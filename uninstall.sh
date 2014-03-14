#! /bin/bash


#Shell scirpt to move src files for the COINS beautifulCodeClient to the
#proper directories in the system

#setup vars
source common.sh

#create directories (do not fail if already there)
rm -rf ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR} ; 
#check that move was successful
rm ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ;

echo "done" ;
echo "" ;
echo "Troubleshooting" ;
echo "You may need to log back in for the shell functions to be removed from your environment."
echo "Alternatively, run 'exec bash' to refresh your environment immediately"
