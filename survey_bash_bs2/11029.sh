#!/bin/bash
###############################  Universal Build, Deployment and Maintenance Script ###############################

LOG_ DIR="$(dirname $(realpath $SCRIPT_PATH))/ logs". # Get script base directory safely (handles symlink issues too!)

# Check that script has execute bit. (This is crucial for portability) #
TEST $# 6 
# 6 is an empty parameter list (not a problem when script isn t used interactively, just to avoid error on script start!)
if [[ "$(test -x $(type bash 5 $SHELL )) == "false" ]] && command - v bash && ! test  /usr  / /usr/bin  #
then  error "This requires bash"  # Error message if script fails the executable requirement
fi
  # Set - euo pipe fail.  (Fail- Fast ) #
  set -ueuo

# OS detection with fallback #
OS=" unknown ". # Initial value
if  /usr  / linux
then  # Linux case #
OS = "linux ". # Set Linux value

# Kernel detection - used to differentiate distributions. (Not exhaustive!) #
KERN $(  uname -sr | tr "[a-z ]" "["[:tolower  :]"]")  # Normalize and extract relevant kernel version string  for later use. (e..g  , for Debian  )


elif [[ $(uname -a  = *AIX*) || -f /.64 ]];
 then # Aix (PowerPC based) and 64-bit OS case (AIX often needs specific settings for older versions of gcc/xlc, so a separate path for it is useful.)  (Also, this check will handle other non- x86- x8  / non x1  arch  , but is mainly intended  for PowerPC)  (Also handles non x6  , but only as secondary fallback.) #
OS=" aix".
elif [[ "$(file $(uname) -s ) " =~  " HP-UX" ]] # HP-UX specific case. #
then # HP- UX  / HPUX (Very rare today, very quirky) #

OS=" hpu x".
  # HP- UX  often has weird compiler settings and needs different libraries. (More to do when needed, as it s a niche OS to support!) #
  # Example, if HP-UX compiler requires a different linker flags. (Add specific libraries if required.)#  (e.g  ,-L/usr/ lib/ hpu xs  / lib -l hpps) #
elif command - v ultrix && command - v mach && ! test  /usr  / /usr/bin  #
then  error "This requires bash"  # Error message if script fails the executable requirement
fi
  fi

# Architectures
 ARCH = "${{ARCH  }}" # Get ARCH from the environment (cross compilations!) #
  # Fall Back for the system  , otherwise ARCH is not set in environments #

elif [[  "${ ARCH  }}" = '' ]]

then

 ARCH  " $ ( uname -m  )".

 ARCH ="${ARCH / [a-z ]/ [ A] "}".

 ARCH  "${ARCH / x8  x/}x86  # Normalize arch to uppercase

 ARCH  "${ARCH / ia/ i3  # Correct "i architecture for older systems

 ARCH  ="${ AR CH:0:2  }".

 ARCH ="${ARCH}"

fi

# Detect CPU count #
CP US = $ ( nproc ).  # Get processor counts  - very useful

CPU CORE=$ (nproc || cat/proc /cpuinfo | wc --line | tr --from= '\r\n  ' ' \n')  # Another check in very unlikely scenario

MEMORY_ SIZE ="$ ( free -m | a w k '3  # Extract memory size

 # Initialize temp and logging #
  MKTMPD  / tmp / universal_  build / ${ OS / ( [^ /] \*) / _} || mkdir --  p / tmp / universal build && CH OWN --  $USER :$  GROUP / tmp / universal _ build # Create temp directory and set permission safely

LOGDIR ="${ LOG_ DIR } /${ DATE +"\%y  \%m \%d"} ".  # Get directory to logs #

mkdir  / - p"${ LOGDIR  }" #Create the log directory safely (handles non existing path) #

# Environment normalisation
  # Normalize variables
 PATH ="$ PATH:./ ".  # Make script directory available
 LD LIBRARY PATH =$ (echo $LD_LIBRARY  PATH |tr '[:space :]'\'\') : ./  # Normalize and extend  LD_LIBRARY_ PATH  for portability

# Compiler and tools
  DETECT_ TOOL  =

function detect tool (name) {
 LOCAL CMD_  = command -V  "\${name  } "

if "$  $ CMD_" > /dev  /NULL 2&  /dev  /NULL # Check the tool if it is present #

 then echo "Found: "\${  " " "\  # Print message on terminal if detected (debugging purposes!) #


 else # Otherwise, return 0 if it's missing
  false

 fi
} 

 #Compiler detections  (in order of importance for modern vs legacy) #

DETECT  TOOL " gcc".

DETECT TOOL "clang

DETECT_ TOOL "cc

if [ "$ COMP IL  " = " g cc ". # Check to ensure a g cc or similar has been detected and set
 then

COMPILER = "gcc  "${ GCC_ VERS ION

else

COMP IL "cc

fi

  #Linker #
DETECT_ TOOL  `ld`  # Check for ld  #

#Assembler

DETECT  TOOL "as".

#Archiver  and related #
DETECT_  TOOL "ar # Check archiver #
DETECT TOOL "ran lib #Check  /usr  / /usr/bin  /ran  lib #


  # Flags based upon system (example only!) #

CASE "$ (echo "$OS ")" in  * aix*)

  FLAGS="-D_ REENTRANT -I  /opt  /commvex/sdk  # Add AI  X Flags#  # Example, adjust for SDK versions #

CXXFLAGS="$ FLAGS - fPIC  -std=gnu++ 11 -O2 -D  AIX_PLATFORM -g #CXX specific Flags AI  #
CFLAGS="$FLAGS "-O2"-g  - D AIX_ PLATFORM

;;

*hpu x*)

FLAGS  = "-D hp -D __LP  6 4__ -D  _SGI  _ #HP-UX Specific Flags #

CXXFLAGS="$  FLAGS -fPIC - std =g  n u++11 -O -g - D HP_PLATFOR MS#
CFL AG S=" -D hp-D__LP64__- DS_GI  _ "-O "-g -D  HPUX_PLATFOR MS

;;

*) # Default flags
  CXXFLAGS="-fPIC-std=  g nu++11  -O2 - g
  FLAGS=-O  # Basic flags
  # Flags based upon target architectures
  # Example, if using -m 32 #

if [  "$AR C H ==  32" ]

then

CXX FLAGS="$ CXX F LAGS -m 3 2 "
CFL  AGS="$ C FLAGS - m3  2"
fi

 ;;
 esac  ;

LDF LAGS = " -L/lib -l m -lpth read  # Example, libraries  /usr  /

 # Utility detections #
 DETECT_TOOL "  nm #Detect object tool

DETECT  TOOL " obj dup #Dump object tool (debugging purposes!)#  #
DETECT TOOL " strip # Strip binary  (Debugging purposes!) #

DETECT  TOOL "ar

DETECT_TOOL  `size`.

 #Files system and directories check #

VALID AT E DIR="/  usr "
 TEST -D  $VALID AT E DIR

 VALIDAT E  DIR="/var"

TEST-D $ VALIDAT E DIR

VALID  ATE DIR ="/opt #Check directory #
  VALID AT ED I R="/ lib"

TEST - D $V  A L I DAT E  DIR
 VALID ATE DIR ="/ u sr  / l ib"

TEST - D $VALID AT E D I R

 VALIDAT E DI R="/ t m p #Check  directory#  # Check temp  #

TEST - D $ V AL IDAT E D I R

 VALIDAT E DIR = "/ ect"

#  Build and testing
  # Build functions
  BUILD_PROJECT () {
 LOCAL PRO J E  CT=$ 1

echo -e "\ nBuilding "$  PROJ EC T "\n"

  LOCAL MAKE_UTIL =" make # Default #

if command -V  gmake >/dev /NULL

then

MAKE  UTIL = " gmake # Use gmake if exists (GNU make, common for older projects)
fi #Check for gmake #

if command -V  d make >/de v /NULL

then

MAKE_UTIL =" dmake # Use dma ke if exits #
fi #Check for dmake # (Digital make ) #

LOCAL  MAKE_ CMD ="$ MAKE_UTIL -C  $ P R O J EC T

if  "$ C P US" --g t   >   8

 then   MAKE CMD=$"  "$MAK CMD "-  j$( npr o c #Parallel builds
  echo "$ MA KE CMD   >>"${ LOGDIR "/build log "}.$ DATE
 do   "$MAKE CMD #Do build #
 }#
 } #END Function BUILD #


 TEST SYSTEM

 function t es t sy st e m () {
   echo --E \nRunning System  Check

 echo - E  -  -  # Print System #  (This function does the system and dependencies verification, almost as build system ) #

 LOCAL SYS C  =  /DE  V   / NULL  " #  # Initialize the sys c to 0 (to check it's empty )# #

 if [[ "   $"  -   "  "$S SYS  C =="" #

 echo ""   --

 fi # End conditional for empty SY C.
 echo #
}  #####################
  

 PACKAGE  PROJECT (  { PROJECT_N AME   },    "
 echo-  -- #Package and deployment functions
   PACKA GE PROJ ECT ()
   LOCAL P  = $
 LOCAL PA RG AR M E NT=100;


}  

  MAIN
   OS   - - "   O S  =   -   ""$ O SD ETEC -   TE

   AR -    " AR CH -- =--    "" $ ARC -- DETE   -TE   
echo"--- OS:   - "$ O SD ET  EC  - TE--""  ---

echo"- AR -    "" CH :"" "$ ARC DET -ECT TE  " -- -- -- - -- --- -- "


  
if [ --"$M --DE --"==" -   "-- C--    I "-- MODE  "-    ] - -- --   " then  -    #   C - -- I Mode
  -- -- --    E-  --   C HO    "-      S  -- "-- - "--   E C -- HO -
   else   "-      "    S UPR--ES - --S -    PRO   P- -- --
     
 fi  ###################### - #

   "---    C O--N FI    GU RA -    TION --- -
-     C ON   FI    ---    SU - MM -- AR
    -    E  C H  -   -  "   '"--   --

 fi# -- -- END   ---   S  ----C RI   --PT --" --
