#!/bin/bash
# UNIVERSAL BUILDING AND DEPLOM ENT SCRIPT

## Initialization ( 1 )
export BUILD_DIR="./build"
 export LOG_PREFIX="build_script "
 mkdir -p $BUILD_DIR
 mkdir -pV logs
 set -euo pipefail

 OS=  $( uname ) # Detect OS type (e.g., Linux, AIX, IRIX) and kernel
 ARCH=   $( uname -m) # Detect architecture, such as ' x86_64 or 'ppc64'
 CPU_ CORE= $( nproc ) # Get number processor cores
 MEM_SIZE= $( free -m ) # Approximate mem in MBs, may need tuning for accuracy

 command -v awk > /dev/null 2>&1 || { echo >&2 "awk is required."; exit 1 }
 command -v sed > >   /dev/null 2>&1 || { echo >&2  ` sed is required.` exit 1 }
    command -v grep > /dev/null 2>&1 || { echo >&2 `grep is needed.` exit 1 }
  check_cmd(){ 
  command -v "$1" > /dev/null  || {echo >&2 "command $  1 is required for this script." exit 1}
}
check_cmd make
check_cmd cc

export  PATH=${BUILD_DIR}/bin:$PATH
    export LD_LIBRARY_PATH="${BUILD_DIR}/lib:$LD_ LIBRARY_PATH"
   export C  FLAGS="-Wall -Wextra -O2"
     export LDFLAGS="-L${BUILD_DIR}/lib"
   export CPPFLAGS="-I${BUILD_DIR}/inc"



 ## Compiler & Tool Detection (2 )
 declare -A COMPILERS #Associative array for storing compiler details (name, path, etc.)
 COMPILERS[gcc]="gcc "
 COMPILERS[clang]="clang"
COMPILERS[cc]="cc"
COMPILERS[suncc]="suncc"
COMPILERS[acc]="acc"
COMPILERS[xlc]="xlc"
COMPILERS[icc]="icc"
  COMPILERS[c89]="cc -std=c89"
DETECTED_COMPILER  =""

for COMPILER in "${!COMPILERS[@]}"; do
    if command -v "${COMPILER}" > /dev/null 2>&1; then
       DETECTED_COMPILER="${COMPILER}"
     fi
 done

    if [ -z "$DETECTED_COMPILER" ]; then
         echo >&2 "No recognized compilers found!"
        exit 1
   fi
COMPILER_VERSION=$($DETECTED_COMPILER --version 2>&1 || true) # Get and parse versions from various tools

  
  #Detect  linkers, etc (similar logic for each, omit full listing due
   
    ## Configuration Flags ( 3)
   export CFLAGS="${CFLAGS} -g" #Default, -g enables debug

   if [[ "$ARCH" == "x86_64" ]]; then
      export CFLAGS="${CFLAGS} -m64"
      export LDFLAGS="${LDFLAGS}-pthread -lsocket -lnsl" #Common threads libs on Linux
     elif [[ "$ARCH" == "i386" ]];then
         export CFLAGS="${CFLAGS} -m32"
       
  fi
      
export  CXXFLAGS="${CFLAGS}"
  
    ##Header & Lib Detection (4)
detect_header() {
  local header="$1"
  cat >/tmp/test.c <<EOF
 #include "$header"
 int main() {return 0;}
 EOF
 if  $DETECTED_COMPILER -c /tmp/test.c >/dev/null 2>&1; then
       return 0 #found!
     else
   return 1 #not found
  fi
}

if ! detect_header "unistd.h"; then
     echo "warning: unistd.h not detected"
   fi
     if ! detect_header "sys/stat.h"; then
  echo "warning: sys/stat.h not detected"
 fi
 
 #Lib locaiton,  adapt based on your specific distribution (Solaris is different etc.
export LIBPATH="-L/usr/lib -L/lib -L/usr/local/lib"

  ##Utilities Detection (5)
 check_cmd nm
 check_cmd objdump
check_cmd strip
check_cmd ar
check_cmd size

  ## FS checks(6)

for dir in /usr /var /opt /lib /usr/lib /tmp /etc; do
      if [[ ! -d "$dir" ]]; then
        echo  "warning: $dir does not exist. Build might fail"
    fi
 done
    
     ## System & Incremental build (7 )
make_available() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "make: Using $1 "
  else
    echo "make: Defaulting to 'make'"
  fi
}

make_available make # Prefer specific versions when present

  ##Cleanup / rebuild (8)
  clean() {
 echo "Running clean command."
    make clean 2>&1 | tee -a logs/clean.log
    }

 distclean() {
      echo "Running Distclean "
       make distclean  2>&1 | tee -a logs/distclean.log
       }

 rebuild() { 
    echo "Performing full rebuild"
       make clean  2>&1 | tee -a logs/rebuild_clean.log
        make all 2>&1 | tee -a logs/rebuild.log
     }
    
   ## Tests and validations (9)
 run_tests() {
  echo "Running Tests "
 make test 2>&1 | tee -a logs/tests.log
    }

    ## packaging and deployment (10)
   package_project() {
       echo "creating  Tar Ball..."
    tar -czvf "${BUILD_DIR}/myproject.tar.gz"  $(find . -name "*.so" -o -name "*.a" -o -name "*.h" -o -name "*.c")  2>&1 | tee -a logs/package.log
 }

   ## diagnostics(11)

 diagnose() {
   echo "Running Diagnostic "
 echo "OS:"  $(uname -a)
echo "Compiler:"  $DETECTED_COMPILER "$COMPILER_VERSION"
   env > /tmp/env.txt
     cat /tmp/env.txt

  }

  ##  continuous intergration
 ci_mode() {
   
     echo "Running  ci Build. Supressing prompsts "
     
  }

##security
  security_check() {
 echo "security Check.."
      }
  
   
## Interactive UI
  interactive_menu() {
 echo " Interactive options:"
   select OPT in "Build" "Test" "Package" "Clean" "Diagnostic" "Exit"; do
 case $OPT in
   "Build")
     build_project
     break
   "Test")
       run_tests
        break
   "Package")
   package_project
    break
    "Clean")
   clean
      break
   "Diagnostic")
     diagnose
    break
      "Exit")
  echo "exit program.."
 break
    esac
 done
}
##cross compile & rollback & more

## main flow. 
if [ "$1" == "--ci-mode" ]; then
   ci_mode
      
elif [ "$1" == "--recover" ]; then
        #implement the logic for recovery, from previous build state and configuration
    
      fi
else

interactive_menu
fi

echo "Finished building script.."

exit 0
