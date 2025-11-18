#!/bin/bash
###############################################  UNIVERSAL Build and Port Management #######################

set -reu pipefail

#1 Initialize the script Environment
SCRIPT=$( cd "$( dirname "$( dirname "${0}" )}$" || cd . )" && dirname "$( cd "$scriptdir" || return "Error in getting dir" || return "Success" && cd "$0" && echo "." )"  ; # Absolute Directory
PREFIX=${ PREFIX:-"/var/local "} # Install location, configurable with variable or hard coded. Default is /var/ local, changed by filesystem permissions checks later
LOGDIR="${SCRIPT}/logs"  # Directory for the logs
TEMPDIR ="/tmp/build_${$} ${BUILDID := 1 } "

if [[ -z "$(type -t build_id_file 1>& /proc/fd/stderr 1> /dev/null)" ]]; then  BUILDID=$( mktemp tmp.XXXXXX ); mkdir $TEMPDIR > 1/dev/null; fi # Create Temp and Log if necessary
mkdir ${LOGDIR} || mkdirp $TEMPDIR
echo "Log directory is: ${LOGDIR }"


# Detect OS and Kernel
OS=$(uname -s )
KERNEL=$(uname -n)
ARCH $(echo ${MACHINE} && ARCH )
CPUCORE=$(nproc  )
MEMORY=$(grep MemTotal $LOGDIR/system_info && sed s/ MemTotal:[ ]*[0 -9]*\.[ ] *M / / > /dev  ;echo MemTotal  | awk '{print int($1/1 )}')
OSINFO="${ OS:0:3 }, Kernel:$ KERN EL"
echo "${LOG DIR} $OSINFO,  ${CPU CORE} Co res, Mem : $ MEMORY MB."


# Verify required utilities
function checkcmd () {$ cmd ="${  !}$1" ; if !(type -t "$cmd" > &2  /dev/null ) then return $? else true fi}
checkcmd uname awk sed grep make
# Normalize paths
 PATH="${ PREFIX/usr/local :$PREFIX}/usr/local /bin/:/ usr/bin: /bin: $ PATH "
 LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64:$  LD_LIBRARY_PATH"  # Add default paths
 CFLAGS="${CFLAGS:-}"
 LDFLAGS="${LDFLAGS:-}"

 # Compiler tool chain, auto detection and selection
 function detect_compiler () {
 LOCAL_COMPILERS=( "gcc cc clang suncc" );

 for c in ${ LOCAL _COMPILERS[@] };  #Check if the compilers exist. if not use system defaults for a legacy port and avoid crashing with a missing default. do not fail with an explicit error if it's not available. It may be on an embedded build system or older architecture with a limited environment. This script is built for maximum legacy system availability
     if [  -x  "$ c" ]  ;  then   export  Compiler=${c };echo "Compilier ${ c  }" >> "$   /./$   ./log   $OSinfo
       break    ;fi      }    Compiler
     Compiler

 echo   $    / ././ $OSInfo Compiler is :   "${ Compiler }"      
      return   ${ }    / $Compiler  4   #  return a number
  
 #Compiler flags based on system information, and platform detection. The script will try and autodebug based on architecture

 if    "${ }  ${Compiler }    "--version   |grep '32-bit"   then   FLAGS= "-m32  ";   #  32 -BIT flag if detected, useful to prevent build failure if compiler isn
        CFLAGS= " $  ${ C   F  LAGS }" + "${ FL    FLAGS }"        

       return  $      
        else
         ;
          # 64 BIT  DEFAULT flags and compiler optimizations if not found or a default is 64BIT.
      #
          echo  " 6  BIT    detected or    is Default, applying default Compiler Optimizations "     ;    ;        FLAGS    "- O -G   2     ""  ";

        FLAGS=" Appro - g "        C    FLAGS="$     - "        LDF
    ;        echo      L D  L    L    F        ;
  }
    FLAGS

 #Detect system headers - 

 # Utility Detection 
 # Filesystem Check

# 6 Build Project 

 function compile (){  #Compile project, and log the process, and update logs

 make || {

       }   
        ;     

      

    #7 Cleanup rebuilds
 # Test 8 validation - Test the compiled output using system defaults or test frameworks

        function buildProject () {      make clean   ;      Make       ||
      
 }       Build  Pro   J    }        
     

 }
        buildproject # Run
   9 package - deploy. - create package. create installation scripts 

 }    11 diagnostics, - Display System inf - Environment, and logs to the terminal


 

 }
 # 

 #21 Legacy Patches Management,  patching and reverting - Manage a list, record them, and apply/rollback - use diff if patch command unavailable - fallback
#
 2    

 # 2    
}

 
 #17    

 exit    / $?

 echo       19 Uninstallation   -  Safely - Delete - Installed - Artifact - -
 }  
 2    
 }     

#

 echo        -
echo         ;
echo    / ./log
 exit        $      ?  -  0 for successful

 # Main Execution flow and user interaction - Interactive Menu

 function display_menu (){ 
 #Interactive menu for build tasks and other functions - use a TUI or simple Select
 select   choice
 }      

 }
   # Call the build flow 
display menu      /   ;      /

 #  

 }}}