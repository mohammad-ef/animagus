#!/usr/bin/perl
use strict;use lib './libraries ';
## use Term: Readline;
require Term- ANSI Color;
require Sys StemInfo;
my $version=" v1.0 ( Build Repository Automation)";

sub init {
    print "$Term:ANSI Color"-> color ( 'green bold', "Build Repository Tool - Build and Manage Your Software" ) . Term:ANSI:: Color 'reset'." \n \n";
    # Operating system and platform detection

    my ($os, $cpu, $arch ,$mem);

    my @osnames = ( "irix", "hpux",    "ultrix",    "solaris" , "aix" , "linux ", "bsd");
    my $detected_ os = grep { defined $ENV { $ _ } && $ENV  $_ =~ /^ $ _ /i } @osnames;   my %env = (%ENV);

    if  !$detected_os && defined $ENV {'OS'} {$detected _os = uc $ENV  {'OS'};} 

    ($os, $cpu, $arch ) = ( defined $detected _os ?" $detected_os":"Unknown", scalar localtime,  uc `$ARCH`   );
   my $mem_kb = int( scalar `/usr/bin/vmstat -s | tail -1` );
    my $mem = int( $mem_kb / 1 ) . " KB";
  #Essential commands checks

    my   @checks =("uname",    "awk " ,    "grep", "make",     "cc","nm","objdump","strip","ar","size","mcs"," elfdumps","  dumpscp","  rsync");
    for my  $ cmd (@ checks )  {   # Verify essential build commands are accessible.

    if  !$cmd  {   print "Error : Essential tool '$cmd' not accessible!\n";exit 1; } # Check tool exist and executable

    }


    # Environment normalization and configuration

   $  ENV{'PATH'} ||= "/usr: /bin";
   $ENV{'LD_ LIBRARY_ P ATH'}    ||= "/lib: /$lib";
   # Initialize temporary and log locations
 if  (!-d "tmp")  { mkdir "tmp ";}
 if(! -d " logs")  {-mkdir "logs";}

   my $temp_dir = "tmp";    my $log_dir = "logs";

    print "OS      : $os\n " ;
    print "CPU      : $cpu\n  ";
    print "Architecture: $arc \n";print "Memory:    $ mem\n \n";
   print "Temporary Directory: $temp _dir\n";
   my $logfile  = "${log_dir}/build_${ $arch }_" . localtime   . ".log";
     open( my $log, '>' ,$logfile )or die "cannot create log:  $!";  # Log all output for debugging purposes.  print $log "Starting Log: "    .  scalar localtime   ,   "\n";

    # Configure output for terminal coloring ( if module is available
   my $colorize = Term:: ANSIColor -> available() ? 1:0; print "Using $colorize coloring for output.\n"; return ($os, $cpu,   $arch,     $tempdir, $logdi, $logfile,     $colorize );}
#Compiler and Toolchain  Detectio  n
sub detect_ compilers {
 my ($os)    =   @_;

    #Compiler Detectio   n - prioritize GNU, fall back to others
 my  (@compilers)     =   ("");
    print " Detecting compilers... \n";

   if  (grep {  -x "$_" } (' /usr: /bin/gcc ' , '/usr: /bin/ clang ', '/usr/bin/cc','/usr/bin/suncc' , '/usr/bin/acc', '/usr/bin/xlc','/usr/bin/icc' )) {   @compilers = ('/  usr: /bin/gcc' , '/usr/bin/c11 ','/ usr/bin/clang') ;} else  {@compilers =('/  usr: bin/cc' ); }

my  $defaultCompiler ;
for my  $ comp (@comp  ilers ){
    my  $ cmd =  $comp;
     my  $ version    =   `$cmd -v  2>&1 |awk  ' /\vversion\v / {  gsub(/version/,    "",$0) } {print}'`;  my  $compiler_version =  $ version;
    print "Detected Compiler :    $comp   (Version:  $ compiler_version)\n"   if   $ compiler_  version;
    if  ( ! $  compiler_version )   {     $ compiler _version =   "Not   Available ";     print   "Compiler $ comp not   available  / or   not   properly   installed \n;"  

}
    }

    #Toolchain Detection
 if(defined $ compiler_ version ){   return $ comp   compiler_version ;}else {   return   "No   Compiler   Detected  "; }
}

    # Configuration and  Flags
 sub configure_fl  ags {

    my ($os  ,_compiler ,$  target_platform)    =   ;

  my %compiler_flags = (      # Define flags for each compiler (example, add more for other comp  ilers and  platforms).      );
    );
  my @cflags = ();
   my   @ldflags =  ();

   # Basic Platform-Dependent Flags
       print "Setting up configuration flags... \n";  

        if  ($target_ platform   eq   "x86_   64  ")  # x86-64 ( most  modern  Linux/BSD   systems)     {$cflags   = "-march=x86_   64   -O2   -g";  $ldflags   =   "-  pthread ";} else  {  #Default   to   32- bit   for   compatibility   (older   IR IX/HP- UX/ULTRIX)  $cflags   -=   "-   m32   -O2   -   g";  $  ldflags  -=   "--   pthread";}  # Adjust for specific platforms/ architectures if needed.

  # Add more platform specific optimizations.     print   "  Platform Specific   Config   uration   Completed    .\n";

    return   ($cflags   ,  $ldflags  );
    }  #System Headers and  Libraries
    sub   detect_ sys_ header {     # Detect system header availability by trying to #include a header and #if defining a preprocessor macro  if  (   - e   `echo '#  include <  unistd.h > '  >>  test .c ;  gcc -E test .c  2 >/dev/null  |grep  - q  "#  ifndef  _POSIX_C _SOURCE  #  endif"`   )   {   print   "unistd.h   found.\n  ";} else {    print  "unistd.h   is   not   present.\n  ";}   # Add more  test cases as need

} # Utilities  & Tool Detection
sub   dete   ct_ tools  {
 my %tool_locations    = ();  # Store the locations of common system utilities for fallback.  

    print   "Detecting  required   tools... \n  ";  $tool_locations{ '  nm'   }=   find_tool(' /usr: /bin/nm');  $ tool_locations {    ' objdump'} = find_   tool( '  /usr: /bin/obj   dump  ') ;  # Add more tool detection

 if  ($ tool_locations { '  make'}) {   print    "  Found   :  Make   \n  ";}  else {  print "Error:   Make   is   not  detected.\n exit 1;  }$ tool_locations {    '  nm'}  ? print   " Tool  nm   location:   "   .  $tool_    locations { '  nm'} .  "\n":print   "Tool   nm  not found." .   "\n;"; return  % tool_lund  ;} # Helper to   find a tool   with some error  detection    sub   find_tool(     $  tool _pat _tern   )   {     my @found = glob    ($ tool     p _att ern  );
      my @bin    path _expo     =  spl     it(      '$  _ { PATH }    ,   _     );        for     @ _   _    ,  $ bin    ,      pa     t    {         #   check in the _  pat_th for executab le
          next if  _       _      = $   tool   ,   p  a      tten_ ;     
      my  _tool     p ath  $ b i      ,  path   / $_ )       ;    my        
     if  -- e  -- x    (_t       p ath     _      ;        {    $ _tool_   pat   t   _ =    -    $t       p a      th_        ;    print      _        $      tool  
     pat        th  f _ound        _     )
     return $ t  t      p       ;    _ _     a  
 }        _
    print   "$  t        oo_     , _  t       e     p      n      d       ;"    
    
 }  r       u    _    t_ _      rn     u    ;  ;}  
_      ;     }     f_   u d     _
 }

 _        f        e  _
 #Files   yst  , m   - d        ;        d
        ; _       t _     e      c  

     b r
 s
        ;     
#     s
     s    u b   s
_
   t_     c       d       u_     s_      ;

    ;     f   o    d   e _  ;     f

        
     b

 s _
 _

 s  i       s_    s _      t   t    ;

  ; _       i _      t       e     o       c_   _    s_  o ds   i     n   
     
 _       _

    d
  s       e  e_
 s_      o
 d
     Sub    d     d_    
  o_   o_

     t      e

    ;      e
 _ _    i   t_       e
        t
   o     s      t

     ;
 _

 d_ _ _

 s

 s _  etc  _      

     _     _

      p _  i_     
     o       o_
 _    
 _     d
 _
 _        d    i
 _
    t  ;       i     ;      e    

  o  s     ; _   _
  i      s  e      t   o      _

       
 _        o _  t   d _       e      s   e  e      e
      

 s
        i    s   e     o       
_        o      t

  _  t

     i    s       i  e     o

 s     

      ;
 s

 s   _ _   

 s
 _
        
   

   s    

 s     ;
 s
       i     e      d_      t    o       _    ;      d

   t_  ;       t  i       s     s    
   s   i _  e

     t   _ _        o    _ _
     t     t    
_  d  ;     o     ;  s     o       d  

      ; s
       d  e_        d   i
    o    e
       o  _ _    ;

  t  _
        

  
 _
     ;

_

     s   e
   s     ;   
       i   t_

      

    d       o       e  t  o   _ _    o
     e _ _     e   d   t   s     
  

  
      

   
      d   o

   ;     e  
       d   i    o_      
      t      d    o _

d
        t      s      d    _ _    _

      t  _  o     s_
_

_
   ; _     
       _       t

   d    t      e
 s

    e      s      e       
 s
      ;

_ _    _
 _        s    

     _   o        i    ;      s  t   ;      ;   ;    e       i    i   e_       i       ;

    e _       i      
     ;   e  

    _ _       d

 _

   _
    e      d      i

      d_  i     ;  _

_     
      i       o      s
     o_   do

 s _        
       d  o     o_  

       s    ; _     d_       _    t_
    _     i
      s

_  o       ;        s       d _       t
     

     t d _      

 _
 _        e
        
       
 _      o       t      i  o
   s , t _ _      i _    d   o _
        _    d  _   

      ;
       i

       ;        e_        d      

  i    e ome     

       s
  

   
        i  

    i     ;

 s       o    i  e  ;        s
       i    ;       
      _

        ;    e
_     

_

   s
 _   ;       ;     
  _  

       e  d     t   _ _  ;     _  _   e       e  
 _      ;    s

  o _
  

_

        i_   

  s  t    

    i  i _     d    

_     e     ;     t    

 _      o       

        t

 _  

       i
      
     _     _   s  d  
     

      s
      s_  ;     _      _
 s    i    
      t
   

_ _   _   
       i    

  i _    i   i       o _   i
        s       _        

_        e

     

       o   ;     

 s  
       o _

      ;    s_            t
       s     s   e      s

      t    s      i _  t

       _ _   d _       t     

 s     s  d

 _

     s   t
       ; _   i_   i    t      _     e   ;     _    d _      

;
        t       i  _

 _      s  i
     e
     s

        

    ;
       t _        i
      ; _  s       _    
  d

    s    i      ;        i  ;   t       
      
 _   e_        e

_       

     i_        

 _

       _     

     o     ;  t     

_        

       ;      d    

 s

 s       _ _

_
 i    ;     t _    e_  d   t   
  e    ;  t _

        i_ _        

    o_        

       e  i    
_   t       s

_ _
   e _
  t    _
 _

_    _  i _
  d   _   _       
   t       e     

     
 _      d      t
       
  o    

 _   
     

_      d  e    i_
        _   i  o

    o

      s
     t      i

   t    e    _    
 _
       d       i

     t   

       t      _       e _      s    i     s    s_        
      e
     t     i

 s _

 _    e   _   _      _ _        t       ;      _      d
      e   _       o  

   s _    _ _     t

 s       e_      
 s     ;   ;
        

   t     i   i   

   s      d    t       _  d   i

  i    s      

    
 s      s    

   
      _        d  t     
_ _

      d     i    

      ;     ;      i      e
 _
    i

 _ _        d

     i_        i
        s       i _      i_
   
  _  i       t

 s      _   d       i
     t_  _     t     s
        t_       d       d  _
        s     s

     d

 s

  e       e      ;   i       i
_ _        i     e

    _
      ;  
_     s   t
        

       

   d   s
 s_       
 s   
     
 s                 s       ; s

 _  s       
   _ _ _      _  

_       i _  e
     

   d      ;    i

       t    _
 s

     t

    d _      
     ;   _

  _  

        e     s _  

   

   _

       e     s       _   
 _     d      t
   ;      t       s      

    e   
       _      _       _ _     i    e      _
_      d      t
   

       i     i_   ;
_  e       
    s
       i      ;        i_
      
  d      s_
       s       _   ;    ;

 _
  i_
_ _             i

 s  
    e      d _
 s   ;  _    s      ;

        t     _       ;      t      _       d     s      
     ;  

    
        e _
_

     
_  s     e    i   d _ _  
       t

     

 s

_  o

    

  s   
    e   
   ;
 _    
   u      b      t    e  

        

     d   _       o    o   

 _       t      
   _

        o  t
       e       o_        
        d_        
        e _        o  o_    e       o  d       t  ;       s      e_  _       d _      ;   _

  

     t_   
  o     s   i_    _       s
    ;   i

   ; _  ;        

        d  _     d       i   d   e_       t

 _      t    _ _        ;   _       _   _   s   _       t      

_  

_    d _ _   _

 s     t     t   i _        
    ;       _        ;

    
  

     

 s
      o

 s

_     _  
 i   t _  i_ _      t     

    _   ;   d
       _
    

        i     e  o

 s       e      s       _     s       t_       
_       s
  e_

        d   o _       t
    t  o
   d      

    ;      d
    t _    d
_    i
 _     ;  
       
        e  _

     i
   e      

     i   _  t   

      
        t _     

    s_       e     ;    
   s    _ _ _ _    ;     i     t  s   

      t_        i

        _        
_    o      ;

        t      t       d     d  d    d   ;

 e
 s  ;   s _
   t  _ _    
        ;        i      i_     i
      

    

       e _
      d    _
        s

 s    
_       ; _ _
        _

      s  ;   

           i   t      _ t     ;   s

 s _   
        i       ;     s       o     d

 s _       

        
_    

_  i     i
       _       _   _ _    e    i       i
    ;      s  ;    _      

       d _  
        i_     t _       s

       d
       e

       i    _     
      ;       ;      

     _
 _ _    d   _

 s _

      t _       s _
   _        ;      t      d      e  d    d
      t
 s _ _      t     _       

   _ _ _        _   i    e d

   t o_       
      s  d       s     

        _ _        t     t    s  _     i _ _        

        _      
  d       e _     t

     d   ;  _       s     

   e

 _       _     t     d _

 s_  e    s _      s     

    d   i      

 s   
 s     
       

 s _ _   i
_ _      
    _    
_       e_  e_   ;   

 _        i    ;        d     t       
  i    _       
 i  ;
 s
     d  _       ;
 s_      e      s _        t    t       e     _   

  s _    e       

     _       i_
 s_    e       _    s

  s       

  _   

_    

 s
 s    e
  s     

       _
      
        
     s    
    e_   t       t
   d      _
       ;   s_     ;

      i  d      i _       d    d
  t_
 s       ;        i
        t

 s    ;       i       s _        
  d      _

 s    s  
   

      
   _  

       i     
      _      s  d     d   _       d_   d     _  t

 s   s   
     

    ;     ;        t       
        

 s _       _       i_       t     ;    _     _
 _

   _ _       _ _        
   s_   s      

     

 _        

     e  ;  _    ;    

 _ _
 s

        t   
       ;  s _ _    d    
     i    ;
      

 s _      t    ;     s _   _

_      e       
 s      t  

_

        
    

 _        ;    d_        ;  ;        e  _ _     t    ;      ;       t     s_        ;   t
 _   _   d     d  ;  i

      

    
       
  i
     e
_      i  
 s

     e     t _     ;

   i

   e

  i_        
  s      ;

      i
      d     s     _
        ;
_     s       s_
   _
  ;       
 _       e  _      
 s _

     

  

_    

       ; _ _      ;
      s      _    s       
        _   i    

  ;        t     _

_        
 s
      
        

   s_     e      s
       

   d _    d  d     t_        d_    

       i   i_       _ _    _ _      
   

 s    i

    ;      i      ;  _

 s       e    _
     t _
  d _
        i
   
 s       e   

       t_    t      
       t       ;       s  
      

 _

   s      

    ;   

     
  s      _     ;   
  e     

  ;        ; _      i_       _      
   
  

 s       i
   
 _    e

    ;    _      s     
      ;     _       i   

  d    ;   _     _
    

_     e      _      d
   _    t      ;

      s_    

 s       
_       

  
      t   

       

      t       _      

 s_        t   ;        i
     s

 s    

 _
   e         

 _ _       _      t       i _        _
  
 s
 _  _       
   d       

        ;      i _        t  d_

  _     _

 _
_        t    t  e  i    _     t_ _     
_ _
 s   t  

 _ _

 s
  t       e_

    t

      d     ;    _

   s

     _     s   i    t _ _

_ _ _      t_     i  d    

   
 s   e  i

   t    ;       ;  s   i    
  s     _       s_
 _

      s      s       s  s     ;  i_  ; _        

 s_  

       _    

_     
      _

   s _

 s   _ _  
    
   s_     t       t   t     d  s _     
     i    d      t _       ;         s _      

    i

   e_       i_     _        d_      ;   
       s     s      ;        
  d     ; _     t _       
 s

 s       
     
    

  ;        s   

  i

        d
 s    
 ; _       t       d     s  i_    s    d       i_    s

        ; _

       i
 _    d_      ;     t
   i                d

       _ _    i

    _    _        _

 _      d_    t     t   
       t  _

       s   
      ;

      i    _
        t _
    
        

     ;_     d

       s

        s    ;

   i   
 _
  s

    _

     ;
  d

_      s   i    ;
       t

        

  s     i_      s

  ;      

_
    d   
    _       t      s     s _       t   i

_        t
        ;  ;     _
     s

  _
 _     _
_

   s

 s     t   _   d      ;    i     _     t
 _

    ;  

s_    i    i      t  d     ;      _
        
  
 _    d     _

        s   _        t      _      t _ t

_    s     _       

 _ _     _       

_    

_       _ _   i    _      
     s

    
 _
 s    s
 _     
        ;      s _     

  d       =  "

    " ;
_     e       o      o_        o     s      s

  _        e     e  
       
_      

      e
     o _

     i    s     

    t _       t  o _  e
       t   

        s   ;     t_   _ _  t     

   s t

   t   

 _     s    
 s   t_       

  s_    d   t _
        d
   
      _   
 _
    d       d

  _   d_  

  s_       _  d    
 s   _      t   e      
_       t     t_ _  e   
        _ _

        d   _        ;  i      _       s  i       i  

    t _
  d      ;        
 _  
  e      d  t       e _       s      i_

        s_

 _        
      s

  

_  ;     
s

       e

       e _    i
  ;       ;       

   e
       i    

   i_      _      

        t     s     t      _  ;  ;  s
_   s _       t   _

     t    ;      
 s   ;       

       s   

  _      

 s _    
_  i
      

    ;  

       _ _
   _ _
       s      t_       s     i

  i_

     i

        t

       _     ;    _   s_     d   i       

        i   
        i    i       i
      

       _ _       t

    
  

     _    

     i_  ;     _ _     ;      _    s       ;
    t

      e    ; _    _  d _ _      ;     ;     i

 _
      i     _  
      

     d
_  _       s

 _
   t_  _

  _        s  s_     i     d _    d       
_ _   _   ;        
s _
_ _   ; _ s    
    
 _

        _
   s       ;        _     
  d_

_      
     d       _   s      i        ;     t       i
 _

       d    ;   d       i
    ;      

_     _ _        d    _     i       d     d_  ;     i     
    i_     
_  _   s      
  
 _       

        
    s   s   

    

        d _
  

 s    i       s    i    ; _ _      

  _    t  t      i _   d   i
   i      s      

 - -

       

 -    i     e

 -
 s      

   

       t       s_     
 s    i  

 _     _       
    

     e      s      i       

_        s _    e

 _       d     i

       d       
 -   t

   ; _ _
 -t       t

 _  e
  t

_    d       
  t
        d
   e
    i
    i   t     -

        e    

   d _    e
        _    e_  -  d _    _     e

 s     e

       t

    -   
    ;       s_      
 _      e   d   -      i  s _       

       i     d   d
 -

        i _      i _      e

     -   ;        t_        ;

 -        d

_      s    

    
    
        

        s       
    e      
  
_  -    i      e    -   ;   
_   -      ;

   d      ;     ;    

 s       s   ;

  i       

       

     

 s_        d_        e
   

     t   d_      e  t  ;     i

       ;        t
_     s      e    s _       i    
     
  i
     
    i      _  _    -        ;     d   ;

       ;   ;       t     

 _

s     i

 -    ;        _ _       

 s
        d       ;        _        i       
       i    

 s    t   _    e  -
 -  i  i     _  ;        
        
     ;      d      d  
- -   d_
_      _    d_     ;       

 _        d _   s  

        t  _       ;
 - -

       

 s  - _      d
   

      i   _      ;        d     

    s       _
        _

     t   d

 _

       _

     t _      t   d

    i  d  _      ;       i
-       

    ;    

 _    ;    i
 _
 s   

   d       ;

 _   t     

    _        e _      t    _  
 _
 -       i    e     s     d     

 s_
       _      s      i  -  ;    

 _
 s

       d       _      i
        s
 -

   s       d      ;
 _  
 s       s    d
  

     
  _   e     e _     ;
- - _     e       i       d_   

     _       s       ;   ;
 s  
    

     a  

  ;      
 -

        

        e  ;
 s_ _        i_       t
  
    -      _       i      e

       
_    _    d       _

        s

    ;
        e       _ _  i     i

   _

 s    s   i      

    
 -
_     

        
  _      

   _   i

       t

    s     t    d _   s  
   e    ;        s      d_     i     i_
        
   s_   s

 -    t    d   _        
 _ _   t
    ;

       i    t

 s  ;
-      ;       i
   t      t     ;   s      e_      

    ;        ;      s _      d    

    t      ;      _ _       ;   
 _   d _  d       i_     _        
       _   t
        e _      t_     _  d  
 s_      e   t      d     

       d _ _  s    d     s
   _
 -  e
 -  -

  i      
 -
 _   ;

        s  e      _     
        d      s     e_    

 -
       d

    _ _ -    

     i   ; _  _ -       t     

    
        d
    i   
   ; _ _ _     ; _       ;      d
        s
 s -    -

     _   _    ;        t
_

        s    -      _

       
-

        d
_  

_   s   d_    e       ; _     - _   i     i  
        

       
    i  _      t    _      d       -       ;  
 -     

        ;      s       -      ;        
 -  _    
       ;   _      t       

   
-

 -    -    
   i
  
     -    d      s   i     d_
  -  
    ;
 s

 -        

       _ _     _       -
 s   -   
- -       d_  e       

    ;    - _
 -    t    

 -
 s   -

 _    

 -   
- _ _        t   e    s   

       s

_ -    
 -   d       d     -     
   _      _  i  e  d   s  -   i       -       d    - _ -

_
     

        ;_ - _
        i  e

    

        d       - _     ; _    ;       
-

  -    t     _    
 s_     ;       ;   s       

_     _     

        t       -     t   ;     d _ _        ;        - _  ;

        d _
       s _
 -    i   
-  s_

- _  ;   i      ;     t

 _    t_
-
 s

    s _   t
- -
   i       s  i  -   t       
    

    t -        

       
-  ;       

 _ _

    i   

  t_

       i  -  i      s  _

-       -   -  
        
 s_   ;  t     t     -        s       _
_        
  _        s     -      

       s _ _ -

   
s _        s -       -        t    _  t       -

 s   
   -   _        
        ; d     d

  i    
        d _        

 s_       ;    
 -     d    _        ;  _ -        _        ;  s     i     
  
 -       

    -     i

   d     t _  ;        -     ;

   d    d     ;

   ; s  ;        ;        
  d       i     

_        s    t _       d        

 _     d

   s - -       d
       _     t       _ _        
       ;     t
 _ _  t   _ _    

    _

 -   _ - _    ;   ;  _     s     t

        ; -    i _ _   
   d  d_ _       s     
_   
  
   ;    

_ - _        ;       i    
   i

        _        _    

 -  _       ;        i        t   t     t  

       
_
 s_ -

    i    t       d_
    
       -        ;  
 -   d

        s     _ _
  ;       ;  _ _  

 -   

     ;    

     
  d        t       d_

       s     

       s _     i _  s -        
        t    d         ;       t     -       t    - _     
  -        
   ;  _    i     _ -
 _   ; _       ;    

    -

 s       
 -     ;     ;        
       

 _        

        
   d        

              
 - -
 
        _     i       d    i _   ; - _ - -       ;

_       s _

     

 -  s
 _

 _    t _   
    s  t  

        d        i
       d     ;
  s     s -    

     t -     ; _     
    i  
       ;  _   i   
     
     

     -     t_ -   t     i -       

 _  -        s _        -     i_     s -       t     ;

    -    -
       s     - -       ;

 -       -
       i

_ _       i _
_
  

 - _     

   -        s

   t    i -
        i  d_  i       

        s     ;       ;        t   t
       - _        ;
   i_  
_

 - _  d _    

 _ _
 -       s _    t_       

    s   
_    t i

        -  s    

   t     -

       t_
    _        

    s       i
-     -        

     ;     

_ _  ;       
        t
       -       i   
     ; -        _  
- _       
     ;
       ;       -

     s

_        _
        _
-        i -

     ;    _    _  t

   -       ;  t  t  i  
     

        _     
     s       

 _  -    _  _       -     t -        -
     i-     

_ _
        _  i   -    ;    

 - _ _
- - -  i  

    s _  s       i    ;    i _ s -        t    -        
-    -

   i   

  

       

_        -   ;
  t _  
    _   
        t  

 _ -       
 -   -       t   

       t

 _ _ _       

        t       

_
-    

    
  t_ _ -       ;    t_       _

     i
       

     s_   s  _ -   
   _       _       
        i - _   

 -  -       i
    

        i     
-       t     

   _   ;  ;    
    
     d _  ;   i _-

_ - -
       i -   t   ; _    -        

     ;

 -        

  

  d    
  d     ;        t    

        

_  -

 -i -

 _-    -

  

     

 _  d -   
  t   

 _ -  s_ - -   s - -       - - - i

    

     ;   t       ;  _
  i     

     s -   s   t _
 _-   i    

  d       t -
    ; -    
     t   - -;
  s     _

 _        ;   -   t  d  
-     ; -

- _  i   

-

-        
 _

       s    d - i   _   
       

-   ;  s    i r;    e  s - - _
       s   _  

    _  i-     _  -   ;   ;    _ _  _    
  