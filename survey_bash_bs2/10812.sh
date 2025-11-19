#!/bin/bash
###############################################  Universal BUILD and PORT Automation #################################################
################ version: ALPHA ############## author : GPT ##############  #######################

# ------------------------- Initialize the script and define variables -------------------------- #

# Constants & Defaults (can/must change based environment) -- Customizable from cli. (see below) 
SCRIPTDIR=$( cd "$( dir "$( read -r )"` || realpath "$(dirname "$scriptPath" )"/$(basename -- "$scriptPath)" || die )/ && pwd ")$
 PREFIX=/usr/local
 LOGDIR="${SCRIPT DIR}/logs" # Ensure this directory can be safely set, even without a home dir
 TEMPDIR="/ tmp/build" # /tmp or another temporary directory
 BUILDMODE="release"  # debug | release
 VERSION=0  #(read from files, or use git if source) 

DETECT_SYSTEM () # detects system details
 {
  SYSTEM="$( ulmt-f | awk '{ if (!seen [$1]++) printf "%s ", $1}')" #Detects System (Solaris or HP UX etc.. )
  KERNVER=$( ulmt-f | awk '!seen[$1] {print $1;next} {$i++ if ($i >2) exit }')  
 }
  
DETECTCOMMAND () #Checks for commands (returns TRUE or FAIL) 
{ 	
	cmd=$1
	 if command -vf "$cmd" 2> /dev/null	 
	 then	return TRUE 
	else 
	 echo ERROR	  : Command "$cmd" is NOT found.
	 return FALSE
	 fi
}

INIT () #Initialize variables, directories, and check requirements -- MUST ALWAYS RUN FIRST! --
{
  # Set -euxo pipefail is essential, it stops the code on first error, so you have an immediate indication where things are wrong! (and don't keep building after erroring out!)
	set -euxo pipefail

	# System Info
	DETECT  COMMAND uname
  	OS="$(uname -s | awk '{print tolower($1)}')  " 
	ARCH="$( ulmt-f | awk !seen[$1] {print $1}; exit}')"  
	KERNELVERSION=$( ulmt )
	CORES =$(nproc ) 
	MEMSIZE=$( free | awk '/Mem:/{print $2}') #Total memory
	 

  # Directory Check and Creation
	 if [ !-d "${LOGDIR }" ]; then
		echo "Creating logging directory ${LOGDIR }"
	 fi

	# Create TEMPDIR, it's a MUST to run
	if [ !- -d "${SCRIPT_ DIR/ tmp/}" ]; then
			mkdir - p  "${SCRIPT_ DIR}/tmp"
	
  fi

	 #Setup standard PATH, LD libraries, etc
	 PATH="${SCRIPT  DIR}/bin: $PATH"  
 	export PATH
}

 #-------------------------Compiler and Toolchain Detection--------------------------
  
DETECT_COMPILERS  (){
	COMPILERS=""
	
	#GNU Compiler (Most systems)
	if DETECT_COMMAND gcc
	then
		COMPILER="gcc" 
			VERSION =$(gcc version ) 
		COMPILERS ="$COMPILERS GNU GCC $VERSION (Linux)" 
	 fi
	
	 if detect_command clang 
	 then
			 COMPILERS ="$COMPILERS  CLANG"
			 COMPILER=" clang" 
			 COMPILER  VERSION=" $(clang version)"
  			
  fi
	#HP- ux
	 if [[ "$OS"=="hp  -ux " ]]
			 then
				  	
	 fi

	# Solaris/ SUN OS
		if [[ "$OS"="solaris "  ]]
	then	
		if detect  command suncc
	then
  			COMPILER = "suncc" 
			 COMPILER VERSION ="(Solaris  SunCC)"
  				COMP  ILERS = "$COMPILERS SUNCC"
	fi
	fi  
	

	echo "Detected Compilers: $COMPILERS"
}


CONFIG_FLAGS(){  #Configuration flag set
   
	
  case "$OS" in
   "linux")
			 CFLAGS =" -fPIC -g  -O2" #Standard  
		   LDFLAGS="- pthread" 
   ;;
	"hp-ux")
				
				 CFLAGS=" -fPIC  -O3" 		
		
		;; 

   "solaris") 
     			  CFLAGS = "-x  cc   +ssa +O2 "  
			  LDFLAGS=" -lsocket -lnsl "

			
		   ;; 

		 *)   #default, generic 
    		     CFLAGS  ="-fPIC  -O2  -g" # Generic defaults	 	
		    LDFLAGS=""
	  	;;

		 esac
    export CFLAGS
		   
  echo  "C flags set"
	 echo LDFLAGS	
   

}



 #--------------- Header/lib detections and System info ---------------#

CHECK_HEADERS()
{ 	
	cat > headercheck.c <<EOF
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/mman.h>

 int main() { return 0; } 
 EOF	

    
		  cc  -c  -o  headercheck.o  headercheck.c  
 if	  [	   $?  !=  0] 	  
    	{ 
   			echo WARNING	    ! : Failed  checking headers (cc compile)  		
     	  
	}
		   	fi  	
		 echo DONE	    headerchecks		  	
	  
}



UTILITY_DETECTION(){ #Utility tools like nm ,  strip etc.. (essential for building.)

    
 echo Checking  for  essential build Tools 
 if detect command nm then
 echo   "  Found 'nm '   Tool "  		
	  else
    	    	 echo Error: Utility:  tool  is needed.   Aborting 
      fi		 	 

	if	    DETECT    COMMAND	   ar		 	
  { echo " found utility tool ar."  
}		
  	else		echo error	 ar 		not Found Aborting [--]

      
		 fi


}




FILESYSTEM_CHECK(){  #Directory  checking 

 echo -- Directory checks starting  ---	

 if   [  !  -  d   / usr	 ] then   
      echo FAIL: /usr is missing
   		 exit   
	fi
    if    [ !  -d / opt  ] 		  
	   then      echo / opt   is   required    		
      
	fi
		 

	  
}





 #---------BUILD system ( Make  utilities etc )----------------- 
 

DETECT_MAKE (){	 
     # Detect preferred  make
		make= $( command -v make || command -v gmake || command -v dmake  || echo "")	 

    if   [	 	 - z	    "${make }" ] ;
      then	   echo WARNING! Make detected is NONE 
    fi

  
    	 echo Using   " ${make   }
		 
  } 

 #--------  CLEAN & rebuild --------  (Clean ,   Build   Target  
 CLEAN ()
{
     
	  
     echo --Cleaning build directory

} 
REBUILD(){ #Full REBUILD of source code, and build artifacts (must start fresh, so no old code interfering)
     echo Rebuilding the Entire Codebase (this could take quite some time, it may take more) 

   }




   #------------------ Test / Validation section -------------------- 
RUN_TESTS(){   
 echo ---- RUN Test
  	 # Run Test suites (this will depend how test is configured (Unit / Function )  -

 }



 #--------------- Package Deployment ( Tar  archives )-------------#
PACKAGE(){	 

 
 	#Tar archive and checksums  (essential to be done after the Build!)

		
 echo Generating archive...
    tar czvf output.tar.gz
     
  sha256  sum  output.tar.gz > checksums
    

		
  echo -- Archive Generation DONE

 }





  #----------Diagnostic/ Info Output --------
DISPLAY_INFO(){ #Diagnostic and Information

echo - System Information

	 echo System :${SYSTEM  }

	  
		

 }	

    #---------------- Cross Compiler Setup ---	

 #--------- Environment  recovery and Backup 	----




#-------- MAIN PROGRAM EXECUTION ----


# Initialization and System Information Collection 
INIT
DETECT_SYSTEM

DETECT_COMPILERS #Detect compiler information, flags
CONFIG_FLAGS   #Configure Cflags 

DISPLAY_INFO

DETECT_MAKE 

FILESYSTEM_CHECK
UTILITY_DETECTION
CHECK_HEADERS
   
RUN_TESTS
PACKAGE #Packaging after building and test, this MUST occur!  




 echo  ----------------------- Build Completed
 echo Retrieving  Summary from build directory...

 exit  0  #Indicate Success
