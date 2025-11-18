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

for COMPILER in ${!COMPILERS[@] }
 do
 if $( $COMPILER --version > /dev/null 2>&1 )
   DETECTED_COMPILER  =$COMPILER
    break
fi
done

if [ -z  $DETECTED_COMPILER ]
 {echo >&2  "No compatible compilers found!" exit 1 }

if  [[ -n  $DETECTED_COMPILER ]]
 { COMPILER_PATH=$(which $DETECTED_COMPILER) }


  declare -A LINKERS # Linker names. Adjust for other UN*X variants
 LINKERS[ld]="ld"

if $( ${LINKERS[ld]} --version > /dev/null 2>&1 )
   then LINKER=${LINKERS[ld]}
fi
 declare -A ASSEMBLERS
  ASSEMBLERS[as]="as"
 if $( ${ASSEMBLERS[as]} --version > /dev/null 2>&1 )
    then ASSEMBLER=${ASSEMBLERS[as]}
fi
declare -A ARCHIVERS
ARCHIVERS[ar]="ar"
 if $( ${ARCHIVERS[ar]}  --version > /dev/null 2>&1 )
 then ARCHIVER=${ARCHIVERS[ar]}
fi
declare -A RANLIB_CHECKERS
 RANLIB_CHECKERS[ranlib]="ranlib"
  if $( ${RANLIB_CHECKERS [ranlib]} --version > /dev/null 2>&1 )
     then RANLIB=${RANLIB_CHECKERS[ranlib]}
fi



## Flags configuration( 3)
    case $OS in
       AIX)
           CFLAGS="${CFLAGS} -qarch=ppc64 -q64"
  LDFLAGS="${LDFLAGS} -lptk -L/opt/IBM/pti/lib64 "
          ;;

    HP-UX*)
       CFLAGS="${CFLAGS} -D_HP_OPTIONS"
           LDFLAGS="${LDFLAGS} -L/usr/lib -lhp9 "
  ;;
  IRIX*)
          CFLAGS="${CFLAGS} -D_IRIX"
    LDFLAGS="${LDFLAGS}-L/usr/lib "  ;;

        *) # Generic settings (likely Linux, BSD, Solarix etc.)
            CFLAGS="${CFLAGS} -fPIC"
 LDFLAGS="${LDFLAGS} -pthread -Wl,-rpath,\$ORIGIN" # For shared library pathing
  ;;
  esac



## Header & Lib Detection (4)
DETECT_HEADER(){
 echo "Trying to detect if $1.h exist"
   $DETECTED_COMPILER -x c -c /dev/null -include $1.h > /dev/null 2>&1
    if [ $? -eq  0 ]
   then echo "$1.h found."
  else echo "$1.h missing."
  fi
}


  DETECT_HEADER unistd.h
DETECT_HEADER sys/stat.h
DETECT_HEADER sys/mman.h


#Library lookup

locate libm.so  >/dev/null 2>&1 || { echo "Warning: libm missing.";  LIB_M=;}
 locate libpthread.so  >/dev/null 2>&1 || { echo  "Warning: libpthread missing." LIB_PTHREAD=;}

##Utility and Tool (5)
   check_cmd nm
   check_cmd objdump
  check_cmd strip
    check_cmd size



##Filesystem & directory check (6)
 check_path(){ 
 local path="$1"
    if [ ! -d "$path" ]   then  echo  "Error: $path is not accessible/exist, exiting..." && exit 1; fi
}
  check_path /usr
  check_path /var
 check_path /opt
  check_path /lib
    check_path /usr/lib
    check_path /tmp
   check_path /etc



##Build  (7)
function build_project() {

 LOCAL_SRC_DIR=$1
LOCAL_BUILD_DIR=$2
 echo "building  src directory ${LOCAL_SRC_DIR}, destination ${LOCAL_BUILD_DIR} using  make "
  mkdir -p ${LOCAL_BUILD_DIR}

   cd $LOCAL_SRC_DIR

if [[ -f  Makefile ]] then
     make -C ${LOCAL_BUILD_DIR}
     elif [[ -f  GNUmakefile ]]
    then make -f GNUmakefile -C ${LOCAL_BUILD_DIR}
else

echo  "ERROR no make or GNUmakefile present for $1  in the src. Exiting Build.."  exit  1;
fi

echo   Building ${LOCAL_BUILD_DIR} Completed

}



## Cleanup (8)
function cleanup() {
   echo "Performing Clean up"
 # Incremental Cleaning : Delete objects/binaries and .o Files
 if [[ -d "${BUILD_DIR}/obj"  ]] then rm -rf "${BUILD_DIR}/obj"}
if  [[ -d "${BUILD_DIR}/bin"  ]]  then  rm -rf  "${BUILD_DIR}/bin"}
# Remove temporary and backup build directories if they exist.

    rm -rf $BUILD_DIR
echo "cleanup Finished..."
}

## Testing(9)
   function run_tests() {

     echo "starting Tests"

 # Example - you would have more sophisticated automated unit test execution in the actual code
   echo  "Testing is  simulated"

      # Placeholder : Add proper testing execution and parsing of output from unit testing here ( ex unitTest.out  )
    echo Tests finished...


  }


##Packaging(10)
 function package_project() {
    SRC_DIRECTORY = $1
    echo put the src files and binaries here to archive them...
 #Example of using  `tar` to make tar balls. Add your logic and paths

 }



## Environment diagnostic(11)
 function environment_diagnostics() {
   echo "Environment Information "
   echo
echo    "OS "  $(uname)
   echo
    "kernel  Version:  $(uname -r) "
     echo  Architecture" $(uname -m)
   echo Compiler version "    $(DETECTED_COMPILER  --version)"
   echo

   #Dump Environment Variable for Debug: remove if not wanted..
     echo    Environment Vars  (Partial)  "     :
  export
 echo    
   export 'echo |sort'
 }



#  Containerization (20)

   function build_containerized() {
 # Check Container Support (Placeholder. Requires docker setup/detection
      echo Check Container  setup" ( Placeholder - Add Container Build Logic)"

    }

## Security (13)
    function perform_integrity_checks(){
    echo    Perform Integrity checks (Checksum verification)"(Placeholder- checksum validation )

    }


##Release Management (24)

  function create_release() {
   
    local release_version="1.0.0"
    #Generate Version Tags in git if git exist and is installed (Placeholder for real integration.)
       
echo create Release version :
      tar czvf  myProject_$release_version.tar.gz -C build .  ; echo    done



   }



#Interactive UI
 function InteractiveMode(){

 while [1 ] ; do
  echo ""
      select OPTION in  "Configure"  "Build" "Clean" "Tests" "Package" "Diagostics"   " Exit"; do
      case $OPTION in
  "Configure"  echo"Running Configurations (Not implememnted.)"     ;;
         "Build"   build_project "./src/MyProjectBuildDir";     ;;
   "Clean"      cleanup  ;;
    "Tests"     run_tests   ;;
 "Package"    package_project    "./src"      ;;
    "Diagostics"      environment_diagnostics    ;;" " "  exit   ;;
  esac
    done
done
}



if [ "$1" == "--ci-mode" ]
then
   CI_MODE=true
  environment_diagnostics

   build_project "./src/MyProjectBuildDir" #Replace
run_tests
    package_project  "./src"


 else
 #  Call Main menu for interactivity

InteractiveMode

 fi


  # Exit code
exit 0
