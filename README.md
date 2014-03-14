Command line tool to send files to the COINS linting and formatting service

Installation:
```
cd /tmp
git clone <url to this repo>
cd beautifulcodeClient
sudo ./install.sh
```
after installation, you may remove this repo from your machine (all necessary files are copied elsewhere

Updating:
clone new copy of this repo/gist, or update an existing one and run the following command from inside the beautifulcodeClient dir. 
This will replace the existing php and shell scripts with the latest versions (any changes you have made locally will be overwritten!)
```
sudo ./install.sh
```

Uninstalling:
clone new copy of this repo, then run uninstall script:
```
cd /tmp
git clone <url to this repo>
cd beautifulcodeClient
sudo ./uninstall.sh
```


Usage:
To format foo.js:
```
formatFile foo.js
```
This will send foo.js to the COINS formatting webservice. When the results are returned, a vimdiff of the original foo.js and the formatted foo.js will be opened.
After reviewing the diff, and quitting the vimdiff, you will be asked if you want to overwrite foo.js with the formatted foo.js
The language type is determined automatically based on the extension of the file.


To lint foo.php:
```
lintFile foo.php
```
This will send foo.php to the COINS linting webserivice, and open vim in a vertical split showing foo.php and the resulting lint report.
After quitting vim, you will be asked if you want to keep the lint report.
The language type is determined automatically based on the extension of the file



To force a language (e.g. lint foo.php using the js linter):
```
lintFile foo.php js
```
This will send foo.php to the COINS linting webservice, and force it to use the JS linter. 
Note that the entire foo.php file will be linted with the JS linter (not only the JS scripts inside it).
[TODO] add automatic extraction of script tags, and lint those.


