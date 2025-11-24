#!/bin/bash
//-------------------------------

 #!./runscript  (to ensure that all intermediate script files are executable before running them)


  set -e -u o pipe fail #Strict execution


  log_level= "INFO" # Default log level.  DEBUG for verbose,  WARNING for errors only..etc..  Can set externally

 #--------------------------------

  PREFIX=$( if [[ "${PREFIX:-}`pwd -L`" ]]; then "$ PREFIX "; fi) #Ensure PREFIX is valid and set to CWD, default, unless defined externally (for install locations)  PWD -L resolves all symlinks so you are getting what they see not some internal pointer.  Important.  Use -M to see symlink pointer.  See man bash "pwd", "- L, - P,-M "


 #------------------------------


 function log(){

  local LEVEL=$( printf "${1} ")  local message=${ 2} local prefix=$ PREFIX local level_color= "${3:-"  } local time stamp=$( dat - date '+ % Y.%m %d % T %Z')  log f=$( echo "$( date +"%Y.%m %d % H:%M:% S, " ) $level  $message" >& /dev/$1  echo "${LEVEL}: ${time $message}" | tput  $LEVEL_COLOR  ) #If you want to use tput to color the messages (not always portable - e. g. old SunOS)  #This uses  $ LEVEL_ COLOR, but it must exist!  You could create an empty color variable so there is none

 } #end function log #This will be useful later

 if command-  > /d /v "tput"  -eq 0 && [[ - n $level  > / d /v /c / o /l or > ] ]; then #tput works.  Color enabled by default, but disabled by empty variable or not installed.  This is the check


  local blue='  \E[34m  ' local bold =' \e[1  m ' local endcolor =' \ 033[ 0m ' #Some default colors  - more robust color support would use ANSI colors and/  d /v  "term"

  level _COLOR =" $ b ol  $ blu e "
  log_level _C olor=$ endcolor

 else level_COLOR ="  " #If you have trouble, disble it for the entire session


 #Check what the loglevel is set to, otherwise it will use a default
  fi


 #---  Initialization ---
 OS="  ${UNAME:-Unknown  } "

 if [[ $OS=  "*Linux * "]];  the log "INFO: Detected Linux"
 elseif [[ "$OS" = "*IRIX "]]; the log "INFO : D etect ed IR I X "; fi

 KERNEL="$ UN  AME -s  "

 #Detect ARCH  - architecture
 AR  = ${UN  AME -m}

 CORES= "$ ({  GET -CPU  S } | wc --line s)"
 MEMORY = "${GET -TOTAL_MEMORY  -k}k  " #Get in KB
 log "INF O: CPU:  $ C ORES, MEMORY $: $ MEM ORY , ARCH $: $AR CH"
 


 echo ""
 echo "======================== System Detected  Details==============================" >> logs/sysinfo .txt

 log "SYS INFO:"

# Verify essential commands
 cmd=("  UNAME AW  K SED G R E  MAKE CC" ) #Make the command list here - add as needed!
 missing= ""

for  i n "${ cmd[@]}"  ; d o #Looping to ensure commands are installed. If any are not installed, an error occurs.


 if ! command -- id --verbose "${ i}";  Then

  miss  ing="$ missin g ${i}"

 fi
 done  #loop
 if ! -Z  " $ m is sing " ; Then
 log "WARNING  : M iss ing essential commands $missing . Build may fail"
  fi


#  Normalize environment variables (best effort to be platform independent!)
 export P A TH  ="$ P ATH:/usr/local/bin :$ P ATH:  $ (pwd )/ bin"
#  Add a bin directory here so you can use this file and/or helper files directly.
 export L D _ LIBRARY _  PATH="${ L D _ LIBRARY _ P A  ATH:=: } : /usr /lib"
 log "ENV INFO : P  ATH: $PATH , L D _ L  IBRARY _PATH $:  $LD _ L  IB RARY  PATH"

 mkdir -- mode=$ mode -p " log s "
  #Create required temp and log directory. This makes running the script multiple times cleaner!  Also, this avoids any permission issues

 #----- Compiler Detection----

 detect compiler() { #Define a function so you can re-use it later and avoid repetition in other build systems!  Also, a nice function makes things look clean.

  LOCAL C_COMP  ILERS=" gcc cl an g c c suncc a c cxlc ic c c89 " #List all compilers
  local LINKER  local Assembler local AR  LOCAL found_comp  ILER= ""

 #First attempt to find the linker (required, regardless of how you compile.  Important.  Also, you may want it as well, if there is an issue later)
 if comman d--id --verbose ld  2>/dev/NULL; Then #LD command exists (required)
  LINKER =" l d "

 elseif comman d--id --verbose g l d; Then #gld, GNU Link tool chain, is the alternate
  L I N KER =" gl d"
 log"INFO :: FOU ND Linker $ LINK ER "

 else
 log" WARNING: Could NOT locate LINKER!  Build may fail. Check installation of linker."  #If you cannot find ld, you can'  t bui l d
  ret urn 1 #Exit this function and abort!  Important.  The whole point of checking for these commands is if they don't exists we abort early!
 fi #Check for LD

  #Then check the assembler
 if ! c ommand -- d--v  r bose as 2>/ d ev/ N UL  ; Then
 log "WARNING  : COULD NOT FIND Assembler. May be needed for cross- compilation, and could cause build failures later."

Assembler  =" " #Just empty out the variable in the even that one cannot exist
 else
 Assembler  =" a s " #Found, good to go
 log "INFO : Assembler FOUND"  #Just log it to confirm we have found it, in case there were issues.
fi #Check AS
 #Then, check for an Archriver tool - very commonly required
 if comman d - i d --  d -v  r b o s e ar  2 >/d ev  /NULL ; the n AR =" a r " #If this is the case, use it to run

 else AR ="" #No arch river, not a major issue
 fi #archiver tool check
 #Loop through the list for each compiler
 for c ompiler in  ${C _COMP ILER s} ; d o #Loop through each of them, trying to use what it can
 if com man -i id-- v e rb os e "${ com pi  l er} "; then #This command actually EXISTS - good sign!

  LOCAL found_ compiler=" $ foun  d _comp i le rs $comp i le rs"
 log " INFO  : D ETEC  T E D COM P IL ER $ c o m p i l e r "
 return "${c om p i l er}"
 fi
 done #Check all of them!
 log "WARNING: No suitable COMPI LER found! Aborting." #Error if there is none - important!  Can't build without that!
 return 1 #Exit function
 } #End Compiler

 C_ Compiler =$( det ect compiler  ); #Set the C_ compiler

 #---- Compiler Flag Configuration---
 log"INFO :: SETTING COMP  ILERS and LINK ER"

 if [ - n "$C _Compiler "  ]; the n #Only run it if there is actually something to compile, otherwise we skip all the flags.  Also, you should have checked the existance of it earlier.

  #Define platform specific C/C++ compiler flags. You can add additional flags, and/ or check different platform flags, for additional support. This is where you add specific compiler flags based on architecture (32-bit vs 64 bit), optimizations (-O2 or higher), or any other special requirements of the code to compile, such has specific math library support, for an unusual system that you support.  These are all platform specific and are what make portability hard to do.
  C F LAGS  = "-- -g  "

 #Detect 32/64-bit architecture (important! This makes a difference in compilation)
 IF[$( g ldc  - m  32   )  >/d ev  /N UL  ]; then

  CFLAGS ="${C FLAG S }  -m32"

 else
   CFLAGS="${ C  FLAG S   }  -m64"

 #Additional common platform compiler/link settings here: You'd add specific flags here

   LDFLAGS="-  Wl,-Bsymbolic"  #Important!  Helps link dynamically with some systems
 #End platform setting

 fi

 exp or t C  F L A G S
   ex port L  D_F LAG S  #This may also contain the math/math-like support libraries!


   l o g"INFO : COM P I LE  RS :$ COMP IL ER C  F  L A GS$CFLAG sLDFLAGS  $  LDFLAGS  " #Just to display them in your terminal and log file, as you are debugging. Very helpful. You will thank your earlier self
 else #if you can  't set C compilers. You have a major error. The compiler may not even work or even installable... This would likely require you upgrade or change the platform and re install all your packages,
 log" ERROR : IMPOSS I BLE   T  O  DE TERM INE CO MP IL ER  ,  ABO RT!" #Major build issue!  You are screwed at this stage - abort immediately.
  re  tu rn 1  #Critical Failure - stop. The entire rest *won*  *t work.  There isn't going to be something there, so you should error.



 #---

 exit 1  #If all of this went wrong, you have to kill the run
 else#Compiler wasn't detected - not fatal error.

  exit 0
  l o g " W A R  N  I N G   -  C   C o mpiler loss. May fail during builds later on..."
fi#END

 exit 0  #End
