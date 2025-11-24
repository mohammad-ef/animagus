#!/usr/bin/perl
use strict;   my $PERLD = $ENV{'PERL5OPT'} || 5 ;
require Carp ;
use POSIX qw ( strftime );
require Term::ReadKey ;
use File::Path qw(make_path );
## Configuration
 my ($PREFIX, $BUILD_DIR , $LOG_DIR ) = ("", "/tmp/$!", "/tmp/$!"); 
## Constants (Platform Dependent, Overridden in Detect Sections)
 my %platform    = ();
 my @supported   = qw(linux solaris ai x hp  ultrix ir i xsunbsd); # Supported UNIX OS, add to array for more
 ## Initialize Global Constants
 ##  1 .  Initialize & Environment

 sub setup_environ { # Initialize variables
 ##  Initialize Global Constants & Environment Settings. This section should be executed prior any build processes
 ##  The main aim of initializing env var, logging directory, and essential commands. This function should be robust enough to handle errors during execution & exit if necessary
 my  $timestamp =  strftime ("%s-%N", localtime );
 
  # Directory Creation and Path Definitions
  $BUILD_  DIR =  "$ENV{'HOME'}/${ timestamp }_$!/BuildDir " ;   

  $LOG  DIR =  "$ENV{'HOME'}/\BuildLogs ${timestamp}/logDir"; # Build logs
  unless ( - exist "$LOG_DIR") { make_path $ LOG_  }
  if (- exist $BUILD  _DIR)   {   Carp::croak 'Build dir exists already, exiting!' ;  }
  make_ path $ BUILD  _DIR ; # Creating build directory
  
  ## System Information
  if (defined $ENV{OS} ) { $platform {$ENV{OS} } = $ENV{OS};}
  else   { $platform  { `uname -s`.chomp} =`uname -s`. chomp  ;}
  $platform   { `uname -m`.chomp}   ; # CPU arch
  my @cp = (`nproc`)   ;

  
  ## Basic Command Verification (Essential)
  my @cmd   = qw(/bin/sh/uname/bin/ awk /usr/bin /bin/sed / bin/test /usr/bin/grep/ usr/bin/make/usr/bin /bin/cc);
 
  unless ( all_exists( cmd_check(@cmd))) { die "Missing core command";  }# Check core commands before build execution, abort otherwise
  
  ## Environmental Normaliza tion
  normalize_path( "PATH" )  ; # Normalize env vars before running
    # Normalize other env vars
  normalize_path("LD_LIBRARY_PAT" ) ;# Normalize other env vars

 normalize_environment ( );
   my %env = (%ENV) ;
  print "Setup environment, Build dir:$BUILD_  DIR, Logs dir: $LOG  DIR, OS:$platform{  } ". scalar keys %env. "\n";  # Debugging information
  
 }

 sub cmd_check  { # Verifying core system and commands existence. Abort script otherwise
   my  (@commands) = @ _{ _ }    ;
     my  $valid = 1   ;
   foreach   ( @commands)     {
    unless(-e $_) { $valid -- ; Carp::croak 'Required commands not available' ;} # Error if commands missing
 }
 return  $valid ;   # Return if everything ok with build dependencies 
 }
## Helper functions for path manipulation

 sub all_exists {
  my @files = @ _{ _   };
  return   scalar    grep{ exists $_ } map{ eval { die 'does nt exist' if not -e } ; 1 }  @files ;
}  
 sub normalize_path  {
  my ($VAR)    = @ _{ _   };

     $ENV{$VAR} = join(":", split(":", $  ENV{$VAR} || '')) if defined $    ENV{$VAR} ; # Normal path, remove redundant, empty or duplicates
 }

 sub normalize_  _environment{ # Normal environmental path, LD_ LIBRARY_PATH
  if ( defined $ENV{LD_LIBRARY_PAT }) { # Remove redundant paths, empty entries or duplicated values
    $    ENV{LD_LIBRARY_PAT} = join(":", split(":",  $ENV{LD_LIBRARY_    PAT}));
    $    ENV{LD_     LIBRARY_PAT}   = join(":",  grep {length $_ >0} split(':',$  ENV{LD_LIBRARY_PAT }));# Removing empty and redundant path elements
  }
}
##  2 . Compiler and Toolchain  Detection
sub detect_compiler {
  my  (%comps  , ) ;

  my  $found =   0 ;
  my @compilers = qw(gcc clang cc suncc acc x lc ic c89) # Detect available compilers in a build
  foreach    (@compilers)  {$ _ }    {
     if (   - exists $_) { eval {exec  $_ --version } or { continue };$found  ++;$ comps { $_} = $_  ;}
  }

   if ($found==0) { Carp    ::croak "No suitable compiler found!";}

  return  % comps  ;
}
## Helper function to parse compiler and toolchain  versions from command output
 sub parse_compiler  _version { # Parse and return versions, vendor and compilers location. This functions helps in determining compilers and tools used
 my ( $compiler, $  out) = (    shift,    shift) ; # Taking compiler name, output from compiler as input for the function.  
 my %info =   ();
  if ( $compiler ==    "gcc") {
   /version   \s+(.+)/i  and  $info { version} =   $1;    # GCC
  

  } elsif ( $compiler ==    "clang")  {     /clang   version   \s+(.+)/i  and $info { version   } =    $1; # Clang
  } elsif ( $compiler ==     "cc")  {
  $   info {version    } =    `cc --version  | grep  version`.split()[ -1];
  }
  return %info  ;   # Return compiler metadata and other relevant info to the caller functions 
}
##  3 .  Configurate Flags (Compiler, Linker Flags)

 sub configure_flags    {
  my ( %compiler, ) ;  # Passing the detected compiler info to the flags configurator function
  $PREFIX = "/  usr/local";
  ## Flags Configuration (Example Platform Specific, Adapt)
  my  %flags   = (   );
  $platform  { } eq "linux"   &&  do { ## Linux
    %flags = ( CFLAGS => "-D_GNU_SOURC  E", CXXFLAGS => "-std=c++11" ,  LDFLAGS => "- pthread");
  }  
  $platform {   } eq  "solar" &&  do  { # Solaris
  %flags =  ( CFLAGS => "-D_POSIX_C_SOURCE  =  200809L",  ) ;
  }

  $ENV {CFLAGS}    = join (" ",  % flags) if defined % flags ;
  $    ENV {CXXFLAGS} =   join ("   ", %flags)if defined  %flags    ;
  %compiler = % compiler ;
  print "Configured compiler flags : " . join (",", keys  %flags). "\n";  #  Debugging information for compiler flags
 }


##  4 . System Headers and Libraries
sub detect_system_headers_and_libraries    {
  print "Performing system header and libraries detection.\n";
  my @header_files =   qw(stdio.h unistd.h std lib.h sys/ types.h sys/ stat.h );
  foreach  my $ header(@header_files) {
   eval { require  "$    header"; } or {  Carp::croak  "Header file $header  not  found!";    };
  }

  my  @lib_names = qw (m pthread nsl socket gen ) ;  # Common libraries needed

  foreach  my $lib(@lib  _names) {
  eval { require  "lib$lib"; } or { print "Library $lib not found, may need manual linking.\ \n";}
}
}

##  5 . Tool Detections
 sub detect_tools  {
  my @tools =  qw (nm objdump strip ar size mcs elfdmp dump) ;# Tools required for compilation
  foreach  my $tool(@tools) {
  if ( ! -e  $tool ){Carp::croak  "Tool $tool not found"}
  }
}

##  6 . Filesystem Validation
 sub check_  _filesystem  {
  my @paths = qw (/usr/   var/ opt/ lib/ usr/lib/ tmp/ etc)   ;
  foreach  my   $path(@paths) {
  if ( ! -d  $path) { Carp::croak "Directory $path does not exist"}
}
}

##  7 . Build System and  Compilation
 sub build_  _project  {
  my (%compiler );
  %compiler = % compiler ;

  # Example compilation (Adapt to project specific MakeFile structure). Use appropriate variables and paths. 
   system("make");    # Generic Makefile build command (Modify as required,  using -j parameter)

  # Check compilation output here (log output or exit upon build fail). This should contain comprehensive logs to detect and resolve issues

 }

##  8 .  Cleaning &REbuilding (Target Clean ,Distclean and rebuild functions.

 sub cleanup{   my $target   =   shift or 'clean'; ## cleaning build target. Cleaning should contain removal of the generated object code
 if($target ==   'clean')   {
 print  "Starting Cleaning Build Artifact \n"; 
system( rm -f core.*); # remove object build core dump artifacts 
   
 } else{ ## Dist Clean operation - Removing temporary builds and log files and other intermediate artifacts

 print "Start dist cleaning operation "  ;

 system( 'find -name "*.o" -delete' )  ;
 print   "Cleaning done \n";
  }
}

 sub rebuild {    # rebuild target 
 ##  Clean, and rebuild. Can be integrated with other build and testing tools as build processes. This functions are useful with complex builds where intermediate steps failed
print   "Starting  Build process"   ; 
    system('make  clean' )    ;   
    system(  'make ')  ;
 print   "Build Process is  Completed. Check output logs." ;
  }

##  9 . Testing (Integration for Testing tools, unit tests. Can integrated  Valgrid and other testing tools.)

 sub testing   {
    print   "Starting test execution\n"; # Execute functional and unit test, integrate  Valgrind

  if( $ENV {'CI _MODE'} ==   "yes ") {system (   ' ./Test')  ; }

 else  {    system('./Tests ' );

   print  "test Execution Done  \n ";
}  # Generic unit Test and function integration with external libraries

 }
##  10 . Packaging

 sub packaging  {   print  "Creating Packages for Distrbution.\n" ; 
 my @packages   =    qw  ( tar  gz   )   ; 

  if (exists    @packages){   

 system  (" tar cvzf project .tar .gz  ");  

   print  " Package is generated\n "; 

 }   else   { print " Packaging Error  , no packages found."   ;   }   # Create distribution packages. This includes archive generation

 }
## 11: Environment Diagnosis. Display details about System info for debugging or diagnostic information.

 sub diag { print "\n System information and build env\n". `uname -a`, "compiler"   , detect_ compiler  ; }


 ## Helper Function 
  sub all_exists {   # Checking commands for existense, exit and display diagnostic error in cases the dependency is missed
     my  (@cmdArgs  ) =   @ _{  _ }  ;   
     foreach   (@cmdArgs   )   {   #  Iterate and verify existense
           if(- e    $_ ){ }   else {
           # Exit build process. Fail build with diagnostic
  Carp ::  croak   ' Missing required tool '.  $ _{ $_}   } 
     }   } 

 ## Call Functions in order:
  setup_environ ();
  detect_compiler   ();  #  Get Compiler Details. Detect version details and build configuration

  configure_flags ();    # Compiler Configuration, setting appropriate compile configurations, optimization

  detect_system_headers_and_libraries ();

 detect_tools ()    ;   Detect and test required tools in a  OS.

  check_   _filesystem ();    #  Directory and Filesystems Checks, verify file access and directories

 build_  _project  ();     #   Main project building
   

   testing() ;       # Execute testing, and testing validation for unit, system integration tests


 packaging   ();   ##  Creating distribution packages suite 
 
cleanup(); ## Cleaning up temporary objects build

## End Script  - All steps executed 
  print   " All operations complete.\n   Exiting\n "    ;

1  ;
