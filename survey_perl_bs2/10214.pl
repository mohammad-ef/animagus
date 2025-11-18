#!/usr/bin/perl
############################################### build_all_unx  #######################
use strict qw($DATA,$+ =~ /(.)/; $ARG)=/ qw($); use vars qw(\%$+ @ARG);
  $|=1; use Term qw(:TERM); use File qw(':all'); $^W =~ /\S+ /; use Term::ReadLine;
  #$|++;  # flush output immediately.

use constant VERBOSE =>  defined ($ ENV{VERBOSITY}) || die "set Verbose to '1' to enable"; #Verbose version flag for debugging
  
my %info; my @build_flags ;
my %config_opts  ( "PREFIX" => "$HOME/" ); 

#1. Initialization  -------------------------------------------------------
  &DetectOS; &VerifyCmds;
  $ENV{LOG_DIR  } = $ENV{TEMP_DIR }=  "build"  unless defined ($ENV{LOG_DIR } &&  $ ENV {TEMP_DIR} ); #create default directories. if not defined elsewhere
  &CreateLogDir if  -D $ENV{LOG_DIR} || mkdir ($ENV{ LOG_ DIR},077 ); #Ensure logging dir exists if not defined

# ---------------------  Detect OS/Architecture/Environment  -----------

sub DetectOS { #detect the OS type & other relevant system information and store it in %info.

  $info{OS}= uc hostname || die "Could  not get HOSTNAME "; #hostname command for os detection, error die
  # $INFO{ OS } = 'IRIX ' if ($ENV{IRIX})= ~/\S+/
  print STDERR "[+] OS  Detection : " .$info  {OS}."\n"; #print for diagnostics. useful for troubleshooting.  STD ERR for errors and info not important.

  my  $uname  = `/usr /uts -a /`;
  chomp ($uname); $info {KERNEL}=$ uname; #kernel and version
  $info{ARCHITECTURE}=$uname;
  $info{CPU}  =`nproc`; #cpu info - count
  chomp ($info{CPUs});

  $info{MEMORY}=`free | grep Mem: | awk '{print "\$2"}';  /`; #memory info in kb, convert later if need be to gb.
  chomp ($info{MEMORY});
}



sub VerifyCmds {#verify the availability of crucial tools. If not present, script fails.  Essential tools.

  # Basic tools.  Add all tools that your compilation process relies on and error out. If tool does not exist or is broken, exit immediately with a clear diagnostic to prevent build. No surprises. If a build is started, all necessary tools must function flawlessly or build should fail immediately and cleanly, preventing further waste.

  die "Error: uname command failed\n" if ! -x '/usr/bin/uname'; #basic OS tool check
  die "Error: make command failed\n" if ! -x '/usr/bin/make';  #critical make check

  die "Error: cc (compiler) not found!\n" if ! grep {-x $_} qw(/usr/bin/gcc /usr/bin/clang /usr/bin/cc /opt/bin/gcc };
  #add others
}

sub CreateLogDir {#Create necessary log files. Error die for problems with creating a needed path

 die "Unable  to  create " .$ENV {LOG_DIR}.". Verify path has appropriate write permission \n" unless  mkdir ( $ENV{ LOG_DIR},077 )  && -w $ENV{ LOG_DIR };  #mkdir + -W to catch permissions

   #create  a simple file.log inside build.
    open my $logfile, '>', "$ENV{LOG_DIR}"  ."/"  ."build.log"  or die "Cannot  open " .$ENV { LOG_DIR}. "."/"."build.log\n";
   close $logfile;

   $ENV {LOGFILE }="$ENV{LOG_DIR}/build.log"; #save path for all later logs

    print STDERR " [+] Logging output to " .$ENV {LOGFILE}."\n";
}


# 2. Compiler/Toolchain Detection  ---------------------------------------------
sub DetectCompiler {  #Detect all known C and C+ plus Compilers with associated enviorment. This will auto detect, fallback on defaults, set globals. and allow overriding
   my @compiler_paths=qw(/usr/bin/gcc /usr/bin/clang /usr/bin/cc   /opt/bin/gcc /opt/bin/clang);  #compiler locations

   my $detected_compiler =  undef;

    foreach my $path (@compiler_paths)
      {  
         if (-x $path) #if existant AND  exe
           {
             $detected_compiler= $path; #compiler found, break immediately, do not iterate again for other options! Save time/resource, important for older platforms
                last;
           }

    }


    die "no  Compiler was able to be Detected, build is  unstable, failing. Aborting!\n" unless defined $detected_Compiler; #critical compiler must always work for stability, no workarounds

    my @ver  =`${detected_compiler} -v 2>&1  `;
   chomp (@ver);
    for my $l (@ver)
   {   
    if ($l =~ m/(gcc version|clang version)/ )
   {  
     my @vers_arr =split / / ,$l; # split by spacing
       $info {COMPILER_VERSION}=$vers_arr [4]   || $vers_arr[2]  if @vers_arr  ;  #handle various formats of ver.

      last
   }
}  
   $info {COMPILER}= basename($detected_compiler) if defined $detected_compiler;   
    print STDERR "[+] Detected Compiler is" .  $info{COMPILER}." "$info{COMPILER_VERSION}."\n";  #log compiler detection

   & ConfigureCompilerFlags ($info{COMPILER} ,$info{ARCHITECTURE} ) ;  #environment fluence

  #TODO implement compiler version specific optimization

}


#3 Compiler / linker Flag Configurations

sub ConfigureCompilerFlags {#configure C ,CXX & other relevant compile time environment settings

     $ENV{CFLAGS}=   "-Wall  -O2" .    "-D_REENTRANT ";# default compiler  environment

   #OS  & architecture
  if ($info {OS} eq 'IRIX' ){

     $ENV {CFLAGS}=  "-Wall  -O2 " ." -I/usr/include";   # IRIX
   }  elsif  ($info{OS}eq 'HP-UX'   ){
   #add other
    $ENV {CFLAGS}=   "-Wall -O2  -I/usr/include  -D_POSIX"; #  -mt is often necessary, -lpthread may be
  }   elsif ( ($info {ARCHITECTURE}  =~  /64/))   #detect x64 or ARM 64 arch and auto apply
    {  
     $ENV {CFLAGS}=  $ENV {CFLAGS}  . " -m64" ;

  }


   #Add additional compile environment variables as necessary to the ENV vars here


  @build_flags   = split ' ', $ENV {CFLAGS}  ;#get all the compile environment options

 print STDERR "[+] Compiler & Flags Configuration "  .join( ' ',@build_flags)."\n"; #show all options.

  
}




#4 Header /  Libraries   Detection.  Auto Detect system level and libraries 
sub DetectSystemHeaders  {
   my @system_headers  = qw (unistd.h sys/stat.h sys/mman.h stdio.h);   #critical system includes to determine base compatibility
    for my $header(@system_headers)
        {  
         die "Header $header does not  Exist on $info{OS}" if ! -f "/usr/include/$header" and !-f "/include/$header" #error checking

    }   #basic headers, critical files that should exist on the target platform to ensure the project is compilable

 print STDERR " [+] All Critical headers detected and existing  ";
}




#5.Utility /  Tools

sub DetectUtilities{ #utility location checks for tools that aren't in default path
   my  @required_utils =qw(nm objdump strip ar size mcs elfdump dump);
     for my $util (@required_utils) {
   if (!which($util))
    {   die  " Utility: $util is NOT found \n"}
   }
   print STDERR " [+] Utilities are OK!\n";

}


#6 - FS/Directory Check
sub CheckFilesystemDirectories {
 #critical file systems & directory exist and can be write access by script, or it is not going to work properly

    my @dir =qw(/usr /var /opt /lib /usr/lib /tmp /etc );
  
   foreach my $directory (@dir){ #loop
       if(! -d $directory || ! -x $directory){die "Required Dir: '$directory' either does NOT exists OR is not accesssible by User.\n"};

       }
 print STDERR " [+] Critical  Dir check passed.  Everything appears available!\n";

}
  
 #Build process, using Makefile -----------------------
 sub BuildProject
 { 
 my @buildTargets   =('build'  ,'configure', 'distclean','clean','rebuild')   ;   
 print STDERR "[+] begin  build\n";  #initial state. for diagnostics

 for  my $t ( @buildTargets ) {

 #  print STDERR $t    ,"\n"

     die  "Cannot detect  build  process \n " unless (   defined (&IsMakeInstalled()) ) ;   
     & RunMake("$t");
 }  
print STDERR "[+]  finished  build process!   "  . join (" " , @buildTargets  )."\n";
 }
 sub RunMake #make command executor to automate the whole thing


{  my $command = $_[0];   #take command from function call and run in subprocess, with error check
#print STDERR "[+] run $command with system Make process" ;   #for logging diagnostics during runtime of process

system ( 'make',   $command )    &&  die   " Make Build:  " .$command." has failed ! Check output and build log"    ;#run, and if fails error message is output


 }  #END of Run Make 


  ###### heuristic to see whether  "make" exist, returns True/false  ######
sub IsMakeInstalled() {#make check heuristic - is there even MAKE on machine?!
# The most portable approach for a generic script

 #if  /Make   exists
 return    system ( "which",  "make"  ) ==0   #system call and check result
}  ##end

#Testing and Packaging   ---------------

sub TestAndPackage {#TEST & then create packaging - can extend functionality with custom testing.
print STDERR "[+] Test/ package  phase \n"; #for debug. diagnostics only, do not print during prod/

 & RunTesting
&PackageBuild 

} # End

sub RunTesting  {

print STDERR " [+][+] running  Test process, ensure testing automation in the source is complete"    ;  #test framework

}  #TEST


sub PackageBuild  {

  my @archiving = ('tar','gz','bz2');  # archive formats for build. expand if required.   .xz is often a safe format as well


 for my $archiveFormat ( @archiving )
   {  

       #build tarball and then zip.
   system  ("tar  -czvf Build_$info{OS}_${info {ARCHITECTURE}}_${info{COMPILER}_${info {COMPILER_VERSION}}$archiveFormat ", "build/");  #creates compressed Build. tar file
 }   #END
 
   print STDERR "[+] Finished Packaging \n";   #log for process confirmation, diagnostics during error
 } # Package END




  
#################Main Script Execution   #
 sub main
   {

     print " [ + ] Initial System Info Detected " ,"\n" ;   #debug info
      DetectOS    
       VerifyCmds

   #&DetectSystemHeaders

DetectCompiler;

 #print STDOUT $INVITE    ,"\n"; 
 #&PrintConfigurationDetails  

      CheckFilesystemDirectories  

  DetectUtilities #Check utilities last so we do NOT exit out during initial detection
#   BuildProject; #run make

#&TestAndPackage

#  
  print STDERR "  Build Completed successfully \n"; 
 # system ("pause"); # for pause/exit
 }   
 #END
    main;#run
### Debug  / Info 
sub PrintConfigurationDetails{ 
 # Print details,  helpful for diagnosing.
 #TODO - Add functionality of exporting to .json file as needed in some env

  print STDERR "[+] --- CONFIGURATION Summary---:\n"; 



print STDERR   " Operating system: $info{OS} ( Kernel Version  = ".$info{KERNEL}. ")",  "\n";   #print info.  compiles
   print STDERR " Architecture     = " .$info{ARCHITECTURE}.  "\n"  ;
  print STDERR "CPU core  #=     " .  $info{CPUs}  .    "\n"     ;

 #  printf(" Compiler = %s, verson : " ,  ) #compiler version 

print STDERR    " Compier     =   ".  $info{COMPILER}      ."Version   ".    $info {COMPILER_VERSION}. "\n"    ;   #version number



} # print config details


sub CreateLogDir {}

sub detectOS {
 }


  1; #Required at end.