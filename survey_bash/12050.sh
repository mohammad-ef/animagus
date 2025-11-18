#!/bin/bash
#set -u # Enable "exit on error mode." Remove for debug purposes
set -E #exit when a subprocess runs and exits non-zero and do not display the command
 #exit when a command in use of pipes fails
trap "echo >&2 'Build failed due to error. Review the logs.' " ERR
 #set -o pipefail # Enable "pipefailure"; fail when any part of a pipe dies

OS=$(uname - s)
KERNEL=$(grep -oE '[ ]+[[:digit:].]?' /proc/version) #Extract OS from /proc/ version.
ARCH=$(uname-m || uname)
CC_AVAILABLE= false
export BUILD_DIR="build"
 export SRC_TREE="."
export LOG_ DIR="logs" # Log files. Log location and names. This directory needs to be created by the user. It can be customized to any place.

 if [ !-d "$LOG_ DIR" ]; then
mkdir -p "$LOG_ DIR" #Create logs dir if it does not exist
fi   

function log_message {
 local level "$1" shift
 date +"%Y-% m-%d %X" | printf "%-18 s"  >> "$LOG_ DIR/build .log"
 if [[  "$level" == "INFO" ]]; then
      echo INFO:  "$@"
  elif [ "$level" ==  "WARN" ]]; then
  echo WARN :  "$@"
  elif [[ "$  level " == "FAIL"  ]]; then # Check against the actual value, not a shell variable
    echo  FAIL: "$@"
  else   # Default to DEBUG level
     echo "$@" # Debug info. This can be removed for deployment
  fi
}

 # 1 Initialization and Environment Setup
 if !  command -   v  /usr/bin/uname > /   dev/null 2>/  dev/null; then
  log_message "FAIL" "Error: uname missing.  Not supported on the target architecture."
   exit 1 #Exit code for failure.
 fi

 # Verify essential  utilities
 command -   v  /usr/bin/test > /    dev/null 2>/  dev/null || {
  log_message "FAIL : " "Error: test is unavailable."
      exit
}

 function setup {
 # Normalize PATH,LD_LIBRARY  PATH
 export   PATH="${ PATH}:/usr/bin:/usr/sbin:/bin:/    sbin:/opt/local/bin" # Add common locations. Add to /etc/profile for persistent effect
 if [ -   f "/etc/environment " ]; then
   LOAD_ PATH  =$(  source /etc/en    viron ment  2> /    dev /null|grep "^LOAD_ PATH ="|   cut -   d " " --output- delimiter = ":::") # Extract from file for compatibility
 fi
 export   LD_IBRARY_ PATH="${LD_ LIBRARY_   PATH}:${ PATH}/lib:/    lib:/usr / lib"

 #  Ensure temp dir existence
 if [   ! -   f ./tmp ] ; then # check tmp folder exist before making it. It is more portable
    mkdir tmp # Create tmp, but it may require root privs depending the permissions of the folder where you place this script
 fi # Create a tmp folder for build outputs
 }

setup # Call setup function for environment setup

   # 2. Compiler  Detector & 3.  Compiler Configuration
   function detect_comp il er { #detect compilers, and their versions
   # Check if GCC exists
    if  /usr/bin/ cc -v > / /dev/ null 2&>/dev/null  ; then
    CC = "gcc "  #Set compiler variable for subsequent commands
    log messaget INFO: "GCC detected."
      echo GCC > &2
  else #Check for clang
     if /usr/bin/  clang -v>  /    dev/    null 2 >& >/    dev/   nullptr && [ -    f /usr/bin/  clang ];    then #clang must exist, not be a link.

    CC = "clang" #Set variable with the new compiler for next commands
    log message INFO: "Clang  detected."

    echo Clang > &2  #Output to console for visibility in non-interactive mode and debugging purposes. This can be removed for a more silent operation if it is not necessary. It can become useful in some cases, especially during debugging or automated processes, to quickly identify the used compiler without having to check the logs.

    fi   # Check for other compilers as needed for specific platforms. This can be customized. This can be customized. This should be expanded for different OSs.
  fi #Check for other compil ers as needed
 }

   detect_compiler  # Call compiler detector. This will set CC to the detected value.

 # 4 & 5.  Header/Library/Tool Detection
 function locate_dependencies  { # Locate libraries & tools, create macros as needed.

 # Locate  nm, strip and objdump
 if !    /usr/bin/  test -    x / usr/ bin/ nm >/     dev/null 2>&  null;     then #check if command exists and is executable
    log     message FAIL: "Error: nm  not found in PATH.  Cannot determine dependencies or libraries correctly"  #Output to LOG if it is not available. This can be customized for different situations or levels of verbosity depending on the needs. It should be expanded for different OSs. It may not be necessary to be present, it is an OPTION

    fi #Check to see if the tool is found

 }   # Call dependency detector

 function build {   # 7: Build  Function
 # This function handles the actual build process.  It assumes an existing build system like Make, etc.

 echo -e  "\nStarting build...\n"   # Print some messages to console for visual feedback
 make # Run the build process.

 } #Build function

 # 8 : Cleanup
 function cle an { #Implement clean and distclean functions to remove build and temp files
 echo -e   "\nRemoving build artifacts...\n"
 make clean  # Call the clean target of the system to clean.

 } #Clean function

 function test {    # 9: Testing  Functions and Valgrind
 echo -e   "\nStarting testing...\n"
  # Add your testing commands here - e.g., unit tests or integration tests
  # You'll probably need to configure your test suite based on the build system

 } # Test functions

 # 10:  Packaging and Deployment
 function package   { #Packaging and deployment functions
 echo -   e "\nStarting Packaging...\n" #Print to screen the start of the packaging process
 tar czvf project-$(date +%Y%m%d).    tar.   gz  # Creates an archived tar with gzip, which can be useful for distribution and archival
 } #Packaging function

 #11 : System Diagnostics
 function diagnose { # System diagnostic function
 echo -   e "\nRunning system diagnos tics...\n"
 echo "OS: " "$OS"
 echo "Kernel: " "$KERNEL"
 echo "Architecture: " "$ARCH"
 echo "Compiler: " "$CC"
 echo "CFLAGS: " "$CFLAGS"
 echo " LDFLAGS: " "$LDFLAGS"
 } #Diagnostic output

 # 12 Continuous Integration
 function ci_mode { # CI  mode functions
 echo -   e "\nRunning in CI mode (suppressing prompts and verbose logs)...\n"
  set  +euo pipefail #Turn it off in this specific function.
 } # CI support function

 # 14: Interactive Menu and 15 : Reporting
   function menu { # Interactive Menu
  select opt in "Configure" "  Build " "   Test" "Package"    "Diagn ose"     "Exit"

   do case $ opt in
    Configure)  log_messa   ge INFO: " Configuring project. "; #Configure  project. Implement the Configure command
    ;;

    Build) log_    message INFO:   "Building project.   "; #Build project
     build #Execute the build functions
    ;;

    Test)   log_    message INFO:  "Running tests...  ";//Test command
     test #Execute test functions
    ;;

    Package)       log_    message INFO:  "Packing project.  ";// Pack
    package #Execute the package function
    ;;

   Diagnose)   log message INFO:  '  Diagnostic output...';    #Diagnostic output function
      diagnose #Execute diagnostic outputs
    ;;

    Exit)    break # Break
     ;;
     *)
       echo     "Invalid    selection .";
   esac done #End of case selection loop
}   #Function Menu


 if [  $#  -   eq   0 ];  then
   menu  # If there's nothing in command arguments execute
   fi

 echo "Script finished ."

 exit 0 # Exit
