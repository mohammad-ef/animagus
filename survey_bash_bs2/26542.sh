#!/bin/bash
###############################################  UNIVERSAL Build and Port Management #######################

set -reu pipefail

#1 Initialize the script Environment
SCRIPT=$( cd "$( dirname "$( dirname "${0}" )}$" || cd . )" && dirname "$( cd "$scriptdir" || return "Error in getting dir" || return "Success" && cd "$0" && echo "." )"  ; # Absolute Directory
PREFIX=${ PREFIX:-"/var/local "} # Prefix, default /var local

LOG_DIR="./logs"  MKDIR_P="$SCRIPT /tmp/temp"
if [-d  " ${LOG_DIR} "] ;then : ;else mkdir -p ${LOG_DIR} ; fi ;
temp_path =" $MKDIR _P ";

# OS info and essential checks (cross platform safe and simple checks). This part does most initial checks to safeguard. This helps reduce problems
OS=$(uname -s)
KERNEL=$(uname -r)
ARCHITECTURE=$(uname -m)

# Check critical binaries exist, return exit 0,1 if any of them not found and fail gracefully
check_command() {
  COMMAND=$1  # Get command argument to check from func parameter list passed in.
  command -V $COMMAND &>/dev/null || echo "ERROR: Command '${COMMAND}' is missing!" || EXITSTATUS=1 && exit ${EXITSTATUS}. This helps to fail on critical missing utilities.
}  # End func definition for utility validation

 check_binary_check="true"  
 check_command "uname make gcc"
 

# Normal path and library, flags. If they don't exist it will set the standard ones
PATH=${PATH:="${PREFIX /bin : ${PREFIX }: . }"}
  LIBPATH=${  LIBPATH:" $PREFIX/ lib"}

LD  LIB_FLAG ="LD_LIBRARY_PATH"

# Create summary file
CONFIG_ SUMMARY="${LOG_DIR}/config.summary.txt"  ; # Config summmary file

 echo "System Info:" >>"${CONFIG  _SUMMERY}"
echo "OS: ${ OS} Kernel: ${KERNEL  } Architecture:${ ARCHITECTURE} CPU Count:  \
$( nproc) Mem Free: \
 $(free-m|awk '{print \$ 6}') ">>"${ CONFIG _SUMMERY}"
echo "Script Path: ${  SCRIPT} LOG Dir ${LOG_DIR}  ">> "${CONFIG _SUMMERY}" 

if [[ $OS =~ ^(Darwin|Linux) ]]; then  # Check for Darwin (macOS)/Linux (POSIX-compatible systems) and fallback to default for others to avoid erroring out. 
 echo "Using GNU environment. Adjust flags accordingly."
  CFLAGS=${CFLAGS: -g -O2}  # Default compiler optimization and debugging flag if not set in OS specific configurations (GNU). If already defined, preserve its values.
  CXXFLAGS=${CXXFLAGS:-"$CFLAGS -std=c++11"}
  LDFLAGS=${LDFLAGS: -pthread} #  Thread flags
elif [[ $OS =~ ^(AIX|HP-UX|IRIX|SOLARIS) ]]; then  # Detect the system for more tailored compiler/link options and OS-Specific libraries to ensure proper linking on rare UNIX
 echo "AIX, HP-UX or SOLARIS environment. Using native environment. Check for flags."
   # Define platform-specific compilation flags here or load them
    CFLAGS=$CFLAGS -D_SGI_
  else
   echo "UNKNOWN system -  use the flags & compiler that exists in the environment to proceed "

  fi  
export CFLAGS CXXFLAGS LDFLAGS LIBPATH PATH

 #2 Compiler detection 
# Check the most popular, if found
 detect_compiler() {  
  local COMPILER=

  if command -V gcc &>/dev/null; then
     COMPILER="gcc" ;echo "${  SCRIPT} - compiler = GCC"; ; exit  # If the flag set
   elif command -V clang &>/dev/null; then  
      COMPILER =" Clang ";
   echo "${SCRIPT} -- compiler clang  detected." 
      ; exit;  #  Set Flag if available, exit to stop looking after detecting.
  elif command -V cc &>/dev/null; then 
       COMPILER = "  default  compiler  ( cc)"; # This can often be Sun or older compilers on other architectures like SGI-IRIS or Ultrix
  
  fi   # end  compiler checking.    If a valid one,  store the variable for compilation

 }   #   detect compile function END; # This ensures compiler selection

 if command -V gcc &>/dev/null || command -V clang &>/dev/null;then

   DETECT ="Compiler  detection was a  SUUCCEE S S!"; else
   DETECT=  "  compiler was no found"

   echo ""

   exit ;		  
   echo $DETECT 

  fi

echo ${   DETECT};


#  detect_linker & detect_asm and ar & ranlib NOT needed since the default will do
  
 #  System  library check, using compilation
system_lib_detect() {

 echo $#
  local file="checklib.c" cat >"${tmp_path}${ file} "<<' END
  #include <unistd.h>
  #include <sys/stat.h>
  #include <sys/mman.h>
 main() {} 
END

 echo "${  DETECT_MESSAGE}; Compilation test " >> ${ CONFIG   _SUMMARY}

 $ COMPILER  "${tmp_path}">${file}  
  #if this is true
 #   $ COMPILER    --test   
}
#  4   Detect utilities (already defined, checking the command exist and setting defaults for them)



#3 Compiler flag definition (OS specific - can expand based environment variable values). 
echo -e "\n Configuring Compilation Flags..."   >>${ CONFIG _SUMMERY}


# Check directory exists or if they need be generated
if  -d "   ./build_logs/ build_dir/";then   ;
   BUILD _DI = "${SCRIPT } /build logs build_dir/";   
      else  BUILD_ DIR ="${  SCRIPT}/ build _logs/build _dir" mkdir build logs
         #End if directory is already exist

        if (mkdir "${BUILD DIR } ");

         :

   ;   ENDIF # END of Directory creation and setting up

 #   echo ${SCRIPT}.   " build directory set">>CONFIG

  echo "$build_ dir created." ;#
fi  
BUILDDIR="$ BUILD_DIR/  #
Build  Dir
"
 echo "   Setting Build_ dir as :" "${  BUILD_DIR}".  

#4 System  and Header checks - this checks and compiles simple program that can check headers for portability, in addition to linking

 #System Check  Header - Compilation
   compile " ${tmp_path  }$ {filename}"  
 #
  echo "${CONFIG   SUMMARY}. Header checks finished".  ; echo -n

 # System File System
if - d $ /usr
: # do not error

if(d $ /usr/) ;# Check /us if exists 
   else 
        :

   Fi

  ; fi # end

 #   if directory
if !   grep - q   /opt $ (ls $ { PREFIX });   # if opt
     echo "/ opt directory is  Not Defined  and will cause issues during deployment."
 else

      if   d $PREFIX  

            if    ls -ld /opt;  then echo  "/   opt directory has permissions. "  fi # check

     
         else
      ;
    END
 fi # check
   echo
 #

  ;fi


 echo "" 

exit

#################### Function  definitions
################
 function build{
    # This  function is  to handle all  compilation needs for  C or C ++ programs,
  

      LOCAL filename =$ 1
       
     LOCAL target =$ 2 
     if   [[ -n "$ filename "] ]&&[ [-n "$target"] ]];

      ; ELSE 
          ; # If not filename and target exit

   
      FI ;   

     
 echo   ${file name }. Compiling ${    TARGET} .    ">>    " $ {Config  sumry}"
 echo ${  FILENAME}. compiling "${ Target"

      ;
 }

 compile{
  

  ; echo ${    filename
 } 

 function check

 :   
; fi
 FUNC
  ; #
END; # This  end to end to define all function

 FUNCTION_TESTS

 #end
