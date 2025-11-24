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
  CXXFLAGS=${CXXFLAGS:-"$CFLAGS"} #Default to default compiler if no c++ flag exist and set default C flag, for portability and backwards
  LDFLAGS=${LDFLAGS:' -lc -std=c11'}

  case "$ARCHITECTURE" in
   x86_64)      LDFLAGS="$LDFLAGS -m64"   ;;
   i*86)         LDFLAGS="$LDFLAGS -m32"  ;;
   *)      echo "Warning : unsupported x86 Architecture $ARCHITECTURE, use default setting  ."  ;;
   esac
fi



#2  Compiler and Toolchain Detection
detect_compiler() {
    COMPILERS=("gcc" "clang" "cc" "suncc" "acc" "xlc" "icc" "c89")  #Compiler list, to be used as argument list and passed in
  
    COMPILER=$(command -v ${COMPILERS[0]} 2>/dev/null )

    if  [ -z  " $COMPILER "] ;then  
      for COMPILE _LOOP in "${COMPILERS[@]: 1}"
        do   COMPILE_CHECK =" $(command -v   \
        $COMPILE_LOOP ) "  #Loop through compiler names, to check the binaries
              if [[ ! -z " ${COMPILE  _CHECK}"  ]];then   COMPILER ="  ${COMPILECHECK}";  break   fi 
      done  # Loop end

     fi
       echo  "${ COMPILER:   Compiler} - Found. Version:  ${$ COMPILER} " #Echo the found
         case $COMPILER in
          gcc | clang )
               
                COMPILER_FLAGS = -D _GNU_SOURCE
               ;;
              suncc | acc )  
                   COMPILER_FLAGS = # No special compiler options 
             
              ;;

        *) 
           COMPILER_FLAGS ="#Compiler flags " # Special cases and default setting  # No compiler setting

              ;;  
     esac 
   export  $ COMPILER_FLAGS    #export to the calling function, in the event flags need modifying 

    return "$COMPILER " # Function returning the value, as variable in case the function gets invoked and the compiler has issues
    
 }   #End Function detect _ compiler 

detect_toolchain
DETECTED  COMPILER ="${ COMPILER:}"# Store the result in this function 
  echo   "-  " "Detected Compiller  - ${DETECT  _ COMPILER: }"

 # Check essential commands - cross platform, fail early

 check_command nm objdump strip ar size mcs elfdump dump # Essential build/debugging/linking command to fail if any fail


#3.  Configure the environment variables, and set default compiler flag values 

 # Set Compiler flags for platform specific, to allow customization, this also sets DEFAULT settings 

#5 Detect Utility/Tool Detection (moved below for now.) # This is moved to avoid the error.

#6: System Files/Dirs
 check_filesystem()
{ 
        REQUIRED_DIRS=("/usr" "/var" "/opt" "/lib" "/usr/lib" "/tmp" "/etc")

 # check_ filesystem_ loop 
      for DIRECTORY in "${REQUIRED_DIRS[@]}"  # Element from directory loop
        do   if [ ! -d "${DIRECTORY }" ] ;then  
               echo "Warning : required path not present - ${ DIRECTORY} Setting  Prefix  ." 
              PREFIX="${PREFIX} -/path_override  /"   # If any missing paths
                
      fi   
          done

        chmod -R a+rx  "${ PREFIX } *" # Ensure default directories can access the directory

       
   echo "- Directory Check: Pass, using the default ${ PREFIX  }. Check permissions."

} 

#8. Utility Check 
utility_check_dir= $ PREFIX # Utility path
  echo Utility check:
check_binary="nm"  check= $  SCRIPT/utilities/utility_checker  ${ utilitycheckDir }   " nm  $SCRIPT/"    " $  SCRIPT/.tmp   $PREFIX/tmp  
    if [ 1  ${ check  }-eq ];then # Error, check fail if return non _equal, return error status to caller 
         exit ${CHECK_FAIL }   else   echo   "${BINARY } is present in utility Check.    Pass.   ".
          done   # Loop check


#7 - Building, Clean, Install - moved below as this part needs other parts done

echo   'Initialization  & Compiler Check Pass,  Config: $ { CONFIG_ _SUMMARY:}' # Summary of Initializations
   ########################## Main Script Body   ########### 

   ########################## Menu/Configuration #######

   echo
  print  _ MENU ="  
 
 Build and Manage Menu  .     Select an Options :   \n 
  [1]   Clean/Build
   [2]     Compile/Test Build.
 [3]    Installation / De Deployment

   "

 while _MENU  true;
     Do 

         Select="${   Select_Menu : - }"     echo  "${_ MENU : }"    _INPUT_
    if
    (( ${SELECT} <=1 && ${ _  SELC_LEET: >=2)))  Then # Error message to user on input value outside defined value to prevent infinite error
            echo   Input must exist between [ 1 to ${ NUM__OPTION   S}: ].

        
         Exit_Loop

         Continue;
    End  if
    if ${Select  = '3 };Then _ EXITM   Loop_Loop

        Fi   if    (( _ SELET: >=1 AND $_   ELECT: - le (NUM _ _OPTION )) _ ;then _ _EXITT
       Exit_
  

        Loop

            End

           Exit

     _EXIT_

   
    ////////////

     if  Select_ =   `
   # 1: Compile Clean and test Build   2_Compile

      if Select== "  _  _
          _Build__ _

  End _ _

    #  1_ _ _Clean_ _ Build.
 Build and manage build menu,
      

  _Build__Menu() Book and
     
    # Print  " Clean / Re_B Build "

      Echo - - -  Cleaning  Project.  Please
 if  [[_ -n "   clean   Target   ". _ ]];then  #Check to run Clean Build 
      Make -_CLEAN   -   --Quiet 
            _Echo - _ Re building  Project...  Please
    _ _:-   
      
        _ _
   
         

    Fi

   
     make_command = Make 
   echo Make: " $ MAKE" _ Build  : "$   {   COMPIL   ER _FLAG }" 

       MAKE - j _NUMBER
         make _Run -j 3    # Number  is number  -
         
   Fi_
     echo   "_ _Build  Menu."_Exit.    Return  _

    End 1 #  Clean
   End if # 3: Deploy_Build Menu
        Echo_  "_Install and manage Build  " _Exit. _Build_Menu
          echo_Exit
            
     Echo "
       " Exit _ Build  Exit Menu" 


   echo  
         echo    -    "Exit
     echo - " Exit _ Menu_ "Exit"    -    Build
        Echo  

      Exit Menu _ Menu
            

      

     Fi

      
       #
            
       
     _End
      Fi   Fi
   End if    Fi # End of Menu choice
   Do

        End
_Build() {} # Dummy build string function


  
check_os(){# This will return an output if any issue exists and fails if issue exists 
   
      echo_OS:  -    -   -    ${ os _ _OS  
     Echo_ _Exit - 
        # Exit

    echo    

       Exit    -     Exit - -

}    _  # Check _
echo  Exit  
    # End

 # Check the os

Exit. Exit_Exit - _
   -   End  

    #End - _  _ - End

Exit -  _ End Exit -  --Exit- -_
-  

  _

# The rest of your build steps (compile, test, package, deploy)
 # 9, Testing & Validate 

  -  #
 -   Exit
 Exit

Exit_

End_

_ End -  End_ _ 


End  - - _ _  End
   -- Exit -- End -

-  -- - _  ---  _

-- End-

Exit -- _ : End Exit

---