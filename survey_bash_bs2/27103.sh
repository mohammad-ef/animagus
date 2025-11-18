#!/bin/bash
__all=false 			  # Suppress uninitialized warning. This is a trick to ensure that we are not trying to use the value. It's not a real declaration, but just avoids error messages from bash.

# 25 Sections in ONE script (long, comprehensive implementation of a build repository)

# ===================================================================================  Initialization ===================================================================================== =====================

set -euo pipefail #strict mode (ex: exit if command fails or pipeline fails)
# Detect system, OS kernel etc, verify tools
OS=$(uname -s 2>/dev/null | tr A_z a) # convert all chars to be lower-case so comparisons are easier in conditionals later.
MACHINE=$(uname -m 2>/dev/null)

ARCH="$(uname -m)" 

CORE_COUNT $(nproc) # get core count

MEM=$( free | awk '/Mem:/ { print $4 }' )
MEM_SIZE=$(( ${#MEM} )) 

CMD_VERIFY=" \cmd_available='$(command -v 'tool')'; if test \"\$cmd_available\" >/dev/ null;" #helper function to check for a tool (command -v tool)

cmd_available_make () {CMD_VERIFY='make' 2>/dev/null} #helper function to check for command make.
 cmd_verity_gnu_compiler () {CMD_VERIFY='gcc' 2>/dev/null }
 cmd_verify_sed (){ CMD_VERIFY=' sed' } 
 cmd_ verify_awk(){ CMD_VERIFY =` awks }


 if ! command-v make && ! CMD_VERIFY 'make' ; then echo "Required command 'make' is missing. Installation aborted";exit 1  fi # check for make
# Initialize log directories
LOG_DIR="logs"  
BUILD_DIR="build"
INSTALL_DIR="install" 
PREFIX="/usr local" # default install prefix
TMP_DIR="/tmp/build_repo"  # temporary build directory


mkdir -p  "$TMP_DIR/$LOG DIR" #ensure that both directories are created
  echo -e "\n--- System Information --- " >"$TMP DIR/$LOG/build. log" # start creating logs

echo "$ OS:$(uname -r) $MACHINE Memory:$MEM $CORE_COUNT core(s)". >> "$TMP_DIR/$LOG_DIR/build  log"
echo -e "\n--- Build Directory Structure ---" >>"$TMP_DIR/$LOG DIR/build  log"

#normalize path/environment vars
 PATH=$PATH: $TMP_DIR # prepend temp to existing
#  Export variables, ensure they're available
export TMP_DIR LOG_DIR BUILD_DIR INSTALL_DIR PREFIX ARCH CORE_COUNT OS
 #=================================================================== Compiler Detection and Flag Configuration ====================================
detect_compiler () {
 compiler=

#Detect Compiler.  Order of checking matters. Prefer vendor-supplied
#check compilers, if GNU is absent

 if command -v clang &&  [ $(clang --version 2>&1 | grep "clang version") ]; then compiler="clang"; else if  command -v gcc &&  [ $(gcc --version 2>&1 | grep "gcc version") ]; then  compiler="gcc";
 else
 #legacy compiler support. Check starting with 'cc', which will often point
 #to Sun compilers
    if  command -v cc ; then compiler = cc else echo 'Compiler could not be found'.  fi fi

    if [[ $compiler ]]; then
 # Extract versions
        compiler_version=$( "$compiler" -v 2>&1 | awk '/version/{ print $3 }') # Extract from -v outpur, version only.  Use `echo ... |awk ...`. This can work across all variants, but it needs to parse version
  # echo -e "\nFound compiler :  \$compiler $compiler version \(  \$\) " compiler  log ''  else #if a specific tool cannot be found

      else   echo -e ' No compilers were located '   ;    

        exit 1 fi }
#configure compilation Flags: -Wall  is always used
compiler="${compiler}" #make compiler accessible

case "$OS" in
     "linux") CFLAGS="-Wall -O2";  CXXFLAGS="-Wall -O2 -std=c++17";  LDFLAGS="-Wl,-z,defs -lm";;; #linux-specific
     "sunos") CFLAGS="-Wall -O2 -D_POSIX_C_SOURCE=200809L"; CXXFLAGS="-Wall -O2 -std=c++11 -D_POSIX_C_SOURCE=200809L";  LDFLAGS="-Wl,-z,defs -lnsl -lsocket";;; #sunOS specific. POSIX
    "aix") CFLAGS="-Wall -O2 -D_POSIX_C_SOURCE=200809L"; CXXFLAGS="-Wall -O2  -D_POSIX_C_SOURCE=200809L -std=c++11"; LDFLAGS="-Wl,-z,defs -lnsl -lsocket";;;
    "irix") CFLAGS="-Wall -O2 -D_POSIX_C_SOURCE=200809L";  CXXFLAGS= "-Wall -O2  -D_POSIX_C_SOURCE=200809L -std=c++11";  LDFLAGS= "-Wl,-z,defs -lnsl -lsocket";;; #older irix
   "hpux") CFLAGS="-Wall -O2"; CXXFLAGS="-Wall -O2  -std=c++11";  LDFLAGS="-Wl,-z,defs -lnsl -lsocket";;;  #HpUX.
   "ultrix") CFLAGS="-Wall -O2";  CXXFLAGS= "-Wall -O2 -std=c++11"; LDFLAGS="-Wl,-z,defs -lnsl -lsocket";;;   #old ultraix - likely no standard
   "freebsd" ) CFLAGS="-Wall -O2";  CXXFLAGS= "-Wall -O2 -std=c++11"; LDFLAGS="-Wl,-z,defs -lnsl -lsocket";;;
   "macos") CFLAGS="-Wall -O2"; CXXFLAGS="-Wall -O2 -std=c++17";  LDFLAGS="-Wl,-z,defs -framework Cocoa";;; #MacOS - frameworks. This would not work everywhere (e.g. Sun).  
     *) CFLAGS="-Wall -O2"; CXXFLAGS="-Wall -O2"; LDFLAGS="-Wl,-z,defs -lm";;;
esac

export CFLAGS CXXFLAGS LDFLAGS CPPFLAGS  # Make variables globally avail
 #========================= Library/ Header Detectors. (Essential, particularly on old variants).========================

detect_header_library () {

   echo 'detecting library dependencies'.  >> $TMP_DIR/$LOG DIR/build log'
  if !  test -f test.c; then
        cat >test.c <<'EOL'
    #include <stdio.h>
   #include <unistd.h>
    #include <sys/stat.h>
  #include <sys/mman.h>
      int main(){  return 0;  }
EOL

     echo' test compiled ' .   >> "$TMP_DIR/$LOG DIR/build log"  
  
#  gcc $CFLAGS test.c fi; 
   #Check header availability

 if [[ ! -f unistd.h ]]; then
     echo  Error -  unistd header unavailable
 fi if [[ ! -f sys stat h ]]
      { echo "Error, missing  s/stat head  r " fi } fi

    fi

 #detect libraries using linker flags
 }
 #======== Tools Utility detection ========
verify_tool () {
 tool_needed=$1  command  --  verifies  that $ tool exists . If $ tool isn  not, exit
    local cmd=$tool; if command  --   verifies --    verifies   --
     then echo "$  is av   aiilable." fi   } else exit1

#  ======== File / dir verification ===== ==== ===== ===== ====
#  Verity files system directories
validate_file_dir(){

   checkdir="$1 "   echo Checking if   checkdiir   exists  echo  -  " $  exists "  $ checkdir if

   echo  Check dir   exists . There is error

 }  #==== System information output ================ ===== ===

#Print detected values.
   
print_system_info

   } else echo Error

 }
    }



 #======== Cross compile detection ====
detect_host_target()

  {   local  _HOST=$( uname --host) echo  _ host
    echo -_ host   echo Host Target   $
    local  _TARR=   local

      echo Host target  $_target }   # ================  Testing /Valgrind
run_tests() { echo Testing.  >
      test   "

#=====   Optional gpg  sign
 #==== = Packaging &Deployment  = == ==== ===== ========

 #  ==== Continuous   CI Mode  ====================== ============= =======
detect Ci Mode (){ if[[   "-  -  ci  ci mode "    ]]  
  } else   exit   }   ) }    ;
} else    #=====Security and Integr   = ==== ====== == ========  } #===== interactive   ====   }  ==== Logging & report

print  all info detected in build.log   echo exit
 #==== Final summary and clean exits  =============
#Need a way  of cleaning if needed system
clean (){

   test "
 #========
# =

#  ================  Main build  ======================= ===
detect  -Compiler () { detect

}detect system info
if
detect Ci

}

print

if [[ "   $  $   is
callable    ] ] ;then  
      call it.   echo No compile
#========
echo   
echo
}   if    $    
    detect system  Info

#  

    print System   information

detect compiler
detect_headers libraries   

# Run
test.    
if  

    detect ci Mode.  #

detect system  information  print.      system information    

echo exit  1  else  run tests  echo  
# =

if run test    

build

    

    if   
      

}

exit  }
detect compiler  # Run build steps

detect
system  Information # run system diagnostics
exit.0