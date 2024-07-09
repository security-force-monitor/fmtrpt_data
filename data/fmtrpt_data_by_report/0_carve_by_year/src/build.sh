#!/bin/bash
#
# Create TSVs of data by year of report
#
# tl@sfm
# 
# Reports 2000-2019 were done in a single project, with 2020 and 2021 data added
# as reports were released by DoS. Actual year-specific TSVs were never made,
# only a single aggregate. This script recreates the year-specific TSVs.

# Script safety
set -euo pipefail

# Input file
i="final_fmtrpt_all_20220325.tsv"

# Functions

_sliceDataByYear () {

	# Print header, then subsequent rows where col 2 = uuid from loop

	gawk -v u="${u}" \
		'BEGIN {FS=OFS="\t"}
		 NR==1 {print}
		 NR >1 { if ($2 =="\""u"\"" ) { print }} 
		' "$1"
}

_main () {

	# Loop over file listing report fiscal year and year uuid

	while IFS=$' ' read -r y u; do

		_sliceDataByYear "input/${i}" \
			> "output/fmtrpt_fy_${y}.tsv"

	done < src/reportlist

}

_main
