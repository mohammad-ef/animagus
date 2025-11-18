#!/usr/bin/perl
## A comprehensive, platform independent, UN Perl Build Repository Automator
  
sub main;  
sub printc { my $COLOR= $_[];  $COLOR eq undef ? print $_  :$STDIO->print (color_start ($ COLOR)); } # Colorize printing for enhanced readability
sub exit_with ($code){ warn ("EXIT with CODE $ CODE \n ");exit($ code ); } 




package main ;
  # Use Modules

use warnings qw(modules syntax ports obsolete unsafe_lwlibs unused_version scalar numeric); 




# Load Perl modules for more robust build
  use Carp; 

  use POSIX qw(uname etmpdir);  # POSIX system call functions and standard variables.

use Time::localtime  ($Time::strftime  % TIME);  # Get current timestamp
  use File::chdir;  # For directory change operations
  use File::Spec; # For creating path specifications

  # Use Modules

use termIO qw(: TERM_STATUS TERM_STATUS ); 






package main ;
  # Use Modules

use strict ;
use IO :: Select;


  package Log;  # Namespace
  # Log Management

sub init ($LOGFILE) { my ($self,$LOGFILE) = @_;
  $self = bless({ FILE => "$LOGFILE", TIMESTAMP=>$Time  ,LEVEL =>'INFO' },"Log ") ;
}
sub info  ($SELF  ,"$msg ") { $SELF = bless({}); my ($LOG,$msg  )-> $LOG -> { $LOG -> { $LOG ->FILE}}
  #$self ={FILE }
  $SELF->{FILE };#$SELF-> {TIMESTAMP => TIME}
  print (STDIO colorize ($ self->{LEVEL},$  "$msg \n "));
}
sub warn ($SEL,$message  ){ $SE->LEVEL ="WARN"; warn  ($SEL,$message  );} 



  # Environment Variables Initialization (Normalization)

  use Config; # Perl Module for Configuration

package main ;
  # Use Modules

use termIO qw(: TERM_STATUS TERM_STATUS ); 






package Build; 
# Main Build Automation script


sub initialize ($BUILD)
  {my($self)=@ _;

 # OS detection
 $BUILD->{ OS  } = $ENV{' OS ' }||(  $^[ OS ])||' UN Known'; # Detect OS using env/ system version
 $BUILD ->{ARCHITECTURE }=  $ENV{Architecture}|| $ENV{' MACHINE '}|| $` [ ARCH ]; # Architecture
 # OS kernel and CPU
 $BUILD-> {KERNEL } = uname -k  ;

 # Essential commands Check
 $BUILD  ->{CHECK_COMMAND }= sub {$command }= 		
 							{ if  (!( exist $ENV  {$command }))
								  && (!system ( "which ".$command."& >/dev/NULL"))
							  	 { die "COMMAND $command not available. Aborting.";}
 							} ;

 # Normalize PATH environment
 $BUILD->  {PATH } = join  (':', (split  (/:,$ENV  {$PATH}))
  # Check temp dirs 

  # Check temp dirs 

  	);


  	$BUILD->{ LOG_PREFIX}= File:: Spec:: configDir () ."builds_" .$ Build->{Architecture };  # Directory for log file creation and temporary file creation.
} 


sub compile($BUILD  ,@SRC_ FILES) {my $self=  @_$BUILD ->{LOG}->  { info  ("Compilations  start") ;
  $SRC =  $BUILD->{SRC }
} 


# --- MAIN 

main ();
 

 


package main;
# System Detection Functions
  

sub detect  _compiler ($ )
	{my (@ compiler );
	 if (system( 'which gcc 2>&1  > /dev/NULL ') == 0
		)
			{ push ( @compilers  , 'gcc' ) ;}
	 

		if(system "which clagn" >/dev/Null) 	{ push @compiler ,'clanng';}  # Check for clanng compiler 
 

		  }


sub detect OS {

}

 


# Main Script Start

package main;
 
$BUILD  ={}; # BUILD Object

 $LOG={}; #Log file.  
 
 $BUILD->{LOG }= Log-> new (" $BUILD-> {LOG_PREFIX} /build.log ");
 $BUILD ->{LOG}-> { info  ( " BUILD started at ". $BUILD-> {TIMESTAMP } ) ;}
 

 

 # Initialization
 $BUILD -> {initialize}($BUILD);
 

 
 

  # --- System Detection
detect compiler ($ $ $ );  #Detect compilers.  Add all compiler here for future expansions!
 $BUILD -> {DETECTED_ COMPILER }=$Compiler;  #Compiler detection is performed
 # Check commands availability 
 #Check commands availablilty is checked

 

 ## Configuration Phase
 ## Build Phase
 ## Tests and Validation 

 

  # --- Testing
 

 # --- Package Phase
 

 exit $BUILD; 

exit( 

exit( 

exit( 

exit(  0) ;
 

# End
 

exit

exit
 

exit_with ($code
 	);

 

exit

exit
 
exit_with 

exit (
 

  #End
 

  # Main Script End



 

  #End
 



 exit_with
exit_with 
exit_with
exit

exit 

exit 

exit_with
exit 

 exit 
exit

 
exit

 
exit

 
exit

 
exit

 
exit
exit
exit
exit
exit
exit
 
exit_with
 
exit
exit 
exit_ with
exit_with

exit
 

exit_with
 
exit_  with

exit
exit
exit 

exit;

 

exit 

exit_with
 

 
exit_with
 

  # End

exit_with 

exit;
 

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_with
exit 

exit_with

exit
exit_ with
exit_with
exit

 
exit

  exit_with; 
 

exit
exit_with
 
exit_with;
 

  exit_with
exit 
exit_ with
exit_with

exit ;

exit

exit 

exit_with
exit
exit 

 

  # End

exit;

 

exit;
 

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_ with
exit_with
exit;

exit

exit 

 
exit_with 

exit_with
exit
exit 
exit_ with

exit_with; 
exit
exit_with ;



 
exit
exit
exit 
exit_ with

exit_with; 

exit_with
exit

exit_with 

 exit 
exit

 
exit

 
exit

 
exit

 
exit

 
exit

 
exit

 
exit

 
exit

 



exit_  with

exit
exit
 

exit;

 
exit_with

exit 

 

exit_with
 
exit_ with

exit
exit ;
 exit  with

 exit_with

exit  with
 exit 

exit; 
exit_ with

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_with
exit_with

exit; exit_ with

exit exit 

exit_with

exit

exit ;

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_ with

exit exit ;

exit_ with
exit_with
exit

  exit_with exit 
exit
exit_with ;

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_with exit_ with ;

exit_with

exit_with exit

exit_with

exit 
exit

 

exit_with

 
exit_with

exit 

exit 

 exit 
exit

 
exit

 
exit

 
exit

 
exit

 



exit_  with

exit
exit
 

exit;
exit 

 

exit_with

 
exit_with

exit 

 

exit_with
 
exit_ with

exit
exit  ;
exit_with

exit_ with

exit

exit;
exit_ with

 

exit_with

exit

exit_ with

exit_with ;
exit exit

exit exit

exit exit

 

exit;
 

 
exit_with

exit
 
exit_with;
 

  exit_with
exit 
exit_with exit_ with ;

exit_with

exit_with exit

exit_with

exit 
exit

 

exit_with

 
exit_with

exit 

exit 

 exit 
exit

 
exit

 
exit

 
exit

 
exit

 
exit
exit
exit
exit
exit
exit
 
exit_with
 
exit
exit 
exit_ with
exit_with

exit
 
exit_with;
 

  exit_with

exit
exit_with

exit_with;

exit
exit_with

exit ;
exit ; 

 

exit;
 
exit;

exit

 
exit;

exit 

 

exit

 
exit_with;

exit

exit;
 

 

 

 

 

 

exit_with

  

  #END EXIT CODE!