#!/bin/bash
#
# Parsing FMTRPT FY 2005-2006 from PDF to a tsv

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
	# Skips outputtng a specific PDF to output/0_pdf_slice

	pdftohtml -c -s -i -noframes -xml -f "${s}" -l "${e}" input/${p}.pdf output/${r}/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

}

_xmlConvert () {
	# Convert the PDF to XML

	pdftohtml -c -s -i -xml output/"${r}"/0_pdf_slice/"${y}_${t}_fmtrpt.pdf" output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

}

_cleanXML () {

	# Basic approach here has some differences from the post-2007 reports:
	# - filter out rows that don't contain substantive data or may be troublesome
	# - make any early changes or corrections that may be useful later
	# - add in a fake placeholder page 0 ("IV-0"), which will anchor the page_number assignment alg
	# - clean up and assign attributes to remaining rows based on left and font position in XML
	# - remove any redundant XML that has escaped processing
	# - fix a couple of XML structure issues
	# - assign a page number to every <training> item:
	# -- because pages numbers appear at the bottom of a page and this alg counts down,
	#    we add a fake 0 placeholder at the top, and add 1 to the <page> values it discovers.
	# -- we close the final training item manually, for mysterious reasons I don't have time to fix.
	# - handle some tag ordering issues using a perl megagulp
	# - pull the country name out of the program title and give it it's own tag
	# - top with an XML, tail with closing tags
	
	cat output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
	| sed '1,28d' \
	| grep  -e "^<text" \
	| grep -v -e "height=\"10\" font=\"8\"" \
	| grep -v -e "font=\"1\"" \
	| grep -v -e "font=\"2\"" \
	| grep -v -e "font=\"3\"" \
	| grep -v -e "font=\"5\"" \
	| grep -v -e "font=\"7\"" \
	| grep -v -e "font=\"9\"" \
	| grep -v -e "TNG(MELT" \
	| grep -v -e "<text.*left=\"54\".*font=\"6\">CRS<\/text>" \
	| grep -v -e "left=\"60.\" width=\"4\" height=\"15\" font=\"0\">" \
	| sed -E '/height=\"14\" font=\"0\"/ {
			s/^.*<b>//g
			s/<\/b>.*$//g
	 		s/Korea, Republic of/Korea (Republic of)/g
	 		s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
	 		s/Region, /Region	/g
	 		s/(,|, )(FY(05| 05))/	FY05/g
	 		s/,/	/
			s/^/<program name=\"/g
			s/$/">/g
			1d
						 }' \
	| sed '1s/^/<page>IV-0<\/page>\n/g' \
	| sed -E '{
			s/^.*left=\"54\".*font=\"6\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"238\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"243\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"249\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"255\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"266\".*font=\"6\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"268\".*font=\"6\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"472\".*font=\"6\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"473\".*font=\"6\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"657\".*font=\"6\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"919\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"928\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"934\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"940\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"949\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"954\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"960\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"986\".*font=\"6\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"989\".*font=\"6\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"992\".*font=\"6\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"106.\".*font=\"6\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"570\".*font=\"4\"><b> (IV-.*)<\/b>.*>$/<page>\1<\/page>/g
			s/^.*left=\"574\".*font=\"4\"><b> (IV-.*)<\/b>.*>$/<page>\1<\/page>/g
			s/^.*left=\"577\".*font=\"4\"><b> (IV-.*)<\/b>.*>$/<page>\1<\/page>/g
			
		  }' \
	| grep -v -e "^<text.*text>$" \
	| sed '{
			/^<program/s/^/<\/training>%<\/program>%/g
			/^<course_title>/s/^/<\/training>%<training>%/g
						}' \
	| tr '%' '\n' \
	| gawk 'BEGIN { FS = "" ;page = "" }
		{	if ($0 ~ /^<page>.+[0-9]+<\/page>$/) {
        			print $0
        			match($0, /[0-9]+/, arr)
        			page = arr[0]+1
    		 } 	else if ($0 ~ /^<\/training>$/ ) {
        			print "<page_number>"page"</page_number>\n" $0
    		 } 	else {
        			print $0
    			}
		 }' \
	| grep -v "^<page>.*<\/page>$" \
	| perl -00pe '	
			s/(<program name.*)\n<\/training>/\1/g ;
			s/(<program name.*>)\n<page_number>.*<\/page_number>\n<\/training>/\1/g ;
			s/<\/training>\n<\/program>\n<program name.*>\n(<student_unit)/\1/g ;
			s/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g ;
			s/<\/student_unit>\n<page_number>.*<\/page_number>\n<student_unit>/<\/student_unit>\n<student_unit>/g ;
			s/<\/end_date>\n<page_number>.*<\/page_number>\n<student_unit>/<\/end_date>\n<student_unit>/g ;
			s/<\/location>\n<page_number>.*<\/page_number>\n<location>/<\/location>\n<location>/g
		     ' \
	| awk -F '\t' '/^<program/ {print "<\/country>\n<country name=\"" $2 "\">"} ; {print}' \
	| awk 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"} ; {print} ; END {print "<page_number>302<\/page_number>\n<\/training>\n<\/program>\n<\/country>\n<\/countries>"}' \
	| sed '3,6d ; s/	/, /g' \
	> output/"${r}"/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"


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
#		_progMsg "Extracting pages from PDF"
#		_extractPages
		_progMsg "Converting PDF to XML"
##		_xmlConvert
#		_extractPagesXmlConvert # uses just pdftohtml rather than ghostscript step
		_progMsg "Cleaning up XML"
		_cleanXML
		_progMsg "Linting XML"
		_errorCheckXML
		_progMsg "Deduplicating XML"
		_deduplicateXML
		_progMsg "Creating TSV output"
		_generateOutput

	done < src/fmtrpt_fy_2005_2006_sections

	printf "%s\n" "Done!"

}

_main
