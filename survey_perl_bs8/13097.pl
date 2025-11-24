#!/usr/bin/perl
use strict; # Enables lexical declarations, dis allowing variable use without declaring and so preventing a lot of programming mistakes in a lot of different languages like PHP, JavaScript or Perl
use warnings;

use File::Find; # Allows us searching a directory structure recursively, which is very often needed in building projects

# Configuration defaults.  These should be overridden by environment vars when available to allow configuration via the build environment rather than hard-coded values.
 my $PREFIX = "/usr/local"; # Install prefix, will be overridden from env
 my $BUILD_DIR   = "build"; # Where to keep build intermediate files, and logs
 my $LOG_DIR    = "logs";
 my $ARTIFACTS_DIR    = "artifacts";


# Global configuration and variables that will change during execution of the script
 my %config;

sub init_env {
    # Detect OS, kernel, architecture, CPU count, memory, required commands. 
    # Verify essential utilities, normalize common env vars.  Create temporary directories. Enable debugging.
  
 my @os_types = ('Linux', 'IRIX', 'OS X', 'HP-UX',  'AIX', 'Solaris','BSD');
   
    $config{hostname } = `uname -n` =~ s/[\r \n]//g if $ENV{hostname eq ""} || $ENV{hostname } eq undef; # Hostname. If hostname is not already set, get from the operating system.
   
    $config{platform     };

    my @os_detect = (); # Used to determine our OS, we will populate it from the OS types above with commands such as ' uname' 

    foreach my $os ( @os_types ) {    
      if ( grep { $ENV{$os} =~ tr/\0//c  } [qw(uname)]  ) {  $config{platform}= $os;  print "Platform $ $os is identified, this script should work well on a variety of systems\n";   break;    }
    }
    if ( !defined($config{platform})  ) {$config{platform}="Unknown"; print "OS unknown, using fallback configuration, this can impact build quality or fail the build entirely if the configuration does not work\n";}  
    	  
  my @essential_tools     ; 


    @essential_tools   = ( 'uname',  'awk',  'sed',  'grep',   'make',) ; # Required commands
  
    my %tools_found;

    foreach my $tool (@essential_tools)    {   if ( grep { $ENV{$tool}  =~ tr/\0//c  } [qw(command)] ) {$tools_found{$tool}     =1;}  }

    # Check if any of the commands are not found, and throw an exit message if the tool is critical to continuing the program' execution
    if ( !  ($tools_found{'uname'}    &&  (  ($tools_found{'awk'}  || $tools_found{'sed'} || $tools_found{'grep'} ) &&  $tools_found{'make'}) ) ) { die "Missing one or more essential tools, check the environment\n ";} # Critical tools not found, script execution cannot be guaranteed to work

  
    $config{arch}      = `uname -m`  =~ s/[\r \n]//g  if (  ! defined($ENV{'arch'}) ||   $ENV{'arch'}  eq "");
  

   $config{cpu_count}   =   system("nproc") == 0 ?  `nproc` :   scalar(`lscpu | grep '^CPU(s):' | awk '{print $2}'`);   
   $config{memory}      =   `free | grep Mem: | awk '{print $2}'`
   
   $config{PATH}      =   ( defined($ENV{'PATH'})  ? $ENV{'PATH'}  :  "/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"  );
  
  my @vars = qw(LD_LIBRARY_PATH CFLAGS LDFLAGS CPPFLAGS);  
    foreach my $var (@vars)  { $config{$var}     =   defined($ENV{$var})  ?  $ENV{$var}  : "";   }
   
   if( ! -d $BUILD_DIR ){mkdir $BUILD_DIR   } if ( ! -d $LOG_DIR  ){mkdir $LOG_DIR  }  if( ! -d $ARTIFACTS_DIR ){mkdir $ARTIFACTS_DIR    }


    print "Initialization complete.\n";
}

sub detect_compiler {
 my $vendor   = shift || 'gnnu';

  # Basic compiler detection using common executables and flags.  This will get complex fast for more obscure architectures/compilers.
  my @compilers   = ('gcc', 'clang', 'cc', 'suncc','acc', 'xlc', 'icc','c89' );
  
  foreach my $compiler ( @compilers  )    {

  my $compile_test_program     = "#!/bin/sh\n echo Compiling and executing basic program.\n"; 
  my $temp_cppfile  = "$BUILD_DIR/test_compile_$vendor.cpp";

 my $result  = "";  # Will be the result that gets written in the file

 $compile_test_program   .= "int main(){return 0;}\n";   # C++ code

  
 if (   grep {  defined $ENV{$compiler} && ( -e $ENV{$compiler})   }  [qw(command)] ) {  # Checks that we know of a tool

 if  (   $ENV{$compiler}  =~ tr/\0//c)    { 
  
       
         
 my @compile_flags_test_file= qw( -o /tmp   );  
        

       $result   = `$ENV{$compiler} @compile_flags_test_file   - $temp_cppfile >/dev/null`; 
         

  # The following is not a real compilation test; however is a simple sanity check to determine what is being used to run compilation,
 # if there are no compiler messages this script should run, else it'll need a proper implementation for a real testing suite that runs a real compilation
        if (  ( index($result, "error") )   or   (index($result, "warning")))   {
   
   # If any errors happen terminate compilation as that will impact our build system in later phases

    die "Compile error for: compiler vendor: '$vendor'. The clean environment should work fine with most standard environments but this may require configuration";   
         
  }      else  {  

 # if successful write out this as compiler that is found 
  $config{compiler_found}  = $ENV{$compiler};
    print "Found  compiler using:   Compiler : $ENV{$compiler}\n"
 }

     }    }   }  
     return    
     

 }

sub detect_linker  {
   # Simple example linker detection (extend as needed)
   
    if   ( defined($ENV{'ld'})    ) { $config{'linker'}    =  $ENV{'ld'} ;
     print  "Linking:    detected  LD link as    linker   : $ENV{'ld'}"; }   
}


sub configure_flags  {
 # Based on OS, arch, and build mode configure relevant compiler/linker flags

  my  $arch    =  $config{'arch'};  
   if(    (   grep    {$arch    =~  /$_/ } [ qw( x86_64 x86_32 x86)]    ) ){

        if   (  grep{ ($ENV{optimize } eq $_  || ( $ENV{optimize}  eq "") && ( $_  eq "O2" ))}   [ qw(O2 -O2 -g)]   ) {    
             $config{'CFLAGS'}.=  " -O2";     $config{'CXXFLAGS'}.= " -O2";  
      }
          

}


 #  OS platform dependent configurations 

if   ( $config{'platform'} eq 'IRIX')    {$config{'LDFLAGS'}.= " -static ";  }


}



sub utility_detection  {  

#Locate common utility like objdump or mcs, this function would need additional testing as this will have more variations across operating systems  
  # Add further tool lookups, validation of command functionality as well,  and substitutions when the expected standard tools missing (e.g use legacy commands for older UNIX flavors, if possible and appropriate.) 
   if ( grep {   $ENV{'nm' }  =~ tr/\0//c   }  [qw( command )]) { $config{'nm'}  =$ENV{'nm'}; print  ' Found utility: NM  ';   }
   else{    print   ' WARNING : Could not detect or run: Utility NM ';    }  
   

}


sub main  {   

  init_env();

  detect_compiler(); # Detect Compiler

   detect_linker();   # Detect common utilities. Extend with other commands, versioning etc.

 configure_flags();    # Set compiler and linker flags for this architecture, OS etc
   
utility_detection(); 

   print "System Information: \n";
  print "  OS: ",  $config{'platform'},  "\n";   
  
  foreach  my $key  (  keys %config  )   { 
        
   if   ($key eq " compiler_found"  ||  $key  eq"  hostname")     {
      print "$key:  ",$config{$key}," \n";    
}   
 }

}   

main();

### Example Usage and Extension Ideas
# To specify a particular compiler override $ENV{gcc} and rerun the script,
# to override build options specify  CFLAGS ,  LD_LIBRARY_PATH and others before retuning

__END__ #Marks end to this script, useful and good coding standard, can prevent accidental code inclusion if the Perl program needs a module to execute, 
