#!/bin/bash
#
# Helper script: Get a clean list of Country and Program Names from raw XML
#
# This helper/scratch code looks at program title issues and resolves problem
# where program title is spread across multiple lines and the country name
# can't fully be extracted. Leaving it here as documentation, but most functions
# are included in main extractor scripts.
#
#
# tl@sfm	2024-09-17
#
# Script safety
set -euo pipefail

# Input variable for raw XML
d="output/202407121057/1_pdf_xml/"
i="2000_2001_Near_East_fmtrpt.xml
2000_2001_East_Asia_and_Pacific_fmtrpt.xml
2000_2001_Europe_fmtrpt.xml
2000_2001_Near_East_fmtrpt.xml
2000_2001_Newly_Independent_States_fmtrpt.xml
2000_2001_South_Asia_Region_fmtrpt.xml
2000_2001_Western_Hemisphere_Region_fmtrpt.xml"


# Functions
_procMessage () {
	# Prints a message, if we need
	printf "\n%s\n\n" "$1"
}

_initialFixes () {
	# Odds and ends that just need bodging before we do anything
	# - Fix for single item where program title goes over 3 lines rather than 2 (just pull "FY 00" into the previous line)
	sed -E '{
		s/<b>Grenadines, Center For Hemispheric Defense Studies,<\/b>/<b>Grenadines, Center For Hemispheric Defense Studies, FY 00<\/b>/g
		}' "$1"

}

_composeProgramTitle () {
	# Drag different bits of the program titles together
	# Key is to do this before cleaning up the program titles, not after, otherwise we end up wtih some orphans
	perl -00pe 's/<text.*left="486".*height="11" font="1">(.*)<\/text>\n<text.*left="486".*height="11" font="1">(.*)<\/text>/<program>\1%\2<\/program>/g ;
	            s/<text.*left="87".*height="11" font="1">(.*)<\/text>\n<text.*left="87".*height="11" font="1">(.*)<\/text>/<program>\1%\2<\/program>/g
		   '
}

_filterProgramTitle () {
	# Simple filter
	grep -i "^<program>"
}

_cleanProgramTitle () {
	# Cleaning steps: creates tab between Country and program name
	# Better handling of situations where the program name is comma separated

	sed -E '{
		 s/<b>//g
		 s/<\/b>//g
	   	 s/Korea, Republic of/Korea (Republic of)/g
                 s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
		 s/<program>//g
		 s/<\/program>//g
		 s/^.*Region, //g
		 s/FY[\s\+|]([00|01])/FY\1/g
		 s/%/ /g
		 s/ {2,}/ /g
		 s/, \+/, /g
		 s/,FY/, FY/g
		 s/, /\t/
	 	}'
}

_separateCountry () {
	# Split up country from program name
	perl -00pe 's/(.*)	(.*)/\1	\2/g'
}

# Subroutines
_cleanProgramTitleOutput () {
	# Composite cleanup subroutine
		_initialFixes "${d}${f}" \
		| _composeProgramTitle \
		| _filterProgramTitle \
		| _cleanProgramTitle \
		| _separateCountry
}

# Main  routine
_main () {

	# Make output file
	gawk 'BEGIN {print "region_file\tcountry_name\tprogram_title"}' > notes/country_program_list.tsv
	# Loop over raw xml, output list of files, countries and programs toTSV
	while read -r f; do
		# Make tsv list, sort unique, output with filename inserted in col 1
		_cleanProgramTitleOutput \
		| gawk -v f="$f" 'BEGIN {FS=OFS="\t"};{ print f FS $0}'  \
		| sort -u
	done <<< "$i" >> notes/country_program_list.tsv
	}
_main
