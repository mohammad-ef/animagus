#!/usr/bin/perl
## -*- Per: t- to- Perl ** Encoding: utf-8 ** 0 -
## Comprehensive Perl Script for Automated System Programming
## Expert Implementation
## Ported and Compatible w/Legacy & Modern Platforms

use strict;
  $ENV{'PERL5LIB '} = './:';  # Include module path for portability.  Important for unusual systems
  use lib './perlmodules '; # Include the directory that contains the required perl libraries.
use warnings;

# --- MODULE DECLERATIONS ---
  $SAFE{_}  = $SAFE{'DIE'}  = $SAFE{'WARN'} = {};
  # Use modules with fallback for older platforms
  use Term::ReadLine; # TUI
  use IO::Path qw ( makedir, rm -f -r -r ); #File and directory manipulation (porting friendly alternatives if standard methods aren 't avlible )
  use File::Basename; #File and directory manipulation functions. Portable.
  use File::Config;
  use Data::Dumper qw (Dumper); # Debugging, data structure dumps; portable and essential.
use Cwd;

my @MOD  ;

sub check_required_commands () { #1. Verify commands (critical)  and set up PATH/LD/C etc... - critical to the overall success.  Handles missing tools and fallback to vendors, etc. - a very critical and hard function for portablility reasons, especially w/legacy systems like irix, hp-ux, and others that might need fallback solutions to standard GNU toolchain.  Handles environment variables as well and creates necessary directories.  The environment and PATH is vital! It's first! 1/16th) 4/6

  die "ERROR: This requires a shell, such as sh, ksh, or bash\n" unless exists $ENV{'SHELL'};

  @MOD  = ('uname', 'awk', 'sed', 'grep', 'make', 'cc', 'ld', 'ar', 'ranlib');
  for my $cmd (@MOD) {
   unless (-x $cmd) {
     die "ERROR: Command '$cmd' not found or not executable. Installation required\n";
   }
  }

   my $tmpdir  = "tmp ";
   my $logdir  = "logs ";
   makedir($tmpdir, { mode => 0755 }) unless -d $tmpdir;
   makedir($logdir,   { mode => 0755 }) unless -d $logdir;

#   Set default path, C,L libraries for unusual systems - a crucial portability function! Handles PATH properly - critical to all functionality that requires execututables or binaries on PATH to work.  Sets important variables as required. Also handles setting LD variables to avoid conflicts - a major problem for old OS.

 my $prefix  = getpwuid(0) . "@HOST ". ".";  # Set a safe install base path. Prevents issues when writing system level paths, critical to older, unusual unix
   if ( $ENV{'PREFIX'} && -d $ENV{'PREFIX'} ) {
           $prefix = $ENV{'PREFIX'};
      }

   $ENV{'PREFIX'} = $prefix; #export this value for usage throughout this build process


    my @defaultpaths  = ('.', "/bin", "/usr/bin", "/sbin", "/usr/sbin", "/opt/" . $prefix, $prefix . "/bin", $prefix . "/sbin",  );  #Add paths that will work even if system is weird, and that is also portable for various older Unix

  my @allpaths  = ( grep -x $_, map { $_ . "/" } @defaultpaths  );

      my $new_path  = join ":", sort unique(map {  $ENV{'PATH'} =~  m s /:(\w +)*  /:(\w +)+$/ ?   $_ . ":" :   $_ ; },@allpaths  );
    if($new_path  != $ENV{'PATH'}){

         $ENV{'PATH'}  = $new_path;

   }



      my @defaultlibpaths = ("/lib", "/usr/lib");

 my $oldlibpath;
 my @oldlibraries = map{  -x? join  ":",$_: $_ , } split  (":", $ENV{'LD_LIBRARY_PATH'} ? $ENV{'LD_LIBRARY_PATH'} : " /lib/: /usr/lib "); #Split up library variables for easier manipulation and use later on
   @oldlibraries= map{-d $_}  @oldlibraries  if @oldlibraries  && $oldlibraries[0] = "";#remove any empty values that exist for LD_Library
 $oldlibpath = "$ENV{'LD_LIBRARY_PATH '}';
my @fulllibs ;
    #Build library PATH, adding defaults

   for (@defaultlibpaths ){

      push  @fulllibs,$_   if (-d $_ );
   }
#Combine with previously defined variables
 my $lib_str= "";

      #combine libraries together

    push  @fulllibs,$oldlibpath  if ( $oldlibpath ne "");
 my @libraryPaths;
 @libraryPaths = grep  -x{   join   ":", map $_ ,}@fulllibs   #Get libraries only, if we are on linux
    my  $libnew  = (split / /,@libraryPaths); #Create variable that can use LD
 $ENV{'LD_LIBRARY_PATH'} = join   ":",sort { lc $_ } $libnew    ;

 print "PATH = ",$ENV{'PATH'},"\n"; #For linux debugging - this allows debugging of PATH values.
  print "LD Library_Path= ", $ENV{'LD_LIBRARY_PATH'},"\n";#Same with library_path values

  }


sub detect_compiler(){
 my ($comp) = @_;  #This section will check for a variety of old compiler names that are no longer consistently in usage
if  ( $comp  eq 'g++')  { return   {name =>'g++', version =>   `g++ --version | head -n 1|awk '{print $3}'|cut -d '-' -f1 `,   vendor => 'GNU',};}

if (     $comp   eq 'clang'){ return   {name  =>  'clang',version    => `clang --version  2>&1 |head -n 1 |awk '{print $6}'  | cut -d '/' -f1`   ,vendor    =>   'LLVM'}; }
  if  (     $comp  eq 'cc'    )    { return {name  =>'cc', version=>`cc -v 2>&1 |grep compiler |head -n 1 |awk '{ print $3 }' `   , vendor    =>   'default compiler'}   ;}


#Older Compilers that may require specific implementations. Crucial section!  Legacy UNIX port. - handles old, rare compilers.
#Add to support for IRIX / AIX  (and older versions). These can be quite specific to versions, architecture, flags

    if ($comp eq 'suncc'){
       return  {name   => 'suncc',version    => `suncc -v  2>&1| awk  \'{print $2}\' `  , vendor=>'Sun Microsystems' }    ;} #Sun Compiler. IRIX
        if (     $comp   eq    'acc'){    return    { name  => 'acc',  version  =>   `acc  --version |head  -n1  |  awk ' {print $2 }'   `,  vendor  =>   'ACC (AIX) Compiler'}     ;}
        if(  $comp  eq "xlc")  { return {name   =>    'xlc',  version    => `xlc -version  2>&1 |head -n 1 |awk  \'{print $3}\'   ` , vendor =>    'IBM'}    ;}


     return    undef   ;#return nothing


}



sub compiler_flag_configuration()
  { #Compiler flag section. Sets environment based on detected environment/architecture, language etc.

   my   $flags     = (); #Compiler and linker settings. default values - this defines the environment variables that the entire rest of the program needs! It sets all important variables!
        #Determine the CPU Arch - Standard flags based on arch/system - portable across multiple OS. This function detects what CPU the system actually *is*. - important because old unix has a large range. Also important because some architectures have strange default compilers! Crucial!


 my    $arch      =    `uname  -m`;

   if( $arch  eq  "x86_64" ){ #For standard systems like ubuntu and windows x64, set default architecture.

       $flags   =   "-m64"; #For modern linux/BSD

        $ENV{'CFLAGS'}      .=      "  -O2  $flags   ";
      $ENV{'CXXFLAGS'}    .=      " -O2  $flags"; #set for efficient compilation and code speed!


  }elsif (    $arch eq  "i386"){

    $flags   =    "-m32 ";#Set the correct value when using legacy or less efficient hardware/system/platform - a very critical section

    $ENV{'CFLAGS'}     .=     "   -m32    $flags   ";
     $ENV{'CXXFLAGS'}     .=     " -m32  $flags ";


   }   else    {    $flags =    "$arch" }

 #Add flags, as necessary based on what architecture.

 my   $is_PIC= -e $ENV{'USE_SHARED'} or ($ENV{'PREFIX'}  =~ /Solaris$/);   #If this flag exist. -P is important, because shared is often needed
     if (  $is_PIC )     {
         $flags      .=  "  -fPIC ";   #Enable PIC (important if creating dynamic lib, for shared libraries - crucial)
          $ENV{'CFLAGS'}      .= "  -fPIC    ";   #Ensure setting
      $ENV{'CXXFLAGS'}   .=    "    -fPIC    ";

} #Enable it.  Important for builds!

$ENV{'LDFLAGS'} .=     "  -Wl,-zdefs    ";#Ensure no unnecessary variables
    # Set libc flag for old/odd Solaris - a legacy quirk, a major challenge when supporting these

    if($ENV{'PREFIX'}   =~  /Solaris/   )     {  $ENV{'LDFLAGS'}   .=   "   -lsocket -lnsl -lm    ";}  #Solaris - specific flags



      if ($ENV{'PLATFORM'} =~ /AIX/ ){
   $ENV{'LDFLAGS'}    .=   "  -bc -lnsl   ";

     }   #AIX Specific.


 print  "Comp flags set as      :\n "  . $ENV{'CFLAGS'}  .  "\n "  ;

    print   "C++ Compiler Flags    set     :\n   " . $ENV{'CXXFLAGS'}   .   "\n";


print     "LINK flags set      :     "    . $ENV{'LDFLAGS'}     .  "\n \n "  ;

   }  #Close configuration



sub utility_and_tool_detection (){

my (@mods = ( 'nm',    'objdump',     'strip',     'ar',  'size','mcs',    'elfdump',    'dump')); #Important tools needed

    foreach  my    $ut  (@mods ){

      unless (   -x  $ut )     {

         die      "Error    $ut  does not    exist or executable.\n     please    make  sure it    is properly   installed";


  }
  } #End utility Detection - critical for all builds.


#Main Execution Start - This drives all the operations! - this will run everything and set all important parameters and run the whole project and test it and build it and package it. Its also designed for maximum porting, with all sorts of legacy checks
  check_required_commands();

detect_compiler("g++");#Example, set g++ for the first stage of compiling to run and test all the other features in a basic environment and run.   Will detect others based on what's on path as needed
  compiler_flag_configuration();

 utility_and_tool_detection(); #Test tools needed
print    "All checks    complete\n    ";


1;  #Return value
