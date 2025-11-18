#!/usr/bin/perl
use strict;    use diagnostics; use warnings;

use Carp qw(confess); #For error output with location in the file
use Term::Read qw(ReadModeInitReadKey) qw(ReadKey);
use Term:: ANSIColor if(-M Term::ANSColor);
use List::Util qw(first);

my ($script = "build_script.pl");
my %options = ();  #For interactive menu. Will hold user choices. This should be moved to a separate config file. 

#---1. Initialization and Configuration---

# OS, Architectures, CPUs (Basic system discovery - enhance as necessary) and essential binaries. Also creates needed directories and normalizes paths.
{ my %os_info = detect_os ();
  print "System Information (OS: ".$os_info{os}."\n Architecture ".$os_info{arch}.". CPU Core Count ".detect_cpu_count().", Mem ".detect_mem().")"; 
  check_binary_exists( "uname", "Checking for uname");     #Essential binaries and required tools
     check_binary_existing(  qw( grep sed awk make), 1);    

  $^O  ||= 'linux';   #Default if OS can't be reliably discovered
   

  my $tmpdir    = "/tmp/" . $script . "_build";
  my $logdir    = "/tmp/" . "${script}" . "_log";
  mk_dir($tmp dir)   || die "mkdir ${ tmpdir}: $!"; #Error handling.
  mk_dir($logdir) ||die" mkdir $logdir: $!";

  unshift @{ $ENV{ 'PATH' } }, $tmpdir;
  putenv('PATH=' . join(Path::Separator, @ {$ENV{'PATH'}}));
  
}

#---2. Compiler Detection--- #This is a basic version
{ 
  # This is simplified - a production compiler finder is much more complicated and will parse /etc/os- release, /etc/sysconfig files, or consult other config to determine the best possible compiler.  
  if (exists $ENV{CC} ) {print "CC set to ".$ ENV{CC}.\n";} #Check if a compiler is manually defined
    elsif (which("gcc"))  {my $ver = run_command ( "gcc --version"); $ENV{CC}    = "gcc ".$ver; }
    elsif (which("clang")) {my     &  ;
  

}

#---Helper Function---
 sub mk_dir {my ($dir) = @_; return mkdir($dir,0 ) || print "ERROR mkdir $dir\n";}
 sub putenv { $_ = shift; print "ENV: $_"; }#Debugging putenv calls
 sub runcommand { my ($cmd) = @_);
  open ( my $fh, "-|",$cmd) or die "ERROR $! running $ cmd"; #Execute shell command and capture output for debugging purposes. 
  local $/ = undef;  $ cmd = <$fh>; #Grab the complete shell command output in a string, not an array. Note that this does not handle error codes, but could. 



}



#---3. Compiler Flags---
{ 
  my %flags  = detect_platform_defaults();
   $ENV{CFLAGS} = join(" ", @ {$flags{cflags}});
   $ENV{CXXFLAGS} = join(" ", @ { $flags { cxx flags}})
   $ENV    { LDFLAGS } = join( " ", @ { $flags{ldflags}});
   
   if ( Term::ANSIColor ) {print ANSI("green","Compiler Flags: " . join(", ", map {$_} split ( " " , $ENV {CFLAGS} ))."\ n");}#Display compiler flags in color if the Term:: ANSIColor module is loaded and installed.
} #End Compiler Flags

#---4. System Head and Library---
{
  #Placeholder for detailed detection. Implement with compiler test and include paths. 
  
}

#---5. Utility Tools---
 {
     # Placeholder to find essential binaries and substitute alternatives
 }
 #---6. File System and Directory Checks---
 sub chkdir {
  my ( $dir ) = @_;
  print "Directory exists and is writeable : " . check_dir($dir) . "\n";  #Simple directory check
 }
 sub checkdirectory {  #Simple file existence check and permission validation
  my ($ path ) = @_;
  return unless (-d $path) ;
   return   unless (- x $path);
    return "$ path  found, writeable, and executable";
 }

 sub checkbinary {
  my ($ path ) = @_;
  return  unless  -x $path ;
 }
#---7 Build System and Compile--- #This is simplified, it does not implement a true build. This section would call Makefile, CMake, Meson, or a similar generator.  
sub compile {
  my (% args ) = @_;
  print "Building: " .  $ args { project }    . "\n"; #Simple placeholder
     # Implement actual build process (Makefile, autotools, CMake, etc., with detailed logging).  
     runcommand ( "make "     . join ( " " , @ { $  ;
}

#8. Cleaning and Rebuilding ---
#---9 Testing and Validation ---
#Placeholder, implement actual test runner and report generation
sub test { 
  #Implement automated unit & functional tests and generate summaries. 
  #Integrate testing framework (e.g. Test::Simple, Catch2)
}

   #---10 Package and Deploy---
 sub package {  
  print   "Packaging project for deployment\n";      #Implement a more robust packaging system with checksums, metadata & archive creation
 }
# 11 Diagnostics and Environment
 sub print_env_details { 
  print "System Environment Details:\n";
   foreach my  $ key ( sort keys % ENV) {   # Print out the full env. For Debugging Purposes
      print "$KEY = $ENV {$KEY},\n";
 }
  
 } #End Diagnostics

    #12 Continuous Intergration
 sub ci_mode {  return defined $  ;    #Simple indicator that this is a CI environment.
 }
  #---13 Security
sub chk_security_settings   {
  #Implement security checks for environment variables, writable directories, and PATH safety
}

#--- Interactive Interface---
sub interactive_menu   {
 my @ menu_options= (
 { name => "Configure" , action  => "configuration"     },
 { name => "Build" ,       action   => "building"    },
 {name => "Test",  action    => " testing"},
 {name => "Package", action  => "packing"},
  {name =>" Diagnostics", action  => "diagnostics"},
  );

 print "Select operation (1-" . scalar(@menu_options)  . ")" . "\n";  #Interactive menu. This should be expanded using Curses for a real TUI
   map { print "$ _  { $. {name}}" } @menu_options; #Display the available options
 while(1){
 print "Enter option number: ";
   my $input = <STDIN>;
   chomp($input);
  if ( $input >= 1  &&  $input <=  );
   my $selected_menu_item = $ menu_options[$input - 1];
    return $ selected _menu  _item-> {action} ;
 } #end while
}

#--- Helper Functions---

sub detect_os {
  my %info ;
    my $os = uname -s ;
    if ( $os eq "Darwin" ) {$info {os} = "mac os"; $info { arch} = uname -m; }
    elsif ($os eq "Linux" )   {  $info      {os} = "Linux";  $ info{arch}  = uname -m ;}
    elsif ( $os eq "SunOS"    ) { $ info { OS } = "Solaris"; $info{ Arch}   =    "x86  ";  }

    # Add other OS detection cases
    return % info;
}

sub detect_cpu_count {
  my $cmd = "nproc";
  my $output = run_command ( "$cmd");
   return  ( $ output =~ /\d+/ )   + 0;    #Return number as an int;
}

sub detect_memory    {
  #Implement a memory detection routine (e.g. using `sysctl -n hw.mem size` or `free -m`)
 my ($total) = runcommand("free -m | awk '/ Mem:/ {print $2}'");
 return $total;
}


sub check_binary_existing {  # Checks for a list of binaries.
  my (@binary_names) = @ _;
    my $all_exists = 1;
   for my $ binary (@binary_ names) {
    unless ( checkbinary ( $binary) ){ 
          print  " ERROR! $ binary command does not exits or not available in system  path";
       #$ _ -> die $!  #This stops build process; 
    #exit $ _ ;   
       all_exists = 0; #Mark all exists.
 }   
    }  #end loop

   # If all exists continue, or error out, if something not exits;
  #   unless  ($_==   )  ;
 if   all  exists   print  'Essential build tools exists'   .     
;

  

 }#

sub check_dir   { 
      # Check to make directory available. Check writeable access
      die   unless open my$ fd,"<:r",$_;
}



### Main Program ---

 my$ option_ selected     menu     ; 
 while   ($ options{ run })
 { option selected       $option
 print   
    
  

 print "  $script   exiting.\n"     
 ;exit
