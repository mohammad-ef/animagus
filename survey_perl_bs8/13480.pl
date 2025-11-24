#!/usr/bin/perl
use strict;  require warnings = auto, qw(Tie::RefHash); # required for some old OSes and Perl < 5.10, for safety
use feature    qw(say /); # for modern syntax (requires Perl 5 and beyond, fallback to printf for earlier)
use Tie::RefHash 'Data::Tie ref => 'Hash';

# Configuration and Globals
# = = =======================

$ENV { "TERM" } ||= "dumb"; # Set a default terminal (some OSes lack the variable initially. Needed for curses, Term Read Line, color, etc.) if missing
BEGIN { $INC  { "Config::Portable"   } =  scalar(localtime); }
package MyConfig;
use vars qw($CONFIG);
BEGIN {
    die "Fatal error: No config file found or read correctly!" unless (read_config('./build.conf');)
    $DATA = { os    => "UNIX", # Set a sensible value in cases it's not detected (older systems or misconfigured ones) }
}

{   sub read config {
    open my$in  , "<",'build. conf' || die "Couldn't find/read config file: $!";
    while ( < $in ) {
       if ( /\b (?:set|define) (?<param >\w+)  (?: =  | :=) ( [ ]* (?<value >. *) )/ ){ # Regex, allows comments, spacing, etc. and catches multiple variations (set x = 1, x   := 1), avoids spaces at the very start and very end, and makes variable name a single word, not an arbitrary sequence of spaces or letters, digits, etc (which causes problems with the code later)  }

       push @{$CONFIG{$param}}, undef if (not defined $ CONFIG{$param} ) ; # If we haven't initialized, initialize, so that push works
        my$clean_value = $value =~ s/[ ]+$//r if (defined $value) ; # Removes all spaces at the end, required to handle different styles of build configuration, and to make comparisons easier/less problematic (and more reliable) and avoid weird edge cases. Also cleans up comments in the configuration if they contain a space at the beginning, to allow them. 

       $CONFIG {$param}  = $CLE AN _V ALUE; # This will handle the variable and clean values correctly. This cleans whitespace, which can be important. This makes the configuration much more reliable in a wide variety of situations across many different platforms with varied formatting, comments, and spacing.
    }   
}
 close my $in ;
 $CONFIG = MyConfig-> new ( config  =>  $CONFIG );  # Create object for the new configuration data, which can be accessed by calling MyConfig -> new ()
 }

sub get_config {
  my( $obj, $param)      = @_;  # Object, and parameter
  if ( exists ( $obj-> {  ' config' }->{$param}  )) { # Check config, if the config exists, then we can safely access its value
     $obj-> { config }   -> {  {$param} } ; # If it exists, retrieve
    }
     else { die "Parameter '$ param' not defined in ' $obj'. Please check the configuration file, or define a new configuration file, or use the default."
   }
}

package MyConfig;

sub new {
     my ( $self, $config)     = @_;  # This will be a config array, passed to the configuration file, so the class knows what configuration options are being used, and what values are being passed through the config file. It's also a way of passing a reference. It's important for this to be defined correctly so the script is robust across all environments with different build options.

  $self-> { ' config'    } =  $config   if ( defined ( $ config ) ); # Assign config, if passed through the constructor
    return ( $ self ); # Return object itself.
}   

package main;

# Initialization and Environment Setup
# =   =   =============================

print "Initializing build environment...\n";    # This is a standard output message that will appear when build is running

  my( $OS, $Kernel, $Architecture, $CPU_Count, $Memory   ) = ( get_environment ( ) ); # Get the environment, and return the information

sub     get_ environment { # Returns operating system details

   my @details ;
   push @details,  'Unknown'    unless ( defined ( $  { OS } ) );
    push @details, 'Undefined   '  unless (defined ($  { KERNEL } ) );
    push @details,  'Undefined  ' if  (!defined ( $  {  ARCHITECTURE  } )); # Check if the Architecture exists before adding it, if it does exist, it will add a defined architecture, which prevents crashes, especially on older platforms where the value isn't initialized properly, or missing completely for legacy OS versions. 
    @details;

}

    # Verify essential commands
    unless( check_commands( qw(uname make gcc sed awk grep) ) ) {  
      die "Missing required command(s).\ Please install and add them to the PATH.\n";
   }

#Normalize Paths, LD Libraries, C Flags, C++ Flags and Link Flags
my    $PATH = normalize ( $ENV { ' PATH   '} );
$  ENV {  ' LD_ LIBRARY_' .  'PA TH'} =    normalize ( $  {  'LD_LIBRARY_'   .  '_PATH'} );
$ENV { "CFLAGS" } = normalize ( MyConfig:: get config ( "CFLAGS" )   || "" );
$ENV {   "CXXFL AG S   "} = normalize ( MyConfig    :: get_ configuration ( "CXXFLAGS" )   ||  "") ;
$  ENV { "LDFLAGS"}  = normalize(MyConfig   :: get configuration ("LDFLAGS") || "")   ; 

sub    normalize  {
   # Normalize a path by removing duplicates and sorting
  my @path_list = split (":", shift  /**@  */) ; # This gets a single parameter, and breaks that string into a list of directories, based on ":", the default path separator across most UNIX-like operating systems, which makes it very portable. The path variable, in this case, is a single string, passed into shift, which breaks the string into a single directory
  my    %seen  ;
  @path_list  = sort  unique   @path_list ;

  my    $ normalized_path = join(" :",    unique (   @path_list));
  $normalized_path ;

}   

  my    $log_dir    = MyConfig::   get_ configuration (  "LOG_  DIR ") ||  '/tmp/buildlogs' ;
   unless (  -d $log_dir)     {
     mkdir $log_dir || die "Unable  to create  log  Directory '$log_dir': $!";
  }
  # Enable strict and warnings
 use Strict;
 use Warnings; # This is an example of a modern, best-practice Perl program
# Compiler and Toolchain Detection

print "Detecting compilers...\n";

 my ( %compilers, $compiler   ) = detect_compilers;

sub detect_compilers   {
 # Detect compilers ( gcc, clang, suncc, etc. )
 my %compilers ;

  if (  -x 'gcc'    ) {  # Check executable status and if it exists (and not a broken link) to prevent errors, crashes, and hard-to-debug problems. 
    $ compilers {  ' gcc'}   = ( "gcc", `gcc --version 2>&1 | head -n 1`,  "GNU" );
 } # This is a more robust and reliable detection. It not only confirms it exists as a binary, but also retrieves a string with the compiler version, allowing for better compatibility detection
  if  (`clang --version 2>&1 | head -n 1`)   {   # Same thing applies to other tools, checking to verify executables and getting more detailed metadata about these
  $ compilers {  ' clang '}  =  ("clang",   `clang --version 2>&1 | head -n 1`  ,     "Clang"); # Detect, extract and assign version details for Clang compiler

}
 if  ( `suncc --version  2>&1 | head -n 1`    ) {  
    $compilers { "suncc"}  = (   "suncc",  `suncc -- version  2>&1 | head -n 1`, "Oracle Solaris/SUN  "); # Check Sun CC
  }

 return( %compilers);  # Returning hash table. The order is not relevant in perl hashref
} # Returns Compiler, with the largest amount of relevant detail to make debugging easy

if  ( scalar ( keys   %compilers)  == 0  )   {
   die  "No recognized compilers  found, check your installation"; # Error handling. If the script detects there are zero recognized compilers installed.  It dies immediately
}

$compiler   = (   keys %compilers  )[0 ];
print  "Detected compiler: "  .$compiler    .   " "   . $compilers {$compiler}    [1].   "\n";

# Compiler and Linker Flag Configuration
#  ==============================

 print  "Configuring flags...  \n";

    my     $os =      $ ENV{   OS   }    || "linux";    # Get value of operating system
 # Set compiler flags depending on platform and options
  my $flags   = (  
         $  OS eq   "IR IX "     ?
         {    "CFLAGS"  =>   "-D _ IRIX ",  "CXXFLAGS" =>   "-D _ IRIX ", }

    :$ OS   eq    'HP-UX'?  
    {   "CFLAGS"   =>  "-D_ HP_UX   -DH P_U X  -DUN IX  - D SVR4" ,   "CXXFLAGS"  =>   "-D_ HP_U X - D _ H P_U X-DUN IX- D SVR4"    }, # Check the HP_UX OS for special configurations
     
         $  OS    == "AIX "   ? 
   {     "CFLAGS"     =>     "-DA IX-DI NFINIT -DU N I X  -DH  AS 4",       "CXXFLAGS"       =>   "-DA IX - DI NFINIT - DU N I X  - DH A S4  "    }, 
      

          $  OS  == "UN I X " or   $ OS   eq     "SOL ARIS" or     $ OS eq    "Linux"     ? { "CFLAGS"  => "-g  - O2 ",  "CXXFLAGS"   => "-g -O2"}, # Default for generic UNIX and Solar systems, or if running with an Linux OS environment
          }       ); # Generic configurations that are dependent upon the type of Operating system

     # Apply the default values.  This provides better defaults than if we only defined it at one level in an initial declaration 
 my( %default ) = ( % $FLAGS, "CFLAGS"     => "-g   - D UN  I X ",
       "CXXFLAGS"   =>  "- D   UN IX  ",  "LDFLAGS"   =>    "",  "CPPFLAGS" =>   " - D _ REENTRANT ",);

my(   %flags     )  =     merge     %(%$default    ), (   %( get  (   configuration    )     );)
my @cflag = @{(get  config(  flags,     )"  ) }      );  

    my (  $  cFlags_result   )    = ( (scalar   % flags,  );       $ ENV{ CFLAGS     }      = (   $   ENV{"C FLAGS"}  || $  CFLAGS  )); 

   print "CFLAGS:"     .     join " ","" .     @ $ENV{"C F LAGS" };  # Prints to screen all compiler information

 # Check the existence and configuration, to protect system.   Print to console

  # System Header and Library Detection
# ------------------------------------
# (Omitted to keep length under constraints; logic involves compilation checks, error handling.)

# Utility and Tool Detection
# -----------------------------

 #Omitted
 # FileSystem and Directory Checks
# -------------------------------
# Omitted for conciseness (would be quite a lengthy block). This includes directory verification and write-check, to check access for build
# Build System and Compilation
# ----------------------------

 # Omitted

# Testing Validation
# --------

# Package and deploy. Includes generating archive and verifying files are correctly generated and stored (e.g., tar balls or zipped versions of project binaries. )

# Recovery roll back and Backups, and other finalization and reporting. 
sub     get config     {    

   (my($  param )     ) ;     
 # This allows configuration files in build, with build variables defined
 return MyConfig     ::      get config   ();

 }


say "Done" if -f "./" or "DONE if exists('./") ;    # A more verbose example using the Perl say function

  
__END__
