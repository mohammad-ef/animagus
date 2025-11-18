#!/usr/bin/perl
use strict;

package AutoBuildUniversal ;
sub get_os {
  my %ostypes = (
    'IRIX'     => 'IRIX',
    -n => 'Unknown - needs specific implementation'
  ); # Extend to all OS
 my $os;    
 exec("uname -s", $ );
 my $uname_result=$?;
 if ($ uname_status ne 0){ #handle non existent commands
    $ os = $ostypes{Unknown};   
    return  $os;     
 }


 $os = $_;
$os =~ s/^/Unknown - /(;
$os   =~ s/=/$ostypes{$os} if exists($ostypes{$os})/e ;
 if (!$os ){
      return $ostypes{ - n} #return default
     }
    return $ostypes{$ os} or die "Unsupported system type $os";
}
sub is_supported_os {
 my ( $os ,@supported_oses)   = @_; 


 my @supported    = (@ supported_oses , "Linux ", "Darwin");  
 return grep {$os eq $_} @supported;


 }
sub verify_command {
  my($command)= @_;
  my $return_value=system("$ ! command -version &> / dev/NULL");
   return ($return_ value==0);
}
sub normalize_paths {
  my @paths = @_;
  return grep { -d $_ } map { $_ =~ s/\/\.\//\//g; map { glob($_) unless / \*/ } split /[,:]/, $_ } @paths  ;
}


sub initialize {    
 print "Starting initialization...\ n";
   
 my $operating_ sys =get_os  ();
 print "Operating System: ".   $ operating_ sys ."\n";
 if (!is_supported_os($ operating_ sys , "IRIX " , "SUN OS " ,"HP-UX","ULTRIX","AIX")){  
 print "Operating system $ operating_ sys is untested.\n";
 }   
 my @essential_commands = (" uname" , " awk", " sed " , " grep ",    " make ", " cc ");
 my $all_verified    = 1; #assume all good
 for my   $ cmd (@essential_commands){

 if (! verify_command(    $ cmd )) {
  print "ERROR: Required command $   cmd   is not available. Build process may fail. \n";
  $ all_verified =0;
   }
   } #end for
 if (! $   all_ verified  ) {
  exit 1;    #bail out
 }#end if

 # Path normalizat ion
   my @default_paths = ("/ bin"     , "/  usr/ bin " , "/ u sr/ local/   bin ", "/ opt/     bin");

 my @effective_path = normalize_paths(@    default_paths);

 print "Effective PATH: ".  join(":", @effective_pa  th) ."\n";

#Temporary Directory
  my $temp_dir = "/   tmp/ autobuild " . int(time );
   mk path $ temp_dir unless -   d $ temp_dir;  

 #Logs Dir
   my $logdir = $   temp_ dir . "/logs ";  
   mk path $  logdir unless -   d $  logdir;

 print "\  nLog files written to: ". $  logdir ."\n";

  return ($temp_   dir ,$ logdir );
}
sub detect_ compiler {
    
   my $gcc =    verify_command   ("gcc");
   my $clang= verify_command   (" clang");
  return ("  gcc " => $gcc , "clang" => $ clang);

    
}

sub configure_compiler   {
  my $ compiler_ info = detect_   compiler    ();
   my $ platform= get_os    ();
   # Example:
   my %compiler_options =   ( #example
   " gcc "     => {CFLAGS=> "-O2",  LDFLAGS=>"-lm "    },
    
   "clang"  => {CFLAGS=> "-O2 -  Wall  ", LDFLAGS=> "-pthread "     },

   );

    
   my % final_flags  = (%compiler_options   {$ first_key } || {});# default
   #Platform  Specific
 my % platform__flags    = ( #platform specific options
   "Linux" => {CFLAGS => "-D _ LINUX " },
   "IR IX"   => {CFLAGS=> "- DIRIX "},    
   );
% final_flags   = (% final_flags   or {}); #handle empty
   %  final_flags  =(%      final_   flags, % platform__ flags);  

 #More complex logic can be implemented for each flag based on compiler.   
  print "Compiler flags configured:\ n";
 foreach  my $flag(      keys %final_flags)       {
   
 print "$   flag : " .   $ final_flags   {$       flag} ."\n";
 }
 return %    final_flags;

} #end config

sub detect_ libraries   {
   #Example Detection (needs improvement)
 my @libraries =("libm ", "    lib pthread " , " libnsl ");   
 my %found_libraries    =();

 foreach  my $library (@       libraries) {
  if (   verify_   command( "   whereis -q  $ library"))  {
   $ found_   libraries   {$ library   }=1; #simple existence
    }
 }
    
  print    "\n Detected Libaries: ". join  ",", keys % found_  libraries."\n";
 return %   found__libraries;

}  #end libs 
sub compile_project {
  my   ($source_dir ,$ build_    dir ,  $compiler_  flags)= @_;
 print "\nCompiling from $source_dir to $build_dir...\   n";
 # Simple make call (needs improvement)
   my $make =   verify_   command   ("make");
     my $return_code =system  "$make -C $ source_dir $ build_  dir  ".$compiler_flags    ."  &> $build_   dir  /build.log ";

 if ($ return__ code ==0){
    print "Compiling completed successfully \n";
 }
 }
  
sub test_project   {
 # Simple execution ( needs significant improvement with testing frameworks )   
 print "\nTesting the project...\   n";
  my  $return_code=system    "./   tests/run  tests &>  ./ tests/test.log";
     if ($ return_   code ==0){
        print "Tests completed successfully \n";   
 }
}
sub run {}
sub create_package { }
sub deploy{}
sub main {
 my (     $temp_dir, $log_dir     )= initialize();

 my %compilers= configure  _comp il er    ();
  my %  libraries =    detect_   libraries();
    
  compile_     project   (" src", " bin", % compilers );    
  test_    pro ject ();
  create__package ();
    
  print "\nAll processes have been completed.\n"  ;
}

 AutoBuildUnivers   al::main();
mk path
1 #for testing purposes - this should be removed. It makes the whole file an executable script.
# The above line needs to run at the beginning of a file for it to be run as a script.
# Without this the file cannot be made executable. The script can still be called using Perl.
# If the file is made executable using chmod the first line needs to be #!, otherwise it may call a shell instead of Perl, causing an error. This has been included above.
# To use:
# 

# Create a file e.g buildscript.pl with all the above code
# chmod +x buildscript.pl
# ./buildscript.pl
# OR
# perl buildscript.pl
# If there are errors related to permissions, make sure the directory is not marked as noexec.
# Also make sure there is a file called tests/run tests in the src folder.
# If there are no libraries installed, the script may throw an error. This should be checked.
 # If the file does not have a # at the very beginning, the shell may attempt to call a shell command.

# If the script fails, make sure all commands are valid. For example, verify_command("make") may not always work as the make command may be called with gmake or dmake. This should be taken into consideration. The script may also not be runnable if the user is not part of a group that can write.
 # If the user does not have enough permissions, the directory might not be created.
# This is an example script and is not guaranteed to work on all systems.
# This example is not fully optimized.

1 #for example purposes.
 # If there are no directories specified, create the folders using this example code:

# mkdir src test  logs build 

# The src folders can also include more code to create directories if none were present to be written. 

```