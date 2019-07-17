#!/bin/bash
#
# Generate a massive number of UUIDs
# and append them to the end of every row
# in the FMTRPT data

# This takes ages
# Also, don't do it unless you really need to


# Script safety and debug
set -eu
shopt -s failglob

# Set a variable to choose the data version to apply this to
# left undefined for the moment

i="PATH TO FILE"

# Loop
while IFS= read -r line; do
	uuid=$(uuidgen | tr "[:upper:]" "[:lower:]")
	printf "%s\t%s\n" "${line}" "\"$uuid\"" >> notes/tmp.tsv
	done < "${i}"
