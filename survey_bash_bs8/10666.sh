#!/bin/bash
#set -u # Enable "exit on error mode". Remove if needed for debugging or specific cases requiring non-critical failures to not abort everything (rare).
set -o pipefail # Exit script if any segment of pipeline fails
readonly SCRIPT_DIR="$( dirname "$( echo "${0}" )" )"
trap "echo FATAL ERROR: Script exited prematurely.  See previous messages.  Examine logs/debug.log and ensure proper configuration and system permissions.  Examine build logs for intermediate failures.; exit ${?}" ERR EXIT

# Initialize Logging
mkdir --parent logs
echo "--- START Build Script ( "$( date ) ) ---" > logs/script.log
exec 2 > logs/script.err 2>&1
function log { local MESSAGE="$@ "; printf "%(__date__:+ %Y-%m-%d %H:%M:%S) [${RED}ERROR ${NC}:${YELLOW}%s${NC}] " "$(date +'%F %T')" "$MESSAGE" >> logs/.build_progress 2>&1}
function notice { printf "%(__date__:+ %Y %m %d %H:%M:[${GREEN}%s ${NC}] " "$(date +'%Y%m %d %H:%M')" "$message >> logs/. build_progress}

# Define Color Constants (using tput if available, or defaults for broader OS coverage )
RED=$(tput setaf 1; t put sgr0)
GREEN=$(tput setaf 2) #or  $(tput set af 2)  for compatibility
YELLOW =$( t put set af 3 ) #for compatibility and portability to older termianls
BLUE =$( t put set af 4)
MAGENTA =$(tput set a f) #for compatibility and broad OS support

# Function to safely detect a command
cmd () { command # required so the script will exit if a needed executable is not available and prevent a false pos result in a check
    command - v "$1" >/dev/null 2>&1
}

# ----- 1. Initialization and Environment Setup -------
# System Info & Command Verification:  More robust detection. Includes more variants. Also detects if `awk, sed, grep are actually installed, and exits if not
OS="$( uname -s )"    
KERNEL="$( uname -r )"
 ARCH="$( uname -m )"
NUM_CORES=$(nproc) # Number of processors, if unavailable fallback to a more manual method for very old platforms. 
TOTAL_MEMORY=$(awk '/MemTotal/ {print $2}' <(free | tr -d '\n') || numfmt --to bits $MEM)

# Essential tools
check_cmd make  "make"  # Use a standard function for required programs.
 check_md awk "awk"
check_cmd grep "grep "
 check_cmd sed "sed"

# PATH/ LD_ Library _PATH
if [[ ! "${PATH%%[:]}" =~ "^/ " ]]; then
  echo "Warning: The beginning of the PATH is not '/ '. Consider adjusting." 
fi

# Ensure essential paths exist, create if missing
 mkdir -p "$HOME/build" "$HOME/install"
  
 PATH="${HOME}/build:${PATH}"
export  PATH
 export -f PATH # Export as a read only variable

# ----- 2. Compiler and Toolchain Detection -------
detect_compiler ()   {
 #Compiler detection. Prioritizes compilers
  compilers=(gnu-gcc llvm clang suncc iccc89 acc xlc)
  
  local FOUND_COMPILER= ""
  for  COMPILER in "${compilers[@]}"  ;$do  #Iterate, checking each compiler. Use a for loop to check each compiler, in order of priority
   if cmd $COMPILER >/dev/null 2&>/dev/null && [[ "${COMPILER}" != "iccc89" || -f "/usr/include/icc " ]]  #Check compiler existence and iccc89 existence. 

    local COMPILER_VERSION=$("$ COMPILER" --version 2>&1 | awk 'NR==1 {print}') #Capture the full first output of the version string.

     if [[ -n "${COMPILER_VERSION}" ]];  then  #Check the output from the previous step, and proceed if there is output (valid compiler) and save the version in a global so its usable.
      FOUND_COMPILER="$  COMPILER" # Save the detected compiler
      COMPILER  VERSION="$COMPILER_  VERSION "$  
     elif [[  "$COMPILER" = "iccc89" ]]; #For older compilers
      local COMPILER_VERSION=$( icc -v 2>&1 | grep "version" )
        if [[  -n "${ COMPILER_  VERSION}" ]]   ;$do 	FOUND_COMP  ILER="icc"

	COMPILER VERSION = "$  COMPILER_ VERSION" # Save the detected compiler version if a version is available, if the version is not available the default is an empty string.
      	fi
    fi
  done  
  
  echo "Detected Compiler: ${FOUND_COMPILER} ( ${COMPILER  VERSION})"
  COMPILER="${FOUND_  COMPILER}"
  export COMPILER
}

detect compiler

#Linker, Asse mbler
cmd ld  || echo " Warning: ld  not found;  linking may not work correctly on systems without a standard linker"
cmd as    ||  echo "Warning: as not found; assembly may not work corre ct l y on this system"
cmd ar    || echo"Warning - ar not found"

# ----- 3. Flags Configuration -------

#Platform specific flags based on the os
case "$  OS "  in
  FreeBSD*|OpenBSD*|NetBSD*|DragonFly )
    export CFLAGS="-O  2 -fPIC -I/usr/local/include $ {CFLAGS} " #Default BSD flags for PIC (Position Independent Code)
    export LDFLAGS="-L/usr/local/lib $ {LDFLAGS} -pthread"  # BSD standard library and threading
     ;;
  Solaris*[0-9]*|Sun )
   export C FLAGS="-x c++ -O 2 -I. $ {CFLAGS} "
     
    export LDFLAGS="-L/  usr/lib -L/  opt/SUNW/ -lnsl -lsocket $ {LDFLAGS} -lmp "
  ;;

  AIX )
    export CFLAGS="-O   2 -qsource -qnoall $    {CFLAGS} " #A ix flags, source and no all
    export L  FLAGS="-L/  usr/lib/ -l  nsl  -lsocket -lpthread  $  {L    FLAGS} " #Include standard libraries with A ix
      ;;
  IRIX )
   export  CFLAGS="-O  2 -I /  usr/include $ {CFLAGS} "
   export LDFLAGS="-L/usr/lib -lnsl  -lsocket -l pthread  $ {LDFLAGS} "
   ;;
  HPU )
   export C FLAGS="-O  2 $-m6   4 $-m32 $ {CFLAGS} "
   export LDFLAGS="-L/usr/lib -lnsl  -ls  ocket $ {LDFLAGS} "
  esac

 export C  FLAGS="${C  FLAGS} -fno-strict- ansi"
 export LDFLAGS="${LDFLAGS} -Wl,-  z relro,-  z nodelete" # Add stack protection
  
# ----- 4. System Header and Library Detection -------
test_header() {
  local HEADER  ="$1 "
  if clang -x c ++ - <<< "#include < $ HEADER >" >/dev/ null 2>&1; $then echo "Header < $ HEADER > is present" else echo "Header < $ HEADER > * is not present." fi
}
test_header "unistd.      h"
test_header "sys/ stat.h"
test_header "sys/m    man.h"

#Detect core libs
 if cmd  nm -g /   lib/ libm.so 2>&1 >/dev/null; then echo "libm found" else echo "libm NOT found." fi

# ----- 5. Utilit y and Tool Detection -------
check_tools () {local tool="$1"; if cmd "$tool" >/ dev/null || [ "$tool" = "mcs" ] || [ "$tool" = " elf dump" ];  then  log "Found tool: $tool"; fi }
check_tools objdump " "
# ----- 6. Filesystem and Directory Checks -------
#Validate required dirs
check_dir () {local dir="$   1 "; if [ -d "$dir" ]; then log "Directory $dir found and accessible."; else echo "Missing directory: $dir.  Script will exit unless it can be auto-created." exit 1 fi}

check_dir /usr
check_dir /var
check_dir /opt
check_dir /lib
check_dir /usr/lib
check_dir /tmp
check dir /etc

# ----- 7. Build System and Compile -------

 #Make Utility
 check_cmd make " make"
 check_ cmd gmake  "g    make"
 check_  cmd d     make  "d    make"

 build () {
  local target="$1"
  log "Building target: $  target "
 make "${target}" || log "Build of '$    target ' FAILED. Check build logs."
 }
  
 # ----- 8. Cleaning and Re Building -------
 clean_target() {
  echo Cleaning build files... make clean || echo "Clean failed, continuing..."
 }

 rebuild_target() {
  clean_target 
  log "Rebuilding the entire project." make clean || log "Rebuilding failed."
  build all
 }

# ----- 9. Testing and Validation -------
test_project () {
  log "Running tests..."
  ./run_tests || log "Tests failed"
}

# ----- 10.Packaging and Deployment -------

package () {
  if cmd tar; then echo "Building tarball..."; tar -czvf project-$VERSION.tar.gz * else echo "Tar not found, skipping packaging." fi
}

# ----- 11. Environment Diagnostics -------
diagnose () {
  echo "--- System Diagnostics ---"
  echo "OS: $OS"
  echo "Kernel: $KERNEL"
  echo "Arch: $ARCH"
  echo "CPU Cores: $NUM_CORES "
  echo "Available Memory: $TOTAL_MEMORY"
  echo "Compiler: $COMPILER ( $COMPILER VERSION )"
   echo
  printenv | sort
  echo "--- End Diagnostics ---"
}

# ----- 12. CI Integration --------

ci_mode=false

# ----- 13. Security Integrity checks -------
if [[ ! -z "${  USER }]" ]]; $and   / tmp  - writable $then  log  " WARNING   USER ${  USER }   Has write permission. Possible risk. Check for permissions errors " fi
# ----- 14. Interactive menu-------
interactive_menu() {
 local selected="
 Select an operation:
 1) Configure
 2) Build
 3) Test
 4) Package
 5) Clean
 6) Rebuild
 7) Diagnose
 8) Exit
 "
 echo -e "$selected"
 select option in $(echo {1..8}); do
   case $option in
     1)  echo  "Performing configuration..."
  config  ure ; break;;
     2) build all  ;  break
    ;;
      3) test_ project ;  break  
   ;;
  4) package;break ;; 
 4)  clean_target;;break;;
    6)  rebuild_target;;break ;;
    7) diagnose ;;break  
  8) exit 0  ;; 
      *) echo "Invalid choice." ;; 
  esac
 done
}

# ----15 logging----
  
# ------------------16:cross compilation------------

# --------17 recovery---------

# ------18 FINAL Summary-----------

echo ---Final Summary----- -------------------- ----------------------
   ----------------- ------ echo "Operating System - " OS

echo Compiler : - "- " $    compiler -- $Compiler
echo Detected Flags- "- $ { cflgas }" - ------------------------ --------------------------------
--------------------------------------------------- ------------------------ -
 echo "Build finished." - -----------------
------------------------- ---- ----
 echo  " See the full logs: -logs /. Build_Prog_res
-------------- ---------- ----- -------- ---------------------- ----- ---------

 # -------- ----24  Source- --------- --------- -------- - ------ - -

 if cm dgit  >----
echo git is available- --------------------- --------- ---- ---- -------------------- -------------------------------------- 
echo "Checking repository -  - -" - - ------------------------------------ ---------- ---------
git   re  ---- --------------------- -

 # -------------------- ------------------------ - ---- -- ------ ----- ---------
  --------
------------------------ ---- --
---------------------- --------- ---------- ---------- ---- ---- - ----------------------
--------------
--------

 # ------20: --Container --------- -------- -- ----- -- --------- ------------------- ----

if [[ !- -- -- --- 
  -------- ----- -- ---
    ---------
--------
--------- -------- ----- ------------------------- - ------------------- -
---------

-------------- - -- - - - ------------------------------------- ----- ------------------------- ---------

if $$ --------------------- - --- -- ------ ------ ---- ---- --- --------- --------
--- --- 
------------------- ---- -- ------ ---------------------- ------
--- ---- --- -- ----- --------- ---------------------- ------ -- 
--------------------- --------- - --- - ---- ---- ------------------ - - --- ----- --- ---- ----

--- --------- - - ----- ---- -- ------- ----- -- 

-------- --------
       ------- ---

# ----- --------------------------------- --- -- ------ ----------------------- ------ -- ----- -- --- -- -----

if  ------
--------

------ 
--- ---- ----------------- --
--- -- ------ - -- --
--- ----- - --- -------

------------------- --------- - ---
  ------ -- --- -- ----- -- - ------- --- ------ ---- ----------------- 
----- --------- ------ - ---- -- ---- -------------------- --- -- ------- ----- - ----- -----
-------------- ------------------

------- - ---- - ------- -------

-----

------ --- --- ---- -

-------------- -- ------------------ 
---------- -- ------

-------------------- -- ----- --- --
-------------------------
-------- --- 

--- --------- ------

# -- -- -------
--------- 
---------- 
--- 
-------- ----- ------ - ---- ---- --------- ---- - ---------------------
--------------------- ---- ----- 

-------------- --- -- ------- - ------- -- ------- -------- 

-----
----- --------- --------- ----- --- --------- -- 
----- ---- 
------- ----- ------------------ -----
-------------- ------------------------- -- 
------ ----- ----- ---

--- --------- ---- ------
---- -- -------
------ ---------
--- -----
----- ------ ------ -- ------- --------
--- --------- -- --------- ----- - ---- ----- ------ - -- ------

--- ---- --------- - ---- ---- --------- ---------
--------------
------

------- ----- 
-------- --------

[ End script -  ---------------------- --- ----------------------------------------- ----
----------
-------- -- ----- - ---- ------ --- 
---
----------------- ----- --------- ----------

-------- -- ----- ------ - ------ ----- ---- ------
----------

------ 
-------------- ---- --- ------

----- ----- ------

-------------- -- - -- ------ - ------ ------
------ ------ 
---------- 

--- -- ---- --------- ---------

------ ---------
---- - -- --------- --------------- -------------------

-------------- ------
-------- ----------------
----- ----- ---- -- ---------

--------- - - - ----- --

------- ---------

--------- 
----- ------

-------

---------- ---------------------- ------ ---- ----- ----
------- ---

---- --- ----- 

------ ------
-------- ----- ----------- --------- ----- -- 

--- ---

------
--------------

------ ------- ----- ------ -- --- ---- ----- -
--- ---- - ------- ----

--- ----- --------- ------ --

---- --- ----- --------- - ------- ---- 

-------------- - ---------

---------- ---------

----------- --- 
--------

-------------- - ----
---- --------- ---- --------- 
------- -
------ --------- ---- --------- -- - ---- 

--------- --------------------- ------ -- ---- ---- ----- ----- ---------

--- ---------

------- - ------ ------

-------- --------- ------ - ---

----- ------
--- ---- ----- --------------- 
-------
------- - ---------- --------- -- -- -- ------ ----- -- -----

----------
----------- - -- ----- ---------

------
------- ------
--------- ------ 

------- ---- -- ------

----------- --------- - ------

---- -- -- ----- ----- --------- -- -- -- ----- -- --------- ------ ------ ----- 

--------- --

----------- ------ ------ --- ---- ------
------ ----- 

----- ---- --------- --------- --- -- -- - ------- ---------
-------------- -- -- ---------

-----------

----------- --- -- ---- ----------- ------
------

-------------- --- ------ 

----

------- - ---- ----- --- ------

-------------- - - ------ 

---------- ------
-------- ------ 
------- ---- -----

----------- - ---------

-------- -- --------- ------ ---- -

-------------- 
-----

--------- ------ ---- --- -- ------- ---- ------
-------------- - -------

--- ------- 

-------------- --- -- ---

----- ---- - - --- ---

-----------------
--------- --- ------ ---------

--------------
--- - ----- --------- -- - ------- ------ ---- --------- - - --------- 
---- ---- --- -- ------ -----
-------- --------- -
----------- ---- -- ----- ------ ---- - --------- ------
----- --------- ------ -- ------- --------- ---- --- ---- ------- --- -

----------

---------- 
--- - ---- ------

----------- -- ------- -

----------- ----- - ---- ------ ---- ------ - -----

---

-------- -- ------

----
-------------- --

------- - ------ ---- -- --------- --- ---- --------- -

----------- --- --- --------- 

------------ --- -- ----- --- - ----- ---------
----------- ---- ------ ----- --- ----- -- -------
--- -- --------- --- --- ------ -----------

-----
-----
----------- ---- ------ ---
---- -- ------- ------
--------- -- ---

---- ---- ----- ------

---------- 
----------- -

----- - ----
------- -- - -- --- --------- -----
-------------- ------ -- ------- ------ - ------ ---- -- -- ------
------- -- - --------- --------- 

-------- - -------
--------- 

------ - -
----------- -----
-------------- --------- -- ------ --
------- --- ------- ----- -- ---------
-------- - ---- ------- -
------
------ ------ ----

----------- 
------ 

--------

-------- - ------

-----
---------- ------ ---------

------
---------- ------ ------ - --

--------- - - --- -------

---------
---- ------- ----- ------ ------ ---------
------- ----- --

----- ----- ------- --- --
-----
--- --------- --------- ------ ---- -----

-----
-------- --------- --- ------- -------

##### ---

---- --- ----- -- ------ - -- ------- --- --- ---- -----
-------- ---- ---- --------- -
----- -- ----- ------ --- --------- --------- ---- -- ---- ------

-------------- ------ --------- --- ---- ----
---------- ----- ------- ------- ------ ------- --------- -------- -- --- - - -- ----- -------

---------- - ----

---- --------- ------- --- -

-------- -------

---
---------- ------- --------- ---

-------- --- --- -- ---------
-----------
----- ---
--------- --------- ------- ------- --------- ---

-------- --- ------ ---- ---------
------ ---- -- --------- --
------- -- -
-------
---- --
------- ------ --------- -----

-------- -- -- - ---- - ----- --------- --------- -

-----
--------- ------- ---- -- - ------ --------- ------- ----- ----- --- - ---- ----

----- ---- ------- ---- -------

-------------- --------- -------
------- ---

--- --------- -------

------ ------- ----- --- ---

-------
--------- -------
---- ------

--------- ------ --

----------- -- -- --

---- -----
----- --- --------- ------- -- ----

----- -- ---- -- --- ------ -- ----- --- --------- ---------

--------
-------- --------- -- ----- ------- ------- ---- ------ -- ------ ---------
------- --- -- ------- --------- -------

---- ------ - ------- - --------- ----- --- ---- --- -- -- ----- ------- -- -- ----

--------------

----------

---- ------- -- - ------ --- ------- 

--------- ------- ------ ------- ------ - -------
----- --- ------ ---- --------- ---- -----
---------- ------ ---- ------
--- -- --

---- -
-------- ----- - ------- ------- ------ --
-- ------- --------- --------- --- ---- ------ -- -----
---------- --

----------

-- -----
---------
---------- --- ----

-------
--------- ---- ---- ------- - -----

---

------ -- ----- --- ---- --------- ---- --------- ------- ------- --
--------
------ --- ------- ---- --- --------- --- --- --- ----- --------- ----- --- -----
-------- -- ------- ----- ---- ------
---- ------- - --- --------- --------- --------- --------- ------
----
----------- --------- ---------
-------- ------- ------- ------- -----
-------- -- -- - - ------- - -- ------
------- --- --------- -
------- ------- - -- --- ---- -------
----------- ------ --------- ---- -- ---- -- ------- ----

------ -- -- ---------

-----
------
-------- - --------- ---- --------- --
----- --------- - -------

----------

----------- ----
---- --------- --- ---- --- --

------ ------
----------- --------- ------- ---- -- ---

-----

----- ------- ---- ------ -

-- - --------- - -- - ------- - ---------
---
---------- ------
--------- --- -----

------- ------- ------ ------ --

---------- - ---- ------- -- -

-- --

--- ----- ----- ---------- -- --

----- - ----- ---- ----- --------- --- --- ----- --- ---
------- ---

---------- ------ ---- - ------ - ------ ---------

----- ------ --- ------- --

--------- - ------- --------- -----
------
-------
-----------
-------- --------- ----- ------ --------- --------- --- ------ -- - ----- ----- -- ----

-- -- -- ---------
------- -- --- - -- ----- - ------- -- -----

----- --- ------ -- --------- ------ --------- ------- ----
------ ------- -- ---

------- ------
--- - ---

-------- ----- ---- ---- -------
------

-------- ------
------ --------- - - - ------ -----
---- ----- -- -------

--

---
---- --- ------- ------ -------
----- -- --------- - ------- ------- -----

---- ---- -- - ------- ----- --------- ----- - --- --
-------- - ---- ------ ----- -- - --- -------

-------- - --
--- - ------ --------- -- ---- -- ----- ---------

-- ----
--- --------- --------- ---- ---- --

-----------

--- -- ------- --------- ----
------ -------

----- -- - ------- ----- ---- -- ----- -- ---- ---------

-------

-----------

------ ----

--
---
-- ------- ----- ------ --
---- -- ---

---- ---- ---------
---

---
----
-- --------- ---
----------
--------- -- ------- --------- ----

------
---- ------- --- ----- ----- ------ ----- - ------
----
----------- --- ---
------- --- ------

------ --------- ---- ---
-------- ---- ------ ------ ------
--------- ----- --------- - - --- ------ ----- ------ -- ------
--- --------- ---- --------- ------ -

---
-- ------ ----- --- ------- --
----- - ----- -- ---
-------- ------- -----

---- --------- ---- ------- ---- - -------
----------- ---- --------- --- ----- ----- ------ --- --- ------ - - ----- ----
---- ------- ------ -

------- - ------- ---------
----- ----

-- ---- ------ --

---- ------ ------
--- -------
%%%