#!/bin/bash
#
# Check generated XML for variations in element left position and font
#
# Use:
# To properly assign an XML attribute to the tabular values for each training item found
# in a US DoD/DoS Foreign Military training report, we need to know their "left" position
# and "font" size. There are often small variations in these inside a PDF and between PDFs
# of the reports. Once we know the permutations, we can design the various parsing statements
# used in the main extrator script. This helpful script looks at the raw XML output from pdftohtml
# of a section of the FMTRPT, searches for the column titles, and then pulls out thier
# "left" and "font" options. To use it, call the script and point it at the XML you want
# to analyse:
#
# 	$ src/analyse_xml.sh path/to/your/file.xml
#
#	Course Title:
#	Left: 35	Font: 3
#	Left: 35	Font: 9
#	
#	Qty
#	Left: 305	Font: 3
#	Left: 305	Font: 9


set -euo pipefail

terms="Course Title
Qty
Training Location
Student's Unit
US Unit
Total Cost
Start Date
End Date"

_extract () {
	# Example input from pdftothtml XML of a FMTRPT report:
	# <text top="90" left="35" width="49" height="10" font="3">Course Title </text>
	
	sed 's/^.*left="\([0-9]\{1,4\}\)" width.*font="\([0-9]\{1,2\}\)".*$/Left: \1	Font: \2/g' \
		| sort -u

}

_main () {

	while IFS=$'\n' read -r term; do

		printf "\n%s:\n" "$term"

		grep -e "^<text.*$term" "$1" \
			| _extract

	done <<< "$terms"

}

_main $1

# To do:
# - look at all XML files and output a single list
# - actually generate the sed statements so we can just paste them into the extractor
