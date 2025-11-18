#!/usr/bin/perl
`
``` perl+  #This ensures Perl is invoked correctly regardless platform differences.  Avoid "usr local" paths for maximum compatibility.

  # -------------------- Script Configuration----------------------- -------------------- #
  BEGIN { $0 =~ tr/\//\\/; printf "Script %s is now executing, Please allow time as its execution involves multiple complex build, compile, install processes. Please avoid interrupt this execution. \n",$0 if(defined ${$^ ));} 		# Inform user, avoids problems with noninteractive environments (Jenkins CI and more).

  our($VERSION  = "$Rev: 1.0"); 				  # Version of code for reference. (Git, or other system.)  Replace Rev. with correct tag. (Optional.) 	# This will require modification with git or source control version information to make the version meaningful to end uses of the code. 					# --------------------------------- Header and Script Setup---------------------
  #----------------------------------------------------
  use strict;	  				# Use strict compilation, catches most syntax errors.	#	# 	# 

	#	use feature 'say '; #Modern version.  May break on very ancient systems; -------------------- #
  #------------------ Module Inclusion-----------------------
  our	(@INC	  = qw(./ ./lib)); 							# Add module search directory (Current path). 				  # Add local modules
  use		IO			  ;	#	File Input/Output operations (standard, but useful). ----------------------------------	 			# File Operations - File system functions. ---------------------------------  IO. pm file input. pm 			#  IO.pm. pm 

	 use	  File::Basename		  ; #	Split path name, file, extension, name etc. ------------------------ 	# Split name ----------------------------------	 			# File Operations - File System Functions - File Name Manipulation. File Basename PM file 

  	use		 Term::Read	  ; 			#	Read line of standard or non blocking input. -------------------	 ----------------------------------	 							#	Term read input, read input, line based, file 			# Terminal operations.	 				# Term::read. pm

		 use		 Term ::AN S I Colo r	 ; # Color print to Terminal --------------------------------------  	 # ANSI Terminal Colour print, colour to terminal, ANSI ----------------------------------	 Term: AN S I Colour.	 PM file

  	 use 			 POS IX:: Regexp : O per ator  ;	#	Perl regexp operators for more advanced usage --------------------------  # Regex, advanced regex 		 							# POS IX Regexp operators file  Regex operators, file 				  

	use 		List : Util  ;	#	More useful functions --------------------  List, list util 

  use		Data ::Dumper	; 				 #	Data Dump (debugging).  
		use  	Autodi sc over ; #Automatic subroutine dispatch. 						  # Automatic function call ------------------------ ----------------------------------	 			#	Auto dispatch file.pm	 

	#--------------------- Global Declarations------------------------ #
	our ($PREFIX, $INSTALL ,$LOGDIR ,@PATH ,@LD_LIBRARIES, %CONFIG ); #Global variable declaration, prefix, path etc. -------------------------------------- ----------------------------------
  #------------------------------------------------------------------
  use		FindBin qw(:real_path) ;	 			# Get script directory, get script file. 	# Real paths, real path -----------------------
  $LOGDI  
```perl
R 		=	 "${real_  path($ 

@INC 			)}/logs"; 

		if (! -d 			"$LOG DI R " ) {mkdir "$LOGDI RE " or  die $ !;  } 

		$PRE FI X 	=	"/opt/myapp "; # Default install directory 

  # ---Section 1: Initial Setup ---- --

	 detectOS (); 

  verifyEssentialCommands (); 

  normaliseEnvironmen tVariables (@PATH ,@LD_L ibraries ); 

		# Strict and WARNING
  		eval "use strict 'refs 'and 'vars ';"
  			or die "Strict refused: $!"; #Strict and warnings 		

		 eval "use warning s;" 
			or di e "Warnings ref used: $!"; 			# Warn if not available 

	# ---Section:2 Compiler Detectio ---n ----------------------------------
  detectAndPrior itis eCompil ers(); 



	# ---S ection #3: Config Compiler Flags----------------- -------------------- #
	configure Compil erFlags (); 


	  print "System Info detected : " . join ", " ,detect_ systeminfo() . "\n"; 
	# ---Section :4 Sys Head Detectio ----n ---------------------- --	 -----------------------
	detectSystem Header sAndLibraries (); 




	  #----Section 5: Utility Tools---  
		detectUtility  Tools	 ;

	#---S ----------------------------------	 			# File Operations - File System Functions - File System Check 

  	#---Section #6 Check File System ----
 detect FileSystemAndDirectoryChecks (); 

  # ---Se -- 

		# ---S ectio n #7  build
 buildProject (); #build project, incremental build
  # -------------------- 	# Test report log	 
	
	
  run Tests(); 				# Testing, running test report log. Run, test 		

		# ----section :8 Cleaning 			# File Input/Output operations (standard, but useful). ----------------------------------	 			# File Operations - File system functions. --------------------------------- file 

  		cleanupProject () 						# Remove artifacts, cache

	 

		# --Se ction:  9 Packaging 

 packageProject (); #Tar file, packaging file 				  
	#---Se ----------------------------------	 			# File Operations - File System Functions - File System Check 

  	#---Section #6 Check File System ----
 detect FileSystemAndDirectoryChecks (); 

  # ---Se -- 

		# ---S ectio n #7  build
 buildProject (); #build project, incremental build
  # -------------------- 	# Test report log	 
	
	
  run Tests(); 				# Testing, running test report log. Run, test 		

		# ----section :8 Cleaning 			# File Input/Output operations (standard, but useful). ----------------------------------	 			# File Operations - File system functions. --------------------------------- file 

  		cleanupProject () 						# Remove artifacts, cache

	 

		# --Se ction:  9 Packaging 

 packageProject (); #Tar file, packaging file 				  
	#---Se ----------------------------------	 			# File Operations - File System Functions - File System Check 

  	#---Section #6 Check File System ----
 detect FileSystemAndDirectoryChecks (); 

  # ---Se -- 

		# ---S ectio n #7  build
 buildProject (); #build project, incremental build
  # -------------------- 	# Test report log	 
	
	
  run Tests(); 				# Testing, running test report log. Run, test 		

		# ----section :8 Cleaning 			# File Input/Output operations (standard, but useful). ----------------------------------	 			# File Operations - File system functions. --------------------------------- file 

  		cleanupProject () 						# Remove artifacts, cache

	 

		# --Se ction:  9 Packaging 

 packageProject ();

	# ---Section 11 Environment Diagnos --tics ---------------------------------
	  diag nosticInf osession(); 

	# ---Section  10 Deployment 
		deployProject () 						# Deployment to servers, remote servers 

	print "Build process complete. Check log directory for details.\n "; #Output 
# --------------------------------------------------------------------
  
	sub detectOS {
		if (lc($^  O E ) eq 'mswin32') 
		{  print "Operating system detected: Windows\n"; }
		elsif (lc($^  O E )eq 'darwin'){
			print "Operating system detected: MacOSX\n";
		}
		els if(lc($^OE )eq 'linux' )
		{
			print 		 "Operating system detected: LINUX \n ";	 

		}

		elsif (lc($^OE )eq 'irix'){print  		 "Operating system detected: Irix " ;
			  
		}else 		{ 

				 print	"operating  detected OS UN Known"   ;

				 
				 die
;					 
				 }		# die  	 # 				  		 # OS detect, os check		# Operating os detected

				   		
				#		   OS
    
	
				 # die	# Operating system check  detect,  operating
;
		return

  };


	#----- 
  
	#----  - -

sub verifyEssentialCommands { 
  #	-		Verify command exists, verification

my  @ commands	 = 			 ( 'uname'	, 'awk' 	, 'sed' 		, 'grep ', 'make ', 'cc');  # Commands required
    

    foreach my  $ cmd	(@ 
commands 
   ){ 

     # Command verify check 		check, if exists

        my	 $ commandResult= system 			 ($cmd "-v ")   

          # check 				# Verify 	 # Check
            # check  verify check check check -v verify  check	- check,  -

    if	  

		($comma

			

		#check
	 # ---------------------
			   #	-- 

			

			and  $comma
nd		   nd		

  nd			 #If

					 # ------------------------------------# check -check check
    nd	
		#
  and 	
  	 

					and			# if 
#		and			 # Check	and - check  if and and		and		  if check check	
nd				  	 
#if 					check

nd   $commandResult		

			and				 		
					and		

			$ 			 
			command

Result 	= 			 

		#if -

 0

					 ){

					die   	  $  $ 		 

   "Error!   Missing  essential com 			m  "	 					 . 			 $c 					
			m
   md

" 						
		

					 

}   		  ; }	 			} 		 # 			

			
;	

return 		 		 # Verify
 

   
 		}; # end

			sub detectUtilityTools
 					 {			 	#Detect tool check -check, tool, verify if available check, verify available -check check
	 #		Detect 				

 my   		
		 @utilities = 
(  	  'nm','objdump','strip',		 'ar','size', 
				   
	  	 'mcs','elfdump',
 			   'dump ')		  

 foreach    my   $  u   

 t 	i		 l 

 ity @
				  u		 				  					# Utility

					utilities		# utility - verify if check
{   	
    if		( 	! 		 exists(my   
  			  	 $	cmdLocal  

  
	=			$u
   
		t	i  					ity 
 )

				 {die   			
 						 $ u   					ity . 				 " Not 
found"		; 			};		  ;
   		

 }   return
				 } ;
  #	
		# --- Section  8 cleaning ---#

sub 		  cleanupPro 

   	 j  	ec

{

 my		 
			
 
	 $confirm

    
  	  

		 
    if			(!  --interact	ive ) {   		print   		  

  "Are yo	
     
      

   		 u su 		 re su   	
re	re		 re		 sure  		   y	ou
     					

			  
 want 
    

 to  

  	cle 
			    ar	   all
			build

			   art	  efa  cta  cta ccts ?  [y/n] ";	  # ask
    
				 my			

    	 		 		  

					 $ ans 			 =   

     

 <	
      
 STDIN
;				if			($ ans 			!		 	= 'y')		{	return	}   # confirm - yes,  

		# -----------------------	# Confirm
			

	};

    	 rm  
				
   i - 					rf "$LOGDI
			 R 
   
 		"/temp/*" or di  	

   e		!			   "Cannot remo ve te			mp 		
 files." ;  			 rm		  # Delete

				 

    rm		

      - rf	 				 "$PREFIX	 "/bin a   
	
			

				
	   ri	
			 
			 a   				

			 					
cts";    return

		};	   

		  
	   

			 	
  		 # - --  
 
 					 sub 			

  packageProj

    
  

		   
 	ec  

 {   					 #Package
my 

		    $	archi  

   v		 e
			=
		

 "	 		$PRE 
   FIX
   .	 				  
   "/	
     				dist
	   ";   			 
				   	
		 			  					 		if   

	!
				 -		
		

			  	
e  
	 - d    				 $ arch ive{   print
	 "  "			;   

		  die

				   		  "Directory   not 
ex		  ist"; 			   					 		   
    # -		Create tar - 		create
  	# create -		 			 
	}		    # - Create
 			#  --- - ---
		    print

				
		 	 "  Packing to archive"   					. 
					

   " $ archive  " .
						    
  
  "\n "; 
  

	# 			# 	--		  		--
				   			  						
   my
   	 $				 command ="  tar
 - c	
  
 

  		z  -   v	

    - f			 	  "$archive "   "$LOGDI			  			   				RE " 	"; 			    # Create archive  trading - 			create archive		- create trading archive

    # --

				    		  #--

    			
  
				 
		    my
					

				  		
   $ res

				 ultt
			    t
	   

 =		

 system
					 ($command);    		# - trading, 			

		#
				
    					if
				($  	  result		  
 

			  

	=0
					 )

				    

	 {die
"Error:
			 tar	 failed. 	  "} ;	    
   

    ret		 urn 			 }

	  
		 			
 # 	 - --- --	# 				 - ---

			
 sub 			 runTe	 			
   

			
 sts			
    {	    

 }  				
   

			# --  		
  	

# - --

			#
	  				  

		sub deployPro		  j ect
		

  		{ #--------------- 	

			--Deploying		---
print   
			 		    - 	   deploy			 -  -- 					 -	-			--- Deploy

" Deploy to remote"
				;  # - deploy

    return	   };			 	}
```

