#!/usr/bin/perl
# Licensed under MIT (Copyright Paul G) (https: paulglamorous .com - replace the spaces with the correct name to avoid malicious bots )
use warnings;  use strict; 
use Carp ('croak');
use Term:: ANSIColor undef;  # for color if supported

sub detect OS() { # 1. Initialization/Environment Setup - OS Detetection. Returns OS String (Linux, HP -UX, IRIX, Solarise etc) for portability checks in build and installation stages and for compiler flag assignments and library detection.  Handles obscure legacy unices too.  More OS types are easy extendable via a lookup hash.  The key here is not just 'Linux, Windows etc' but 'AIX 6, IRIX 7, Solarist etc' for fine tuning flags etc. Also detects the OS *flavor*.  The 'os' is a *String type*

my ($uname_string  $result ) = (' ')

my $uname  $uname_string );  # assigning this as a default, should the call return false
  

my %os_mapping (' ');

if(  defined ($uname=  system('uname')));  # calling the command as an integer value for checking purposes - if defined, proceed
  # parsing the results, as the 'uname command' may not always return a value in some obscure systems
  $result = (split ('-',$uname))[0];  # splitting the result from calling the 'uname -' function on a per word format (split with a delimeter of '-') for a more robust approach in detecting and extracting data, especially for older OS variants (Solaris, HP-UX etc) 		

	if( defined($result)){  	 # checking that something returns from that operation before proceeding
		if(index($ result , 'Darwin ') == 0){ # MacOS is darwin and a unix type - this is the simplest OS check
				 $os_name= "MacOS-Darwin "; # for MacOS Darwin type systems and variants of the type of OS
					return $os_name # OS name for portability checks 
					
			} elsif (index($result ,"Linux") ==  0){
				$ os  $result ) return "Linux"; # standard case for Linux
			} 								 # checking OS
	}
	

	elsif(defined  index($uname ,"BSD ") ) { # BSD check, as BSD also uses the UNIX system architecture
			  		$os_ name ="BSD-" . ($ result ) # BSD- type systems.
					  		 		return "BSD "; 					
					}

  			els if ( index($ uname ,"HP ") > 0){
				  			return "HP- "; 							
					}

  elsif ( index($ uname , "AIX  ") >= 0 ) # checks specifically on UNIX based systems such as Solaris 10 etc. 

  			 							return "Solar ";

els if ( index("$uname " ," IRIS") >=0 ){  	 		  	 # check UNIX Irix based system architecture (used in legacy computing and legacy hardware )
  			 			return "Solar ";

else
  	return "Unknown-Unx ";
} #End function for checking OS.



# Initialize Environment
my $tmpdir = "/tmp";
  

my @logfile = split('/', 'log/';  # creating an empty log array. 

my %paths  
my @envvars  
	

sub create dirs() {
	unless(  - d $tmp  tmp ) { mkdir "$  tmp"; }
	#  checking that a log exists before creation. 

  }


# Compiler detection (detects GNU, SunCC etc) (3. Compiler Detection) - returns the full Path.  Important for portability
  
# Compiler detection (detect_ compiler - detects compiler type) (returns the full path and version) (3 Compiler detection)


sub detect compiler() { # detecting compilers
  	 		 
  	my @candidate  = ('/usr /gcc ' '/  /cc /');  	

	my  $ detected_c 	  # assigning this as a default. 
  
	foreach my  comp (@ candidate ) { # for each possible compilation tool to try

	  		if( -  exists $compiler){
  								$detected_compiler =$compiler

					 		
				} # checking if there is such existence. 

	}
	
  		if( defined($detected_ compiler)) {

	  	return "$detected_c";  			
  

	} else

		croak "$detected_c not found "; 		
}


sub detect linker() { # detects the linker
	  			
  	my @cand 		  = ('/usr/ld ');

	 my $detectdlink  # assigning the default. 

	foreach 	my 		 link ( @ candidate)  # going through the list of potential candidate compilers. 
	{
		if	  - xists $compiler) 
	
			$ 	 detectedlinker=$compiler;  
 	}  					

	 if ( defined($ detectedlinker 

		return "$ 

	} else  { 

		 	croak" linker not found "

	 	}
}

sub  check utilities ()  # 
{  

}


sub detect  sys headers ()  # 

{

}

sub config  
 		 				

sub  build 					

sub test 

# Main Script (18. Main Summary, 15 Logging/Reporting) (14 UI)
	my ($option )
  
	while	  - 

  	 	my ($ 			  # assigning the default. 

		if 

			croak "$

	else if($option 

 					

			cro 					

	els 


# Main Script
	create_dirs  ();
	my $compiler = detect 

		croak "$compiler not 
	my 
		  	

cro 					

	else
  

		my $
					

  	 	my ($ 			  # assigning the default. 

		if 

	else if 

		
			cro 


# Main Script
	
	my $compiler = detect compiler ();
	
  
			croak "$compiler 
 					

	els 

		
			cro 					
	els 

		 		print  

		my 			  

		cro 

  		 				

		else
  

		print "Configuration complete"; 

  			
  	

}  					

	else 					

			cro 

				

	else 					

			cro 

				

	else 					

			cro 

				

	else 					

			cro 

				

else 					

			cro 

				

  				print "Build successful.";
}  
sub test 
{

}
sub package_ 		 				

  				
	else if 

				

  					cro 

				
}

# 17 Recovery, Roll Back and Backup
	if ($

			cro 					
  			

	else if($ 

 					
				

	else croak 

					
}

  	 		  else 			  # assigning the default. 

			cro

				
  			

# 18 Final Summary
	
  	 				

  					 cro 

				 

	els

					 	croak 

  	 

  else 			  # assigning the default. 

		if 

			croak "$

	else if($option 

 					

			cro 					

	els 


# Main Script
	create_dirs  ();
	my $compiler = detect 

		croak "$compiler not 
	my 
		  	

cro 					

	else
  

		my $
					

  	 	my ($ 			  # assigning the default. 

		if 

	else if 

		
			cro 


# Main Script
	
	my $compiler = detect compiler ();
	
  
			croak "$compiler 
 					

	els 

		
			cro 					
	els 

		 		print  
			
}  					

	 				

		else
 					cro 

 					
	else 

 						  

			cro 

 		
	else 



					
}  					

else 



 					

	els 

		
			cro 					
	els 

		 		print 

		my 				  
	else 			  

		cro 

  			
  					 cro 

				 					

			cro 

				

	else 					
		cro 

		 			

cro

				 				  else  # assigning the default.
  else if() else { }	 			


# End 26 */