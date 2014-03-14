<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */
/*
 * Command line script to send a PHP script to webservice for beautification
 * and linting.
 *
 * ARGUMENTS:
 *
 * First argument is file to be beautified (required)
 * Second argument is the action to be performed on the file (format or lint).
 * Third argument is the name of the file to be written to (optional)
 * if only two args are specified, then the new file will be written
 * to with the same name as the original filename, but with the action
 * (format or lint) appended to the end.
 *
 * EXAMPLE USAGE:
 *
 * FORMATTING:
 * To format a file in the current directory with filename
 * index.php, perform the following:
 * php send_php_to_cleaners.php index.php format
 * This will send index.php to the formatting webservice and will write
 * the response (formatted file) to index.php.format in the current dir.
 * if index.php.format already exists, then the new file will be named
 * index.php.format.1 and so on...
 *
 *LINTING:
 * To lint the formatted file, run:
 * php send_php_to_cleaners.php index.php lint
 * This will send index.php to the linting webservice and will write the
 * response (linting report) to index.php.lint in the current dir. If
 * index.php.lint already exists in the CD, then the file will be given
 * the name index.php.lint.1 and so on...
 *
 * @Dylan Wood
*/

$newLine = "\n";
$extToLanguageMap = array(
    //extension => language
    'js' => 'js',
    '_js' => 'js',
    'php' => 'php',
    'inc' => 'php',
    'class.php' => 'php',
    'conf' => 'php'
);   
//attempt to get action
if (!empty($argv[2])) {
    $action = $argv[2];
    if (!$action == 'lint' && !$action == 'format') {
        throw new Exception(
            'Invalid action specified. Specify either lint or format'
        );
        die;
    }
} else {
    throw new Exception(
        'No action specified. Specify lint or format'
    );
    die;
}
//attempt to get filename to send
if (!empty($argv[1])) {
    $filename = $argv[1];
} else {
    throw new Exception('No input file given');
    die;
}
//attempt to get language of filename
$supportedLanguages = array_unique(array_values($extToLanguageMap));
if (!empty($argv[3])) {
    $language = trim($argv[3]);
    if (!in_array($language, $supportedLanguages)) {
        throw new Exception(
            "Unknown language specified: $language.\nSupported extensions: " . 
                implode(', ', $supportedLanguages)
        );
    }
} else {
    //get input file type
    $inputFileExt = pathinfo($filename, PATHINFO_EXTENSION);
    if ( !(in_array($inputFileExt, $extToLanguageMap) && 
        $language = $extToLanguageMap[$inputFileExt]) ) {
        throw new Exception(
            "Unknown file extension: $inputFileExt.\nSupported extensions: " . 
                implode(', ', array_unique(array_keys($extToLanguageMap)))
        );
    }
}

//set target url
$targetURL = "http://lintcoin.mind.unm.edu/beautifulcode/$language/$action";
//this is the extension that will be assigned to the new file
$responseFilenameExt = ".$action";
//get username
echo "running as " . get_current_user();
echo $newLine;
//send the file
print $targetURL;
$newFilename = sendFile($targetURL, $filename, $responseFilenameExt);
if ($newFilename) {
    switch ($action) {
        case 'lint':
            system("vim -O $filename $newFilename > `tty`");
            echo $newLine;
            echo "The linting report for your file has been written to $newFilename";
            echo $newLine;
            echo $newLine;
            $keepReport = getInput(
                "Would you like to keep the lint report(Y/n)?",
                array('Y', 'n')
            );
            if ($keepReport === 'n') {
                exec("rm $newFilename");
                echo $newLine;
                echo "Lint report removed";
            }
            echo $newLine;
            break;
        case 'format':
            system("vimdiff $filename $newFilename > `tty`");
            echo $newLine;
            echo "Your beautiul new file has been written to $newFilename";
            echo $newLine;
            echo $newLine;
            echo "Use the following command to view a diff of the changes made by the formatter";
            echo $newLine;
            echo "vimdiff $filename $newFilename";
            echo $newLine;
            echo $newLine;
            echo "Use the following command to copy the formatted file over the unformatted file";
            echo $newLine;
            echo "mv $newFilename $filename";
            echo $newLine;
            echo $newLine;
            $doMove = getInput(
                'Would you like to replace the file with the formatted version (Y/n)?',
                array('Y', 'n')
            );
            if ($doMove === 'Y') {
                exec("mv $newFilename $filename");
                echo $newLine;
                echo "File replaced with formatted version.";
                echo $newLine;
            }
            break;
    }
}


/**
 *
 * @param unknown $targetURL
 * @param unknown $filename
 * @param unknown $responseFilenameExt (optional)
 * @return unknown
 */
function sendFile($targetURL, $filename, $responseFilenameExt = ".log")
{
    $newLine = "\n";
    //setup new filename for writing to the local dir
    $newFilename = realpath($filename) . $responseFilenameExt;
    $tmpFilename = $newFilename;
    $ext = 1;
    //make sure that we do not overwrite anything
    //by looping until we arrive at a filename that is not in use
    while (file_exists($tmpFilename)) {
        $tmpFilename = $newFilename . '.' . $ext;
        $ext = $ext + 1;
    }
    //reassign newFilename to be the safe filename
    $newFilename = $tmpFilename;
    //make sure that we can write to the new filename
    if (!touch($newFilename)) {
        throw new Exception("Could not write to $newFilename");
        die;
    }
    //obtain absolute path of filename
    $filename = realpath($filename);
    //get handle pointing to new filename
    $newFileHandle= fopen($newFilename, 'w+');
    //set up post data
    $post = array('file_contents' => '@' . $filename);
    //initialize cURL object
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $targetURL);
    curl_setopt($ch, CURLOPT_FILE, $newFileHandle);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
    echo "Sending $filename to $targetURL...";
    echo $newLine;
    //send request
    curl_exec($ch);
    //check for errors
    if (curl_errno($ch)) {
        unlink($newFilename);
        throw new Exception("Error during HTTP request: cURL error: " . curl_error($ch));
        die;
    }
    //see if anything was written to the new file
    if (!filesize($newFilename)) {
        throw new Exception("Error: no data written to $newFilename");
    }
    curl_close($ch);
    echo "Complete";

    return $newFilename;
}


/**
 *
 * @param unknown $msg
 * @return unknown
 */
function getInput($msg, $acceptableResponses = null)
{
    fwrite(STDOUT, "$msg: ");
    $varin = trim(fgets(STDIN));
    if (is_array($acceptableResponses)) {
        while (!in_array($varin, $acceptableResponses)) {
            $msg = "The following responses are acceptable: "
                . implode(', ', $acceptableResponses);
            fwrite(STDOUT, "$msg: ");
            $varin = trim(fgets(STDIN));
        }
    }

    return $varin;
}
