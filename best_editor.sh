#!/bin/bash
#
# Best Editor is only for the best typists, and is written assuming
#   that real coders and writers don't need to see what they type 
#   to know how perfect it is.
#
# But honestly this program is just a piece of satire written due to
#   a joke between three friends about the opposite of self-documenting
#   code, which we decided is self-obfuscating code (Perl).
#
# Date:       2019-04-20
# Programmer: HyperVegan
# Purpose:    Amuse friends.
#
# Parameters:
#   $0 - Program name.
#   $1 - File to edit, does not need to exist already.
#
#######################################################################

PROG=${0##*/}

## Functions ##
function usage {
   echo "Usage:"
   cat << EOF 
   $PROG name_of_file_to_edit_or_create
EOF
   exit 1
}

function display {
   contents="$1"
   clear
   # Hidden
   #contents=$(echo -e $contents | sed -e 's/[a-zA-Z0-9]/*/g')
   # More Hidden
   contents="$(echo -e $contents | sed -e 's/[^ \n\t\r]/*/g')"
   # Most Hidden
   #contents="$(echo -e $contents | sed -e 's/[^\`]/*/g')"
   cat << EOF
$contents

   Editing $filename

   Press \` to create a newline.
   Press Enter or Return to backspace.
   Press ~ to escape from the best editor.
EOF

   if [[ $debug == "1" ]]; then
   cat << EOF 


-= DEBUG:  Real contents of the file are below =-
$(cat $filename)
EOF
   fi
}


## Validations ##
if [[ -z "$1" ]]; then
   echo "ERROR:  No file name passed!"
   usage
fi

if [[ $2 == "debug" ]]; then
   debug=1
   echo "Debug mode enabled... cheater."
elif [[ ! -z "$2" ]]; then
   echo "ERROR:  Hey, only one parameter allowed. Let's not over-complicate this."
fi

if [[ "$1" == *" "* ]]; then
   echo "ERROR:  Seriously, spaces in a filename? You aren't one of us, get out."
fi

filename=$1


## Main ##
# Put the file into a variable
touch $filename
file="$(cat $filename)"
display "$file"
# No idea why but there is a bug here. This first display shows the obfuscated file
#   all in one line, but after entering a character it all gets adjusted correctly.

# Edit the file, but only from the end. :)
IFS=''
while read -e -n1 letter; do
   # Allow an escape
   if [[ "$letter" == '~' ]]; then
      break
   fi

   # Allow newlines
   if [[ "$letter" == '`' ]]; then
      letter="\n"
   fi

   # Allow backspacing
   if [[ "$letter" == '' ]]; then
      file="${file%?}"
   fi

   # Add the letter to the end and save the file
   file="$file""$letter"
   echo -e "$file" > $filename

   # Obfuscate and display file
   display "$file"
done


exit 0
