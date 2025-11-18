#!/usr/bin/perl
use strict;   my $is_ai = 0; #for IRIX specific checks - set to 1 if detected
# use warnings qw (all); #enable at your peril on IRIX/AI - too many deprecation
 use POSIX; #for mkdir with permissions

 # Load modules
 use Term::ReadKey;
 use Term:: ANSIColor;    if (eval { require Term:: ANSIColor; } and not( $@ )) { } else{ Term::ANSIColor = {}; } #optional module for colored printing
 use Term:: Readline;
 use JSON;


  my %OS_INFO;

 sub detect_platform { # Detect and initialize platform settings and core libraries
  my $os_type =  uname()->0;   # Detect OS ( Linux, BSD, Darwin, etc)
  $OS_ INFO { OS = $os_type; }    # Store OS information

  my $arch_bits =  `uname -m ` =~ /x86_64/ ? 64 : `cpuinfo` =~ /bits / ? $1 : 32;  $ OS_  I N F O    { ARCH_BITS = $arch_bits; } # 64 or 32
        my $arch =  `uname -a ` =~ /arch / ? ( $& =~ /arch (.*)/ ) : "unrecognized";  $OS_INFO   { ARCH = $arch}; # Detect the processor architecture, like aarch64, arm v7
  $OS_INFO   { KERNEL =  `uname -r`}; # Kernel
  $OS_INFO    { CPU_THREADS   =  $] > 5.30? (grep { defined $_ } (map   { eval {fork} } (10))) : 1 };  # Count CPU threads - fallback method

  if ($OS_ INFO { OS}=="IRIX") { #IRIX specific settings
    %OS_INFO=( OS => 'IRIX'); $is_ai=1  ; print  ANSI_COLOR  " \e[31m IRIX detection enabled\e [0m\n".ANSI_ RESET; }

     print  ANSI_COLOR . " \e[32m Detected OS  : ".$OS_INFO { OS}."\n".  ANSI_  RESET.ANSI_COLOR . " Detected ARCH: ".$OS_INFO {  ARCH }."\n".  ANSI_RESET;
 }

 sub detect_essential_utils { # Verify essential commands are executable - important portability requirement
  my @essential_cmds = qw(uname awk sed grep make cc ld as ar ranlib nm   objdump strip mcs   elfdump dump patch gzip tar);  #Add commands required during the build
  my $missing_ cmds = [];

  foreach my $cmd(@essential_cmds){  #Verify each command exists and is executable
        my $executable = `/bin/. $cmd`  ||  `/usr/bin/ $ cmd` ; #Check in system directories - adjust as per your target UNIX systems - Solaris, HP-UX often have unusual paths.   IRIX has very particular locations.  Add more as per your target UNIX system - /opt /etc/path  /usr/local/etc  /usr/openwin - often require manual adjustment per target OS and build setup, as do libraries.  Check /usr/include/sys  /var.

    if (!$executable){ push @$missing_ cmds,  $ cmd;  }
  }
  if (@$missing_ cmds){  die "ERROR Critical tool missing: ". join ", ", @$missing  cmds." Build terminated \n". ANSI_ COLOR."\e[31 m". ANSI_  RESET;  }
  print ANSI_COLOR  ." \e[32mEssential commands verified\e [0m\n".ANSI_  RESET;
 }

 sub normalize_environment { #Normalize paths, libraries, compiler flags
  my @path_segments = split /:/, (exists $ENV   {  PATH} ? $ENV { PATH} : ''); #Split PATH, remove empty segments
  $ ENV { PATH}    = join  ":",grep { length } @path_segments;
  $ ENV { LD_LIBRARY_PATH}   ||= "" ; #Set an empty value if it's undefined to allow proper path resolution.  Some older UNIXes don't handle an unset variable well.  IRIX for example.
 }

 sub detect_compilers { #Detect compilers and store info in %OS.  IRIX requires special handling for legacy compilers and flags
  my @compiler_names =   qw(gcc clang suncc acc xlc icc c89);
  my %compilers = ();

  foreach   my $compiler_name (@compiler_names){  #Detect various compilers - IRIX needs special compiler detection as it uses different naming conventions and legacy compilers are common (cc,  suncc, acc)
   if ($is_ai &&  (  $compiler_name =~ /^suncc/ || $compiler_name=~/^acc/)) { #special treatment on IRIX

     my  $result=  `/bin/$compiler_name -v 2>&1`;

          if ($result) {$compilers { "$compiler_name"}  = { version=>($result =~ /version .* ([\d.]+)/)?$1 : 'N/A', vendor=> 'Sun', location=>  `/usr/ccs/bin/$compiler_name `} } }
           else
   {
         if  ( ` $compiler_name -v  2>&1` ) {#generic compile version
                my $result =   `$compiler_name -v 2>&1` ; #check in system locations

               $compilers{ "$compiler_name"}  = { version=>($result =~ /version .* ([\d.]+)/)?$1 : 'N/A', vendor=>  'GNU' , location=> `/usr/bin/$compiler_name` } }
           }
      }
     else   {   #For general compilers.    Solaris, etc
     if (  `$compiler_name -v`  ) {#check the version and the tool.

      my $result  =   `$compiler_name -v 2>&1`;

        $compilers{  "$compiler_name"} = {version=>($result =~ /version .* ([\d.]+)/)?$1 : 'N/A', vendor=> "N/A", location=> `$compiler_name`} }  #capture vendor as we cannot be sure from simple output - need more robust parsing if needed.
       }

       }
     }
       $OS_INFO{COMPILERS} = %compilers;  #store compilers information for access elsewhere

    print ANSI_COLOR." \e[32mCompilers detected:\n".  ANSI_ RESET ;
    foreach  my $compiler (keys %compilers){   print ANSI_COLOR. " \e[32m ".$compiler." (Version: ".  $compilers{$compiler}->{version}.")\n"). ANSI_RESET;}

  }
sub build_project  {    #Basic C build - adjust according to specific make targets
   my ($project_dir,$config) = @_;
     chdir   $project_dir || die "cannot find the $project_dir \n";
  if($config eq "debug")  { print ANSI_COLOR ." Debug build starting ... \n" . ANSI_ RESET;  system ("make  debug" ) }
       else   {print ANSI_COLOR ."Normal build \n" . ANSI_RESET ; system "make"};

   }
 # ... Other subroutines to be fleshed out: compile, install, test, package ...

 print "Initialization completed.\n.";
 print ANSI_COLOR ."Starting System Diagnostic Info\n" . ANSI_RESET;

  detect_platform();
  normalize_environment();
  detect_essential_utils();
  detect_compilers();

 print "Detected Platform Info:" . JSON::encode ($OS_INFO ) . "\n";
print "Normalized Env Variables";  print Dumper %ENV ;


__END__

