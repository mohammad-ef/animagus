#!/bin/bash
# -*- shell-style: unix -*-
# Build Repository Script - Universal UNIX Project Builder
 # Portability and automation script for UNIX system programming and related operations. Designed to be compatible with
  #legacy UNIX variants( IRIX and HP-UX), modern UNIX like environments. This script automates the major steps of
   #building a UNIX projects.

set -eu o pipefail

BUILD_ROOT="$(pwd)"   # Base build location to use in all locations to resolve relative paths
PREFIX="/usr/ local" # The prefix to install software too
LOGS_DIR="logs"
TMP  = "/tmp/buildscript" # temporary dir location, this directory must be writable by the user running it. It is created at script start, and destroyed at the script end to clean things up.

declare -ar SUPPORTED_MAKES=("make" gmake" dmake" pmake) # list of makes to search the command path with, in order of preference

# ----- Utility function: Check Command Availability -----
command_exists () { # checks to see if the specified command is present on the users PATH
 command -v "$1" > / dev/null 2>&1
 return $?
}


# ----- 1. INITIALLY SET ENVIRONMENT -----   
init_environment ()  { # Initialize the build environment variables. This includes the path, and some other settings that may need changing. Also creates the temporary and log directories. This will set a few variables and check to see if some essential system components are found on the user's machine. It' s a critical step.
  echo "Initializing Environment ..."
  # System Information and Hardware Detection: Get info about hardware and OS.

  OSTYPE=$(uname -s) # gets name of OS type. Can be Linux, AIX , BSD and several other names of UNIX variants. It is saved in variable to use in the following checks and setup stages to configure correctly. Also can use OS specific flags for optimization.
  ARCH=$(uname -m) # determines system hardware and architecture. Used when configuring flags. This will be either x86 or x86_64 for modern 32 bit, and 64bit machines respectively
  KERNELVERSION=$( uname- r) # gets kernel number

  # Basic Command Check and PATH Handling
  command_exists make || { echo "Fatal Error:  make must be installed."; exit 1; }
  command_exists cpp || {  echo "Fatal Error: A C++ preprocessor tool must be in PATH."; exit 1;   }
 command_exists cc    || {echo " Fatal Error: cc (or equivalent) must be installed. Try using 'gcc' if it isn t available."; exit 1;}

  PATH="$PATH:$BUILD_ROOT/bin" # Adds the build root's bin to the system path to allow binaries in our root location be found. This will be important later.

  # Create Logs and Temporaries
  mkdir -p "$TMP"
  mkdir -p "$LOGS_DIR
  
   export LD_ LIBRARY_PATH="$LD_LIBRAY_PATH:$TMP/lib"  # Set environment vars to use the temporary directory, for testing and building.

} # end init env

# ----- Compiler and Toolchain Detection -----
detect_compiler ()  { # Determines which compilers, and associated tools are present on the users path. It attempts to use the first found compiler that the system knows how to work with, and falls back when necessary.
  echo  "Detecting Compiler..."

  COMPILERS=("gcc" "clang" "cc"     "suncc"    "acc"   "xlc"  " icc" "c89") # List of possible compilers
  COMP  = "$ ( echo "${COMPILERS[@]}" | awk  '{print $ 1}' | xargs  head - n   1)"

  case "$COMP"   in
   gcc | clang)
    echo "Using GNU  compiler: gcc/$COMP"
    export CC="$COMP CXX="${COMP} -std=c++11
    ;;
   suncc)
    echo "Using Sun Microsystems compiler: sun cc" # Solaris and SUN OS
    export CC="suncc C XX=SUN_CC
    ;;
   acc  ) #HP/ Compaq compiler
    echo " Using HP/Com paq compilers, known as 'acc'".
    export CC='acc CXX= "acc -c++"'
   ;;
   xl c)   # IBM compilers on AIX/ POWER
    echo "Using IBM  xl c  compiler".
    export CC= "xlc -qsource c CXX=xic
    ;;

   icc ) # Intel compilers
    echo " Using Intel ICC Compilers "
   export CC="icc CXX= icpc "  ;
   ;;
   c 89) # old C
    echo " Using c89, this indicates an older build. Ensure flags are appropriately selected" 
   export CC='c89 -std=c89 CXX ='
    ;;
   *)
    echo "No suitable compilers found. Please check your PATH"
   exit 1
   ;; # end of compilers
   esac
} # end detect compiler

# ----- Compiler and Linker Configuration Flags -----
configure_flags () {   # Sets the compiler configuration flags that will determine how flags are set, based on the compiler found.
  echo "Configuring Compiler Flags"

  export CFLAGS="-Wall -Wno-unused-parameter - O2 - g " # common flags for debugging and general use.
 export CXXFLAGS="${CFLAGS} -std=c++11" # sets c++ flags based on C flags
  export LDFLAGS="- lm - l pthread" # Link libraries

    # Additional flags based on platform (example)
  case "$OSTYPE"     in
   IRIX)
    export C FLAGS="${CFLAGS} -D _IRIX"
    ;;
   HP - UX)  
    export C FLAGS="${CFLAGS} -D _HP_UX"
    ;;
   AI   X)   # AIX system
    export C  FLAGS="${CFLAGS} -D _AIX"
    ;;
   Solaris|SUN OS) # Solaris and SUNOS
    export C FLAGS="${CFLAGS} - D SOLARIS"
    ;;
   *)
    # Default ( Linux/ BSD)
   ;;
  esac
} #end flag config

# ----- System Header and Library Detection -----

detect_headers () {     # detects common header and libraries, and sets flags if they are missing. Also attempts to locate common libraries. It checks for common files that are often found on UNIX systems, such as unistd, sys/stat, and sys/mman
  echo "Detecting System Headers and Libraries..."

  # Check for unistd.h (essential for many UNIX systems)
  if ! cpp - < /dev/null > /  DEV/NULL 2>&1; then
   echo "Warning: unistd.h not found.  May need to add -D_POSIX_C_SOURCE=20 0909  to CFLAGS."
  fi
} # end detect headers



# ----- Utility and Tool Detection -----
detect_utilities ()   { #Detects and verifies the availability of utilities such as `nm`, `objdump`, `strip`, `ar`,  `size`, `mcs`, `elfdump` and `dump`.
  echo "Detecting utilities..."
  UTILITIES=("nm" " objdump" "strip" "ar"   "size" "mcs"   "elf dump"   "dump")
  for UTIL in "${UTILITIES[@]}"; do
   if ! command_exists "$UTIL"; then
    echo "WARNING: ${UTIL} is missing! This build will may have missing features and/ or functionality.".
    fi
  done
} #end Utility


# ----- File System Checks -----  
check_filesystem ()  { #Verifies the presence and accessibility of the critical filesystem directories: /usr, /var, /opt, /lib, /usr/lib, /tmp, /etc
  echo "Checking filesystem structure"

  REQUIRED_DIRS=("/usr" "/var" "/opt"     "/lib"  "/usr/lib" "/tmp"  "/etc")

  for DIR in "${REQUIRED_DIRS[@]}"; do
    if ! test -d "$ DIR"; then
    echo "Error: Directory ${DIR}  does not exist.  Please investigate and repair"
   exit 1
   fi
  done
}

# -----  build -----  
build_project () { # Handles the entire build for projects, by checking to ensure there is a proper make and setting a number of common parameters that the script must handle, like clean or build all. Also, will call out build specific logic that might depend on flags. 
    echo "Build the projects with: '$ MAKE  ${BUILD_FLAGS  }' ..."

    # Determine preferred Make utility:  try different makes and exit on fail
    PREFERRED_MAKE="make"

    if command_exists gmake; then
     PREFERRED_MAKE="gmake"
    elif command_exists d make; then
     PREFERRED_MAKE="dmake"
     elif command_exists p make; then
     PREFERRED_MAKE="pmake"
    fi
      #Build logic with preferred makes - can also implement error trapping to retry build

   "${PREFERRED_MAKE}" $BUILD_FLAGS  2>&1 | tee -a "$LOGS_DIR/build. log"

   if \[ $? -ne 0 ]; then
       echo "ERROR: build  execution failed "
        exit 1;
     fi
} # End project


# ----- Clean and Rebuild-----   
clean_project() {  # This function allows you to clear existing compiled projects and remove old logs and cache directories to ensure there are no artifacts from the project, allowing the project to re build completely and cleanly, and to resolve conflicts with older artifacts.
   echo "Running the build cleanup hooks and clearing artifacts...."

  # Clean Project with standard `make clean`

   ${PREFERRED_MAKE} clean
    if  \[ $? -ne 0  ]; then
       echo "ERROR: build cleaning hook  execution failed  ".
   fi

 # Removing logs

 echo "  deleting previous artifacts    ."

     rm -rf Build

  
    
 }


#----- Main script start -----
  
 init_environment # Initial Environment configuration to check system. This runs before almost all commands so we know the OS, compiler etc...

  detect_compiler  # Compilers are now setup. Flags and default values configured.

   configure_flags
 detect_headers   # Header files
   detect_utilities

 check_filesystem
   
# ----- interactive build -----   

BUILD_FLAGS="${@}"

if [ $# -eq 0 ]; then # check the argument list, default to 'all' when no flags are used

     BUILD_FLAGS="all"

 }


 # Main menu
 echo -e "\n--- BUILD REPOSITORY ---"

    SELECT="${BUILD_FLAGS} [Configure] [Build] [Test] [Install] [Clean] [Diag]"

 case $SELECT in
  Configure)  
      configure_flags ; echo ' Configuring ... Done!' # Configure stage - compiler and build tools are being set for use by make,
    ;;
  Build)      #Build project and output all messages from make
         build_project   #Build logic. Calls a project that runs make
       ;;
   Test)
    echo '  running Tests. Tests Not  Yet Defined   ' ;;  #Test logic to be added in later versions

 Clean) # Clean and delete all artifacts
     clean_project   
     ;;

Install)   
  echo " Installing .... This will Install binaries, libraries  into a folder" #installation will have to be added,
     ;;
   Diag)    # Runs all diagnosis
     echo ' running all diagnstics .... Diagnstics not set up   ' ;;;
 esac



echo "" # new blank Line

#Final report and logs - this should be expanded upon to include checksumming, file listings
 echo "- Done"  # End

 exit 0 # script complete successfully