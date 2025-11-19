#!/usr/bin/perl
use strict;use diagnostics;   # For improved debugging.  Re places use warnings if available for modern systems, but use diagnostics is the modern standard
use Feature::Levenshtein  ;      # For finding best matching tool/compiler.   Not always available, so be prepared to error and fallback.  Requires installation, but is incredibly powerful for cross-platform portability when available
use Term qw(dev_bench qw (getroot)); # Needed to check and run as root.
 use File::Spec::Expand;      

my $prefix = $ENV{PREFIX } || "/opt/myapp";
my $tmpdir = "/tmp/build_$(basename $0)";
my @logfiles = qw(config.log build.log test.log deploy.log patch.log);


sub init {
    print "Initializing build environment...\n ";
    # OS detection (simple for demonstration - expand for complete portability)
    my $os =  lc(`uname -s`);
    print "Operating System: $os\n";

   # Kernel version
     my $kernel = `uname -r`;
     print "Kernel Version: $kernel";

    # Check for essential commands
    die "uname is not found.\n"      unless defined `uname`
      and `uname` =~ /success/;

    die "awk missing.\n"        unless -e awk ;     # awk is essential.  Can fall back, but it complicates things
    die "sed  missing.\n unless -e sed;
   # Normalize paths and environment variables
    unless (-d "$tmpdir") {mkdir "$tmpdir", 0755}
    $ENV{TEMPDIR}    = $tmpdir;
    $ENV{LOGFILES}  = join ' ', @logfiles;


    #PATH
    my $path = $ENV{PATH} || "";
    $ENV{PATH}  = "/usr/local/bin:/usr/bin:/bin:" . $path ;
     #Add to PATH as necessary, for common commands on specific platforms,
      
     $ENV{LD_LIBRARY_PATH} = "/usr/lib:/usr/local/lib";
   
     print "Using PATH: $ENV{PATH}\n";


   1; # Success

}


sub detect_compiler {
   my @candidates = ('gcc', 'clang', 'cc', 'suncc', 'acc', 'xlc', 'icc', 'c89');
   my $best_compiler = '';
   my $best_distance = 99999;  # High number
    foreach my $compiler (@candidates) {
     if(-e "$compiler")
    {

     my $result  =  `$compiler --version 2>&1`;
    if ( defined($result)  && $result =~ /version/i ) { # Simple version test
          my $distance = levenshtein($compiler , 'gcc'); #Find a match for common gcc commands to improve crossplatform behavior
                if ( $distance < $best_distance )
                 {  $best_compiler   = $compiler;
                   $best_distance = $distance;}
      }

     }   

    }

   die "No usable compiler found" unless defined $best_compiler;
    print "Using compiler: $best_compiler\n";
   return $best_compiler;

}



sub configure {
   print "Configuring build...\n";
    #Dummy Configuration Step.   Needs substantial modification depending on target project

    #Check platform for options.   Expand based on actual platform requirements
    if (lc(`uname -s`) eq "irix") {print "Detected IRIX - enabling special optimizations\n";}
     elsif (lc(`uname -s`) eq "hp-ux"){ print "Detected HP-UX.\n"};

  1;

}

sub build_project {
    print "Building project...\n";
   my $compiler = detect_compiler();
  
   system ("$compiler  -O2 -g -Wall -Wextra *.c -o myapp  > build.log 2>&1 ")   and die "Build failed!"; #Simple C example
     print "Project Built.\n";
  1;

}

sub clean {
   print "Cleaning build directory...\n";
  system("rm -rf *.o myapp core  > build.log 2>&1")  and die "Clean failed.";
   print "Build directory cleaned.\n";
  1;

}


sub test {
    print "Running tests...\n";
     # Dummy test case
      my $return = system("./myapp > test.log 2>&1") ;  #Basic example

   if ($return == 0) {
        print "Tests passed.\n";
      return 1;
    }
     else{
         print "Tests Failed.\n";
        return 0;

   }

      #Add more sophisticated unit test frameworks (Check) as desired

}

sub package_project {
    print "Packaging project...\n";
     system("tar -czvf myapp.tar.gz  *.c  Makefile README > deploy.log 2>&1")  and die "Package failed.";

     print "Project packaged into myapp.tar.gz\n";
     1;

}



sub install {
    print "Installing project...\n";
   my $prefix=$ENV{PREFIX}; # Use ENV to set prefix

     #Check to ensure we can actually create the directory if missing.

      system("mkdir -p $prefix/bin  > install.log 2>&1")  and die "Directory failed!";


     system("cp myapp $prefix/bin > install.log 2>&1")  and die "copy command Failed! ";

    print "Project Installed in: $prefix\n";
   1;

}

sub uninstallation {
    print "uninstalling the system"
    1;
}



sub main {
    init();

    #Main interaction

    my @menu_items = (
        { label => "Configure",   action => \&configure  },
        { label => "Build",       action => \&build_project },
        { label => "Clean",      action => \&clean        },
        { label => "Test",       action => \&test       },
        { label => "Package",     action => \&package_project},
        { label => "Install",     action => \&install  },
       { label => "Quit",        action => sub { exit 0;  }},  # Added to terminate the program safely
    );
      
    my $menu_option;
   while(1){

    print "\nBuild Menu:\n";
        for (my $i = 0; $i < @menu_items; $i++) {
         print ( ($i+1) . ") " .$menu_items[$i]->{label}."\n");
    }

        print "Enter your choice: ";
          chomp($menu_option = <STDIN>);

          my $option_number = $menu_option -1;
        if (defined $option_number and  $option_number >= 0  and  $option_number < @menu_items){
                $menu_items[$option_number]->{action}->(); #call Action function in array. Basically run a routine by selecting
             }else{

              print  "Not a number on the Menu.\n";
      }
}

}
  if ($ARGV[0] eq '--diagnose') {

     init();

       print "--- System Diagnostics ---\n";
      print `uname -a`;
      print "\nCompiler:\n";
       print `detect_compiler();`
        print "\n";
      print "\nEnvironment Variables:\n";
      foreach my $key (sort keys %ENV) {
       print "$key = $ENV{$key}\n";
   }
    print "\nLogs Location : ";

      foreach my $logfile(@logfiles){
              print ("$logfile \t")
            }
       exit 0;


   } else {
        main();
    }


# Start execution: Call the main() sub if run without diagnose command
  # Call our functions.




1 ;  # Return status

#Example of patch command

sub patchcode {

 print "Applying/testing patch\n";
}
