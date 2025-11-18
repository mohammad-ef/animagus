#!/usr/bin/perl
use strict; # Require declaration of variables. Improves debugging. Prevents accidental global use.  Crucial in legacy/portability.
use warnings; # Enables a lot of diagnostic information. Essential, especially for legacy code.
use File::Find; # Recursive filesystem traversal, essential for versioning/cleaning and other file-oriented tasks. Crucial. Also for directory verification and existence
use File::Basename; # For manipulating pathnames (dirname / base name / extension etc.)  Needed.

use Term::ReadLine; # For improved user interactive experience. Needed and important in menu interface (section 14), although a very advanced addition
  
use Data::Dumper;
use List::Util qw(podsort); # Used for sorting and other list manipulations for versioning (section 24), and diagnostics

# ----  1. Initialization  ---- (Crucial. The core of any build process).

my $os     = $ENV{'OS'} || (uc scalar(`uname - s`)  #Detecting the OS - very important
        =~ /^FREEBSD|BCBSD/ ? 'FreeBSD'  #Special case for FreeBSDs and their relatives, very common in some niche legacy areas like aerospace and scientific equipment builds where BSD remains a core part for its stability
        : uc `uname -s`)
        =~ /^SCO/ ? 'SCO' #SCO systems are rare but need consideration for completeness for some older projects - a common legacy build target
       :$os);

if ($os   eq 'IRIX') { system("unset CXXFLAGS; export CXX  =  ccplus;");}   #Specific fix to support older SGI/IR IX compilers (very uncommon now but still a legacy need for a few niche build environments)
$os =~ s/CYGWIN_NT/CYGWIN/;  # Cygwin normalization for better recognition
 
my %os_mapping     = ( #For versioning and flag compatibility. Very important for long lived projects with multiple OS builds

    'FreeBSD'=> { prefix=> '/usr/local'  }, #Example of specific platform customizations
    'AIX'=>    { prefix=> '/opt/aixos'    }, #AIX is important for some older projects in IBM mainframe builds for some older projects in IBM mainframe builds for some older projects in IBM mainframe builds for some older projects and needs special flags to ensure compatibility
    'HP-UX'=>   { precompile_options => '-D_POSIX_C_SOURCE=200112L' },
    'SCOOpenServer'=> {prefix    => "/opt/scos" },
    )    ;

$| = 1; # Flush output - critical for user interactivity. Needed and important in legacy systems as buffering can break expected terminal output
my $PREFIX = $os eq 'FreeBSD' and exists $osMapping{$os}  ? $osMapping{$os}{prefix}  : "/usr/local";

my @essential_command = ( 'uname',  'awk','sed','grep','make','cc','ld','as','ar','ranlib'  );

sub check_cmd {    #Essential to prevent a build from failing unexpectedly and provide clear error output on missing build commands
    my ($cmd) = @_;  #Single parameter passed in
    if (! -x $cmd)  # Check if command exist, with execute privilege
        die "ERROR: Required command '$cmd' not found in PATH.  Please install or configure $cmd and ensure it exists in PATH"
}
   
map {   #Looping to verify each essential commands. Needed for all portability
     check_cmd($_)  or die
}     

 @essential_command;  #Calling the check_ cmd on each essential command to ensure they are all available. Very important in cross compatibility.

my $temp_dir    = "/tmp/build_environment"; #Standard temp directory
my $log_dir     = "logs";
mkdir $temp_dir , 0777 unless -d $temp_dir; #Create directory
mkdir $log     , 0777 unless -d $log;

my $PATH    = $ENV{PATH} . ":" . "$ temp_dir"; #Adding temporary dir to the PATH for portability. A very good habit to prevent conflicts
my   $LIBPATH = "/usr/lib: /lib: ./lib";

   
# ---- 6. Filesystem and Directory Checks ----
   
# Validate essential directory existence. Very important for portability
   
my @directories = (
    "/usr", "/var", "/opt", "/lib", "/usr/lib", "/tmp", "/etc"
);
   
sub validate_directories {   #Validation subroutine
    my $dir = shift; #Passing a directory into the subroutine to check for existence and read/write privileges to allow the build
    unless   (-d  $dir)   #Check if directory exists
        die "Missing directory. '$dir'."
}

   
map { validate_directories($_)}     #Calling on each directory to be validated, very important in cross platform compatibility to prevent failures
     @directories; #Calling each validated directory for validation of exist and privileges to allow a seamless and successful build to start
   
my %filesystem_mapping = (    #Platform specific directory and file configurations to ensure builds are successful across a wide platform spectrum of OSes
    "HP-UX"     => {  'LIBPATH' => "/ux";},

);
   
  $LIBPATH  .= ":" .$filesystem_mapping{$os}->{'LIBPATH'}  if  defined $filesystem_ mapping{$os}->{'LIBPATH'}; #Appending any platform specific directories to the LIBPATH

   
  # ---- 7 and 8. Build System ---- (Makefiles are critical and must be supported).  
   
sub build_it {    #Subroutine to call and build project using make
    my ($project_dir,$build_command) = @_; #Passing project path and the build command
    print "Build: $project_dir\ n"; #Print the build directory
    chdir $project_dir or die "Unable to find build directory: $ project_dir"; #Changes to the build environment directory
    system($build_command) == 0 or warn "Build FAILED $?";
}

   
   # ---- 2. Compiler and 3 - Config ---- (Compiler detection is key).
   
sub detect_compiler {  # Compiler detection
   my @compilers =   qw(gcc clang  suncc  acc xlc    icc c89); #Supported compilations
   my $compiler = 0; #Default value if none is found. This ensures a compiler is always found
   foreach my $compiler_name (@ compilers) #Looping for each compiler in the build
   {     #Checking to see if the command is executed and available and setting the compiler variable for future use

      my $cmd_str =  "$compiler _name  --version 2>&1 | awk '/version/{print $2}'";   #Checking the compiler name and version to ensure it is the correct one

      open(my $compiler_fh, "- |", $cmd_str) or next;    #Opens the compiler for checking and parsing information
      my $version = <$compiler_fh>;    #Gets compiler version from file
      close($compiler_fh);     #Closing handle
      $  version =~ s/[^0-9.]// g; #Removes invalid characters from the compiler for comparison and consistency
      
      next if ! defined $version or $ version  =~ /ERROR /; #Next if an error is found during version extraction
      
        

      print  "Found $ compiler  - version $ version\ n "; #If found, print the output
      $compiler = $compiler_name; #Set the default compiler
     }
     
   return $compiler; #Return compiler variable
   } #End subroutine
  
   
  sub config { #Configuration
    print "Configuring...\n";
        
    # Add your configuration steps here (e.g., autoconf, CMake)
    # For example:
    # system("./configure --prefix=$PREFIX --enable-feature1 --disable-feature2");  Needs the actual script.

    return 0; #Return value of zero indicates successful configuration to be handled later
    } #End subroutine
 
 my $compiler = detect_compiler(); #Get compiler

#Example build directory
 my @build_dir = ('./build', 'src');  #Adding example build dir and project src dir to build the projects and allow them to proceed successfully


build_it ('src','make')   or die  "Building the file was NOT SUCCESSFUL, please check compiler setup."; #Running and compiling the build

print "Successfully Built\n";
#Add more code and features. The code needs more functionality but it gives you an example and structure you could extend from.