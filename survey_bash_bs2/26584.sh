#!/bin/bash
__all=false 			  # Suppress uninitialized warning. This is a trick to ensure that we are not trying to use the value. It's not a real "flag."
set +x
echo "--- Initializing System and Setup--- "
echo $( date ) # Add timestamp.
# Initialize the log and config dirs, create the directories only on failure.
mkdir -p log &&  touch log/status || fail
mkdir -p bin || fail
# Set -u to error out upon variable expansion failure and -e to error
# if commands fail. -O will cause the entire script exits.

# Set a function that errors with descriptive message. 		
 fail()	  {
	echo "ERROR at $(date) - " $1 &> log/error; exit 1	
	 }

# Check commands
command -v uname > /dev/null	 	  
if [ $? -gt	 0	  ]
	then 
		fail	 "uname utility is missing"
			
	fi
 	  
echo "Essential commands present."
# OS detection
OS=$ (uname -s	)
ARCH=$  	( uname	-m)
KERN_VERSION=$ (uname -r 	 )
CPU_COUNT=  $(nproc)
MEM_SIZE=$( getconf	_physical_pages  ) * $(getconf	 PAGE_SIZE)
MEM_SIZE=$(echo "$ (( $MEM_SIZE / (1  *1024 *102  4)))" |bc)

echo -e "\n--- SYSTEM INFORMATION ---"  	
echo	 "Operating System:" $ OS
	echo	" Architecture:" $ ARCH
echo "Kernel Version:" $ KERN_VERSION
	echo "CPU Count:" $ CPU_COUNT
	echo "Memory(GB): "$MEM_SIZE
# Normalize environment
export PATH=/usr/local /bin:/usr/bin:/bin
	export LD_LIBRARY _PATH=/:/ lib/

# Initialize CFLAGS, LDFLAGS
  
	CFLAGS  ="$CFLAGS -Wall -std =gnu99 -fPIC "
	LDFLAGS =" $ LDFLAGS -W no-unused-label"

# Initialize variables
  
	PREFIX="/usr/local"
	BUILD_DIR=" build"

# Initialize build type to release (default value)	
	BUILD_TYPE="release"

echo "---Compiler Detection---"
 	detect_compiler
	
	
 		
# Compiler detection
detect_compiler()
	{

#Detect GNU compilers.	
  	 if  command -v	gcc 	 >/dev/null
  		then
				echo  "Found GNU GCC Compiler"	
  	  			 COMPILER=gcc
				 VERSION=$(gcc -v	2>/dev/null	|head	-n 1 |sed 's/. */:/' | cut -d : -f2	 )	
				   
		elif 	command -v	clang  >/dev/null 	
			then 
  	   		 echo "Found Clang Compiler" 		
 				 COMPILER=clang 
				 VERSION=$(clang -v 2>/dev/null	 |head	-n 1|sed 's/. */:/'| cut -d : -f2) 
 			elif command -v suncc >/dev/null 	
			then 
				
					 echo  "Found SunCC Compiler" 
				 		 COMPILER=suncc 
					  #Sun C versions tend not to display well when using gcc -v 2>&1  		 
  				 VERSION="Unavailable - Sun C version not detectable "	
			else	
				  echo  "Could not find GCC compiler or similar, build might require configuration for a different architecture and environment.." 
	 fail   "gcc is  essential compiler. Ensure is  configured."  				 	
	  		
		fi	
			 
	echo  "Detected compiler $COMPILER version $VERSION."	
 		export  COMPILER

		 if  [  "${COMPILER}" =  "gcc" ]; 
	  		 then  		 
				  	 CFLAGS="$CFLAGS -m${ARCH} "	 		
				   	 	  		
  		   fi

# Check other build dependencies ( make)	 		 	
command -v make	 > /dev/null ||	fail  "GNU Make build is required -  Install or Configure it properly "		

		 }	 

# Configure Compiler and Linker flags - 			
  	 configure_flags

 configure_flags() 
 	{	

echo -e "\n--- Configuring Flags based on $OS platform ---\n"		
	  # Adjust based on OS, example: Solaris
		if  [ "$OS" = "Solaris"	 ];	
				then	 						 		 
					   		  LDFLAGS="$LDFLAGS -W no-unused-label -lm"			
		   	  			  					
		   fi		

#	Adjust the compiler flag if the build target has changed (i686 / i386). 	 	 
if	[ "${ARCH}" ==  "x86_64" ];  		 		 
			 then	 					
					 CFLAGS="$CFLAGS -m64 "			
				   			 LDFLAGS =  "$LDFLAGS -m64"			
			
  			 fi
 
  		echo	  "\nConfigured Compiler flags - $CFLAGS \n"  	
  	  		echo   " Configured LDFLAGS flags - $LDFLAGS"  
   
		 }		
   
	
# File system / directories check.						
 check_file_system	

 check_file_system(){		 	
  		echo	  "\n---  System Destinations Check--- \n"		
   		if 		 		[ -d "/usr"  ]  					  		  					
				then	 			
					 echo  "/usr  exists with proper  Permissions \n"  					
				else					 			
  				echo   "Warning /usr destination might fail. Ensure permissions or install build in alternate place  . "					 		
  		 		  	 			
  		  			 fi					

 if [	-d   "/var"  ]				
		then	
					echo	  "/var Exists \n" 					
	else 		
		echo   "Warning, ensure /var permissions. "		
				 
				 fi			
 				   		  
				   			if 	 -d   "/lib"					 		
					  	 then						
   				echo   "/lib exists \n"	
			  			 		else					 				
    			 	 		  		 				  			echo	 "WARNING : No /lib detected , this is a serious issue"  							 		
					    				   					
				fi					

 }	 	

  build_system  "ProjectMain"			

  build_system()  		{				 
	 			 		 			

local PROJECT="$1"					 	
#Detect and configure Build utility.		 
 if [   -x   /usr/bin/gmake ];		  			 		 		
 			  then  						 			
		    BUILD_TOOL ="gmake "						
					else					 				
 				 				BUILD_TOOL=" make"	
  				   			 		 				 	  	 				
  					 fi					

			echo   "Build Tool selected   "$BUILD_TOOL			 				

			cd "${PROJECT}"
					echo "Build process starting"  

 # Build with selected make. 
		   "${BUILD_TOOL}" $BUILD_TYPE

					 if  [ "$?"	 !=	  "0"	   ]	 	
   				  then
  					 echo    "ERROR : Build FAILED, See Logs. Aborting Build"		
		       			 fail    "build failed. Please check build configuration. Logs stored"   
	  				  			 fi 					 
				    echo "Building completed successfully!	Logs and status updated	. "			
				
					cd -	  

 }		

 # Perform system-specific diagnostics (OS dependent tests)			
 diagnostics	

 diagnostics()
 {			
		 echo "\n-----Running OS specific System Diagnostic Check----- \n"			

 #Detecting if the machine  runs solaris			 				 	 			 
 	  if   [   "${OS}"  ==	 "Solaris" 		];					
 			 			then	  				 		
  					  #Run some diagnostics specific to solaris				  	 		

	 fail  "Solaries diagnostics need updating "

			 fi	

 	 	# Check some of common system dependencies	

 if command -v libelf  >  /dev/null 				

  				then			
   				 echo   "ELF library found \n"  

   else
 		 	   				 		fail   "Error! libelf utility or Library needed to detect file structure "					 		 
					  fi				   					 					 		 			
}
exit	 0 # Exit successfully with 0

