#!/bin/bash
#
# Parsing FMTRPT FY 2016-2017 from PDF to a tsv

# tl@sfm / 2019-12-06
# 	   2024-07-10 Update to orchestrate different runs
#          	      Update to scrape page number from PDFs
#          	      Updated to restore older PDF extraction function

# Script safety

set -e
shopt -s failglob

_progMsg () {

	printf " + %s\n" "$1"

}

_extractPages () {
	# Use GhostScript to extract PDF from specific page ranges
	# This step is more robust than just using pdftohtml, but may create backwards compatibility problems
	# Note that voluminous gs terminal chatter is routed to the bin
	# Function is cribbed and adapted from this blog:
	#  https://www.linuxjournal.com/content/tech-tip-extract-pages-pdf

	gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sstdout=%stderr \
		-dFirstPage="$s" \
		-dLastPage="$e" \
		-sOutputFile="output/${r}/0_pdf_slice/${y}_${t}_fmtrpt.pdf" \
		input/"${p}.pdf" 2>/dev/null

}

_extractPagesXmlConvert () {

	# Alternative to _extractPages, not using GhostScript.
	# This version produced the XML for all reports up to and including 2018-2019.
	# Seems to keep values with hard hyphons in them in same attribute

	pdftohtml -c -s -i -noframes -xml -f "${s}" -l "${e}" input/${p}.pdf output/${r}/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

}

_xmlConvert () {
	# Convert the PDF to XML

	pdftohtml -c -s -i -xml output/"${r}"/0_pdf_slice/"${y}_${t}_fmtrpt.pdf" output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

}

_cleanXML () {
	# Filter out irrelevant material and accurately place tabular cells into the right attribute in an XML tree.
	# This function  works like this:
	# - Get only the <text> lines from the raw XML.
	# - Remove lines with title font ("0").
	# - Convert <page> tag to <text> tag, which simplfies mass exclusion (we reinstate the tag further down).
	# - Remove column headers from XML (e.g. "Qty", "Course Title").
	# - Reinstate <page> tag using presnece of "number" in XML.
	# - Based on interplay between left position and font size, assign an attribute name.
	# -- Use the analyze_xml.sh helper to find out the values to put in here;
	# -- Exception here is creating a new page tag.
	# - Check that we don't have have any <text> tags left.
	# - Introduce "page_number" attribute inside <training> tag, using the <page> tag as an index.
	# - Remove redundant <page> tag before correcting cross-line nesting issues.
	# - Correct problems with nesting that exist across line endings.
	# - Add XML doctype heading.
	# - Remove empty lines.

	cat output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
	| sed 's/^<page/<text/g ; s/page>/text>/g' \
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
		s/<text.*number="\(.*\)" position.*$/<page>\1<\/page>/g
		s/<text.*left="27".*font="1"><b>\(.*\) <\/b><\/text>/<country name="\1">%<c_name>\1<\/c_name>/g
		s/<text.*left="27".*font="2"><b>\(.*\) <\/b><\/text>/<program name="\1">%<p_name>\1<\/p_name>/g
		s/<text.*left="27".*font="3">\(.*\)<\/text>/<training>%<course_title>\1<\/course_title>/g
		s/<text.*left="297".*font="3">\(.*\)<\/text>/<quantity>\1<\/quantity>/g
		s/<text.*left="351".*font="3">\(.*\)<\/text>/<location>\1<\/location>/g
		s/<text.*left="540".*font="3">\(.*\)<\/text>/<student_unit>\1<\/student_unit>/g
		s/<text.*left="729".*font="3">\(.*\)<\/text>/<us_unit>\1<\/us_unit>/g
		s/<text.*left="918".*font="3">\(.*\)<\/text>/<total_cost>\1<\/total_cost>/g
		s/<text.*left="999".*font="3">\(.*\)<\/text>/<start_date>\1<\/start_date>/g
		s/<text.*left="1080".*font="3">\(.*\)<\/text>/<end_date>\1<\/end_date>%<\/training>/g
		}' \
	| tr '%' '\n' \
	| grep -v -e "^<text"  \
	| gawk 'BEGIN { FS = "" ;page = "" }
		{	if ($0 ~ /^<page>[0-9]+<\/page>$/) {
        			print $0
        			match($0, /[0-9]+/, arr)
        			page = arr[0]
    		 } 	else if ($0 ~ /^<\/training>$/ ) {
        			print "<page_number>"page"</page_number>\n" $0
    		 } 	else {
        			print $0
    			}
		 }' \
	| grep -v "^<page>.*<\/page>$" \
	| perl -00pe '
		s/<\/training>\n(<program name=\".*\">)/<\/training>\n<\/program>\n\1/g ;
		s/<\/training>\n(<country name=\".*\">)/<\/training>\n<\/program>\n<\/country>\n\1/g ;
		s/<\/training>\n<training>\n<course_title>.*<\/course_title>\n<program/<\/training>\n<\/program>\n<program/g ;
		s/<\/training>\n<training>\n<course_title>.*<\/course_title>\n<country/<\/training>\n<\/program>\n<\/country>\n<country/g ;
		s/<training>\n(<country name=\".*\">)/<\/program>\n<\/country>\n\1/g ;
		s/<\/course_title>\n.*<training>/<\/course_title>/g ;
		s/<\/training>\n.*<quantity>/<\/training>\n<training>\n<quantity>/g ;
		s/<training>\n<course_title>.*<\/course_title>\n<course_title>.*<\/course_title>\n<course_title>.*<\/course_title>$//g ;
		s/<training>\n<course_title>.*<\/course_title>\n<course_title>.*<\/course_title>$//g ;
		s/<\/p_name>\n<quantity>/<\/p_name>\n<training>\n<quantity>/g' \
	| gawk 'BEGIN{print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"};{print};END{print "</program>\n</country>\n</countries>"}' \
	| grep -v "^$" \
	> output/"${r}"/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"


#	 s/<course_title> <\/course_title>\n<course_title> <\/course_title>//g' \

}

_errorCheckXML () {
	# Check the XML for errors. When it (finally) passes, we're all good.
	# You can also use xml el -u on the same input to check the xml structure.

	xmllint --huge output/"${r}"/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/"${r}"/3_xml_errors/"errors_${y}_${t}_fmtrpt.xml"

}

_deduplicateXML () {
	# Apply XSLT tranformation to xml to merge entries that span multiple enties in the XML.
	# For XSLT explanation see: https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text

	xml tr src/deduplicate_training_items.xsl output/"${r}"/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/"${r}"/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml"
}


_generateOutput () {

	# Generate a TSV output from the XSML, clean up some spacing and tabbing cruft, and apply a header row.
	# For explanation of use of xml ancestors: https://stackoverflow.com/questions/51988726/recursive-loop-xml-to-csv-with-xmlstarlet

	xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	',us_unit,'	',student_unit,'	',start_date,'	',end_date,'	',location,'	',quantity,'	',total_cost,'	',page_number)" -n output/"${r}"/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tpage_number\tsource"};{print $0"\t"p}' \
	> output/"${r}"/5_xml_tsv/"${y}_${t}_fmtrpt.tsv"
}

_setupOutputFolders () {

         # Create folder structure using extraction run ID as root
         # if it doesn't already exist (-p option)

         mkdir -p output/"${r}"/{0_pdf_slice,1_pdf_xml,2_xml_refine,3_xml_errors,4_xml_dedup,5_xml_tsv}
}

_main () {
	# Extracts and parses different sections of the FMTRPT.
	# Provide the following input to control the script:
	#  p = input filename
	#  y = fiscal year of report
	#  t = sub-section (e.g. Africa, Western Hemispehere)
	#  s = first page to extract
	#  e = last page to extract
	#  r = extraction run ID

	while IFS=$' ' read -r p y t s e r; do

		printf "\n%s: \n%s\n" "Run ID" "$r"

                _progMsg "Checking output folder setup"
                _setupOutputFolders

		printf "%s: %s\n\n" "# Working on" "$t"
		_progMsg "Extracting pages from PDF"
		_extractPages
		_progMsg "Converting PDF to XML"
		_xmlConvert
#		_extractPagesXmlConvert # uses just pdftohtml rather than ghostscript step
		_progMsg "Cleaning up XML"
		_cleanXML
		_progMsg "Linting XML"
		_errorCheckXML
		_progMsg "Deduplicating XML"
		_deduplicateXML
		_progMsg "Creating TSV output"
		_generateOutput

	done < src/fmtrpt_fy_2016_2017_sections

	printf "%s\n" "Done!"

}

_main

