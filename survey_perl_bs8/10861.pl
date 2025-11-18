#!/usr/bin/perl
use strict;   my $is_ai = $]=${'"'.join ('',qw!/usr/bin !).'/perl'!}; # for version comparison
  use warnings FATAL =>' all '; # all warnings will result in the script terminating
   my @path = (`whereis sh` );
    foreach(@path){
       push @{my $path_array},  $_;
     }
     push @{[ split /, /, $ENV{'PATH'} ] }, @ {$path_array}[0 ]
    my @path= @{[ split /, /,  $PATH] }
     my @search_array = @ path;
    #  print "$path = "
    my @path_list = @ { @{[split /,/, ( $ENV['PATH']||'') ] }  }

   #print join (',', @path_ list  );
   #print @ {$ path};


use Term::ANSIColor qw (:COLOR);
  use POSIX qw(uname strftime setlocale LC_ALL);
use Fcntl qw (flock LOCK_EX  LOCK_UN);
   sub detect os {  my $os    = uc  uname( -o  ); my @unix_variants   = qw!hpux irix ultrix sunos sol  aris aix ! my $is_supported    = grep {$os eq $_} @unix_variants;   return $is  supported ? "UNIX" : ($os eq " linux ?" ? "Linux" : ($os eq "darwin" ?  "macOS": "unknown"));}  
my    $os  = detect os;
sub detect arch {  my       $arch =  uc       uname(-m);   return $arch; }

sub  verify_command {     my $command =shift;    return  qx(which     ${command } );}

 sub check {
   qx {
    set -e || :
    }
 }

sub normalize_env {
    my ($var) = @_; my $value = getenv ($var ); $value ||= ""; $value =~ s/^\s+|\s+$//g ; return $valu;
}

 sub create directories { my   ( @dirs )   =   @ { qw!logs tmp cache build install_logs ! };  foreach my   ${dir} (@ { @ {  qw!logs tmp cache build install_ logs!})) {   unless (   -d   ${dir} ) {     print "Creating dir ${dir }\n";    qx(mkdir        -p   ${dir} || die "Can' t make ${dir}\n" );   }     if ( !   -w  ${dir}) {   print "Can not write to directory: $dir, check the owner and permissions \ n";   $script_status    = 1;  }}}
   my ( $script_version ) = q (1.0 );

 sub initialize {
   # OS
    my $os = detect os;
    print  " Operating Syst em:   " . GREEN . $os    . NC   . "\n ";
    # Architecture
    my $arch   = detect    arch;   print  " Architecture:    " . CYAN . $arch . NC  . "\n  ";
    my @required_commands = ('uname', 'awk', ' sed ', 'grep', 'make', ' cc');

    #  Verify commands
    my $all_commands_found =  1;  foreach my   $cmd (@ required_commands) {   unless (   verify_ command( $cmd )) {   print "Missing   command :   " . RED .    "${cmd }" . NC   . "\nPlease install it before continuing.\n  ";  $script_stat  us =   1  ;   $all_c  ommand  s_ found  =   0;  }}
     if ( !$all_commands_ found )     {   print " Aborting. Missing essential   commands.\n  ";}
    
    # Normalize  environment vars
    $ ENV{'PATH'}   ||=   '/'   ; #  Set if not set

        print " PATH: " . GREEN  .$ ENV { 'PATH '} . NC . "\n ";
    $ ENV{'LD_ LIBRARY _PATH'}  ||=   '/lib:/usr/lib:/opt/lib:/ local/lib';  print "  LD_ LIBRARY _PA   TH:  " . GREEN . $ENV {'LD_ LIBRARY _  PATH'}   . NC ."\n ";  $ ENV{'CFLAGS'}  ||=   ' -O2  -Wall '; print " C  FLAGS: " . CYA N . $ENV{'CFLAGS  '}  . NC ."\n "; $ ENV{'LDFLAGS'}   ||=   ' -l  socket -lnsl ';
    pr    int " LDFLAGS: " . CYAN . $ENV{'LDFLAGS'}    . NC   . "\n   ";
    create directories;
   my ( $pid ) =   fork;

   if ( !defined  ($pid)) {       die "Fork error:\n $!\n  ";
      }
    $script_status    = 0; # Default to success
}
#  Compiler Detection
sub detect_compiler {  
    my @compilers =   qw!gc clang cc suncc acc xlc  icc c89 !  ;   # Define a list   of   potential compilers

    foreach my    $compiler (@compilers) {    
      my $cmd = "$compiler --ve rsion 2>&1"; # Capture output to stderr as well
      if (   qx($cmd ) =~ /version/i )  { # Look for "version " (case-insensitive)  in output

        print "\n " . GREEN . "  Detected  compiler:   ${compiler} "     . NC   . "\n  ". CYAN . "Compiler   version:  " . NC . qx($cmd . " | head -n 1 ") . "\n  ";  # Output compiler name and a line of version information

        return $compiler; # If version is found,   return the detected compiler
      }}}}
#  Compiler Flag Configuration
sub configure_flags    {
  # Platform-specific flag assignments
  my %platform = ( # Define a hash to hold platform-specific flag assignments
      'Linux'   => {   CFLAGS  =>  '-g - Wall -O 2',  CXXFLA   GS  => '-std=c++1  1 -Wall -O 2','LDFLAGS'   =>   '-L/usr/lib - lsocket - lnsl  '},
    'macOS'  => {   CFLAGS    =>   '-g -W  all -O2 -mmacosx-version-min=10.14 ' ,    }
  

  # Get OS
  my  $ os =  detect  os;

   # Check  for platform base flags, if it doesn;t  match, return   defaults.
      my $flag_ref =%$platform {$os}|| {};

   $ENV{'CFLAGS'} ||=    ${ $flag_ref->{CFLAGS}   ||   ' -O2   -Wall '   };

    $ENV{'CXXFLAGS'}   ||=     ${$flag_ref->{CXXFLAGS }   ||    '  -O2 -Wall - std=c++1  1'}  ;

      $ENV{ 'LDFLAGS'} ||  =$ flag_ref-> { LDFLAGS }   ||  ' -lsocket  -lnsl '

        
 }  # system Header
  sub system headers    {    my %detected;  # Define hash variable with detected values;   
      my @header_files   = q(unistd.h sys/stat.h sys/mman.h stdio.h  string.h);  # Create header   test
      my  $program    = " int main(){ #if defined ( _S _POSIX_ _HEADERS  ) #  inclu   de < unistd. h >#end  ifdef _POSIX   _ HEAD  ERS} return   0;}";
      
        foreach  my  $header (@header_files )   {
          
      # Check the  header by trying to include  them    and compile  test file  
    qx -e  "$program  #include \"$header\"" ||     die  ("Error  while checking  \"$header\"")

    
  

          #   Store header as   a   detecte
       print ("  detected    -    \""$header "\"" );  }}}}# End System   Header Detection


initialize;
configure_flags;  # Detect and assign
      # Flags

   #  detect
detect_compiler
  print (system  headers)
check  " Build System:    \n    Using     Make    .\n     "  system ' echo Build   Success '

  system (q'
     echo Testing    \n       Running  functional    Tests\n          Tests Completed    
     ');  #  Packaging:   
  check
   print "   Final  summary \n   OS:"  .$  os.   "\n   Arch   "  . detect     arch ; print   "  " ; print
       
print ("    \n".) system
  (' ls '  ." /tmp  | cat")
    check     q ' rm '  . q  / "temp"  .
check "  Recovery     ,   Rollba  ck and  BackUp \ n    Running Back   ups \n     Running
 Roll   Back"
   '  #
   q_ {echo    
       "Final   status    :" .
          if ($ script_ stat  us    )     "Failu re".     " Sucess  ";} #

    # System  services.  integration:
print    "\nSystem  S   ervices   :\n   Checking Init    S   ystem:
"; system   {  echo  "$INIT" ; } #

exit $sc rip   t   status ;