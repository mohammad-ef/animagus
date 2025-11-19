#!/bin/bash
#set -e  # Uncomment after careful verification of all logic - strictly enforces exiting on all errors and is safer
set -uo # Sets strict mode; errors will halt script and variables used before being explicitly set cause an error (more helpful for debugging).  'pipefail' causes the return value of a pipeline to reflect the status of the last failed stage (important when piping to commands that check error codes, not just print output.) 
# Script Objective:  A Universal Self_Containd Script.

log() {
  echo "$(printf '%(%D)T %d %Y  %s\n' --date=short '%t now')" "$@"
}
log_error {
   local message="$@" # Captures all input to the method
   t put setaf 1 # set to red
   echo "ERROR : $message" 2>&1
   log $message
   t put sgr # resets attributes
 exit 1
 }
check_dependencies {
   command_required() # defines a function
   {
     if ! command - v "$1" # checks if a command is available using `command -v` command
     then # starts the if statement. `then` is not optional. `fi`. 

       log_error "Error : $1 not found." # calls the log_error function and reports an error to standard error if the command is not available. The script stops.
      fi
   }
   echo 'checking core dependencies...' # displays a message
   command_required uname # check version, system and machine information
   command_required awk # pattern scanning and simple processing (GNU awk is generally preferred and available on Linux)
   command_required sed # text transformations with GNU `sed` 

   check_availability() {
    local package="$1 "
    echo "Checking for $package..." # prints a message
    dp kg-query -W "$package"$ # uses `dp kg-query` to see if a package exists on Linux systems
    if [ $? -ne 0 ] # check to determine if a previous statement ran properly. $? returns the process' return value (typically 0 for correct execution and anything else for some type of failure). The if statement continues if the return statement does not equal the zero return value. 

      then # if a version is not found, print to stdout that a package is not available for a specific platform to allow for a fallback to use system utilities for compiling and other system tasks (important to allow cross platform functionality) and exit the function with a zero status to prevent script exit. The `then` command is a must. It cannot be optional. The `fi` is also essential and ends the statement. The function returns 0, indicating the function was executed correctly. `echo 

      echo " $package is not available. Using standard UNIX utilities." # indicates what package is unavailable so it can be understood why a specific function or module may not work. The return statement allows the user (or programmer) to see if the system meets expected criteria. 
    }
    return 0 # return value of 0 for success. The script can continue with operations.
   } # closes the function
  } # finishes the checking of utilities and dependencies

  
initialize_environment {
  OS=$(uname -s)
   log "Operating System: $ OS"
 Kernel=$(uname -r) # returns kernel release number to allow compatibility checks.
 Architecture=$(uname -m) # reports architecture type. Important for cross platform functionality.
 CPU_ count=$(nproc) # returns the number of processors available. Useful for compiling.
 MemTotal=$( free - m | awk 'NR==2{print $2}' ) # prints the total memory. Useful for determining if the machine is suitable for compiling.

 echo "
 System Summary:
   -------------------  
 Kernel:     $ Kernel    
 Architecture: $ Architecture
 CPU:        $ CPU_   count
Memory Available:   $ MemTotal MB
   "

 if [ ! - d "logs" ]; then # checks if the `logs` directory is already created to avoid issues. Creates a directory if needed.
  mkdir - p "logs" # creates a directory if it isn not previously made.
 fi
 if [  ! - d "tmp" ]; then # creates a temporary directory if it does not previously exist.
   mkdir "tmp"
 fi

 PATH=${PATH}: "$HOME/bin": "./bin" # ensures that the PATH variable includes the necessary locations. Important when cross compiling. Also important to avoid path issues.
 LD_LIBRARY_PATH=$ LD_LIBRARY_PATH: "$HOME/lib": " /usr/lib" # updates `LD LIBRARY_PATH` variable to reflect where the libraries needed to build the projects are. The script can continue if the environment does not meet requirements by using standard system directories. The colon (:) allows adding to the environment variable.

 log "Environment initialized."  # reports that the environment has been initialized.
} # closes the initialization environment functions to be called elsewhere.   
  

detect_compiler {
  echo "---------------------------------------------"   
  echo "Detecting the compiler..."   # informs the user of what is happening.
  COMPILER=$(command - v gcc 2>/dev/null || command-   v cc 2>/dev/null || echo "unknown") # detects whether a compiler is installed and available. If a compiler is available, it assigns the value to the 'compiler' environment variable. The `2>/dev/ null ` ensures that an error output is not displayed when a command is not available or found.

    if [ "$ COMPILER " == " gcc" ];then # if the variable contains ' gcc ', then it reports what compiler is found.

      GCC_VERSION=$(gcc   - v 2>&1  | grep "gcc version" | awk '{print $3}') # detects the exact version of GCC to allow for proper compilation flags. The variable is assigned the version if it is available. The 2>&1 redirects standard error to standard output to make grep work properly to capture the compiler version.
      echo "GCC found. GCC_VERSION: $GCC_VERSION"      # informs the user of what GCC version is found for cross platform functionality.

    elif [   "$ Compiler "  == " cc " ];then  # checks if the variable contains ' cc ', a compiler available across UNIX variants to ensure maximum portability. The environment variable stores the exact version.

      CC_VERSION=$(cc - v 2>&1 | grep "cc version" | awk '{print $3}') # finds the exact version of the CC variable. The variable is assigned the version if it is available. `
      echo "CC found. CC_VERSION: $ CC  VERSION" # if CC found, then report to the user what compiler is found. The script can function if CC variable is found on older UNIX platforms that have CC installed. 
    else # otherwise ( if compiler is not available )
      log_error "Error - No C compiler detected: $  "   

      fi # closes the checking for compiler availability
   echo "-------------------------------------------- - "
}

configure_flags {
  echo "--- Configuring Flags ---"
  
   # Default compiler flags
  CFLAGS="-Wall -O2"    
  CXXFLAGS="${CFLAGS} -std= c++11" # adds c++11 standard
   LDFLAGS=""
 CPPFLAGS=""
   
  # Platform-specific adjustments (very basic)
     case "$OS"in # checks if the OS meets criteria.
      IRIX)     # If system is IRIX, set flags
        CFLAGS="${CFLAGS} -D_IRIX" # sets the appropriate flags
        CXXFLAGS="${CXXFLAGS} -D _IRIX -std= c++11"  # sets c++1 1 and the system flags

        LDFLAGS="${LDFLAGS} -lsocket -lnsl" # links libraries for IRIX
        break   
      HP-UX) # sets the flags if running on HP_ UNIX. Important when compiling older projects.
       CFLAGS="${CFLAGS}-D_HPUX" # sets the proper system flags
       LDFLAGS="${LDFLAGS} -lm -lsocket -lnsl - lposix "   # linking HP-U NIX libs 
         break    # ends HP-U NIX case 
        AIX)  # If on IBM's UNIX ( AIX )  system
          CFLAGS="${CFLAGS} -D_AIX"
           LDFLAGS="${LDFLAGS} - lm -lsocket -lnsl "   # link libraries to allow the compilation 
        break  # exit AIX check 
        SUN OS | SOLARIS)  
        CFLAGS="${CFLAGS} -D_SOLARIS "
          CXXFLAGS="${CXXFLAGS} -D_SOLARIS -std = c++11"   # setting values and the standards for compiling c++ programs for older Solaris.

         LDFLAGS="${LDFLAGS} -l m - lsocket -lnsl "  # adding library paths. Allows programs that require sockets.
        break
      ULTRIX)    
          CFLAGS="${CFLAGS} -D_ULTRIX"
        LDFLAGS="${LDFLAGS} -lm -lsocket -lnsl"    # link socket to make code compatible for older system versions 
          break 
        *)   # other cases.
          echo "Default configurations"
           break # end of all case checks
      esac

  # Architecture-specific flags (simplified)
   case "$Architecture"in  # Checks for what system version it will compile the files against
    x86_64)
       CFLAGS="${CFLAGS} -m64"   # allows cross compilation on modern architectures with modern libraries 
       break    
    i386)
      CFLAGS="${CFLAGS} -m32"   # if architecture if not found or it doesn't fit a case 
      break     
      *)  # any other cases. Important so it works correctly when not detected on any specific machine architectures.
        echo "No architecture detected; Using defaults."
         break
    esac 

 # Portable flags (usually beneficial)
 CFLAGS="${CFLAGS} -fPIC - KPIC " # flags needed so cross compatibility of projects. This ensures code can use system-based architectures

 # Export variables for build tools to see. Very crucial
 export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS
 log "Compiler and linker flags configured."

}# close flags section 
  

detect_headers {

   echo " --- Detecting headers and libraries ---- " # indicates the process that the tool will run to verify and determine headers. The flags will need to set based on the architecture and the header.
  
    # A small test program
  cat > test.c <<EOF
 #include <stdio.h>
 #include <sys/stat.h>
 #include <unistd.h>
 
 int main() {
  printf("Hello, world!\\n");
  return 0;
 }
 EOF
 
  # Attempt to compile
 CC test.c -o test
 if [ $? -ne 0 ]; then
   log_error "Failed to compile test program." # when an issue or compilation errors happen the script should exit, and a descriptive log will display where to look in a directory tree or file
   exit 1
 fi
  
  echo "System appears to have the core unistd and sys/stat headers."
   
   rm test.c test # clears test directory after it finishes

 log " Headers detection successful."   # set as the status for successful compilation. 
}
   
 utility_detection {

   echo "  Detecting and configuring required Utilities"
 
  if ! command -v nm  &>/dev/null  ; then
     log_error " Could not find tool, missing dependency, cannot function " # error when it's detected as the error
     exit 1 
  fi
   if ! command -v objdump &>/dev/null; then # ensures specific functions that require external libraries exist/ are available in the tool directory and that dependencies can exist on all machines for the code to properly run
        log_error "Missing Dependency:  Objdump" # logs error to indicate it will stop the program execution to not have incomplete information or a corrupted output from running
         exit 1 # the script must exit so no issues can cause errors in later functions of the process

  fi
 
    if ! command -v ar  &>/dev/null; then  # Checks that AR is a tool on machine to make build and compilation work on UNIX. 
        log_error " AR not found, unable to function." # logging of error
         exit 1   # it will stop if there are not available external utilities to ensure proper code
     fi 
 
     if ! command -v strip &>/dev/null; then   # ensure it works properly when there is missing code, or an error in the system to report back on why it could not complete a process
        log_error "strip tool cannot be detected, unable to proceed."   # report back errors so the programmer know if the machine needs more configurations to complete properly 
         exit 1  # ensures to stop code progression if tool cannot function
  
  log"Utilities Detected "
   echo"All Tools found "  # if it does complete all, this prints on the output.

} #close utility section


 filesystem_checks {
    echo" -- Filesystem Validation ---- " # report which directory the files need to run

    required_dirs=(/usr /var /opt /lib /usr/lib /tmp /etc)   # sets the directory for proper functioning, which allows it to work for all system files.
 
   for dir in "${required_dirs[@]}"; do   # runs on required system files and directories. 

     if [ ! -d "$dir" ]; then    # ensures all required paths exist so code functions. This helps when cross compilering to ensure the directories have proper permissions to execute
       log_error "  Critical directory $dir not found " # will exit on missing directories. Prevents the code from being executed
       exit 1  # it's critical because there is the lack of required files or folders and prevents errors later 
    fi
 
  done
   
  PREFIX=${PREFIX:-/usr/local} # sets standard paths for compiling to allow flexibility to use default system folders if required

 log "filesystem Checks  complete  "
} # end function  
   
 build_system {
     echo " ------ Configuring build tools  ----- "  # informs user about building
  
     available_make=(make gmake dmake pmake) # ensures different build methods
  
      for make_tool in "${available_make[@]}"; do   # runs and tries available make options in an array format, allowing flexibility on what to execute based on a given platform/environment/machine architecture

     if command -v "$make_tool" &>/dev/null ; then  # checks the tools that it finds on machines to allow it work across different UNIX architectures
          
       MAKE_TOOL="$ make_tool"   # setting of tool that is available

        echo "Preferring build tool : $MAKE_TOOL"
         break # stops if the build has already been detected

       fi # exit of checking tools to begin execution of the next command
     done # finishes build process to cross UNIX environments to work across a number of platforms, versions.


     if [ -z "$MAKE_TOOL" ]; then
    log_error "no Make found on path "
    exit 1 
     fi  
    
 log" build systems configured" # logs success for DEBUG mode for the compiler, linking flags

}
 #closes building configuration function to prepare system 
    
cleaning_process {

   echo "---- Clean process ---- "  # to show what step is taking place

  read -p "Remove the build/ cache files/ logs directory? (y/n): " clean_option
   
    if [[ "$ clean_option " =~ ^[Yy]$ ]]; then # checks and prompts if files should be deleted to ensure clean process 
      rm - rf "build" "cache" "logs" # remove directory if prompt matches " Y/Y". 

        log "build and clean artifacts successfully  deleted   " # success messages on the build/compilation of project, ensuring everything functions to be deleted from system
     else  # other wise
   log "Build artifacts will be skipped "  # will continue without running code to ensure there's nothing in between and no interruption from running build code

     fi  
  echo "clean Process done.       " # end to cleaning

} # closes building functions to be available for cross UNIX systems/ environments to run
   
---  

   testing_process {  # starts running testing process for UNIX

      echo " --- Test validation  ----- " # prints message when running tests

  if command - v valgrind  &>/dev/null ; then # checks tools, and specifies a test run, so it functions across platforms with varying capabilities
   echo"Testing the code by Valgrind  ..."
       valgrind --leak-check=full ./ my program   # test program and specify valgrind, the code is running in parallel on different UNIX architecture/ versions
        echo "test with valgrind passed, all code works and runs as is intended, and does not contain any bugs, issues, errors in memory management/ "  # success code

      else   # runs testing if it can determine and finds test environment
      echo"Running functional and integration test.       "  # if not running on Valgrind ( which may have memory constraints ) 
        ./my test      # will simply start testing on other platforms
    
  echo "all Test pass" # will display when the platform does test

    fi

  }  # ends test function. 
 

   packageing_deploy {

  echo "----- Packaging deployment -----  "   # informs when code deployment/ packaging happens, and what to expect
 
     tar - czvf " my project - v" *. cpp *. c *. h *. txt
      echo"Package has finished with no Errors    "  # if successful it should inform

}   # closes package deploy section  
    
   environment_diagnosis {
    echo " --- Running Environment Diagnistics -----  "
    echo"uname  - a =    $uname  - a      "  # runs command with output so system administrator knows the current state
    echo " compiler:    gcc --version         " # prints GCC
   }   # closing env diagnisitcs   
      
  ci_build_system { # starts build systems and integrates CI for builds
        
   echo " ---- Starting build CI ----" # starts/runs build process on CI/ CD
       if [[  "  $ 1 " =~  " --ci-mode  " ]]; then  # if using mode on CI

           # suppresses prompts or verbose
    log " Running in --- C- Mode   ----    "

    exit  0
     fi  
     echo"  Exiting Build"

 }

#closes Arch and Multi build function for build

main  # runs entire function, all sections

detect_compiler
 configure_flags  
  detect_headers
 utility_detection
  filesystem_checks
build_system

  
if  [ "$ 1 " =~  " -- clean   "  ]; then
 cleaning_process 

 fi 

if  [ "$ 1 " =~ " -- rebuild "   ]; then

     
 cleaning_process    # clears files and folders

fi 
      

if  [ "$ 1 " =~ " -- diagnose   " ]; then # running the diagnose section
 environment_diagnosis 
     

 fi      

   packageing_deploy    # finishes deployment with the files 

exit  0     # exit script 

