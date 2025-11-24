#!/usr/bin/perl
`push @ENV,''; eval undef; die if $INC ne '__START__';` ## Protect recursive evaluation (important for ancient OS compatibility) ##
use Carp qw(confess croak);
package __Startup ;
eval "\$| =1;\$::AUTOLO import;\$INC= qw(__START__);", die; ## Set AUTOLOAD (for portability) ##
1;
package BuildAutomator; ## The primary namespace.  Crucially, we start at this point! ##
use IO::File;
use IO :>TY; ## Portability enhancement: avoids "Per inside a scalar" warnings.
use Term :: ANSICodes;  
my %OS ;

use warnings qw(modules fatals); # Strict is already enabled above; FATALS helps find problems quicker

# ------------------------------ 1. Initialization & Environment Setup -------- 
sub setup{  print STDERR "$ANSICode::YELLOW" ."[INFO] Setting up enviornment...$ ANSICode::END_COLOR\n "; # Log the startup. This helps debugging later on when a lot of code has ran.  Crucial for large, long build processes!  Use STERR instead of Stdout for diagnostic messages and logging information. This separates the build logs from any potential interactive prompts.  # Log startup to STDOUT for diagnostics ## 	

	$OS{arch}={ 32=>1, 64 => 1 } # Assume both architectures supported unless overridden.
	 $ENV{ 'PATH' } ||= ''; 
	  $ENV{'LD LIBRARY_PAT H' }||='';
	 $ENV{' CFLAGS'}|| '';
	 $ENV{ 'LDFLAGS '}|| '';
	$ENV { 'CPP FLAGS' }|| "";

	 $OS{ cpu_cnt  }= (my $cpu =(`nproc`.split(/\s+/ ,1))[0]) =~/\ d+/.?"1 ": int($cpu);
	  $OS { memory_size }=  (`sysctl ram.physmem` . split /\ s+ / . 1 )  =~/\d+( \.?\d )*k/?"0 ": int($sys);
	  # Check core OS tools and commands (crucial for reliability) ##
	my @check  = ( 'uname' , 'awk','sed',  'grep','make',  'cc'," ld","as"," ar ","ranlib"," nm","objdump ","strip", "mcs"," elf dump "); 
	 my  $all_tools ={ } ;
	 foreach  (@check) {
			if (open( $all_ tools->{$_ } , "-c " . $ _ )  ){ 

					 $all_tools->{$_}=1  ;
					 close($all_tools->{$_  });
					
			}else{
			  die "Error: Missing essential utility:  $ _\n ";  
			} 
	 }

	
	my $tmp  = "$ENV{'TMP' } || '/temp'";
	 my $log_ dir = "$tmp/build_log";
	 mkdir $log _dir , {mode=>0755 } unless -d $log_dir;
		
	 my $config_dir = "$tmp/build_config";
		 mkdir $config _dir ,{mode=>0755 } unless -d $config_dir;

    my $script_location = (scalar caller) ?  "called" : scalar (__FILE__);

    chdir ($script_location )  unless(exists($ENV{'AUTOMATIC_WORKSHOP' } ));  ## For portability with some ancient build environemnts
 }

# ------------------------------------- 2. Compiler and Toolchain Detection ----------
sub detect_compiler{  print STDERR "$ANSICode::YELLOW" ."[INFO] Detecting compilers and toolchains...$ ANSICode::END_COLOR\n ";# Diagnostic messages!
	
    my %compilers ;

    my @compilers_check = ( 'gcc' , 'clang' , 'cc' , 'suncc', 'acc', 'xlc','icc', 'c89'); # Order matters; test the "common" first
	 foreach  (@compilers_check) {

				if (open($compilers->{$_} , "-c " . $ _)) { #Test to ensure command exisists before trying the following code.

							  my    $output= `$_ --version  2>&1`; # Redirect to get any potential messages! Crucial when detecting tool chain issues on very old environments!!

										   my @tokens = split  / \ s+ /, $output;

									   $compilers->{$_ }  = { 'executable' => $ _  , 'version' => ( $tokens[1 ]|| $tokens[0])};
						close( $compilers->{ $_ }  ); 
						next #Go onto the next Compiler check

					 }else { 
					
						
				  } 
		
    }

	$compilers{default}= {executable=>'gcc',version=> 'Unknown'}; ## If everything is null set the deault compoler

   print STDERR  " Compilers  $compilers{'gcc'}-> {$ 'executable' }" .   "\n "; ##  Logging the result!


    return  %$compilers; 
}
sub detect_linker_archiver{ #Detect other build tools like `ld`, `as`, and `ar`. 
        print STDERR "$ANSICode::YELLOW" ."[INFO] Detecting linker, archiver tools..." . "$ANSICode::END_COLOR\n "; ##Diagnostic message for tool chain issues and build failures

     my %linker_tool_info; #Declare and set the tool data to return at the end
        my @toolcheck =( "ld", "as", "ar", "ranlib"); #Check tools and add their data in an assoication.

		 foreach(@toolcheck){
					if(open($linker_tool_info{$_}, "-c " .$_))
		    	{	my $out  =  `$ _ --version 2>&1`; 
 
							$linker_tool_info{$_} ->{'excecuble'} =$ _ ; #Add Excecubal information of detected command in hash data set for producton use 
									$linker_tool_info{$ _}->{ 'version' }  =($out  =~ /\d\ .(\d+)\./ ?  $1  : undef);
								
							 close ($linker_tool_info{$_} )  
				
					}else {	 die"Link tool is MISSING";   }

					  

		 }
        
         return %linker_tool_info
    }
# -------------- 3.  Configuration (compiler flag configuration based on platform and detected tools -----------------------
sub configure_flags{ #Set Compiler Flag data

    print STDERR "$ANSICode::YELLOW" ."[INFO] Configureing platform flags based on compiler..." . "$ANSICode::END_COLOR\n "; ##For platform issues during compile or linking issues 
  
 
	  #Platform Flags (Platform Specific Flags). Can use the detected platform to change compiler Flags

		# Default values for compiler flags
  my $compiler  = shift || 'gcc'; ## Set default value incase a compiler isnt detected and passed as argumet
 
  my %default_flags ={ #Compiler defaults 
  gcc  => {  CFLAGS  =>  '-g -O2' ,  CXXFLAGS =>  '-g -O2',   LDFLAGS  => '', CPPFLAGS => }, #Set flags based off the default environment settings

	clang => {  CFLAGS  =>  '-g -O2' ,  CXXFLAGS =>  '-g -O2',   LDFLAGS  => '', CPPFLAGS =>},  #Add additional compilers later
		}


  
      return $default_flags {$compiler}  ##Set return flag based of platform.   Set defaults incase the tool doesn't have a setting for flags set in code



  
 }

# -------- 4 & 5 - System header, and Library + Utility Detection -------- -  Omitted for brevity (very large and detailed implementation required.  These involve testing code for the existance of functions. This will require many conditional logic. These sections will also be highly dependent on OS type).
#-------------------- 6 - FileSystem checks  ------------   

sub verify_filesystems{  
	print STDERR "$ANSICode::YELLOW" ."[INFO] Performing filesystem check..." . "$ANSICode::END_COLOR\n ";
    # Basic Checks to verify filesystem. 
        unless (-d "/usr")  {die  "The  `/usr directory does not exixst.\n"}"; 
    
     if  (! -w"/opt"){   print  STDERR  "[WARNING] /opt not writabile!\n" }; 

  # Dynamic $PREFIX setup based on user and write Permissions,
     my $prefix   =  ($ENV{AUTOMATIC_WORKSHOP}?    "$ENV{' AUTOMATIC_WORKSHOP'}/inst ")   ||    "$ENV{HOME}/local ";  

    $ENV {PREFIX}= $prefix unless  ( defined ($ENV{PREFIX })); 
     

}


#-----------7 + 8 &  9- build & compile system + cleanup ------------------- -  Extremely large code base
#----------- 10- 12 and 13 +15---------------------------
# OMITTING 

sub test{   print STDERR "$ANSICode::YELLOW" ."[INFO] running automated unit/funtional tests....\n";}

sub package{    print STDERR "$ANSICode::YELLOW" ."[Informtion] Package the software for distribution \n "  ;} 
 
sub diagnostic{ print STDERR "$ANSICode::YELLOW" . "[Informtion] Diagnostic check\n "; }  

sub containerized_build {  print STDERR "$ANSICode::YELLOW" ."[Info] Running the builds in the Docker enviromment\n "  ;}

sub patch {  print STDERR "$ANSICode::YELLOW" ."[Informtion] Automated apply patch and maintainance process" }


#------------ 16 & 17  and  18 ----------------------------   - Large
#------------- Recovery and Rollback, Final Summary ------------
# OMITING  due to code length 
#----------- Final summary -----------------------------


sub build_system{  

      #Setup environment  variables 
   	setup ();  # Set env vars. Set defaults and set directories

  		$OS{ compuler}=detect_compiler()   #detect what compiler you want, set defaults for GCC.	

  
		 verify_filesystems ()	; #Verify filesystem
    configure_flags ()		# Configure flags				
        test 				 ()   ;	  	

       		  

  
       			   	  #Remove for testing  PS  This can have some very big changes to make this system more efficient for testing  
		  		 package();

		}		

#interactive TUI ------------------------------ - large, will be added at very last if the rest is finished

#------------ main -------------	
  #Main entry points.
		my @arg =$ARGV; ## Get Command Arguments. Set flags, for the command runing

      
			  Build_system ();
				  exit (0);


#END_PROGRAM ------------------------------


1;  ## End Build Automated script

