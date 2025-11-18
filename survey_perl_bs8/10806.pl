#!/usr/bin/perl
use strict;use diagnostics;   # For improved debugging.  Equivalent to warnings and stricter code style checks if diagnostics is installed.
use Term::ANSIColor; # For coloured outputs, if installed - otherwise fall backs to plain text
use File::Basename;
 use File::Find;
 use Term::Readline; # Requires installation via cpan - but makes interactive menus MUCH easier - alternative C curses if this not possible
 use POSIX  qw(settimeofday strftime);

################### Configuration ###################
BEGIN {
  my $perl_location = File::Basename::dirname (__FILE__);
   unshift @INC, "$perl_location";
 }
################### Globals ########################
 my $PREFIX = "/usr/local"; # Default prefix
  my $BUILD   = "/tmp/build";
 my $LOGDIR  = "$BUILD/logs"; my $TMPDIR = "$BUILD/tmp";

sub init_environment {
  print $COLOR['bold green'], "Initializing environment...\n",$COLOR ['reset'];
 my $os   = `uname`; chomp ($os);
  print "OS: $os\n ";
 if ($os =~ /IRIX/) {$PREFIX = "/opt/$ENV{SYSTEM}/"; # IRIX default prefix}
 elsif ($os =~ /HP-UX/) { $PREFIX = "/opt/$ENV{SYSTEM}/";}
 elsif ($os =~ /ULTRIX/) { $PREFIX = "/usr/local";}
 elsif ($ os =~ /SunOS/) { $PREFIX = "/opt/SUNW/bin";}
 elsif ($os =~ /AIX/) { $PREFIX =  "$ENV{HOME}/local";}
 elsif ($os =~ /Darwin/) { $os = 'macOS'}

  my @essential = qw( uname  awk  sed  grep  make  cc   ld  ars );
 my %found;

  foreach my    $cmd (@essential) {
   if (-x  $cmd)    {$found{$cmd}=1; }
   }  
 if( !scalar keys %found == @essential){
     die "Missing critical utility  ($cmd).";
  }
 my @path  = split( ":", $ENV{PATH} );  
 @path    =  sort {   $a   cmp $b  }   @path;  
 my    $clean_path  =  join(": ", grep  {-x    $_  }    @path);  

 print  "PATH =   $clean_path\n";  

    # Clean environment vars. Prevents build conflicts from external dependencies
 my     $ENV{'CFLAGS'}       =              "";  
 my  $ENV{'CXXFLAGS'}    =    "";  
 my  $ENV{'LDFLAGS'}   =  "";   
 my  $ENV{'CPPFLAGS'}      =          "";    

   if( ! -d $LOGDIR)   {   mkdir ($LOGDIR);   }   
    if( ! -d $TMPDIR)    {  mkdir  ($TMPDIR);}

 my   $cores     =  1 ; 
   open  my   $cores_fh , "-|", "nproc";    
      chomp   $cores     =   <  $cores_fh>; 
 if   ($cores ==  0){ $cores= 1; } 
      print "Detected Core count: $cores.\n";

 }

sub detect_compiler {
 my %compilers;
 my @possible_compilers = qw(gcc clang cc suncc acc xlc icc c89);

 foreach my $compiler (@possible_compilers) {
   if (-x $compiler) {
     my $version = `$compiler --version 2>&1`;
     chomp $version;
     $compilers{$compiler} = { version => $version, path => $compiler };
   }
 }

 if (scalar keys %compilers == 0) {
  die "No usable compiler found.";
 }

 print $COLOR['bold yellow'], "Detected Compilers:\n",$COLOR['reset'];
 foreach my $compiler (keys %compilers) {
   print "  $compiler: " . $compilers{$compiler}->{version} . "\n";
 }

 return \%compilers;
}
 sub configure_flags {
 my  ($compiler, $platform )   = @_; 
  my  $CFLAGS  =    "";   
 my $CXXFLAGS  =     "";    
 my  $LDFLAGS = "";  
 if ($platform =~ /IRIX/)   {    $CFLAGS =  "-D_IRIX";   }  
 elsif  ($platform =~ /HP-UX/)}{    $CFLAGS  =  "-D_HP_UX";  } 
  
 if ($compiler eq "gcc") {  $CFLAGS  .=  "-O2 -Wall";    $CXXFLAGS .="  -std=c++11";    }  
 elsif($compiler eq  "clang"){ $CFLAGS  .= "-O3 -std=c11";}
 
 return($CFLAGS,$CXXFLAGS, $LDFLAGS) ; 
 } 

sub detect_libraries {
    my $headers = ["unistd.h", "sys/stat.h", "sys/mman.h", "stdlib.h", "stdio.h"];
  
 my @found_headers = ();

  foreach my $header (@$headers) {
  
   my $test_file = "$TMPDIR/test_$header";
     open my $fh, ">", $test_file or die "Can't open $test_file: $!";
     print $fh "#include \"$header\"\nint main(){return 0;}\n";
    close $fh;
      
    my $compile_result =  `cc -c -o $TMPDIR/test_$header.o $test_file 2>&1`;
    
    if ($? == 0) {
        push @found_headers, $header;
    } else {
      print "Warning:  $header  not found during test."; 
      
  }

}
    
   print  "Header File Found  ";  foreach    my    $file (@found_headers)     {    print     "\"$file\"\n";}

   return (@found_headers);
}


sub build_project {
    my ($makefile, $target) = @_;

    print $COLOR['bold cyan'], "Building project: $makefile target: $target\n",$COLOR['reset'];
 my $make_cmd  =    "make ";   

if   (defined($ENV{JOBS}) and   $ENV{JOBS}>  0 ) {$make_cmd.  =  " -j $ENV{JOBS} "} else {$make_cmd  .=   " -j $ENV{Cores};";} 
 if  ($ENV{TARGET}){   $make_cmd   .= " TARGET =  $ENV{TARGET}" } 
 
 $make_cmd.   =    " $target" ;
    my $result      =    system  ($make_cmd);

   if ($result) {    
 print     "Build FAILED.\n";     exit    1;   } 

  print $COLOR['bold green'],  "Build Successful\n",$COLOR['reset'];
 } 

sub install_project {
   my (@files_to_install) = @_; 

  print  $COLOR ['bold cyan'],"Install Target" ; foreach      my  $f (  @files_to_install  ){   print       "$f, ";      }   print  "\n";

 foreach     my      $f  (  @files_to_install)     {

   if      (-f     "$f")      {
  my    $dest  =       $PREFIX ;

if ($dest!=$f){
 system    ("cp     \"$f\"      \"$dest\" "  )    or  die      "Can not  move    '$f';    check     destination"   ;     }   
}      else {
  print       "Error   can't   move  : "  .   $f ."\n";   
   }   
   
} 
 }


######################
###  Diagnostic   #
######################

sub diagnose_system {
  print $COLOR['bold blue'], "System Diagnostics:\n",$COLOR['reset'];
    my $uname = `uname -a`; chomp $uname;
   print "uname: $uname\n";

 print "COMPILER\n";   foreach   my     $k (   keys     detect_compiler ){    print    "  Compiler:" .$k.  "\n";       }    

print "\nPATH:\n"; 
     my  @path   =     split ":", $ENV{PATH};   foreach  my   $element (@path )    {
      print "     PATH :    $element   \n" ;
}


 print "System Variables :\n";      print "   CFLAG   :"   . $ENV{CFLAGS}.  "\n"; 

   exit  0;

}


##########Main###########
my   $CI   = 0 ; 

    if($ARGV[0]   eq "   --ci--mode   "){ 
         $CI   = 1  ;
         shift    @ARGV; 
        }

   init_environment;
 if ($CI   ) {print    " Running     CI     Mode\n"}

 my $compiler = detect_compiler();  

 my   ($CFLAGS,$CXXFLAGS,$LDFLAGS)=configure_flags  ($compiler->{'gcc'},"Generic") ;    

my    $libs   = detect_libraries(\@{}     );

   build_project(   "Makefile","all");  
     install_project( "$PREFIX/bin/testapp" ,  "$PREFIX/include/header.h");   
if    ($CI  ) {   print  "Build      successfull";   exit(  0);}     

   print  "\nBuild       successful."   .  "\n"; 

 exit    0 ;

__END__

