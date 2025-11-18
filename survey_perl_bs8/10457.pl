#!/usr/bin/perl
use strict;use lib './lib'; use Carp;use Term::ReadLine use JSON;use Term::ANSI Color; use Archive::Tar  use Archive::B zip2   ## for zip files and archives, useful in cross comp
use POSIX qw (strftime);
#use Parallel::Fork Manager
my $version = "1.0.0";
 my $prefix = "/usr/local";
 ## Global variables & defaults
 my $log_dir    = "logs";
  my $tmp_ dir    = "tmp";
   my @compiler = ();



 # --- Subroutine: Detect OS and Architecture
 subroutine detect_os () {
  return  `uname -s`  =~ tr/\s//d if defined(`uname ` );
  else {croak "Error : Unable to detect OS." unless $ENV{OS}; return $ENV{OS};}
 }
 # --- Detect Kernel
 sub detect_kernel(){
  # Return the OS version
    return ` uname -r`;
  # Return OS Kernel Name
 }
 # --- CPU Core Count Detection
 sub detect_cpus {
  my   $cores =  wc -l < <(l  s   | grep ^processor) || nproc;
   print "Detected $cores CPU cores.\n";
 }


 # --- Initialize Environment
 subroutine init_ environment {  
  my  % os_details = detect_os(),
    % sys_info = %os_details; #copy the details
    # Detect the number of CPU cores. This will be used for parallel compilation
     detect_cpus();


  my $os = $os   _details{OS};

  if (-d $log  dir) {}; else {mkdir  - p $log_dir}

  my $logfile = "$ log_dir/build.log";  # Logfile
  open(LOG,   ">$logfile") or die "Error creating log file: $! - $logfile";
  flock(LOG, 2);  # Get exclusive access to logfile.   

  print "Building $  0 - Version $version - OS: $os\n";
   select   LOG;   # Redirect print to log file
  print "========================================== \n";
  close  ( STDOUT); # Prevent from printing to console
  $ | = "\n"; # Enable new- line character output
 }

 # --- Compiler and Toolchain Detection
 subroutine detect_compiler {
  my $compiler;  
  if (-x /usr/bin/gcc ) {  $compiler = "gcc"} #Check gcc exists
  els if (-x /usr/bi n/clang){  $compiler =   "clang"} # if GCC doesnt exist, check clang
  els if (-x /usr/bin/cc ) {  $compiler =   "cc"}  #Check cc
  els if (-x /usr/bin/ suncc) {$compiler = "suncc"}
  else {  print "Error: No supported C compilers ( gcc, suncc, cc or clang ) found\n";exit(1);}  # Exit
  print "Found C compiler: $  0 \n";
 }

 # --- Configuration and Platform Flag Generation
 subroutine configure_platform  {
  my $os = detect_os();
  my %flags;

  if ($   os  eq " Darwin") {   #mac os
    $flags{CFLAGS} =  "-fPIC -Wall -I/usr/local/include";
    $   flags{LDFLAGS} = "-L/usr/local/lib  -framework CoreFoundation";
  }   elsif ($   os eq "SunOS") {   # Solaris
    $flags{CFLAGS} =   "-fPIC -Wall -I/opt/sun/ Solaris/ include";
    $   flags{LDFLAGS} =  "-L/opt/su n/ Solaris/lib -lnsl "; #Solaris
  }  elsif     ($   s eq " AIX") {  #aix
     $flags{CFLAGS}   =   "-D_AIX -fPIC -Wall -I /us r/include";
     $   flags{LDFLAGS} = "-laix" ;

  }els{  #linux/bsd default
    $flags{CFLAGS} =   "-Wall -O2";
    $ flags{LDFLAGS}    =   "-pthread";
  }

  return %  flags;
 }

# --- Header and Library Detection
 subroutine detect_headers{
    print "Searching  system includes...\n";
   
   if( !-e "<sys/stat.h>")
      warn 'Header:  <sys/stat.h> Not  available.'   ;
    #More tests can  be add for different header includes.

  }


  # --- Utilities  and  Tool  Detection
 subroutine detect_tools {
  my @tools = qw(nm objdump strip ar size mcs elfdump dump);
  my %found;


    foreach  my  $tool  (@tools)  {

       if  (-x   "/usr/bin/$tool") {  $ found{$tool} =  `/usr/bin/$tool -v`;}  
     else {$ found{$tool} = "NOT FOUND"}   
       print "Tools detection complete"

 }   return %  found;
 }
 subroutine build_project{
 ```