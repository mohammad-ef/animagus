#!/usr/bin/perl
############################################### build_all_unx  #######################
use strict qw($DATA,$+ =~ /(.)/; $ARG)=/ qw($); use vars qw(\%$+ @ARG);
  $|=1; use Term qw($ReadLine :history :clear :completion );  # for terminal interaction

# --- Initialization  --------------------------------------------------

  package BuildAllUnx; my $scriptDir  := ($ARGV[  "script" ] // $ENV{"  BUILDALLUN  _HOME"}// ".  ");// use a hard codded dir
  $Build  { "script"  _dir  }$ scriptDir; chdir ($  _script); my  $tmpDir  := $script_dir." /tmp"; my $log_path :=  " $build  { _script}_logs";
  mkdir($log  "_dir) or die $!";  #Create logs if not there.  Check dir permissions. $Build_  {_logs } $log__path
  mkdir($ tmp__dir ); #Create tmp if no there and test if the file exists and the path is valid
  print "\x41\n";

#  OS, CPU, Arch etc detection
  print "Detecting platform info \n". "os=  ".$ENV{' OS '}. "\t Kernel  version = " .`  uname -a`;  print "CP Us ".scalar (qw(1, $ENV{$" _proc_num _cores "});  # CPU count
  

#Verify tools
  check_command(['uname','  awk ' , ' sed ',  'grep ','make ','gcc ']);

#Normalize paths and envs -------------------------------------------------------

  
# Compiler & Toolchain Detection
  sub detect_compiler { #This function is not really used right now so is empty.  Add logic for compiler auto-detection and version checking here for different compilers, like gnu or Intel, sun cc etc, and store info as build info vars for flags and paths.  Use regex or external utilities if needed (such as checking for a compiler executable.)} {} #Placeholder to allow expansion
  

#Compiler Flags (based on platform, CPU) ----------------------------------------


  $ Build_  {  "_CFLAGS "  }=="-g-Wall-O2 ";  $ Build_{"_CXX  FLAGS"} ="$build  { "_CFLAGS "} -Wformat -Woverflow -fPIC  ";// Default flags for C/ C++, include -O2 and warnings flags. -fPIC for creating sharable librarries (for dynamic linking.)

# System Headers and Libraries -------------------------------------------------------
  $ Build{  "_LIBPATH"} ="/usr /lib :/lib"; #Add common paths to find the library

# Tool Detection - locating nm objdump etc, checking existence/function  -------------------------------------------------------
  sub detectTool  {$tool_name =>  checkToolExists($tool_name  )=>(exists($  ENV{$tool__name})?1:  die "tool $tool_ name not found");} #Simple helper tool existence check function to use elsewhere.  Could add version checking, or more sophisticated verification here.

#Filesystem/Dir Checks (read, write permissions on critical dirs) ----------------------------------------------------  
#Utility Checks (nm,objdump,ar, etc)-----------------------------------------  
checkTool  { "obj dump } detect Tool
check_command(['nm ','objdump ']);

# --- Build System ---------------------------------------------  ------------------------------------------  ----------------------------------  --------------------
sub detectMakeTool {

    if (-x "/usr /bin /gmake") {  
        $ Build{"_Make_tool "}  ="gmake";   print" using gmake \n";   }   
        elsif (-x "/usr /bin /make")  { $ Build_ { _Make  _tool  } ="make ";    print"using make  \n";    }
     elsif ( exists   ENV{ _DM ake _ })  {$ Build__   {"_MAKETOOL  "  }= "_MAKE";  } #If DM  make   variable
    elsif (-x '/opt /subversion /bin /pmake' )  {$Build_{   " MAKE "}_tool }=pmake }; ## pmak tool found.
     
     else  {die  "NO   MAKE     UTIL  FO ND ";   }; } # No tool found

#Cleaning & Rebuilding

    sub doClean {$makecmd=join( "",  ($ Build_{_Make_to ol},   "-- clean " )   );}   } { #This will run  `Make` clean
sub  buildproject
   {#  build project using the  detectMaketool   function to run a  " make"

#   Testing & Validation
   checkCommand([' val  griND ']    ){   def valGRinD   ($BUILD{  } );   valGrIn D;

 # --- Package & Deploy ---------------------    --

 sub  packageProjet   {}    

sub  diag {}
 # Continuous   integration

 #--- security Checks
    $ Build _{"checksum "} =` md 5sum ";     

 sub check  cmd  ({   foreach @{$ _ cmd}
        die unless(- x "$_" or $E ENV{$_})}  };    

     }    


### Interactive UI 
 sub menu { 

# Final Summar and Report ---------------------------   -----    -----

1
