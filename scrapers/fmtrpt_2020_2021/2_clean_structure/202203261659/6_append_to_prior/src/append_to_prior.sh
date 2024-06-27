#!/bin/bash
#
# Append new Fiscal Year data to full, previously published/processed dataset
#
# tl@sfm	2022-03-25

# Safety measures
set -euo pipefail

# Existing dataset, placed in input folder
e="final_fmtrpt_2020_2021_20220325.tsv"

# New FY dataset, placed in input folder
i="final_fmtrpt_all_20210806.tsv"

# Functions

_appendNewFY () {

	# uses xsv cat
	# restore tabs and quotes with xsv fmt

	xsv cat rows -d "\t" input/"$e" input/"$i" \
		| xsv fmt -t "\t" --quote-always 

}

_main () {

#	_appendNewFY > output/final_fmtrpt_all_20220325.tsv

}

_main
