#!/usr/bin/perl
############################################### build_all_unx  #######################
use strict qw($DATA,$+ =~ /(.)/; $ARG)=/ qw($); use vars qw(\%$+ @ARG);
  $|=1; use Term qw($ReadLine :history :clear :completion );  # for terminal interactions

 # Initialize global constants and paths
  package buildtools  ; # create global constants/variables to be available globally

  sub init  {$ENV{prefix }="/"} # default install prefis is slash (root)

  use Term::ANSIColor  qw($COLOR_RED :styles(bold)); my %colors = ( error  => {bold=>1, color  => $COLORS[2]  ,back=>" "} ) ; # for colored terminal messages and error logs  and error codes
  our %build  = (%build ); my @command_lines  =`env | sort `; # store all commands to use
  our %compiler_data  = (%)compiler; my $LOG  ="buildlog.txt "; # set a log file to log all messages from build.log
  open(FILE,"$ LOG" , ">"); chdir("./");  # create or clear a new file to log messages

  # check all essential commands from the system. If commands not exist, return the error. Exit build script to protect. This prevents from build errors during execution time if any required programs missing from system environment!

  print $COLOR["bold red"], "Initializing system checks ... \n ", $COLOR[0]." \n $LOG \n"
  sub init  {$ENV{prefix }="/"} # default install prefis if not provided in the environment vars or the configuration files!  and return to the default directory! This helps to keep a clean project! Also helps prevent unexpected errors and bugs!
  sub check_essential_programs {$essential_progs  = ("uname" ,"grep",' sed'  ,'make', 'gcc', 'awk','rm ',"touch"," chmod","cp ",  ,"find ", "ls");  print "$COLR" }

################################################################################################################
  package compiler; # compiler specific methods and configurations

  #################################################################################################### Detect and configure compiler ###################### ################################## detect different versions of C compilers, linkers, assemblers, and archivers,  and set flags accordingly
  #detect compiler from $PATH environment variable if gcc not detected from the path or the env vars or system variables, try clang and cc from the paths. If not detected, show an erropor message!

  #################################################################################################################################
  #compiler detection, configuration, version and flag handling (e.g -g for debugging, O2 for optimization, -m32  for 32-bit builds etc)

  #####
  use File qw() ; my @possible  compilers = ('gcc' ,'clang','cc','suncc ', 'aocc','xlc ','icc','c89', "ccache"); my ($compil  ) = " \n "; # declare variables! to store the result from compilation commands from the terminal

  #detect different compiler from the available compilers from possible compilers, return the version info of the compilers! Also, detect flags for specific architecture (32/64 bit) and portability (PIC, etc) from system architecture (e architecture is 64 bits, set 64 bits flags for compilation!)
  #detect and configure linker from $PATH environment variables,  and return versions. Set the environment vars to set flags! If not available.

   ### Compiler flag config (optimization, flags like architecture etc.
     ### system specific flags

     my ( )
    ####


   my   ;   #####
#### #
#   ################### Compiler detection function, detect the most suitable available complier from list to build the projects

  my (    $compilation, ); my $
#

#####


  #### compiler version from the path or environment vars
     ;

     #compiler versions detection function from env
#####   ###   #Compiler version information (including Vendor version number) from PATH and system vars to be set and store into Perl array to store compiler details later and available for all global scope..(version flag,  architecture info, system environment) for the whole script!! This can reduce time, increase program execution performance,

     #
   # compiler configuration flag (optimization, flags etc.) to be set from OS specific system configurations to improve compilation and performance
    ### #
#  system environment configurations

###
#####



#################   Compiler flags (O2/optimization/ debugging etc) based system architecture
 #

    ##  detect and handle flags from env vars, if exist set and save the env flags

####


####


#######################
####

#Compiler specific functions
####

####

###   #####

#### compiler flags

###### Compiler flags

################# system architecture and environment detections, flags configurations. and compiler configuration
######  #detect system env variables and configuration,
#####################   #################### # compiler versions

# compiler info, version flags

  #
  # Compiler configurations. Compiler flag (optimization),

### Compiler flags for the specific tools/ compilers
######  ####

  # set up default build flags based system

######
    #####
#
### Compiler info and version information for debugging or tracing the program during compilation time and execution
#############



###################



######



#########



################################################## system headers library functions detection!
  ###### Detect the available system environments and configure compiler and flags!


#########



########


##### Compiler versions info,

#####
#
#####

#### Compiler configuration info, version

######## System header/libs
###### Detect header

(#compile

##### Detect headers,
#### Detect available

###  Parser
####### System env configurations and system libraries
######## Detect

##### Parser and detect headers and

########  ####  #

#####

######  #####   ###   ## system info detection (uname etc..) to determine compiler and libraries to install
########


  #########   ###


  ######   System info and libraries.  Compiler flags based environment and system configurations to ensure correct compilation and system library compatibility.




#########



#######



### system headers and environment

##### system header,
########  System

#####


####

#########
########


### Compiler info

#################### Compiler detection from the terminal or PATH env
# Compiler and system libraries to configure and install




### Compiler from linux

# Detect

####### Detect and configure
######### Compiler version, compiler configuration and libraries
#######System libraries

####### Detect
######### Compiler from windows.
#####

####################



######




###### Compiler from AIX




#########  compiler
#######
######## compiler versions from environment



####### Compiler versions detection, and libraries

######################


######  ###




#  ####

# compiler versions, environment flags
################
####### system header libraries. Detect header versions. and libraries


##### compiler versions info


######## system configuration. compiler version from
#  ####

##### compiler version and library



########


########## System info

####### system info detection




#######################
#####




#################
######### System header version,

###### Compiler flags



######
#########


#######




################

########




#### System version




########
########### system libraries




########### System flags
#

#########



#######


########
###### compiler info

###




###### system flags




##### compiler info,

######



######## system

####### System header version info. compiler configuration, flags. system version info.




###
#####

#  #######################



###  Compiler versions




#################### system versions
######### compiler flags.
####



#### Compiler versions



##########


# system flags and
#########


########### System header and environment

########### system versions


###  #### system

####### system versions
######



##### compiler environment. compiler versions from terminal or PATH and environment vars!



######



#####
#########  compiler
####


##########  compiler



####


#########
### Compiler configuration info

########



######




####




######



#######

#

######## Compiler configurations,
##########


######




##### compiler flags
#########

#####
########

###########




#####



###

##########
######

######### compiler
###### system version




################

########




##########

################




###########
########## compiler flags




################



######




##### system flags


######




#######  ################################## System utilities
########## Detect the available system environments, and configuration.

########## Compiler flag versions



#### system versions


##### Compiler and library



###




#####
#####

#################

######

##### System configuration flags




######




####### System environment variables




################




########### Documents.

# compiler configuration from environment vars and from
#########
### system configuration from env


###########




###
##########
##### Compiler environment configuration flags

####  compiler flags from

##########

#######

########## compiler info


########

######



####



#### system

################



####### Compiler

###### System libraries




###########  Compiler

####  environment variables
#####

###
######



#### System versions

#######
####  environment and compiler

################

########


######### compiler and env
################


#########




#####



#####



##########



##### Compiler

########


####



########  ################# compiler flags. Compiler environment and compiler



######### system info



#################



######
##################### System info from



######## System configuration flags



##########




########## Compiler environment configurations from

################




##### system environment



########




##########


###### system configurations and compiler configuration and system versions

##### Compiler

#######


### Compiler

#### System versions

#####

########


########## Compiler flags,



###
##### compiler infos


###

#### system info,

######




####  ##################################



######

###### Compiler configurations




######## system info

######
#######

################




#########




########## Compiler environment and

###### Compiler info

###

######### system versions and configurations




##### compiler and

####### system versions, configurations





##########
#########
#####################



###########



###
############### system versions from


#####
######## compiler and versions

#####  environment




### Compiler version info



################################### system libraries




###  #####

################

########




########## Compiler info and configuration flags




####

########### system flags





########




##### System version information



#########
###########

####



########

#########


###########
###### compiler configuration and env and flags


#########




######## Compiler configuration




################################

#### Compiler

#### environment flags from



#####################




##### system configurations from




###  system flags




##########




#######


##########




##########  System and versions



########

#####



########


###



#########

########




####



##########
######


#########


################## Compiler configuration


####



########### System configuration and libraries


####


#########  ####
######### system environment configuration flags

#######


######




###### compiler version and



###### compiler



######  ##################################### system flags




######## Compiler version and



###

######## Compiler and environment



####################  ###################




####### system versions.
######


###
###### Compiler configurations from



#######################

########



#########




######

################
##### system flags




#####  environment flags from




###

#########
#########




##### System libraries
##########



#### System libraries



########## compiler info


######## System flags





#########



##########



######### compiler versions



#########

#########




########



########### Compiler configuration


##### environment variables from env vars




######

######### compiler flags

########

### compiler info,
###

########## System info


###
##########  compiler configuration




###### Compiler environment




#### environment



#####  System info and

########## environment variables from


################

###########




###########
########  ### system version and



####  ###########
#### system libraries and

### Compiler info




##########



#######################




###########




########

#########


### environment from




###########

################



##########


######### Compiler & Environment configuration



########## compiler environment flags


################# system libraries from the paths


#########
####### System version



########### environment and system configuration




####### System configurations from environment.




######## Compiler configurations from


######

#### Compiler

######## Compiler environment



#########
######
########




###########




####




######## compiler environment variables


####### System version info from environment.


###### environment configurations and flags and compiler versions
### environment configuration



########## System info




####### system version



##########  Compiler and system flags



########## environment from

####  system versions




######### environment variables
###### System info,



##########

########## compiler info,
######### Compiler configuration



##########
#######




##########  system and flags. Compiler versions
#########
### environment versions
####




##### system info
########## Versions of all compilers, libraries


################

####



###### compiler and environment

###### System libraries from env

################
####### System libraries



######## Compiler and system info
###### system environment



########### environment variables from

##### Compiler and libraries info and environment flags from




########



##########

#### compiler and system configurations. Compiler configuration
#### Compiler flags environment versions

##### environment flags,
### System configuration

### Compiler versions, and information, from



###

################
#########  environment from



###### system version



################

########## environment info. System and flags. System info from. Compiler and flags from the env




##########



###




####### Compiler versions
######### System configurations.

######### environment versions, compiler info.

###### system environment variables, environment from



##########

################
##### Compiler flags


######## Compiler flags

##### compiler versions. system versions and info


######## Relative environment info,
########## compiler flags environment



###  ### system install location


#### Compiler



##### compiler environment info
################
#########



#### Compiler



####
########## environment

#######################
##########




####

########## environment

##########




#####

### system versions
######## System configurations,




########  System version




###




##########



########### Compiler

#### System versions



####  Compiler



### Compiler configurations,

##########




######## compiler version



#####

########  ### System and versions




####### system info

########



###### System configurations from




######## environment


##### Compiler and system libraries


#### system info



###########  System flags and compiler

##########  System configuration




################# compiler info

#########  #####  System libraries,




###### compiler configuration

########

##########




######## System libraries
##################




###### environment and compiler




###########  ###



########



################### System environment configurations.




###### system libraries
#######



###### compiler and environments
######## system info and configurations from system and from compiler env.



####  ################
###########




######## System and compiler



###

####### System environment versions from




########




###########

#####
####  Compiler info environment configurations


########### Compiler configurations and libraries




###### compiler info




###########



#####

######### system versions



#######

######### environment configurations





########## System info from system and compiler environment



####### system flags
####### System version


##########



###### Env



######## System configurations


################



################
###########




###  ###

##################################### Compiler info from
######### System version

#### environmental and versions

####################### System info

##########




######
######### system
#######

### system configuration and versions, from system.
######### Compiler,




###




######### system versions
###### environment

######



######## System flags


####### System configuration



##################### compiler configuration from system environment,
##### compiler and system version


###### System version


#####  #####




###########



########## environment info and versions




##########
######## system flag info.
###########  ##### System flag environment




########




########## compiler version
#########




###########



###########




###  System configuration
###### Compiler versions info environment configurations




### system configuration and environments from



###########
############ System configurations

########## Compiler configuration and environment info.





#####




########




##########

#########
###########
########## environment configuration
####### compiler versions

#####
###### compiler configuration
######



###### environment info

##########  ### environment info. system and flags.




######## System and Compiler




### System configuration

########



########## System flag from system env



####  System configurations




### system version info and compiler versions and env



######## environment




#######################
# Compiler environment
# environment from the environment, environment variables.


#



################# System flags




#########
##################

######## environment

################



#########  ##### System info

######## compiler flags and




###### Compiler



##########

##### compiler

##########  ##### compiler and



### System libraries info environment configurations

###################



# compiler info
##### environment and compiler configuration. System configuration




########



# Environment

##########
###########  Environment




#
#### System version from system

#### Environment. Compiler environment configurations



#########  ### environment info environment versions and



######## environment

##### system environment

######### environment flags



######## system and versions!!!! Compiler configuration, and environment versions
#####################



########




################



# Environment



#####

# Environment
######




####



##########




##########
# Environment versions

######## system version
# Environment configuration




#########
#### environment



# system and env versions

### compiler and env configurations
################



#########System configuration flags



###########



###################

###########
######### system

######## compiler configuration environment and system configuration

######### System configurations.




################



###  compiler version.
######



######## Compiler versions

######### Compiler and versions from env vars

################################



##########




### environment info and configurations. Environment and Compiler version




#####




### Environment configuration and system and version.





#########  #################### Environment versions and Environment info and env config




########### Compiler



#### Compiler versions info



###################




####################




##### Environment



################## Compiler info



####################
########### System flags
########### system environment configurations and info
#########




########## compiler

######




### Compiler flags



###### system

##########




###### system versions info from environments


###

#



########## environment




#### compiler info environment config



#########

########## compiler configurations


#### System configurations


######
# System version

# Environment versions



### Environment configuration. System version
######



########### Compiler environment info



###### Compiler versions from environment



### Compiler

###########




###########
########




#




########### Environment info environment configuration from. Environment and Compiler



######### System info, versions.
###### System environment flags


####



### Compiler configuration and flags. Environment



#### environment
###########

#########



###### environment
###
########### Compiler version

######Info




#Environment and compiler

#### Environment




###########




###### Environment configurations



########## Environment



# Compiler



######## System info




###########




#########
###########




#



########### Compiler and Environment versions, configuration
###########




################



###########



#



#####




###########




#### Environment version

########### Compiler



######## compiler and

#########

########
########### Environment version, Compiler configurations


#




#### Environment and System




### Compiler and Env
####



#



#### environment


######### environment



########### Compiler info


#########




###### system configurations

######### environment configurations


########### System version from




###########
################




# System versions from
######




##########




### System



###### system configuration

#### System info


###



### version

########

###########



###########



#########



######### system



# environment

########




########### compiler info, system configuration

##########

#
######
### compiler flags




### system configurations
##### compiler flags from env

########## Compiler configurations from




##################
#### Compiler version can

###



###### system configurations




###########



#### Environment configuration environment



### Compiler

####




########## Environment




#### version, environment and system configurations and info


###### compiler version




##### compiler info
########



##