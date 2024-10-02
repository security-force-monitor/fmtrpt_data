#!/bin/bash
#
# Parsing FMTRPT FY 1999-2000 (HTML format)

# tl@sfm / 2019-12-06
# 	   2024-07-10 Update to orchestrate different runs
#          	      Update to scrape page number from PDFs
#          	      Updated to restore older PDF extraction function
#          2024-07-31 Adapted to handle template C PDFs
#          2024-09-   Adapted to handle columnar PDFs which aren't cleanly broken into regions
#          	      Refactor _cleanXML into subroutine
#          	      Refactor to parse HTML

# Script safety

set -e
shopt -s failglob

# Functions

_progMsg () {
	# Write helpful messages to terminal if we need one
	printf " + %s\n" "$1"
}

_curlGetHTML () {
	# Save HTML to local file
	# CloudFront will block request if curl doesn't supply a user agent
	# For up to date user agents: https://www.whatismybrowser.com/guides/the-latest-user-agent/firefox
	curl --fail \
	     --silent \
	     --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 14.7; rv:130.0) Gecko/20100101 Firefox/130.0" \
	     --url "${u}" \
	     --output input/"${p}.html"
}

_moveHTML () {
	# Drops raw HTML into 1_pdf_xml step
	cp input/"${p}.html" output/"${r}"/1_pdf_xml/"${y}_${t}_${s}_fmtrpt.html"
}

_cleanFirstFixes () {
	# Quality of life improvements:
	# - mostly fixing items that go over two lines, by pulling one into another
	# - important that the substitutions here are as specific as possible
	# - next time, organise them by input file so we can better track their impact
	sed -E '{

		# Basic formatting fixes
		s/<\/TABLE>//g
		s/<\/TD><TD><\/TD><\/TR>$/<\/TD><\/TR>/g
		s/&amp;/\&/g
		s/\&/&amp;/g
		/<TR><TD>&amp;nbsp;<\/TD><\/TR>/d
		/^<TR><TD>$/d
		/^<TR><TD>Title of <\/TD><TD># <\/TD><TD ALIGN=\"RIGHT\">Cost<\/TD><\/TR>$/d
		/^<TR><TD><\/TR>$/d
		s/<TR><TD>\(<B>FMF\)/<TR><TD><B>\(FMF\)/g
		s/TR><TD>H<B>onduras/TR><TD><B>Honduras/g
		s/<TR><TD><B>Enforcement \(INL\), FY 0<\/B>0<\/TD><\/TR>/<TR><TD><B>Enforcement \(INL\), FY 00<\/B><\/TD><\/TR>/g

		# Progrm title fixes
		s/^<B> Albania, International Military Education And/<TR><TD><B> Albania, International Military Education And/g 
		s/^<B>Bangladesh, International Military Education And/<TR><TD><B>Bangladesh, International Military Education And/g
		s/^<TR><TD>Brazil, Exchanges, FY 99<\/TD><\/TR>$/<TR><TD><B>Brazil, Exchanges, FY 99<\/B><\/TD><\/TR>/g
		s/^ <B>Croatia, International Military Education And/<TR><TD><B>Croatia, International Military Education And/g 
		s/^ <B>Estonia, Foreign Military Financing \(FMF\) Program/<TR><TD><B>Estonia, Foreign Military Financing \(FMF\) Program/g
		s/^ <B>Lithuania, International Military Education And<\/B> <\/TD><\/TR>/<TR><TD><B>Lithuania, International Military Education And<\/B><\/TD><\/TR>/g
		s/<TR><TD>Peru, Section 1004 - DoD Drug Interdiction, FY 00<\/TD><\/TR>/<TR><TD><B>Peru, Section 1004 - DoD Drug Interdiction, FY 00<\/B><\/TD><\/TR>/g
		s/<TR><TD>Peru, Service Academy, FY 99<\/TD><\/TR>/<TR><TD><B>Peru, Service Academy, FY 99<\/B><\/TD><\/TR>/g
		s/^<TR><TD>Egypt, Foreign Military Financing \(FMF\) Program, FY<\/TD><\/TR>$/<TR><TD><B>Egypt, Foreign Military Financing \(FMF\) Program, FY<\/B><\/TD><\/TR>/g
		s/^<TR><TD> 00<\/TD><\/TR>$/<TR><TD><B> 00<\/B><\/TD><\/TR>/g
		s/^<TR><TD>Lebanon, Non-Security Assistance, Unified Command <\/TD><\/TR>/<TR><TD><B>Lebanon, Non-Security Assistance, Unified Command<\/B><\/TD><\/TR>/g
		s/<TR><TD>Benin, International Military Education And Training<\/TD><\/TR>/<TR><TD><B>Benin, International Military Education And Training<\/B><\/TD><\/TR>/g
		s/<B>Tanzania,<\/B>/Tanzania,/g
		s/<TR><TD>Tunisia, International Military Education And <\/TD><\/TR>/<TR><TD><B>Tunisia, International Military Education And <\/B><\/TD><\/TR>/g
		s/<TR><TD>Training \(IMET\), FY 00<\/TD><\/TR>/<TR><TD><B>Training \(IMET\), FY 00<\/B><\/TD><\/TR>/g
		s/<TR><TD><B>Training \(IMET\), FY 0<\/B>0<\/TD><\/TR>/<TR><TD><B>Training \(IMET\), FY 00<\/B><\/TD><\/TR>/g
		s/<TR><TD>Z<B>imbabwe/<TR><TD><B>Zimbabwe/g
		s/<TR><TD>Engagement Activities, FY 00<\/TD><\/TR>/<TR><TD><B>Engagement Activities, FY 00<\/B><\/TD><\/TR>/g
		s/<TR><TD> Engagement Activities, FY 00<\/TD><\/TR>/<TR><TD><B>Engagement Activities, FY 00<\/B><\/TD><\/TR>/g
		s/<TR><TD>Engagement Activities, FY 99<\/TD><\/TR>/<TR><TD><B>Engagement Activities, FY 99<\/B><\/TD><\/TR>/g
		s/<\/B> <\/TD><\/TR>$/<\/B><\/TD><\/TR>/g
		s/<TR><TD>( \(IMET\), FY [09][09])<\/TD><\/TR>/<TR><TD><B>\1<\/B><\/TD><\/TR>/g
		s/<TR><TD>(\(IMET\), FY [09][09])<\/TD><\/TR>/<TR><TD><B>\1<\/B><\/TD><\/TR>/g
		s/<TR><TD> (FY [09][09])<\/TD><\/TR>/<TR><TD><B>\1<\/B><\/TD><\/TR>/g
		s/^<TR><TD> <B>/<TR><TD><B>/g
		s/<TR><TD>(Training \(IMET\), FY 99)<\/TD><\/TR>/<TR><TD><B>\1<\/B><\/TD><\/TR>/g

		# Broken lines with JCET
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>35<\/TD><TD ALIGN=\"RIGHT\">\$63,000<\/TD><\/TR>)$/\1 CONTINUING \2/g
		/^<TR><TD>CONTINUING<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>12<\/TD><TD ALIGN=\"RIGHT\">\$47,000<\/TD><\/TR>)$/\1 AVALANCE \2/g
		/^<TR><TD>AVALANCHE <\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>326<\/TD><TD ALIGN=\"RIGHT\">\$58,000<\/TD><\/TR>)$/\1 MARKMANSHI \2/g
		/^<TR><TD>MARKMANSHI<\/TD><\/TR>$/d
		s/(^<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>56<\/TD><TD ALIGN=\"RIGHT\">\$136,000<\/TD><\/TR>)$/\1 NAVIGATION \2/g
		/^<TR><TD>NAVIGATION<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>61<\/TD><TD ALIGN=\"RIGHT\">\$126,000<\/TD><\/TR>)$/\1 MOUNTAIN, \2/g
		/^<TR><TD>MOUNTAIN, <\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>99<\/TD><TD ALIGN=\"RIGHT\">\$89,000<\/TD><\/TR>)$/\1 NAVIGATION \2/g
		/^<TR><TD>NAVIGATION<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>23<\/TD><TD ALIGN=\"RIGHT\">\$56,000<\/TD><\/TR>)$/\1 LEADERSHIP \2/g
		/^<TR><TD>LEADERSHIP<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>90<\/TD><TD ALIGN=\"RIGHT\">\$60,000<\/TD><\/TR>)$/\1 PEACEKEEPI \2/g
		/^<TR><TD>PEACEKEEPI<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>12<\/TD><TD ALIGN=\"RIGHT\">\$96,000<\/TD><\/TR>)$/\1 ADVANCED S \2/g
		/^<TR><TD>ADVANCED S<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>22<\/TD><TD ALIGN=\"RIGHT\">\$40,000<\/TD><\/TR>)$/\1 LEADERSHIP \2/g
		/^<TR><TD>LEADERSHIP<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>68<\/TD><TD ALIGN=\"RIGHT\">\$154,000<\/TD><\/TR>)$/\1 LEADERSHIPS \2/g
		/^<TR><TD>LEADERSHIP<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>24<\/TD><TD ALIGN=\"RIGHT\">\$55,000<\/TD><\/TR>)$/\1 MARKSMANSH \2/g
		/^<TR><TD>MARKSMANSH<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>27<\/TD><TD ALIGN=\"RIGHT\">\$40,000<\/TD><\/TR>)$/\1 LEADERSHIP \2/g
		/^<TR><TD>LEADERSHIP<\/TD><\/TR>$/d
		s/(<TR><TD>JCET: SOF METL TNG: LAND)( <\/TD><TD>14<\/TD><TD ALIGN=\"RIGHT\">\$73,000<\/TD><\/TR>)$/\1 WARFA\2/g
		/<TR><TD>WARFA<\/TD><\/TR>/d
		s/^(<TR><TD>JCET: SOF METL TNG: MOUNTAIN)(<\/TD><TD>8<\/TD><TD ALIGN=\"RIGHT\">$13,000<\/TD><\/TR>)$/\1 \&amp; \2/g
		/^<TR><TD> &amp;<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MEDICAL )(<\/TD><TD>42<\/TD><TD ALIGN=\"RIGHT\">\$53,000<\/TD><\/TR>)$/\1 CL \2/g
		/^<TR><TD>CL<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MARITIME )(<\/TD><TD>58<\/TD><TD ALIGN=\"RIGHT\">\$121,000<\/TD><\/TR>)$/\1 O \2/g
		/^<TR><TD>O<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: CLOSE )(<\/TD><TD>45<\/TD><TD ALIGN=\"RIGHT\">\$138,000<\/TD><\/TR>)$/\1 QUAR \2/g
		/^<TR><TD>QUAR<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: LAND )(<\/TD><TD>120<\/TD><TD ALIGN=\"RIGHT\">\$89,200<\/TD><\/TR>)$/\1 NAVIG \2/g
		/^<TR><TD>NAVIG<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: LAND )(<\/TD><TD>14<\/TD><TD ALIGN=\"RIGHT\">\$73,000<\/TD><\/TR>)$/\1 WARFAR \2/g
		/^<TR><TD>WARFA<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: LAND )(<\/TD><TD>10<\/TD><TD ALIGN=\"RIGHT\">\$20,000<\/TD><\/TR>)$/\1 NAVIG \2/g
		/^<TR><TD>NAVIG<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MOUNTAIN)(<\/TD><TD>63<\/TD><TD ALIGN=\"RIGHT\">\$124,000<\/TD><\/TR>)$/\1 0 \2/g
		/^<TR><TD> O<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MOUNTAIN)(<\/TD><TD>8<\/TD><TD ALIGN=\"RIGHT\">\$13,000<\/TD><\/TR>)$/\1 \&amp; \2/g
		/^<TR><TD> &amp;<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MEDICAL )(<\/TD><TD>24<\/TD><TD ALIGN=\"RIGHT\">\$112,000<\/TD><\/TR>)$/\1 TR \2/g
		/^<TR><TD>TR<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: MEDICAL )(<\/TD><TD>42<\/TD><TD ALIGN=\"RIGHT\">\$53,000<\/TD><\/TR>)$/\1 CL \2/g
		/^<TR><TD>CL<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: PSYOP, )(<\/TD><TD>31<\/TD><TD ALIGN=\"RIGHT\">\$207,000<\/TD><\/TR>)$/\1 CMO \2/g
		/^<TR><TD>CMO<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: BOAT )(<\/TD><TD>40<\/TD><TD ALIGN=\"RIGHT\">\$45,000<\/TD><\/TR>)$/\1 HANDL \2/g
		/^<TR><TD>HANDL<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: COLD )(<\/TD><TD>80<\/TD><TD ALIGN=\"RIGHT\">\$66,000<\/TD><\/TR>)$/\1 WEATH \2/g
		/^<TR><TD>WEATH<\/TD><\/TR>/d
		s/^(<TR><TD>JCET: SOF METL TNG: )(<\/TD><TD>12<\/TD><TD ALIGN=\"RIGHT\">\$47,000<\/TD><\/TR>)$/\1 AVALANCHE \2/g
		/^<TR><TD>AVALANCHE <\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: PATROL )(<\/TD><TD>55<\/TD><TD ALIGN=\"RIGHT\">\$170,000<\/TD><\/TR>)$/\1 FOR \2/g
		/^<TR><TD>FOR<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: SQ\/PLT )(<\/TD><TD>66<\/TD><TD ALIGN=\"RIGHT\">\$87,000<\/TD><\/TR>)$/\1 MOV \2/g
		/<TR><TD>MOV<\/TD><\/TR>/d
		s/^(<TR><TD>JCET: SOF METL TNG: NCO )(<\/TD><TD>28<\/TD><TD ALIGN=\"RIGHT\">\$118,000<\/TD><\/TR>)$/\1 LEADER \2/g
		/^<TR><TD>LEADER<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: CQB ROOM )(<\/TD><TD>40<\/TD><TD ALIGN=\"RIGHT\">\$120,000<\/TD><\/TR>)$/\1 C \2/g
		/^<TR><TD>C<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: BOAT &amp; )(<\/TD><TD>7<\/TD><TD ALIGN=\"RIGHT\">\$25,000<\/TD><\/TR>)$/\1 END \2/g
		/^<TR><TD>ENG<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG: RURAL )(<\/TD><TD>64<\/TD><TD ALIGN=\"RIGHT\">\$86,000<\/TD><\/TR>)$/\1 OPER \2/g
		/^<TR><TD>OPER<\/TD><\/TR>$/d
		s/^(<TR><TD>JCET: SOF METL TNG:LIGHT )(<\/TD><TD>31<\/TD><TD ALIGN=\"RIGHT\">\$83,000<\/TD><\/TR>)$/\1 INFAN \2/g
		/^<TR><TD>INFAN<\/TD><\/TR>$/d

		# Other broken lines
		s/^(<TR><TD>INFORMATION MANAGEMENT )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$1,040<\/TD><\/TR>)$/\1 APR \2/g
		/^<TR><TD>APR<\/TD><\/TR>$/d
		s/^(<TR><TD>COMMAND AND CONTROL )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$7,805<\/TD><\/TR>)$/\1 SYSTEM \2/g
		/^<TR><TD>SYSTEM<\/TD><\/TR>$/d
		s/^(<TR><TD>TRNG,MANPWR&amp;PERS )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$10,000<\/TD><\/TR>)$/\1 MGT-CONUS \2/g
		/^<TR><TD>MGT-CONUS<\/TD><\/TR>$/d
		s/^(<TR><TD>FUNDAMENTAL OF )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$657<\/TD><\/TR>)$/\1 CONTRACTING \2/g
		/^<TR><TD>CONTRACTING<\/TD><\/TR>$/d
		s/^(<TR><TD>QUALITY ENVIRONMENTAL )(<\/TD><TD>8<\/TD><TD ALIGN=\"RIGHT\">$141,968<\/TD><\/TR>)$/\1 MGMT \2/g
		/<TR><TD>MGMT<\/TD><\/TR>/d
		s/^(<TR><TD>QUALITY MANAGEMENT )(<\/TD><TD>4<\/TD><TD ALIGN=\"RIGHT\">\$0<\/TD><\/TR>)$/\1 PROGRAM \2/g
		/^<TR><TD>PROGRAM<\/TD><\/TR>$/d
		s/^(<TR><TD>SUMMER MOUNTAIN LEADERS )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$555<\/TD><\/TR>)$/\1 CR \2/g
		/^<TR><TD>CR<\/TD><\/TR>$/g
		s/^(<TR><TD>AWC )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$4,020<\/TD><\/TR>)$/\1CORRESPONDENCE\/RESIDEN\2/g
		/^<TR><TD>CORRESPONDENCE\/RESIDEN<\/TD><\/TR>$/d
		s/^(<TR><TD>CONTINGENCY PREP )(<\/TD><TD>1<\/TD><TD ALIGN=\"RIGHT\">\$555<\/TD><\/TR>)$/\1 CMD\&amp;CONTL \2/g
		/^<TR><TD>CMD&amp;CONTL<\/TD><\/TR>$/d

		# No edge cases so general sub
		s/<TD>JCET: SOF METL TNG: SMALL <\/TD>/<TD>JCET: SOF METL TNG: SMALL UNIT<\/TD>/g
		/^<TR><TD>UNIT<\/TD><\/TR>$/d
		s/<TD>ELECTROMAGNETIC SPECTM <\/TD>/<TD>ELECTROMAGNETIC SPECTM MGT<\/TD>/g
		/<TR><TD>MGT<\/TD><\/TR>/d
		s/<TD>AMPHIB WARFARE SCHOOL <\/TD>/<TD>AMPHIB WARFARE SCHOOL USMC<\/TD>/g
		/^<TR><TD>USMC<\/TD><\/TR>$/d
		s/<TD>ADVANCED SUPPLY <\/TD>/<TD>ADVANCED SUPPLY MANAGEMENT<\/TD>/g
		/^<TR><TD>MANAGEMENT<\/TD><\/TR>$/d
		s/^<TR><TD>RESOURCE MANAGEMENT <\/TD>/<TR><TD> RESOURCE MANAGEMENT CRS-SP <\/TD>/g
		/^<TR><TD>CRS-SP<\/TD><\/TR>$/d
		s/^<TR><TD>ADVANCED INSTRUMENT <\/TD>/<TR><TD>ADVANCED INSTRUMENT SCHOOL <\/TD>/g
		/^<TR><TD>SCHOOL<\/TD><\/TR>$/d

	}'

}

_cleanGetTables () {
	# Remove everything that's not a HTML table row
	gawk '$0 ~ /^<TR><TD>.*>$/'
}

_cleanConcatProgramTitles () {
	# Titles have a <B> tag; pulls content of rows with two <B> tags into a single item
	perl -00pe 's/<TR><TD><B>(.*)<\/B><\/TD><\/TR>\n<TR><TD><B>(.*)<\/B><\/TD><\/TR>/<TR><TD><B>\1 \2<\/B><\/TD><\/TR>/g'
}

_cleanAddProgramTitle() {
	# The second regex subs the first command for a tab, delineating the country part clearly
	sed -E '/^<TR><TD><B>/s/^<TR><TD><B>(.*)<\/B><\/TD><\/TR>/<program name="\1">/g ;
		/<program/s/,/	/
		'
}

_cleanRemoveTotals () {
	# Clear out the table rows that have totals in them
	gawk '$0 !~ /^<TR><TD>.*Totals:/'

}

_cleanWrapTrainingItem () {
	# Wrap the training items in our XML structure
	
	sed -E 's/^<TR><TD>(.*)<\/TD><TD>(.*)<\/TD><TD ALIGN="RIGHT">(\$.*)<\/TD><\/TR>$/<training>%<course_title>\1<\/course_title>%<quantity>\2<\/quantity>%<total_cost>\3<\/total_cost>%<\/training>/g ;
	s/^<TR><TD>(.*)<\/TD><TD>(.*)<\/TD><\/TR>$/<training>%<course_title>\1<\/course_title>%<quantity>\2<\/quantity>%<\/training>/g'

}

_cleanExpandTrainingItem () {
	# Bump attributes into own row
	tr '%' '\n'
}

_cleanCreateCountryTag () {
	# Use tab inserted earlier to fish out country from program and year
	perl -00pe 's/<program name="(.*)	 (.*, .*)">/<\/program>\n<\/country>\n<country name="\1">\n<program name="\2">/g'
}

_cleanFinaliseXMLStructure () {
         # Add an XML header and footer that balances the XML structure
         gawk 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"}
                             {print}
                          END {print "</program>\n</country>\n</countries>"}'
}

_cleanFinalFixes () {
	# Remove annoying processing cruft and any other last fixes that are needed
	sed -E '{
		3,4d
	}'
}

# Clean HTML subroutine

_cleanHTML () {
	# main cleanup sequence
	cat output/"${r}"/1_pdf_xml/"${y}_${t}_${s}_fmtrpt.html" \
		| _cleanFirstFixes \
		| _cleanGetTables \
		| _cleanConcatProgramTitles \
		| _cleanAddProgramTitle \
		| _cleanRemoveTotals \
		| _cleanWrapTrainingItem \
		| _cleanExpandTrainingItem \
		| _cleanCreateCountryTag \
		| _cleanFinaliseXMLStructure \
		| _cleanFinalFixes \
	> output/"${r}"/2_xml_refine/"${y}_${t}_${s}_fmtrpt_raw.xml"
}

_errorCheckXML () {
	# Check the XML for errors. When it (finally) passes, we're all good.
	# You can also use xml el -u on the same input to check the xml structure.
	xmllint --huge output/"${r}"/2_xml_refine/"${y}_${t}_${s}_fmtrpt_raw.xml" > output/"${r}"/3_xml_errors/"errors_${y}_${t}_${s}_fmtrpt.xml"
}

_deduplicateXML () {
	# Apply XSLT tranformation to xml to merge entries that span multiple enties in the XML.
	# For XSLT explanation see: https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text
	xml tr src/deduplicate_training_items.xsl output/"${r}"/2_xml_refine/"${y}_${t}_${s}_fmtrpt_raw.xml" > output/"${r}"/4_xml_dedup/"${y}_${t}_${s}_fmtrpt_dedup.xml"
}

_generateOutput () {

	# Generate a TSV output from the XSML, clean up some spacing and tabbing cruft, and apply a header row.
	# For explanation of use of xml ancestors: https://stackoverflow.com/questions/51988726/recursive-loop-xml-to-csv-with-xmlstarlet
	# Insert name of source file into the final column
	xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	','US Unit not included in 1999-2000 report','	','Student Unit not included in 1999-2000 report','	','Start date not included in 1999-2000 report','	','End date not included in 1999-2000 report','	','Training location not included in 1999-2000 report','	',quantity,'	',total_cost,'	','Page number not included in 1999-2000 report')" -n output/"${r}"/4_xml_dedup/"${y}_${t}_${s}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tpage_number\tsource"};{print $0 "\t" p}' \
	> output/"${r}"/5_xml_tsv/"${y}_${t}_${s}_fmtrpt.tsv"
}

_setupOutputFolders () {

         # Create folder structure using extraction run ID as root
         # if it doesn't already exist (-p option)
        mkdir -p output/"${r}"/{0_pdf_slice,1_pdf_xml,2_xml_refine,3_xml_errors,4_xml_dedup,5_xml_tsv}
}

_main () {
	# Extracts and parses different sections of the FMTRPT in HTML format
	#
	# Provide the following space-separated input sto control the script:
	#  p = input HTML filename without extension
	#  y = fiscal year of report
	#  t = sub-section (e.g. Africa, Western Hemispehere)
	#  s = chapter within sub-section (e.g. "3")
	#  u = URL for report section and chatper (e.g. Western Hemisphere is published across 5 HTML pages)
	#  r = extraction run ID
	#
	#  e.g. "cta_af_a2gam 1999_2000 Africa 1 https://1997-2001.state.gov/global/arms/fmtrain/cta_af_a2gam.html 202407121057"
	while IFS=$' ' read -r p y t s u r; do

		printf "\n%s: \n%s\n" "Run ID" "$r"

                _progMsg "Checking output folder setup"
                _setupOutputFolders

		printf "%s: %s\n\n" "# Working on" "$t - $s"

#		_progMsg "Obtaining HTML"
#		_curlGetHTML
#		_progMsg "Moving HTML into workflow"
#		_moveHTML
		_progMsg "Cleaning up HTML"
		_cleanHTML
		_progMsg "Linting XML"
		_errorCheckXML
		_progMsg "Deduplicating XML"
		_deduplicateXML
		_progMsg "Creating TSV output"
		_generateOutput

	done < src/sections_1999_2000

	printf "%s\n" "Done!"

}

_main
