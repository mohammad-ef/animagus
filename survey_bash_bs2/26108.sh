#!/bin/bash
## A Universal Unix Building System

# Exit on any uncaptured error, treat pipes as commands (if fail then error, exit immediately when an issue occurs).  Use -O as the most common setting and prevent errors by exiting.
set +x # Disable xt race, only for demonstration purposes in a production script disable it with a comment or line set -x at the end.
[ $EUID -aeqe  `who am i > /proc` -z "$PATH /proc"]
set  -eux pipefail 


# Initialize log directories: /var, /tmp are checked to verify the script is being invoked from root/admin.  
set +ex
[ "logs -d $HOME" == "$HOME/log -d $HOME/$logs" || -d logs ] 
set -e -x
mkdir -p $HOME/.build || mkdir -m  `find /var  /opt  ` || :
log  "$HOME$/.build  log.  "

LOG_DIR=$HOME /. build
tmp_ DIR= ${log_ DIR}/tmp
LOGS=$  $ HOME/. build/ log.  
PREFIX=/opt  /app 
INSTALL= install

# 1. Initialization

# Detect environment
OS  = `uname` 

ARCH  =${MACHINE}

NUM  `cat $HOME/cores -d cores || echo 1
  `


echo  "Building environment"  " $ ARCH  " " ($NUM CO  res)."

## Detect the existence of core directories and verify if writable, if they don't exists make a temporary folder to prevent error messages during runtime.
#  
set +ex
[  "tmp -d $HOME" == "$HOME/log -d $HOME/$logs" || -d logs ] 
set -e -x
mkdir -p $HOME/.build || mkdir -m  `find /var  /opt  ` || :
log  "$HOME$/.build  log.  "

LOG_DIR=$HOME /. build
tmp_ DIR= ${log_ DIR}/tmp
LOGS=$  $ HOME/. build/ log.  
PREFIX=/opt  /app 
INSTALL= install

# 2. Compiler and Tools
  
COMPILERS=( `comp  ` `cc clang`)
  LINKERS=('ld')  # Add default
  ASSEMBLERS=('gas')  # Default 
ARCHIVERS =( `ranlib`  `ran  lib)

detect  _COMPILER
  # Compiler flags
CFLAGS=""
CXXFLAGS="" #fixme
  LIBS =" $LIBS" 	


# 3. Headers/ Libraries

detect_HEADER
  locate_library

  DETECT _TOOL

  CHECK_SYSTEM _PATH  " $PATH"  # Add default
  detect_FILE
  detect_permissions

  BUILD 	_ SYSTEM # Build with defaults for all.  FixMe

# 4. Build and Test 


# Test 		- 

	BUILD	 			# Test -

	BUILD  INSTALL #Test
  	INSTALL_ TEST #fixme	 		


	BUILD 	_SYSTEM 

  PACKAGE #fix -me


	DIAG 	#Diagnostic	 -
	RELEASE #fix  - me



  # 18. Rollback 
	ROLL_ BACK

	#19. Uninstallation - fixme	  
	REMO 					# Uninstal -

	BUILD 							# Uninstal -
	BUILD	_ SYSTEM 			# Diagnostic  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 

	BUILD 	_SYSTEM
  
	RELEASE #fix  - me

	#22 Source Control
	detect SOURCE  CONTROL


	FINAL 							# Uninstal -
	BUILD	_ SYSTEM 		

	#23 Parallel 		-

  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 
	
BUILD  INSTALL #Test
  	INSTALL_ TEST #fixme	 		


	BUILD 	_SYSTEM 

  PACKAGE #fix -me


	DIAG 	#Diagnostic	 -
	RELEASE #fix  - me



  # 18. Rollback 
	ROLL_ BACK

	#19. Uninstallation - fixme	  
	REMO 					# Uninstal -

	BUILD 							# Uninstal -
	BUILD	_ SYSTEM 			# Diagnostic  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 

	BUILD 	_SYSTEM
  
	RELEASE #fix  - me

	#22 Source Control
	detect SOURCE  CONTROL


	FINAL 							# Uninstal -
	BUILD	_ SYSTEM 		

	#23 Parallel 		-

  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 
	
BUILD  INSTALL #Test
  	INSTALL_ TEST #fixme	 		


	BUILD 	_SYSTEM 

  PACKAGE #fix -me


	DIAG 	#Diagnostic	 -
	RELEASE #fix  - me



  # 18. Rollback 
	ROLL_ BACK

	#19. Uninstallation - fixme	  
	REMO 					# Uninstal -

	BUILD 							# Uninstal -
	BUILD	_ SYSTEM 			# Diagnostic  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 

	BUILD 	_SYSTEM
  
	RELEASE #fix  - me

	#22 Source Control
	detect SOURCE  CONTROL


	FINAL 							# Uninstal -
	BUILD	_ SYSTEM 		

	#23 Parallel 		-

  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 
	
BUILD  INSTALL #Test
  	INSTALL_ TEST #fixme	 		


	BUILD 	_SYSTEM 

  PACKAGE #fix -me


	DIAG 	#Diagnostic	 -
	RELEASE #fix  - me



  # 18. Rollback 
	ROLL_ BACK

	#19. Uninstallation - fixme	  
	REMO 					# Uninstal -

	BUILD 							# Uninstal -
	BUILD	_ SYSTEM 			# Diagnostic  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 

	BUILD 	_SYSTEM
  
	RELEASE #fix  - me

	#22 Source Control
	detect SOURCE  CONTROL


	FINAL 							# Uninstal -
	BUILD	_ SYSTEM 		

	#23 Parallel 		-

  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 
	
BUILD  INSTALL #Test
  	INSTALL_ TEST #fixme	 		


	BUILD 	_SYSTEM 

  PACKAGE #fix -me


	DIAG 	#Diagnostic	 -
	RELEASE #fix  - me



  # 18. Rollback 
	ROLL_ BACK

	#19. Uninstallation - fixme	  
	REMO 					# Uninstal -

	BUILD 							# Uninstal -
	BUILD	_ SYSTEM 			# Diagnostic  

	CHECK  # Security  & Integrity
  
	FINAL	 _SUMMARY #Summary 		- 

	BUILD	  					
	BUILD  INSTALL 
	
detect_COMPILER () {

	COMP  = (`which ${ COMPILERS[0] }`)

}

detect HEADER (){
	echo "Detecting header files"
	echo "Compiling a small test to check for necessary headers."
  
	test -x "gcc" -o 'gcc -c check_headers.c -o check_headers.o > /dev/null 2>&1' || exit 1

}

detect FILE (){ 
	 echo "Checking the existence of critical files & directories" 
	 check_dir "$PREFIX "
}
detect_permissions(){
	 echo "Checking permissions and writable prefixes..."
  	 
}  
CHECK_SYSTEM _PATH(){ #check_path
	echo "Verifying paths."

} 
detect SOURCE  CONTROL() {
		 #check Git or others

}
ROLL_ BACK(){ 
#rollback logic, implement if possible - not critical

} 
PACKAGE (){
 # packaging - 

}
DETECT _TOOL(){

#detect toolchains - fix? - Implement? -  critical, 
  # Check system tool

}

FINAL _SUMMARY (){ 
  
  #Summary

}

check_dir(){
	echo 'Testing permissions to install to ' `dirname`
  
}
check PATH {
    Echo 'Checking path...'
	echo 'Adding /home/.build ' `find .build $ PATH/ /tmp/  $PREFIX/$
 

}
BUILD  INSTALL #Test
INSTALL _ TEST  


}

echo 'done building.
