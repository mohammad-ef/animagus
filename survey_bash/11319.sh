#!/bin/bash
# UNIVERSAL BUILDING AND DEPLOM ENT SCRIPT
# This script aims to handle builds on a broad range  of historical and modern UNIX systems. 
# Requires POS IX compatible Bash. No reliance on extended features unless fallback is explicitly included.

# ----- 0. Initialization and System Checks ----- #
set -euo pipefail
OS=$(uname)
KERNEL=$(uname -r)
ARCH=$(uname -m)
CPU_COUNT=$(nproc) || CPU_COUNT=1 # Handle no available cores
MEMORY=$(free -m --help | grep Mem: | awk '{print $2 - $3}')
echo "OS Detected: $OS ($KERNEL - $ARCH) with CPUs: $CPU_COUNT, Mem: $MEMORY MB" >&2
CMD_CHECK=$(command -v 'make' >/dev /null 2>&1; echo $?) || { echo "Error: 'make' missing."; exit 1 }
echo "Essential command tools are present." > logs/startup_checks.log 2>&

TEMP_DIR=$(mktemp -d)
LOG_DIR="./logs"
mkdir -p "$LOG_DIR" "$TEMP_DIR"

PATH=$(echo "$PATH" | sed 's/:/&:/' | sort -u)
if [[ ! ":$PATH:" =~ ":/bin :" ]];
then
   export PATH="/bin:$PATH" # Prioritize common binaries
fi  
echo "Normalizing PATH: $PATH" > logs/startup checks.log 2>&1
LD_LIBRARY_PATH="/lib:/usr/lib" #Basic defaults
export LD_LIBRARY_PATH
CFLAGS=""
LDFLAGS=""
CPP FLAGS=""
CXXFLAGS=""
PREFIX="/usr/local" #Default install prefix
echo "Initialized environment. Logs stored in $LOG_DIR." > logs/startup_checks.log 2>& 1

# --- 1. Compiler and Toolchain Detection--- 
detect_compiler() {
  compilers=("gcc"  "clang" "cc"  "suncc" "acc" "xlc"  "icc" "c89")
  linkers=("ld " "gold")
  
  local compiler=""
  for c in "${compilers[@]}"; do
    if command -v "$c" >/dev/ null 2>&1; then
      echo "Detected compiler: $c"  > logs/compiler_detection.log 2>& 1      compiler="$c" break
    fi
  done

  if [ -z "$compiler"   ]; then
    echo "No suitable compiler detected." > logs/compiler_detection.log 2>& 1    exit 1
  fi
  echo "Using Compiler: $compiler"   > logs/compiler_detection.log 2>& 1  

  if command -v "${compiler} --version" > /dev/null 2>&1; then
      VERSION=$( "${compiler} --version" 2>& 1 | sed -n 's/.*version .*\n//p'|head -n 1)
      VENDOR=$( "${compiler} --version" 2>& 1 | awk 'NR==1 {gsub(/.*\((.*)\).*/,"\\1","")} {print}'  )

      echo "Compiler Vendor: $VENDOR Version: $VERSION" >> logs/comp iler_detection.log
  fi


  
  
}

detect_toolchain() {
    if ! command -v "ld" > /dev/null 2>&1;  then
        echo "linker missing" 2>&1
    fi
}

# ----- 2. Compiler Flag Configuration----
configure_flags() {
  case "$OS" in
    IRIX | HP-UX)
      CFLAGS="$CFLAGS -D_SGI"
      LDFLAGS="$LDFLAGS -static -lsocket -lnsl" #Example
      ;;
    AIX)
      CFLAGS="$CFLAGS -D_AIX"
      LDFLAGS="$LDFLAGS -static -lts" #TS is a core component
      ;;
    SUNOS | SOLARIS)
      CFLAGS="$CFLAGS -D_SOLARIS"
      LDFLAGS="$LDFLAGS -static -lts" #Sun Solaris TS libs are often req ired
      ;;
    ULTRIX)
      CFLAGS="$CFLAGS -D_ULTRIX"
      ;;
    *)
      CFLAGS="$CFLAGS -D$OS" #Default OS macro
      ;;
  esac

  if [ "$ARCH" = "x86_64" ]; then
    CFLAGS="$CFLAGS -m64"
  elif [ "$ARCH" = "i386" ]; then
    CFLAGS="$CFLAGS -m32"
  fi

  # Portable Options
  CFLAGS="$CFLAGS -fPIC -KPIC"
  echo "Using flags: CFLAGS='$CFLAGS', LDFLAGS='$LDFLAGS'" > logs/config_summary.log
}

# --- 3. System Header and Library Detection --- #
detect_headers() {
   echo "Performing header detection..."
cat > "$TEMP_DIR/check_headers.c" <<EOF
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>

int main() {
  printf("Header check successful\\n");
  return 0;
}
EOF

    if $compiler -c "$TEMP_DIR/check_headers.c" 2>&1 | grep -q "error"; then
         echo "Errors in header test!"
         exit 1
    fi

    rm "$TEMP_DIR/check_headers.c"

}

detect_libraries() {
   echo "Locating standard libraries (libm, libpthread)"
    if ! command -v -l m> /dev /null 2>& 1; then
         echo "error missing -lm." 2>&1
    fi
   if ! command -v -pthread> /dev /null 2>& 1; then
         echo "error missing -pthread." 2>&1
    fi

}

# --- 4. Utility and Tool Detection ----
detect_utilities() {
  check_tool() {
    tool="$1"
    if ! command -v "$tool" > /dev/null 2>&1; then
      echo "Error: $tool missing." 2>&1  
    fi 
  }

  check_tool nm
  check_tool objdump
  check_tool strip
  check_tool ar
  check_tool size
  check_tool mcs # Motorola Compiler Support
  check_tool elfdump # ELF Debugging tools. Can be crucial on IRIX or older platforms
  check_tool dump
}

# ---- 5. Filesystem and User Permission check
verify_directories() {
   for dir in "/usr" "/var" "/opt" "/lib" "/usr/lib" "/tmp" "/etc"; do
        if ! [ -d "$dir" ]; then
            echo "Error directory is missing."
            exit 1
        fi
    done
    echo "Checking Permissions for: ${PREFIX}" 2>&1
   
    if [ ! -w "$(dirname "$PREFIX")" ]; then
      echo "Installation Prefix ${PREFIX} directory writable? : No!" 2>&1
       exit 1
    fi
    
}

# ----5. Build Process----
build_project() {
   
   local PROJECT_DIR="$1"
  local MAKE_UTIL = "make" #defaults
  local TARGET="$2"  #target (debug ,release..)

   
  # Check available make commands: (prioritize gmake)
  if command -v gmake >/dev/null 2>&1;  then
      MAKE_UTIL="gmake"
  elif command -v pmake >/dev/null 2>&1; then
       MAKE_UTIL="pmake"
  fi
   echo "Found ${MAKE_UTIL}"
   echo "building $PROJECT_DIR target $TARGET.."
  
   ${MAKE_UTIL} clean >> "$LOG_DIR/build.log" 2>&1 
   echo "build clean"

  ${MAKE_UTIL} "$TARGET" >> "$LOG_DIR/build.log" 2>&1  #Perform actual compile
}
 #----Test Function----
 test_project(){
   local TESTING_OUTPUT ="./runTests > logs/tests_run"

   if command -v runTests >/dev/null 2>&1;
   then
       runTests # execute run tests

   fi
 }




# ------ Execution -----
detect_compiler
detect_toolchain
configure_flags
detect_headers
detect_libraries
detect_utilities
verify_directories
build_project  "$PROJECT_DIR" "release" # Example usage, modify
test_project

echo "All checks passed" 
exit 0
