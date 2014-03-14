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
