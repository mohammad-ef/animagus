#!/bin/bash
# This build & management automation bash script

set +u # temporarily allows to run when some commands fails. This prevents premature exiting when checking for commands
set +o # temporarily allows to see the intermediate commands. This can help during development to understand which steps lead to which issues
set -e # exits the script on the very last error

# Global Definitions - configurable at the beginning for easier modifications
PREFIX=$( getcwd | awk 'BEGIN $1 = ""; print substr ($"/",2)');  
TEMPDIR="${ PREFIX}tmp";
LOGDIR  "${ PREFIX}log ";
INSTALL_SUFFIX="${ OSVAR := "}" ;
  # OSVAR := "" - empty string is necessary because we will not use this var. Otherwise the variable will contain the result of a command execution. 


OSVAR=$( getent system-limits || true)
ARCHVAR =$(uname -m)
CPUCOUNT  ="${nproc:}"  

# Function to check command availability
command -v _ | if true ; then return $?; exit true fi
if [[ ${ #_ != "}" ]];
  exit 2

fi

  #Initialize and create temp and log directory. Also setup environment
  _Init_Environment
  # Compile/linker detections and setup
  detectCompiler()  #detectCompiler, compiler_flags,  lib_paths
  detectLibaries  #detectLibraries

  buildConfiguration() 		
  cleanBuild  #build_project  cleanup_build
  unitTesting #run test
  packaging() 		 #build_package deploy  install package deployment to another place.  (scp or other tools to transfer the binaries to a different system.) 		
  finalReporting

  # Functions
 	 ---------------------- Initialization  -----------------------------

_ Init_Environment(){	
	if [[ -z "$LOGDIR "]];	
		LOGDIR =" ${ PREFIX}/logs ";
		echo  "Setting up initial environment variables";	  					
		  	
		echo "Prefix: ${ Prefix }"
		mkdir -p $PREFIX
		  #create temporary directory
  mkdir - p $TMP  		
	mkdir - p $LOG 	  #log location
	mkdir $INSTALL_DIR	 						 						 			
}
# ---------------------- Compilers detections  ---------------------------

detectCompiler(){  	
	_COMP  
	Compiler=" "
	Compiler=${COMP[ "GCC_COMPILER "] } 		
	Compiler  
}

  		 	
_COMP ()	
	Compiler  

	case "$Compiler  "in		
		gcc)  COMP[ "GCC_COMPILER  "] = gcc;;
		clang)  COMP[ "CLC_COMPILER "]  clang
  g)  		
		gcc  #fallback
		;; 			
	esac	
  Compiler	

# Compiler flags and paths
 compiler_flags= ""		

	case "$ARCH_ "in			
		 x86_ " 32")  compiler_flag "- 	m	  32";;			
		 x8 					
	esac

  # Libraries detection.  This is a stub, to detect standard Libraries.
 detect Libaries ()		

}

  			

# ---------------------- Utility detections  ---------------------------------- 

detect_utilities(){  		
	_UTIL		
  # Check utilities. 			
}
_ UTIL(){		
	
	  command -v nm 			nm
	command -v obj 		obj
  command - v strip		strip  					 
}


#  Build Configuration	 ------------------

buildConfiguration(){ 								
  mkdir build				
  # Build with make
	
}


  		

# Building Project
 build_  
_Build(){ 				
	echo	 			
}


# Cleaning ------------------

 cleanup
_  
_Clean(){	
  if	

} 
#---------------------  Unit Test ------------------------
 unit  Test ()

}

  	 		 
  #-------------------- Packaging
  	 	

packaging () { #package  
	echo	
  # Build tar
  # Package for deployment 	 
} #end function

final 
 _Final (){

} #end function

#----------------- Diagnostic

 diagnose (){	
	echo

}  

# Main Function

_Main (){
	
}

  
main
  _main
  _main
  
echo	  "Finished!"
  
exit	
0 	 ------------------------------------------------------------------- --------------------
# Additional sections (extended requirements -- not yet fully implemented, placeholders and stubs) #--------------------
# -------------------------------------------------------------------  

# Recovery 		 

 #----------------------------------------  Patch 				 		
# Patch	 		
# Patch	 		
# Patch	 		
# Patch	 		
# Patch	 		
# Patch	 		
# Patch	  

# Container	 		
# Cross 		 	 		
# -------------------- Service	 

  -------------------------	  

# -------------------- Security		
 --------------------------------------------------------------------
 --------------------------
 ---------------------
 ---------------------- ---------------------- ---------------------- 					
exit	 					
0
------------------- --------------------
---------------------- 						
exit  			
0
  ---------------------

``` -------------------------  --------------------- ---------------------- 			 
exit	
 0
---------------------------------------  ---	  --- ---	  --- ---------------------- 
exit	
  ---------------------------------------- ----------------------------------	  ------------------------------------  --------------------- ---------------------- 			 
exit	
  ---------------------
 ----------------------------------	  --
``` 
exit	
 --------------------------------- 
-----------------------
 

```exit 0
--------------------
 exit 0
```exit 0
 ----------------------

exit 0
 --------------------------

``` exit 0
```exit 0

```exit 0
exit	  ---------------------

``` -------------------------  --------------------- ---------------------- 			 
exit	
 --------------------------------------------------------------------
 exit 0
 -------------------------------------
```exit 0
------------------- ---------------------
 exit 0

---------------------
 
 --------------------------------- exit 0
  ------------------------------  ---	  ---------------------

``` exit 0
```exit 0
-------------------- exit 0

exit	  -	  --------------
```exit 0

```
```
exit 0
--------------------
  -		
 exit 0

---------------------
```  

exit 0
```
```
exit 0
```exit 0
 exit -			 exit -			 exit -			 exit -			 exit -			 exit -			 exit - 

exit 0

-----------------------------------
 	 	exit 0
exit 0
------------------  --
exit 0
  exit ---------------------
```  
exit 0
exit -------------------------

 exit0 exit0 exit 0

exit 0 exit  --
``` -----------------------------------------

 						
exit 1
 exit  ---------------------

``` -------------------------  --------------------- ---------------------- 			 
exit	
 0
---------------------------------------  ---	  --- ---	  --- ---------------------- 
exit	
  ---------------------------------------- ----------------------------------	  ------------------------------------  --------------------- ---------------------- 			 
exit	
  ---------------------
 ----------------------------------	  --
``` 
exit	
 --------------------------------- 
-----------------------
 

```exit 0
--------------------
 exit 0
```exit 0
 ----------------------

exit 0
 --------------------------

``` exit 0
```exit 0

```exit 0
exit	  ---------------------

``` -------------------------  --------------------- ---------------------- 			 
exit	
 --------------------------------------------------------------------
 exit 0
 -------------------------------------
```exit 0
------------------- ---------------------
 exit 0

---------------------
 
 --------------------------------- exit 0
  ------------------------------  ---	 ---------------------
```  --
exit 0
 ----------------------------------
 exit 0

 -------------------
 	exit  --
exit 0
 ----------------------

 exit  --
``` ------------------------------	  ------------------------
 exit --------------------------------- exit 0
  ------------------------------  ---	  ------------------------

``` exit 0

```
```
exit 0
```
```
exit 0
```
 exit 0

exit	  -		
 exit -			 exit -			 exit -			 
exit
