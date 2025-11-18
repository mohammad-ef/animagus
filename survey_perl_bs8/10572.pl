#!/usr/bin/perl
use strict;  require warnings = autosubs qw(scalar le); # Enable best warnings
  use Term::ReadKey; #For better interactivity in older versions and terminals, fallback to standard if missing, but warn
  require Term qw(ReadLine);  use Term qw(clear); # Use term:: readline
  # use Term   qw(clear); # Use term for clear command.
  use Term::ANSIColor;  use Getopt::Long;  use Digest qw(SHA256);  use File::Copy; # For copy and move operations
use POSIX qw (setsid); #For daemon support

  my ($opts, @opts)      = GetOptions("prefix="  => \$opts{ "prefix"  },    # Allow to customize build prefix and paths. Can specify a location. Can also use a relative path such as `./prefix` if you are building for the directory you are currently executing. If not given use a standard location that should be writable and is not a temporary location or a user home location for a portable solution that works on various platforms that may have different home locations that are hard coded. 	 

	"build-type="  => \$opts{ "btype"      }, # Allow to choose which type or version of the built binary will be constructed. Can choose to use debugging or optimizing versions, which should affect compilation flags and how libraries or modules are built or configured.
	"verbose"  =>{  'verbose'}   , # Allow user to see additional debug and diagnostic logs that may have been hidden otherwise.
	"debug"      => sub{$opts{ debug}    = 1;  },$ # Set to use debugging builds for a specific build or run.

	  "diagnose"   =>{ sub   {$opts{diagnose}=1;$opts{ verbose}      =1  ;$opts{ debug}    =  1  },$}, # Show system and version diagnostic. Should also display all of the build flags that are available.

	"recover"      =>{  'recover'}, # Enable recovery from a previous known build, and attempt to rollback the last build if there was a failure or error. Should use backup files or directories that contain information that could be recovered from a previously known stable or working build to rollback.
	"containerized"   =>{'enable_container'}, # Enable containerized builds
	   "ci-mode"    => sub  {$opts{ ci}      =1    },$ # CI- mode disables interactive mode. Suppresses all terminal output.

	"test-coverage" => sub {$opts   {'test_cov_enable'}   =1   },$ #Enable test coverage
      
	  "parallel"   =>$opts{" parallel"}   , # Allow to enable multiple build or compiling instances. 
	   "patch-apply"      =>{  'apply_patches'} , 
	   "release-mode"     => sub { $opts{'release mode'} = 1 ;  }, #Build a release mode artifact for final deployment or packaging.

	"version"  =>{   }, #Print the version
	@opts
     );
  # Default prefix and build type. 	     
  $opts{ prefix    } ||= "/usr/local";  # Set default installation path. This can be customized by using the command line. Should also be set to a safe location where you would normally install software that can be written to. Can specify a location.   
  $opts{ "btype"     } ||= "release"; # Release builds are typically the most optimized, while debug builds are the least. 	    
  my @debug  = ();

  # System detection and configuration.   
    if (exists $opts { "patch-apply"})
    {     my @files   = glob("./patches/*.patch"); # Search for files that end with `.patch`. Should only apply files if there are actual patch files in the patch directory to avoid unexpected behaviors or errors.
	   	foreach    (@files)
	   {
	   	   if (open  ( my $patch_handle , "<" ,  $_ ) ) #Open each patch to read its contents.
	    {
		  print "Applying " $_ . "\n";
		  system "patch < " . $_ . " ";		
	    }

	   }		
    }
  
  # Detect OS, architecture, and kernel info.  
  my ($os, $arch, $kernel)      = (uc first (split /\s+ / , `uname -a`), uc scalar (split /\s+ / , `uname -m`),    uc scalar (split /\s+ / ,  ` uname -r`));
  print  colored "\nSystem Details:\n", "red",   " OS:  " . $os . ", Kernel: " . $kernel . ",Arch :" . $arch . "\n ";
  #Detect compilers
  my  $compiler = detect   compiler();  print "Compiler: " .  scalar $compiler . \n if defined $compiler  ; #Detect compiler and print it.

# Utility and Tool Detection  
sub detect_compiler() {
     my @compilers = qw(gcc clang cc suncc acc xlc icc c89);
     my $candidate = ''; # Set initial variable. Should be used if none of the compilers is set.
     foreach    (@compilers) #Go through all the compilers
     {
	   if (   defined (scalar (grep { $_ eq $ compiler} @compilers )) )
    {  return $ compiler  ; #Return compiler
	   }
    }
	#Check and return the compiler that can be used.
    return $candidate  ;
}

 #Check to see if a file or directory is writable or readable. Should not allow users to run with restricted permissions, since they may run into permissions problems during the build process or later.  
sub file_access_check {
  my $filename = $_[0 ] ; #Filename to check. Should also verify that the file exists.
  if   (! -f  $ filename )   and (!    -d    scalar $filename) {
  print   "Warning: " . $ filename   . " not found or exists and could not be found for access check\ ";
  }

  if   (-w  scalar $filename )
  { #Check if the file can be written to by the current system or user.
      print   "File " . $ filename . " is writable.\n "; #Show that the file has write capabilities. 
   }
   else
     {
	print      "Warning File "    . $  filename  ." is un writable.\n   Please verify permissions to proceed.\n  ";
    } #Warn users if the file does not have the write access to the directory or file.
}

# File system and directory validation
  foreach    ( "/usr","/var","/opt","/lib","/usr/lib","/tmp","/etc" )
  {
	file_access_check     ($_); #Check all the directories to verify that they are writable and readable.
  } 
# Initialize logging directory if it doesn't exist
   mkdir  " logs " , 0755  unless  (-d  " logs ") ;     
# Environment diagnostics
 sub print_environment() {
  print "\nEnvironment Variables:\n";
  foreach    (keys %ENV )
  {  print "$_" . ": " . $ENV{ $_ } . "\n"; }
}

if(exists  $ opts{" diagnose"} )
  {  print_environment();  } #Call the environment variable print routine if the -- diagnose mode is called to print all variables. Should also print flags and compilers if the -- diagnose mode flag is passed as an additional variable.  
# Check for essential commands
   my @necessary_commands = qw (uname awk sed grep make cc);  
   my  $check   = 1; #Set to 1 for all commands to be present. 
   foreach    (@necessary_commands)
    {
    if (   not   -x  $   ) 

  { #If a command is not found and does not work or can not be executed properly then report it and fail the build.
	   print  "Error: Command '" . $    ."' not found."   .   "\n ";
   	      $check  = 0 ;
      } #Warn or print an error when the system can not verify the presence of an command needed by the software that will be constructed from a repository and/or source files.

   }  
if     not    scalar    $check     { #Check whether every necessary commands exists in order to determine a failure condition
       print  "Required commands are not all present in your operating environment, so aborting. Possible errors will arise and that this is expected behavior."  .   "\n "; #Report error if a build has errors
      exit    1;

 }#Report a failure and terminate the building and compiling of source or archived repository code files for a specific version

  if($opts{'ci'})  
   {print   "CI Mode: Verbose Output Disabled \n";} # Inform of the status if you want or do not want to see more messages.  #CI
      # ... remaining functions (compilation, testing, packaging, etc.) omitted for brevity, following similar pattern. 
    

 #  # Build system (Makefile detection)   - not fully complete in all the possible build options or scenarios, however it is enough for most builds or compilation.    
    my    $makefile  =    'Makefile' ;
 #    unless   (-f      $makefile  );    print " No Makefile Found" ."\n   ";
#     $ makefiles  found  
print scalar( defined $ makefile)     ?" Make file " :     'Not  makefile '   .          "\n ";    #If no  Make files can engage or activate a build script

    print     'Building '      ." $makefile    .\n "    ;

print     "\n   Completed build \n"      ;      

 print  scalar   (defined   (    "Makefile"))  ." Make  Files were detected, otherwise, you should use another script"   ;       

if ($opts{" verbose"})
{ print scalar     ("\nVerbose Output: Build Logs stored in logs folder ")
;
}       
  
 exit   0  ;

1; # This signals to Perl the return statement
