#!/bin/bash
#
# Stack FMTRPT data files into single output TSV
#
# tl	2019-07-17
#	2019-12-06 updated
#	2021-08-06 updated with outfile test
#	2022-03-25 updated to just aggregate current FY
#
# Script safety and debug

set -eu
shopt -s failglob

# Choose a new outfile name each time data are updated

outfile="final_fmtrpt_all_202410041854.tsv"

_stack () {

# Use csvkit's csvstack
# Make a single tsv of the FMTRPT data, reconvert back to .tsv with full quoting
# We don't keep the input filenames, but this can  with troubleshooting later down the line
# add --filenames to csvstack if you want filenames

csvstack --tabs input/final_fmtrpt_*.tsv \
	| csvformat -T -U "1"

}

_main () {

# Checks if outfile already exits, so we can't accidentally wipe it

if [ -e output/"$outfile" ] 
	then 
		printf "%s\n" "Warning: Output file $outfile already exists. Choose another name."
		exit
	else
		_stack > output/"$outfile"
fi

}

_main

# To do:
# - migrate to xsv? 

