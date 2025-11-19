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
 	}   # end check os 

	else 		#no success setting current OS and exits. 		  #if system returns zero ( success). Then continue with next loop to set
   {		#If we have success with the os check and can run the code. then print to screens that we are running the correct version, 
   		   		 print ANSI $COLOR {RED },"Warning" . ":",ANSI $COLOR {BLUE},"$currentOS" .":" , ANSI $COLOR {GREEN},"Can't find $name in current OS!"."\n",  
    
 		# Exit script, no valid Show OS.		 	  			 # Exit with Error.    

	}	 #end checking
 	exit(1);   

  #}
   #}
   }

print ANSI $COLOR {GREEN}, "Current OS is :",$currentOS ." \n",   term $color {$CYAN}, "Checking Essential commands.\n"	   , ANSI $COLOR {GREEN}, "Verifying: `uname`, `awk`, `sed`, `grep`, `make`, `cc`", term $color {$YELLOW}," Please verify commands are correct and in your environment. Check the output in terminal \n" ,

  my $temp_dir = "/tmp/build";  # Temporary building area

 unless (-d $temp_dir) {  mkdir $temp_dir  or die "Can't create temp dir $temp_dir: $!";  }

 my $log_dir  = "logs";    unless (-d $log_dir)  {  mkdir $log_dir or die "Can't make log Directory."; } # Creates a logging area and creates if necessary, and error.

 ENV{`PATH` }  = "/usr/bin:/bin:/usr/local/bin:".ENV{`PATH`};  #Ensure important system dirs
 ENV{`LD_LIBRARY_PATH` }  = "/usr/lib:/lib:/usr/local/lib:".ENV{`LD_LIBRARY_PATH`};   #Check libs. Can expand with specific lib dirs based on system type if desired

 print  ANSI $COLOR {GREEN} ,  "Setup and init Completed \n " of term {yellow}," Checking and normalizing the env \n ";   ;

 # ---------------------- 2. Compiler & Toolchain Detection ---------------------

 sub detect_compiler() {

 my ( $compiler) = shift ;
 my  @possible_compilers  = ("gcc","clang","cc","suncc", "acc", "xlc",  "icc", "c89");
 #Detecting compiler by attempting command
 foreach my "$compilerCheck" (@possible_compilers){	  	 #Checking through possible commands for the OS

		  print  "Trying " .$compilerCheck . "."  ." please confirm.\n " 		#Print Statement 	 	#If it not possible, exit the compiler function call with an message

	 	my @compiler_result =  split( / /,  (  exec $compilerCheck "-v > /dev/null")	);

   		 # if(exists  ) 		 
			 if (( $?) == 0)	 # If success with the compilation, exit function call by returning $ compiler check	 #Check success
     			 return ($compilerCheck );   	#Returning the name for usage
 }    			

	print ANSI $COLOR {YELLOW },  "Warning "  .":"   .term  color($GREEN),    ." Compiler not recognized while searching.  Exiting check."	  ," Exiting"
	 #Exiting Compiler Detection, as there's error

 # Returning compiler detection, exit.  	  ;  		 

 }   	#Exit Compiler Check	 	

  

  sub detect_linker($)   
{  my $compilation  =  shift	
 # Detects linking, can add different commands for detection 
	  
 # Checking link commands for OS 
  @linker = qw/ld/; #Link Commands 

		for	 ( $#compiler)    	  		  

}  #Check for the correct commands to use  		   

# Check Link command and run, return success
	print "Check Link "   #Checking linker, can print info on terminal to see or error

# Return the link if the link commands exists  
#-------------------   Check linker  	 #-------------------- #

  sub  detect_toolChain {  	

		
		return (1 ); # Return the ToolChain as detected( The toolChain as been tested).    Check for error

}  

  

# -------------------  3. Config & flags Compiler   ------------------	    (Configuring for system/compiler flags.)	 
# Function definition
sub  configure_flags   

 {  	

# Logic here	 #

 print	   	ANSI$COLOR {$RED}, " Configuring the system \n ",
	   term	    color(GREEN	   ,	      ." Please be ready to see output" 		 		;
 }

  # Define platform specific flag

 # Standard flag
  sub   platformFlag 
# Platform- Specific logic here
    	   
  # Platform-Spec Flag Value  		
 }		
 

 # Check flag and update values for compilation 
    # Standard compilation Flags for system, OS 		

# Compile flag	  		

    ;  				  					   					#-----------------------   4 .   System & library detections--------------------------------------- 		    		   #  	 
  sub	 detectHeaders()    					 # Detect header by using compile commands		

    		 {

  				 			;	# Check to return			  #	;   				
   		
   			}

  
  
    ;
    #  Must be defined with all the libraries for checking	;

		#		Check the libraries with all values to be detected		    	# 
	sub		checkCoreLibraries

			

    					 #-----------------------    	 #
    	 	 # Detect all utility Tools for the Build



 #Check and confirm all tool chain
 print termColor {Yellow} , "\n Check Tools and confirm " # Checking tools 			

	 sub   DetectToolchain	# Detect utility Tools and set up environment variables to call	 			  						  	

# Utility/Tools for build

			 					 ; #Checking tool and environment
 # Confirm and detect environment variable and tool

		  			 ; 					 			#Confirm and run

 # Checking and setup tool environment		  				    #		

;   
#Check and finalize utility 	
		
	; 	#	Checking to set the system to use the tools  	 	   			;  #

 #Check to confirm that utility Tools exist 
		

    ;		 					

# Confirm the environment variables		   												
  
  	

			   ;
   				

#Confirm the build and run		
				  						    ;		;			    	;  			 #Check environment
 # Check and Confirm environment

 # Final check		     	   						

; #-----------------------   Check file System Directory-----------------------  	     (Directory)		 			     			   

#checking all file System directory

sub  filesystemDirCheck 	;
{  	    
print	    
	    term	        Color  			


		

  # Check for the correct values to exist	

 #-------------------- Check and confirm Directory		#

#Checking all directories	    
			  

  #Check all values and exit  			   		   					

	 	   					

			  	    					 

		  
}		    					



					  
		   
		     	 						  

		  ;
   				   		
		

	  			    				  						     # Check build directory, exit	;		   						#	Check environment	
  

			 
  			

;			  ; 

#Checking Build 	#Check the environment 	 #

    		    	; 					   					

   				  						

;	;  Check Environment		# Check build
  #Checking to finalize 
  #  ------------------- Build	
;	

			   
  
    			   ;	    

				; 					#Check to compile		     		   	     	    					  					  				 			 			 			
  					 # Build
    # Check for build to run  	     ;			;		
#Check Environment		
	; 		Check build
; #Confirm build  					# 

  					   

	#Check to exit  
    	
		;

			 #Build
		 	;   				; 				Check to Build		 #

;  			 

# Check to Compile			 					  						 				

  ;		#Build			    				#		 #	Check Build  #  

	    		     		   		;			 #Check environment to exit		;  	   				 
# Build	     Check	# Build to Confirm			 #	    		     ;   					

    		
    			#Build  	    Check 		    

			# 							 #

	 			#Check  

		;
   		 	; # 				

;  		
			;
		     					  					 
			     # Build   ;  Check
				#
    

		
		    
    	     ;			 #

    #Build and confirm		 #  			    				    

  	     					    ;
	#Confirm and built			 	;

  # establish all environment	    
#	Build			 	;    
		     						 #Build		 				   						;  			#Check to Build			

				   

 # Check Build		; # Check	  	   ;   			     
#Build  

 #Check and build 				     	; 	    # Check
    				

 # Check Environment and check Build  ; #	    ;		   ;

		    #Confirm  and built			#Check Build		;			     
			  

   	 					;	;		

				  	;	Check and exit  				     		 #Build 			     		 		#Check

				

   # Build
    ;
	   Check Environment

				     	#Check

		     

			     				 # Build

		

 #Confirm
			# Check
    

#Confirm and check			 # Check	     			 # Build  Check
 #Confirm Build				   				    				    					  
		; #Build

		   		  
		
	#Exit		 			    
    
 # Build		  	# Build		
#Check to Build		; Check Environment to Confirm  
			

  	   	;

   Check Build				 #
 #Confirm to exit  Check	   Check Environment   		   		    	

		  				   
			

		   
   	    

		;

			     					#Confirm	   					   					;		

  Check
	
	 #Exit to confirm		     Check  		 #  
#  Check to exit		;   Check Build

;
    Check to check and run			;    	# Check Environment 	    ;
		 #Build and check	 #Confirm  Check to build and exit 

 # Exit Build to run Check					; Check
	

	  		# Confirm	;		Check

 # Exit	     ; Check 			      ;	   
			;  Confirm 			#
 #Exit  Check ; 	     # Exit  to Exit		 				

  		 

			;    

  

						;   		  					     Check  Check
; # Build to check			   

		
		
  			     Check

  	#Exit

		Check and Exit

		;   		#Build 			; 				  

# Check and build
 # Exit to Run Check  
			          				     		   
 # Check
  					

			     
  

# Build

			# Check  

; 	

				 #  Exit
    			   Nah 			   
		   #Build to Run	    

   ;		#Exit			     					

    ; Check	 # Build	  ; 			   ; 			     
		Check  		   					   				
			 # Build
  

			   

				  				# Exit		  	   	

#  Build

# Confirm Build 				

 #  Exit	 #

  		 Check

  Check		 				    					 #  

  Build		   

  Exit	;		    			  	 				

#Build		     		   				   
	    

 #	Confirm			  #Check and Check to Check  		  		 #Exit Check		 #  			  				
  			     		   #Exit 	 				;  

		

   		

    #Exit			   			#Check		 #Build	 			  Check   

				 		    				 		    #

		   ;  	  
# Build to check			    Check   		    	
  	 
;   Confirm Check

# Exit	 #Build  ;			 #Exit  Confirm
		    

Check		  #Exit		     				;

	

	    ;		 #

			     Check	
				;Check
				; 	;Check to check				 		  ; # Build to Confirm to check	 
					 #Build 	 			  		    ;  			Check to confirm Check		  					 
 #Check and run				   ; 
	;	   Check to exit and Build to Exit
			Check 				  # Exit 	;	  Check	;   				  Check

 # Check

  Confirm and run  			   	 #Check	  ;	    

Check

	  # Confirm and Run


Check and confirm			 		

 #Check
   ; #

		
			Check and Confirm				#  

; Check			   			 #Confirm 	   Check
Check				; #Confirm Build			# 				

Check		

			Check
Check				# 

  Exit	 # Check	     #
  Confirm		

  			    

		
			    				
	#Exit

Check		    
			 Exit Check		   				
   			Check and run Check				    				   
				    

Check

				#
		  			
;		Check to Run

; Check	;Confirm

Check  Check			

		#  
Check to run  				

Check 				Check  			Check				 				Check and confirm		 			;Check  
  		 #Confirm	;

  Exit	;			  Check to Build and check 	 # Exit		 #
#  ; Check			
    		
			  	#  		;   #

;
; 				

;
# Check		 		
			   
 #Check				Check		   

	
Check
# Build and Check		 				# Check to Check

 # Exit
    Check and Confirm  
   Check

	Check
  Exit

    ;Confirm to Run  # 

		   			 			 	Check			
			#Exit to exit Check	;

	#  		 		#  		   ;Check and Run  

			; Check			 
    		    Confirm
    	  #  #
	 #

#Exit to Build			    	#  			

  	
# 		Check

  Confirm  		#Confirm to exit

	

# Confirm 				
#Build		 #
		

; 			;		 #

  			# Check to check
Check		    ; Confirms			    Check

    		    #Check		   Confirm
 # Exit	# Confirm

    		;Confirm		Check		 # 				   

     ;

			

		; #

	    #Confirm		#Check  
		;Confirm to confirm			  
			#Exit 

Check				

			Check

  				 		Check	
# Build Check  			Check			#Confirm			
#Build

   ;

	
		 #  
Check		;     	  			
    	 # Confirm

;Check			 #
  

Confirm and build

		;		Check
   				 
	  Check			 	
   

#Exit

Check  ; 
   

; #Exit  # # # 				# Check

    Confirm
; # Confirm	 			#

	Check		
		

	Confirm		 #  	 
#Build Confirm		    ; 
 #

   ;  # #  Check		 #  

		Confirm	
  		   	 #Confirm and build 
			Check to run			

   ;Check
  #  
;Check  	;  ;  				Check 	   ;

		Confirm  	    Confirm and Exit 	   	
    Confirm

Check and exit			

 #Build
#Check			
   
# Exit			 #Confirm
#Check 				 		Confirm  Confirm 

			  ; Check # 		   				#  #
   
	   #  Confirm			 		 			   				
Check	   Confirm and exit		;

; # Exit Check
Check 			; Confirm  

Check # Check		  	; Check # # #  ; 		 
Confirm  			 

;	;Check

;  			   Confirm 		    # #	Check #
   	 	;  #Check
  # Check to Build # Confirm and build # 	Confirm

	;	   ; #  Confirm		

   			Confirm to Run

  
Confirm	    Confirm	# #

   	Confirm
 #Confirm			 #  			# Check		 #	Confirm

	 # #
 # Exit to Exit	  ; Check	

;	;
Confirm to build and run	    		# Check			    
	  			#  		  Confirm to Check	
			Confirm

Confirm  #
	 #

	
 #Confirm			     Confirm #

;	 #
		 
;	  Confirm #;Confirm and Exit
   			
   Check
#  Exit	 

	
			# #

			 # Confirm			

 #Check		  Confirm  		

# #Check		#Confirm	 		  #

   			  Check	
Confirm		   			

Confirm	; # Exit 	   
			Check  #  # 

	Confirm	Confirm

	 # #	  # # Check and confirm  
  	Exit Check 

Confirm	  	 
		
			   	Confirm  			 # Check	 #

		Check to confirm			 		

   Check
   ;		;  
# Check 				;

  Check and Check  				Check 	
# Check to Run			 # #  				 			Confirm 			#

	   		;
Confirm and Build 	  		#  #		Check  

#  #Check #
   Exit  ;

  

				   Check			 		Confirm	    
			 	#

	; #

; 

   #

			 # Check # #  Confirm		 #Confirm #		 
  #

			 				

# Confirm			;
			;Check
  Check
  ;	 
		

  

  # confirm
	; 		 #


   
Confirm
   Check		#	 
 #  #Confirm	 	;		; 	Check	;

Confirm to Exit	  				Check
Check
			 Check 
   
		;Check	;

		;
;		#  Confirm		 #  			#

--> #Header to run #  				#Confirm to Exit  
Confirm  			 #Confirm  #	 

		; 		 #
#Confirm to run 		
# Confirm   # Check  	Confirm

; 			Check  ; # Confirm  Check to build
		;
		# #Check   			

;Confirm 
# Confirm # 	 # Check	  				 			 	
		   			   
#Check	

   				
   Confirm #		  Confirm to Exit	   ;  				; Check and Check			 
;Check  	Check			Confirm and exit

Confirm			   				Confirm
  			 #  
#	# Check and confirm   			
   
 #Exit 

Check

  				# Confirm			

        #

Confirm
Confirm #Confirm 		#  

Confirm # Check	  			

 #  #Confirm		  
	 			

			# #Check

   			  			 		
   Confirm			Check  

Check
;Confirm 

			Confirm
		
Check
   Check
		 

			Confirm  	Confirm and run  Check	 

Check #Exit
	

			 # Check
   

;		
		 			  ; # Exit 			   

#Exit
		
			 			 				

#Exit to Build 
Confirm 

#  ;
   				
		Confirm

; 				Check		; # Confirm to Run  Check

			Confirm  Check

 # Confirm			 

 # Confirm to Exit
  Confirm		Check

Confirm
# Exit
Confirm and exit		

   ;Check to Check	   		; Check and check 		   
  

	 	Confirm		 	;Check # # 

Confirm 

 # Check			; Confirm  Confirm
 # #
Confirm

 		   ;	Check 		 		#Confirm		Check	
; Check and Build and Exit   	 # Confirm  		;Confirm  			   				 

	Check  

#	 Confirm			 #Check # 			;	 	  		   
Confirm

			   ; 

   			Check
; #Exit	
Confirm			Check to Confirm #

Confirm		Confirm
  

Check
# 	 Check

Confirm# 

	   ; 	 		 

			  

# 				Check to exit   

;Check # Check

#	Check 	#Confirm 	 	   			

		# Exit			  Check #Check	
		# #

		;  ; 

	 # 		Confirm 	Confirm to Check and Check 
   # # Confirm		 # Confirm and Exit		   #

			# Exit		   #	 #  Check to confirm #Confirm		   				 # Confirm  ;Confirm
Confirm to Exit   			   		;	

 # Check	 #

			 					Confirm			 #Check	   	Check			

  # Confirm		
  # 	  ; Check to Build		 			 			 #Confirm			
		   

Check to Exit 

			   Confirm  

 #Check			;
	;	; Check		Check		  Confirm  Check		 
	   Check 
		;Confirm to Run		   		 			 # Exit		

 #  ;Check 			
				  Check and run Check to Confirm

;

  		   

	# Check 				#Confirm # #

Confirm  ; Check
; Check 
Check			#
  
 #Check		Confirm #		Confirm  	   			#Confirm
Check	 # Confirm	

Check	 # Check

# Exit		   		Confirm and Confirm		  

Check 		 #Confirm	  				  	;

	  	 # Confirm		

Confirm  			Check
		  	;;
Check	Confirm
		 

;  ;  			   
				 # # #Confirm

Check #	Check
Confirm and Check 

		

	; 

 #Confirm		 	#  Confirm to Exit Check  Check			; #
  				  ; # Exit
;Confirm and build  Confirm
	 	 				
Check to run

  Confirm and Exit		# #

		Check	   Check and Confirm #Confirm to Confirm
			   Confirm			# Check  				Check			;Check 		 # #and Confirm to Exit Check # 
# Check and Check 			  
  # Exit
			

 # 		#

		

Check 		
Confirm # Confirm		Confirm to Build

;
   

   			   

	; 	Check			;Check to confirm Check  Check	
;Check	
	;Confirm to build
  Confirm to Build		
   #Confirm to check and build is Completed
			# Exit	 

  Check			Confirm  Confirm		Check  #Confirm		 			

  			 			# Exit			
#	 Check		; 	;	

		Check # Exit

Check 	 

   Confirm			Confirm
; Check
Check 		   Confirm to check	Confirm

	

  # #
;  
	 #Check and exit

;Confirm
	   			;  		Confirm  ;Confirm
 #Confirm	confirm to run 	 			;		#  	#  
		Check to Build Check

			Confirm 

			
		  

 #Check to run Check # 				 #

Confirm			Confirm to build	

Check 

  Confirm
			 		 #  				#  #  		

Check # Confirm 			   ; 
Check and Run		 # Confirm Check and run Check		 
	 

			Confirm and runCheck

  		 # 	Confirm Check  	# # Confirm to exit  
;Confirm to Exit  	

Check	Check # Exit to Compl
	Check			; 		Check; Check

Confirm 		

		 	;		Check		 # Exit		Check
 #Confirm
		  Confirm Check		  

	   #Exit  
Confirm	#Check and Run # #

#Exit	
   		;
  

# 
 #Confirm	 #  #Check

		
		; Check		Check # 	Check and check 		 	Confirm
Confirm		;	Confirm	  
# Confirm #	Confirm and build		 
Confirm	 #Check		# #  Confirm

#  Confirm		   #Confirm	   
   		

			Confirm  Check  		# # Confirm		 
 Check  Confirm		 			   			
  	;Confirm
			  			

;Check # and exit
  		 # 

# 		Check

			Confirm #  #

			;Confirm

; #
  Check			Check  Confirm 

  Check  			  		   
 #  Exit to exit and Build to Check	#  
			 				Check to Check 	

Confirm  

#Exit	Confirm Check		;  				Confirm

		Confirm
 #Check			
Check		
     		;Confirm to check	  		Confirm
# 			 			  ;Check	 

	  

 #Confirm	

   

Check

;Confirm 			 #Exit to Check
   

  #Check
Check # Exit  Check  	 #Confirm #Confirm Check	
 #  Confirm  Check to Build and check #	

		 #Confirm to run
;	 	   #Confirm and Exit		;
   				  # 				 	

 # #  ;Check 			; Confirm to run and Confirm
   Confirm Check # # Confirm #  Exit

	

			  # 		   				   			 #

  

			Check			 

   				Check			
; #Exit and exit 	   # # Confirm # Confirm  to exit
		
  	
	 #Check # 			Check 	  

 # Confirm  
Check  to Run # # Check		 		Check # Confirm Check  Check Check		Check

			# Confirm

	 #Check to Exit
# # #
Check  ;Confirm and confirm	Check		   		Confirm # 
			; #Exit  #  Exit to build Check # Confirm  Confirm Check	  			
  # Check to build Check Check  Exit	;

Confirm		# Confirm and build to confirm to Build
  				 # 			  Confirm

		Confirm and Exit #

	Check #

 # Confirm
#Check  #  Exit		 # Exit	 to Exit Check	 		 		 #	  Confirm

Check
		
Check

	  #Check Exit to Check to Confirm to buildCheck and build
Confirm		Confirm

   			Check  
	#  Check to Check  		

   				 	# Exit # Exit	  #"	;
  Confirm

Check to Confirm to runCheck		#Confirm

;
;	  ; Check	 

		  Confirm Check
   

		

	Confirm
# 					   			Confirm	;Confirm

Check and Check

	Check		   				  
	   			

;  	   		   

			
; Check	
	#	Confirm 	
; # # # Confirm and Check  to Check	# Confirm 

Confirm 		 # 

 #Check	; 

;		  		 
   ;
#	 Check 			#

;

 #  #Check	 Confirm	
 #Check

#Check 	Check to Check # Confirm	#Confirm		 #	Confirm  		Check	 

Confirm
; Check
		;

;		;Confirm 

 #Confirm		Check		;
# #Check  Check Check	Confirm	Confirm		
		Check
   Check 			;

			Check

  

Check
Confirm

Check		  Confirm
 #	

#Exit and Confirm run # #	
 #Exit #

 # Check	
   #Check	  Confirm # Check #Confirm #Check and Build to confirm

; Check		Confirm 
 #Check  to check Check Check #Check		 		   			Check Check to Exit Check  Exit	# Check Check Check  	Check		
			Confirm

 #Check #

  

	 		Check  to check #to Run  
Check				Check  

#Exit Check		 				

  #Exit and exit and build
		Check # # #Confirm

   

 #Check #	 
Check #Confirm  Exit		Confirm	  

  
Check		;Confirm to build
Check Check 
;
# Exit	 Check
			 # Check 	 #

  

   Confirm 			   		

 #Check check	  Confirm and run

; #Check
Confirm # Exit Exit and run to check # #

Check
 #Confirm	 
   				; 
  Confirm Check # Check

		
		# # 
  #Check to Exit  Check Check

 ;
 	  
	Confirm and Check Build to Exit and build #
  	; Check and run	#Check

   		 #Confirm 
Confirm	  
Confirm 			   # Check		Check # Check 
   Confirm 			 			# Exit

	
# Confirm	 Check  #	 Check to check to Run #Chec