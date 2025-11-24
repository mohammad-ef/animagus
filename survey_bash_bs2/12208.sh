#!/bin/bash
# UNIX Universal Build & Deploy Automation Tool (UBUBAT v1.0)

# 1. Inititalization && Envrnmnt Setup
OS="UNKNOWN OS"
ARCHITECTURE="Unknown Architechture "
MEM="0" CPPU="0 "
KERNEL_INFO ""
FUN=() LOGDIR= () TEMPLOGDIR () TEMP_LOG ()


FUN(){  local log_prefix ="[$0: $($] $FUN]"
  
}




# OS detection and version.  Handles Solaris 10 (and older IRIX and others too) gracefully with "grep /proc "
getOsInfo  

# Function Definition (for easier function call) to check the commands existence
detectCmd  

check_essential_commands  



function  init  {
  set +x  # disable tracing, so it does not get messy.  Reenabled later
  detectCmd #Check if all tools needed is available on OS and version detected earlier, 1. initialization & environment setting. OS version detection etc. 	

  # Check and create required directory if needed and make them all world readable (for compatibility on very archaic unix like HP-UX) or versioned UNIX like SOLARIS/ IRIX where you need specific permissions set by system administration to be writable for the build. This makes things less problematic when trying out a new build. This makes a difference with Solaris/IRIX as the version is very old in many situations. This is for maximum UNIX system coverage with a build tool to not fail.	

  TEMP=$(mkd  temp)	  TEMP_LOG=$(mkd  log_temp  ) LOGS=$ TEMP_ LOGS_TMP = ${ TEMP _ LOG / temp  / _log  / } 
}



  # Normalize Paths (Important across all versions of SUN, HP and even some BSD variants.)

  # Set environment variables.  These can be overridden later
  TEMP= "/  /tmp  "

# ----------------------
  # Check for existence of expected folders
  # and set defaults if absent (important for Solaris) or use environment settings from a file (for older system with configuration in .profile files etc) or a custom script for version specific settings

function mk  { 				# Create folder (with error checking )	
	
  local dir = $
  # check existance, then check permission before making
	if 								! 		
  			[[	-d "$dir"		
  			]]		
			
  then
		echo "$ Creating new $ dir" 						
			# make the folder if missing. This handles the HP case. (where the system does NOT set up temp)
			mkdir	  - p $ dir
  else		
			  # check the folder is available to be write to by checking permission and owner, to avoid error on build. This is for SOLARIS, IRIX etc	

			echo $dir is already created with expected permissions 	
  end			

  	return	
}  			


  # Set environment variables, to allow users or custom configuration
  CFLAGS 			= 			
  LDFLAGS			=
  CPPFLAGS	 =

} 

function check_ essential_Commands	{

	  detectCmd " uname "
  		detectCmd " make  - v " # check make and if not found exit with error	

  detectCmd " gcc -v 				or cc  -- help	"	#Check compiler availability
}


# 2. Complier && Tools Detection
  	

detect_ compiler	{

	COMPILER 		
	
  # Check and handle compiler flags and versions
	  

  } # compiler Detection
	

 detectTool	 {

	 # Detect tool chain utilities such as 'nm', 'objdump'
  }		


  		
detect_ compiler 	
detect Tool
#3 Compliler &&Linke Flgs Config

  	configureCompiler  		
detectCmd 			
detect_ tool

# --------------------------------
  	 						  
configure_ compiler 	
detectCmd 			
configureTool

  	detectOS
 #4 Sys Hd  & Lib Detect 

detectSys  		

detectSys	 

detectSys 			
detectOS


  	#5 Tool Detection

detectTool 		

detectCmd

  	configureCompiler 			
configureTool 			
detectLib

  	detectLib 	
detectCMD 			
configureCompiler  
# -----------------------------------
detectCmd 		

detectCmd

  detectCmd

# ----------------------


 #6 Filesyst && Dir Check

# detectFileSystem

# checkFile  System

# -------------------------- 	

 detectSys 			
detectCmd

  # -------------------------------
  detectCMD 			

detectCMD

  					

# ---------------------------------  
detect_ tool 			
detect CMD
#7 Build && Comp

detectBuild

 detectSys 			
detect_ tool 

  detectTool  
detect_ tool 	

detectSys  
#8 Cleaning &&Rebuilding

detectCmd 		

detectCmd

  detectSys 		  detectSys 

  	configure compiler 					 					
  detectCMD

detectBuild 		

detectCMD
# ----------------------


  detectCmd 		

  detectCMD			

  						

 detectSys  # 9 Testing && Validation
 detectSys 			
detectCmd

  detectCMD

	

  detectTool 			
detectCmd 					
detectCmd 	 
# -------------------------------------
detect CMD

detectSys

	 detectTool

	 detectSYS

 detectSys

  detectCMD	 				

detectSys
# ----------------------------------
 detectSys

  detectSys			

 detectSys

  					 
 detect SYS
 #10 Pacage &&Deploy

detectCMD 		

detectCmd

  detectSys

detectTool			 detectSys  
detectCMD
# 	 	
detectCMD  # ------------------------------ 	
detectCmd
# 11 Env Diagnostics

detectSys detectSys 		

detectCmd

  detectSys 		 detectSys 
# ---------------------
detect Tool 	 		  detectSYS
detect Tool			
# ----------------------


  detectCmd 		

  detectCMD			

  						

 detectSys  # -------------------------------
 detectCMD
 #1 -----------------------------
 detect Tool 						  detectSYSdetect Tool 	detectSYS
 #1 -------------------------
 detectTooldetectSys 	detectSYS #1 -----------------------------
 detect Tool 		detectTool 	 		detectCMD detectCMD
# -----------------------------------
detectCmd detectCMDdetect Tool 		detectSys detect Tool 					
  detectSys 		 detectSys 

detectSYS

 detectTool #1 -----------------------------
detectTool detect TooldetectSYSdetectCMDdetectCMD detectSys detect SYS #1 	 					detectCMD
 detectTool		detectSYS detectTool detect Tool

detect Tool 	detectSYSdetectSys 

 #1 		
 detectCMD
detect Tool detectTooldetectSys 		detectSYSdetectTool detectSys
detectSys 		detectSYS
detectCMD 

detectSysdetect CMDdetectCMDdetectCMD detectCMD
# -------------------------------
detect Tool detectCMDdetect SYSdetectCMDdetectCMDdetectCMDdetectCMD detectCMD

#1 					
detectSYS 		detectSYSdetectTool 					detectSYS
 detectTooldetectCMDdetectCMDdetectCMD detect Tool 	detectCMD 		 

detectSys detect CMD detect Tool 					
  detectCMD
detectCMDdetectCMD detectCMDdetectCMD detectCMD
  	detectCMD

  detectSYS 		detect TooldetectSYSdetectCMDdetectCMD 			
# detectSys 		detectTool
 #1 ---------------------------- detectSysdetect SYS
#detect SYS
 #1 detectCMDdetect CMDdetectCMDdetectCMDdetectCMD detect SYS
 #1 detect CMD detect Tool 					

detectSys 

detect CMD
detect CMDdetectCMDdetect Tool 				

detectSYS 					
detectSYS 	detectTool
detectSYS 					detectSYS
 detectTooldetectCMDdetectCMDdetectCMD detect Tool 	detectCMD 		 

detectSys detect CMD 					

#	 #	  1detect CMD detect SYS			

  # # detectTool
#1 detectCmd #2 
detectSYS #, detect Tool, detect CMD# detect Sys 


	#3
 #
 #
 # 
detect Tool

		
 detectTool 			  

	 	   #	  #3detect Tooldetect CMD #detect Tool 		  #4  5	 					  				

detect Tool  

	detect Tooldetect CMD
 detect CMD detect SYS#5 detect Tool#detectSYS 				


	 detectSysdetectCmd 			
  #5	

		 #4  detectSYS #5 			

 detectTool#
				        # detect TooldetectTool		 		 detect CMD	detectSys
				   
detect Tool #detectCMD detectSys  
  

detectTool	  

detectCmd detectCmd
detect CMD detect CMDdetectSys  
 detectSYS 				 
 #4 detect TooldetectCmddetectCMD# 
 detectCmddetectSys #detect Sys	detect TooldetectTool	

 #	#detectCMD 	 #5		

			# detectSys

	 detectTool	 #5 			# detectSYS		
		detectCMD	 detectTooldetectCMD  #6 	
					

					 		   	#	# 			 #
#7  8detect SYS

 # 					 					detectTooldetectSys #

		  			# 	   detect Sys#		#

 # detect SYS
#9  			# #
				#

	 detectTooldetectCmd	   

		 

detectCMD	 #9

		detect CMD  detectTooldetectSys  			

				

					   			#detectCMD		detect CMD			


  					detectCmd# 9

detect SYS		
 detect tooldetect Tool	detectSys

 detect Sys detectSYS
 #detectSys	detectTooldetect Sys  
 				

detect Sys		
		

			   
 # 						  # #	#1

		
					 # #	  					

				 # #

 detectSYS  					


  				   	# 	
				detectSys#
			 #

detect sys	


		


		  detect Sys	detectTool		 # 4  detect SYS	 5

				


		 detectTool #
# detect Tooldetect Cmd	
			
# #

  

				


detectCmd	  #1	 detect Tool # # detect TooldetectSYS  		


#1
 detect CMD	detectSYS		 detect TooldetectSYSdetectTool # #	detectTool
 detect SYS
# 						

				 detect Sys detectTool
 detect CMD		  	

			 detect Tool

#

			


		
	

					 detectCMD	 # detect SYS	   	 detectCMD #detectCmd detectCmd

			detect Tooldetect Cmddetect Sys

					   				   			

#
				 # 
 detectCmd		 detectCmd
 detect Tool #	

 detect Sys  

	 detectTooldetectCmd detectSys  
	 defctTool  				 detectSYS   


			 #
#  

 #  

					

 #
				#		


			 # detectTool
			


  
					
 #1 # detectCMD 

 detectSys 						#	detectSys 

 # detect TooldetectSYS detectCmd detectTooldetect CMD 			


	 #
  						 detect Tool		   	   				
 detectCmd
  	 # #detect Sys	detectTooldetect CMD 						#detect CMD#

 detectSys#  						#detect Tool # #
				# detect SYS	detectTooldetect Tool		


					#	 					# 						


  										#  					   # detectCMD	


detectCmd

		 						 detect Tool#	#detect Sys 

#
detectSYS  						
detectCmd  detect Sys detectTool  

 detect CMD # detect CMD    					detect SYS		   

 #

 #	 			   	# #

		 #		


	


 #1 #
					 
		

 detect SYSdetectTool
 #	detect Tooldetect Cmd 					


 detect Cmd  

 detectCmd#detectTool #detectSYS detectTool #		
	detect CMD#
				
		
	# #


				

				


 #
  			


 #

detect Sy # #
detect TooldetectSys

				 					


#1

			 	detectSYS detectSys detectCmd	


# detectCmd  detect CMD detectTool

 # 

detectSYS #1

			 	 detect CMD	 #		#detectSYS#	detect SYS # detect SYS 
			#  


  	 				


					   					 			


										   					


		

			 detectTool#	


			   		


 # detectSYS # 9  					# 9 detect SYSdetectSys		 
 detectSYS#		


#		



  # detect Sys#
			


# 
 # detect CMD 


					#	

  # detectTool  					  #		 
# detectSys
 detectCMDdetectTool

					detectCMD  	



					 # #detectSysdetect SYSdetectSys  					#


	#	 #	


  
  			 	  				detect Sys		detectTool  			detectCmd# detect Tool	 detect Sys # # detect Sys
	detectSys	 detect Tool  #

detectTool		


	 detect SYSdetectSYS 	#	#detectSys

#  				  				#detect Sys 					 			   


				 detectSys detectTool

	   
	
	


 # detectTool
				

  			 			 
  	#1 detectSys #		


					
		 detectSys
			   	 detectTool 	


detect CMD 
		 # detect Tool detectTool
					 detectSYS #
			


detectSYS
detectCMD		


 detect Tool  detect Cmd

				
 detectSys#
 #

  

	#
					detect CMD

				detect Tool#

# 					


detectCmd

 detectTooldetectTool#,
  						 
	 detectTool#
  					


  				  

			# detect SYS
detectSYS
		detect TooldetectSYS  #detect SYS  				  			 # detectTool	# 


 detectTooldetect SYS#
# 		 			 detect Sys #

  			  			 #
		  		 detectSYS  			

				 # 				#  #


  detect SYS
	detectCMD#
detectTool
 detect Sys
				   detectCmd

		#

  			
  		
 detect Sys
			
 detect Sys
	

		 detect TooldetectCMDdetectSYS
detectCmd #
 #detectTool  

  				 	 					


#  				detect CMD  
#1 detect Tool  				 detectSys
detectSys	
				 detectSys		 detectCMD 						 		
 detectTooldetect CMD #detectSYSdetect CMD  		 detectTool detectCmd		
#detect SYS detect Tool

	

#detectTool		  
  detectTooldetect SYS  #

 # detectCmd #  				#		


 #1detect Tool #	

			
# detect SysdetectCmd detect SYS	



				#1

# #1detect SYS
detect Sysdetect SYS# detectCmd detect CMD	detectCMD#	

				   
 detect CMDdetectCmd #
				  
#	 detect SYS detectSYSdetect SYS #1

				

# detect Tool
detectSys
					 # detect Tool#  


 #
			

detect Sys detectSYS		   detect Tool# 			


					


detectCmd #1 detect Tool# detect Tool
 detectCMD

			 			   #	# #	 

  				 #detectTooldetect Sys
		  		 # 		  	

				


			

 #detectCMD
	
			   


					 # 

				  	 	#

				   					


					 detectTooldetectCMD
			detectSYS#
		


detectTool		 detectSys#detectCMD 
	 detect Tool		detect Tool detectCMD #1	 detectCMD		# 


 detectCmd 	 					detect CMD	#		
					   			
detectTooldetect Sys		detectSYS detect Sys 			

			  		 
#detect Tool  

	
 # # 2# detect CMDdetect Sys 
 detectTooldetectTool	 #detect CMDdetectCMD		  detectTool 				 detect Sys #
					   			   					  


			   detectSys
detectCmddetect SYS #1		  				   			 detect Tool #
					 detectCmd	   
					 
			


  				 		 detect SYS
#	 						detectSys  
#	  					 #1 #1
detectSYS detectSys 					

				
		 

 # 
  
  

				


					detect CMD  					 detectSys detectSys		

detect Tool
 detectSys
	  						#		

 detect Sys 

				  	#detectSys
	
					detect SYS 						   

					   
			 # 
	


		
	

detect Sysdetect Sys #  

 #
			 detectCmd#detect SYS
					 # detectCMD # detect Sys  					


	


					 					  				

			 # detect Sys  
			  			   			 
	detect Tool  

 #		the		
		

# #1 #  			#		


 detect Sys# detectCmd#  #  detect Tooldetect CMD  	


		
#detectTool

		  
 # #  detectSys#	detect Sys # # #
			detectCmd	 detect Tool		   

		  			detectTooldetect Tool

					detectCMD 					
			  			 # 


			


 #	
					
  					


  										 #
 #



				
			 # detectSYS 						   
 detectSYS # detect Tooldetect CMD		detectTool  					 	


				 			 #detectSYS detectSys

  			   
 #

		
			   					
	


 detectTooldetect CMD		 #	 #detectCmd	

 #		 detect Tool 
	#	  			#  


#	

 #1	
#	   

					

#1 #1 1# # 232#detectSYS 			   			detectTooldetect Sys	

	#
 detect Sys
	 detect Sys

	#
detect              	 # detect Tool# # detect Sys		

  

  				

		 		 # detect SYS#

					
			detect Sys		
  
#		 					 #  
					

	 detect Tool # 2
					

					 		#1 # detectSysdetect CMDdetect SYS#	detectCmd

 #detect CMD	 					 
				#		
		   detect Sys  		

  # detect Tooldetect SYS
  					
detect CMD		

 detect SYS  			 #detectCMD# detectSYS

 detectCMD 		 

					  

					  
  					 detect CMD	 #		# 

	 						detectSYS	detect CMD
#  		 #detectCmd  detectCmd 						

# # #

	 detectSys# # # #detectTooldetect SYS

		


detectSys 			


		 # 		#

 #	


					
#
 detect CMD#		 # detectTool
detect TooldetectCmd detectTool#
 #
				#

detect Tool

	
				 detect Sys		
detectSYS		   


	  					# #  # 					   			
#

  
  					  
  

  

			   


					   					# dame
#1 detect SYS	 				

 detect SYS# detect Tooldetect Tool 	#		

	 #

	#	

			#		 	   
 detectCMD

 detectSys

					  

detect SYS#  
					
			
					  

detectCmd

				


 # #1

			 #
#		#detectSYS detect CMD
detect SYS detect CMD				# 		detect SYS	detect Tooldetect CMD# 					  
					
			#

	 

	detect Tool detectSYS # # 					detect Sys	 						

		detectSys

					  					


 detectCMD	


				
				#  					   			   detectSys detect SYS

				   

				 # 
			   					 					 #
#1	  
					#1detect SYS
	 	detectCmd 		  				
			detect Sys	

detectCmd
				  # #  #		


				 detectTooldetectSYS	 				


	
  

detectCMD
			

	
 		 detectSYS 
		   		detectTool

			

detectCMD		#

		 #
#		 #		
	detectCMD

			 
			 detectSYS 


#

			
detectSYS#


	

detect CMD		 #

#1		 #		 					 
 detectTooldetect Tool		 #detectSysdetectSys detectCmd	#  				

		 		 		 detect Tool#  	 		 					  detectCMD detectCmd

					 		 #	

# 		


			detect SYSdraws 	
 #1
			detect CMD		#detect Sys #		 detectSys detect Sys#

	 				 
 detectSysdetectCmd

				   				
detectSYSdetect Sys

					

			  			detectCmd	

 #5  

				 detect Tool		 #		   

  		
		 #

			
 #1

				   				  				 detectCMD#
detect SYSdetectCmd 	# detectCMD  

  		detectCMD

			detect SYS
 #
 detectTool#	 						 		detect SYSdetect SYS  
 

detectTooldetectCmd		# #		 # 
					 detectCmd
  # #detect CMDdetect Cmd	detectCmd

 detect Sys detectCMDdetect CMD
 				#		 detectTool

		   

		#
# detectSys  			detect CMD 		detectSys		  detect Sys#
#

	


 # detectTooldetectSYS
			 detectTool detectSYS 			# 1  				#detectSysdetect Tool # #  	   

 detectTool
	   

 #  		


		   detect SYS detectSys
					 detectSYSdetectSYSdetect CMD detectCmd 					   		   
					

 detect SYS 		   				  		 detect CMD detect TooldetectCMD
detect Sys	 #
			 						 detect Sys 			 detectTooldetectSYS

 #	 # detectTooldetect Sys  

				 				
 detectSys#
					 	 #detectCmd detect SYS detect SYS  			 detect CMD#		  			  	


#1
	  #	 detectTooldetect SYS#		 				   				

	 detectSYS

				 detectSYS detectSYS detectSYS #		
detectCmd

					 detect Sys #	  
 #1
	detect Sys#	# detectTool
 # #

detectSysdetect Sys# detectTooldetectSYS#  				   		
 # detect CMD
	#

 #
				   				 detect Sys		   				 				  
			

  						 detect Tool	  				detectTooldetectSys detect Sys	 detectTooldetect CMD#  				detectSys	   #  


  					


	detect Tool

	#detectTool	


# 2 detectTool		   				#				 
		  		

					  # # #

					

# detectCmd
#		#	
				

 # #detectSYS
 #		


#	


  	 #1# detect Sys		
			


				
		 						 # #	
	 #	 	
		#1 #detect SYSdetect CMD		  					 # #		detectTooldetect SYS # 	


					 #1detect SYS #
			
	


#	 detect CMD  #	   # 						
  	


detect Sys detect Tool	 			


detectCmd 
  

				
					   	  					  



#	# #detectTooldetectCMD
 #  				 			 #	 #detect SYS
				


		  	

  					#1# detectTooldetect SYS #  


#detectCmd

  #		

detectSys		
			

#  				

				
	 	

#
					detectTooldetect SYS	 			 #1

			 					detectSYSdetect Tool

	 detect Sys# 						 detectSys		detect CMD 

		 detect SYS detect SYS # detectCMD 						#	detectSYSdetect CMD
 detect CMD

detectTool	# # 1  


		 		 detectCMD detect Sys # #detectSysdetect Tooldetect SYS		  detectSYS	#		

			


  

#	 #1#
				
					 #		

  			detectTool
					 detectTool
					  


  	#
				 				
 detectSYS#
					

		   detectTooldetectCmd #1 		 #

				   


	

#	detectSYSdetectTooldetectSys		   			   # #

#

  

	 			 #		

 detect CMD detectCMD  detectSYS		 	detect CMDdetect SYS############	#1 detectSYS

				#detect Sys		 #	 #	detect SYS		


				   # 1#		 #
			 # detectSYS
detect Tool 
					


		
				 			

			   				


					 #
			 #		
				#		 # #
 detect SYS
 #  		 #	 #detectCmd #
 detectSys		#detect Sys detect SYS	 detect CMD  				 #detect CMD detectSYS detectCMDdetect Tool detectSys 						 detectCMD	# 


			#
 detectCmd	 #	


# detect SYS detectCmd

detectTooldetectSYS
  # #

detectSysdetectSYS #

  				


					   detect Sys	


	

  						  	#1 detectSYS

					   # detect CMDdetectCmd#
detectTooldetect Tool 	 # detectSys#	

		   

				 detect SYS#	

detect SYS #

 detectCmd detectSYSdetectCMD

				  
	
	


			 detectTooldetectSys#


 detect Tool#  detectCmd# #

			detectSYS		 # 						

 #

				detectSys		
					  				
 # # #		
		   detectSYS detectCMD

		#detectTooldetect CMD
 # detect CMD # #detect CMD  


					 #

		


			
 #detectTooldetectCMD detectCMD #  	 # 				

# 	

 #		  
		


   		  					 


			 detect SYS
  						
					#		  

 # 


#detect CMD	


					
	 # 	# detectCmd		
detect Tool  
	#
	 detect Sys#detectSYS#
			  					
	   


  
			
detectSYS
					   					 #

#  detectCMDdetectSys#  

# 						   			 #		
	  				 detectCMD	 detectCmd		 #		 detectCmd  	

		 # 	 #

			
			


					
	

#  			#

 detectCmd# 
	detectSYS

		 # detectCMD		   			   					   					 


		   				   	
 #  	  				   		 				#		

#detect CMD	



		

	
			   #		 		 			
		 # #
				  					

 #	 detectCmd		


detect SysdetectSYS		detectCMD detectSys #	


			

		 # 	
 detect Tool detect CMD  
  
	  					

				
 #detectSys#detect CMD#		  
	 #
					  


					 # 					# 					#
  						
 detect Sys
				 # 1  				 # 			

# 				


#		detectSYS# #		detect Tool
			  

detect CMD 				#	



 # detectSYS	 		   


	   					

# # #detectCmd detect SYS  			#	 detectSYS 		detectCmd detect CMD#detectCmd# #


		# 
					#

# detectSYS  detectCmd# 			  detectTool	detectCMD #

				


  						
 detectCmd 				

 detect Tool	 detect SYS 						  			


 detectSYS # detect Sys # detectSYSdetect Sys#

				detectTool	 detect Tool		 detectTool		
					

	 						#

detect Sys 					# detect CMD

	#
					# detect Tooldetect CMD 						 


					#

#1	


					#		  
					
	   

		  


# 2

	 detectTool
				
detectCMD# detect SYS 				
					
  
			 detect SYS
		

  # 2 #		  

#detect SYSdetect Tool detectSYS  					

 detectCMD detect SYS
 #  

	  					#

					detectSys detect Tool  		

detectTooldetect Sys 

detect CMD  		
 detectTool #

	


				   #

					  detect CMD 

	   #detectTooldetectCmd 

detectCMDdetectSys  


detect Sys# 	# detectSYS	  
#		 



		  			  

detectTool 
 detectTooldetectTool
detect CMD#	
		   

detectTool detect SYS

			 # 


		 detectTool #		    	#	   detectCmd
				 detect SYS #  detect SysdetectTool	
detectCmd 	 	 detect CMD		#
detectTooldetectSYS	   	

 #
			   		 detectCmddetectCmd 					  detectSys#detectCmd	 

#	 		   					  	   		
		  	#

detectSYSdetectCMD detect Sys		 #


	detect Sys		
#		 # 	 #		#		
 #

 detectSYS		   					
 detect SYS#  		detect CMD# detect Sys		
			

		  		


				


	  detect Sys #detect Sys#detect Sys
 detectCmd#	 detect SYS#detectSys
		 #	
 #

		 #  				


detectSYS
					
detectCMD 				 
					
		

  
detectSYS 
		

				
  

			

			


					


					detect Tool

 detectCmd# #  
#1#  			#

# #  			detect CMD detectCMD		#


  		
		
	  	


 #  
	# 		  
  		detectCMD



 detectCmd

		 

		
  

			 #
 #	   	#  					

#

 detectCmd # 					

 #		




 #	 # 


		
					 # 			 		 #   #	

 #

		


detectSys 


		#		


  detectCmd# detect CMD
  			  					  			



  detectCMD 


				   					 # #
#2	 detect Tooldetect SYS # #		
		#
 detect CMD# #detect TooldetectSys #	 detect SYS# #
					

detectSys #  detect Sys

#		detectSYSdetectTooldetectSYS  detectCMD
			 #  				# 			



			

		


		 


 #1	  detect CMD

  PING		  
				 # #	
 detect CMD
 #detectSys detectCmd  

 detectCMD	


detectCmddetectSYS#  


					



			
				


				detectCMD #
			


				


# 
detectSys		

 detectSYS 		
		

  		 # 	 #


  	
			



					


		
	detectTool  #		 
detect Sys 				


  				
  						#detect Sys detect SYS  
			  			  
	
detect CMD	# detect CMD #

					



 detectCMD  					

				
			



				 detect SysdetectTool	 detectSYS #detectSys
detect CMD

					detectTool	


 detectTooldetect CMD		
  		

# #detectTooldetect Sys
detect SYS detectSys detectCMD #		 			detectCMD
 # 

# #	 detectCMD  					


				 detectTool
  		

					
			 detectCMD	



	 	  #  	

# # detect CMD

detect Sys detectSys detect Cmd		


detectSys	



 detect CMD

  		 detect Tool

				


 detectSYSdetectCmd#		#

	detect CMD 

  			


 #1	
detect Sysdetect CMD 				

					  #  	 


		  
			 detect Sys#
 # 

		#
# 				


#

# 			 detectTooldetectSYS #	detectCmd
	# detect Tooldetect CMD

detectCMD detect Tool detect SysdetectCmd	



					 # detectTool  # detect SYS#	 #
		detect CMD
		  

det  

	


		#detectCmddetect Sys 				  



#1	#  detect SYS	
#1	 #	



				 #


detect CMD detectSYS 					 #
detectCmd	 detectSYSdetect SYS detect Sys detect Tool		 # 
detectTooldetectCMD

 #		

 # detect SYS
		

 #
				  detect Sys	 detectSYS	#


 detectSYS	 


  		detectTooldetectCmd  


 detectSYS

  
  

  			 detect SYS	  #  	#detectTool #		



#

	
 detectTooldetectSYS

 detect Tool  


detectTool  		 



  				
 detectTooldetect SYS	



	   


	detectCMD detect SYSdetect SYS
					 



				 #
		 		#detectCmd  # 



					



					  				 #

					 		  		 detect CMD		 #  		
detect TooldetectSYS  		

 detectTooldetect CMD detectTool 		 detect SYS detect Sys detect SYS  


  				# 	detectTool
  					 detect SYS detectCmd #  #detect CMD

  	 #
 detectSYS# 



					 			
	  


		
				 			electronic

#

		 

 detect Sys

  detectCMD	 



 detectSYS # 


			    	 #
		

	 #detectTooldetect CMD
  		#detect Sys #
	  
  

				  #


 detectToolle



		
  
				

 #1 detectTooldetect Sys		detect Sys



 detectTool
	


					detectTooldetect SYSdetectSys

detect Tooldetect SYS 		 			
			 



 #1

  

					#detect SYS detectSys 
# 					detectTool detectCMD detectCmd


				# detect SYS	 			  


  	
					
	#
detectTool		

			   					#
# 
			detect Cmddetect SYS	# #	 detect CMD	#  detect Tooldetect SYS 



 detectSys	detectSYS
			  
  #

 detectCMD  

 #detectCmd

	


 detectCMD#

  				# deemd #  
 detectSys # detect Sys#  # 


 detectCMD
 detectCMD 		

	   detectCmddetectHysdetectToolededecm#
#detect Sys  		#		 # #  	 # # 				}detect Toolect Sys#
			
# 				}  
 detect Syscounting 					


	
	
					#
	#

				
  #detectToledec Sys		


			
  detectCmd  		 #		 detectTool

  
#	}
			



				   	detectCmd 				
				#	 #detect Sysdetect SYS#

 #detectSYS 			  #		


	
detect Sys detectTooldedec Sys	 # #

 detectCmd  				#	#
  


  					detect SYSdetect Sys detect Sys 						 detectToled

	   #
		
		   detectTo
		# # #

		
	 detect Sys 						detect Sys


				  

			 #detect Sys  
		
				

					

# detect Toled

					 #detectCmd	  detectSys


 #

 # #detectCmd detectTool detect SYS 
 # 				 detectTool	  #


detectCmd# detectTool  					 #


		
			  


 detectTool #detectTool

			 detect Tool	#		# 	  	 #	 #


  	
		#
# detect Tool#

 # detectSys


 detect Tool		 # detectTooledecc
detectTooldetects# 				

# detect Toold

  


					


			#


				   					 #


					

# 	





		# 					detectTool	#  				



  			 # # #
				 				  					detectCMD detect Sys#	#
detectTool
 #detectCmd#  


					 #

 detectCMD detectTooleedecs
					    


#
#				




	

 # # 					 detect SYS


detectCMD#
 #

		 detectTool detect SYS	

				

	detectCmd		  		 # # #
detect SYSdetectTo
	

		

				 
					 #
			#  			  

 detect Tool #  detectCMD 


detect To
  detectCMD
		


					


	
  					  					#    # detect Tool

				
#	 					 detect SYS #		


				#		 # detect CMD #	detect Sys 						  


 #

	#
  #  
detect SysdetectSys	
 detectCmd detectToode 					detectSys 			 



				

				








					 #	


  detectSys

	  				

				   

			 # #  #detect SYS# #
			 #
		
  

		
 # detect Sys
			   

 detect SYS# detect SYS


				 detectCMD	 

 detectSYS

 #
detectCMD #detectSYSdetect Tool#
		 		 

 detect Sys# 



			 		   


detectTool

					 			#		detectToode 		detect SYS#	detect Sys# 	 


				


		#
 #detectSYS#
detect Sys #
 detect Tooldetect SYSdetectTooldetect CMD

  	



 detectCMD detect Sys  tooleec

					# 					detect SYS  
					 
		

#
detect Tooeedec  

					 #	# #	

  			 # #  
 #detectCMD detectCmd
 #detectTool# detect Tooledetecta


 detectCmd  	#	


detectTool detectSys#

		#  
	 # #		# detect SYS  detect CMD
	
 detect To
detectCMD 
  


					 			 #  					   
				#


				

					#	detectCMD 

  #	 			  			
detectTo
	#		 #	

 detectTool		 #


			


 detectToled#


	  				


#  



	

				 	 			 #  		


detect Tool  # detect SYS detect CMDdetect SYS
 # 
		


 detect Tooele
				
#				detect To
					


			  

  

		
detect Sys


# detect Tool  

			#  					

 detectSYS #

 # 						 detectSYS

			 #
 #


detectTool#  	



 detectCmd#		
		detect SYSdetect Tool #
#  detect CMD  					


detect SYS	 



 # 	
			   				

detectCMD		#

					 					#

#
		

				  
  	 #


 detectTool detectSYS
#  
 #


# detectSys# 					
#detect Sys


 #
detectSys# detectToo