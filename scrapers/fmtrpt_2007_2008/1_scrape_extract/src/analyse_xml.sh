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
# "left" and "font" options. Note that differences may still exist, but this gives you a start. It also
# doesn't extract any information about the Programs, as these are not flagged as such, and vary throughout
# the document.
#
# To use it, call the script and point it at the XML you want
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

# These may vary from report to report

terms="Course Title
Qty
Location
Student's Unit
US Units
Total Cost
Start Date
End Date
ALP - FY 2007 DoD Training
CTFP - FY 2007 DoD Training
DOHS/USCG - FY 2007 DOHS Training
FMF - FY 2007 DoS Training
GPOI - FY 2007 DoS Training
IMET-1 - FY 2007 DoS Training
IMET-X - FY 2007 DoS Training
Regional Centers - FY 2007 DoD Training
Section 1004 - FY 2007 DoD Training
Service Academies - FY 2007 DoD Training"


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
			| _extract || true

	done <<< "$terms"

}

_main $1

# To do:
# - look at all XML files and output a single list
# - actually generate the sed statements so we can just paste them into the extractor

# This gets you the programs from the 2007-2008 report:
# grep "left=.54.*font=.0." output/202407121057/1_pdf_xml/2007_2008_Africa_fmtrpt.xml|grep -v "Totals"|sed "s/^.*0\"><b>\(.*\) <\/b>.*$/\1/g"|
# sort -u
