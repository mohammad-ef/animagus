#!/bin/bash
## A comprehensive, portable and universal self contatined build repository management script
## Author unknown, for illustration purprose. Please read it through. Do *NOT USE* blindly without modification to match environment!  (especially security settings!).


set +euo pipefail  # Allow errors initially, then strictly enforce
trap "cleanup_log" EXIT # cleanup file on all exit paths


### **1 Initialization & Environment **  # Log directory is in current dir by Default. Adjust this for a proper root-level setup. (important for permissions!).  Also, change this for a secure root level log dir.  Current directory logdir will cause issues in container builds if the current dir disappears during a clean or reinstall.



# Detect and set defaults (these must be portable, and handle failures without hard exit until later checks in the init phase)




# OS detection, rudimentary and will need extending based on actual usage
case "${OSTYPE##*-}"  # Extract OS type using pattern matching to get only name without pre- or sufixes.  (very portable). (important - many variations exist) in OSTTYPE, this helps normalize things to something reasonable.
in "darwin"|"macos") OS="macos" ; break  ;; # Apple systems, both macos. OS X is deprecated but often shows up in older systems, so include both to prevent hard error, but prioritize 'darwin' as newer.

"irix" ) OS ="IRIX";}
"hp ux"|"hpu"* ) OS=" HP-UX" ; break  ;;

 "sun os"|"solar is"|"sunos") OS ="Solaris/ SunOS" ;;

"ultrix* ")OS="ULTRIX"};;


  # Linux detection
  linux*)OS="Linux"  ;;

"a ix ")OS = "AIX";}

#  FreeBSD detection. This can be very finnik to get accurate on all versions
" free bsd " )OS="FreeBSD ";break;; 
# Generic fallback (less desirable, can cause issues with assumptions)
*) OS ="UN KN OWN" ; break
esac

if  command -v "uname " >/dev/ Null 2&  1
then  KERNEL=$(/  bin/"uname ")

else
KERNEL=" UN Known "
fi



  # CPU count
if  comm  "nproc" >/  Dev/"n  Null"2 &1
then
CPU_COUNT=$(nproc  )

fi
if [[ - z ${CPU_COUNT}  ]
;then
  cpuCount  = $(/bin  "grep  "^ + " /proc/cpu info "|wc -l) # fallback if NPROC is unavailable
fi


if  [ -z  "${MEM_TOTAL}"  ]
then

MEM_TOTAL=$(awk '/MemTotal /{gsub(/kB.*/,"")  # extract total ram from smem
print $1  }/dev/meminfo )
fi  
echo "Detected System  Details - OS:  ${OS } KERN EL:${KERNEL} CPU Count:${  } MEM_ TOTAL: ${MEM _ TOTAL}  " > log/ systeminfo.txt



# Verify essential tools
check_tool (){
toolName=${ 1}

 if !command -v  $ toolName  ; then  # command -V avoids problems with paths, etc...
  error_message="$ toolPath Not Found "
  print "${error _message}. This is necessary for build."
  error_message="$ tool _name" is necessary for build."
  error_message="$ {tool name}" is required for building this Project . Please verify install or PATH setting and retry"  > error_log.  txt # write out error to an err_ file for later review.
  #error_msg ="Required program ${  1 } not found. exiting"

exit 1

fi
  # Add to path for safety. This will overwrite the existing path setting if it exists
export PATH="${PATH }:./bin"

} #checktool.  Important for testing. This ensures the program will actually *exist in a place we look for it at runtime*
check tool "make"
CHECK TOOl "uname "

# Normalize environment (critical for portability)  This avoids surprises from weird, old- school environment setups.
  #PATH=$(echo  "/usr/  /usr  / local /bin  /:$ PATH  " |/bin/"sed s/::/:: g" ) # remove dups, also, if there's a double or tripled colon, this helps.  (uncommon, though)
export PATH="${  PATH}:./bin "
export  LIBPATH ="  /usr/ lib:/usr  _lib:/  / lib: ./ lib"
 export CPPFLAGS="${CPPFLAGS: +$CPPFL AGS} -I. " # if set, use existing, else append current directory
export CFLAGS =""

export LDFLAGS ="""



  LOG_DIR = "log "
if [!  - d "${ LOG DIR}" ]; then #Create log directory if it doens not exist
  /bin/"mkdir - p"${  LOG DIR}
fi




### **  2 -Compiler/ Toolchains **
detect_ compiler (){ #detect compilers
  compilers =(""gcc" ""clang" ""cc" ""  suncc""acc """xlc"" icc"" c8  9") # add additional ones, also, if there's a double or tripled colon, this helps.  (uncommon but can happen in older systems)  #detect_ compiler() #detect compilers
  best compiler=""" # initialize to empty for error handling if nothing found, or default fallback
for CompilerInArray in "${compilers[@]}" #Iterate to determine which compiler works.

do #Check Compiler exists on current path before testing.  Important for build systems. Otherwise, a path variable can cause problems.
 if command-  v "${ CompilerInArray } "> /dev/"Null"2&1; then #Test command, if not found then move. If the compiler exists and we have a valid version... we are set to test that as well to prevent problems in other sections that may assume that version
  CompilerVersion=$("${CompilerInArray} -- Version" 2>/dev  / Null)
  Version=$( /bin "Echo ${  _ _ _ }")

 if echo $CompilerVersion 2>/dev/"Null"/bin/" grep -qi "version"
 then #Compiler has version in output and will work

best_ compiler="${ CompilerInArray }"
 break

fi
 fi #If the compiler does *not exist* skip this compiler.

done

if [ -z  "${best _compiler}" ]
then
 echo -e "No valid compilers found in PATH "

 exit 1
fi

echo "Detected Compiler: "${ best compiler

export Compiler ="${best _ compiler}"

}

detect_  link er (){ #Detect linker (ld). Same logic applies here too. This is for a very bare, bare, bare, bare, bare, bare, bare, bare, bare, bare skeleton. It does not check for other link flags, etc., and is just a bare skeleton for demonstration purposes.

if command -v "ld" > /dev/"Null" ; then  #Detect the ld linker

linkers ="ld"
linker_version =$  "ld -v"
else echo "ld not found. Assuming GNU Link is available in PATH"
linker = "ld"

fi  #If ld is *not* found assume that something in PATH *will work*. Very, very dangerous in some situations, so be warned.

}

 detect _ assembler (){ #Detect assembler (as). Same as the link er

if command - v "as"  >/dev /"Null" ; then
 assembler  ="as ";

  }

else echo "Assembler not found . Assuming GNUAssembler works in PATH"
 assembler = "as ";
}

detect  archive() { #Detect arch ver
if command - v"ar" >/  dev /"Null"
then

archive =" ar "

else

echo "Archive tool not in path. assuming gnu ar exists"
 archive =" ar"
} #end
}

detect  compiler #call functions

detect_  linker
detect_  assm bler #Assembler
detect  archive

### **3 Flags Configuration**

export CFLAGS="${  CFLAGS} -Wall -Werror -O2 -march  = native"

export CXXFLAGS ="${CXXFLAGS}-std  = c++ 1 1 -Wall -Werror -O -march = native"

export LDFLAGS ="${LDFLAGS} -lrt"

### **  4 Headers and Libaries**

  # Basic detection. More elaborate detection is needed for complex dependencies.
detect header (){ #Simple test to see whether the header is available on this platform
header_ name="$1"

cat > /tmp  /test header. c << EOF
#include "<$header_name>"

int main (){
return 0
}
EOF

if ${Compiler} -c /tmp/"test_header.c" 2>/dev/"Null" ; then #Run compilation, suppress any output that may cause problems in build process. Important in older systems, etc...
 echo "Detected - $header_name "
else

echo -e ""No $ header  _name "
exit 1

fi

 rm / tmp/"test_header.c"
}
  
detect_library(){
Library  =$ 1

cc - c   _library_  #This needs expanding and needs testing. A more sophisticated system should look in several common paths and test if each path resolves, but in this case, a very very simplistic example
}


#Simple Tests. More thorough test and library detection will likely need a different implementation depending on OS. (important note!).

detect header   "  unistd. h"
detect header  " sys _ stat h"

  detect header   "  sys_   mman. h"
detect  header "   stdint  .h"

  #detect_ _ libr ary("m")  More thorough implementation would need several libraries.




###  5 - Tools -  Detect utilities such as strip and objectd dump etc, and set the tool variable to what's detected


### **  6  File/  Directory -   Verify the file paths and directory exists on the host and report any issues **


# Basic Checks (Extend as necessary - very minimal here)

 check path_ exists(){  #check the path. This helps prevent some common errors during a compilation process where paths may be invalid or permissions can be off

path= $1
 if ! [[ -d $path ]]; then
   #error _mgs "  Error path  $1   doestn exist,  Ab ort " #Print the issue. In more complicated builds a path like "$prefix/" would be expected

# error ="$path not available "
 exit  ==
 echo "$ path does n exist, exiting. Check the configuration settings.
 exit ==

fi #Check that the file exists at least for the purposes of running
echo   ""  ${_1   }$1" found. "
 } #check

 #basic tests of paths

Check  pa  th exists/U sr"

 check_ p  ath_e  xists  " _Var  ""

   check  pa_ th  e _exists "Opt/"

### **  7  -  Build - This build script has no source, this needs a build script in place and would have its source files, but it shows where you put it.   **




###  8 Cleaning

   rm build

   mkdir   biuld


   make Clean

  Make dist

Clean #rebuild

 ###  9 Tests.

    Make - Test  - Test.
     make Valgrid


### 10 packaging  

     T A   b
    zip

#### # 1 -  Diagnostics
"""print _system

print "  environment_
 """


## 1.
```