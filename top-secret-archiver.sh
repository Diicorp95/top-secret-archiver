#!/bin/bash
# shellcheck disable=SC2016  # Adding intentional quotation marks
# shellcheck disable=SC2031  # Change isn't lost because it's in IF
# shellcheck disable=SC2034  # Unused variables left for readability
# shellcheck disable=SC2089  # Adding intentional quotation marks
# shellcheck disable=SC2090  # Adding intentional quotation marks

# https://github.com/Diicorp95/top-secret-archiver
echo "Top-Secret Archiver: Archiver of your top-secret files.";
echo -e "(c) Diicorp95. MIT License.\n";

# Modules
randpw() { < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c72; } # https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
prompt_confirm() { while true;do read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY;case $REPLY in [yY])echo;return 1;;[nN])echo;return 0;;*)printf "\033[31m%s\n\033[0m" "Invalid input";;esac;done; } # https://stackoverflow.com/a/32708121/13976788

# https://stackoverflow.com/a/677212/13976788
command -v 7z >/dev/null 2>&1 || { echo >&2 "7-Zip execution failed."; exit 1; }

# Check if $1 is right
if [ "$1" == '-h' ] || [ "$1" == '--help' ] || [ "$1" == '' ] || [ ! -d "$1" ];
then
    # Else display synopsis
	echo -e "Usage: $0 <directory> [prefix]\n";
	exit 1;
fi

work_with_dir = "$1";
password =
read -s -p -r "Set password for archive: " password;

# If password is not entered...
if [ "$password" == '' ];
then
	prompt_confirm "Generate password?" || (password = randpw);
	printf "Password:\n\033[32m%s\033[0m" password;
	while true; do
		prompt_confirm "Ready?" || break;
	done;
else
	option_password = '-p"';
	option_password += "$password";
	option_password += '"';
fi

prefix = 'top-secret';

# Prefix check
if [ "$2" != '' ];
then
	prefix = $2;
fi
prefix += '_';

# Filename for archive
new_filename = $prefix;
randn = $(date | md5sum); # isn't used to generate a password
new_filename += ${randn:0:12};
new_filename += '_';
new_filename += $(date +%Y-%m-%d);

# Add to archive

7z a -t7z '"$new_filename"' '"$work_with_dir/*"' $option_password -mhe -mx=3 -ms=off
# Test if everything is OK
7z t '"$new_filename"'

exit $?
