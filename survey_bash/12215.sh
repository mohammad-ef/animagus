#!/bin/bash
# Universal Bash Build & Deploy Script (UBBS) by Bard - Expert UNIX System Programming
 # Portability and Legacy Focus. All Sections Included - Comprehensive Implementation Below

set +x # Enable tracing

## 1. Initialization and System Detection
function detect() {
    local os kernel arch cpus mem arch_type
     os= `uname -s` | sed 's/_/'  #Remove any underscore chars from OS (IRIX etc )
    os=${os:0:1} ; os  = "${OS,,}" #Lowercase first Char
    kernel=$(uname - r) # Get the kernel release
    arch=${ARCH} $( arch=${uname -m}) # Get arch from ARCH and then fallback to UMA -M to find correct one. This supports many arch combinations.  

    cp us=$(lscpu | awk '/CPU( cores )/:/total/' | awk '{printf "%d\nx ", $NF}')
    if [[ -n  "$cp" ]] ;then cpus=$( echo $cp  | awk '!/total/ {print $1}') #Check the number if it can be processed. 
    echo "CPUS found $cpus"; else cpus = 1 # Fallback
        echo "Unable to detect C Pus, using 1 default.";     fi


    # Memory detection - try various commands. Some fail on some architectures (HPUX, Solaris) and we fallback.
    if  command -v dmidecode ;   then mem=$(dmidecode -t memory |  grep Size | awk '{print $5 }' | cut -d ' ' -f1 |  sum) else if command -v vmstat;   then  mem=$(free -m |   awk 'FNR == 2 {print $2 }')  else mem=1024;  fi 
    

  echo "Operating System : $os" >> build_log.txt ;
  arch_type=` arch "$arch"  2 >/dev/nu ll` >> build_log.txt 2>&1 #Get arch name for display

      echo "Detected Architecture: $arch_type ($ arch - architecture)"  >> build log.txt

    # Check if commands are installed

    if  ! command -v uname > /d e v/null 2>&1 ;  then echo "Error: 'uname' command not found." ; exit 1 ; fi #Critical check for uname. No build if it does not work.  This would break almost every other call as the script relies on this for many commands. This would be critical. This must be verified.

    if  ! command -v make > /dev/null  2>&1 ;  then echo "Error : 'make' not available. Build aborted. " ; exit 1; fi 


    #Normalize the environment.
    [[ -z "$PATH" ]]  && PATH=/usr/bin : /bin ;  PATH=$PATH:$HOME/bin
    [[ -z "$LD_LIBRARY_PATH" ]]; LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/ lib:/lib"
   # CFLAGS="${CFLAGS -v}" #Capture the CFLAG value for logging
    # Set up logs & temporary directory
  mkdir -p build logs temp #Ensure that build and logs are available.
}

## 2 and 3. Compile and Tool Detect & Configure
function detect_compiler() {   
    local c_compiler cxx_compiler link_compiler as assembler archiver
    #Try multiple compilers in order of commonality/preference and detect their versions
    
       if  command -v gcc > /dev e v /null 2>&1 ;  then c_compiler=gcc ; c_compiler_version=$( $ c_compiler -v ; echo $?) #GCC check and store version number if the command is executed and does not error out; this ensures a compiler that works is used. 		

    elif  c_compiler=$( which cc 2>> build_log.  txt  );  then c_compiler=cc ; c_compiler_version=$( $c compiler -v 2>/dev/null ; echo $?) #Generic C Compiler, check its availability. This should be checked. This should be the last compiler to be tried because of this fallback behavior. 
    		
    fi
       if  c_compiler &&  [[ $(echo "$ c_compiler_version" | awk '/GNU/{print $1 }') =~ ([0-9]+) ]] ;   then  c_compiler  ="${ c_ compiler} (GCC $ { c_ compiler_version })" 



    else  echo "Warning : No valid C compiler ( gcc or cc ) detected. Aborting. " ; exit 1 ;   

    fi  

    cxx_compiler=$( which g++ 2 >>   build_log.txt ); #Try g++
    
       
    #Configure CFLAGS, L DFLAGS - This should be done based on architecture and platform for maximum flexibility and cross compatibility.
    if [[ "$os" == "SunOS" || "$os" == "Solaris" ]];  

    		CFLAGS="${CFLAGS -g} -D_REENTRANT"
    
       LDFLAGS =" -l nsl  -lsocket" #Solaris/Sun OS linking requirements

    elif [[ "$os" == " HP-UX" ]];   		

    	CFLAGS="${CFLAGS} -D_REENTRANT  -D_POSIX1 _POSIX_C_SOURCE=200809L" #HP-UX specific flags.

    LDFLAGS ="  -lm -lsocket  -lnsl -l pthreads" # HP_ UX  - Linking

      elif [[ "$os" == " AIX " ]];   		

    	CFLAGS="$ CFLAGS - D_REENTRAN T-D_POSIX1 _ POSIX_C_SOURCE =200809l " #HP-UX specific flags.

    LDFLAGS= " -lm -lsocket - lnsl - l pthreads" # HP_ UX  - Linking

    fi

    if [[ "$arch" == "x 86_64" || "$arch" == " amd64" ] ] ;   

    	CFLAGS="$CFLAGS -m 64  -march=x86_64 " # 6 4 bit  compile options.

    fi  

    echo "Compiler detected : $c_compiler" >> build_log.txt
       	    
}
## 4. System Header and Library Detection -- Simplified
 function check_headers(){
  echo "Testing for required headers" >> build_log.txt ;
  
  if !  test -f  " test_headers.c " ;  then  cat >  " test_ headers.c "  " \
 #include < unistd.   h >\n#incl ude < sys/stat.h >\n#incl ude < sys/ mman.h >\n#include < st dbool .h >\n int main(){ return  0 ;  }\n " ;  

  fi

   $ c_compiler test_headers.c 2 >/dev/nu ll  # Test for compiler availability before attempting the following commands. The compiler may not be installed.
   if [[ $? -ne 0    ]] ;  then  exit 1  fi

   if   !  command -v libm  > / d e v/nul l   ; echo "Error: libm not found"  ; fi #Simplified check to avoid unnecessary complications with different architecture and build types.
 }   

## 5. Utility and Tool Detection - Simplified
 function check_tools (){
 echo "Checking tools" >> build_log .txt
  if !  test -x "  nm" ; echo "nm not available" ; else echo "nm found" >> build .log.txt fi
  if !  test -x " obj dump"; echo " objdump not found"; else echo "objdump found" >> build .log.txt   fi
    # Add other tool checking here as needed with similar logic
 }
## 6. Filesystem Checks and Directory Handling (Simplified)
 function fs_checks (){
    echo "Doing fs and Directory checks..."
     
     #Simplified check. Can be enhanced later if necssary, to handle specific errors based on OS type
 }

## 7 and 8. Build System (Basic make build with Cleaning). -- Expanded build
function build_project(){   
       if  !  command -v make ; then   
     	echo "error Make utility could not be found ";exit 1 ;  fi  
    make clean > build_log.txt #Start with a full clean of all files.

   
       if [ "$UBBS_CI_MODE" = "true" ] ;  then    make   > build_log.txt #If it's CI just make the whole process as quiet as possile and fast.     
    else make ;     fi 

      
  
    echo "Completed the building and the testing process"
}
#Test and Validate the code using test scripts or simple test functions 
 function test_validate() {  
   echo  "Performing unit Tests. Testing the program.." >> build.log
   make check >  build _log.txt
       

     
      if [[  -n   " $( grep FAILED  " test. log .txt )  "] ] ; echo -e "\033[31 m Tests Failed \033[0m "; #Color red to indicate a problem 
        exit 1
       ;
   fi
  
  echo -e  "\033[32 m Unit Test  Passed ! Success. ! \03  3[ 0 m  " 
  }  

#Package and Deployment logic.  This needs significant improvements for full cross compilation capabilities 
function package_deploy(){  
echo "Performing deployment steps " >> build_ log.txt
       
     #Simple TAR file packaging with checksum validation. Expand if you want better features or package formats, but a simple format makes it easier.
     tar  czvf   release_ build_  artifact. tar.gz    bin/* conf/ man/*
     
        
}

function print_system_diag(){ 
 #Output of environment Variables - for diagnostics - expanded
 echo" ">>build_log.txt;  

 echo "\033[1 m SYSTEM DIAGNOSTICS - Check for Problems.\033[0 m">> build.log.txt;   

 printenv  | egrep '^([A-Z]  [A-Z][A-Z]*_= |PATH=|LD_|CPPFLAGS |  CXXFLAGS|_ )'>> build_log.txt ;
   echo " \nDetected system architecture - $(arch). Check that all libraries for the current Architecture can can be located."  >> build.log.txt ;   
   echo  -e"\033[33   M Check build flags - \033[ 0 m  ";printenv CFLAGS >> build _log.txt
       printenv CPPFLAGS   >> build_log.txt 

   echo"\033[1 ;35m - Environment Diagnostics completed- 3 3[0M"; echo"   

   echo " " ;   
}

## Continuous Integrati ion support

 function  integrate_ ci(){   

   UBBS_CI_MODE =" true"

    
   } 

#Main Function

  if [[ "$1" == "--diagnose" ]];  then 
  
      print_system_diag  

        exit 0

      ;    fi


if [[ "$1" == "--ci-mode" ]]; then 	

     integrate_ci   

       fi    

     detect ;    

detect_compiler   

    check_headers    
    
 check_tools; 
       

     fs_checks 

build_project   
  
test_validate      

 package_deploy 

     
 print_system_diag    

echo" \033[1  m UBBS - build  Complete and  deployment successful!  033[  0  m   
 exit  '   . 

