#! /bin/bash


#Shell scirpt to move src files for the COINS beautifulCodeClient to the
#proper directories in the system

#setup vars
SRC_DIR=src/
SHELL_PROFILE_DIR=/etc/profile.d/
SHELL_PROFILE_FILE=beautifulcodeClient.sh
PHP_SCRIPT_DIR=/usr/local/php/
PHP_SCRIPT_SUBDIR=beautifulcodeClient/
PHP_SCRIPT_NAME=sendFileToCleaners.php

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

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
