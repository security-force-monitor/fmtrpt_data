#!/bin/bash
#
# Parsing  FMTRPT FY 2017-2018 from PDF to a tsv
#
# tl@sfm / 2017-03-27


# Script safety measures

set -e
shopt -s failglob

# Loop the extractor using a file specifying page name, report year and section as variables
# Grab the page range from the source pdf, and convert to simple xml without frames
# Hit it with lots of filtering and regexing (note: this is fragile)
# Check for well-formedness of inital xml
## script will exit if xmllint throws an error
# XSLT step to deal with training child elements that split across multiple rows (eg. us unit, location):
## See: https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text
# Transform to tsv and output
## See:  https://stackoverflow.com/questions/51988726/recursive-loop-xml-to-csv-with-xmlstarlet

while read -r p y t s e ; do

pdftohtml -c -s -i -noframes -xml -f "${s}" -l "${e}" input/${p}.pdf output/1_pdf_xml/"${y}_${t}_fmtrpt.xml"

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
	| grep -v -e "left=\"54\" width=\"2\"" \
	| sed 's/<text.*left="54".*font="1"><b>\(.*\) <\/b><\/text>/<country name="\1">%<c_name>\1<\/c_name>/g' \
	| sed 's/<text.*left="54".*font="2"><b>\(.*\) <\/b><\/text>/<program name="\1">%<p_name>\1<\/p_name>/g' \
	| sed 's/<text.*left="54".*font="3">\(.*\)<\/text>/<training>%<course_title>\1<\/course_title>/g' \
	| sed 's/<text.*left="324".*font="3">\(.*\)<\/text>/<quantity>\1<\/quantity>/g' \
	| sed 's/<text.*left="378".*font="3">\(.*\)<\/text>/<location>\1<\/location>/g' \
	| sed 's/<text.*left="567".*font="3">\(.*\)<\/text>/<student_unit>\1<\/student_unit>/g' \
	| sed 's/<text.*left="756".*font="3">\(.*\)<\/text>/<us_unit>\1<\/us_unit>/g' \
	| sed 's/<text.*left="945".*font="3">\(.*\)<\/text>/<total_cost>\1<\/total_cost>/g' \
	| sed 's/<text.*left="1026".*font="3">\(.*\)<\/text>/<start_date>\1<\/start_date>/g' \
	| sed 's/<text.*left="1107".*font="3">\(.*\)<\/text>/<end_date>\1<\/end_date>%<\/training>/g' \
	| tr '%' '\n' \
	| grep -v -e "^<text" \
	| perl -00pe 's/<\/training>\n(<program name=\".*\">)/<\/training>\n<\/program>\n\1/g' \
	| perl -00pe 's/<\/training>\n(<country name=\".*\">)/<\/training>\n<\/program>\n<\/country>\n\1/g' \
	| perl -00pe 's/<\/course_title>\n.*<training>/<\/course_title>/g' \
	| perl -00pe 's/<\/training>\n.*<quantity>/<\/training>\n<training>\n<quantity>/g' \
	| awk 'BEGIN{print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"};{print};END{print "<\/program>\n<\/country>\n<\/countries>"}' \
	| sed '/country/s/^/ /g' \
	| sed '/<c_name/s/^/  /g' \
	| sed '/program/s/^/   /g' \
	| sed '/p_name/s/^/     /g' \
	| sed '/training/s/^/      /g' \
	| sed '/course_title/s/^/       /g' \
	| sed '/quantity/s/^/       /g' \
	| sed '/location/s/^/       /g' \
	| sed '/student_unit/s/^/       /g'\
	| sed '/us_unit/s/^/       /g' \
	| sed '/total_cost/s/^/       /g' \
	| sed '/start_date/s/^/       /g' \
	| sed '/end_date/s/^/       /g' \
	> output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"

xmllint --huge output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/3_xml_errors/"errors_${y}_${t}_fmtrpt.xml"

xml tr src/deduplicate_training_items.xsl output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml"

xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	',us_unit,'	',student_unit,'	',start_date,'	',end_date,'	',location,'	',quantity,'	',total_cost)" -n output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tsource"};{print $0"\t"p}' \
	> output/5_xml_tsv/"${y}_${t}_fmtrpt.tsv"

	done < src/fmtrpt_fy_2013_2014_sections


# To do:
# - lots of clean up of the sed/awk/grep etc
# - later iterations (eg. the scripts for the 2006 and earlier, are better
