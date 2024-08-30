#!/bin/bash
#
# Pre-publication filters: A chance to remove naughty data
#
# tl@sfm

set -euo pipefail

# Specify input file

i="final_fmtrpt_2001_2002_202407121057.tsv"

# New Filters: Enumerate each as a function and name sensibly

_angolaError2019 () {
	# Remove Angola data from the 2019-2020 FY report. This is because
	# the source PDF released by DoS has a corrupted page (p. 101) at the 
	# end of the Angola data and the start of the Benin data, so we can't be sure
	# which data is Angola, and which is Benin. We will re-run the process once the DoS
	# has corrected the source PDF
	# See: https://github.com/security-force-monitor/fmtrpt_data?tab=readme-ov-file#2019-2020-report

	gawk 'BEGIN {FS=OFS="\t"}					;\
		NR==1 {print}						;\
		NR > 1 && !($4 ~ /Angola/ && $2~/730b2c0f-4eb6-4dbb-af57-2be9eb32031a/)' $1

}

_main () {

	_angolaError2019 input/"$i" > output/"$i"

}
_main
