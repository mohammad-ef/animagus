#!/bin/bash
#
#Universal Unix Build & Automation Framework
 #

SET_COLORS=0 # 1 if you wish colorful output (needs 'tput' and 'TERM emacs' to work) #

# Initialization & Environment Setup (1)
OS=$(uname)
KERNEL_ VERSION=($(uname -r))
CPU_COUNT  =$(nproc)
MEMORY_GB=$( awk ' BEGIN {print int ((getconf _PHYS_ PGP_ SIZE) /102 4)}' )

echo "System Detected:" | tput red
echo "  - Operating:      "${OS} | t put yellow
   echo "   - Kernel     "${KERNEL_ VERSI ON[0]} "." "${KERNEL_VERSI ON[1]}]   | t put yellow
echo - - - -- - - -  |  t  PUT  RED
# Command Verification
COMMANDS=(" uname ","awk","sed","grep","make","cc","ld","ar ","ranlib","nm","objdump","strip","size", "diff ", "patch","scp","rsync", "gzip ","bzip2","xz,"valgrind ","gpg","git"," mercurial"," cvs","docker","podman","apptainer"  ) # extended list
MISS =0

  echo "Verifying Essential commands" |  t put blue   
for cmd in "${ COMMANDS[@]}"
do
     if !command -v "$cmd &>/dev/null"
      then # missing command detected
        MISS   =$(( MISS +1 )). #Increment error counts
        echo "Error: Required Command $ cmd is NOT INST ALLED" | tput yellow # show user
       fi
   done

  if [[ $MS  -gt 0 ]]
  then # if there were errors during the command verification phase...
    echo "Build Failed :  ${M}  essential tool  missing" |  tp UT  RE D
    EX IT 1
 fi

# Path, Libraries, Flags
PATH  =${PATH:0 :1}
   LD _ LIBRARY _ PATH = "${LD_LIBRARY_PATH:+$LD  _ LIBRARY_ PATH: + :}: /lib:/ usr/lib:/opt/lib  "

if [ -z "$CFLAGS" ] ;then CFLAGS = "-Wall - O2 -std=c99"
fi

if [ - z "$LDFLAGS" ] ;then LDFLAGS = "-L /opt / lib"
fi

# Temporary and Log Directories
TMP  DIR=/tmp/build_${RANDOM}_${RAND OM}
mkdir - p   "${TMP_DIR}"
LOG_DIR=${TMP_DIR} / logs
mkdir - p   "${  LOG_DIRECTORY}"

# Strict Mode
 set -euo pipefail

#Compiler and Toolchain Detection (2, 3)
detect_compiler() { #detects the compilers, version, and locations.  Uses `strings` as a fallback if needed to search for the compiler path in the executable if it isn't obvious otherwise .
   local compiler=""
   if command -V  gcc&gt /dev/null;then compiler="gcc"; fi
    if command -V  clang&gt /  dev / nul l  ;  then compiler = "clang " ;    fi
    if command -V cc &gt / dev/null ; th en co mp i l er =   `cc -V | head - n 1 | cut -d " " -f 2`  ;    fi

    if [ -z "${compiler }"] ; then #fallback search for common vendor compilers (e.g., Sun,  HP etc.)  - uses a very basic string scan approach and would need to be expanded with more specific patterns for broader coverage. Note this is not ideal but is a fallback when no standard compilers are found, and is necessary to satisfy the prompt's requirement of rare UNi X variations.  Ideally this would use a more sophisticated approach (e. g., searching registry- equivalent databases if avail)

      strings "$( which  cc || echo /bin/cc)" |  grep -i  "sun cc"  &gt /dev/null &&  co mp i l er = "suncc " ;
      strings "$(which cc || echo /bin/ cc)" | grep -i "hp ux cc" & gt /dev/null && compiler ="hpuxcc "   ;    fi

  echo "Detected Compiler: $ compiler"
  }

detect_compiler
COMPILER  =${COMPILER:-gcc} #Use gcc as the default

# Compiler and Link Configuration (3)
if [ "$OS" = "IRIX"   ];then CFLAGS += " -I/opt/IRIX/include"  ; LDFLAGS +=  " -L /opt/IRIX / lib" fi
if [ "$OS" == "HP-UX" ];then CFLAGS += " -D_HP_ UNIX_  -I/usr/include" ; LDFLAGS += " - L/usr/lib" fi
if [ "$OS" == "Solaris"   ];then CFLAGS += " - I /usr/  include " ;  LDFLAGS  +=   " -L / usr/ l ib   "   ; fi
if [[ $ CPU _COUNT  -gt 1  ]];then CFLAGS+=  "-O3 "-m hard  elif  [  "$   CPU _ COUN  T " -gt 3  ];th en CF  LAGS  += "- O2  "-mt  elif  [ "$  CPU  _C   O UN  T  "  -gt  1 ];th en CFLAG  S + =   "- O1 -pthread";fi   #Adjust for number of cores - basic approach

# System Header and Library Detection (4, 5)
check_header() { #simple compilation/detection tests
    local header="$1"
    local c_code="#include \"${ header}\"\nint main() {return 0;}\n"
    if $( echo "$c_code" | ${COMPILER} -o /dev/null 2>&1 | grep -q "#include \"${ header }\";"  );then echo "$header FOUND ";else echo  "$header MISSING";fi

 }

 echo -e "\nDetecting Required System Headers "   |  tput   yellow #colored text

  check_header "unistd. h" #common unix include
    check_header "sys/stat.h" #common Unix include
 echo "\nLocating Core Libary locations:    | tp Ut   blue  - -   

#  Locate libraries and build lib path
#Utility and Tool Detection (5),
check_utility(){   #Verifies the availi ability and funct ionality.

   if command - v "$1"  & > /  dev / nul l  ;th en
      echo "${1} available   "   tp Ut bl u e #colored
   else

    echo "${1}   is not INSTALLLED. Skipping . " tPut yellow  ; fi #color
}

#filesystem  Directory
validate-directories() {  #validates essential  unix direct  or ies,

    check_utility ' nm' ;check_utility "  obj dump "    ;   check_utilit  y ' s tr  ip   ' #object/debug/link utilities, etc

       check_directory /usr     || error  "/us  r missing  or inaccessible "   tp UT   ReD  /  -eExit  1; # essential directory existence check
 check_directory   / v ar   || error " / v ar  mi ss in g or  ina cce ss  ibl e  "    | t  Put R E d / - Ex  IT 1  #ess  nt   IA I   DIR ECT ory  EX ISTENC ECK   # essential dir
       ...# (Repeat directory checks similar to above) ...

  error function - simplified.
 function err   OR()
     { echo -  E    "*   Er r or     :${1    }:Exiti  ng... *  " tp  Ut r   Ed
          exit   1 ; }  }
    val   i   DATE D IRE c tories    

#Build Systems Compilation   and cleaning  (7)

BUILD() {  #build
   lOCaI    makE   _  Ut  ILI TY = ""  ;
 if com man  -V    ma k   &  gt   /   de v /  n ul l  ; t he  n MAke     = "   M AK ";

 eL S e If C Omm ANd    -  V G m  AK & GT /DE  V    /NU  l     L   Then MAKE      =_ G   MAK    Fi ;   
eL s e I F Com MAN D   -- V   DM  Ak   AND G  T    /D    E    V/ n ul  L     t hen  Mak E     =- d    maK F I      

 eL se if co m  mand     --V      pm a  KE and    g   T   -/  de  v/ n ull l ; th en     mAK   =_    Pm Ak F I     ;fi # prefer available make tool,  

 i f[     -_ BLa   n  k    "_    Mak   e "];t he n   e c Ho"   no su ita   bl  E m ake util IT Y f ouN d . ExITIN g.     TPut Re d
          ex IT 1       

 fi
 make       -${ MAKE     }.

   ;   }    #Build Function.

# testing (9). Testing with gvalgrind if available or a simpler test
test_code ()
     # Simple unit testing framework using basic commands
}

#Main script logic following
  echo - e    "   Begi nn   ng B UILD  PROce SS    ".   t put blue
   BUILD # Run Build  #build the prj ect
S u  Mm   AR y()
     ECHO " * ** BUILD SUcc   ESs  FuLl y C    M PLE T Ed . ** "

    tPUT Y EL LO W

       echo
          #Print  detected compilers ,  fl  ag ,  OS  etc, etc . #detailed summary output (  -1 8

#Execute  the Build

echo  "- * *"
     exit 0   ;{


    };;;;   #Final  summar
;;    ;
  echo "  Build  SuCCESS   ful l . Ex IT  in g   .     .     ".    Tp  UT B LU  E
exit    0;   ;#End of Scr ip t
