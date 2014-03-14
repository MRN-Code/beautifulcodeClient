#code linting aliases
function formatFile() {
    if [ $# -ge 1 ] 
    then
        if [ $# -ge 2 ] 
        then
            php /usr/local/php/beautifulcodeClient/sendFileToCleaners.php $1 format $2
        else
            php /usr/local/php/beautifulcodeClient/sendFileToCleaners.php $1 format
        fi
    else
        echo "no input filename provided";
    fi
}
function lintFile() {
    if [ $# -ge 1 ] 
    then
        if [ $# -ge 2 ] 
        then
            php /usr/local/php/beautifulcodeClient/sendFileToCleaners.php $1 lint $2
        else
            php /usr/local/php/beautifulcodeClient/sendFileToCleaners.php $1 lint
        fi
    else
        echo "no input filename provided";
    fi
}
