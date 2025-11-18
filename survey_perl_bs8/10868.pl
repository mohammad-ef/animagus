#!/usr/bin/perl
use strict; 					# Ensures that variable usage requires explicit declaration before assignment
 use warnings;					# Activates runtime warnings, which will alert you of errors that might go unnoticed
  use File::Basename;		# For basename() function to return the filename portion
  use File::Find;			# For searching file tree. Needed to identify installed libs for rollback/restore
   use File::Spec:makepath  ; # Path construction, for more cross platform safety.
   use Term::ReadKey;		     ; 

 # --- Constants ---
  const my $LOG_DIR = "logs";
 

 # --- Initialization and Configuration ---
 my $prefix = "/usr/local";  # System prefix (configurable by argument)
 if (@ARGV && $ARGV[0] =~ m/^[^\/]+\/(.*)/) { #Allow prefix to be set from cmd line. Prevents prefix from starting at root
  my $fullPrefix = $1;
  my $canonicalized = $PREFIX;
  #Canonical path, resolve symlinks, and expand any relative paths, and prevent path traversal vulnerability
  $fullPrefix = $canonicalized =~ s{/}{ }g && eval $fullPrefix; #This resolves the full canonical path

  $ prefix = $1 unless $fullPrefix;

 }  
  
  
 sub initialize {
  print "Performing system checks and configuration...\n";
  my $os = `uname`;
  print "OS: $ os";
  
  #System check to ensure required tools are available
  my @required_bins = qw (uname awk sed grep  make cc nm strip ar size  );
  for my $tool (@required_bins) {
  unless( - x "/${tool}" ) {
  die "Missing command: $tool . Please make sure it installed. Build will exit now.\n";
  }
  }
  
  #Normalize paths, set default if missing. This will be important.  
  
 

  #Create necessary log and output directories: If the log directory is unavailable, make it
   unless (( -d "logs") || (mkdir "logs"  )|| (mkdir $LOG_ DIR )) {
   $@ ; #Print error if mkdir failure occurred and exit
   #die "Could NOT establish logging directory - Exiting.\ndetails: ". $@;
   die "Unable to create '$ LOG_DIR'.  Permissions? Check your path.\n";
   }
 
  print "Log directory initialized: " . dirname( getcwd() ) . "/$ LOG_DIR\n";
 }

 sub detect_os {
 my $os = `uname`;
  $os =~ s/^ *//; #Remove any white spaces from the beginning of the output string to avoid errors
 return lc $os; #return lc for comparison purposes later in the script
 }


 # --- Platform-Aware Configuration ---
 sub configure {
 my %config;
  
 if(detect_os eq "linux") { #Linux specific config
  $config{ cflags } = "-Wall -Wextra -g";
    $config{ lflags } = "-Wl,-O1 -Wl,--sort-common";
 } elsif (detect_os eq "sunos") { #SunOS specific config
  $config{ cflags } = "-xWc++ -fpic";
     $ config{ lflags } = "-default_library=/usr/lib -Wl,-R/ ";
 } else { #Fallback, use some generic flags.  
   $config { cflags } = "-Wextra -Werror -g"; #Good general flags
  
  }

 return %config; #Return our config for future use in build stages/ etc
  }


 # --- Compiler and Toolchain Discovery ---
 sub detect_compiler {
  my @compilers    = qw(gnbcc clang cc suncc acc xlc icc c 89);
  my $compiler = "gcc";  # Set a default if no other compilers are present

  foreach my   $compiler_name (@compilers)  {

  if( - x "/ ${compiler_name}" ) { #Check if we have it.
  $compiler    = $compiler_name;
  last; #If we find a valid option we will end the loop
      }
     }
  
 return $compiler ; #returns string with the compiler name.  
 }

 # --- Header Detection ---
 sub detect_headers {    
  my @needed_headers = qw(unistd.   h sys/ stat.   h sys/ mman.  h);
  my % headers;
  
  for my  $ header_file (@ needed_headers) {
  if ( - e "/usr/include/$ header_file" ) {
  $headers{$header_file}   = "/usr/include/$ header_file";
  }elsif ( - e  "$ (get_include_dir() ) / $ header_file") { #Handle custom include paths
  $headers{$   header_file} = "$ (get include_   dir()) / $ header_file";
  } else { #If we can't find the header
  }

 }

return %   headers;     
 }

 sub get_include_dir { #Get a custom directory that might be available if we can't get them from the defaults.    
  #Check for common alternate include locations
  return "/ usr/local/    include";  
 }

 # --- Build Phase ---
 sub build_project {
  print "Performing build process...\ n";
  system("make all" ); #Basic make invocation
  
 }

 # --- Test Phase --- 
 sub tests {    #Test phase
  print "Starting automated test sequence...\n";
  system(' make test');  #Basic test phase invocation
 }
 # --- Package and Install ---
   sub  package_build {
  print    "Creating archive and preparing build deployment...\n"; #Informational messages to the user
  system ( "make dist");  # Generate archive
  my $ archive_name = "build_ archive.tar.     gz";   #Hard coded name - can be made dynamic.
  
  copy( "  $ archive_ name"  ,$LOG_ DIR); 

 }
 sub install   {
  print "Installing binaries and dependencies to $ prefix... \n";
  system( "make install PREFIX=$    prefix") ; #Install phase
 }
 # --- Utility Functions ---
 sub print_colored    {
  my ( $ message, $ color ) = @ _;
  my $ color_code;

  if( $color   eq "red") {   $color_code = "\e[31m";  }
  elsif( $     color eq " green") { $ color_code = "\e[32m"; }
  elsif( $      color  eq " blue") { $ color_code =     "\e[34m"; }
  else {  # Default
  $  color_ code = "\e[ 0m";  }
  
  print $   color_code . $ message .     "\e[0m" . "\n";
 }

 # --- Main Execution ---
 initialize();
 my    %platform_config = configure();
 print_colored( "Compiler set to: "     . detect_compiler()."\n", " blue");

 build_    project();
 tests(); #Invoke tests
 package_    build();
 install(); #Invoke install

 print_colored( "Build and installation process completed successfully.\n", " green");
 print_colored( "Please check $    LOG_ DIR for logs.\n", " blue"  );
 

 # --- End ---
 1 #Perl requires a return value from the last expression
 #Note: All of this will not work if you try and simply 'cat' the entire thing and execute without running in proper perl runtime and dependencies

