#!/bin/bash
#
# Parsing FMTRPT FY 2002-2003 Africa section from PDF to a tsv

# tl@sfm / 2019-12-06
# 	   2024-07-10 Update to orchestrate different runs
#          	      Update to scrape page number from PDFs
#          	      Updated to restore older PDF extraction function
#          2024-07-31 Adapted to handle template C PDFs

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
	# - make any early changes or corrections in the program title rows
	# - fix some course titles that are broken across lines in the XML, and not caught by later grouping
	# - add in a fake placeholder page 0 ("IV-0"), which will anchor the page_number assignment alg
	# - clean up and assign attributes to remaining rows based on left and font position in XML
	# - remove any redundant XML that has escaped processing
	# - fix a couple of XML structure issues, including keeping the <page> tag in between other items, not inside them
	# - assign a page number to every <training> item:
	# -- because pages numbers appear at the bottom of a page in template C PDFs and this alg counts down,
	#    we add a fake 0 placeholder at the top, and add 1 to the <page> values it discovers. However, this
	#    does not work where a section of the report starts from a non-0 page, so we specify this value in 
	#    the input variables, and use awk to insert it.
	# -- we close the final training item manually, for mysterious reasons I don't have time to fix.
	# - handle some tag ordering issues using a perl megagulp
	# - pull the country name out of the program title and give it it's own tag
	# - top with an XML, tail with closing tags along with an actual value ($ne) for the final
	#   closing page number (actual report page, not PDF page number)
	
	cat output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
	| grep  -e "^<text" \
	| grep -v -e "height=\"18\" font=\"0\"" \
	| grep -v -e "font=\"1\"" \
	| grep -v -e "font=\"2\"" \
	| grep -v -e "font=\"3\"" \
	| grep -v -e "font=\"5\"" \
	| grep -v -e "font=\"7\"" \
	| grep -v -e "font=\"8\"" \
	| sed -E '/height=\"17\" font=\"0\"/ {
	 		s/^.*<b>//g
			s/<\/b>.*$//g
	 		s/Korea, Republic of/Korea (Republic of)/g
	 		s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
	 		s/Region, /Region	/g
	 		s/(,|, )(FY(02| 02))/	FY02/g
	 		s/,/	/
			s/^/<program name="/g
			s/$/">/g
			1d
						 }' \
	| sed -E '{
			s/>EIMET<//g
			s/>REGULATOR<//g
			s/>MGT<//g
			s/>TNG\(MELT<//g
			s/LANG LAB VOLTAGE/LANG LAB VOLTAGE REGULATOR/g
			s/BOARDING TEAM MEMBER/BOARDING TEAM MEMBER EIMET/g
			s/EXEC HLTHCARE RESOURCE/EXEC HLTHCARE RESOURCE MGT/g
			s/MANAGING ENG LANG/MANAGING ENG LANG TNG\(MELT/g
						}' \
	| gawk -v nb="$nb" 'BEGIN {print "<page>IV-"nb-1"</page>"};{print}' \
	| sed -E '{
			s/^.*left=\"324\".*font=\"6\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"513\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"519\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"536\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"525\".*font=\"6\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"538\".*font=\"6\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"743\".*font=\"6\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"927\".*font=\"6\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"1198\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1204\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1224\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"121.\".*font=\"6\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"126.\".*font=\"6\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"1339\".*font=\"6\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"134.\".*font=\"6\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"840\".*font=\"4\"><b> (IV-.*)<\/b><\/text>$/<page>\1<\/page>/g
			s/^.*left=\"847\".*font=\"4\"><b> (IV-.*)<\/b><\/text>$/<page>\1<\/page>/g
						}' \
	| grep -v -e "<text.*text>$" \
	| sed '{
			/^<program/s/^/<\/training>%<\/program>%/g
			/^<course_title>/s/^/<\/training>%<training>%/g
						}' \
	| tr '%' '\n' \
	| perl -00pe 's/(<page>IV-[0-9]+<\/page>)\n<\/training>/<\/training>\n\1/g ;
		      s/(<page>IV-[0-9]+<\/page>)\n<\/program>/<\/program>\n\1/g' \
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
	        }'\
	| grep -v "^<page>.*<\/page>$" \
	| perl -00pe '	
			s/(<program name.*)\n<\/training>/\1/g ; 
			s/(<program name.*>)\n<page_number>.*<\/page_number>\n<\/training>/\1/g ;
			s/<\/training>\n<\/program>\n<program name.*>\n(<student_unit>)/\1/g ;
	 		s/<\/training>\n<\/program>\n<program name.*>\n(<us_unit>)/\1/g ;
			s/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g ;
			s/<\/end_date>\n<page_number>.*<\/page_number>\n<student_unit>/<\/end_date>\n<student_unit>/g ;
			s/<\/student_unit>\n<page_number>.*<\/page_number>\n<student_unit>/<\/student_unit>\n<student_unit>/g
			' \
	| awk -F '\t' '/^<program/ {print "<\/country>\n<country name=\"" $2 "\">"} ; {print}' \
	| awk -v ne="$ne" 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"} ; 
			    {print} ; 
			   END {print "<page_number>"ne"<\/page_number>\n<\/training>\n<\/program>\n<\/country>\n<\/countries>"}' \
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
	# 
	# Provide the following input to control the script:
	#  p = input PDF filename without extension
	#  y = fiscal year of report
	#  t = sub-section (e.g. Africa, Western Hemispehere)
	#  s = first page to extract
	#  e = last page to extract
	#  nb = first actual report page number
	#  ne - last actual report page number
	#  r = extraction run ID
	#  
	#  e.g 34329 2003_2004 Africa 1 40 1 40 202407121057

	while IFS=$' ' read -r p y t s e nb ne r; do

		printf "\n%s: \n%s\n" "Run ID" "$r"

                _progMsg "Checking output folder setup"
                _setupOutputFolders

		printf "%s: %s\n\n" "# Working on" "$t"
#		_progMsg "Extracting pages from PDF"
#		_extractPages
		_progMsg "Converting PDF to XML"
#		_xmlConvert
		_extractPagesXmlConvert # uses just pdftohtml rather than ghostscript step
		_progMsg "Cleaning up XML"
		_cleanXML
		_progMsg "Linting XML"
		_errorCheckXML
		_progMsg "Deduplicating XML"
		_deduplicateXML
		_progMsg "Creating TSV output"
		_generateOutput

	done < src/fmtrpt_fy_2002_2003_Africa

	printf "%s\n" "Done!"

}

_main

