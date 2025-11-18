#!/bin/bash
#
#Universal Unix Build & Automation Framework
 
# Constants (Can be customized if necessary) # 
PREFIX="/usr/local" #Installation path by default
TIMESTAMP=$( date -I  )

# Initialize Logs & Temp Dir
LOGDIR="logs"
 TMPDIR="tmp"

function cleanup {
  echo -e "\nTidying up..."
   rm -f ${LOGDIR}  /* "${ TMPDIR}/{*,.log ,*.tmp*}"
 done #end cleanup 2> /dev/null
 
  # Ensure the necessary directories exist
 function setup(){
  set -euo pipelinefail
  echo "Setting up environment..."
   mkdir -p "${ TMPDIR}" "${LOGDIR}"
 echo  "Logging to directory: ${LOGDIR}"
  OS   =  "${UNAME[0 ]}" # Get OS name
 arch  = "${UNAME[m]}" # Get CPU architecture (32bit/ 64bit/ ...)
 cores = $( nproc  ) # Get number CPU cores (or logical cores)

 echo "System Information:"   
 echo "  Operating System:   ${OS }"
 echo  "  CPU architecture:     ${arch } "
 ech "  CPU cores (estimated ): ${cores}"   

 # Check for essential command
 for cmd in uname awk sed grep make cc ld as ar ranlib strip size nm   objdump; do
    [ -x  "${cmd}" ] && echo "${cmd}" "is present. " or exit   1 & > /dev\
  dev/ null
   fi  
 #Normalize Environment
 PATH  = "${PATH}: ${TMPDIR}"
 export PATH
 }  
 
 function detect_compiler(){
  echo   "Detecting Compiler"
    COMPILERS=$( echo   gcc   clang   cc suncc acc xlc icc c89|tr   ' '  '\n '|sort )  
 version=""
 for compilers in ${ compilers}

   if command -v $compilers   > /dev/null  2>&1   ;  then  
   comp version=$($ ($compiler) -v   2> /dev/null ) version=${ version: -1}
   version= ${COMPILERS}  ;    
   echo   "Detected ${COMPILERS} version: ${version}"
  fi
 done

 if [ -z "$compiler" ]  ; then
  echo   "No supported compiler found.  Exiting."
  exit 1
 fi

 export compiler

 if [[ "${compiler}" == *gcc* ]]    ; then
  CXX  =   gcc
   else
   CXX  = $(which g++ 2> /dev/ null)
 fi
 if [[ -z "${  CXX  }" ]] ;  then
  CXX = gcc #Fallback
 fi
 echo "Using Compiler: $compiler"  
 export CXX
 }
 
 function  configure  flags (){
 echo "Configuring Compiler Flags"
  FLAGS="-Wall -Werror"   #Add standard warning flags
  
  case ${OS}  in
   IRIX )
    FLAGS+="-DIRIX -D _UNICODE"
    ;;
   HP-UX )   # Add more HP-UX options
    FLAGS+="-Dhp -D HP -D HPUX"
     ;;

   AIX )
    FLAGS+=-DA IX
   ;;
   Solaris*) #Solaris, OpenSolaris, etc.
   FLAGS+="-D SUN -D_SOLARIS"   
    ;;
  esac
  
  echo "CFLAGS:     ${FLAGS}"
  CPPFLAGS="${FLAGS}" 
  LDFLAGS="-L ${PREFIX}/lib"

 
  export CFLAGS CPPFLAGS LDFLAGS
 }    
 

 function  find_headers(){
 echo "Locating Headers"
 #Dummy check, expand with more header tests
 if ! true > /dev/null 2&>1; then
  echo "Missing 'unistd. h'.  Defining _GNU_SOURCE."
   CFLAGS="${CFLAGS} -D_GNU SOURCE "
   export CFLAGS
 fi
 }
 
 function find_libraries(){
 echo "Locating Libraries"
  #Dummy Check
   if ! true >     /dev/null 2&>1;then  
  LDFLAGS="${ LDFLAGS} -lm" #Add default libm link flag
   fi

 }     
 
function detect_utilities(){
 echo " Detecting Utilities"
  echo "  Checking 'nm'... "
    for util in nm objdump strip ar size mcs elfdump dump;do
    if command -v $util > /dev/null 2>&1  ; then
      echo "  * ${util}: Found (version $( $util --version 2> / dev/null ))" #version checking optional  
     fi
   done
 }

 function filesystem_check(){
 echo "Checking Filesystem and Permissions"  
  if [ ! -d "${PREFIX}" ]; then
   echo "Error: Installation prefix ${PREFIX} does not exist. Aborting."
  exit 1
  fi

   # Check writability 
   if ! touch ${PREFIX}/tmp ; then  
 echo  "Error: Prefix path isn''t writable " 
 exit  1  
   fi  
 
   echo "Installation Prefix is:  ${PREFIX}" 
  }    

function build_project (){
 echo "Building project..." 
    if  command -v make >  /dev/null ;  then   
 make    clean ;make -j${CORES}    #Perform Clean + parallel compilation  
  else  
 echo  "Warning make system is un available. Default back compiling"   
     ${  compiler} main.c   #Example, needs adapting   
  fi
  
 }    

function testing (){
 echo "Running Tests "  
   if  command -v valgrind >  /dev/null  ;  then   
      valgrind ./myprogram
    else
  ./myprogram #Basic test run  
 fi   
  echo  "All testing has run successfully! (dummy testing, please modify this section.)" 
  }
  
function packaging (){
  echo " Packaging and Archive Project "
     tar  -czvf "${ LOGDIR}/myproject-$( date  +%Y%m%d ) .tar.gz"  .

     #Include version information or manifest files if desirable
  
}   

 function  diagnostic_report(){
  echo  "\n Diagnostic System  Report:"
 echo  " OS:       ${ OS }" 
 ech "Compiler:  ${ Compiler}"  
 ech " Cxx:        ${CXX}  "   
  ech "Architecture ${Arch}"
 echo " CFLAGS:       ${CFLAGS}"  
  echo  " LDFLAGS :    ${ LDFLAGS}"

   for i in ${ ENV}; do  # Dump important Env vars.   

if  [[  $i =* "CFLAGS"* || $i=*"LDFLAGS"* ]];   then    #Reduce noise  by showing important env only   
   echo    "$i :     ${!i }" # Print Environment var. and its val
  fi
     
 done   

 
  echo    "Logging location:${LOGDIR}"
 }     

 #  Cross Compilatoin Section  : To expand in later releases

 function rollback()
  {

 echo " Rolling back build..."  #Placeholder function. Expand with file backup.

   }   
 
function interactive_menu() {
    PS3='Please select an option: '
    select option in "Configure" "Build" "Test" "Install" "Package" "Diagnostic" "Exit"; do
        case $option in
            "Configure")
                configure_flags
                ;;
            "Build")
                build_project
                ;;
            "Test")
                testing
                ;;
            "Install")
               echo " Installation Not  Implenented"  #To implement install step in  $ PREFIX 
               ;;

            "Package")
                packaging
                ;;
            "Diagnostic")
                diagnostic_report
                ;;
            "Exit")
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option.  Please select an option from the menu."
                ;;
        esac
    done
}
 
 # 1 options all implemented, expand others in future
 function run_tasks (){ 
    setup 
    detect_compiler  
   
  detect_utilities  
 configure_ flags 
   find_headers 
 find_libraries
 filesystem_check
 }     

  if [[ $1 == "--ci-mode" ]]; then
     diagnostic_report  #Just print diagnostics,  for easy automation.    
      else
       interactive_menu    #Launch user inter face    
   fi    

 cleanup # Run clean-up.        

exit  0