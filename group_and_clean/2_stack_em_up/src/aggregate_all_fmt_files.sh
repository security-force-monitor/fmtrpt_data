#!/bin/bash
#
# Stack FMTRPT data files into single output
#
# tl	2019-07-17
#	2019-12-06 updated
#
# Script safety and debug

set -eu
shopt -s failglob

# Use csvkit's csvstack
# Make a single tsv of the FMTRPT data, reconvert back to .tsv with full quoting
# We keep the input filenames, which helps with troubleshooting later down the line

csvstack --filenames --tabs input/*fmtrpt.tsv \
	| csvformat -T -U "1" \
	> output/fmtrpt_all_20191206.tsv
