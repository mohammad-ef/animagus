#!/usr/bin/perl
use strict; #Enforcing variable usage with declaration. Helps prevent accidental typos becoming unintended functions in code and helps identify the purpose of variable usage more effectively. Also enables error reporting on use of the undefined or non-declared functions. It improves robustness, readability, debugging, code quality, and error detection.  It makes it more difficult for bugs to sneak into the code. It improves overall reliability of the program by catching more bugs early.

use warnings; #Enable all warnings to identify potential issues or non-compliant patterns. Helps to catch problems early and improve code. Also assists debugging, code maintenance, and readability.

use Term::ReadKey #Provides access and control over keyboard input in a non blocking way. Enables reading character input directly without the need for user pressing enter first (single character at a time). It provides features like raw mode, getch(), and key codes. Helps create interactive programs.

use Term256   #Provides functions that make ANSI coloring possible, for better readability. Helps create more user- friendly interfaces. Helps in debugging by color coded messages that highlight specific areas or conditions.

; 
use File::Basename;  # Provides the basenameto get only the file name, dir name, and extension.
use File::Path      #Functions for making or modifying entire filesystem paths recursively.

;
use POS ixdenominators #Enables use of POSIX constants. Helps in portable code, making code more robust on different platforms. Provides consistent constants like PATH and others.

;
use Getopt::Long    #Provides a function to get the option flags and argument values.

; 
use JSON; #Provides functions to parse and generate json data, which can be helpful in configuring build parameters or for exporting metadata. Improves compatibility. Helps in configuration. Also assists debugging, code maintenance, and readability.

use List::Util;  # Provides a list of functions for manipulating a list. It is useful when you want to do list comparisons, filtering, sorting, etc and avoids the creation of custom code for such tasks. Makes operations efficient. Improves reliability of the program by catching more bugs early.

### 1. Initialization and Environment Setup
sub initialize {
   print "Initializing build environment...\n";
   my ($debug) = @_;

   #Detect OS & Architecture, Kernel and CPU Core
   my $os = `uname`.substr(0, 1); #Get OS from uname. It returns the platform name and architecture.
   my $kernel_version = `uname`. substr (-1) #Get Kernel Version
   my $architecture = `uname -m`; #Gets architecture, usually ' x86_64'
   my $cpu_count = `nproc`; #Counts how many logical CPU cores the machine has.
   my $memory   = `/bin/vmstat | awk '{print $6 / 1024}{exit}'`; #Gets memory

   #Verify Essential Commands, Normalize PATH,LD_Library_PATH, C and L Flags
   unless (-x /usr/ bin/gcc) { die "gcc not found" };
   unless (-x /usr/bin/make) { die "Make not found"}
     unless (-x /usr/bin /awk){die "awk missing"};
    unless (- x /user/bin/sed){ die ' sed missing'} #Check if sed is present

   # Create Log directories
   unless(- exist "logs") {mkdir -p "logs"}
   unless(-exist "artifacts") { mkdir '-p' "artifacts/" };
   #Normalize
   $ENV{PATH}  ||= "/usr/  local/bin:/ usr/bin:/bin"; #Sets up the PATH
   $ENV{LD_LIBRARY_    PATH} ||= "/ usr/lib:/lib"; #Sets up LD lib
   $ENV{CFLAGS}  ||  = ""; #Sets default values
    $ENV{CXXFLAGS} ||= "";#Sets the flags for compiling C++ programs
   $ENV{LDFLAGS}  ||= ""; #Sets linker defaults
   $ENV{CPPFLAGS} || = ""; #Pre-compiler flags


   print "OS: $os, KernelVersion: ".$ kernel version.", Arch : $architecture, CPU Co res: $cpu_count, Memory:" . $ memory."\n ";
    return ($os, $kernel_ version, $ arch, $cpu_ count,    $  memory);
}
#2 Compiler and Toolchain Detection

sub detect_ compiler {
   my $compiler = ""; #Sets compiler to a default value
   if ( -x /usr/ bin/clang) { $ compiler = "clang"; } #If the path exists
      elsif (-x /  usr/bin/gcc) {     $ compiler = "gcc"; }#if gcc exists
   elsif    (-x    /usr/ bin/cc) { $ compiler =     "cc";}

   print "Compiler: $   compiler\n";  #Prints compiler information
   return    $compiler;
} #Compiler
 #3 Flags
sub configure_flags {
    my ($ compiler, $ os ) =@_;#Get compiler and the OS for flags
    my ($ CFLAGS, $CXXFLAGS, $      LDFLAGS);

    if ($ compiler eq   "gcc" || $ compiler eq "clang" ) { #Conditional for compiler selection. Checks for specific compilers.
    if ($os eq   "SunOS"){ #Platform specific conditions
        $  CFLAGS =  "-fPIC -Wall -O2 -  D_REENTRANT";#Defines compiler flags. Flags for portability, debugging and code optimization. 
        $CXXFLAGS = "-fPIC -Wall -O2";# Flags specific to C++.

        $LDFLAGS = "-  lsocket -lnsl - lpthread   -lcrypt";#Linking
    }
    elsif ($os eq    "AIX"){
    $CFLAGS = "-g -O2 -DBUILDING  -DUSE_POSIX -D_REENTRANT";
    $CXXFLAGS = "-std=c++14 -g"; #Standard C++ version
     $LDFLAGS = "- lpthread - lssl - lcrypt ";
    }

    else { #Default flags
     $ CFLAGS =   "-Wall - O2 - D_RE ENT R  AN T ";  #Defines default flags, enabling warnings
      $CXXFLAGS =    "-std=c++11 -  Wall -O2  ";//Sets C++ standard and flags for compiling the code, ensuring portability of the compiled executable.
      $LDFLAGS =" -lpthread ";//Sets default linker flags
     }
    }
    elif ($     compiler eq "suncc") { #SunOS specific compiler configuration. Checks compiler
        $CFLAGS = "-x  c++ -  D_  RE  ENTRANT"; #Compiler flags

       $CXXFLAGS = "-x c++ "; #Sets the flag for C++ compiler. 
        $LDFLAGS = "-lsocket  -lnsl ";
     }


    print "CFLAGS: $ CFLAGS\n"; #Compiler flags
    print "CXXFLAGS: $ CXXFLAGS   \n"; #C++ flags
    print "L  FLAGS: $ LDFLAGS \n";#Linker flags
   return  ( $CFLAGS, $CXXFLAGS, $ LDFLAGS  );
}
 #4 Header and Lib Detection
sub detect_ headers_and_libs   {
    print "D etecting header and libraries \n ";
    my @headers = qw(unistd.h sys/stat.         h sys/mman.h); #Headers
    my @libraries    = qw(libm libpthread  )   ; #List of libraries. Lists common libraries. Helps find dependencies.
    

    #Compile test programs
    foreach my $header (@headers) {   #For headers. Iterates headers. Compiles test programs. Checks header presence, ensuring that the headers are available for building the source code, preventing compile errors and improving the code' reliability.  

       my $test  = "
#include \"$header\"
int main() { return 0; }
";

       my $compile_result =  `$compiler_ detected -c temp.c    2 > /dev/null`;  
      unless ($ compile_result =~ /fatal error  :/) {print "Header $header is present.\   n"; }
      }   
    

    foreach my $lib (@  libraries) { #For each library
      my $test = "
#include <mstdlib.   h>

 int main(int argc,     char *argv[    ]) {
   
  return    0;
 }
";
     my $ compile_result = `$compiler_ detected -c temp.c -l$lib 2 > /dev/null`; #Compile test programs
      unless ($  compile_result =~ /cannot     find  -l$lib   :/) {   print   "Library $lib   is present.\   n"; } #Checks if library is found by examining output from linking
       }   
}   
   # Utility Tools 
  sub detect_utility_tools {
        print "Checking tool presence: ";
        unless (`which nm >/dev/null 2>&1`) {  die "nm tool missing \n"}# Checks tool. Returns error otherwise
           unless (`which objdump  >/dev/null 2>&1`)   {   die  " objdump   tool  missing " }; # Check for existence using `which`. Returns a fatal error otherwise

            unless ( `which   strip  >/dev/  null 2&1` ){  die  " strip tool m  issi   ng   \n  "} #Tool
          print   "Done.\n";

     }

  #File system

  sub check_ filesystem_access{
        print   " Ver   if  ying   access \n   ";
         my (@paths    =   qw (  / usr  /  / var   / opt   /lib / u sr /lib  / tm  p  /  etc    )    );  
   
         foreach    my $ path(@  paths)  {   
        
         if (!- exist $ path ){die " Path not   existent.     \n   "   }
            unless(-  x $path  ){    die     "  Permission  Issue     .   "   }  
      }

      return  1;   #return true value when all conditions passed

}
    #build

sub build_project{

 my (@ sourceFiles  ,    @  includesDirs) =    @_

print "Building  p  roject  :\n"   ;

    #Compiles C files
       foreach    my $  sourceFile (@ sourceFiles) {

    my     $object  = $ sourceFile   .   ".  o   ";   #Generates file extensions, object name based source name

    my   $compiler_  comman =     "$ compiler  _  detected - c -  I" .  join     "   -I" , $    includesDirs;
        
    my $compile  output   =     ` $ compiler command "$ sour ceFile   " " > compilation log   "     `;    
  

     
       if   (    $ compile     output    =~  "fatal      error   :")      {  die       " Failed    t o Compile"       }   #checks compiler errors.  Error output
   print        "Compilation  completed     : "      . $      sourceFile. "    =>        $  object   "    .     "\n"     ;    
      }


      my $linker  co mman  =   "$ compiler detected    - o   outputfile. e  x  ec $ source Files .   "; #Link command to build executable file
      
print      " Link ing --"        ;    

my $linking    Com pilet lease
     
=
  ""       .$    
linker  Comman

   s;      #Linking process, compiles multiple sourcefiles 
       ; #
        #  print $
 linking  Compiledlease   ,   ";
  
    } #build_ project   end

 sub clean
      print      

  "Cleaning project\n";#
         ;

  ;  


 sub run  
    Test
  s 
        #  Print 
       test s   summary  

      .    ;     } 
 #Main
 my   ($debug    )
=  ""    ; 
  #Command    li  
 ne    parsing, flags  

Getopt::Long ->
  Con   
figur   e   ('debug '      )  ); 
 #  key    to enable d debug   mo 
     de.  
  
 if($argv 
  -1)   

       &&     "$ argv" eq 'd  
    iagn  ose'){ 
         print 
        "\n"  " Diagn os tic mode \n ";   ;  Diagnostic m

     de  

    ;}   ;
#Main execution flow   

if     
      ($
      argc    eq 
      -
1
 ){
   if ( 
         -  1  < $ argv ) 
   #Check    argument  length     #

 {    die          }    #Check    ar     guments      .  

        ;} #end    main_exe cution   ;     
# Call Funcitons    to execute  the   b build    Process      
     ;     Initialize      

     Initialize (   $" debug"     );
         D   detect
      Co  

m  pile r    );   Detect     c om  

pile 

   #Configure     compiler
 flags;   Con f     ig   
 ur
    _ 
       
     
      fl  

    a     g s     ()

  # D et ect    -
  Hea d

        d_
            
    He    aders _  & 
_

   li   b   

      

   . 

       S

      

       # 
 Build      

       pr

          
o   j

        E      _c t_ 

To   _ _  u _ t i  _   

_

   L 
       _s
   s_  s 
          ; _ _    

       _ _ 

   Test      .  ;

   #Package
  

        package    project; _ 

 _

 ; 

;   Print
   final    s

       u _mm 
      ar

          .    # _     Print  final  summ ary. Print summary
_      s_ _

    
       __ __ 
; # _

__    =    }  .     # _  __ __    =      

   .

   . __
; 
   e

exi_
;

   ;   e  x  t_
; _ _ __ _ _ __

exit (  

;   
0   ). _  ;   ;     exitt_

__  ;     _   ; 
 _

  .     __   _ 
__ ; _ __    __
    exit; 
    
__    ; _ __    _; _  _; _

    __
   exitt  ;
_ ;__
__   .    ex  itt   _;  _

_

    
exitt__    ex

  _  ; 
  ; _   __
__  
ex;    _   exi_  t  

__;   exit_

 __ ;   _  ;    _; _ ;
    ;_ _ ;   exit_;__    .t   exit__ ____ __    _; _    _ 
   __ ex__

    __ ; __
exit ___; __ _     
__ __    _ 
;  __

ex__    it ; __ 
exi_ ;
 _ __   __ ex
; ; ;  _ exitt
__    __ __

   ex _

 _

 _ ; __ _    
   exit __   ;  ; __ 
 _
__

exit_
;__ __   .

; exit __
  ex  _
  tt; ;   ex _   exit;

 _

    __  

  ; ;__   ;
;__ ex

it_ ; _  _ __;

__

exitt ___; ex__

__ __   .

   _ .exe_  t_ .
 exit __  ; exitt _ . ex; ; _
exit  t __ __  ._. ex _ _ exi _ ;__ex
exit __;  exit ; _; ex __ __ ; ;  _.
   ex
  __ exitt _;   _ __   _.ex _ ._. ex __

    __ _;  _

 _ __   _ ex__ __

exit__ ;
 _ __;_* _ ;  ;__ . ; __

_;__ _;__ _;

_ ___; ;__ _. ___.  . __ _  
ex__ _

 _.
 _ ex _ __ __;
__ _

;_; _

___ _ __; _ _;__
_;_ __  ._
__

_;  ._.  
. ex  
 _ _ __; ; ; ;__ _  _. . ex  _; __ _;_;

_ ;
_. _  _.

_;

_
 _ _ __;  ; _ _.  

; ; ;
  ._ _. _ _
_ _.

_. ; ; _  ex
; __ ; _;  _;

  ._

_. _. ex _ ; _ _;  . _.
 _.

_; ; _ ;  _; _. _. ; ex  _. ;_;  __ ex  _

 _

  __. . ; ex  _ . . _.
 ;  __ .
; ex __ _. __;  _.
_; _; _; _. ex_ . ; _ _. __ _.
;_; ex_ . .
 _

_ ._. ._. __ . . .  __. ;_. . _ _.
;  __.  ; _ ; ex_
;_;

 _ _ _. _
_ ex _.

; _;
_ _; ex__ ; ex __ ;

  ._ _  _; _. _;

 _. _; ._; ex_. . _ ex_.

_
, ; _; _;

_ _  _; ;_.  ex . ex _ __

_; ex_ __ _. __ ; _.
__ ;_ __ ex _ __

 _ _ ;

_ _;_. ._;  __. . ex _.
_ ; _ _  __ ;  
_.
;_. ; _. _; ex . _

;  _.
 _ __ ; _ _; _; ex

_. __ __
. ;  ;

 _ _
  ex_.

_;_
; _

_;

; _. _; . _.

__ _ _. . ; _ __ _.

_. ._;_.
__

;_; _. _

  .__

 _. _.  ex  _ _ ; _
; _.
.
 _. __ .

  __ __  ._ _. __ ;
. _: ;
_  _ ex __ _;
  ._  ; . ex_

_. . _ _. _. _.  ; _. _; _. _. _;

  ex __ ; _. _
 ; ;

_;_. . ._; ex  __. : ;_.  _ _ ex _. . _ ;_
 _ _. _ __ _.
  _. ___. ex ; _.
 _. ;
. _. ; ex ;

__ _;
_.
 _. _. .

__

;

  _; _ ._. _. _ _;

__.
;_;
  _. . . _. _;
_; ex_. _; ex
 _. ex . _; _; _  _; _ _

_; _. _. _. _. _. ;_ ex _. ex_ __ _. _. . _ ex .
 _ ; _;
_ ;
;_. __ ; _ _
_  ._ ; _; ex __
; ;_.
__

_; ex_. _ . _.

_;
 _. _.
_; ; _

_
; ex _. __ _;_ _; _ ex ___. _.
__. _ _. __ .
; ; _. .
 _
  _; _; _ ex _; ._. ex_ ;
_. _. ;
. . _.
 ;

  ._ _. _. _

__ _
.

; ._.

_
_
_. _ _;
_
  .; ex

_.

_. ex

_ . .

_  __. ehe_ __ __. ;_.

__ _; _ _. _ _.

ex_ ex We

_ ex__ . . ; _.
__. __ _ ; _. ; . ; _

_; _. ex_. . _; ex
  _; ex__ __ _. ex _ _. ex ;_

;_;
_. ;_ __ . . _. _. . _. __ __ _

_
_; ex
__ _ ;_. ; ex__ ;_.

; _;_. __ _ _; ex

; _.
__ ;_ ex

__.

_ ex ; ; _. _.
; ; ; _. _.  
_. _.
_; _ . ex_  ._ _. ._ _;

; _

;_. _ _.

_ _ __

__

__ ;_ . . _; . ex __ _; _

ex_. ex __ . . _. ex __ ; ;

 _. . ex .
_.  
. .

ex _ _.

ex . ; ex __

_; __ ;
. ex ex_ __ _;_ __ __ .

. _;_ __ _ _. _.  __ ; _.

ex ;

__ ex ex

. ex_  ._ ._  _
  ex_.  _; _ . ;_ _; . __ . __; _. _.  __ ;
ex

__ ex _. _. _. _;
  ._ _. ;_;_ _; ; _

. _.  _; ex _. ._.

ex

 _.
_.
_ _; _ __

.  __  _;_ _ _ ;_

.  ; _. ; .

. ex
_ ;_. _. . ex _;_ . ;_; .
__.  ;:_; _ ;_;

_. . ex

  _;
_ ; _.
. __ _. __
__ __ _;_. ;

; _.  . ; . ;_ __;

_  ; _ __
 _. __ _;_ ex ;

. _ ex ; .

. _

.

_.

______ . ex _;

__. . ex . _. ; . ex .

_.  _

; ; _. . ex _; ex _.
 _. ;_.
;

__. _. ;_; _. . _;_ _ __ _ ; ;

ex _ __

_  .__

 . ex _. _ _; _ ex _.
_. _. __;

 .

  ;_;

 _;_ _; _; . . _; _; ex __ _; _ _;_ __; . ex_. _;_  ; ex _.  _. _;_ ; ex ;_ . _. ex _. _; _. ex . _.  ._
_;
. ;_  .;
  _;_ _. _  __ _.

 _. _  ._  .;
  ._ _.

. ; _  ; ex
 _. _ ex _ _.
_; ex

  _; ; ex ; _ _. _  __. ; ex _ _ __ __ __ _; ._ ; _
_.

;_.

__ __ . ex _.  _. _ ex

__ __ _. _. _.
ex ;_;_. _; _; ._;
__. ;
ex

;_; _ _ ;_ ex_. . . ex _. ;
__.
  ;_; _;
 .
_. ;

ex . _

_ ; ; . . ;_; _; _; _. ;

_; ;_
_. ;
; ex_.  __. _; _ _ . _ _.  _; ; ; _ . ; _.
.  ; _ _ _. _.  ._
 _. _;

__

; _.

__. ex

_  .; .

__.
 ex_. ex_ .

_. ex

_; ex _; ex _
__. ex _; _ ; _ _ . ._ . _. _;_; ; _
ex ; ;_.  ex ; ; ; ex_. ; _ _ ;_
_ _; ;
  .; . ; . _ __ ex .; . _ . ;_. _;
_. _ . ; _ _;_. ex_. _. ex_;_ _.
. _;
__. ; ; _ _. _. . . ex _. ; ;_ _; ex_; _. ; _. . ;_ .
 _. _.

_.  ._ . ._. ex _; ex . . .

  . ; ex_. _;
 _. . ex _. _
 ;

; _;_

_ ex_
_. _. . _ _ _;_ _. _; ex . _. _. _ _ __ ex_.

_. ex
. . ;_ ex _. _;
_;
__. __ ex_  _. ex_; _ __ _ _; _.
_. _;
__. _. _ _ __ . ;_.  ._ _. _; _.  __. ex ;_
__.

_
.
_; ;_
ex _.
_  ex_. . _;_

__. _. . _
_; ; .

_  __.

 _. ;_; _;_.  .  __.

. _;_.  .; . _
  .
 _.  __. .
 _. _; ex
 _ _ _:  _;
 _.
. _; ex

_; ex ;

__ ex_. ;

_ _. _. _
ex
_; ; _. _; ; ; _. ex_. _;

 . ex

  .; ex_; _

__.
 ._
 . _; _;
_ __ ; . _.
 _  __
  ___. _;
.

.
 _

.
; _. _  ; _;
_. exh ex ex
ex; ._. ;_. .
.
 .

_
_ . _.

.

.
;_. __ . _. _; _; _; _; ._. __ _;
 _. _.

_
_ ex ._. ; _ __ _. ;
 _ __ _
 . __

_ _  ._ _ ex

 .

 _ _; ii!.  ._ ex _; _;
ex ex_ . _;
ex_ _;_. ex ._;
_.

_; _. ._ ; ; .

_  _; ;_. ;

;_;

  . _;

 _. ; ex
 _.  _.

_. ex_.  ;_;_. _.
_.

_; _ __ _;
;_. _;
_;

__.  ex
 . ; ex_. .
;_; _ __ .

. ex _. . ;_; .

_; ex _;_ . ex_. ; ;

; _. ;_; _. _. _ ; _. _

; _; _; . _ . _;

_. _; ex _. ;_; _ ;

ex _ ;_. ;
__.

. ; ; ;

 .

; .

_  __.  _ _
  __ _

ex_ __ ._ _. ex_. _. . _.
 . ex_. _. .

.

  ex_;_ ._; ;

__.  _;

. ex_. .

. __ ._ _;_; ex_. ex _._.

; _;_.
  ; _
 ._ ; _. . ex
;
 _.
_. . ex_;_; . . ex

 . _. _;_ _; .

ex
 _. . _ ._ _; _ ex _. _ ;_  ._.

__ _;_. _. . . ._. . ex
  _. _;
. _ _ _

_. __ _ _
__.  _; _; _  _.

_ _;

__.  ex_. _. . ex ; _

__. _ _ _;_.
__. __ _. _;_;_.;
_;_  ;_. _ _ _ _;_

_ . .

_

_.  ; _. _. __ _  ; ex ;_
. __

. ; _. ;_. ; ex_  _ ._ __ ; ex _. _. ; ;_ ._.  ;
 _. _ . ; ;_. ex_;
 _.

_;_
__. _;
_; _; ex ; ex_ ._; _;_ . . ex
_. ex_. _.  __ ; _.  . ;_ ._;
__.
. _. ._;
  ._
  _ ;_. __
  _; ; ._ ex . ._
   ; ex ;_

_ __
. _ __ _;_
_
ex_* _ _ _  .; _.
_ . _. _ _; ; _.

. __ ex_. __ _;_;_;_ _. _. ex; ex _ _;_ ._ _. _.
 ._. _; ; ;
_ _ ex .
 _ ; _ _  ._  ;

_;

 . ; ex

_.  _ . ._ _.

  _;
. _;
;

.  .; ;_. _. __ ex
_ __ ; ex_.  .; . ex ;_; ._ _ _ ex .
. . ;

;

_;_. ; _  ; _. _;_ ex ._
 _ _  _.
_;_ ; _.

__.  _ ; _. _; ; . ex _. _; _. ex _ ex_ __

__. _.

 ; . _. _.
; . _ _ ex_; _ ex_  _ ex ._;_ _. _.

ex; _. . _.  ._ _ ex
; _ . ex_; _ . .
ex; ;_ .

; _;_. _ _

_; ex _

  ; ;_

;

. . ex_; ; _. ex; . ex _. ex ; ex_. __ _. _. _
; ._. . .
ex
_. _. _ _ _.  __
_;  _. _; ex; . ;
ex

 . ; ; ex_

 _. _. __ .      ; _. . ex _;_;

__. _. . ;
ex

_; .

__. _ ; ex_ __ _ __ __;_. _; ;
 . ex_

 _. _.  _;
 . _. ex_ _  ex ;
  ._.  __. ;_ ex ;_ . _. _;_; _.  ;

_ ex

  ex_ _; _. __
_. ex_ ; ;_;
 __ .
_  _; ._
 _ _ _.  ex

.  ._  .;
_-_. ex; _ ;
_  .  __.  ._;
;_. __ ex
; ; ; _ ; . ex_; .

. ex; _; __;_. . .
 _. _; _; _ ex_;
__.  ._

.

_ ._ ._.  ex
 ;_ ex

_;_ __ _;
_ _. __

_  _.

  . _;_.
; _. _

__ ex_. _; ; _. __ ._
.

_ _. _; ex ; ;_

__. .

 _. __ _;
_.  . ex_;

__ . _ _  ;_. _. _. __ _.
_; _. _ ex _ __ _; ex

__.
_. .
 .
_; _. _.
; ex_. ex ; ; ;_;

ex; _; _. _.

__.  ; _;_ _. _. _. _; . _ ex_. ex;

  __. _ _;
ex_ __ ex ; _. ex
__. .  __ ._  _  _;_. ; . _ _ ex .

 .

__. ___. _; ex_  __ _ .
 _. ex .
_ _. ._.

_;

_.
_. _.  ; _; ;

. _.

;
__. ex _. __ _; ; _

_. ex

__. _ _ ex; _.
 . _;_
 _. __
 _. ex .
.  ex_. _. ;_  _;

 . . ._; ; . _.

ex
_ ex_ . _. __ ; _.  ;_;_. . ; _. ;
_ _.

 _.
  _; . ex _. __ ._; ;

ex
_. ex_;_; _. ex_.

_
. _; _. . _
ex ;

. ._ ;_. __
ex _.

_;
__ _ _ _ _ . _ __ ._ __ . _. __ ; _. _ __ ;_. ._ ;_; ;_. __ _. __ ; _. .
  _ ex ;_. _; _. ex
 _. ; _

;

_;_. . ex_.

 _.
_
 .

 _.

_; ;

; . _. _ __ . _ __ ._; ; ; _. __ .  __

.
  . __; _ ex

 . ___. ex_. ex_.

_. __
_; _;_. . _;
. ; ;_  _ ex_ . _ . _. _ ex_;_;_ . .
..; _

__. ; ex_
  ;
_.

_ ._;

_ _; . _.

. . _

ex_ . _.  _ _

 . _. ._; ; _ __ ex_

.  .; _. __ _; ex

__.
_.  __. _.

_;
. ex ._; _.  _. ._; _;_ __

 . ex_ _.
_
 . . ._

 _. _;
_. ex ;

__.  __ ;_. _; _  ex .

 . . _  ; _. _; _;_. ___. ex ;_; ex _. _
;_. ; . _ ;_.
 ._. ;_ ;_.  .  __. _. _; _
; ;_ ex_. _. __ _;_ _.  __
 _.  ;_; ex ; ; . ._ _ _.  __. _;

_ _;_. __ ; . ; _ _ _.  _; _;

 ._. __
__.

ex_
 ._. ___. ex; _;

; _. _; _;

_. _. _
. __
_

_

; ex_ _. . _  _. . . .
 _.  . _. ; ex

__.

  _. ex_ ex . _.  _; _ ; _. _; ex . _

ex
 _ . _
 _. _; . _  ._ ex ; ex _. __
_; ex _. _;_. __ ;_. . _ ; _ ;_  ex _ _; ex;

;
__.  __ _. ex
_ _.

_  ; ex
_.  ex; _. _;_. _ ex _ ex_ ex _ ex ._; .

__ _. _. _; ex . _  ex_. ex ; ;_.
  __ ex . ex _ __ _. ex_. ex

_ _ __ _; _

__ ;
. _.
. _ ex

. _; _ ex;_. _

_;_ _. _;
. .
 . _ _.

__. ___. ;

 . . ; _ _ _ _
_ __ _ . ex_ _; _. _;_. ex ;_. ex
__. . _. ex_. __;

 ._ _;_ ex _. ;

;_ . . _. _. _
 _.  _. _. _. _. ex
.

 _. _. _ _; ;
_ ; _ _ ;_ . _;_. .

.  ;

. _;_; ;_. ; .

__ ._. _; _. ; ex _.  __ _. _. ex _ ;

ex; _;
. _ _. ex;
; _; _ _ ex; _ _
 . _  __ ._; ; _ _.
 _. _. _; _

ex_. _; ;_ ;
 . _; .

 .

; ex ; _ _. _ . ex_; _ __ ex _ . . ex

 _.

__.
  ._  _; _; ._ _.

_;

_
.  _. . ex_ ex _ _; ;
ex

; ._ ; ex_; ._;_. . ex_. __ . ; ; ._; ex_.
__. _;_.
__.
;
ex; ._; ;_.

__ _ _; _. _ ._;
ex ;

___.  _.  _; _
_.  __

 _. . ._ _. _ ex

 . _ _; ex _. _
_. _; _; . ex_.  .;

__ _ ._. ; ; ex_
_; _. _. .
_. ; ex _. _. ;_;
 _ _.  ex
 ._ _; _. _. _.  ex ;_

;_; ; _ _.
. _  __ ;

_

_;

 _. .

_. _. _. ; _  __. __ _. ; _. _ __

. _ __
 ._.

 ._;_ _;_. . ._; .

_; ;
ex_; _ .

___. _ _. ex_ _. ; .
. .
; _. ; .

__. . ;

__
__. __; ;_;_. __ ._; ; ._;_.
 -_.

_;_
 . ex_. _. ex _.  .;_; _. ; _.
_. _. _ ex;
; _. ex_ ; .

__; . . . ; _ ex _. ._ __ ;_. _; ex . _ ex _. . ex _. _
ex ; ;_. _;_. ex
_ __ ;_; _; _ ex _ ex_  .; ex
 _. ex; ; ex ; ex_. __ . ; ._; . .
_.  _ . ex;  __. __ ___. _. ; _ _

 .
  __.
_. __
 _. ._ ex _.
; ; _ _. _.

. __ _ . ;_;_.  _  .
_. ;. . ;

__ _ __ ; ex _ __;

 _. ex _ _; _ ;_.

_.  ;

 .

__ ;_. . ex_ ; ._ .

_;

__.

 .

; _ __ _. _ _. __ _ ; _.
__.
_;

_. ;_. ._ ex;_.

__. __ __ ._;
_;

 . _. _. __

_; ex _. . ex
 _ _;_ .

__.  ex _.

; _. ;_;_
_ . _ _; ex._ _; ex_ __ ; ._
__.

_; _. .
 _. _; ; _. ex ;_ . ;

_. ;_ _. .
ex _. ._;

_ _ _ _ ex_. __ ex_; _

_

_; _ ex;  _ __ ;

 ._ __ __; __ _; ;
; _ .
_; _. ex ; ; _. _; _ _;

 . _ __ ex; _.

_ _;_;
. . _.

 _. __ _. . ex; _ __ . . _ _ __ ex_. __ _; _. _ ___; ex ; .
_; ; ex
 _. __ _;

.  _; . ex _. ;

_

 ._; _. __ _. __ ;_. . ;_;_ ___.
.

__ _ ;_.
_. _

_  .; ex . ._  ._ _ _. ex

 . _ ex_; ; _ *
.

__ ___.  ex ; ._ ex_; ex_ ; _.  _;

 ._. ex_
_ _;_;_ _; ;_  _. _.

  __
_; ex . ex _. ex;  ; ._.
_; . _. _. _;_.
  . _
_ =

  __ ___ ___  ___ _  _; _

. _ . ex _.

  ___ _ Ok_

__.

 . . ex _. _ _ ex ; . _. __ . _ _; ex ;_. ;
_ _ _;

_; .

__. __ _. _; . .
_; ._; _. _. _ _ _  .

_. _ __ _.

__. _. _. _.

 . . ex . ; ;_; _
.

. __ _ ex _
_; _ _.
__. _;

  .. . ex .
 _. __ _;_. ;; .
__. _; ._ _ __ ._. _. ;

  _;_ ex_. __
_. . ex ;
;
__. ; ex . _. . ex _. _.

. ; _. __
_  ._ _.

 . ; ;_. _;

 _. __;___ .
_ __ _.

_.

. . ; _. __ ;_ _. ex_;_ ex_;_;
  __. ___. __ .

  ___. ._. _. ex _
_;_ _. _. __ _;_; _ .
; ex_.

 .
_ ex_. _ _  _. _;_. .
;
; ;_ _. _. _ .

_.

  ; _.

 . _
__. ;_;_.

_;_. _; _
_. .
;

__ ex_. ; ex . ._. ex _
 ._. _.
_  ___.

_; _. ex_. __ _ ex _. _; ;_ _. ex

_.

__ .

__

 ; ex
 _ _ _; ex

 _. . ._. __

  _. _; ; _.
_ _. __ 
; ex_

_; ex

_
_ ; ; ;

 _. ex ;_; ex; _  ex_. _. _; _  __ __ _. ex_ ; _.  .; _. _

_.  __ ;. _.  _; ex_. _;

__ __
;_; ; ex ;

_ ; ex _ _  __ __ __ _.
_ _; .
 _. _ _;_;

__. _ __ _
;
ex_.
_  __ ._. ; ;_
_ _; _. _; _; ; . _ _ _
 . ;_ _;_;_.

  _
__. ex _. _.

; _ .
_; ;_.
ex; _; . ;_. _; ex

__
; ex ; ex_;

 .
; _. ex ; _ .
;

; ex

  _; ;_. ; _  .; _. _; _. ; ;_. ; _ _. _

  _; _ ;_; _; .

;_;_. ; ; . _.  ._.

__. . ex_. _ .

_ ex_. .
 ;

__. __ _ _.  . _. ex _. _. .; _.

  _; _ _.

_; ;_ ; ex

 _. _. _;_
_; _.  ._ ex_;_.
; ex ; _ _; ex ;_ _;_.

  _; ex

 _. ;
 _. ex_; _ __ _;

__ _;

_;
_. .
 _.

. .

  .
  .;
 _.
; ; . _ _ ex ;
 . _. ; _ ;
 _.
_; ex _. __; ._; ex;_;_; _
  _ _.  .;_
 _ _; _. ._  _ _; _. ___.
;
_;_. . ; _ _. ___.
.

_. _;_. _.  .;_; ex

  ; . _  _.  _,

_.
. _ ;_;
_ _; _ _. _ . _

 _.  ._. ___. __
_;_  .;_; ;
. ;

.
 . _
 _. . _ ex . _.  ._ . ;
. . . ; ;

__. __ _; . _ _ __ _.  __. .
_  _. ._.

 _. _; ex _ _ ; _. _; _; ex_.
 _. _.

; ex_.  __.
_  __ __
 ._.
 _ ._

;_
. . ; _ __ ;_; ex_ ex_ . _ _.
;

_ ex _ _. __
__. _. _.

  ex _. _ _ _;

 _. _  _ _;_. ;_; ._.
 _. ex

 _.
_.

 _. ___.

.
_. _ ex ._; ._. ; _  .;_;

__.
__. ;

_ ex_ ___.  _; ex
_ ; .

 . _ ex_.

 _.
  _. ex
 ._; .

_; ex_ ;_; _. _;
_ ex _. _ _;
_; ;_; .
 ._ __ ex _ _ ex
_. ex ;_; ; ;_.  ._ ;_; ex_; _ _ _. _

.
_. _. ; _ ; _. . _. ; _. ; ex_ ;
; ;_; ex_.  _; _ ex _ __ ex ; . ex_ ___.  _;_ _. _ __;_. . .

. _. _.  _ _ _. __ ; _; ex

  _  ; _;_ _;_ ; _. __ ex _

_.
_;_ _; . ex_ _.

_. . _.

  _ _. ._.  _. ;
  .;

__.

  ex_ ; ._. _; _. _. _

 . ; _ . . ex
 _ _ _;

 . _. _;_; ._;_.  _;_ ex ._; _. ex_.

. ; ex_; ._ _.

_; _

 _. _. _. __ _; . _. ._

  .;_. _ _  ex _. ;_ __ _ ex; ._. ; _. ._; ex

.
 _ _  . _  ._ ex
 _  _.  ._ . ._
 .
 . _. __ ; . ; _. _ . _. . _ ._; ex; _. ; ex
."._. ; ex

. _; ;

_ __ . .
; ex .
_.  ._. _; _ _.

. ; _. ;_; _.
 .
; ex_. __
. ._. __

_; ; _ __

__. ;_. ex .

 _.
_.

_; _. _; ex _ ._;_ _ _; ;
 ._; .

 ;_ ex_

; ex _.
_;
 _.

_ ex_;_;

_;
_ _;_; ex .
_. ex

. ;
; _. ex

_; _ ex; ex_; ; _ ._.
;_; ;
__.
; _;

ex _. __ . _ ex

;._. _;

_.

__. __ _.

 ; ex

__.

_ __
 _ . _ __

 _. __.
 _. _. _ ._ _ ;

; ex_ ;_  _ _; _ _.  ex _ . ;_; ex_; _.

; _ __. ex_; _. ;_ _ __ _. __ _. _. __

; ex . ___ . ex ._. ._;_ _ _; . ex
_ ;_.  __ ex;_; _. . _. _.

; . ex _ ex

__. ex . ex; _ .
; ; .

; _; ;_; _ __ ._;_. ._
. ._. ;_.
_
 _.
_
_ _ __ . . ._; ;

. . ex
 . _.

__.  __ ;_. _ _.  _. _ .   __. ex;_. _;_.
 ._. _ _;_;_  ; ex
 _ _. ;
_ __
_
 ; ;_. _. ._. _. _. ; ex_. ._.  _ ; _. _.  ex ;_; ;_;

;.
. ._. __
; _. ex _. ;
 _ _;_ ; ex
_ __ _. ; __ . .

 _ _;

__.

_. __

_. . ; ._;_.
; _. _. ex
. _ _ .
 _
 ._ _
_. ex

 _ _
 ; . . _. ex_;_. _. ___. ;

 . ex_; ex _. ._. __ _ . ex

; .

 _. .
ex; _

_. _ . _. ; _. __ ; ex_;_.

_ _. ___.

_; ex _.

 _ ex_;_ _  __ ex_ _; _ ex ; _. _. _;_; ; _ _;

_ _ _; ex ;_;;

 _ ex_; _,

 _. ex . ._. ___. ex .

_;
 _. ex .

_.

 _.  _  ._ .

__. __

__. __

 . ex ; ; ex

. _; _ ex_. _; _. _ _. __

_; ex_ __ _. _;
_ __
 _. __ _ _; _ ex . ;
 ;_; _. _. __.  ex_.

_

__. _

. _

 _ ;

 . ;
. _; ex
_. . ._.

_ _; _. _; ;_ ex_;

; ex _.

_. __

 ; ; .

 . _ _. __. _ _ _;

 _

_ ___. ___. ;

_ _.
 _ ex ._.

_;

 ;_.  _;

_
 ; ex

_ ex _. _ ; ex . . ;_ ex _ _ . _ _;_;
. ._; ex . _. ex
 _ ._;
;

. __ _.  _;_. ex_. _; ex ._
 _. _ _.
_;

.

__. _; _. _  __

 ; . _. ._;_  ___. _

. ; ._. ex ;
_. ;_;_ _

 . _ ex_ ex
 _.  _; ex;

 . . . ex_; ex ; ; _.

 ;_.

; ;

_ . _  ; _.

_  . _ ;_
 _. ex _ __; .
_. _; _. ; _. ._ _;_ _.

 . _ _; _. _;

; _ __ _ __ _; ex_
 _. _. ;

_; _ _. __.

__. __ _ __ _; _. _; _. __ _ _. ex_  _. __;__. _;_;_.

 ; ex;_. ; ;

_. _.

_; _
 _
  _; _  __.  _. __ _;

_ _ ___. _. _  ex ; _
 ._;
 _. . ._. ;_

 . _.

 _. ; . _.  .  __ ex ; ; ex;
  ;

. __ _. _.
_; . . _  ;
_;

__. _. ex . _
 _. ex

_ .
 ; _ __ _; _;
_;_. _;

 _. _. ; ._; _.

_.
__. _ ; . _  __. _. _. _; _. __

; ex_;
; ex
 _. _. .

 ._ ;_
_;

_.  _. ex; _; _. __ _ __ .
. _; _ ._;_.
_; _.
 ._.

 _ _ ; ;_. ._.
 ;
_ ex

.

 _ ex_. _. ex _. _;

 _.

_ . _ _ .;

;

 ;
__. ;_. _; ._.

 _ __ _;_;_ ex _. __ . _. ex _ ex; _. ___. __ _. ;_. ; ;_; ;_. __
 ;_ . _.  ._ _. _ _ . _  . ; ;_;

 _
 .
. _. ex
_

ex_

_. _. . _. __ . _. ; _. ___.

__. _ _;_; ex _ _. _.

 . _ _; _. ___. ._ _ ;
_.
. ex_ . _  .; ;
 _.

. ;_ _;

.

_ _; ex

_; _;_  _;_

_. _ . ;_.
. . . ex ;
  ._
; ;_ __ _ .

 ; ex
.

 ._;_; ; . _;

. _ _; ._
  __ _  .;
 _ ex_  _  .  .; _. __
 ;_;_. ex; ex . ex . .

 _.

__.  ._

 _. _; ex ; _.  .

 ._  .; _.

_ __. _. ex _;
_. ex

_;_ _. ex
  ._ ;_. ex

  ; _; _.  ex; ._. _  _; ; . ex_ ex_ __ _ .

_; _; . ex _ _;_;

 _ . _. __ _. __ _.  . ;_;_ _;
; ;

 .

_. ._;_ ex_;

; _

; _.
_. . _.

__. _ . ex
 ;_. _; _.  ._

__. _ _; ;
_.
; ex_.
 _.

_; _; . . _ ._.  ;
  ex_ _.
 ._;__. __; ex; ex_; _;_. _ _;_; ex_.
.

 .

_;_. 