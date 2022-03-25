#!/bin/bash
#
# Parse US DOD/DOS FMTRPT FY 2020-2021 from PDF to a TSV
#
# tl@sfm / 2022-03-25

set -e
shopt -s failglob

_progMsg () {

	printf " + %s\n" "$1"

}

_extractPages () {
	# Use GhostScript to extract PDF from specific page ranges
	# This step is more robust than just using pdftohtml
	# Note that voluminous gs terminal chatter is routed to the bin
	# Function is cribbed and adapted from this blog:
	#  https://www.linuxjournal.com/content/tech-tip-extract-pages-pdf

	gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sstdout=%stderr \
		-dFirstPage="$s" \
		-dLastPage="$e" \
		-sOutputFile="output/0_pdf_slice/${y}_${t}_fmtrpt.pdf" \
		input/"${p}.pdf" 2>/dev/null

}

_xmlConvert () {
	# Convert the PDF to XML

	pdftohtml -c -s -i -xml output/0_pdf_slice/"${y}_${t}_fmtrpt.pdf" output/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

}

_cleanXML () { 
	# Filter out irrelevant material and accurately place tabular cells into the right attribute in an XML tree.
	# This ...mess .. works like this:
	# - get only the <text> lines
	# - remove lines with title font ("0")
	# - remove column headers (e.g. "Qty", "Course Title")
	# - based on interplay between left position and font size, assign an attribute name
	# -- Use the analyze_xml.sh helper to find out the values to put in here
	# - check again that we only have <text> tags
	# - correct problems with nesting that exist across line endings
	# - add XML doctype heading
	# - remove empty lines

	cat output/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
	| grep -e "^<text" \
	| grep -v "font=\"0\"" \
	| grep -v -e "^.*Qty.*$" \
	| grep -v -e "^.*Course Title.*$" \
	| grep -v -e "^.*Training Location.*$" \
	| grep -v -e "^.*Student's Unit.*$" \
	| grep -v -e "^.*US Unit.*$" \
	| grep -v -e "^.*Total Cost.*$" \
	| grep -v -e "^.*Start Date.*$" \
	| grep -v -e "^.*End Date.*$" \
	| sed '{
		s/<text.*left="27".*font="1">\(.*\) <\/text>/<country name="\1">%<c_name>\1<\/c_name>/g
		s/<text.*left="27".*font="2">\(.*\) <\/text>/<program name="\1">%<p_name>\1<\/p_name>/g
		s/<text.*left="35".*font="3">\(.*\)<\/text>/<training>%<course_title>\1<\/course_title>/g
		s/<text.*left="305".*font="3">\(.*\)<\/text>/<quantity>\1<\/quantity>/g
		s/<text.*left="359".*font="3">\(.*\)<\/text>/<location>\1<\/location>/g
		s/<text.*left="548".*font="3">\(.*\)<\/text>/<student_unit>\1<\/student_unit>/g
		s/<text.*left="737".*font="3">\(.*\)<\/text>/<us_unit>\1<\/us_unit>/g
		s/<text.*left="738".*font="3">\(.*\)<\/text>/<us_unit>\1<\/us_unit>/g
		s/<text.*left="926".*font="3">\(.*\)<\/text>/<total_cost>\1<\/total_cost>/g
		s/<text.*left="927".*font="3">\(.*\)<\/text>/<total_cost>\1<\/total_cost>/g
		s/<text.*left="1007".*font="3">\(.*\)<\/text>/<start_date>\1<\/start_date>/g
		s/<text.*left="1008".*font="3">\(.*\)<\/text>/<start_date>\1<\/start_date>/g
		s/<text.*left="1088".*font="3">\(.*\)<\/text>/<end_date>\1<\/end_date>%<\/training>/g
		s/<text.*left="1089".*font="3">\(.*\)<\/text>/<end_date>\1<\/end_date>%<\/training>/g

		}' \
	| tr '%' '\n' \
	| grep -v -e "^<text" \
	| perl -00pe '
		s/<\/training>\n(<program name=\".*\">)/<\/training>\n<\/program>\n\1/g ;
		s/<\/training>\n(<country name=\".*\">)/<\/training>\n<\/program>\n<\/country>\n\1/g ;
		s/<\/training>\n<training>\n<course_title>.*<\/course_title>\n<program/<\/training>\n<\/program>\n<program/g ;
		s/<\/training>\n<training>\n<course_title>.*<\/course_title>\n<country/<\/training>\n<\/program>\n<\/country>\n<country/g ;
		s/<training>\n(<country name=\".*\">)/<\/program>\n<\/country>\n\1/g ;
		s/<\/course_title>\n.*<training>/<\/course_title>/g ;
		s/<\/training>\n.*<quantity>/<\/training>\n<training>\n<quantity>/g ;
		s/<training>\n<course_title>.*<\/course_title>\n<course_title>.*<\/course_title>$//g' \
	| awk 'BEGIN{print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"};{print};END{print "</program>\n</country>\n</countries>"}' \
	| grep -v "^$" \
	> output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"

}

_errorCheckXML () {
	# Check the XML for errors. When it (finally) passes, we're all good.
	# You can also use xml el -u on the same input to check the xml structure. 

	xmllint --huge output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/3_xml_errors/"errors_${y}_${t}_fmtrpt.xml"

}

_deduplicateXML () {
	# Apply XSLT tranformation to xml to merge entries that span multiple enties in the XML.
	# For XSLT explanation see: https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text

	xml tr src/deduplicate_training_items.xsl output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml"
}


_generateOutput () {
	# Generate a TSV output from the XSML, clean up some spacing and tabbing cruft, and apply a header row.
	# For explanation of use of xml ancestors: https://stackoverflow.com/questions/51988726/recursive-loop-xml-to-csv-with-xmlstarlet

	xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	',us_unit,'	',student_unit,'	',start_date,'	',end_date,'	',location,'	',quantity,'	',total_cost)" -n output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tsource"};{print $0"\t"p}' \
	> output/5_xml_tsv/"${y}_${t}_fmtrpt.tsv"

}

_main () {
	# Extracts and parses different sections of the FMTRPT.
	# Provide the following input to control the script:
	#  p = input filename
	#  y = fiscal year of report
	#  t = sub-section (e.g. Africa, Western Hemispehere)
	#  s = first page to extract
	#  e = last page to extract

	while IFS=$' ' read -r p y t s e ; do
		
		printf "%s: %s\n\n" "# Working on" "$t"
#		_progMsg "Extracting pages from PDF"
#		_extractPages
#		_progMsg "Converting PDF to XML"
#		_xmlConvert
		_progMsg "Cleaning up XML"
		_cleanXML
		_progMsg "Linting XML"
		_errorCheckXML
		_progMsg "Deduplicating XML"
		_deduplicateXML
		_progMsg "Creating TSV output"
		_generateOutput

	done < src/fmtrpt_fy_2020_2021_sections

	printf "%s\n" "Done!"

}

_main
