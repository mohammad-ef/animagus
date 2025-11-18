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

# ---

 detect CMD	

#detectSys

detectSys # detectTool 					 				 			#---

detectCMD#
-----------------------	#----------------------#
 #detectCMD #
# detectSYS  detect SYS #	detect CMD # 				------------------------#
#
---		 			 #detect SYS # detect Tool

 detectTool 

 					 #--- 			
 detectCMDdetect CMD  detectSys #
 detect SYS	 # detect TooldetectSys#
 detectSys		---#
---------------------#detectSYSdetectSys  
detect Tool

detect SYS		

		

#

----------------------detectSYS# detectTool#		  		

---------------------------	#-----
----------------------	

 detect Sys detectSysdetect SysdetectTool  				

 			

		-------------------------- detect Tool		detect Tool detectTool #

# detect SYS#--- 	 #--------------------------#-----			detect Tool
 # detect Sys#
  
	  ----------------------  		detect SYS #
 ---------------------- detect CMD
		

detect Sys #-----		# detect CMD	  

------------------------------------- detectTool #-----			detect Sys	

  -----------------------  		  
 detectCmd		 detect CMD		# 	------------------------- detect SYS  		 detect SYS 		 detectSYS
   ------------------- # #

---detectTool  ---	---detectCmd  ----		 detectCmddetect Sys		#detectSysdetect CMD detectSys		detectTool
 

detectCMD 		  detectSys		---#--- detect Cmd  detectTool 			 #---  
		detect Tool	 # detectSys 	 detectTool	
		

--------------------#	 #

 #-----		

  ---#------------------
 # detectSYS		#---------------------------------------document
									 			#

# --- 

 # detect CMD  detect Tool# detectTool  

 # 

------------------------# 		 	  
detect CMD  			#-----  	 
detect SysdetectTool		#---

# detect CMD #--- #------------------------ #	---detect Tool #-----detect CMD

detectTool detect Sys

#----- #detectCMDdetectSys	------------------------ # 				 				detectSys 	#-----	 detectCMDdetect SYS	 
#---  # 		---

 				detect SYS # 
 detectCmd 



------------------------		
  ------------------	 #---#
  			detect SYS 				
-------------------- detect CMD detect CMD	detect SYS
 				 #	#--- ---
 detect CMD			
	---		----------------------
#	
		-----#	
-------------------- detectTooldetectSys		detectTooldetectCmd

  		detect Tool
 #----- detect CMD		---

------------------------- 

 		 #
---#----------------------------------------  		
  	#				 detectSys detect SYS#

---	 detectCMD

 
 

---
 detectCMDdetectCmd
 
 ---detectSys detectSys #detect Tool
#

#------------------------------------------ detect Tool		 detectSYS		---#detect Tool		 detect SysdetectSYS ---detectTool  detectCMD #detectTool 	----------------------------------- detectTooldetect Algorithmn

-------------------
detect TooldetectSys #detectCMD detectSYS #--- #	 		detectTooldetect Tool #----- 			

 #--------------------------
#-----
#-----		

#detectTool 
	#
	--------------------- detect Sys	 
		

---
detect CMD

  detect SysdetectCmd			
---		 #

  				 #
detect CMD

------------------
  	 # -----------------------detectCMD	

------------------------------------------		 				  				

---

		 
 #---  #	------------------------- detect TooldetectSys detect Sys	 detect SYS  detectSYS  		 detectCmd	 #	  ---  				
---------------------- #-----		---

				 			# detect SYS

  		# detect SYS 
#-------------------------------------- #----- detectCmd
#detect Sys #		
	

------------------------#---
 detect TooldetectSYS #--------------------------  		

  #detect Tool #-----
	 #	  detect Sys#----- #-----------------------------------#
#----- 			
 detect Tool #---		detectSYS	---	#---

 		

  	---

  detect SYS  	

 # 				 # 

 # 
 ----------------------  ------------------	 #----# -----------------------	detect TooldetectAlgorithmndetect Tool		detect Tool #
		  #		---
------------------------

	 detect CMD		
 detect SYS
---

 detectSys detect SYS#--------------------------  #	------------------ detect Sys detectCMD	# detectSys	---#-----------------------		detectTool  

detectLocaTool 				  					 #		
				detectSys #-----

------------------------ detectCmd #		  			#detectCMD		----------------------
---	

--- #
	 #--- detect TooldetectSys # 
detectTool
 detectTooldetect SYS

--------------------		  	---detectSYS		#
#------------------- # 	---

----

 
 #	  	

					   		   		------------------------- detect TooldetectSys#		detectCMD	#detectCmd	
# detectTooldetect Tool #
  -------------------------
detectTooldetect Algorithm#detectSYSdetectTool
-------------------------- detectSYS
detectCmd

#		 #-----
#
---		---#----- detect TooldetectAlgorithm	
--------------------#

detectSYS
 detect Sys		detectSys	

	detectSys	#
 # 

 #
 	 		---detect Tool detect TooldetectSys	#	

 ------------------- 

detect Sys		 #detectTool		
	 #----- #

--------------------

	 #detect CMD
detect Sys

#

---		 # detect CMD
		 detectSys# 
 # detectTool		 detectCMD
  		 			 # 

 	detectTooldetect Algorithmm

		  			#	

------------------ 

detect SYSdetect Sys		
			------------------------		 

---#----- detectTooldetect Algorithm		 # 			--- 	detectTooldetectAlgorithm
---	detectCmd
detectCMD 			 	#

detectCmddetect Sys #		 	#
 

detect SYS# ------------------------ 		  			 

	 detect TooldetectAlgorithmm#-------------------

----------------------detectSys# detectCmd detect Sys  	---------------------		

	  #	---	---------------------------		  				 detectSYS#detect CMD 
 #------------------ 
 					
--- 					  # 			

			----------------------------------------		detect Sysdetect Cmd#detect Sys
---------------------#---------------------#	detect SYS

 	detect TooldetectSYS # 	 detect Sys		  detect Sys
---------------------
--------------------------# detect CMD#-----	detectCmd
------------------------

 	detectSYSdetect Tooldetect Algorithm			---			 				 # 		
detect Sys		---

  					---

		

  			 detect Sys

detect SYS  
 #----- 		 
# 
-------------------- 		# 					
 detect CMD  					 			# detectCmd detectTooldetect  	

		#------------------ detectSYS 
 #		  		 detect CMD#

 detect Tool #

		 # detectCmd
 detectCMD	 detect Tool		----------------------detect TooldetectAlgorithmmmm		
  

		#---------------------
		  -------------------- # 		  			detect CMD  detect Sys		 detectCMD		

	------------------- 				#
	 #		#
 detect SYS#

detect Tooldetect Algorithm

 	
#

detectSYS

#---#detectTool #

--- detectSYS# 	

-------------------

detectSys
 	
#-------------------------  

--- 			detect Tooldetect Algo		#					
 # detectCmd#---detect CMD	---

 ----------------------------------- #-----detectCMD
 

detect SYS	--- #detect Tool

 detect Tooldetect Sys detect Tool 			 # detectTooldetect Alg 		----------------------------------	
 #
  #
 detectSYS
  

-----------------------
 # 	 	

detectCmd detect CMD

		------------------------ detectTool #

		 #--------------------  # 		---	
detect Sys

 detectSYS  
detect CMDdetect TooldetectSYS 			
 detectCmd	 
#---detectTool	detect Tool detectTooldetectAlgorithm		#	 #-----	
 

  --------------------		 #detectTool

 #		 #
--------------------------	

detectCMD #	#		#---

 detect Tooldetect Algorithmt 

detectSYS#

		 -------------------detectSYS 			--- #------------------	 detectCMD#
 #

 --------------------- #	detectCmddetect Sys 

--- #--- #

 					  	--- # 			

 detectTooldetectAlgorith
 			#

detectCmd	  ------------------- #
	

 detect Tooldetect  	---		detectSys #-----#

  detectSys	detect Tool# detectSys # detect SYS		 -------------------------  			

----
  		detect Tool  

	 # 
--------------------- detectSys		# 			detectCmd# 					 	 detect TooldetectAlgor	#--- 					---

---  

detect CMD detect Tool # 
 detect Tooldetectsys detect CMDdetect Sys
 detect Sys

	#

 detectCMDdetect SYS		#

  -------------	
		

detectCMD 	 detect Sys 	
	-------------------------

	# detect SYS 		

 detectTooldetectAlgor  				detect SYS #----------------------- 	 detect Tooldtecc Sys	detectSys  				

	  			
 # 		#---#		

detectCmd 		

#	---
		
  
 			------------------- detect Tool

------------------------- 

#

	#---		

		 detect CMD
	--------------- #--- 				
------------------------  

#detectSYS  			

detect Tool	 			 			  		

	detectSys 	
detect Tool#	 #		  			  --------------------- 		-----------------------detect SYS 					detectSYS

#

		 detect SYS #detectSYS		  				 detectSYS 
	

---	

#

		detectSYS

 detectCMD	  
		#

	--------------------- #

#-----
	 # detectCMD	 #
		#

 detect Tool		 # detectCmd 
detect SYS		

---

----------------------		 	 detect TooldetectSys detectCmd
 #---  	

detect Tool		detect CMD#detect SYS
	 			 		detectSys	--- #		detectSYS detectCMD#detect CMDdetect Sys
 ---  	 #detect Sys detect Tooldetect SYS
 detect Tool #-------------
 #------------------ 	---#--- detectTool	
 		 detectCmd #		  # 

---
---

 detect CMD#	----------------------	  				 detectSYS 

#detect TooldetectAlgorithm	  			 detectTool 	 detectCMD detect Sys		detect SYS

---  detectCmd	

 			#-----  	detect SYS detectSYS 

------------------------detect SYS detectSys # detect Sys#

detectCmd  

 #		 detect SYS detect Tool	

 ----------------------- 	 detect Tool

------------------------ #
	 				detectCMD # 	
---  				  			

 #
 					 	#---detect Sys
		 #-----		 detect SYS detect Tool # detectCMD

		detectSYS	-----------------------detectTool#-----
#	--- #

------------------

		 detectCMD		#
 #		 				detect Tool detect CMD
#
---# detect Sys
	detect Tool #detectSys detect Tooldetect SYS

		

---

 detectSys  

		

 detect SYS # detectCmd		  ------------------------ #	  		

  --- detect SYS 					detect SYS detectCmddetectSYSdetect Tool 

----------------------detect Sys

 #detect SYS#	 ---------- detectCmd
		detectCmd		---  	 					detect CMD
 #-----
		---
		# ---------------- ---------		
 

------------------------------------------  	---
----------------------

 
  --------------------------detectCmd#		 detect Tooldetectsys		

#		-----------------------  				 		 				---#
						
 detect Sys #

detectSYS 
 #		 		

		----------------------------		detect SYS  detectSys	 detect Sys detect SysdetectCmd		-----------------------------------

  				 detectSys#		 detect Tool detect Sys	detectCMD #-----		 detect Tool
 
  			 #---  			 #
  		detectSys	#detect CMD
#detect Sys #--------------------------

 	

		#detect SYS#detect Sys

		 detectCMD 					detectCMD  		 detect Tool 				detectCMDdetect SYS	
 #------------------detectSys	 #
 detectSYS detect Sys detectSYS #detectSys		 					 	 detect Tool #

---		 					detect Tool
	 
------------------------#---------------------

 #

		--- detect Tooldetect sys detectCmd detect SYS	
  					 #
-------------------detectCMD#-------------------

  	 detect Tooldetectsys

		  ----------------------		 #

		 				

 # 					 			---detectSYS#
------------------------#	 #----- detectCMD		 			 
  detect CMD

#---  					-------------------	--------------------#-------------------- detect CMD  					detectSYS 		---		 detectSYS #---

	

#	
 #	---------------------detectTool

 detect Sys		 #------------------  					

#		 				detectTool detect Tool

	---

---
	---
	 #-----	 
 # 
#-----  			detect SYS	detectSys detectCmd	detectCmd 				  #-------------------------- 				---------------------	  #	----------------------  

 detect Sys#------------------- 		# detectSys#------------------		 				#---  
 #---
----------------------

--------------------------		 #----- #
		#detectSysdetectCmd 

#
 detect CMDdetect Tool		 detectCMD
---detectCmd# detectCMD  				------------------	 

detect Sys		
	
 #detect TooldetectSys #------------------	  

	
		---detect SYS	#---#	  

 detect Tool#

 detect Tool

# 

 detect Tooldetect Algorithm

 					#		  

-------------------

 detectCMD
	detectTool
 					  		 		

 

 

---		
  ------------------------------------------  
detect Tooldetect Sys		 #

 

detectSYS#	detect Sys #--- detect Tool# detectTool		  		  		
  		

  				-------------------------

 detectTooldetectSys #detect Tool #-----------------------detectTool detect Tooldetect Sys detectCMD#
 ------------------- 			 #

-------------------------		
 	  			#--------------------- detect SysdetectCmd  ------------------detect TooldetectionAlgorithm
 # 				 

detectSysdetectCMD
#
 detect CMD	# 					--------------------- detect CMD #detect Tool
detect Tool		---  				detect Sys # 
detectSYS		
 detect TooldetectSYS
---------------------- detectCmd#

 detect Sys detect SYS  			---  detect SYS		
  			---

 	  

---

 		
 		# detectCmd #----- detectSys#		# detect TooldownAlgorithm	#	 #		 #detect Tooldown Sys#
-------------------------

detectTool detect Tool

		

 ----------------------  -------------------
 #
---------------------  detectCmd

#-------------------------- 	------------------ 			 detectSYS		---		 detectCmd detect SYS#------------------------ #

  #
 

  			 #---
-------------------detectCMDdetect Tool	---------------------------------------

 detectSys  detectTool detect SYSdetectSys detectSys	----------------------  detectCMD

 ------------------------ 				

 detect TooldownSy

detectTool #---# --------------------------------------- #		 ------------------------------------------
--------------------------  ---		  				---detectCMD
detectSys

#		#-----

---------------------- #		

----------------------	#----- # detectCMD
 					--- 				

  				 		  #

-------------------- 
  detectTooldownAlgori			detectTooldown

  

 detectTooldown 

 detectCmd 					

 detectTooldown detection#-----  

	--------------------- #----- 				
#

 					#	  ---detectSysdetectTool  		 	 #

 detectTool		

 #detect Tool detectSYS

detectSys  

	

-------------------- 

 #
 					 detect Tool 		-------------------------detectCmd

  	 detectTooldownSysdetectCmddetectTool
	

 #---

------------------  --------------------	detect Tool#		--- #detect Sys	----------------------- detectCmd#---  detect Sys # detectSYS

	

 #---

		 # detectSys		#

#-----  #-----#---  #detectCMD 					 detectCmd#-----detectCMDdetect SYS 	  			  

  		detect Sys detectTool  	  ----------------ready---------------------# 
 detect TooldownSy	
 detect Tool detectCmd
----------------------------detectCMD		  				  

#--- ------------------		

  		# detect Tool	 #-------------------------- detectTooldownSysDetectCmd

# detectCMD #

		 detectSysdetect Sys
---		---

---------------------------------------

 detectSys detectCmd

		 #detect Tooldown Algorithm

 detect Sys #		
 #-----detect TooldownSy detectCmd  detect SYS 

		
 detectCMD#-----

	  			 #
-------------------detect SYS detectCMD detectCMD

 		

 

---------------------- #

		---		detectSys	
 	 detectTool

 detectSys #--------------------- 
 #
# ------------------------------------	

# 
------------------------  			

#

-------------------- detect SYS  				 					  
-------------------

 #------------------

 detectTooldown detectiondetect Sys detect SYSdetectTool 

	--------------------- #

 ------------------------	 		
 -----------------------detect Tooldown

	 ----------------------- 

--------------------------------------- detectSYSdetectTooldetect

 #------------------------- 				

		---		detectSYS#
detect SYS detectTooldown Sysdetect CMD#

		# detect Tool# 

 ------------------detectSYS#-  # 				 detectSys 	 	detect SysdetectSYS detect TooldownSy 					detectTool 

detectTooldown#
 #------------------------
		--------------------------  
		  

 

detect Sys detect SYS  detectCmd 				 detectCMD detect Sys	#--------------------------------------- #--- #		-# ----------------------- detectTooldown --------------------
---		
  #	------------------detectSYS

---

 detect Tool
------------------------	 #

 detectTool 

# detectTooldownSy  			 		 		#----- #-----  	---#detect TooldetectSy# -------------------		detectCmd

---#

 detect Sys
 #	 # detect Sys #detectCmddetectCMD

detectSys #detectSys	

		detect Sys  		#	detect Sys

 detect Sys  				  detectSys  

detect SYS 

#

 #detect SYS  					  detect Sys#-----
---------------------

 #
	#		-------------------  			 

------------------  
#-----		--------------------- #
	
		---------------------detectTooldetectSYS		detectCmd  					
		

  detectTooldown detection  detectCmd  detect SYS
#-----#----- #detectSYS  	

---
---------------------#--------------------- 		detectTool		 detectCMD #--- 	--- detect SYS

---		 #
#---	 

 #-----

 detectSYS
#-----

  				detectCMD #	 #-----
  		
	-----------------------------------

#-----#detectTooldown  	--------------------- 			  
	 #--- #detectCmd 					 				 	

---  detect SYS

		---		# detectSys#-----
 
-------------------- detectCmddetectSYS	  			 detectCMD  
 detect Tool #---

--------------------		 detect Tool 
detectSYSdetectSys
		#		 detectTooldown
 detectCmd

----------------------- #---#detectTooldetectSYS		------------------------#---# detect Sys 		---------------------		  

# 	detect TooldownSys # detectTooldown detection		 detect CMD	  					---  -------------------

		 -------------------detect Tooldown#---  		 detect Tool detectTooldownSydetectCmd#detect CMD

 #
	

 detectCmd

---
---
----------------------#
---  			

-------------------#

--------------------

 #

 #---#
 #

		

	 ---------------------detectCmd detect SYS 				
 detectSys -------------------------		 #
 detect Tool#	

--- detect Tool# 		------	-----------------------

--- #--- #---

  		# detect Tooldown detection	---------------------- detectCmd
------------------------- #-----		--- # 

 #

 ---------------  ---detect Sys # detectCmd  

------------------------------------		---

------------------
#---------------- #detectSYS#------------------
 			#detectSYS		detectSYS

		--- #---------------------

-------------------
  ---------------------  			  				

 # 					---# detectSYS #
----------------end of build 

detectSYS#

# 
  
		 detect SYS# ----------------------- 		 #----- detectCMD		
 #-----detectedSYS		

		

---
	# detectSys

  
--- # detecting Sys#--------------------  		detectSys

 #
------------------------

 #

---		 # --------------------
 #

 #		

-----------------------

 					 	 # 	 #detectSysdetectSys #------------------------

 detectTooldown#

  

# detectSYS		 #		
 
#---
 #-----detect Tool 					

-------------------detectSYS #	 			# 
 			  detectCMD

detectCMD
 detect Sys
	 detectCmd detect Sys	detectTool	

 #	

detectTooldetectAlgori		#---

 			 detectSYS		 detectSYS#
  ------------------------
 # 					---

		-------------------

		

#--- #		 detect Tool		
  		 # ------------------------detectTool  	  #detect Tooldown detection

detectSys detect Sys

--------------------		

---------------------
	  	  

 #		detect Tool		 detectSYSdetect SYS 					 detectCmddetectTooldownSys 				 

	 		detectTooldown 			 #------------------------- # detectTooldown  					
 
------------------------
 			 					 
  			#

		------------------- #

 #detectCMD 					----------------------		

 ------ #-----#		#-----------------------#	 detectTooldown# detectSys detect Sys  ---------------------  
	

	 					  
		--- 	  

		 detect Sys #---#---
#-----------------------	---	# 			detectCMD

  #detectTool detect SYS	------------------------------  --------------------detectTooldownSys	 detectTool
		#----- #-----detect Tool 		 #	------------------

 #---------------------detect SYS

detect Tooldown  			

 detect Tool		detectCMD	 			detectTooldetectSy
 detect SYS detectCMD		# 	 

	-------------------  














 ----------------------------------detectSysdetectSys detect Tool	---  #--- #-----------------------
#---#-----	 ---------------------- #

  ------------------- detect SYS  	detect SYS	 # 					---------------------

--- 		 detectSYS #		
		---  --------------------------
 detectSys	
 detect Sys#

  -----------------------  

 #	 

#-----		 		
	---		 #
 		 
	
  			 					
	 detect SYS #detect SYSdetectTooldown #detect Sys  					detectSYS
detectCmd	 #---		 	------------------#

------------------ detect Sys		 #------------------
		
-------------------------- # detectTooldetectSys #detectCmd
		 
 
 		 #		---	
		  
 # 		

#-----		#	

 detectCmd 			#
#-----

 	
  					--- #

 detect Sys  detect Sys#detect Tool

detectCmddetect Tool	 #-----------------------
	  				detect Sys		  

	

		 					end# detectCmd  

 detect TooldetectSys	--- 					

---