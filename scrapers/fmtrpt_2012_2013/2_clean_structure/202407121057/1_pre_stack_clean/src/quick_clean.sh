#!/bin/bash
#
# Quick clean ups before stacking
#
# tl 2016-07-17

# Script safety and debug

set -eu
shopt -s failglob

# Make a list of files that we are going to work on

ls input/ > src/files

# Escape all double quotations before stacking
# Saves a lot of pain later
# It really does :P

while read -r p; do
	sed 's/"/\\"/g' input/"${p}" \
	> output/"${p}"
	done < src/files
