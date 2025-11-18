#!/usr/bin/perl
## BEGIN

package main;

use strict varsqw(); 					#Strict mode on all.
use warnings qw($WARN $DEBUG);			 #Enables various debug levels as desired.
use File::Basename 'dirname ';		 #For filename manipulations (dirname etc)

# Module Loading (Prior to environment initialization, if available on a system).
use Term::Ansicolor if (-d 'Term');  
use Term::ReadLine qw :DEFAULT term_read;  


## END ## 


#--------------------- Initialization-------------------------
sub initialize{

	print "-------------------------------------------------------- \nInitialization and Environment Scan \n ---------------------------- \n";
	$OS 	= uname() =~ s/^(.*? )?/(?=$OS )/$1 / if scalar (uname()); 					  
	$kernel = uname(); 		
	$arch  = uname()->{ arch } ;

	# Core commands verification
	@CMD  =&check_command([" uname"," awk", "sed"," grep ", "make", "cc"]);	  

	#Normalize Path variables
	$ENV{PATH} 				 = &normalize_path($ENV {PATH} );
	$ENV {LD_ LIBRARY_PATH  }=(getconf  LIBPATH) if defined(getconf("LIBPATH")); 		#Get system wide
	# Create temporary & log directory if it missing. 
	($BUILD  dir = &make_ dir("build_$RANDOM" ))
	and 
	(&mk_ path("$BUILD dir"))
	  ;

	$BUILD  = "$BUILD";

	 ($TEMP dir = &mkdir (" tmp"))  and
	(&mkdir  ( "$TEMP  " . $BUILD ));

	$logdir ="logs";
	($logdir_ exists = & mkdir ($logdir )){

	} 

}


### Core Subroutine Declarations
sub normalize_ path { 			#Normalize path variables.
	my $p =$_; 						 #Local Copy
	  # Split and remove duplicates and empty entries. 
	my	@paths  ;
	for my $path ( split (':' ,$p)){
		$paths  and push(@paths ,$ path )if (length(  $path ));
	}
	return ":";
	}

  

#-----------------------Compiler Detection-----------------------------------
  sub detect_compiler{	# Detect available compilers

	  print "-------------------------------------------------------------\n Compiler Detection & Toolchain Scan \n------------------------\ \n";		#Prints header for section
  	my	@found ;

	if (-x /usr /bin / gcc ){
		push(@found ," gcc " . `gcc -v`);
	} 

  # Check for other common compilers.
	
	
  print "Compiler found: @found";
	return @found 		#Returns an list
}

#------------------------Compiler Flag------------------------------------- 
sub config_ flags {
	
  print"--------------- Compiler flag configuration\ \n";		#Prints header for section
  

	if ($ OS = "HP- UX"){

	}
}

 
#--------- Header & Library Detection------------------
  sub detect_system_headers{ 	#Detect and handle headers.
	
	print "---------------------------------------- System Headers\n";	  #Prints section header
	  
	#Test for header file
	my	  $testprog	  =`cat >test.  c <<EOF
	#include <stdio. h>
	#include  <unistd .h>

	  EOF;
	`;
	
	  #Test compilation
  	system " cc -c test. c ; rm -f test.o";
	
	
	
	  #Return results
  	return 1;
}

#-----------------  Utility Detection----------------------
sub detect  _tool {
	
  print"------------- Utility Detection \n ";
	
	my @tools ;
	
	if (` which  nm `){
			 push(@  tools,"nm");
	}
  

	return	@ tools; 
}

#-----------File System Checks--------------------------------
sub fs  _checks {	#Valid File checks
	  print "--------File System Checks-------------\n";
	  

	if (-d  "/usr" ){
		
	} 
}

#---------- Building-----------------------------------------
sub make_project{
	 	print "--------------------- Building --------\n ";
	
	my	$target	  = shift;

	if ($ target =="clean" ){

	} else{
		system " make -j $(nproc )" #Build with parallel jobs. 
	}
}

###  Utility Sub Routines	

sub check_command{ #Test if a commands exixists. 
  	
	my $ commands	  = join  (" " ,@_);

  	  if   system "$commands -v " 

	{	 print ("ERROR no commands $ commands ")   ;	 #If a failure is return it shows a messgae

    	   	 exit(1)
    
  	 }

   	  
   		   

 }

  sub reproduce_errors{

  print	 ("An error occured. Recreating and retrying. ") ;		 #Shows to users a retry of a action.

  	 }


 sub mk_path{				  #Check and creat directory 
   my 			 $ dir		  =shift 			 #Pass path 

    
 		 unless 	( mkdir   ("$dir" ) if  (! -d"$dir") ){   		 # If no such directory creat one.  Otherwise continue 
  		 print"ERROR creating directory   "$ dir . "\n ";   

    	   	exit (1);    			 		 # If the operation return and fails the script is exiting  1
 	  	 }  	
  	 }



	 	  sub make  _ dir {	
   my	  	$prefix=shift   
   		return	   "/tmp/$prefix";   			  #Create  directory with /TMP prefix.    


	 	 }	 



  ###  Initialization and Call to Scan
    initialize;			  		# Initialize Environment
    
 #  	print detect_ compiler   	# Call Compiler to be checked and reported

 # detect_system_headers	 	 # Test header

    ### End Main Execution		#  All calls will come from Main executions and the initialization

 	###   Print the Summary

### Main script

	 print"\n";			
print"Script finished.\n"; #Shows completion to the user
 exit(0);  	 #Return to shell to confirm execution succes	 #Returns success exit

