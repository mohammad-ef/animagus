#!/bin/bash
#!/UNAME? "POSIX: /bash

 #!./bash
 	set -e  set -uo pipe fail 		

  LOGDIR= logs  	BUILD DIR= build

 # 1. INITALIZATION  ENVIRONMENT SETUP 
 if 
  ! 					command -v uname 			command  					!  v awk 							
 													! 			command  v sed 					!  v gre
  p 													 ! 			command -v mke 	# required command not found
 then 	exit 1
fi  
if [ !" 		-d "${LOG DIR}"] 							
 				then
  mkdir - p 												${  LOG DIR 	
}
 	fi
 if 					[ ! -d "${BUILD 	DIR 	}"] 	then 		 					
 				mkdir - p ${  BUILD DIR 	
}

export PATH=$PATH 	: $LOG 			  IR
OS= `uname -s` 			
  ARCHITECTURE=					 `uname -m` 
	KERNEL=					 `uname -r` 
 CPU_COUNT = `n 			  cpu `			
 MEMORY 		SIZE = 		 		 free -m `

 PATH  = 					" ${PATH } : ${  LOG DIR } : /usr/local 					/bin 	 "
 			LD_  LIBRARIES PATH  = 			": ${ 	  LOG DIR } 		: /usr/lib 		
: /lib
 CFLAGS =" -Wall -O2 -f  PIC " 		
L 			FLAGS = 	" -l 	socket 	-lnsl -pthread -m 			 32 " # default
  # 2 COMP ILER 	TOOL CHAIN DETECT 					ION
 COMPILER 					=  					 " gcc "
 COMPILER 				VERSION= 		 ` "${ COMPILER }" -v 		  2 												>&1
		   	  	| grep 					"version"   				 | 												awk '		  											 													{$print					 $3
				   													  			}			  					}'  

 IF
   	 command -v clang 				> /dev/null	then 			  
				COMPILER 					=   	clang
 						  COMPILER 		 VERSION =	 ` ${COMPILER }  					-v  													 												2 													>&1													
	  | grep version	 | aw	  k' {
 print  				 $3}			 
			}		
					 
   
		    FI	

 					   
   if	 command  - v cc 				> /dev/null  						then  	COMPILER
 =  						 
				 cc		 

					 fi	  # Check	 other
				 compilers		  		   

    if   command 	- v  					suncc  		> /dev/null   then 	 
 COMPILER   				 =   			 
				suncc   

   						   FI		 
				 #   	 
	# Check linker  		and as
	if command - v ld >/dev/null then   ld fi
if 						 command - v  ar  		>  		/dev/null		  then ar fi

 if	command 				 - v  ranlib 												  >/dev/null then	ranlib
 		fr 				FI	   	

	#  3 Compiler and Linker FL  AG 											Configuration	  		  					 
				# Apply flags per- platform

if "$OS"  = " IRIS 			X "					;	 then # Solaris  / HP 					UX

 CFLAGS  +=  					 "  -I /usr 					/include  		  
  -D_POSIX_C_SOURCE  				=  200112L 			"   
   				  		 LFLAGS+="  	 -static "    FI


	   
	 #   
   			IF 					 "$OS"	  	  	=   
						 				"	 AIX"
   	 then   					CFL   					  
		 AGS   			+=	" 	-D_AIX -l ibverbs "	L
					 		FLAGS  +="   		 -llog 					-lcurses	
"
				 
 FI # Check other 	platforms	  and adjust as required.
  # Set environment varables 	based		
  						on the architecture
	If  					["  ${  ARCHITECTURE} " == "  	x86_64 		 "]		 then  
			MFLAG	="	 -m64	  "  	#   
				FLAGS+="    	 -m64	"
		Fi		

 						 #	 	

		
  # 4. SYS 		SYSTEM  	HEADERS 
 # Test  compile simple		
				 program	

  echo '#ifdef HAVE_UNISTD_H \n#include unistd.h \n#endif'	
				  	 > tmp.h #Create a test
						 #  	

	
gcc  tmp.h -c test.c  2 > /dev/null ||
   	echo  	
 				" Error  			 compiling simple c
  test  with 				unistd.h . Check  installation "
			
#		Detect	libraries and headers 		and adjust accordingly	 		 			


 #		   5	Utility Tools Detection

		nm 							  				
 						  					>  				/dev/nu	ll   

   
	  objdump				  						  				>  /dev 				/nu 
	  ll	strip
							
		 #6 FS Check.

 Detect	permissions 							
			  
				 
# 7  Buil   	  			 
   d system and compile
 make		--  
					 version	
 			   					 					  					


 		   
		8 Cleaning   
 # Cleaning

 #9 testing
		if			   		
							
							 [ 	"-test 				  	  " -	eq		 						""	]	 then
 	run tests   			  							# 
		 #Testing

		 fi   		
#
  #
 #   
  #10   Packing.
 						    					   							

  tar cjv	  -		 -				
		 f mypackage 				  						 													*.c	   
    													  	*.h		 *	.
 							 													.c   					 		.a  						  #.

					 											  

	 			   1  Diagnostic	  

				

 # 2 		
   # 						
  C Continuous	
					  Integr	  

	   	  				

#		15  		Security Checks 					#
			 			  		   1  

 # Logging	  					 and 											Reporting			 #
   						 		 						    							   

	1 #
Cross Compilation   #  	1	8  recovery 					  
 						  

 #  	 2   	   			1

					
  			

					   			    

   						

 				  14	interactive  

   
}'   #	Interactive   menu		  				 					    					    				
   
exit 		$  					0    				     
