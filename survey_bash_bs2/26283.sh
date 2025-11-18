#!/bin/bash
__all=false 			  # Suppress uninitialized warning. This is a trick to ensure that we are not trying to use the value. It's not a real "flag."
set +x
echo "--- Initializing System and Setup--- "
echo $( date ) # Add timestamp.
# Initialize the log and config dirs, create the directories only on failure.
mkdir -p log &&  touch log/status || fail
mkdir -p bin || true # bin should exists already.
mkdir log/build && touch log/.build 

set +e 

if [[ ! -r /etc/mtx.conf || "`/usr/bin /sys/config mt -s -d`" ]]; then echo ""; else echo "Warning: System security configuration is in place." >> log/build/system.log; exit; fi


#Detect OS type.
OS=$(uname)  
if [[ -x /usr/bin ]]
then 	 
	echo "OS detected as $OS"
fi

ARCH=$(uname -m 
)
CPU=$(nproc)
MEMORY=$(free -m)
echo "ARCH=$(echo ${ARCH})"
export ARCH 

CPU_COUNT=$CPU
 MEMORY_SIZE=$MEMORY
export CPU_ COUNT
export MEMORY_SIZE


#Essential Utilities check.
for cmd in `uname awk | sort uniq | grep -v "awk"`
do 
	  test -x "/usr /bin/$ cmd" 2&> /dev  null || die "ERROR: $cmd is missing."
done
 

 #Normalize paths.  This is important.
 PATH="/usr/local/bin:/usr/ bin:/bin"
export PATH
 LD_  LIBRARY_PATH="/usr /lib:/lib"
export LD_LIBRARY_  PATH 




# Compiler and Toolchain Detection ---
  
echo " --- Detecting Compiler  and Toolchain --- "
COMPILERS=("gcc" "clang","cc","suncc","acc ","xlc","icc") 
LINKERS  =("ld") 
ASSEMBLERS=("as ")
ARCHIVERS=("ar","ranlib") 


DETECTED_COMPILER  = ""
 
 for compiler in"${COMPILERS[@]:0:1 ]" # Iterate just over the first entry for now. More later 
 do 		 	 
 	command -v "$compiler" > / dev/null && 
	DETECTED_COMPILER="$  compiler" 
 	echo "Detected compiler: $DETECTED_COMPILER"
    break   
 done 
 if [[ -z "$DETECTED_COMPILER" ]] 
 then 	  die "Error:  No suitable compiler detected"  
 fi 


 # -- Config & Build System Flags --
 CFLAGS=""
 CXXFLAGS=""
 LDFLAGS=""
 CPPFLAGS=""

case $OS in
   AIX)
	 CFLAGS="$CFLAGS -D_AIX"
  ;; 
   IRIX)
      CFLAGS="$CFLAGS -D_IRIX"
      LDFLAGS="$LDFLAGS -lm" 
   ;;
   HP-UX)
       CFLAGS="$CFLAGS -D_HP_UX -fno-strict-aliasing"
      LDFLAGS="$LDFLAGS -lmp" 
   ;;
   Solaris)
    }CFLAGS="$CFLAGS -D_SOLARIS"
  ;; 
    *) 
	 CFLAGS="$CFLAGS -D__LINUX__ -Wall -Werror -O2 -fPIC"
 	}LDFLAGS="$LDFLAGS -pthread -lrt"  
	 } 

 	export CFLAGS
 	export CXXFLAGS
 	export LDFLAGS 
 	export CPPFLAGS  

   
 

# Header detection and library paths 
 echo " ---Header & Libaries Detections---"

 test "./missing-header.c" -a "./missing-lib.c" -a "$(echo $LD_LIBRARY_PATH )"   #Quick safety checks, to exit even when there's something obvious to prevent build from continuing with incorrect setup.  If they're not created, something else happened earlier in initialization

 if ! cmp -s ./missing-header.c "generated_headers.c" && diff -u  ./missing-header.c "generated_headers.c" > log/generate-headers.diff && echo  $(cat  "generated_headers.c" |head) >>  log/missing-headers.result  

 then

    	die "Headers are  not correct or have failed during testing"
  fi


echo "System Header Detection complete"



# Utilities Check  

  

   
 # Filesystem  Validation

   
 echo "Filesystem validation"


  

   
 

   
echo "All system tests completed "



 echo " --- Utility Check and Detection  ---"  

echo ""


 

# Building  & Compiling ---

echo " -- Starting Build--- " 

#Testing the compilation
 echo Linux build

if [  ${COMPILERS[0]} -gt " gcc " ]   
    then echo gcc   $CXX  " -O3 $ CXX  FLORS" |tee --  - a > log.c || exit 
else echo g++ 		 "    -O3 "   $   "  FLORS"" |   tee  -->   -a    >>	 log	.c 

	 
  	
    exit   

	   fi
    



#Cleanup 
 	

exit 0