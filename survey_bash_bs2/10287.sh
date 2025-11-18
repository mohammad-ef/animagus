#!/bin/bash
# UNIX Universal Build & Deploy Automation Tool (UBUBAT v1.0)

# 1. Inititalization && Envrnmnt Setup
OS="UNKNOWN OS"
ARCHITECTURE="Unknown Architechture "
MEM="0" CPPU="0 "
KERNEL_INFO ""
FUN=() LOGDIR= () TEMPLOGDIR () TEMP_LOG ()


FUN(){  local log_prefix ="[$0: $($] ${1:-Build}  : $FUN ]" }
log ()  { fun log_prefix  $1 }

detect os

verify_tool "unAME" "Check UNIX"
verify "grep -q awk"; verify 'echo $PS1| grep "\[\["' && echo 'detecting terminal coloring' && COLOR_ENABLED ="yes"
normalize_path && normalize env

mkdir  logs  ${FUN: "logs"}" || echo "Logs folder creation error."

# Create tmp directory if doesn's exists
TMP=$( find tmp_build || echo tmp_build) || mkdir -v ${TMP} 2>/dev  # /Dev is not needed as mkdir handles errors 

set -eouo pipefailure
# 3. Compiler Detection

DETECT COMPLER
# System Check
CHECK SYSTEM DIRECTORIES


check compiler flags;
check system headers;
# Tool Chain
CHECK TOOL CHAIN

# Check if make utilities
detect Make;  check utilities
detect file check; detect backup;

# CI MODE flag 
CI_MODE ="false" ;

while [[ "${#$@ }" > "$CI MODE"] ;do case -s "${FUN :1}: $0  "${1} in  --ci- mode  "-c"; do  ci_ MODE ="true " ;shift;done; done
check_ ci


BUILD_PATH ="./"; INSTALL_ PREFIX =`/usr  local`;


function verify(){ echo "verifying  : $1";  cmd="$1" && $FUN  $1 }

detect backup location && check file system
function backup {

}
# Main Execution
function  build{
} 2>/dev

# 4. Compilers Tool Chains

COMPL  =
ARCH  

find -L /bin -wholename /usr /bin -typef  |
  awk -f  "{print \$NF  /usr  /opt }"

# 18 Recovery, Roll Back and
  

# 5 Utility Tools
  #21 patching legacy maintnace
  # Check for the presence of utilities such as grep, find, awk, etc.



function detect backup locations
  BACK UP LOC =""
  check directory "/back  /home backup /mnt backups " BACK UP LOC= "$1" BACK UP LLOC =" $BACK"  "

# 
# Main Menu

function interactive_menu {


}

  
exit
  


detect_ os

OS_NAME="$(  unAme | grep  -Eo '^ ([a-zA-Z]+)' )"

  

  # 3 Compiler tool

detect compiler {
}
normalize path

function detect os; echo "OS detected $os_ NAME ";

detect backup location { }


  
verify command

function verify {
}


function normalize_ path {
}



# Check file

function detect backup locations
  BACK UP LOC =""
  check directory "/back  /home backup /mnt backups " BACK UP LOC= "$1" BACK UP LLOC =" $BACK"  "

# 
# Main Menu

function interactive_menu {


}

  
exit
  


detect_ os

OS_NAME="$(  unAme | grep  -Eo '^ ([a-zA-Z]+)' )"

  

  # 3 Compiler tool

detect compiler {
}
normalize path

function detect os; echo "OS detected $os_ NAME ";

detect backup location { }


  
verify command

function verify {
}


function normalize_ path {
}



# Check file

function detect backup locations
  BACK UP LOC =""
  check directory "/back  .backup /mnt backup /backups"
  back_ UP_LOC ="/opt/ backup"

# 4. system check
  # Check that libraries exist
function check directory; echo "verifying system directories";
  
function verify tool()
  check
}
  check utilities

# 16 cross compilations

  #23 paralell building



#25 system sevices

# Main

#  
#  exit with a code 



if [[ "$COLOR ENABL" = "yes  " ]

} else { }

# Exit status
exit
  
if [ "$ CI MOD " = "true"; then exit 0 fi;

interactive menu
exit;

# Function Definitions

function verify tool { 
}

  check command
  # 8 Cleaning rebuilding



detect backup location

exit

``` 1
``` 2

echo 

echo 

  

``` 3

exit 

  
echo 



exit 0
exit; 
exit
exit
exit 2

echo 
exit

  
exit

exit; 
exit
exit; 
exit

  
exit

exit; 4 4
exit
 exit;

exit 4
exit
exit 5
exit
exit

  echo
 exit 5
exit
exit
exit
exit

  print;

  
exit

exit; exit 6
exit
exit; exit;

  
exit

exit;  echo
 exit 6
exit
exit
exit
exit

  
#exit

  echo
 exit

exit 7
exit 
exit
 exit; exit
exit
exit
  7; print
exit
exit 

exit

exit; exit;
 exit

exit exit exit
exit exit 7
exit; print;
exit
exit
exit exit;
 exit

exit 7
exit

exit 8
exit exit;
 exit

exit exit

exit
 exit 8;
 exit
exit; exit;
 exit exit;

exit 8
exit

exit

exit; exit 9;
exit
 exit 9;
exit exit

exit
 exit exit; exit9
exit
exit exit;
exit exit exit 9

 exit

  print
exit

  
exit

exit; exit1 
exit

  
exit

exit; 4 4
exit
 exit;

exit 4
exit
exit 5
exit
exit

  echo
 exit 5
exit
exit
exit
exit

  print;

  
exit

exit; exit 6
exit
exit; exit;

  
exit

exit;  echo
 exit 6
exit
exit
exit
exit
 
#exit exit exit
exit

exit 7
  
```
```bash 
exit
exit; 1
``` 

echo 

 echo.

 exit; exit9
exit
exit exit;

exit
exit exit; exit 4
exit
  print
exit

  
exit

exit; exit1 
exit

  
exit

exit; exit10
exit 

 print;

 exit1 1
``` 

echo 

 echo.

 exit; exit

exit
 exit exit; exit

exit
 exit exit

```
exit
exit 5
exit
exit

 echo

```

 echo

```
exit
exit exit;

  
exit
 exit1 9
```

  exit

exit 8

```
  
exit 8; 

```

 exit

```
print exit8 
exit

  exit

```

``` 9
exit
exit exit. 9
```

 exit

exit exit

 print
```  
 exit

 echo

 exit
exit exit exit;
 exit

exit 

 echo

 exit1 
exit
 exit 
exit
 exit 

exit

 print
 exit 10 1
``` 
```bash
exit 11
exit
exit exit exit
exit
print exit11
exit
exit
exit 5

 echo
```
exit
exit exit exit 11
exit
  print
exit

 echo

 exit
exit exit exit 11
exit
  print

 echo

  print
exit

  
exit exit exit
exit
```
exit
exit 9
exit
exit exit. 9
```

 exit

exit exit

 print
```  
 exit

 echo

 exit
exit exit exit;
 exit

exit 

 echo
exit1
 exit 

  
exit
110 exit
  exita

  exit 1
exit
exita
 exit
 0 exit exit

exite 2

exit1

exit;  echo1 303 exit exit exit

echo;
 exit exitt exit 9 5 exit exit

exit0;  3 exit exit exit
  03 exit3 extta3 exta4 extaa 13; exit extta 

  3exitt extta

  

print exit1 3 exit 93 9 exitta

3;  3extta;
 print exit1 53534ex

  

 exit13 extta13; exit

1
print; exit ex11

 print

print;
print

  3exit 0
1 exit exit838 exitta ex

3 exit;1; 0 exta3 9;34 exta999 03 93 extta; exit exit9 exit exitaex it3;

print 

```