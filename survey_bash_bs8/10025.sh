#!/bin/bash
#set shell options for stricter and reliable execution. This will exit on first error and fail silently when a command does not complete normally
set - euo

# Initialize Log Directory & Summary File (if they exist) and set defaults for various parameters, directories, variables. These can be overriden. Also set color codes if tput color is possible. Otherwise, disable them for monochrome systems. If tputs color function does not exist or fails to execute, disable it. Otherwise, colorize log output for better human readability. This is done for debugging and ease of maintenance.
LOG_DIR="logs"   # Directory that will hold log files of build steps. 

# Log and Summary
if [ ! -w "." ]; then
  echo -e "${RED}Warning: Current directory is read-only. Creating logs in \$HOME/logs ${NC}" 
  LOG_DIR="$HOME/logs"
 fi

# Ensure log directory exists
mkdir -p "$LOG_DIR"
LOG_PREFIX=$(date +%Y%m%d%H%M%S)
LOG_FILE ="$LOG_PREFIX.log"

if [ -z "$( tput setaf 1 >/dev/null 2>&1 " )" ]; then
  # No color support
     COLOR_SUPPORT=false # Disable colored logs, since the system doesn' t supprot color output to the console terminal. If the system does not have the tput function, the logs will not be colorized and will be plain text output.
else
    # Enable color support to make build process more easily visible.
    COLOR_SUPPORT=true  # Enable color-supported logs.
  fi

# Color Codes
if $ COLOR_SUPPORT; then
  RED="\e[31m" # Red color code.
  GREEN="\ e[32m" # Green code
  YELLOW="e [33m"# Yellow color code
  BLUE="\e[34m"# Blue color code
  NC  "\e[0m"# No color
fi


#Default prefix for installing binaries
 PREFIX="/usr/local"

#Initialize PATH, LD_LIBRARY_PATH, compiler flags for portability
 PATH=$PATH:/usr/local/bin:/opt/bin:/opt  # Add common bin paths to the PATH variable in case they are required, and if the build system has dependencies on it. Add /usr/local and /opt to the PATH variable to allow programs in those directories to be executable.
export PATH

 LD_ LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/lib:/opt/lib
   export LD_LIBRARY_PATH

 CFLAGS="" # Default compiler flags are set to empty. Compiler flags are only modified when needed.
 CXXFLAGS =""
  LDFLAGS =""
  CPPFLAGS="" # C++ preprocessor flags are set to empty. Compiler preprocessor flags are only modified when they are needed.
    export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS

#--------------------------------------------------
# 1. Initialization and Environment Setup
#--------------------------------------------------

echo -e "${GREEN}System Info: ${ NC}"
uname -a

NUM_CPUS = $( nproc) #Get number of processors/cores
echo "Number of CPUs: $NUM_CPUS"

MEMORY=$( free|grep Mem:| awk '{print $2}') #Get memory
echo "Total Memory: $MEMORY"

# Check for required commands
command -v awk >/dev/null 2>& 1 || echo "Error: awk not found - exiting"

#--------------------------------------------------
# 2. Compiler and Toolchain Detection
#--------------------------------------------------

detect_compiler() {
 local COMPILER=""
  if command -v gcc > /dev/null 2>&1 && [[ -n "$GCC_VERSION" ]]; then
    COMPILER="gcc"
  elif command -v clang >/dev/null 2>&1 ; then
      COMPILER="clang";
  elif command -v cc >/dev/null 2>&1 || command -v suncc >/dev/null 2>&1 ; then
       COMPILER="cc"  #Default fallback option for systems where compiler is just named `cc`. 
   fi

 if [ -n "$COMPILER" ]; then
  echo -e "${GREEN}Detected Compiler: ${ COMPILER} ${ NC}"
 else
  echo -e "${RED}No supported compiler found - exiting${ NC}"
  exit 1
 fi
}

detect_compiler
GCC_VERSION=$( $COMPILER -v 2>&1 | grep "version" | awk '{print $3}')
echo "Compiler Version: $GCC_VERSION"


detect_linker() {
 if command -v ld > /dev/null 2>&1; then
   LINKER="ld"
 else
  echo -e "${RED}No Linker was detected- exiting ${NC}"
   exit 1
 fi
}
detect_linker
detect_assembler() {
   if command -v as > /dev/null 2>&1; then
     ASSEMBLER = "as"
   else
      echo -e "${RED}Assembler `as` not detected.  Exiting.${ NC}"
   exit 1     # exit with non zero exit code if assembly command cannot be called or not exist
  fi
}

detect_assembler
detect_archiver() {
 if command -v ar > /dev/null 2>&1 ; then
     ARCHIVER="ar"
 else
  echo -e "${RED} archiver is missing. Exiting.${ NC}"
   exit 1  #Exiting on failure as archiever is needed
 fi
}
detect_archiver
#--------------------------------------------------
# 3. Compiler and Linker Flag Configuration
#--------------------------------------------------

configure_flags() {
    case "$(uname -m)" in
        x86_64)
            ARCH_FLAGS="-m64"
            ;;
        i386)
            ARCH_FLAGS="-m32"
            ;;
        *)
            ARCH_FLAGS=""
            ;;
    esac
  

  if [[ $(uname) == Darwin ]]; then
    CFLAGS="$CFLAGS -O2 -D_DARWIN $ARCH_FLAGS"
    CXXFLAGS="$CXXFLAGS -std=c++11 -O2 -D_DARWIN $ARCH_FLAGS"
    LDFLAGS="$LDFLAGS -lsocket -lnsl -lresolv -pthread"
    CPPFLAGS="" # Preprocessor
    export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS 
  elif [[ $(uname) == Linux ]]; then
    CFLAGS="$CFLAGS -O2 -g $ARCH_FLAGS -fPIC -KPIC"
    CXXFLAGS="$CXXFLAGS -std=c++11 -O2 -g $ARCH_FLAGS -fPIC -KPIC"
    LDFLAGS="$LDFLAGS -pthread"
     export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS 
  else #Generic POSIX compliant OS, likely a *BS
      CFLAGS="$CFLAGS -O2 -g ${ARCH_FLAGS} -fPIC -KPIC"
      CXXFLAGS="$CXXFLAGS -std=c++11 -O2 -g $ARCH_FLAGS -fPIC -KPIC"
      LDFLAGS="$LDFLAGS -lsocket -lnsl -lresolv -pthread" # Default for generic systems. Might need to adapt depending.
      export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS

  fi
}
configure_flags

#--------------------------------------------------
# 4. System Header and Library Detection
#--------------------------------------------------
detect_headers_libraries() {

    if ! command -v grep >/dev/null 2>&1 ; then
        echo "Cannot locate greo, header and library testing not functional."
        return
     fi

    #Test compilation of sample to identify header existence and locations,
   cat > check_headers.c <<EOF
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdio.h>
EOF

  
   if $COMPILER check_headers.c 2> errors.txt  && grep -q "No such file or directory" errors.txt; then
        echo -e "${YELLOW}Header missing - adjusting settings...${ NC}"
    fi

 if ! command -v mmap > /dev/null 2>&1; then
   echo "Mmap utility does not exists - no mman support available"
   export  MMAP_SUPPORT = false
  else
  echo "System supports Mmap utility."
  export MMAP_SUPPORT=true
 fi

    # Locate common core libraries if possible, if the core OS does not define standard library path then this can resolve dependencies and locate core system utilities
     if [ ! -z "$LIBPATH" -a $LIBPATH ]; then
           : #Lib path detected - use this library search order instead.
       else
            LIBPATH ="/usr/lib:/usr/local/lib:/lib:/lib64"
          export LIBPATH #Export it in environment variable to resolve linking errors, if not already available in PATH, export library to allow for linking to it.

     fi

}
detect_headers_libraries
#--------------------------------------------------
# 5. Utility and Tool Detection
#--------------------------------------------------
detect_utilities() {

   for UTILITY in nm objdump strip ar size mcs elfdump dump; do
    if ! command -v $UTILITY > /dev/null 2>& 1; then
        echo -e "${RED}Error:  Utility \"$UTILITY\" is not found  - exiting. ${ NC}"
     fi
     done
}
detect_utilities

#--------------------------------------------------
# 6. Filesystem and Directory Checks
#--------------------------------------------------
check_filesystem() {
   for DIR in /usr /var /opt /lib /usr/lib /tmp /etc; do
      if [ ! -d "$DIR" ]; then
         echo -e "${RED}Warning: Directory \"$DIR\" does not exist - this might cause issues.${ NC}"
     fi
   done

  
  if [ -w "$PREFIX" ]; then
      : #prefix can be overriden, and it exists. 
      echo "Using prefix = ${PREFIX}"
    else
   echo -e "${RED}ERROR, installation destination ${PREFIX} isn't writeable! - please specify or adjust it. -  Exiting . ${NC}"
    exit 1  #Exit, and let the operator to resolve it by fixing permission or moving installation prefix directory location
   fi
}
check_filesystem

#--------------------------------------------------
# 7. Build System and Compilation
#--------------------------------------------------

build_project() {
  
  local MAKE_COMMAND= make #default is to use "make" utility to do all building and managing the build process and compiling source code modules into an application binary and executable files

 if command -v gmake >/dev/null 2>&1; then
  MAKE_COMMAND=gmake #if make doesn't execute on systems and gmake is present, then change command from the system default of  `make`. It may exist or is present on different types of UNIX. If it is not available on your system and `gmake` isn't defined it defaults to "make" utility, and this will work for almost every system out there
 elif command -v dmake >/dev/null 2>&1; then
  MAKE_COMMAND= dmake
 elif command -v pmake >/dev/null 2>&1; then
     MAKE_COMMAND=pmake # If dmake not exists or can not found, use `pmake`. 
 else : fi
  
   echo -e "${GREEN}Build command is set: ${ MAKE_COMMAND}${ NC}"
    
 #Build target for source code, and compiling modules to produce binaries, if execution target output shows a build target and is a compilation task and it is valid it executes compilation.
    $MAKE_COMMAND

   if [ $? -ne 0 ]; then
    echo -e "${RED}Build Failed ${ NC}"
     exit 1 #exiting if a critical system failure occurred in a step
  else
  echo -e "${GREEN}Build Sucessfull${ NC}"
  fi
}

#--------------------------------------------------
# 8. Cleaning and Rebuilding
#--------------------------------------------------
clean_project() {
 echo -e "${GREEN}Starting Cleanup Process  ${ NC}"
 $MAKE_COMMAND clean  # Clean command to remove all the generated source build objects for compilation
   if [ $? -ne 0 ]; then
    echo -e "${RED}Cleanup Failured ${ NC}"
     exit 1 # Exiting the program in cases it has failure. Critical step that cannot fail in a build process. This may break subsequent steps to a failed building environment, and it would lead to a system failure, on which you need an engineer for resolving such problems on production level and a lot of resources will be required in resolving each one, and they all could of be resolved from the get go and it saves time, cost and manpower, if you implement it. The best practices and principles is prevention over correction
   else
     echo -e "${GREEN}Cleanup Completed successfully${ NC}"
  fi
}

#rebuild target, if build process has failure in any steps
rebuild_project() {
 echo -e "${GREEN}Attempting Full rebuild process from zero${ NC}"
 clean_project
 build_project
   if [ $? -ne 0 ]; then
      echo -e "${RED}rebuild Failured. Unable to complete rebuild, it failed${ NC}"
      exit 1 #exit and let operator or automated tool know
    else
        echo  -e "${GREEN}rebuild successful  ${ NC}"
   fi
}

#--------------------------------------------------
# 9. Testing and Validation
#--------------------------------------------------
test_project() {

  echo -e "${GREEN}Starting validation steps of software module ${ NC}"
    
 if command -v valgrind >/dev/null 2>&1; then
      $MAKE_COMMAND test || $MAKE_COMMAND valgrind

    else
       echo -e "${YELLOW} Warning, valgrind  utility missing for debugging software! ${NC}"
      $MAKE_COMMAND test  # If not detected use a regular build testing target.   This could potentially lead to errors or bugs being overlooked in code base

  fi
}

#--------------------------------------------------
# 10. Packaging and Deployment
#--------------------------------------------------

package_project() {

 local ARCHIVE_NAME = project-$(uname -m)-$(uname -r).tar.gz
 echo "Creating Package $ARCHIVE_NAME..."
 tar -czvf $ARCHIVE_NAME  # Creates package using TAR to be deployed or packaged.
 echo  "Created  archive package ${ARCHIVE_NAME} in  / "

   scp $ARCHIVE_NAME  user@destination:/destination  # Example, you will change these. It's for remote transfer and deploy

   rsync -avz $ARCHIVE_NAME user@destination:/destination # alternative to remote deploy. You change parameters and locations

}

#--------------------------------------------------
# 11. Environment Diagnostics
#--------------------------------------------------

diagnose_environment() {
  echo -e "${GREEN}Diagnosing system...${ NC}"
  echo "OS: $(uname -a)"
  echo "Compiler: $COMPILER version $GCC_VERSION"
  echo "Libraries: $LIBPATH"
  echo

   printenv | sort
    echo -e "${GREEN}End diagnosis${ NC }"
}

#--------------------------------------------------
# 12. Continuous Integration Support
#--------------------------------------------------

if [ "$1" == "--ci-mode" ]; then
    CI_MODE=true
    shift  # Consume argument. No verbose logging during build process when ci enabled, it only shows critical messages

 else # default non ci-mode is more user and debug friend

    CI_MODE=false 
 fi

#--------------------------------------------------
# 13. Security and Integrity Checks
#--------------------------------------------------
security_check() {

 # Check if PATH is compromised by potentially bad or world writeable files and folders, if it contains anything outside
   
  # Check and prevent execution on the path to files which the operator or the process do not own

}

#--------------------------------------------------
# 14. Interactive Menu Interface
#--------------------------------------------------

interactive_menu() {
 echo "What would you like to do? \n "
 local choice=$( select "\nSelect an action"

      1 "Configure"
       2 "Build"
      3 "Clean"
        4 "Rebuild"
        5 "Test"
        6 "Package and Deploy"
       7 "Diagnose"
     8 "Exit")

case "$choice" in
  1) build_project  ;;
  2) build_project  ;;
  3) clean_project;;
  4) rebuild_project;;
  5) test_project ;;
  6) package_project;;
  7) diagnose_environment;;
  8) echo "Exiting."
    exit 0;;
esac
 interactive_menu
}

#--------------------------------------------------
# 15. Logging and Reporting
#--------------------------------------------------

log_message() {
 echo "$(date +%Y-%m-%d %H:%M:%S) - $1 " >> "$LOG_DIR/$LOG_FILE"
}

#--------------------------------------------------
# 16. Cross-Compilation and Multi-Architecture Support
#--------------------------------------------------

# Placeholder - needs expansion.  Requires setting of CFLAGS and other suitable settings based on input

#--------------------------------------------------
# 17. Recovery, Rollback, and Backup
#--------------------------------------------------
#  Requires implementing file/build artifact management for proper backup. Currently empty
#--------------------------------------------------

#--------------------------------------------------
# 18. Final Summary
#--------------------------------------------------
create_summary() {
   echo "Build Summary (stored in $LOG_DIR/$LOG_FILE)  :\n"

}

#--------------------------------------------------
# 19. Uninstallation Logic
#--------------------------------------------------

# Not Fully Implemented -- Need tracking of Installed binaries and paths, then a delete procedure

#--------------------------------------------------
# 20. Containerized Build Environment
#--------------------------------------------------
#Not Full implement -- Placeholder, will contain detection, setup , and running steps within Container and artifact exports. Currently left incomplete as requires external software such as  Container and dependencies such as Docke r or Poma

#--------------------------------------------------
# 21. Patch and Legacy Maintenance
#--------------------------------------------------

# Not Fully implemented - will require implementation

#--------------------------------------------------
# 22. Source Control Integration
#--------------------------------------------------
#Placeholder to detect existing sources control systems like `Git`,` Mercurial `, `cvs `, or similar versioning systems
#

#--------------------------------------------------
# 23. Parallel Build Scheduling
#--------------------------------------------------
#  Requires implement and integration to leverage parallel execution with the ` make command
#  Parallelism needs locking and resource synchronization and proper handling for failure cases in production environments or CI/CI environments as failure on any part or step leads to a failure.
#

#--------------------------------------------------
# 24. Release Management
#--------------------------------------------------
# Requires versioned archive build to create deploy versions

#--------------------------------------------------
# 25. System Service Integration
# Requires implementing init services
# This can vary greatly across system

# MAIN PROGRAM CONTROL
if $ CI_MODE; then

   create_summary

  else #NonCI mode. Provide User Interactive Menu

     interactive_menu
    create_summary
 fi

echo  -e "${GREEN}Completed${ NC}"
exit 0
