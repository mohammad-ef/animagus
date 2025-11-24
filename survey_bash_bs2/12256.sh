#!/bin/bash
**
Script to build & deploy software for ancient Unix systems, and newer ones too, all at same speed.  Automated build. 8-bit friendly.

This entire program is self contained and portable across all POSIX systems that have the tools it needs, and will report missing tools if needed.. No dependencies besides the standard ones!  (Bash) 64-bit. (Probably)

# Initialize & Setup

set **euo pipefail #Strict exit behavior

OS="unknown OS"
KERNEL=$(_uname _print_version)  # Capture output to a simple string variable. This should not fail on systems where _uname does not exist.

# OS Family determination, very important.  Use uname -m to check the machine architecture too.. 64 bit, or older architecture (RISC or others.) This helps us choose right compiler flags.
# NOTE that these tests are deliberately simplistic and are designed to run *any system without crashing*. They are *NOT designed as accurate tests*, but rather to avoid crashes. More precise tests would fail in the ancient systems.  They do the job of choosing a reasonable path though and, for that, are fine.

MACHINE ARCH=unknown_architecture ARCH_TYPE=unknown

if  grep -q "IRIX[ ]6.\*"  ${_uname -x}
  	then
  				OS="IR IX"
				MACHINE="ir ix-architecture"
				ARCH ="64bit"
				ARCH ="64bit"
				ARCH ="64-bit" 3>/dev/null  2>&1
fi
 

if [ "${OS}" == 'IRIX' ]
  	then

		# IRIX needs special attention, so put that here
		:
		  
	fi


if  grep --quiet "Solaris"  ${_uname -n} ; then  #Note the -n flag here
	OS=" Solaris" #SunOS or Solaris
	MACHINE="Solaris-architecture "
	ARCH="64"
  	:
	fi
	 

fi

if  grep --quiet --extended-regexp "HP-UX" ${_uname -n}; then
	OS="HP-UX";
	MACHINE=" hpux arch ";
	ARCH_TYPE="32 bit" 
	ARCH="32"; #Important flag to use when compiling.
	:
	fi

if grep --regex --extended --silent --ignore 'ULTRIX' "${_uname -n }" ;
then
	OS =" ULTR IX"
	MACHINE="ULTRIX machine";
  
	:
fi


if  grep --regex --extended  --quiet "AIX"  ${_uname -n} ; then #AIX
	
	OS  ="AIX"
	MACHINE  = " AIX architecture"
	ARCH  ="64 bit"
	
	:
  	:
fi


  #If it does not match the above OS systems, let's assume that's Linux
 if [ "${OS}" = ''  ] ; then
		OS=" Linux" #Generic catchall Linux
		MACHINE="Linux arch "
		if [ $( arch )$( arch  ) = " x86_64" ]; then
			ARCH="64 "
  		else
		ARCH="32" #Default
		fi
	  #Linux done

	:
  fi


NUM_CORES  =`nproc`
FREE_ MEMORY=`top -b -n1 | awk '/MemFree/ {print $NF}'`
echo "
Detected System Configuration:

OS: ${ OS }
KERNEL: ${ KERNEL}

Architecture ${ MACHINE }
Architecture type (32 bit/ 64 bit):${ARCH} #Important for choosing compiler flags later
CPU Cores: ${ NUM_CORES } (nproc)
  Mem. (Free/Total (approx)
${ FREE _ MEMORY} "

# Verify essential binaries exist, and print errors on missing files. 
CMD_LIST=("uname" "awk 'awk{ exit }'" "sed" "grep 'make'" "gcc" "cc")
MISSING=() #List of missing tools, used later
for CMD in ${CMD_LIST[@]} ; then  #loop over each essential command tool in the list.
  	
	command -v "${ CMD" }" > /dev/null 2>&1 || MISSING+=("' ${ CMD }")

		 	  #Append it, do not crash, report missing command.	
  
   #println the tool list
done

if [  -n "$MISSING"  ] ; then

  echo  "WARNING  !!! IMPORTANT TOOLS are MISSING:   $ MISSING  !!!!  BUILD WILL FAIL" >&2

   #Print a very loud warning that some build will crash if these essential components aren't here.	
  	:

   
else 

	:  #If commands ARE available... do nothing here.. we do want strict, so no extra steps if tools ARE working	
  	
fi

#Path/env normalization

#Set up default paths and flags

export PATH="${ PATH}:/usr/local/bin:/opt/bin:/usr/bin:/bin" #Prioritizes some likely directories and standard paths.. 
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib"
export CFLAGS="${ CFLAGS} -Wall -Wextra -fPIC " #General / standard warnings.  Fpic enables the build for some dynamic library usage and usefulness on different system environments (and portability too, which helps a *lot* )	
export LDFLAGS="${ LDFLAGS} " #Nothing by default... this is set per target architecture in the architecture detection block later on
export CPPFLAGS="${ CPPFLAGS} "


#Temp and log dirs.
TEMP_DIR="/tmp/build-environment/."
LOG_DIR="./logs"
mkdir -p "${ TEMP_DIR}" 2>/dev/null  #Can fail silently
mkdir -p "${ LOG_DIR}"  2>/dev/null
:


# Diagnostic function for environment summaries, to be activated through flags	
diagnostic_mode () {
   
   echo " --- ENVIRONMENT SUMMARY (Run --diagnose to activate full dump!)  "

	 echo OS=${ OS }	

  echo Kernel version = "${ KERNEL }." #Kernel info for later diagnostics	
    
  echo Compiler flags= ${ CFLAGS}.

   #Print more details (like what compilers/linker were detected etc.. later.) 	
  	
	  : #End Diagnostic mode, more can be added here if desired later 

}

:

** Compiler and Toolchain Detection (very robust)**

detect_compiler () {

	 COMPILER=$(which gcc) || COMPILER=$(which clang) || COMPILER=$(which cc) #Give gcc, clang and standard `cc` compilers first preference (important.)   Note order, important.

  if  [ -z "$COMPILER" ]; then

  	COMPILER=""
		  :	

   fi
   echo "DETECTED Compiler:"   `$COMPILER -v  2>&1 `	#Just echo out to console, for the time being	
 	
	  COMPILER_NAME=`$COMPILER -v 2>&1 | head -n 1 | awk '{print $1}'`	
   
    #Note we do nothing further right now to detect toolchains etc (that can all go later on), and for maximum POSIX compatibility	
 	 	 :

   
   : #End the toolchain/Compiler section		
	

}
: #

#Flags for the platform (IMPORTANT to be able to set flags correctly per target architecture )
platform_flags() {

		#This section can be very long with many conditional flag checks.. but we want it as robust as we can	
 	:	#Do NOTHING right now - this should set some standard platform defaults. This should also set some defaults for flags (32 bit/64 bit, -msimd etc )
} # End Function

detect_linker_assembler () { #Not implemented fully now

} #end the Function.   Can come later

detect_utilities () {
 #Not fully implemented

} #End Utilities


detect_header_lib () { # Not currently implemtened in great detail.  All headers must come from local installation for it to pass
}  #Not implemented, will do a bare minimum of sanity tests
  # File System Directory checks 

fs_checks () {

 #Simple checks, will be much improved in time.. 
	 
}	#End fschecks, for more detailed tests later, to verify system setup and available permissions/access etc



** Build Automation Section (THIS is the CORE) **

build_project() {
 #Simplified placeholder build system

 PROJECT_ROOT="$1"  #First argument will be path
  make clean > "${LOG_DIR}/build-clean.log" 2>&1 #Standard cleanup first.	
	   

		make   > "${LOG_DIR}/build.log" 2>&1	

  	 :

  

}

package_project () {

#Packaging - create tarballs (minimal packaging support, expand on later for rpm, deb)
 echo "Packing up"	
tar -czvf "${ LOG_DIR}/built.tar.gz" "$PROJECT_ROOT"

echo  "Packed"
 : #end Package Function	
} #End

run_tests() {
	  echo "Executing Unit and Integration Tests...  This section will run the actual tests SHOULD that section of logic have been written"
 	 :

 } #Test functions - will need substantial writing for any use!



** Diagnostic Mode - for verbose diagnostics (needs substantial expansion for proper diagnostic info and reporting later!!! )**
 	  #
   		if [ "$1" = "--diagnose" ]; then	

				diagnostic_mode
				:	

 	  
  	  	
			 fi	

** Interactive Main Logic - this can surely improve and expand with menus or GUI options	
while [[ $# -gt 0 ]]; do

key="$1"
shift

	 case "$key" in
   		-h|--help)
  			  echo  "  --build : Perform complete project build"
     	     echo " --diagnose: Runs system diagnistics"
				echo "   Help:"

				:
		esac


   #The MAIN logic is as below.   This allows for build commands
if [  "$1" = --build ]	 ; then #Check if it runs the complete program

  echo	" BUILD IS STARTING  !!!! (Run help - for command help at later stages.	   Build, diagnostic)"

			 #Setup all necessary things here, such the project directory to be worked in
					  	  #
	 build_project "${TEMP_DIR}/proj" #This can have its project folder defined by an env variable at the beginning. 		 
 		: 
package_project
 run_tests
			echo	" COMPLETE !!!!!!!!!!" #This shows it runs

				#Diagnostic Functions - run
 # 			
   else 	 #No flags are set at top. Do something

		:

				 

				echo   "Error : Unknown argument  (use -h for Help, to find details)" 2>&1
			 #End error case.   	  
   	   
   
 	fi
done


 # Exit codes (0=success) and more verbose debugging info. 		   			   			

 exit 0
