#!/bin/bash

# https://github.com/Diicorp95/top-secret-archiver
echo "Top-Secret Archiver: Archiver of your top-secret files."
echo -e "(c) Diicorp95. MIT License.\n"

# https://stackoverflow.com/a/677212/13976788
command -v 7z >/dev/null 2>&1 || { echo >&2 "7-Zip execution failed."; exit 1; }

# Check if $1 is right
if [ "$1" == '-h' ] || [ "$1" == '--help' ] || [ "$1" == '' ] || [ ! -d "$1" ];
then
    # Else display synopsis
	echo -e "Usage: $0 <directory> [prefix]\n"
	exit 1
fi

work_with_dir="$1"
read -s -p "Set password for archive: " password

# If password is empty, then don't use -p option.
if [ "$password" != '' ];
then
	option_password='-p"'
	option_password+="$password"
	option_password+='"'
fi

prefix='top-secret'

# Prefix check
if [ "$2" != '' ];
then
	prefix=$2
fi
prefix+='_'

# Filename for archive
new_filename=$prefix
randn=$(date | md5sum)
new_filename+=${randn:0:12}
new_filename+='_'
new_filename+=$(date +%Y-%m-%d)

# Add to archive
7z a -t7z '"$new_filename"' '"$work_with_dir/*"' $option_password -mhe -mx=3 -ms=off
# Test if everything is OK
7z t '"$new_filename"'

exit $?
