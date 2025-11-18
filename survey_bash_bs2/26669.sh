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
 if ( ${ U NAME  }- m   )| | - match 'ia32 | i686 '; THEN  #If the CPU architecture says "ia32 or i686 - very specific to older systems - important to catch. This also means its not x86_64 architecture"
 C FLAGs="$ CFLAGS -m32 "

 el s e #Assume it is at least 64 - it would likely complain and exit with errors! - This improves environments, where there may not be specific 32 bits. Also this avoids problems in newer architectures that support mixed compilation.
  CFL A GS  = "${ CFLAG s }  - m64 "
fi

 EX PORT C FLAG s # Export these for other functions. Very common.



 log"  INFO: Set CF LAGs =${  C F  L  A  G  s  }" #Just confirm it, if the script has a bug and this fails later!


   export CPP FLAGS="${ C FL A G s  } -std= c++17  - f p ic  - KP IC "  #Important: Add standard c++ flags.  This ensures C++ is compiled with the newer version, but not necessarily newer that your C libraries - this may still lead to issues!  The Fp IC option will create " Position Inde pen de nt code ". Important. It helps make the installation of a program more reliable and easy, as the program may then not need the exact locations of some libraries

  e xp or t LDFLAGS="${  LF LA G s  } --lth r e a d-m  --pthread "
   exp o rt CX XFL A G S = ${  C  FLAG  S   }


 #else this section would only exist, is there a com pile, and we don't know how!



  f i

 log "COMPILER & LINK E  R  CONFIG: C  C $: ${  C _ COM PIL ER  }   FLA GS ${  C FL A G S  }, LIN KER$: ${L I N KER}" #Log this info, for reference and future checks - VERY Important to check these

  

 #----- Sys header detection ----
  DETECT  SYSTEMHEADERS (){  #Helper function

#Detects standard unix header includes - Very importnant if this has problems later - can help troubleshoot problems
 log " DETE C  TING SYS TEM Headers - IMPORTANT for portability - can take awhile. " #If a system cannot include standard Unix systems. The system will need more tweaking, for compatibility with it

 }

 #Detect Sys headers and print the output if it exists or has issues,
  DetectSYSTEMHEADER

 #--- Utility tool detection ----
 UT IL S (){  #Helper func
 echo ""
 #This will check for some of the more obscure and important commands to run

 log "UTILI T Y TO  OL DETECTION  "
 for t o ol in  ( "  n m objectDump  Strip   A r Si Ze MCS el fd  ump dump" );  d o

  i f comman d --  id --ver bo se"${t  o ol}"  ; Then #Does that thing EXIST, at all??  Important! This prevents a ton of crashes, by knowing it can even exist. You don't know if some tool may exist
   log"  U  T IL  - FOUND tool $: ${to  o  l  }"

   else log"Warning:: Utility TO Ol: "${ to o  l}  could n OT  b e  fou n d! Build ma  y f ai  l - this  i s u n common, check your environment"  #This could be common
   f i
 done
 } #Tool function, called to find all those obscure tool, so it won, t fail when it uses them!

 U TI L S  

 # -- FS and DIR CHECK---

 #---- File and Dir Checks ---
 CHECKFS()
 { #Another utility helper
  
 log "  CHECK FILE/DIR EXIST  EN C e"
   # Validate that all critical locations exists! This may not catch some things - and should ideally not exist
 for dir  i n("/ usr   / va r/  opt /li b/ usr/l i b / tm p/  e tc " )
  ;d o
   if [  !  -d"${ D I R}" ]   
  The  l o g"ERROR! Di rector $ DIR doesn ot Exisst . Bu i l  d w i l l fail "   and   r et ur n 1

 f  i

  
 d o  ne  
  #Confirm everything is OK
 l o g"All required D Irec tory Exists. C he ck  p a ss ed "
  #Exit function normally! No Error
 return 0 #Important!
 } #Dir check. Very critical
   #This may cause the buid ot abort, and exit the program if there i a missing di r! This makes for good error catching in most of our builds
 C hec  k FS
  

 #---- Main ---- #Main
 l o g "STAR TIN BUI LD. C on f ig u  re, bu ild a  n   test  s"
 C h i

 e   x
 l   a  s

 #---- Cross - Compile ----- (Cross compilation is a more specialized and important thing
 e

 s

 t

 # -- Final  Summary - Very helpful! This helps with future builds - it can log a summary. Also helpful for error tracing later
SLC.sh

 # ---- Exit --- Exit with a zero
 exi   t   
0