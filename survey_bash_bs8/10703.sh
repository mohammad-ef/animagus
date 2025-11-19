#!/bin/bash
#set strict bash mode
: ${_ } set -euo pipefail &&
  # Initialize Log Directory and Timestamp variable, enable colorized output where possible for ease of debugging/operation, and initialize a global array to store compiler and other version info. These can be accessed from any function using the global array, but it avoids polluting functions with repetitive logic and keeps them cleaner
  mkdir -p logs &&
   TIMESTAMP=$(date +%Y%m%d-% H%M%S) &&
LOGFILE="logs/build-$ TIMESTAMP.log"{

  [[ $(type -t tput) != "command" ]]|| enable=colorized
  else   enable=""
fi; export enable ; 
COMPILER_INFO = ();

# Functions for Colorized Printing
function red()   {   local string="$1"  ;   local formatted="$ {RED}$string${RESET}" ; }
function yellow()     {   echo -e "$string$ { YELLOW}\" $1\\n $ {COLOR_RESET}" }
function magenta() { local str="$1";  local formatted="$ { MAGENTA}\" $str $ {RESET }" }

# Function to Log with Timestamp
function log() {
    local MESSAGE="$1" ;  local MESSAGE2 ="[$USER@$(hostname)] : $MESSAGE"
  printf "%s\ n" "$MESSAGE" >> "$LOGFILE"   ; { [[ $enable=colorized  ]] && printf "%s\n" $(t put setaf 1) $MESSAGE 2  } || printf $MESSAGE;
  }


# 1. Initialization and Environment Setup
  log "Starting universal build script."  ; log "Timestamp: $TIMESTAMP"

  OS=$( cat /etc/os-release |   grep 'id=' | awk -F'='  '{ print $2}'  );
  KERNEL=$(   uname  -r ); ARCH=$( uname -m   );
  CPU_COUNT=$(   sys  ctl 'hw.physproc'  2>& 1|| echo 1    );
  MEMORY=$(    free|  awk '/Memory:/ {   PRINT int($3/1024)  }     ');

  COMMANDS=("uname" "  awk" "sed" grep "  make" "cc") ;
  for CMD in "${COMMANDS[@]}"; do {  test -x  /usr/bin /"$CMD"/  || die "Error :  Essential command '  "$CMD"'" is  NOT  available."   }   } ;

  # Normalize PATH, LD  _LIBRARY_ PATH
  PATH=${PATH}: $PWD/bin;
  LD_ LIBRARY_ PATH=${LD_LIBR ARY_ PATH}: $PWD/lib ;

  # Set global environment vars for common directories. If directory not found, exit and print an error for debugging purposes. This should prevent any errors downstream
  [ -d /usr ]       || die "Critical: /usr not found";
  [ -d `/var `]      || die "Critical : /var not found ";
    
  # Create temp directory
    mkdir -p temp &&
       tmpdir=$PWD/temp; export TMPDIR= "$tmpdir ;" # for some compilers (like hp-ux), this is necessary for temporary directory access

# 2. Compiler  and Toolchain  Detection (and recording compiler information in the GLOBAL COMPILER_INFO array, and also adding vendor compiler defaults as appropriate based on the discovered platform and compiler versions). This ensures a compiler can be found, no matter its version or location and sets it as a global env variable
  function get_compiler() {
    COMPILER=$ ( command -v gcc 2> /dev/null )  ||   COMPILER = $(   command - v  clang 2>&1);

    if [ -z "$COMPILER" ];  then {   # Check for HP compiler ( hpcc), IBM compiler (xl c), or Intel C compiler (icc). These compilers are less prevalent, so it's more likely they will be the only possible compiler. If all others fail, try these, as they may be installed and configured already. This allows legacy code to build more reliably. If all else fails, exit an informative error to the console so the end- user doesn't think it's a simple build failure.   }   else {  exit 1   };   fi
  }


  get_compiler;
  COMPILER  INFO["name"]=$ compiler;
COMPILER_INFO  ["version"]= $(   $ COMPILER - -Version 2>&1); log "Using compiler:  $ COMPILER  (  $ {COMPILER_INFO [ "version" ] })";

  # Check for C++ compiler
  function get_cXX_ compiler()     {
    CPPCOMPILER = $( command -v g++ 2> /dev   null) || CPPCOMPILER= $( command -v   clang++  2>&1     );
    }
  function get linker() {
    if [[ $(uname) == "HP-UX  " && ${COMPILER} == hpcc ]];   then   linker= $( command - v    ld.hpux 2 > / dev/null );   else   linker=   $(    command - v  ld 2>&1 );  fi;
}

  get_cXX_  compiler;
  if [ -z "${ CPP  COMPILER }" ];  then {  die "C++ Compiler  NOT  available!"   } fi ;
  COMPILER_INFO["name cpp"]="${ CPPCOMPILER  }";
  COMPILER   INFO ["version cpp"]=$ { CPP  COMPILER } - -Version 2>& 1;
  linkers= $ linker;
  getlinker;
  COMPILER  INFO  [ "linker" ]=$ {  linkers   }  ;
  COMPILER   INFO  [ "linker version" ]=$ { linkers}    -v | grep "linker" ;

# 3.  Configure  Compiler  and Linker Flags
  function  configure compiler_flags() {
    local platform = $ {OS};
    if [[ $ { platform  }=="  ubuntu" ||  $ {   platform }==" Debian"  ]];   then {   CFLAGS="- Wall - D_GNU_SOURCE" ; CXXFLAGS="- Wall   -   fPIC" ; L DFLAGS="-   lpthread- l m"  } };
    if $ { platform }=="  centos" ||  $ {      platform }=="RedHat" ; { CFLAGS="- Wall  -   D_GNU_SOURCE"     ; CXX FLAGS="-   Wall   -   fPIC"   ;   LDFLAGS =" -     lpthread-  m- ldynamic- lrt"}  fi;

  if [[ $ enable=="  colorized"    ]];   then {    printf " %s  $ {COMPILER INFO['name']} compiler flags: C FLAGS= $ {CFLAGS}  CXXFLAGS=  $ {CXX  FLAGS} LDFLAGS=$ {LDFLAGS  } "   };   else { echo "Compiler flag settings are:  CFLAGS=$CFLAGS CXXFLAGS=$ {CXXFLAGS}   LDFLAGS= ${LDFLAGS  } "}  fi;

 export CFLAGS CXX  FLAGS LD  FLAGS;
}
configure compiler_flags;

# 4.   System  Headers    and   Library  Detection
  function check_for_headers() {
    local header_list=("stdio.h"      " stdlib.h""  unistd.    h""  sys/  stat.h""  sys/     mman.h")
    for header in "${header_list[@]}"; do {  local test code="#include \"$header\" \ n int main() { return 0;}\ "";   local temp_file=$ {tmpdir}/test_header.$( echo   $ {header} | rev  | c  ut -c 2 |    rev).c;   echo   $ { test  code} |  $ { COMPILER}  -   c "$temp_  file"  2>& 1||  echo   $ { test_  }   }   fi;

  done
}

check_ for_headers;

# 5.      Utility   &   Tool   Detection
function detect_tools {
  [ -x  /usr/bin/n m ]|| nm ="/   opt/homebrew/bin/ nm"
[ -x  /usr/bin/objdump ]|| objdump  =" /  opt/homebrew/bin/    objdump"
[ -x  /usr/bin/ s  trip ]   ||   s trip  ="/   opt/homebrew/bin/   s trip  "
}
detect_tools   ;

# 6.  Filesystem  &   Directory  Checks
function filesystem_checks {
  if [ ! -d /    usr ];   then {  echo   "ERROR: /usr Directory  Missing"   ;       false   } fi;
  if [ ! - d / var];   then {   echo   "ERROR: / var  DIRECTORY  Missing"   ;    f alse } fi;
  if [ ! -  d /    opt ];  then {   echo   "WARNING:/      opt  DIRECTORY  NOT  FOUND  (May  cause  installation  issues)"  } }   else { true    }   fi;

}

  filesystem_checks;
  prefix="${PREFIX:-/usr/   local  }" ;  log "Installation Prefix:$    prefix" ; export     PREFIX;

# 7.  Build  system  and   Compilation (using a make utility).  The script attempts to find a make utility and then executes a build target. This is a very simplistic compilation process and does nothing to handle complex build scenarios, however the script attempts to run all commands, log the build progress and exit cleanly on any build or compile failures
  function  build project{
     make   "build_target_ here " ||
     echo      Error compiling  project   >  $  LOGFILE

      return 1

 }
# Build the Project if there isn't a flag set in command parameters (for automated execution, like build systems, test suites and container deployment pipelines.)  The command should have some form, such as "script build " to start build process

[ "$BUILD_BUILD_"==""" " ||  build     PROJECT ;


# 8.     Clean/Distclean/Rebuild
  function perform cleaning{
  make    clean    ; log   Successfully executed cleaning.    return      1    ;
  }

  perform    cleaning    ;
  return      1 ;
# 9.  Test &      Validation
 function  execute_ test suite {  # A very basic example here to show a possible test run scenario using shell tests
 test -   f tests / runtest || echo " No tests found "     >>       LOGFILE     ;     run   test ||  fail   to  execute     Test

 return         1

}

#execute Test
   execute      Test     ;

# 10.Packaging  &       Deployment (creates an example simple  TarBall
function  make package archive
tar       cvf   $ PREFIX   .    t a   r    $ PROJECT     
 log " Created package $ PROJECT   ".    true;
}

# make   Pack

   make      pack       ;

#11.     Environments      diagnostics (outputting environment info to aid  diagnostics. The script provides diagnostic output useful if it's used to set environment and system information to help build the code, as it lists important compilers as a summary.)
function output_env   information { echo " OS :      $  OS    ;   " echo        KERNEL:"     $ KERNEL    "" echo   ;
echo    CPU      :    "$ { CPU COUNT } ";  echo " Memory  in       Mb   :       $ {    MEMORY }  ".      ;;;echo  COMPILER       :       "$  { COMPILER }     ;;  };;  
;;     Compiler   :        "${{COMPILER     info        [      name   ]   }}"
 echo  COMPILER VERSION        "${    C OMPI LE RI    INFO    [ version       ] }"

 return  TRUE ; }

 output   _Env Information;

#  Add more build, package testing functionality to make the whole operation seamless, but these are enough examples here.   If this was to build more complete systems then all build tools would require their specific commands/arguments and error management

 log        "Finished     Building      ,   Packaging       "     and            exiting    script ;
 exit        0
