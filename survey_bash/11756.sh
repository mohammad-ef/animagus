#!/bin/bash
#set -e #strict, exit on error. Disabled as sometimes necessary for legacy reasons, use set -u at the start
set -uo #set -u is stricter and will error on unset variable, pipefailure will exit when there is an error. set -e can cause issues when trying to catch an errors in a conditional statement, so pipefails is a bit more flexible. This will also allow us to use conditional exit codes to do specific operations that should be able to continue regardless of exit code from commands. 



# 1. Initializations, Setup, and Core Configuration. OS, compiler detection, and essential commands. 
function initialize {

  OS=$( uname )$
  ARCH=$( uname -m )$
 
  # Essential commands check (robust for older systems)
  CMD_CHECK=$(  command -v make >/dev/ null ; command  -v cc >/dev/null ;  $OS &&  command -v awk >/dev/null)
     
  echo "Running on $OS,  kernel: $(uname - a) architecture: $ARCH "
  [ !  "$CMD_CHECK" ] && echo "ERROR: missing commands (make, cc, awk). Script Aborted. Check installation" && exit 1 #exit script if make, cc or awk missing

  # Create temp directory, and the logs directory, and logfiles 
  mkdir -p "$TMPDIR" / tmp /logs
  
  LOGFILE="$TMPDIR /build.log"
  SUMMARY="$TMPDIR /config. summary"
  mkdir -p  "$TMPDIR"/ logs
}

# 2. Detecting Compiler and associated build utilities
 function detect_compiler {

 local compiler
   compiler =$( command -v cc )  # default compiler if not detected
   if command   -v  clang >/dev/null;   then compiler="$ ( echo $ {compiler}   | grep - oE "clang" | head - n 1 )" # use clang if it is the highest in priority and detected   
   elif    [ "$( echo $ {compiler}  )| grep - q -E "suncc"     ]"; then     compiler="suncc"  # for Solaris, HP and other systems  
   elif  [  "$ { compiler  }| grep - q -E gcc "     ];  then compiler="$ {compiler }"
   fi #if compiler  

 echo "Compiler detected: $ compiler"
 echo "Compiler location:  $ { compiler  }"
 echo  "Compiler version:  $( { compiler  } --version )" # attempt at extracting the compiler version
}

#3. Compiler flags based on system.
function configure_compiler {



  case  "$ {   }OS"     in
  AIX)
    CFLAGS="-g -O2 -D _AIX " # add aiix flags and optimizations
      LDFLAGS="-lposi -lrt " # add libraries required for aiix
    CXXFLAGS="${CFLAGS  } -fPIC" # set up cross compile flags, for cross compilations. This allows us to cross build for a variety of systems
    ;;  
  HP-UX)
    CFLAGS="-D hpux -I/usr/include -g -O2"
    LDFLAGS="-lposix -lslib $ { compiler } -lthread   " # add library flags to the build process to use thread and posix functions
  ;;

  Solaris)
    CFLAGS="-I$ {SYS}/incl -Dsolaris -g -O2" # set system flags as appropriate with the compiler, and include Solaris libraries to allow it to compile. This helps the compiler locate the libraries it needs to build the application.
    LDFLAGS="-lsocket   -lnsl -lposix -L$ {SYS}/lib " # set Solaris build flags as appropriate and link to necessary libraries. The -L option will tell the linker to look in the given path for library files, which can be helpful in resolving link errors.

  ;;
  Linux)

   CFLAGS="-g -O2 -D_GNU_SOURCE  "# GNU and system flags 
    LDFLAGS="-pthread -lrt -lm "
    CXXFLAGS="${CFLAGS} -std= c++11 -fPIC " 

  ;;
  *)
   CFLAGS="-g "
    LDFLAGS="-lposix"
    CXX  FLAGS="-std=c++11"
  ;;
  esac    #configure  compiler  

}

#4. System Header and Library Detection (Robust)
 function find_essential {

 echo "Detecting Essential Libraries and Headers"

 if ! $ { compiler  } -c -o /dev/null -  <<EOF >/ dev/null 2>&1
#include <unistd.h>
#include <sys  /stat.h>
#include <sys  /mman.h>
#include <string.h>

EOF
     then   echo "ERROR: Cannot verify unist  d and system headers. Script Aborted."  && exit 1
 fi

 echo  "Headers found."


 find_library libm
 find_library lib pthread
 find_ library libnsl
 find_ library lib  socket

}




function find_library { #find libraries, robust to system
 local libname=$1
 liblocation  = $(ldconfig -p | grep "\$ { libname  } " | head - n   1 | \
 awk '{print $4}' 2>/dev/null)

 if [ -z "$ { liblocation  }" ]; then
   echo "Warning: Library \"$ { libname  }\ " not detected automatically."
 fi
 echo "Location of $ { libname  }= \   $ { liblocation  }  " # echo the library that was discovered to the console.
 export LIBPATH="$ { LI BPATH  }  :\   $( echo $ { liblocation  } | sed 's/\.so.*$//' |  sed 's/\.sl.*$//' )"
}


#5. Utility and Tool Detection (Robust, with fallback) 
function detect_utilities {

 echo "Detecting Utilities"

 for  tool in nm "objdump" "strip"   "ar" "size" "mcs" "elf dump" " dump";   do
 if ! command -v "$tool" > /dev/ null ;      then
  echo " Warning tool '$   tool' missing, using alternatives if available"   
  continue
 fi
 echo " Utility '$ {tool}   ' detected"
 done
}

# 6: Filesystem and Directory Checks.
 function check_filesystem {
  echo "Checking Files System"  

  for   dir in /usr / var /opt /lib /usr/lib /tmp / etc ;   do #check for essential directories
   if ! $ { compiler   } -d $ { dir  } > /dev   /null 2>&1 ; then
    echo " WARNING: Directory '$ { dir  }'  not accessible. May cause build problems ."
   fi
  done
    
 echo "Filesystem checks complete." # echo the completion
}   

# 6 Build System and Compilation
 function build {
   
  local  makefile=$1  #pass the location of the make file from the argument, and assign the value to variable makefile
  [ - z "$makefile"  ] && echo "ERROR: No Makefile provided for build " && exit 1
  echo "Building using make with Makefile: $ {makefile} "

      make -j$(nproc) -f "$ { makefile }"
 }


# 7: Cleaning, Rebuilding, Distcleaning 
function clean_build {
 local build_target=$1
 [ $ { build_target  } -eq 1 ] && echo "Building Project " && build "$ {PROJECT_MAKEFILE }"
 [ $ { build_target   } -eq 2 ] && echo "Running Distclean " && make distclean
 [ $    build_target   } -eq   3 ] && echo "Rebuilding Project" && build "$ {PROJECT_MAKEFILE }"
 [ $ { build_target   } -eq 0 ] && echo "No action specified." # echo the build target that will be performed, for console readability purposes
}

#8 Testing
function run_tests {
  echo "Running Tests"

  if command -v val  grind > /dev /null ; then
   echo "Using Valgr  ind for mem  ory leak detection"
    valgr  ind --leak -check=all --track-origins=yes --show-reachable ./testexecutable
  else  
   echo "No Valgrind found, running basic tests"
   ./testexecutable
  fi # if valgrind
}

#9 Packaging, Deployment (Simple)
 function package {

  echo " Packaging Project"
  tar   -czvf  "${PROJECT_NAME}.tar.gz" *
  cp "${PROJECT_NAME}.tar.gz" /tmp
 }

#11 Environment Diagnostics
   function diagnose {
 echo "Running Diagnostic Mode"
 echo "OS: $ { OS   }"
 echo "Kernel: $ {uname -a} "
 echo "Compiler: $ {   compiler  }"
 echo "Libraries found: $ {LIBPATH  } "
 echo "Build Path:    $ { TMPDIR   }"
}

#12 Continuous Integration
 function ci   {
  echo " Entering CI/ CD mode. Suppressing prompts, enabling verbose logging"  
}

#13 Security Integrity Checks
 function security_checks    {
  echo " Running Security & Integrity Checks..."
  find / -writable - type d 2>/dev/ null
  } # security  checks

#14 Interactive Menu
function interactive_menu {
 echo "Please select an option:"
 echo "1. Configure"
 echo "2. Build"
 echo "3. Run Tests"
 echo "4. Package"
 echo "5. Diagnostics"
 echo "6. Exit"

 select option in 1 2 3 4  5 6 ; do
  case "$option" in
  1) echo "Configuring...";;
  2) echo "Building... ";;
  3) echo "Running Tests";;
  4) echo "Packaging";;
  5) echo  "Diagnostics... ";;
  6) echo "Exiting..." ; exit 0;;
  *) echo "Invalid Option ";;
  esac
 done #end of interactive  loop

}



#25 system integration service installation. Requires root or elevated permissions
 function install_service{
 echo Installing services. Root required
 }

#Initialize and execute the function
initialize

detect_compiler

configure_compiler

find_essential

detect_utilities

check_filesystem


PROJECT_NAME="myproject"  # replace with your project's name
PROJECT_MAKEFILE="Makefile"  #  location for the main  makefile for  project, change the value as per need 

if [ - z "$PROJECT_NAME" ] && [          -z "$PROJECT_MAKEFILE  "] then  echo  "Please  assign value to Project NAME & Project Makefile  variables for execution  to proceed.
exit
  
fi
 #add interactive interface.

ci
diagnose


clean_build 2
#call to build

run_tests # test

security_checks

package   # packaged build artifact.




echo "Script Completed "   
exit 0
