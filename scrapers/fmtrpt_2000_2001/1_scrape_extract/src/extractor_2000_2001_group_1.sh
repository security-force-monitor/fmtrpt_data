#!/bin/bash
#
# Parsing FMTRPT FY 2000-2001 (Group 1)

# tl@sfm / 2019-12-06
# 	   2024-07-10 Update to orchestrate different runs
#          	      Update to scrape page number from PDFs
#          	      Updated to restore older PDF extraction function
#          2024-07-31 Adapted to handle template C PDFs
#          2024-09-   Adapted to handle columnar PDFs which aren't cleanly broken into regions
#          	      Refactor _cleanXML into subroutine

# Script safety

set -e
shopt -s failglob

# Functions

_progMsg () {
	# Write helpful messages to terminal if we need one
	printf " + %s\n" "$1"
}

_extractPages () {
	# Use GhostScript to extract PDF from specific page ranges
	# This step is more robust than just using pdftohtml, but may create backwards compatibility problems
	# Note that voluminous gs terminal chatter is routed to the bin
	# Function is cribbed and adapted from this blog:
	# https://www.linuxjournal.com/content/tech-tip-extract-pages-pdf
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

# Sequence of functions used in _cleanXML sub-routine
#
_firstFixes () {
	# Odds and ends that just need bodging because they're just too annoying to fix in other ways
	# - Fix for single item where program title goes over 3 lines rather than 2 (just pull "FY 00" into the previous line)
	# - Although this is actually fixed by _composeProgramTitle, but it's a useful step nonetheless
	sed -E '{
		s/<b>Grenadines, Center For Hemispheric Defense Studies,<\/b>/<b>Grenadines, Center For Hemispheric Defense Studies, FY 00<\/b>/g
		s/>AMPHIB WARFARE SCHOOL </>AMPHIB WARFARE SCHOOL USMC</g
		s/>USMC<//g
		}'

}

_trimLeadingTrailingItems () {
	# trim raw XML for particular Region to remove leading or trailing trainings from other regions which appear on those pages
	 case "${t}" in
		"Africa")
			sed "1,4d ; 6057,6160d"
			# Australia items at end of PDF page 20
			;;
		esac
}

_composeProgramTitle () {
	# Deal with scenarios where program title attribute is spread across 3 or 2, and single, lines. 
	# # Assign <text_program_name> as a placeholder we can use to anchor cleanup ops below

	perl -00pe 's/<text.*left="486".*height="11" font="2">(.*)<\/text>\n<text.*left="486".*height="11" font="2">(.*)<\/text>\n<text.*left="486".*height="11" font="2">(.*)<\/text>/<text_program_name>\1%\2%\3<\/text_program_name>/g ;
		    s/<text.*left="87".*height="11" font="2">(.*)<\/text>\n<text.*left="87".*height="11" font="2">(.*)<\/text>\n<text.*left="87".*height="11" font="2">(.*)<\/text>/<text_program_name>\1%\2%\3<\/text_program_name>/g ;
		    s/<text.*left="486".*height="11" font="2">(.*)<\/text>\n<text.*left="486".*height="11" font="2">(.*)<\/text>/<text_program_name>\1%\2<\/text_program_name>/g ;
	            s/<text.*left="87".*height="11" font="2">(.*)<\/text>\n<text.*left="87".*height="11" font="2">(.*)<\/text>/<text_program_name>\1%\2<\/text_program_name>/g ;
		    s/<text.*left="486".*height="11" font="2">(.*)<\/text>/<text_program_name>\1<\/text_program_name>/g ;
		    s/<text.*left="87".*height="11" font="2">(.*)<\/text>/<text_program_name>\1<\/text_program_name>/g'
}

_cleanProgramTitle () {
	# Create the <program> tags by removing styling, fixing some irregularities,
	# tab-separating country, program name
	# Assign another temp tag so we can keep passing it through the filtering easily
	 sed -E '/<text_program_name>/ {
 			s/<b>//g
			s/<\/b>//g
	   		s/Korea, Republic of/Korea (Republic of)/g
            	 	s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
			s/<text_program_name>//g
			s/<\/text_program_name>//g
			s/^.*Region, //g
			s/FY[\s\+|]([00|01])/FY\1/g
			s/%/ /g
			s/ {2,}/ /g
			s/, \+/, /g
			s/,FY/, FY/g
			s/, /\t/
			s/^/<text program name=\"/g
			s/$/">/g
		}'
}

_filterOutUselessLines () {
	# Filter out roes that don't begin with the <text> tag
	# Sequentially exclude rows we don't need
	grep -e "^<text" \
	| grep -v -e "font=\"2\"><b>[0-9].*$"\
	| grep -v -e "font=\"2\"><b>.*Totals:.*$"\
	| grep -v -E "font=\"2\"><b>\\$.*<\/b>.*$"\
	| grep -v -e ">Cost<\/text>$" \
	| grep -v -e ">Title <\/text>$" \
	| grep -v -e ">of # <\/text>$"
}

_assignTrainingAttributes () {
	# Assign attribute tags to rows based on the "left" and "font" values
	# Note that page numbers are not assigned from the <page> tag but captured from inside the text
	sed -E '{
			# Left column
			s/^.*left=\"87\".*font=\"1\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"3[01][23458]\".*font=\"1\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"3[5-9][0-9]\".*font="\1\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			# Right column
			s/^.*left=\"486\".*font=\"1\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"7[01][23478]\".*font=\"1\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"7[5-9][0-9]\".*font="\1\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			# Pages
			s/^.*top=\"1120\".*height=\"13\".*>([0-9]+)<\/text>$/<page>\1<\/page>/g
			# Program
			s/<text program/<program/g
		}'

}

_filterOutNonText () {
	# Exclude lines still wrapped in a text tag
	grep -v -e "<text.*text>$"
}

_addTrainingTagsToProgram () {
	# Last <training> before <program> attribute needs a closing tag
	# <training> tag started and closed before <course_title> attribute
	# Token inserted to generate line breaks
	sed '{
			/^<program/s/^/<\/training>%<\/program>%/g
			/^<course_title>/s/^/<\/training>%<training>%/g
		}'
}

_splitLines () {
	# Generate line breaks
	tr '%' '\n'
}

_wrapPageTags () {
	# Make sure <page> tag is not trapped inside a <training> item
	 perl -00pe 's/(<page>[0-9]+<\/page>)\n<\/training>/<\/training>\n\1/g ;
		     s/(<page>[0-9]+<\/page>)\n<\/program>/<\/program>\n\1/g'
}

_assignPageNumbers () {
	# Capture <page> content and insert in <page_number> attribute just before closing <training> tag
	# The effect is to assign a page number to each training item
	gawk 'BEGIN { FS = "" ;page = "" }
		{	if ($0 ~ /^<page>[0-9]+<\/page>$/) {
       			print $0
        			match($0, /[0-9]+/, arr)
        			page = arr[0]
    		 } 	else if ($0 ~ /^<\/training>$/ ) {
        			print "<page_number>"page"</page_number>\n" $0
    		 } 	else {
        			print $0
    		 } 
	        }'
}

_removeOldPageTags () {
	# Print everything except the <page> tags, because we don't need them now
	grep -v "^<page>.*<\/page>$" 
}

_massageXMLStructure () {
	# The XML structure is broken in some cases, which we fix with substitutions that correct the nesting order
	# Also extracts <country> varaible from <program> variable
	perl -00pe '	
			s/(<program name.*)\n<\/training>/\1/g ; 
			s/(<program name.*>)\n<page_number>.*<\/page_number>\n<\/training>/\1/g ;
			s/<\/training>\n<\/program>\n<program name.*>\n(<student_unit>)/\1/g ;
	 		s/<\/training>\n<\/program>\n<program name.*>\n(<us_unit>)/\1/g ;
			s/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g ;
			s/<\/end_date>\n<page_number>.*<\/page_number>\n<student_unit>/<\/end_date>\n<student_unit>/g ;
			s/<\/student_unit>\n<page_number>.*<\/page_number>\n<student_unit>/<\/student_unit>\n<student_unit>/g;
			s/<program name="(.*)	(.*)">/<\/country>\n<country name="\1">\n<program name="\2">/g
			'
}

_finaliseXMLStructure () {
	# Add an XML header and footer that balances the XML structure
	awk -v ne="$ne" 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"}
			    {print}
			 END {print "<page_number>"ne"<\/page_number>\n<\/training>\n<\/program>\n<\/country>\n<\/countries>"}'
}

_closingFixes () {
	# Remove any final troublesome lines not caught by earlier steps
	sed '3,10d; s/	/, /g'
}

# CleanXML sub-routine

_cleanXML () {

	# main cleanup sequence

	cat output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
		| _firstFixes \
		| _trimLeadingTrailingItems \
		| _composeProgramTitle \
		| _cleanProgramTitle \
		| _filterOutUselessLines \
		| _assignTrainingAttributes \
		| _filterOutNonText \
		| _addTrainingTagsToProgram \
		| _splitLines \
		| _wrapPageTags \
		| _assignPageNumbers \
		| _removeOldPageTags \
		| _massageXMLStructure \
		| _finaliseXMLStructure \
		| _closingFixes \
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

	xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	','US Unit not included in 2000-2001 report','	','Student Unit not included in 2000-2001 report','	','Start date not included in 2000-2001 report','	','End date not included in 2000-2001 report','	','Training location not included in 2000-2001 report','	',quantity,'	',total_cost,'	',page_number)" -n output/"${r}"/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
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

	done < src/sections_2000_2001_group_1

	printf "%s\n" "Done!"

}

_main
