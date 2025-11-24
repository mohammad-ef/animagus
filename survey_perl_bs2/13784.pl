#!/usr/bin/perl
 use warnings "nonfatal";  # Suppress some warnings, handle them manually when needed.

use strict;

use Carp;
use POSIX  qw(:constants);  # Use these constants.  Not the best practice overall but needed here

# Module Imports for Function Calls. These are necessary to make all functions work.
  use Feature qw(say);  use IO :: Seek; #For seek, tell etc functions that read/ write
 use Sys::Info qw(os architecture cpucore memtotal memory);  # For information gathering.  Can use more specific libraries if they exist and are installed.  But these should do a sufficient job
 use Env  qw(:REPLACE_VARIABLES default vars); # For environmental variable access

 use Term:: ANSIColor; # For colorized printing (optional, check for availability at runtime)  Can add this at run time if not avail. 	  Can use more specific library.
 use Term :: Readline; # For interactive menus, optional.
# ---------------------- 1. Initialization and Env Setup ----------------------  (Core)

 my $prefix = "/usr/local"; # Defaults if nothing found.  Can set via environment.  Can allow setting during install/config phase.  Can check for user access.
 sub init {}

 # Detect OS (Simple, expand later).

 my @possible_os_values  = ( 'IRIX', 'HP-UX ', "BSD", "Linux", "Sun ", "AIX", 'ULTRIX' , 'Solaris ');
 # OS identification - this is rudimentary for now, will improve

 my $currentOS; 

 # Check each os value and set $current os accordingly.
 foreach (@possible_os_ values ) { #Loop through potential OS values and set the $currentOS var.
  #if system ("echo $osvalue  | uname")
  #if (open (my $fh, '<', "-")) {
  	if (system ("uname"))  { #Run "uname " and test result for errors or no output.
		$currentOS = @possible_os_values [ 0 ]; 		 #Set OS value.
		exit 0;

    } 

    $currentOS = $ possible_os_ values  [ 0 ];	
    last
    }


 #Verify Commands: Basic Checks
 sub verify_command {
   my ( $command ) = @_ ; #Command that will be used, and passed as arg from other parts of this script
    return eval {system($command);};	
  } 	#Basic system test function, if the result is non empty string
# Create Log and Temp Dir (Check, create with appropriate permission if doesn't exists.)

# --------------------- 2. Compiler and Toolchain Detection---------------------

sub detect_compiler {
   my @compilers = qw(gcc clang cc suncc acc xlc icc c89);  # Compiler options. This array needs expansion for better compatibility.

  foreach my $compiler (@compilers) {
      if (verify_command("which $compiler") != "") {  ##### This is an effective means for determining tool pathing

        print STD err  "Compiler Detected $compiler.\n"  ;
        return $compiler; # First Compiler found returns that as first match for consistency
    }

  }
  return "No compiler architecture.";   #Return default
} # end Detect Comp.


#Detect linker

 sub detect_linker  { 	#Detect if ld compiler architecture exists in env or via the path and return value or null value
    my $compiler=  verify_command(which  'ld');

  if ($compiler  == '') {   return null  ;}

   else    {    print "Compiler: ". verify_command( which "ld") . "\n" } 
     return $compiler; # First compiler found return first result as best fit for now.

  
}	


sub detect_assembler
 {    print 'Checking For Assembler '
   return   verify_command("which as ")    #First found compiler, or empty
}
	#Detect ar 

sub detect_archiver{

    verify_command ("which ar");  
    
    
   return 
    'arch'  # First Compiler Found.

}




# ------------------- 3. Config Compiler Flags.--------------------  Basic for the now, can add per compiler

 sub configure_flags {

  my ( $compiler ) = @_ ;	
 #  return ( "CFLAGS= -O2" . "$ENV{CFLAGS}") 
    return ""

} 



#--------------------------------------  4: system-Header ----------------------- 
# This section detects if required libraries/includes for project is accessible or missing
 sub system_detect

  { 
     print 'Detect system header and files.  '
   

    
    return;

  }     
    #--------- 5: utility Detect --------------------------



sub verify_and_detect {  
  my ( $utility, @variants ) = @_ ; #utility should exist, if does return, variant can vary 
 # Verify utility exist in current enviro. if does return, and set variant 
	  if   verify_command  ('which $utility') { # If does exists. set the desired variant,
		
  		# if(! exists  variants [0 ]   ){ 4 return null. }   #If null variant
			return
        $variants[0];	

 	 } # if doesnt return the next
 
}   



 #-----------  Filesystem & Directory-------------------------- 6



#-----------    8   Rebuild,Clean   -------------------------



#----------------------- 9  : Tests Validation  -------------



#-----------10 -  Packing / Deploy -----------



#---------------------11   Diagnostics------------------


  

#--------   Contin Integration   ---------



#------------     SECURITY CHECKS -----------13


#---------------  Interactive interface  -------------

#------------------- LOG /  SUM  ----------------------- 

#------- Cross  compile -------------



#------------RollBack and  Rec------------------
	
  



 #Main script body -  Start. (Run all set operations and diagnostics here, or in the CLI. Can have interactive prompts to run the process, with rollback etc.)

init();


print  Term::ANSIColor::color( "blue ",  'BOLD'  );	  

say "System Initializing." , " OS:" , "$currentOS",
  ' architecture:' , architecture()
    ;	

say	 'Detectors running'
	
    	 
   

#print   configure_flags ('GCC' );  

	  print  Term::ANSIColor::color ( "white  ", "Normal");



  1;  #End the perl script
