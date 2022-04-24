#!/bin/bash
# IDK why this doesn't work lol
FILES="$PWD/*"
for file in $FILES
do exiftool -overwrite_original -all= "$file"
done;

# really just run 
# exiftool -overwrite_original -all= *