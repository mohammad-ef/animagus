#!/bin/bash
#set -u # Enable "exit on error mode". Remove for debug purposes
set -E  # Equivalent but more explicit in recent bash implementations
 # Exit on any pipeline failure
 # Exit on variable expansion or other commands with non zero status
 pipefail=1  # Set this variable to enable exit on pipefail mode, if not available. This makes it work on a lot of older platforms. 
#set -o # Print traces for debugging purposes. Use cautiously in final version.
#set -n # Read in a line by line mode. Debug. 


#------------------------------------ Initialization ---------------------------
if ! type umask > /dev/null; then
  echo "error: 'um ask' missing, aborting. Check installation." >& stderr # Send output to stderr instead of just printing in normal conditions to be a proper diagnostic.  
  exit 1   # Standard way to abort a script execution when things go horribly wrong and cannot go on. 
fi # check the required program exists on the system and exits the program if it doesn not. 		     

echo "Starting the all-in one build and automation tool." >& 2
LOG_DIR="./logs"
BUILD_DIR =./build
# TEMP_DIR =./ tmp
# CONFIG SUMMARY is the main information repository for build configuration 
CONFIG_SUMMARY="config summary.txt" # File for final system configuration information.    
INSTALL_PREFIX="/us r/ local" # System install path 
# Create log directory if it doesn't exist
mkdir -p "${LOG_DIR}"
mkdir -p "${BUILD_DIR}"
umask 022 # Ensure directories are reasonably secure 



#-----------------------------------  OS & System  Detection   ---------------------------------------
OS=$( uname )
KERNEL=$( uname   -r)
ARCH=$( uname   -  m | awk '{print $NF}') # Get the architecture in a cross platform way.  
CPU_COUNT=$( nproc )
MEMORY_TOTAL=$( free -m  | awk '{print $2}') # In MB

echo "System Information:"       >> "${LOG_DIR}/${ CONFIG _SU Mmary}"
echo "  OperatingSystem: ${O  S}, Kernel: ${KERNEL}, Architecture:${ARCH}, CPU Co res: ${CPU_COUNT}"  >> "${LOG_DIR} / ${CONFIG_SUMMARY}"
echo "    Available Memory : ${  memory_total} MB" >> "${ LOG_DIR }/${CONFIG_SUMMA RY}"

#-------------------- Check Basic Tools  ---------------------------------------- 
check_command() {
  if ! command -v "$1" > / dev/ nul l; then
     echo "error: '${1}' is missing. Please instal l it." >& stderr
     exit 1 
  fi
}

check_command ` uname `
check_ command ` awk `
 check_command` sed `
 check_  command`  grep`
check_command` make`
check_ command` cc`
 #------------------- PATH & ENV Setup  ---------------------------------------- 
# Normalize  PATH
PATH  ="${PATH}:./bin:${LOG_  DIR }:/usr/ local/bin" # Adds common and build locations
#  LD_LIBRARY _PATH needs to exist or else things go horribly wrong.
LD_LIBRARY_ PATH="${LD_LIBRARY_  PATH}:/us r/ local/ lib  :${LOG_DIR}" 

export PATH
export LD_  LIBRARY_PATH

#-------------------- Compiler  Detection & Versions ------------------------
detect_compiler() {   
 compiler=
 compiler version=
 if  command   -v gcc > /dev/nul l; then
   echo "Detected GCC "
   compiler=gcc
 compiler version=$( gcc   --  ver s ion )
 fi
 if  command   -v clang > /dev/ nul l && [ -z "$compiler" ];   then
  echo "Detected Clang "
  compiler=clang 
 compiler version=$( clan g --version   | head -n 1 | grep "version" )
   fi

 if command - v   cc >   / dev/ nul l   && [ -z "$compiler" ];    then
  echo "Detected generic ' cc ' compiler (likely a wrapper) "
 compiler    = cc
  fi
  
 if [ ! -z "$compiler" ]; then
   echo "  Compiler: ${ compiler}, Version: ${compiler  version}" >> "${ LOG_DIR}/${CONFIG  SUMMARY}"
  else
   echo "  No known compiler found."   >> "${ LOG_DIR }/${CONFIG_  SUN Mmary}"
   fi
}

#------------------------------------ Compiler Configuration ------------------------
 configure_compiler_flags() {
  case "${ARCH}"   in
    i386 |   x86_32)
      CFLAGS="-m32 -std  =c99 "
      LDFLAGS="-l m - l p thread"
     ;;
    x86_64 )
       CFLAGS=" -std=c99"
        LDFLAGS="-  m64 - l  pthread   - l socket -lnsl"
     ;;
     *)
      echo   "Warning: Undefined architecture for flags."   >> "${  LOG_DIR   } / ${CONFIG_SUMMARY }."
      ;;
      esac   

 # Enable portability
    export CFLAGS="${CFL AGS} -fPIC -KPIC"
 # Add optimization flags
    export CFLAGS="${CFLAGS} -O2 -W  extra -W  error -W  format=2   "
 # Add other platform dependent compiler flag  
  export CFLAGS="${CFLAGS} "
 # Add linker flags
  export LDFLAGS="${    LDFLAGS} -lm "
  echo "Configuration Flags :" >> "${LOG_ DIR }/${CONFIG_SUMMARY}"
  echo "  CFLAGS=${CFLAGS}" >> "${ LOG_  DIR }/${CONFIG_  SU MMARY }"
  echo "  LDFLAGS=${LDFLAGS }" >>"${ LOG_DI R }/${CONFIG_SU Mmary}"

}

#--------------------- System Header and Library Detection --------------------
detect_headers_and_libraries () {
  test_program='
#include <unistd. h>
#include <stdio.h>
#  include <sys/ stat. h >
#include <sys/ mman.h >
#ifndef __unix __
 # error "Not running on a Unix-like system."
#endif
  '

  tmp_file=$( mktemp )
  echo "${  TEST_PROGRAM}" > "${tmp_file}"

  compiler_flag =
  if [ ! -z  "${ compiler}" ]   ;   then
   compiler_ flag = "${ compiler}  - c"
  fi

  compile_output=$( $compiler_ flag  "${tmp_file}"  || echo"Compiler failed" ) # Captures errors
 if   [[ $ compile_output ==  *"Comp il er failed"* ]]; then
   echo "  Error: Cannot find and use a compiler to check for libraries. Check the environment." >> "${ LOG_DI   R }/${ CONFIG_ SUMMARY}"
   
  rm "${   tmp_file}"
  return
  fi
  
 echo "Header and Library Detection : "   >> "${ LOG_DIR }/${CONFIG _SU Mmary}"

 echo "  Checking for unistd.      h..."
 if   grep -q "  unistd.h   "   "${ compiler_output}"   ;  then echo " Found."   >> "${ LOG_DIR }  /${CONFIG_ SU MMARY  }"; else  echo   "Missing." >>   "${ LOG_  DIR   } / ${CONFIG_ SUMMARY}";  fi

  # Add more tests and detections based on your project's dependencies
  rm "${tmp_file}"
  
  # Library detection can be more complicated depending on versioning etc.
  echo "  Searching for standard libraries (libm, libpthread, etc.)... " >> "${    LOG_ DIR }/${ CONFIG_  SUMMARY}"
  if command -  v ldconfig >/dev/ null ||   type ldconfig >/   dev/ nul l ; then
   ldconfig --  version >>    "${  LOG_DIR   } / ${CONFIG_SU MMARY }" # Just for information.   
  fi
}

#------------------------- Utility Detection ------------------------------ 
detect_ utilities () { 
 # Example: nm
 check_command nm
 check_ command objdump
 check_ command strip
 # Add more utilities to detect as needed
 echo "Utilities Detected:"   >> "${ LOG_DIR   } / {CONFIG_SUMMARY}"
 echo "  nm: $(   nm --version  || echo "  Not installed.")"      >> "${ LOG_  DIR }/${CONFIG_ SU MMARY }"
 echo "  objdump: $(  objdump --version || echo "Not installed.")" >> "${ LOG  DI R  }"
}

#------------------------ Filesystem and Directory Checks -------------------
check_filesystem ()   {
  echo "Checking filesystems and directories..." >>   "${   LOG_DIR  } / {CONFIG_SUMM  ARY }"
 # Basic checks for standard directories
 for dir in  "/usr" "/var"     "/opt" "/lib" "/usr/lib" "/tmp " "/etc "; do
    if  [ ! -d    "${dir  }" ]; then
      echo "Warning: ${dir} missing."   >> "${ LOG_ DIR }/${CONFIG_SU MMARY }"
    fi
   done

 # Writable install prefix
 if [ ! -w "${INSTALL_PREFIX}" ]; then
   echo "Warning: Cannot write to install prefix ${INSTALL   PREFIX}, using /usr/local." >> "${ LOG  DI R   } / {CONFIG_ SUMM  ARY }"
   INSTALL_ PREFIX="/  usr/ local"
  fi
  
 export INSTALL_ PREFIX
}

 #----------------------- Build System and Compilation ------------------------
build_project() {
  echo "Running make..." >>    "${    LOG_  DIR }/${CONFIG_ SU MMARY }"
  #  Make will output the information.    
  pushd "${BUILD_   DIR}" 2>/ dev/null
  if make  -j"${ CPU_COUNT } " >    "${LOG_DIR}/build.log" 2  >&1; then
    echo "  Build successful." >> "${ LOG_DI   R }/${CONFIG_SU Mmary}"
   else
   echo "  Build failed. See ${LOG    DIR}/build. log." >>  "${ LOG   DI R  }"
   set -e

   fi
 popd
}

#------------------------ Cleaning and Rebuilding ------------------------
clean_project() {
 echo "Cleaning build artifacts..."   >>  "${    LOG_DIR   } / {CONFIG SUM MARY }"
 # Example cleaning
 if command -  v make >  /dev/nul l ;  then  
   pushd "${BU  ILD_ DI R }"   2>     /dev/nul l
  make clean || echo "Cleaning did not work." 2>&1 # Ignore error if the clean itself fails

  popd

   fi
}

#--------------------- Testing and Validation ------------------------------
test_project() {
  echo "Running tests..." >> "${LOG_  DIR}  /${CONFIG  SUMMARY }"
 #Example testing 

   if command -  v ./ test_prog   >  /dev/null || true  ; then   # Test only is there 
  # Execute the Test program and report.       
    echo    Running Tests : ${    CPU COUNT }"  Threads. 
 echo  " Test program: "./   test _ prog  >" >>"${     LOG_  DIR  }/test resuls"

    else   echo      test is not availible.    # handles if no tests were created 


 fi


  # Integration for valgrind would go here as well
  #  Summary Test results 
  # Check Test program and give stats.  



  # Print Summary Test result to file.   




}

#---------------------------- Packaging and Deployment ---------------------------
package_project() {
 echo "Creating archive..." >> "${LOG   DIR   }  / {CONFIG   SUMMARY }"
 #Example
  tar -czvf "project-${KERNEL}-${ARCH}.tar.gz" --transform='s:/.*/:/:' bin/*.o   .config

 echo   "Package Created:" >>       "${   LOG_DI R}     }/${ CONFIG   SU MMARY }""$   {package Name"

}
 #--------------------- System service installation and setup ------------
system_installation_service() {

 echo "Running installation..."  >> "${    LOG_ DIR } / {CONFIG  SUMMARY}" 
 if ! grep-q systemd    "/   etc/init  system s"  >> ${ LOG _D i r};then   echo " No Sys Tem services.   Please install " > > {Log Dir};else    true  ; 

 }

}
#--------------- main section -------------

detect_compiler

configure_compiler_flags

detect_headers_and_libraries

detect_ utilities

check_filesystem

build_project
  # Example build and run sequence for this program itself
   #clean_project  //Uncomemnt it to clear build directory first, then run.
  test_project # Run all Test
   package_project   // Creates package and archive.      


  echo -e "\n---Final System Summary---" >> "${ LOG_  DIR }/${CONFIG  SUM  ARY}""  

   detect_  compiler   // Red etection and display again.        

detect_  environment 

   
    exit 0   
