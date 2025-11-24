#!/bin/bash
#set  # Ensure we use the shell in use to run the shell script to run the shell script and use the correct environment
 # Universal build and management script for legacy portability, diagnostics, packaging, patching, deployment, & more across many UNIX platforms 
# Author:  Your Name
#  License: MIT (flexible for commercial projects and contributions)   

 # -------------------- Global settings, functions & initial environment checks -------------- #  
 # 24 hours in the future
EXP = $(($(( $(DATE -d "tomorrow %s " )) - $(( $(DATE + "%s ") )) ))
# Function to display messages colored
color_output()  {
  # tput is needed to use ANSI colour codes. Some systems don 't use ANSI color codes so we provide fallback.  
  tput setaf $1; echo "${2}" ; tput - ;
}
 # Define functions for error and warnings
 error(){
  color_output 1 "ERROR: $1" ;
 }
warn () {

 color_ output $5 "WARNING: $1 " ;
 }

 info ()   {
  # Color info output in white
  echo   "${1}"
 }

debug ()   {
     return

     # Color info output in yellow
  echo   "${1 }"
} # Debug statements can be easily turned to off
# Ensure we have a reasonable environment

 set -euo pipefail
  log () {   local prefix="$1 "
    info "${prefix} - $@"    # Default output in a standard format
   }
   info "Starting the UNIX Build Repository Management Script "
   # Create essential directories
 tmp_dir="/ tmp/unix_build _repo" # Standard temporary dir, check to see if this directory is writable
 log "Setting up working directories and temp directory."
   mkdir -p "$tmp_dir"
 log "Creating log and temp dirs completed."
   log  "Creating log and temp directories"

 # Set LOG_DIR to a more descriptive name that indicates where we are running
 log_dir="/ logs / unix_build _repo "
  create_log_ dir () {
   # Check if it exist before attempting create
   if  [ !   --dir   "$1" ]; then
     mkdir  -$1
   endif
  } # end func
 create_log_ $log_dir
   # ------------------------- Environment & OS Detection -------------------------------- #   
   # OS and Kernel
 OS  = $ (echo $ (uname -s)   |  tolower ); # Convert to all lower- case and use the string value.

 ARCH  =`uname -m`
 CPU_COUNT=$ (nproc )
 MEM_TOT=$ (free -m    | awk '/Mem:/  {print  $2}')

 # Verify basic tools
  for cmd   in  \ uname \ make \ cc gcc \ sed \ grep \ awk;   do # Verify essential UNIX tools
  command  -   v  $ cmd > / dev/null || error "Missing  essential tool: $cmd   .  Check your PATH variable and installation. Please install this to continue the script." # Check to see if this file exists with standard path
     done # end loop

 # Set PATH, LD_LIBRARY_PATH, CFLAGS, and LDFLAGS
   # Normalize PATH (add tmp and standard libraries) and ensure its properly formatted
  old_path=$  PATH
 PATH=$  PATH : "$ tmp_ dir" : "/ usr /bin " : "$ (find / usr / local /bin  -maxdepth 1 -type d)"
   
 LD_LIBRARY_PATH=$LD  _LIBRARY_  PATH : "/ usr /lib  ": "/ usr / lib64 " : "$ (find / usr / local /lib  -max  depth 1 -type d)"

  export  `   printf "%s=%s\n"   "  PATH   " "$ (printf "%q " $   PATH)" | sed 's/: \+/:/g'`
  # Export LD_ LIBRARY_PATH
 export   "${LD  _ LIBRARY_  PATH}"
   info "System Info:" # Standard system info. Useful for diagnostics

   info    "  OS:   $  OS"
   info    "    Arch: $   ARCH"
   info    "  CPU Cores: $ CPU_COUNT"
   info    "  Mem: $MEM_TOT MB "
   debug "   Original     PATH:   $ old_ PATH    " # Display original values before we modify the system
 log  "Initial environment checks and setup completed."

    # ------------------------- Compiler & Toolchain Detection ------------------------------- #
   # 3. Configure Compiler Flag based on platform.  
 compiler_detect ()   {
  compilers=("$ (echo $ (cc -v 2>&    1) | grep "Target:"     | awk '{print  $2}')" \
   "$ (echo $ ( gcc -v 2>&   1 ) |   grep "Target:" | awk '{print $2}') ")
   info "Detected Compilers:"
   for compiler   in  $  compilers; do
    log " Detected Compiler:  $  compiler"  # Display compiler
     done # end loop
 }

   compiler_detect
 log "Compiler Detection & Configuration completed." # Show status

 # ------------------------- System Headers &  Libraries  Detection ------------------------- #
   # 4. System Header Detection: Test compile.  
 detect  _ headers () {
  # Define some test compilation code
  tempHeader =   "
 #ifndef _UNIX _BUILD _REPO_TEST
 # define _UNIX _BUILD _REPO_ TEST
  void main () { } # Simple test function. Empty function.
 #endif "
  
  temp_header_file="$ tmp_ dir / test_header. h "; temp_c_file="$ tmp_ dir / test .c "
 temp_obj_file="$   tmp_ dir /test .o "

 # Save the test header
  echo $   tempHeader > $ temp_header_file

 # Write test program
  cat > $ temp_c_file<< EOF
 #include   "$ temp  header _ file" # Check the file is present
  int main   () { return 0; } # Simple test
 EOF
   
 # Compile test to detect errors
  cc -  c $ temp_header_ file $ temp_c  file  > / dev /null 2>& 1 || { # If this does not work then fail
   error "Could not compile a simple test. Missing headers?"
 }
 log "System headers detected and tested." # Standard status message after completion of test

 } # end func
   # ------------------------- Utility & Tool  Location ------------------------------------- #
   # 5. Locate tools
 find_tool  (){
  if !   command  -   v "${1}" > / dev/null ; then # If tool is not found fail
    error "$ 1 is not installed."  # Standard error message.
 }
   } # end func
 # ---------------------- Filesystem and Directory verification -------------------------- #   
 verify_directory () {
  directory="$1"
  if test  !-   d "$ 1 ";   then
  create  _dir "$ 1  "

  log "Directory $  directory did not exit. Attempting to create now."
  if  [ $? -ne 0 ]; then
  error "Failed to create directory  $  directory. Please check permissions and available storage. Aborting the build."
  exit 1
  endif  # end if create dir
  log  "Created $  directory. Build resuming"
  fi    # end if test
 } # end func
 # Check essential directories
 for dir   in "/usr", "/var", "/opt", "/lib", "/usr/lib", "/tmp", "/etc"; do
  verify_directory "$  dir"     # If not create
 done  

 # Check if writable
 if test  !$ ( echo $   PREFIX | grep -q  writable );    then
  PREFIX="/ usr /local"
  warn "PREFIX not writable by current user. Using default: $PREFIX"
  export  PREFIX
 }

 log "Filesystem and directory checks completed." # Show the build status after checking.

 # ---------------------- Build System (Make) ---------------------------------------- #
 detect_make() {
    if command -v make >/dev/null;   then make_cmd="make";  fi
   if  command  -  v gmake > / dev /null;   then make_cmd="gmake"; fi  
    if command  -v dmake > /dev/null;       then  make_cmd="d make"; fi
    if      command   -   v pmake >  / dev /null;   then    make_cmd  ="pmake"; fi # pmake is for HP-UX
   log "Using make command $make_cmd"     # Show what build manager the build uses

 } # end func
 detect_make # Execute the function for detection of make

 # ---------------------- Compilation & Rebuild Function--------------------------------- #
 build_project()   {
    project_dir="$1"    # Get Project Path and Build the directory.

    info "Building $   project_ dir  .  " # Indicates where this process takes us and the name

   pushd "$project_ dir"  > / dev /null
      # Invoke MAKE with -j for multiple processes if it has CPU cores
 make - j  $ (nproc)
  
     popd   >  / dev  /null   
 log   "Finished Building the project."
  
   }
  
 clean_project() {  
   # Implement `clean` functionality
 log  "Clean project "
    pushd "$  1 "
       make clean >  / dev / null
        popd
    log   "Successfully cleared build files in Project"  
  }

   rebuild_project ()  { # Functionality to clear all previous project and restart project 
 log "Performing full project rebuild from Source Code" # Status update of where process goes
 clean_project   # Call Clear and Build Project Functionality.

   } # rebuild

 # --------------Test Framework (Example: running basic test script --------------#  
  # Create Test Framework to test functionality after Build  
    run_tests() {   # Get project Directory
 project_directory =  "$ 1 "

    pushd  "$ 1 "
         log "Starting automated functional test run..."

  sh test # Runs shell file
          
     popd    
  
     echo
     color_output  3 "Running automated testing..."
  
       [   $ ?   -eq -0   ]     && log "Test Suite: Pass. All test files completed with no issues!" 
        else     error "Testing suite Failed."

     fi  # test status #

}

 log "Tests have concluded, status displayed after execution of script  "
#   
##------------------ Package Build Framework   --------------# #

create_package_archive() {    # Archive build for deploy
project  _  location   =  "$  1 "   # Set directory location from argument. 
 package_location   ="$ 2 "    # Define Package output
 # Package Archive
tar   - c - f  $ package_location "$   project _ location   "  > /dev /null 2>&  1

  }  

  uninstall(){     # Remove package installation files
   }

# --- Container Framework Integration --------------------------#
check_container()   { # Container Check. Docker
     container_name="$1"
       [   -- -d $ 1 ];   then log"Docker/Apptainer Container: "
        exit_0   }

 # ---------Interaction and User Options  ---------
 menu(){   # Menu Selection to guide process and select operations.

 echo " Select  build Operation:"  
    select action in "Configure", "Build", "Clean", "Test", "Install", "Exit"; do

         case  $ action   in
             "Configure")  
                  info  "Starting Configure " ;

               ;;  # Start
           "Build")       
            
              build_project

                  ;;
          "Clean")        # Start of Clear project

                 info   "Initiating the Cleaning of files to free memory..."

              ;;     # Begin

        "Test")
           info   "Executing testing framework, testing all code and functionality  .   Please hold.." ; 

             ;; # Run Function Test  to execute
      "Install")        # Install to location, 
      #    create  Package  build 
               # Install to system or custom locations.  Check and confirm install directory before continuing
              info " Installation Framework Initiated. Please confirm location."
               exit   
            ;;       # Begin installation framework process and prompt. Confirm directory for system

        "Exit")    # Terminate the application 
         
               info " Application has been exited, exiting script "

        exit    

             ;;
     esac   # END  OF   Menu 
        echo   ; # add blank row in console 
   done      # Finished

}

    
    
 # -------------- Main Program flow ------------   -- - 
 # --- Start Navigation -- - 
    
   info   "Build process started  !"
 # -- Display initial system Information
   detect_ compiler # Detect
     OS     and    Architecture

  
    detect   _ headers # Run System Header detection. 

    menu  
  
log   " Build completed, script termination"  
 exit   0  
