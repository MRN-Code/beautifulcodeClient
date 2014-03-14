.PHONY: install
  
SRC_DIR=src/
SHELL_PROFILE_DIR=/etc/profile.d/
SHELL_PROFILE_FILE=beautifulcodeClient.sh
PHP_SCRIPT_DIR=/usr/local/php/
PHP_SCRIPT_SUBDIR=beautifulcodeClient/
PHP_SCRIPT_NAME=sendFileToCleaners.php

# to create conf/settings.json
install:
	mkdir -p ${PHP_SCRIPT_DIR} ; \
	mkdir -p ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR} ; \
	cp ${SRC_DIR}${PHP_SCRIPT_NAME} ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ; \
    if [ -a ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ] ; \
	then \
		echo "copied ${SRC_DIR}${PHP_SCRIPT_NAME} to ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME}" ; \
	fi;	
	cp ${SRC_DIR}${SHELL_PROFILE_FILE} ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ; \
    if [ -a ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE} ] ; \
	then \
		echo "copied ${SRC_DIR}${SHELL_PROFILE_FILE} to ${SHELL_PROFILE_DIR}${SHELL_PROFILE_FILE}" ; \
	fi;	
	chmod a+x ${PHP_SCRIPT_DIR}${PHP_SCRIPT_SUBDIR}${PHP_SCRIPT_NAME} ; \
	echo "done" ; \
	echo "run lintFile filename [language (js|php)] or" ; \
	echo "run formatFile filename [language (js|php)] or" ; \
