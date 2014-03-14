#! /bin/bash


#Shell scirpt to move src files for the COINS beautifulCodeClient to the
#proper directories in the system

source common.sh

#create directories (do not fail if already there)
mkdir -p ${PHP_SCRIPT_DIR} ;
mkdir -p ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR} ;
#move PHP script to new location
cp ${SRC_DIR}${PHP_SCRIPT_NAME} ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ;
#check that move was successful
if [ -a ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ] ;
then
    echo "copied ${SRC_DIR}${PHP_SCRIPT_NAME} to ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME}" ;
fi ;
#move shell functions to new location
cp ${SRC_DIR}${SHELL_PROFILE_FILE} ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ;
#check that move was successful
if [ -a ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ] ;
then
    echo "copied ${SRC_DIR}${SHELL_PROFILE_FILE} to ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE}" ;
fi ;
#update permissions on PHP script
chmod a+x ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ;
#load the new functions into the active users profile
source ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ;

echo "done" ;
echo "" ;
echo "Usage:" ;
echo "run lintFile filename [language (js|php)]" ;
echo "run formatFile filename [language (js|php)]" ;
echo "" ;
echo "Troubleshooting:" ;
echo "If you get a command not found error, try logging out, then back in, or running 'exec bash' to refresh your session" ;
