#!/bin/bash
#
# Create TSVs of data by year of report from final, fully augmented datasets
#
# tl@sfm 2024-11- Update for changed attribute names

# Script safety
set -euo pipefail

# Input file
i="final_fmtrpt_all_202410041854"
run=""

# Functions

_sliceDataByYear () {

	# Print header, then subsequent rows where col 2 = uuid from loop

	gawk -v u="${u}" \
		'BEGIN {FS=OFS="\t"}
		 NR==1 {print}
		 NR >1 { if ($19 =="\""u"\"" ) { print }} 
		' "$1"
}

_main () {

	# Loop over file listing report fiscal year and year uuid

	while IFS=$' ' read -r y u; do

		_sliceDataByYear "input/${i}.tsv" \
			> "output/fy_${y}_${i}.tsv"

	done < src/reportlist

}

_main
