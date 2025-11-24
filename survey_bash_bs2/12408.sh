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
 	echo "Detected compiler: $DETECTED_COMPILER " && break # Exit for loop when detected. 
done  


echo "Linker"   
DETECTED_LINKER=  
for linker in "${LINKERS[@]}" do  
    command -v "$linker" > /dev/null &&   
      DETECTED_LINKER  =  "$linker" && break  
done    

if [ -z "$DETECTED_COMPILER" ];  then die "Compiler Not Detected."   fi


# Flags -----------------------

echo " ---Configuring flags---- "

if [ "$OS" == "Solaris" ]; then  
	CFLAGS="-D_SOLARIS"  
	LDFLAGS="-Wl,-rpath='$ORIGIN'" # Needed for dynamically loaded objects
	export LDFLAGS #Export is important
	CDEBGLDFLAGS=-lc   # Add debug
else  
  CFLAGS="-g -O2"  
  LDFLAGS="-Wl,-soname" 
fi   
export CFLAGS

CXXFLAGS  ="$CFLAGS -std=c++11"
export CXXFLAGS  

# Utilities  -------------
echo "---Utility  Detect---- "
UTILS=("nm" "objdump" "strip" "ar"  "size" "msd")
for util in "${UTILS[@]}" do   
      command -v "$util" >/dev/null ||  die  "Missing $util";  
done 



#Filesystem 
echo " -- Checking Filesystems  ---"

# Defaults to avoid error message
PREFIX="/usr/local"  
test -d "/usr/local" || mkdir -p "/usr /local" || die   "ERROR cannot  create prefix /usr/local" 
   


#Build and make utility  

echo " ---Checking Builds & Making  "

MAKECON=$(which make || which gmake || which dmake)  

if [[ -z  "$MAKECON" ]];  then   die  "No suitable make utility detected";  fi   

export MAKECON #This is vital!


#Test and build ----
BUILD=yes

echo "---- Building and compiling ---"

mkdir build_output  
# Build
build_success=$?  # Save exit status


echo  --- Building
if eval "${MAKECON} clean > log/build/" || false ; then
 echo Build Clears OK > log/build.  
else   
   echo ERROR Clearing
 fi 


 # Test ------

echo "Testing ----"


 # Install ----
 
install=no 

echo ---Install

echo -- Packaging 

exit 0 
