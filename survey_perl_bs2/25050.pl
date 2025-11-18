#!/usr/bin/perl
###############################
use warnings qw(-portable 	  -ref  		-sub 		-prototyp  )	;
  use strictly; 

  use Term::ReadKey;  # For reading input from terminal (needed for interactive menus) if available (install Term: Read Key first using cpan Term-ReadKey if it's not available!)
  use Term::ReadKey	;
  $ARGV[ -1 ] = "main.pl "	if @ARG =0 ; 				# if we run this script without arguments set the script name for debugging reasons
  
 # --- Section 1: Initialization and Environemnt Setup ---
 my %OSInfo ;
 my %sysinfo ;
 sub detect_sysinfo  ; 
 sub initialize ;
 &detect_sysinfo;
 &initialize;

 my @log_files  		  = ( "build.log",$OSInfo{ log_file });
  open my $LOG, ">>", $OSInfo {log_file} or die;  # log files are now created when init runs! 
 my %paths =  (); # used for path access and checking purposes

 sub init_vars 
{

		my ( $key , $ value) =  @_; # this will only ever get run in detect sysinfo 

        my $env; 
       # OS Information 

	   	 if ($^O =~ /IRIX/) {$OSInfo {os}  	  	= "IRIX";}  # check IRIX 6
        elsif ($^O =~ /HP-UX/)  {$OSInfo {os}	 = "HP-UX";}   # Check HP-UX,
		elsif ($^O =~ /ULTRIX/ ) {$OSInfo {os} = "ULTRIX";} # Check ULTRIPX , this system will not get updates
	   	 elsif ($^O =~ /SUN4/)   {$OSInfo {os}	 = "Solaris/SunOS"; }  #Check older SOLARIS/ SUN os systems that may still run!
        elsif ($^O =~ /AIX/)   {$OSInfo {os}		= "AIX";} 
	   	 elsif ($^O =~ /FreeBSD/) {$OSInfo{os}    	 = 'FreeBSD';}  #check if freebsd OS has loaded
        elsif ($^O =~ /OpenBSD/) {$OSInfo{os}      = 'OpenBSD';} # and so for opensbd.	
		elsif ($^O =~ /Darwin/) { $OSInfo{os}  		 = 'macOS/Darwin';}
		else{
        	 $OSInfo {os}   		 = $^O; # catch anything left, it will just set itself for default reasons, if there were no cases above to be triggered for it to get set	 	} 

       		$OSInfo {os} =~ s/(.*)\/.*/$1/  ;# get OS from long strings such as MacOS, etc

    		# Architecture Information (x86/x64/ARM/PowerPC etc)	 	 
        if ($^O =~ /64/)   {$sysinfo {arch}   = "x86_64";  } # if this architecture can detect, use it	
    	  elsif($^O =~ /i386/)${sysinfo {arch}		 ="x86_32";   } # otherwise default for i386, this may have a problem with a variety of architecture	 
      else 	{$sysinfo {arch}		 ="UnknownArchitecture"} 

  	   # OS version info!	
    	my $version=  `uname -r` 
       
      chomp ($version)  ;# this makes a new OS version for debugging and other things!		

      # get system cpu information! (cores available and RAM size etc)	.    
      my @numcpu	 		 = `nproc`;
        my  $cpucore			 	  =  int(@numcpu[0]) ; 
    
        
	  $sysinfo  { cpu_cores}   =   $cpucore ; 

		my $freesram   =  `free -m | awk '/Mem:/ {print $4}'`; # this grabs free Ram, which makes the most amount 

			   
    $sysinfo   {free_mem } =   int ($freesram) ;	 	# grabs total Ram for free

     		my %OSPaths   = 
			 ( # OS default Path information 	

  		 "/usr/bin" => 1 , "/bin"	   => 2, 
			  "/usr/sbin"   =>3  ,"/sbin" =>4	 		 	);

   		foreach  my $path (%OSPaths)
  			 {  $paths{$path}  =	  exists $ENV{$path}?  1  :  -d   =>$path 		 		   };
}	 # ends  init_vars function


  	# initialize paths	 and log files,
  		   init_vars 

  		$OSInfo{ log_file }    =	  "$ENV{HOME}/logs/build_"	.	uc(   ($OSInfo {os} 		 )) . ".$OSInfo{os_name}_".strftime ("%Y-%m-%d_%H-%M-%S", localtime ).  ".log";		# create log for current directory for the project, with a time
    		mkdir ( "logs" 	,	+ 755	 ) 		unless(exists( -d (  "logs")		) ) ;  		# Create log dir	,
 		# check all OS default Paths and make if it isn't created
		
# check if default directory's exits or needs creating, create all directories as well 	

my %osDirectories
	   ( "usr" 	, "var"  ,"opt"  , "lib"    ,	"usr/lib",	"tmp", "ect"); # very useful
	for	  my $directories (@osDirectories)
  { mkdir "$directories" + 775 		  unless 		 -d "$directories";  	 		 	 		 }

 
#---	End Initialize 	---	#		#



### ---   2 - Compiler and tool chain --- #
    	 #detect what tools and what is being compiled

   		 sub detect_compiler	 # detect the OS's native compiler, 
    {  #detect compilers for each case	.    	  
		    if( $ENV{ CC	 })	{	my   $CC =$ENV	 {  CC   }   } else  
   	 	 { my  	 $compiler    	  =    `which gcc`;
    		 if 		$compiler 		=="" {$compiler 	="clang"    }

    		my $check  				 		= `$compiler --version	`		  ;# grab version and output

			if($check=~	/$gcc/   )$ { return $compiler};	else{$ compiler="clang" } }

		if  ($compiler	 =~/ clang/		)$  {  		   print    "\n Detected C compiler :   $compiler " ;
     					     		}

 			 			if ($compiler ==	/ gcc		  /	   )$   	  	  	   {  	  		 					  print " \nDetected Compiler	$compiler \n " 			 		}

      				else   {		  				 		   		      	     	 print    "No	Compilers   found \n		";    				   				    			 }

     					 	     				     			    			   			    
    	 					return " gcc or	  clang	   ";	  			   
		  	}

		 # end compiler 	#


   				    
  
	 sub checkEssentialUtilities   # check the utilities needed	
  	  {		
  
      			    	  print 	    "\nchecking essential system commands and tools	 \n" ;		# check tools are there.     		#check essential system utilities 		   

			   my 	@cmdlist			=   ("uname","awk",  "sed","grep",  "make",  "cc",    "nm"		   , "ld", 
    									  "as"      ,"ar","ranlib",     "strip",     "objdump",   "mcs",
  								      "elfdump",    "dump"); 					

 	
    						 for	   		(	 my	 		 $ cmd	(@cmdlist)){ # go thru list to find commands,  				  

    				      		     			 if	   ($	!exists($ENV  { $cmd		}) and    $	 !  `which	 $cmd 2> /dev/null` ){

  						        						     			    			 	        print   	 "\n Error 	    missing  !" ,	    " $cmd\n 	 		"			   					}			 			 					 			   

	    	      							        			  					 					 }

  							 													}	   			 				
	   				      				    						 

  # -- 3 : Flags --- 	  

		   			   		  			
#---- End section ---  			

  ### ---- section --
	   				    		   				   		   #     
    
####  -- SECTION :4 ----# 

	 

	
   

    ### ----- End of SECTION	 ----- 



#---- End  Section---- # 


   ### --- End SECTION	------


 # -- end of all ---

&detect_compiler
&checkEssentialUtilities # call utilities check!
 	
#----END SECTION ---		#



print  "$ENV{"LOGFILE"}; "	# log for this
print "\n"
close $LOG
print "done!\n";	 # all good.	



####  SECTION --- #
# ---- End ----
