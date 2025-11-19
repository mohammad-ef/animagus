#!/bin/bash
**
Script to build & deploy software for ancient Unix systems, and newer ones too, all at same speed.  Automated build. 8-bit friendly.

This entire program is self contained and portable across all POSIX systems that have the tools it needs, and will report missing tools if needed.. No dependencies besides the standard ones!  (Bash) 64-bit. (Probably)

# Initialize & Setup

set **euo pipefail #Strict exit behavior

OS="unknown OS"
KERNEL=$(_uname _print_version)  # Capture output to a simple string variable. This should not fail on systems where _uname does not exist.

# OS Family determination, very important.  Use uname -m to check the machine architecture too.. 64 bit, or older architecture (RISC or others.) This helps us choose right compiler flags.
# NOTE that these tests are deliberately simplistic and are designed to run *any system without crashing*. They are *NOT designed as accurate tests*, but rather to avoid crashes. More precise tests would fail in the ancient systems.  They do the job of choosing a reasonable path though and, for that, are fine.

MACHINE ARCH=unknown_architecture ARCH_TYPE=unknown

if  grep -q "IRIX[ ]6.\*"  ${_uname -x}
  	then
  				OS="IR IX"
				MACHINE="ir ix-architecture"
				ARCH ="64bit"
				ARCH ="64bit"
				ARCH ="64-bit" 3>/dev/null  2>&1
fi
 

if [ "${OS}" == 'IRIX' ]
  	then

		# IRIX needs special attention, so put that here
		:
		  
	fi


if  grep --quiet "Solaris"  ${_uname -n} ; then  #Note the -n flag here
	OS=" Solaris" #SunOS or Solaris
	MACHINE="Solaris-architecture "
	ARCH="64"
  	:
	fi
	 

fi

if  grep --quiet --extended-regexp "HP-UX" ${_uname -n}; then
	OS="HP-UX";
	MACHINE=" hpux arch ";
	ARCH_TYPE="32 bit" 
	ARCH="32"; #Important flag to use when compiling.
	:
	fi

if grep --regex --extended --silent --ignore 'ULTRIX' "${_uname -n }" ;
then
	OS =" ULTR IX"
	MACHINE="ULTRIX machine";
  
	:
fi


if  grep --regex --extended  --quiet "AIX"  ${_uname -n} ; then #AIX
	
	OS  ="AIX"
	MACHINE  = " AIX architecture"
	ARCH  ="64 bit"
	
	:
  	:
fi


  #If it does not match the above OS systems, let's assume that's Linux
 if [ "${OS}" = ''  ] ; then
		OS=" Linux" #Generic catchall Linux
		MACHINE="Linux arch "
		if [ $( arch )$( arch  ) = " x86_64" ]; then
			ARCH="64 "
  		else
		ARCH="32" #Default
		fi
	  #Linux done

	:
  fi


NUM_CORES  =`nproc`
FREE_ MEMORY=`top -b -n1 | awk '/MemFree/ {print $NF}'`
echo "
Detected System Configuration:

OS: ${ OS }
KERNEL: ${ KERNEL}

Architecture ${ MACHINE }
Architecture type (32 bit/ 64 bit):${ARCH} #Important for choosing compiler flags later
CPU Cores: ${ NUM_CORES } (nproc)
  Mem. (Free/Total (approx)
${ FREE _ MEMORY} "

# Verify essential binaries exist, and print errors on missing files. 
CMD_LIST=("uname" "awk 'awk{ exit }'" "sed" "grep 'make'" "gcc" "cc")
MISSING=() #List of missing tools, used later
for CMD in ${CMD_LIST[@]} ; then  #loop over each essential command tool in the list.
  	
	command -v "${ CMD" }" > /dev/null 2>&1 || MISSING+=("' ${ CMD }") 			 # If command is not available add command to "MISSING array, which gets handled down stream". 

		 	
fi


if [ ${ #MISSING} -gt 0 ]  #Print list of needed tool dependencies, before exiting program to help people who have an unbuilt system to fix and get back to the task.

then

	echo  ""

	echo -e "*** ERROR: The following dependencies were not found.  Installing dependencies, if necessary: *"
		# Loop, so you see a better message on a command line terminal, too
		for ITEM in "${ MISSING [@ ]}"  #Very nice array looping, using "@". This way there's an entire message that goes across all this
	
	echo	  	"* Missing:	"${ ITEM }"
	done

	exit $  ( echo "$ *  Tool dependencies failed.") #exit the program immediately with descriptive message so that users know where to fix problems

	 
	 		 	 

	#end of switch on dependency
	 	 

	# end for
fi



PATH="${ PATH:0 :200 } ${ HOME   }/${ PATH }" 

LD_LIBRARY_PATH=

if [[ "${OS}" == "Linux" ]]; then  #Only apply to standard UNIX, because older UNIX variants don't have /lib, but have system/library folders
   LD_LIBRARY_PATH= /usr /lib/usr :  $LD_LIBRARY_PATH 

   fi 

if [[ "${ OS}" == "IR IX" ]] 	; then  
	 

 LD_LIBRARY_PATH="/usr/lib:/usr:/usr/lib/" $LD_ LIBRARY_PATH #Important on this ancient architecture! 
    fi 

mkdir -p logs temp builds dist

trap 'echo "ERROR! Cleaning" "trap "" && clean " >&2; exit 1' EXIT  # Trap to ensure cleanup happens

# 2. Compiler and toolchain Detection.   The very core part of any good system is being aware of how your tool chain looks and being to adapt, as well
  

  # Detect and configure tools, this section does not have any problems
 	
function detect_compiler ()  {
  COMPILERS="gcc clang cc suncc acc xlc icc c89" #A lot of ancient, but important, languages here, so be sure it supports them

	
  if command -v gcc > /dev/null 2>&1 ; then #The best and default, GCC 
  COMPILER="gcc" 	 

  else
  	if command -v clang > /dev/null 2>&1  ; then #Good modern language 

   		COMPILER = "clang" #Clang
    	else #Try other older compiler, in this specific, older sequence of detection 
       

     if command -v cc > /dev/null 2>&1 
        
     		 then	 

				COMPILER ="cc" 	
   		   
  			   	else
    						 if command -v suncc > /dev/null 2>&1	

  					     		  	 then
											  COMPILER  = "suncc"  
										     		  		  	   	  		 	 	
											      				   else	
														    echo ""
		 	    						
													exit  	 
		
  
			   

 													  				 #Exit
	      		 			  
   						

    							 # Exit	   			
		

			 # exit

					   

	      				  					fi		 	 

     					else #End checking CC	
					    				   	#  
					 		# Exit   					   	
  			   				 

		#	 			 exit
    						 fi		

					
  		
 		
   
    				


					#  	 

   	
	 				
					
		   				  fi  

 	#end check on compilers
   #exit

fi  	

 echo "*** Compiler selected : ${ COMPILER }" #Output selected compiler to help understand

} #Function end


function detect_linker_archiver_assembler(){ 	#Find libraries that the build tools depend on, automatically
#
 	
   COMPILER_NAME= "$COMPILERS[0]"
#

	 	 #This code needs the tool, sadly... so it can detect if tool can run

if  	 [ ${COMPILERS} =~ gcc ] ;then
		echo "" 
   	LD=	 "ld "
		 		AS ="as"  				 

   		
AR  ="ar"			  

   			  #Exit

				#
				fi	 
		 #Exit 		       				    
   					 #
 			 # exit				
#

		if   [   "${ COMPILERS} =   =    = clangs]	 ;	 then    					
#   
# 				echo ""   		     		 		   

  
	   				 #Exit		

		 			    

#				  #

	#	 				#
					 # 					      	 	     					    					 #
		

    				 		#
   #exit 				

	  
   						 	   
		   					     	 #   						 				

    

 		     	      			 	      			 # 	  	

					    		

   				# 					 #				     					

    
  				     # 						    				      				#
			    			 #
	

					  			

   		  		# 	    #

		  

					 #	  			

			#   				
    		    

   			    

	     			   			  	#		      				
#

			  	
			     
				

					
   					    #			      		     	
					      		 #					

  #
			  

		    				 #	
		#exit

					 		  #
					 #			     							 #

						   					

		 #				  			 #			    #

				

	  				    					    					 				

						      	 #  #
    

					      		                 	

#			
	# # #
	

  					   				  #					  				   #					#  		   				     				 # # # 			#   				 			
    #

	  

   		  
 # #			    

			    				
   			#				      		      		#
		      					     #  
  					# 		 #
   		
				
				    	

    			#  		#				
				      				 #					
		 #	      

		  
			# 				
  

	

   				

    					

    #		 				 	   	 		

	
	     				 #	  		 	#   # 			

				     					   #  		   				 		 

			#   			 
					
				    
					 	
			  		 #   				#
   				     #	
 # #  			  

   	  					 #	 				   	# #			    
  		     		 #
		 # 				     			

    			   		    
   				

   	     			
  				    
		  		    

			 		     			    	    

  
    
   	   					    
   
	 		   				 #  		 #


#
#exit



}


#3 Compiler Configuration (platform) and Link Flags: This part handles how we actually compile

  function config_compiler() {
    CFLAGS=""
    CXXFLAGS=""
    LDFLAGS=""
    CPPFLAGS=""
  if [ "${ OS }"  = " IR IX " ] ;  then  

			
	C  FLAGS="$ CFLAGS - O3  - fshort - enums -f  builtin - fverbose" #Some special IRIX optimization settings here 	    				
	 				#    						     		   #  							 #	
 			LFLAGS "$ LFLAGS   - static  -l -  static   	"		#		     	   				
    		 #
			   	 				 #			

	#
		# 		
	  
		 		

 					
 #		  

 				    				  #   
  			 #		

				   			
#		

  			# 			 #				

 		#

 #				   #	     

 
#
 #   		#

    				  

	     	

 #				 				   		 #  		 	

   

    			   			 #

#   					    
 #				     				    				    #	 			 #

  			    #	  #				#

				
				# 

 		#############  ##   #####################

  	
		

 			 #
  #   # #

				
  						 				

  ################## #		 

  		

  ## 					   
 ######################  

				   
				      			

  ####################### ##    				    			 		    			
				     #
			 # # #			    #  					     			   		      			  					 #   		 #  	
			#	

 
	

		    
		 	   ##
#		    ################# #  				  					 	     				   ### #		  	 				

  ## 			  ##			     

 		
   ##  					      					     					     ### ##    
  		 # #

#

	
 #  ## 
 				

			   		
  

#		 

   ##
   #

  
		  #   
		  #    				 

    	     			   	   	      #   
  			   			   					 #			  				  ###  					     #
			   			   #	#			   	 

				     #				  		   			   #

			   		 		

	   #	     
			  ###	  					
	
#
 #		      #
    			#				     ## #		   				#		

			 #####		 #		 #

 #	#	      ### 			      			     # 			

#				  
 #   		
  			 # #   	  			     			#		     ##  		  

 #   ###

   		

 

		

 
#  				  		  	      ##   		 #  		  		

	

		  					    	 

		

#		     			    ###
			   			  

				  	      

		
    

    
 #		  

   

	 #   					

   ##		

	  ###			  				   #

 #			  #

    ##	     			#				    			      #####################		#	
				
  	 	     				    #

    

		      	 						
#  ##		      			     	    			    	  
				

   

 #

	     

 				    				  ###
#
  ##   		     
    	      # #

			   				    
				      		      ##		 

    #   
#
	#		 				  
 

#				 				     				#			     			 #				 #				 				   			      

			
		
 	################

	 # 				 #			 #				  				     ###   					    #########
   				 		    		
#  					    				#  

 #		   

   ##   				#

 #   					
# #		

				      
    				 #			     					  		 # 				  					#	
 			 #  
   				  		      				

# #				     
 #			#

    		   
#	 				      ##
	

		#   				    

 #				#  			 #  # #
 # 				   	     			

				

# #	

				

 # 

#

 #		
#				    				     			 #	# # #		   ###		   		  

 #
  ##
   		 #	# #  			    			

  					   		   				#	   ###    			      			     	#	 #

   ### #
	    				
 #   ##	#

		      					     ##    		

   					      #  ###
 #	    			 
 #   	    				     			
  			   #				     #				      	

  					 					     

		  
#  	     

		  				#
				#   

#	   					      				    					   ## 		    

  
 

   
 #   	      #   			     		
   ###

 # 		      					    

		    ###

  	 #			
			      					
  

 

	# 					    ##	    				    					 #		     	

 #

	      #   				 #
			#				    
   #			

	   ## #

		 #		#			      ### #  	  			    					  					 #

#		#				 #			   ##

				 #	 

			 # #

  

 

	    				   

 #			   					

# # 				   # #   ##	 #			   ##		      #			     ## #				
   

				   				

		    ###	#				    			   

 	 	 				
   			      					  

"",

  			
  	   	 #  ##

	
 
		 #

   		     					  ## 				 #

#		     ##			     				
    				

  #  #		#
    	

#	  		 		# 	    ### #				     		

 	#

			      

				#  

				

   				     				 #			    					   				

	      	#  
		
 		  ## # #   			  	
# #

 #
				   		# 		 ###   #
    			#   ###		    				  

# 

			

  
		      	     					  
	 

		#

				    ### 	  #				
		     ##	 #
		  				#			 # 				      
	   			 #

  #
				

  	    			      				
 
		
    		   			### #				    				   			     		  #  		      		
				

    	#				 #   
  ###  

 				    

    			
	 # #			      			    					

			    					   

				 # #    #

	   #			     
#	

    					

 #				      # 			    ##			#				   	    	     ### #
				 #			  #				

	
			      				 #		
 # 	#  				  
 #	   

			
		 #				 

	 #		

			  ###    

 			    		
# 			   			 
  ##   #				
#			
			#	 
    

  		

# #  ### # 			

	# #
				
			 #	

 #				#				#		   ##  
   ###		

#			      #
  ##### #	  			  		
	
  
 

			#  ### #  			 	   				
	  
    # 	   
    			
  	    ##				      
#  			    				  			      ###

	    ###

				      				  #   ##		# #			

				 #			  		  		 # 	  
#				
 #			#		 
			
		# 			  
			   			
 

   #

    				    #

    			   

		#

			    

 			

  
    # 				      

 #  		#   		      		  			  

		

		    					

#
 #   ###   				 	
    	  

 	    ### 

		     	    

   ###   	     					   ## 	  			   	  ###			
		 #   			      	 #		 #

 
	      ##			 #   				      ###    
  				

  	   #		    			  ###    			

 		#

			
  ###  			    ###		   ## 
   			    		  ###  #

			  					     		 
    				 				

  	 #	    ##	     			 	   	 	 #
			#				     				   
 
  

				 		 	      				   
  ###

  				# # 
#

 				 

		 	  			###### #

		 				  			   

    				 #   

				

 
				      ##		  #   
			  # #			

		 #  			     ##  
				

			      #

   		 #   			  					   			    
				# 	 #   	

 #	 #				    	  					
		  #
		 
 
   ### 	      

			    				

		      					

    ##	 #  ##   					      # #

   				      #				 

#   			     
#		     ##
	

 #

   ###  

  				      ##   		   
#
   
  ##    ###    			 			  					    		 #			
  
 #   ###    					 # # #   					   	#
	    # 				

			
  	#		#	  				 #
  ##    		     			  # 		    ##    ###

 #				

   
 
				    ###
   
  	  					 #			

  ###
			   	

   		
	 #	   					   					#		      ###	

				
 				   

 
 #  			   		#	    ##   			#			  # 
 #  	     ###

		
			      ##	  #

		   	      		  			
#		 #   ##			
		# #		  #	 #		#		     	   	

  				     
  
    ###

	
    ##

#
 #			      ##		#

  ##   					     

			 # 				  ###	 #				  			  	 

	
	     ### 				 #   
#		    				     		#
 
 	

   

   #			 				      ##		    				
#		   
  ##		   

			
 # 	

			#			#				#  ###    			# #

  				# 				

 #  		   ##
 #		
 #			

 	     

 	
		

#	#			 #  

				#				
   		 #				   			    			 			      ###		  				#			 #	
#   #		      	 #	
  

 				  	     ###			
#	
				     				 #   		  #   
		   #

  

				#	    	      				  		#	      ##			     ####	

#	###

    		  				#   

 		#			 #   ###

 #		

    ##

 				     

    			

    

		 

			

    

			
				 # 

 				#				      					 #{   	

		     #  			      		     #   					   	 #   		#  ##

 #	     ###		    			 				 			     ###			  ##

		
  				 #			  			
 #

 	

		 #				 # #   			 			    #		    ##		 
			

	# #				    			  ### # 			   				     	     			
  			  			    ###			   					
		 # 	     ## ##			# #			 

	 #   			   ###
		    

	 #  ##  	#   ###    				    	  

		
 #	    	#

 #   ###   			
 #

  					 # #			      ### 								
    		      
		    			     
#
		   		    
		   
  				 	
  ## 				 #  			

				     					     				      				      
 #

				  
 # 				    #				      ##
#		 #	

 #			
    			 #				      				      ###    			  				    ###    				     
 				

				
	   

    # #  #  			# #

    				 #	
 				 # #		 #	# #

  					    		 	

  

  					  

 #			     	    		     

	 		 
   #  #			

   				 #				    			     					 #	

	 #   # 

	 
   	#

		   ##
	  ###			 	     		      					  				     			 	      

			  #		   # # 	      
 #			 
#

		  ######### #
    	   				
				 	

	    ##  			

    

    				    			      				 #
   		     					#
    					      
				 		     					  	#    				

  		   				  				 
		    

	
  
	  				      		  

	     
	      #
				   			#	     ## 		#

    				   

#
		 
			   			  

    					    # #

 # 		

  

   ##
 

				      
    

    
		  		  					
#
   		   					# 			     				     			      # 				

   ##			  				 

   	   	      			  			    ###		   				
	 #			# #				 			 # 	 # #   
   				  
    				  				    ## # #				 #	   			    	     #   				 			      				      		     					#			    ##

		 #  					     #				    
	  
	      ##  

  		   				#			     

    					

				    			 		     		   	 
 #  ## 			    

		 #

   			     #

 #				  ###		    ###		 		   
		   #   

  					     ##
		    		   				 #	    	###    			   					 	#   #   			      				
#   		   ### # #   	      			   
				
			
	 		 				  # 			

 # # #
  ####  					 #			  				 # # 	

 #  					      					  ##	  ###
	  	
  			  

 			    		

  #			#		

			 # 

				
   			  					   
	  					   #   

  ##

  ##			  

#		 #

				#		 	
 		      ##    				     	  			  					# 
   					 #

 #		  		 		 
   		   ##   ###  		    				

#  				

		  

 				      			
 		
		      #		#			 #		 
			   

			

	     			   

				      

		 	   		

 

    		    # #

  
#			 #				     				   			

	 		 # 			 			

	      		   
    ## 	#

    
			 #
		    ###  ###    				   # 

 
			      		    					

#

   ###

		     					     ##
			 			

		
				 #		 
				   ###    				  ###	#  		
 				     
			   

			      ###	     			     	

   	   ###  				    

   

 				 #

	  					
		 #   	     
     			#
			  ###
 
#				  ## 

 				    
#				
 				      

#  ####			 			    ##   
			 

				 	     

 		      	     

			  

   ##

  #
   			
   					#		#

   				  	   
		     				# #		   			    ##	 #

    				   #	     ##

 #				
# 				      				#  			
		     		#

 				 #	 		#

				     
	 #

	  			

				   #			    				 #	   			   	    				#		     		
	
 			#			 #	     
		    	
   ### 			   				  ###	      
			 #  ###
  
  ##	 #

	# 		
    				
			
   				     				    	     ##   
   					  ##  	  
   				 
 			     

	

#				 #
			   ###  ###    

#			     				#	 #		 #		  
	 		
   	    			
#   

 		#  #		      
			 #	    		    					   #	

		  				#   ###		
 	

 #
   # #

  				
   

			      
				#	  

	      			   
 #  		     
 		    #####    ##  	  #			      					  ###    ###  
		

			
    		   					    					
   		 #
			   # 	 
 

 		
	  		   ###		   		 			
    ###   

#			# #   
   		
				    					 #			   					    
   	
			    
		      ##			 #
				  				     
  #				
    				      
 			      					 #

	

 		 		      ##
				# 

#

			

	 
				  					    #
#
   			 

			    #			   		

 
			
  
 #				  

    
#   

				      		

 #	

 #			  ##   			#	      	   			  			      			    
   

 				 # 		  					   
   	 
    					   		   			#  
	#				   
					    					
			

		   			    					 # #		

	     ## 		  # 
			     					 #  ###	
			    				
				

# #	     #
	
   					   					   	
  ###
  #				     

    	# #				   #

			#	#
				     

			    				

    			      ##
	#				#		#   				

  				   					
 #  		     	      				 

   

			     				     ##	 	   				  					   ###  # 	 #	     		#   ###   #   	 # #   	

 

	     				     

 
  	   #  ##	#

		   # 
				 # 

 
  	 #	      #	  #		
		 	     	    #			 		
 #	      ## 	#   
 	 			    

		    				     				 #			

		    
    ###

#

#				   

#  ##
    ## 

#	   					  

    			

 				   

  
  			
# #				      # # #   #	  

    			    
		  #
		
		

		

	

		     ##			 				     	    

  		   			 #				  		   
#			  				 #  # 			

    				 #

    #

#  				
  #
 #	     			     
	 #   				#  				   ##  

   			  #	   	
  ###   		

				

#	  ##
	   # #	   
 
   	
    					    					#
 #	    
 #				 			
 				 

	  #  					  ##			      

			    ###	 	      					

 	  
    #		     ##
   		    
			 		#	 
		      		#  	

  #
 #   # #
 		    

				

			      				     		 #

	  	

   ###		

 			   
		   			   #				

    	
   
 	#   				    			 	#		 #			 			#  ##  	
    #
			  	  				 #
				 	     
				    #		 			#	 

		 # #				    			 			  

	      ### 
   ###		    ##		  				

			  	     	  

  		    

  				      				     ###   #				  

		   #  ##  		 			  ###			#		    

 #  	    

				  	   				#		 #
  		   ## #			
 

   		

#
  

    		 
 #		   ##			# #			#
   

  		   		 
				   				     ##    
  

  				   #  	     ##

   #  			#	  	 #   ###  
						  		 #		 			  ###			

 		
#  		     	     #  ## 
		   #   		      		
			 
	   			
   			      				     
				   				      ########## # # #

 #		
				    ###

		    	    					
    				      			
 
#

				   	   		 #			    		# #	    				   

   		 #  ## 	    					

 #				      		
				      			  ###	 #		     		  	  			#  ## 			 	      

 #	
				  		#

	  				    		   		
			  			# # 

 		#	     ###			
    		

 

				   #				  				
  # # # 

		      					     
		   			

	
				    	

			   ##   	     			

				   			 
		
  	

# 

   					

			   #		    		      ##		
   #		  			     ###		#		    ##

   					 			 	 
 			  ### #			    
		#

 #

				 #		      			#
		
			
  		   					   # #		 

			     				   		 		 	     				  
		#
				 
 
 #

 # 				   
 				 #	  ###
 	    ###	  	 #	#	
 #   			  				

			      					  				 

  ## #				   ###   

				     
		  
				    	

	 #				    # 
	
		#		#
				 		

    ### 
	

#		 

				 # # #	    

	
			      
		 #	 # #			 			  
 #

 		  # 				#				   #   			
 # #  ##    #  ###	#

  	# #				

	      ###    ## 			     
#			 #
 # 	     #

    	    				 
 

  ##	
 #		   	     ###			    			  			 # #			   ### # #	
 		     	    :				  					  #	 	     
	  

 		 #
  ###
  			#

    ### #	#			 #

				   				 

		     				     ###    ###	 #
    ###    	    
		 #  #

		     		#   			     
#  ##   	 #
 #  

	      	#  	 	     

 				#	   ##    		     ### # 		  ###    		 ##			     ##			

				 #	  

#

		 #   			 #			   				   # # 	
				 # #				
#			

			  					#	

				  		    			      
#

			  					     #  			
  ###

  			   					    # 			   #				#	 #  			    

# #		 

 	
		  			 # 	#  #				   				   

		

				

			 #  ### #			     # #   # #			     ##

    

	   

				
	  ###
			    	

 # #

 # #				      		 		  

    ###   #				      

			 
				 #		  #	

    			 #
	

				
 #   ##		   ##			 # 		
   ##    	 

		     				 #
		      ###		

		      

				

#

    		  # #   
			      ##
 # #	    		#  ###
    ###   			#				   			
		
    		

 		# 			      	    					

  ###   			  
   				   ##  		      ###  			   			      
#				#			
   				   			 
    ##			#   			 
				

				    			
 #

			

 
    ##		 #		     
 
  	

	  ###    			
  
			  ##   ### #			   			      ##

	      #		      #			# #   ##		 #				 #  ###			   ##   

	    ##    		     		   	    		    

				  

 			     
    ###
				  #		     				   ###			 

   

		 

 #

  
		  					#		# 
 #				      

    #   ##   
   
 #				 		
				

   	       ### 				  			 #

  
			

			     					
		     ### #				     ##			  # #	    				 #	
   		
   			 # #	     

   					#  

 		#   		    
    ###			

				
   					 #   			 	 
    ##		    

   			
# 
#			    	    
 		    # 		 	  ##

   

# # 			#		  ###   		   			 # 			
				

  ##   

 		    				 
			      ##	

  		    ##   	      

  		 #	 	 	  ## #	#

  			     	
			    			    		   ##	 

				#			 			     ##
  					     			 #		
 		

  					# #			     	 	# #	
#		
 	    ###			     ## 

		

			   			      #	 
   					  #  	 #   	

				   	 #				

