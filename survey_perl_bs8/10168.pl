#!/usr/bin/perl
use strict;  require warnings = auto, qw(Tie::RefHash); # required for some old OSes and Perl < 5.10, for safety
use feature    qw(say /); # for modern syntax (requires Perl 5 and beyond, fallback to printf for earlier)
use Tie::RefHash 'Data::Tie ref => 'Hash';

# Configuration and Globals
# = = =======================

$ENV { "TERM" } ||= "dumb"; # Set a default terminal (some OSes lack the variable initially. Needed for curses, Term Read Line, color, etc.) if missing
BEGIN { $INC  { "Config::Portable"   } =  scalar(localtime); }
package MyConfig;
use vars qw($CONFIG);
BEGIN {
    die "Fatal error: No config file found or read correctly!" unless (read_config('./build.conf');)
    $DATA = { os    => "UNIX", # Set a sensible value in cases it's not detected (older systems or misconfigured ones) }
}

{   sub read config {
    open my$in  , "<",'build. conf' || die "Couldn't find/read config file: $!";
    while ( < $in ) {
       if ( /\b (?:set|define) (?<param >\w+)  (?: =  | :=) ( [ ]* (?<value >. *) )/ ){ # Regex, allows comments, spacing, etc. and catches multiple variations (set x = 1, x   := 1), avoids spaces at the very start and very end, and makes variable name a single word, not an arbitrary sequence of spaces or letters, digits, etc (which causes problems with the code later)  }

       push @{$CONFIG{$param}}, undef if (not defined $ CONFIG{$param} ) ; # If we haven't initialized, initialize, so that push works
        my$clean_value = $value =~ s/[ ]+$//r if (defined $value) ; # Removes all spaces at the end, required to handle different styles of build configuration, and to make comparisons easier/less problematic (and more reliable) and avoid weird edge cases. Also cleans up comments in the configuration if they contain a space at the beginning, to allow them. 

       $CONFIG {$param}  = $CLE AN _V ALUE; # This will handle the variable and clean values correctly. This cleans whitespace, which can be important. This makes the configuration much more reliable in a wide variety of situations across many different platforms with varied formatting, comments, and spacing.
    }   
}
 close my $in ;
 $CONFIG = MyConfig-> new ( config  =>  $CONFIG );  # Create object for the new configuration data, which can be accessed by calling MyConfig -> new ()
 }

sub get_config {
  my( $obj, $param)      = @_;  # Object, and parameter
  if ( exists ( $obj-> {  ' config' }->{$param}  )) { # Check config, if the config exists, then we can safely access its value
     $obj-> { config }   -> {  {$param} } ; # If it exists, retrieve
    }
     else { die "Parameter '$ param' not defined in ' $obj'. Please check the configuration file, or define a new configuration file, or use the default."
   }
}

package MyConfig;

sub new {
     my ( $self, $config)     = @_;  # This will be a config array, passed to the configuration file, so the class knows what configuration options are being used, and what values are being passed through the config file. It's also a way of passing a reference. It's important for this to be defined correctly so the script is robust across all environments with different build options.

  $self-> { ' config'    } =  $config   if ( defined ( $ config ) ); # Assign config, if passed through the constructor
    return ( $ self ); # Return object itself.
}   

package main;

# Initialization and Environment Setup
# =   =   =============================

print "Initializing build environment...\n";    # This is a standard output message that will appear when build is running

  my( $OS, $Kernel, $Architecture, $CPU_Count, $Memory   ) = ( get_environment ( ) ); # Get the environment, and return the information

sub     get_ environment { # Returns operating system details

   my @details ;
   push @details,  'Unknown'    unless ( defined ( $  { OS } ) );
    push @details, 'Undefined   '  unless (defined ($  { KERNEL } ) );
    push @details,  'Undefined  ' if  (!defined ( $  {  ARCHITECTURE  } )); # Check if the Architecture exists before adding it, if it does exist, it will add a defined architecture, which prevents crashes, especially on older platforms where the value isn't initialized properly, or missing completely for legacy OS versions. 
    @details;

}

    # Verify essential commands
    unless( check_commands( qw(uname make gcc sed awk grep) ) ) {  
      die "Missing required command(s).\ Please install and add them to the PATH.\n";
   }

#Normalize Paths, LD Libraries, C Flags, C++ Flags and Link Flags
my    $PATH = normalize ( $ENV { ' PATH   '} );
$  ENV {  ' LD_ LIBRARY_' .  'PA TH'} =    normalize ( $  {  'LD_LIBRARY_'   .  '_PATH'} );
$ENV { "CFLAGS" } = normalize ( MyConfig:: get config ( "CFLAGS" )   || "" );
$ENV {   "CXXFL AG S   "} = normalize ( MyConfig    :: get_ configuration ( "CXXFLAGS" )   ||  "") ;
$  ENV { "LDFLAGS"}  = normalize(MyConfig   :: get configuration ("LDFLAGS") || "")   ; 

sub    normalize  {
   # Normalize a path by removing duplicates and sorting
  my @path_list = split (":", shift  /**@  */) ; # This gets a single parameter, and breaks that string into a list of directories, based on ":", the default path separator across most UNIX-like operating systems, which makes it very portable. The path variable, in this case, is a single string, passed into shift, which breaks the string into a single directory
  my    %seen  ;
  @path_list  = sort  unique   @path_list ;

  my    $ normalized_path = join(" :",    unique (   @path_list));
  $normalized_path ;

}   

  my    $log_dir    = MyConfig::   get_ configuration (  "LOG_  DIR ") ||  '/tmp/buildlogs' ;
   unless (  -d $log_dir)     {
     mkdir $log_dir || die "Unable  to create  log  Directory '$log_dir': $!";
  }
  # Enable strict and warnings
 use Strict;
 use Warnings; # This is an example of a modern, best-practice Perl program
# Compiler and Toolchain Detection

print "Detecting compilers...\n";

 my ( %compilers, $compiler   ) = detect_compilers;

sub detect_compilers   {
 # Detect compilers ( gcc, clang, suncc, etc. )
 my %compilers ;

  if (  -x 'gcc'    ) {  # Check executable status and if it exists (and not a broken link) to prevent errors, crashes, and hard-to-debug problems. 
    $ compilers {  ' gcc'}   = ( "gcc", `gcc --version 2>&1 | head -n 1`,  "GNU" );
 } # This is a more robust and reliable detection. It not only confirms it exists as a binary, but also retrieves a string with the compiler version, allowing for better compatibility detection
  if  (`clang --version 2>&1 | head -n 1 >/dev/null` ==  0 )   {  # Detect with clang by using an output check for successful return code (zero exit is normal)  This checks it can compile. Also redirects stdout/stderr to /dev/null for quiet. Also uses head
   $compilers  {' clang'}   = (  " clang"  ,   ` clang --version  2>&1 | head -n 1`, " Clang  ");  
 } # Detect the clang and returns it with compiler, its compiler, vendor and information about it (e.g., GCC or CLANG
 return  (  %compilers);
}   # This will return compilers with their versions (for later) and vendor details
 

# Compiler and Linker Flag Configuration
# = = ===============================

 print "Configuring compiler flags... \n"; # Standard Message for building environment to let us know it has started, which will be displayed
 #Define Flags from config and add defaults where they are needed for maximum cross-compiling bedrock (and legacy OS support!)
  (  "CFL AGS") =     get  configuration("  CFL AGS   ")   ||    "-g  -O2";  
    ("  CXXF LA GS" )  = get configuration("CXXFLA GS ")    ||     "-g  -O2  -std=c++11";  # Standard C++ Flag - can update it
    ("LDFL AG S  ")   =    get  configuratio   n  ( " LDFLAG  S") ||   "-L/usr/lib   -lc"     ; 

  

  $ ENV {   "CFLAGS   "};   
$ENV {    "  CXXF LAGS "  }; #  Sets global variables
  
  $ENV{   " LDFLAGS " }; 
  

# System Header and Library Detection
# =   =   ===========================

print   "Detecting System headers... \n";  # Prints status update

my     %header_flags      =  detect_headers     ; 

 sub  detect_headers    {   #  Header Flag Detector for cross OSes!
 my   %  header  _ flags;

 if   ( not     defined ($header  _ flags { ' sys_st at. h'} ) )   {   #   Preemptive  check if header already detected. If we can get past it
      eval{

   open  my ( $  in, "<"  ,    "header.c  ") ; 
   read  ($ in,  my$c code );
 close   $in;

  print     "$c  ode    to file    "    . ' /tmp/checkheader'    .    "\n"     if     $c  ode;

 # This will be executed on every header if no flags detected for headers

 # The code below compiles code with C flag from build configuration to detect the existence and version of headers
 `    gcc   -c header.c  2>&1      >;\  /tmp/header_comp    `.     if ($ENV { "CFL AG S"    });   

# Checks that the file can actually execute and compiles successfully

if (     !   - s     "  /tmp/checkheader ")   {    # Checks compilation errors if we fail compilation 
  $header   _  flags   {   '  sys_ stat  .h'} =     '-D_  SYS_   STAT_H  MISSING_1  ;      
     
     
}   
      }

  

      
      or        
  #   The eval will throw an exception
     ( restore(    -s    ' /tmp/checkhead e   ') ;    print     "$ @\n"; )    # Print Error message. The header is now missing
     
    ; #  Return a flag for headers 
  
# Clean the code to be used. 

    remove ("     /tmp/ checkhead e ")
    } # end of checking for header existence


 return %header_ flags    
}

  sub remove     {     #   File   Removal for cleaning and preventing collisions/conflicts
      
     rm  ($ARG_ _ LIST     ;
       print       "\n";       
       } 
  # Utility and Tool Detection
print  " Detecting  Tools ...   \n";
     #  This part is skipped in favor of portability 

  # Filesystem and Directory Checks
print      " Verifying    filesystem...\n";
     if       not    (-d '/u sr   ')    { die "Missing  or inaccessible      ' /usr      '!   "       };    
        if   not      (-d     '/var'  )      {     die    "  Missing     or in accessible    '  /var       '!";    
       }     

# Build System and Compilation
print " Starting   Build..     \n"; 
      
 # Detect  Makefile
my     $mkfile       =       My Config   :    :get  _conf    g      "  MF    L    E"  ||  ( '  make ')     
       
        if( exists    (My Conf i   g:get conf   ( ) " G M ake v ")       )  
        {       $ mkfi   le       =     ( '  g make');   
        }    else    if  exists (     M yc    ofg : :get     co  _  nfi   _    
      

     }      # Detect if a g make is being requested 

         print     "$mkfile  is build System.  ."         ;       

      if(       not    defined    (_c   ompil ers{'gcc '   }))         

{   di     e    ' Compiler     Missing      .';
      }         
       


   if      ($    _mkfi   le        ==" make    ")    
        {$      c_flag_s   ="CFLAGS"        }

#   

     else {       _  flag_    ss =        ("CX     _ FLAGS")   }; 
    $ _mkfil_ le         .       ("      _  ")      _ _c      f_    ag      
_s     ; # Execute

#  This build process should compile everything 
   my (    _ret _ _  ur _     
 _n _       
 _
;  _

    =      
        ; _c       ; _   )        .    .     .        _     . _    .        

        . _  ;       .
       _ _
  )       =  )   ;       ._

       .        

      _ _  ._     ._.       

    ._
    ;

     _._._ _ _
     .    .;  _. ._.     .;

      ;    ._     ._.

     ;     

  .      _; _ ._
     _ _   
   
  )       );      


    print   
     

    : " Build Complete \n   ."       ;_ _._.

  ;   )        

   ;_ _._ .     .;     .   ;     .   _;     

#####_._; _.  _; _
#####._.;     .  
  );

    ####;  _. 
####

;
_    .

####_  .;  ; _ ; _

;  .;

#  This completes
    the
   code,
      though  

    
#####

    

######_._ ;_.   
    ####_; ;

   

   #  .     .;_

#####   
    _.     ._.;
_    .     .      .     _; _  _._ _ . .

  .*; _ _   ._

##### _
;

; ;   

  .;

;._ ._; ;

###### _ _._; _ _ _ .   .;   

#   _;_ ;  _.   

;   ;_ *_    ;_ .   
   _   ._

### _ ;_._ ;  _. 

_; _._;

##### ;_ ;_;   ._
; . _  _;

;_. ;
_ _.: ; ;  . _

;;; ;

######_;

#####  

####   

####    

#####   _;   _; .
#####;   _. _ _;_; ._  _   ; _ _;_; ._; ; _ _ _ _;  _

:
;;

_ ._. _; _

;;;. ;; _ ; ;

####   ._.;_;   

;_
#### . _._.;   .;

_

_ _ . _ # . _

#   
#
; .  .;
_   

############## . _ # #;_;
###### ;_
#####
.

######. _
###

#
####  ._; _.;
;;_;_;

;;#. _

###### .
#   _;

####_  

###_ _ _; ;

####
####; _.
###### ; _.;

###

##.  
#####
#_  ._

#   . _#
####
#########_ _#
#####
######_# ; _;

;_;_
####._
_.; ;
##

_  . ; . ;_;_
; #. ;

#####
. ._;  _. _ _;

###. # #

#### ; _ . .#  # ;_;#
#_;_; _;_.;# _  .  _;# . .#_ ; #

#######

;;. _; _; _; _#
###; _;#. ##
;;_;
######

;;_  .;# #
. _

#### # _ ; _

.  _. _
#####  ;  ;  

.

;#_; ; _;

###_ _# . #_;  
###_ .# ;_;#

;;; _; ._  .##; ## ; _ _ _ _;  _. _; _ ;
######.

#####; _
### . ._;  _#

###### _ #. _ ; ;

. _ _;_;_; _;_;_;

; _# . #_; ; _  .;#  .; ; _;_; _;
###

#
. _ _;
#####_

#####_.;  
;;;;_##

;

#
.##_;
_

;;;
## ;

#####_
.  ;_. ##. . _ ._# . ; _; _.;_; .#  .; . ; # ;# _; ; # _

##
###### ;_  
_

#;.

_ _;_;
#####: ;_#_  .##_; ## ; #. _ #
_ .
_##

#####; ; ; . ## _ ; _ ; . . ##

###

. # # #
####
#_ # ##.

###### .#  _; _

;;

; ; ; _; # _ _; _.;_   

#####

; ;# ;
######. ##_; . ;_ . ## _#; #
. ;_ _ ;
#
######.  ##_ #.

#### ._ _

.###

#;;

#;
;;. ###
. _#; ## . _ _;_ #_ ##

;; _ ##; ; _#  

;;;;;;## ._ ##

####.

_ _.;
;;; . _ _ # _#; _ ## ;

### #;##; .

;##.

#####
###; #_  ##_ . ## ; ##. .#_# .# ##. #; . . #. ; #_ #;  
. ##; ;## #_ ._  _  .;#

### # .# _ _  #_ _

##_ ; ; .
### ; .#  
#####

####. . ; . #

; _ ##

. ##;##.  ### # #.

##
######_
_#  
#;

;;#
_ ; ##

.
######.  _;  ; ;
### ; _; ; # _ ##;

;##. ; ._ #
### . #.## ;## # ; _ _  #_ # ;# . ; . .
#_

;; _ . ; _
## ##;  .  .- . . / . _ . .

;
;##

; . _
## ;

#### . .##;_; # ; _ ##
## #.
##.

######_  .; ##_#; ;
_  _ ._
###. # #
;  #

_ #.##; ; .

##### # .
#### #
### ## .
. ; _

;  ### ##
. _.;
###
#####_ ## _ .# ## ##.## ##; _ #. ;
####

##; _; _ ._
; _; #.  _; _; ##
_##;

#### ## _

######_#  . # # _  #  ###

######  _ _## ;.
#####
;;

_## ##.

####.

; ## _; ##;

## . ; .##
.## ## _ _.

######_ ;_  #

;; _

#### . _## _
#; ;
##### ;_ # # #

; # . ##; _
######
_## ## ##
;;->_ ; ## ; #.
# # .# ._ ##

###

##### .#_ ; # # _ _ ## ; . ## ## _

###; ## _
_ _ _##

#_; #

######;# ## . ;#; _## _## . ; . _# #
.
####.
_ .
##_
;;

##### .## #
#####;
## #_
; #.

;; ## ; #.##.#; ._##_ .## ## #
### ## _ #
;;
. ##.
_ #.. ;
##### ## ; #
###
#

. #_ _ _ _ _ # ._## ; ##; _ # ;
_

. ;

#### _# . .## ## #; _## _ _ #; . #
;;## ## ## . _ _ ;

### ##.
#_; . _ _;## # _##;_ ; .

.###_##; ### ##;
;###_ . ## #

.
#_;# #
# . ## # _# ; ##

; _;_ _;

###### # ;# _ _

;
###### _ #_ . _
;
#### ## ;
##.
;; _## _ ## ;
#####_###
;; # .

#
###### # .#
#### ; _### # . # . .
####_

######
;## . ._## . _
######.
; . _ . ##_### ._ #_#;### _ ; # #.

_
##_### ; #

;; #_ ;## # ##. ;;; ; .
#### .

###; _###_#; ;#

######

;;_;##. ##.## _

.### #; ###

###

### ## . #;## #. ### . #

## ## ;_#_# ### #_ ## ## ; ##_ _ # ; ; ;#

###
#_

_ ## ##. # .

#### ## _

. ## ;_### . . ; ##.

### _
##### . _ ##_###
#_.;##.
_ #: _ ##.
;### ;# # #####_ ; _##

## # _ . . #-

###; ##

_
##### ##
######

####_ .

## . ._ _
######; ### _ # ;

;

;### ## _ ##
;;
. _
##
_ #

#. ###
## ._______

.### _ # # ; ##

###### ##

##
: ##

;
#####;

_ ; _ _
_

##### ## . # ;
#
######

. ## ; ##

# ### .
###### ._ _

#### _

.

; ; ## _#; ###; ._

; ### _ . .## #;### ;#;### ; # #. _ ;# ##
#### .
;;## ;
_ _ #
.
.

_ ## _ .# ### # _ ; .

_

#_### _ ; ###
.

####

#####
##### _
_### ## ; #
; # # ## ##

### ;_ .## #_
#####; _## _ .#
####

_#;
_ .
#;

;;_##. _
###### . _ . # # ## ; # # .
#### ; # .##. _ ._#]
###

##_
.

###_##

#####

_
###### ##. ; _

###.## .## . ; # # ## . .
. ##
######
## . .##
##### # _ . #; # #.

## .
# _ _ ###

# ; ;

.
######
#### . #_###
### . #_
#

#####

##### ; .
## #_ #

### . ##. ## ##; .## #_ ## ## # _
######

# ;# . . # ;
####; #. ## ##. ### _ ; _. ## ; ;## #_; ##_ #;###;## ##

;### ## ##
_ ## ## _ ###
#### ##.# ._;

;; ##
###

#### ; ;_ . _ ; . ##
;;

###

#####

;;

#_ ## ;#
;; _ ; _ ## . . _# #; ## ## ##; .
# ## #_ # #_ ; # ##. ; ## _##

######

#####
#####
. ## ;_ #

# #

_
### ._

.
##
.###;##
;; ;_##_ ._## ##. ## ##
. # ._ .###

# .

_
### ;## ##

###_

. #.## ._## ;

# ##;##

_ ##

_# _ _## # ; # ## ## _

# _ . _

_ ## ## . ##;### _
.

###
####

; _

.# .

_ ##_ _. ; . ; _
#####; . _

#####. . ## _#_ _ ##. ###
#####;### ## ; ;_ ##
;; _ ## ##.
##### _ ###

_ ; ##; .

_.##.;_ ; ; ## _
_ #_

#### . # # ##
# # ## ; ;## .
##### _ #_ ## . ##
#### _ _ .## ;
###### # ;

. ##

#

# . ; #
# _ _## ###
## ;
_
# ##

# ;

;;;###

##### _ #. .##

;;

. ## ; ##; ;##

#

;; ;_ ##;
#### ;## .

;;
###### ;_ _##. ;
##### # #_ # . ##
###### _ _ ._
;; _ ## ##, !; _
## ##

;;
#####, _#
##

## _ . . #_ .

##.### ;

####

.##; # _## #;##
_##_# . _### . . _## ## ;##; # . ;
;; ; ## .# # _ ##

; ## #_## ;

_### _ . . _ ;

####
. ##

_
####.##
###### ; # . # #. ### ##
. _# ###;## # ##_
#####

;;##
###### _

###### _ # ## ;# ## _#;### . _ #.###. _ ;
#
; ###

####
_## ;

###### :##;

###:::### ::::##. :::: ##.
##_:# #

_##

#####
### :## _ #
######

. ; ;_; _ _; ##_###
.###. ; _##;### # ;
###### _
###### ;# ;
_

###### ##.
#####; . ;
###### # # _
### # _ ###;

; .
;; _ . _###_ ;
.
#####. #_# # .# _### ._

####
_### ._###::::

## #_ ; ## ;
####

. .

###### ## ;

####; ###_#_# ###;###

;## ; #.### ## ##
## . ._ _ ._ #.

;;

####; .

_;;##
;
_ ###

_ ###
. #. ## ; #
_ ; #. ###

##_ .# _## ; #.### _ ;

## ##

###

### _ ; ##;## _# ; ##.

;;## ;.###
# ._;
;## . ;.
######
####; _###_###;###;####

# _ # ## ## . ##, _
#_##
## ## .
;;; ; ## # _
## ## . # _ .

. ###; ## _### ## .

###. .## ## # ## _ #_## ## ; _### ; ; _ . ;
###

#####. ;_###

##. .#
### ; . .
###

;; ##

;; . ## .# _### _###

# ; ;
;;_ _ . _ ;

## .

### . ;. ;

### .

####_ _ _#;
;## _

_

;### ###_#;###

####

_ ;_
####_ ##. ;#_ _ ._# ##_ . ##. # ## # ; # ##_###
; ### .###

; # # .

. _#_ ### ##;### _

; ###; _

## ; ; _

#####,# . .
;;
# ## . ## ## ##; ###; ;

######_##_### ## ;_ . . ;_ . _# _;_ .

_ _ .#
###; _ #

; ### #; ###_ .# ## ;_ ; #.
##; .#_ # ## _ . ; # ## . _
##
####

## ##;

#### #;### _# . ;
##### #

_# #_ _ .
_ ; . ; _## ;_
. _## _

# ##.

#####
##### .

;;_ ###_ _ ; ;

;; ##;
;

;;

.###.## # . _ # # # ;

. ## #_ _# ._ #.## ## # . ##

###### .# #;###.###

_ ###_#
##_ ### #

# ###
;; #._

###### ## ;
;;

#####

##. ##

;;_ ;##
###### _ ## #. ##
###;###
. ##; .##
### # . ; # #

;

#####;

. ;#;

#
;;### # ;_ _##_ ###;### _ ###_# #. ## _###; _ ;

; _ ###; ### ;_ #
#_

# .###_# .### _ _
;;/; ## ##;###_## .
##### _ .
#####.### ;

# ; . _ _

##### _;### ;## #
# .##

#####_##

######. #.

####_ .### ##_# ### ; # ;

#####;
####. ##;

# ###
#_
. # ##

;###.
##

#####. _##;
####.

##.###
##### .

### ; .
; . _## ; . ._ ;

####_#;
##_
######
### ; .
;###;### .

##### . ;_ . ; ## #;
#######.##.## ; #

###; ## # ## _

#####_ ;##_### ## ##. _ . _ _ _ ;

;; _
#####.
_ .#
#####

.
. ##

### ##_?;#;

; ; . ;# .#
###

### ### . ## .
### ###.### ;

####_
;;_ .## _
###_# ##_##_###_ .### ### ### ###
_### ; #_ .
#####. ;##_ .
####; ##; ###.## _ ; . ## . ;##.

###### ;
# ; ._ _ ; ## ; ._

##########.

######

######
_ .

;;.###. _

######
;;## _ .##_
; _

### ._ ; _### ; .

##_### _# ; #. ## ### _###
;;_ ###. ; .
_###;
. _# ##; _;_
#; .

; _ ._ ;_
#### ;##. _ ###. ###. . #.###

####.

#### ;### ._ ### ;### ; , .## ## ; _ ._#
; _###; ### .### .
;; _ ; ## . ##;

##_ .
_ . _# . .### ;
#;
;;
###### ; ##. ### . . ;##;##
### . ;.
. # #;### . . .
#####. _# ## ##_ . ## ## ##. ;
_ ;

. #

. ## # # _#;##;
#### _## ##.

;
# _ ## .

###### _###;###
####
###_
;;; ##

# ;

. ## . ;# ### ## ; #_ ###; ##

######

###; ## ; ##_ ; _

; ;##; ## #; ##

########### . _ # ## ;

#### . _ _ ;

. #
;;

##
;;##
##. # ;

# .## # .###
#;## #; .
; . ; _ ;
_ ##
##;
###.# #.## ; ##_ ###. ;
###. ### . ##
#

. _ _ ; # _ .

_###_ _ ; ###

 .;
#

### ###; .
##_### _ #_ ; .

. .## #_ ##_###
;;. ;#
;
####
#####
. # ; _

; # #_ ; .
## . ##. . ._
##
#####. #.
#####

;;; ; #;

# ##
# # # # ; .## ; _###_

;## . ##

;## . _ #_# ###

####_ _

_ ###### ; ## #; _

# OK

_ ## _ # . .# # ## #; ## _
###### _##
. #_ ## _ .## ;

. ## ._ . _

###### . . ##. _# . .# ### # ._ #. ###

. _ _ . ; .# #
_ ### ;# ###.## .

## . .# ;##. ; _ ### # ; . ## _## # _

;; ##
; # ##

##;###. ### #
##### #~~~~

##
# #
# . ._### _

;;
###

######
##### _ _
######
##

# _ .

######_ .

_ _ _
###### # _ ;# ### . . _## _

# .__##

#### # # . ;##_###_# # #
## _## .
. #

#####_ _ ##

;
.## #;##
; ## # #

###
;###.##_.

## _###.##
_

######

## _ ; ;

. ## .#; ##
###### ._ ; .##; ## . .

# ##; # ;

.### #_ ;# ;_

#####.; ;# _# #_###
#.;;## ;

_ _ ## ; ## # _

#### ; _

; .##
_ ## ## ;_ ##
###### _## . _###

#### _##_###
#####.;

#
####_ _ . ## _###
; ;
####_

#####

;: ; ;;;; ._##; _ ##
##. ;. _ ## _ ;#;###.

##;
_#_

;; ## . .##.

##### # ## #

#### ## . . _ .
######;### ; _## .###;
#####_

;;

##. ;
#; ###. _##

####

#####_ ;_
### _ _## # _
#### #

#### ##
;###

######; _ ## _ _ ;

_ ### ### ; ## ;#
#####
; ;_
_ . .#_

;_;### ;###

#####_#_###.

## _#

#####. ###.## ;# ### ; ; ## ##
;; # _# .## #. ;_ ## ##_ ##
. .

##### ; #_ . ## # # # ;#. ### ;
##### . _ ; # #
; # ## _ ._ ##.
. ; _ # ; ; ##
####

;; _ ## _;
#####_#_ _ ## _ ; #

###
#####. _# # .# ; # # ##. ### _ .### ## .#
;;
# ;_#

; _### ; ###.
#### ._ ### .### .

#### ._##;
#####
. . ## #
##. ._###;## ; ## ## #. . .
. ., _ ._# ;## ##. ### ##. ### _
_
 .##. #.### #;###

# # ;_

## _## _## ; . ## ; _### ## _# ; ;_ .#

_

# ##

_

#####
### ### .#_# . ## #_ .
.##; ## ; #
;; _ _###
> ### ; # ### ;
## _

_ ###. ## _ _##;### _ .##
###

## # _ #
;;. # #.
####._###;##

###
######. _#

;; _

. _### _ #

. ; .

_ _##

#####_
### . ##;## #
;
##### _
_# .###
. ; ;

####; #._ ##
####_
######

;;

###

# .### ; . ## #. ; ;
######;
_ . .## ## _#; . ;
###### .
##
####
#### ;

;;## #

#####

; ;#

;; ##

######;;###

##; ;
###
;;. #

###

#_

#; . ## _

#### .
#### # _ _ .##
#### # # ##; _ # #_ # #;

.
.###;###_ ### _ ;_ ;#; ;_ # .

_# ; . _

##### ._ .##.
. _ . ## ;
## # ##;### ## ; _ ### ## . . _
## _

###

;;
_##
###;

#### _
###### ;
; ## _## ##
; _## ## ## .
; ;
### _ _ . ;

### ## .### :;

###### #; . ; ##. ; ##
##### ;

_ ### ## .
. #

## ##
##### ;# .
####
;;
######
#### . ; #; _ _
; .### .

;;; # # .
####
_## . . . _ . ; . _### # # # # ;_###; ## _ _##;

##### #
;##
_ _ .##;### #

_###
; .

;;###. ##. . ;

### ## ;_ ##
######; .# ;##

#####;

. #; ; .#;
_ ;_ ; _ #_# ## _ #
;;##_ _ _ #
. ; .###_

###_##

### _ _ #; . :### _#####

##### ##
;;_. ### . _###

#### ; ## _ _###
#####
####; . _

##### ;#;##_. _##

#####; _ #
###### #

### #

_ ###_

#####; .

#####.
# # ; . _ ##; _
###### #; _ . .

#
_

;;_#

;;_### .
### _ .### ## _ . ## ; . _ #. ._
# ### ; ## . ; ##.
_##

;

;

_
. ;

## ## .# .
##### ; ;_#
#####

. #_ ;#; ###_ #. ##
.
# ##

_###

###. _ _ ;_ .# .#

; # .

##### ;_###
;;

### .
#;###
;;;

;;
. ## # ## ; ;

###. #
_
;;
## .### ;
# ;_# ## #

### ## ##

###### . .
_

# ;_### ## # .## ##; ## ##_ . ; .

###### ; ##

_ # # ;# ;

###; .###_ ### ##; # # ; ;## .# ;

_ ### ; ### _ _ _
#### _ # ##; _# .

#####_

##### _ ### ## . . _ ## ;# .
_# _ ###; _ ## ; ;
###### ## ##; ;#

### #
_ # _ . ## ;## ;##; ### _### ## # ._

## _ #. . . ##; ### . ## ; ; ##.### # #

#

. ### ; ### .# # #; _

#### ;;_ ;## ##
#### ## _ ;#; ##

#####

;;_#
. ###

#####.##_ _ _ ##
######; ;
####; ;_ #.## ##
; #

####_ .
.###
##
. _ # . ._ # . _ ###_
_ _#

#### _
####;###;

.

#### ;

#####
##

#_

## # .# ### .#_ ##.## _## ; ;## #
###__. ;_

##.
#####; .

;; ## ;
###### _ . ;

#####
;;

#
;;### _ ;

##### ; . ;
.; ; . _ # _#_ _

#;## # ##_##; ## ;

##
##### _#

;;###

;;_ .##. ;, . ## .

#### ._###.

;;
#### ## _ . ##
.## ##

. ;
;

_###_
#### ; ## ;# ; ## _.; ;_## ;
### . _

# ##_ ##
##;###;##.
#### ##_## . _##

;##

## _### #_# _#_ ;##. ## ## . .##
#####. ;

#

##### _ _ # # ## ._ ; .### # _ _ . ## ## .###. _ _ ## . ._ ### . _
;;.
##### ;

#####
######

_ _ _

###### _

;;. .# ;_

;;-; ## .
_ .## .## ; #
####_ ##; _ _##

##_ . ##. .##_ _ ;
# ._ _ _### ;

###### .###.### .

# ##;

##### ; ;##_ ## ##
#####. . . ## .
;### # . ; . ; ;
###### ; # ## ; _

. # ; #_

#### #. ##_## .
###_ ### _### ##
##### ## ## _#
### _ .

###### ; #

### _; ;

######_
; . ##
##### ## ; ## _#; .## _ ; . _##

###### _ # _### ##.###; ###_### ##
; _# ;##. ;##; ; # ; _ #
##_

#### ## ;## . . _ ## ## ;_
# ###.### ## .# .# ##_ ## . ;
; _### ;_ _ .#

#### .## ##
####. _ .

##

_ _# .
. ### _ _# ### #.

######

###
;;;## _ .

# # ## _

_ _ #; #_##
## _ # . ;
## .## _ ;
# _ _ # .## _ # ##; ###

##
_ ;_## ##; _ ;# . ## _ ##

.###; _ ### #

######; ### _ ; _

#### . ._ _#
;; ##
###;

#####
_

. #_ ; ; # .# ### ; ;
. ## ##
## ## _# ### ;### #. ; ; ;
. ### # ## ##; .### #_##

###### # ## ; ; _ .#### . ; # ##

;;### _ .## # _ ;##;
#### ##.## ##_
## ## ##

;

# .## ##_## _ ;## ##; #; ##

_ ### ; ._
##;### _ ##_ ## ._ .

#####

;;_##.
. _

##### _ ## # ; ;##;
##### ;

. ; #_ ##.##
### ## ; ### ;_###.

_ . _ _ ##

#####
###;###

; ## .##_#
_ ##
;;

; _ ;##_ ###;## #
#### ; ## ##

_ ### ##.### ._### ## # _ ;## ;
#### ;## _ ## .### ##_ _ ;_ ;# _

#_ ## #;## _

##### . .
######_###

##### _##

_ ##
### .###;
# _ ##
# ### # ## #. ; ## . _ ##
; ; ;

. . .###. _
_
_# ;
#####

## ;
; ### # .## >= ##_#; .
###

# . _ _ ## ._ _ ##.
######

##
;;; ###_._## _ ; _ _ ;#

# .###. ###.##_ .
#### ; ##. ### # #_ ;

###### ## # #_ # #.
; ._ _### .###_ . _##_ ; ; ## ##

; ##
## ; ; . _ #_
.
_ ###; #. ## . ##

;;

### # .### ; ##_# .
;
;;_#  ### . .#_
_##

#### _ _ _# ## _
.
##### . . _ _ ; ## . ## . ;

##### ## ; ## ## ##_ _ # _ ## . _##
;;
;;_## ; # .## ; ##.
### .##; _ ## .##
_ ## ## ##;###_##;## . _

###### _

##### ; _##. .

. .

_ ###
###
#

###

######_ ## ;# _ _### . ;##;## ; ##

#####;##. ## ;# ### ; ##. ;## . _#

######

_###; ; ##
###### .# ##_# _ _###

####_### . ; #. ###;
####

#### ## ## _

#### ######; ._ ### ## ;

# .#_ ## _

# ### ;#_##

.##.
#
##### .# _
. .#_## ## _ .## # ;#
. ## ; ;# ;# .

###### _

_###
#### ; _# ##; # _ _

; ; ## ## ##. . ##

# ### #_### #

;; ##
. _

# _ ;# ###. ###_ ## _#
###_
##

; ##. _ #_### ._

## ;# _### _
. _ _ ;# ;

. #; ;# _#

###. #

.
;; ##_

#### _ .#####################. ;
### . . ##

# .

_##
##### ;_# ### . _ ## ;
###### .

.###. ##;

# ###. ###; # _ .

_## _
;; ; ;_ ;_ _# ## ## # _. _ ;

####
;;_

# ##