#!/usr/bin/perl
###############################
use warnings qw(-portable 	  -ref -l -strict -mixed -once );
  use strict;

	#Modules required for the script to perform.
	  sub load_module {
		 my ($module_name)  = @_; #Name of required package/ module needed.


		 eval { require($module_ name);//Try to execute the command. if it succeeds it continues
		 };
		 if (($@ ) ){ #Check for failure, error.
			print "Error loading Module: $module_name  - $ (@)\ \n ";
			exit  10 ;
		 }
	}


	# Load required modules
	load_module("Term::ReadLine");
	load_module ("Term::ANSIColor"); #for colored terminal output if supported
	load_module("Digest::SHA");  #for generating checksums.
	load module("File::Find");//To check file systems.

	#--- 1. INITIALIZATION and ENVIRONMENT SETUP ---
  my $os = `uname`;
  chomp $os;

  my $kernel = `uname -r`;
  chomp $kernel;

  my $arch = `uname -m`;
  chomp $arch;

  my $cpu_count = `nproc`;
  chomp $cpu_count;
	if(not defined($cpu_count)){ # If `nproc` failed use alternative way of obtaining information
	  $cpu_count = `cat /proc/cpuinfo | grep "cpu cores" | awk '{print $NF}' `;
		chomp $cpu_count;
		if (not defined $cpu_count ){
		 $cpu_count=  `cat /proc/config.gz | grep 'nr_cpu' | awk -F = '{print $2}' | awk -F ' ' '{print $1}'` 	
		 }

		 if (not defined $cpu_count)
		 {	 # fallback method
		 	 $cpu_count = `cat /proc/cpuinfo | grep "processor" | wc -l`;
			chomp $cpu_count;
		 }

	}
   #Error check on obtaining count

   my $mem = `free | awk '/Mem:/ {print $2}'`; #Total Memory
  chomp $mem;


  #Essential command checks- if commands missing the system does not satisfy requirement
	unless (-x "/usr/bin/uname") {die "uname command missing!";}
  unless (-x "/usr/bin/awk") {die "awk command missing!";}
  unless (-x "/usr/bin/sed") {die "sed command missing!";}
  unless (-x "/usr/bin/grep") {die "grep command missing!";}
  unless (-x "/usr/bin/make") {die "make command missing!";}
  unless (-x "/usr/bin/cc")  {die "cc command missing!";}



	if($os=~ /AIX/){
		$PATH="/usr/sbin:/usr/bin:/usr/ccs/bin:$PATH";
		$LD_LIBRARY_PATH="/usr/lib:/usr/lib64:$LD_LIBRARY_PATH";
	}

  #normalize.   Add these variables.
  my $TMPDIR="/tmp";

	if ( !-d $TMPDIR ){ #create /tmp folder. if doesn't exits

			 mkdir $TMPDIR or die "cannot create tmp dir $TMPDIR"
		 # chmod 0777  $TMPDIR;
	}


	my $LOGDIR="$TMPDIR/build_logs";
    if( !exists($ENV{'LOGDIR'}) )  {

  mkdir $LOGDIR or die "could not create dir"
   }


#---- End Section ---
#--- 2. Compile & Toolchain ---

  sub detect_compiler{

		 my ($candidate_compiler)=@_; #candidate name

		 return (1, $candidate_compiler ) if  -x  "/usr/bin/$candidate_compiler";
			return (0, "" ); #Not present in /usr/bin directory
	}

  my($compile_status, $gcc)= detect_compiler("gcc");
	my($compile_status_clang, $clang )= detect_compiler("clang");
  my($compile_status_cc, $cc )= detect_compiler("cc");
   my($compile_status_suncc, $suncc )= detect_compiler("suncc");


#--- end Compiler Detection

  #--- 3. Flag Configuration ---

 my @cflags;
 my @cppflags;
 my @ldflags;
 my @cxxfags; #CXX
 my %env = (%ENV);  #Make it read writeable to the scope


	if (  $os=~ /AIX/){ #Platform-Specific Options. This is for portability.
	 $CFLAGS = "-g -O2  -DAIX -D_AIX -I/usr/include  "; #Define environment flag and options for portability
	 $CXXFLAGS = $CFLAGS ;
	 $LDFLAGS = "-lstat -lsect  ";

	} else { # Default flags. Can expand later with different flags based on platform.
  $CFLAGS  = "-g -O2 ";  #Debugging + optimized for general build process
   $CXXFLAGS = "-std=c++11 -g -O2  "; #Use standard and options if it compiles.
    $LDFLAGS ="-lpthread";  #Common link
		 $CPPFLAGS="-I./include -I$ENV{includedir} -I/usr/include "; #Include paths
		 }


	 #---- END Section

  #--- 4. Header and Libs detection---
 sub detect_lib_and_headers {

		#Small hello program that uses headers/ libraries. To be complied/ tested

	#Simple hello code

    my $check_program = "$TMPDIR/check_libs.c";

     open my $fh, ">", $check_program or die "Couldn't create program $check_program : $!\n";

	print $fh <<'CHECKPROGRAM';
		#include <stdio.h>
		#include <stdlib.h>
		#include <unistd.h>
		#include <sys/stat.h>

	int main() {
			 printf("Hello world from build\n");
			 return 0;
	}
	CHECKPROGRAM

	close $fh;
#Compiler command with output/ error redirect, for detection purpose

    my $command= "cc $check_program -o $TMPDIR/check_libstest -Wall";
		my ($compiled, $stdout, $stderr)=qx($command 2>&1 );  #Execute compile/ command.


    if ($compiled!=0 ){

      print  "Error:  Compile/Libraries missing $stderr  \n"
       return 0 ; #Indicates an error/ fail.
	 }
	 else {
			 return 1;  #Compilation was ok. Indicate Libraries found.
	 }

}

 my ($header_and_libs)= detect_lib_and_headers();
  # --- end Header section----
  # 5 - Utilities

	sub detect_utility { #Check the existences and availability for the given utility/tool name.
  	  my($candidate_utility)=@_; #utility
       return 1 if (-x "/usr/bin/".$candidate_utility );
        return 0 ; #Return zero. Means utility Not exist
  }


 detect_utility ("nm");
detect_utility ("objdump");
 detect_utility ("strip");
   detect_utility ("ar");
      detect_utility ("size");
# --- 6 filesystem

 sub  check_dirs{ #Verify exist of essential folder to run this code and perform.
 my (@folder)= ("$PREFIX","$TMPDIR","/usr/lib","$HOME", "/etc","/var/tmp",  "/usr",  "$LOGDIR");

   for my $checkfolder  (@folder){

     die  "Missing folder " . $checkfolder." Please install and create the path\n" if  !-d  $checkfolder  ; #if it is NOT a folder exist
 }

	 }

 check_dirs()

  #7:BUILD SYSTEM
sub build_system  { #Make sure make exist
     if( detect_utility ("make") == 0 ){

      die "ERROR- make tool does not exist please install or setup your build system";
   }
  	 print "Building using GNU make";

}
build_system()

#-- End SECTION ---

   #-- End build System --


my @install_files  = ( 'example.c', 'myheader.h', ); #Dummy

 my @test_exec =  extras("executable-file"   );


 #-----End of section  ------

#17  Recovery rollback ---



sub  main {
 print "Welcome! Building system";
print"  Detect system OS:"   . $os;

 print "Detect kernel:"    .$kernel ;


print "Detected compiler is gcc:".($compile_status?"YES":"NO"); #If compile status exist means the command is valid/ present

 #print "\t  compiler:"     . $compiler.
 if (exists ($ENV{ "PATH"} ) ) {
      print "\t Path variable is : ".  $ENV{"PATH"};
}else {
    print "Warning no Path detected";

 }

  my $user_decision = prompt("Select an Action:", {
      default_action => 'configure',
       actions => {
              'configure'   => sub {
                    print "Initiating configure process. (This part is unimplemented, but placeholder here for expansion)\n";
                     configure_build() ; #Dummy. Expand for choose/configuration options.
               },
                  'build'      => sub {
                        print "Start build proccess \n";
                         build_project(@install_files );  #Pass in compliation file name list/ directory

               },
               'test'  => sub {
                    test_application(@test_exec );  #Test executable/ binaries files
				}
	      ,'clean'   => sub {  cleanup() ;  } #clean and build system files
				   ,  'quit'   => sub {  exit;
                 }

        }
 });



 #End section 

sub cleanup {
 print  "Cleanup option";

 my ($file)= "$TMPDIR/check_libstest"; #Remove the testing program from the directory after build/
	 if (-e $file){

      rm ($file); # Delete the temporary files. To remove the directory it has be a clean up. Remove build/ files

	}
  # Remove log folders
 if(-d $LOGDIR){

    rmdir ($LOGDIR) or die "error removing dir  :$!";
	}
   print "Cleaning system completed.  All folders/builds deleted successfully.\n";

	}


#End main


#----- Dummy Subs for demonstration----
sub configure_build {

}


sub build_project{ #This will build based of input list from the array file.


 my (@file)= @_;

 for my $compileFile (@file ) {
      my ($output) =qx (gcc $compileFile -o build.exec -Wall) ; #Dummy compilation process using gcc.


			print "$compileFile compile result \n  $output \n";

   }

	  print  "Build complete \n" ;

	 }

  sub test_application{ my (@file)  =@_;

      for my $application  (@file){

        print "$application executed test process"; #Dummy execution and validation for build process test


    }

}

}

  main();


###################### End of the complete program######################

