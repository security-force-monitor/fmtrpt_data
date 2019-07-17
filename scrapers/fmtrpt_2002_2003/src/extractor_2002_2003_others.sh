#!/bin/bash
#
# Parsing  FMTRPT FY 2003-2003 from PDF to a tsv (sections other than Africa)
#
# tl@sfm / 2017-04-02

# Script safety measures

set -e
shopt -s failglob

# This script just deals with the Africa section, as it is very different from the subsequent section
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
	| grep  -e "^<text" \
	| grep -v -e "height=\"18\" font=\"1\"" \
	| grep -v -e "font=\"0\"" \
	| grep -v -e "font=\"2\"" \
	| grep -v -e "font=\"4\"" \
	| grep -v -e "font=\"5\"" \
	| grep -v -e "font=\"6\"" \
	| grep -v -e "font=\"7\"" \
	| grep -v -e "font=\"8\"" \
	| grep -v -e "font=\"9\"" \
	| grep -v -e "font=\"10\"" \
	| sed -E '/height=\"17\" font=\"1\"/ {
	 		s/^.*<b>//g
			s/<\/b>.*$//g
	 		s/Korea, Republic of/Korea (Republic of)/g
	 		s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
	 		s/Region, /Region	/g
	 		s/(,|, )(FY(01| 01))/	FY01/g
	 		s/,/	/
			s/^/<program name="/g
			s/$/">/g
						 }' \
	| sed -E '{
			s/^.*left=\"324\".*font=\"3\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"513\".*font=\"3\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"519\".*font=\"3\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"536\".*font=\"3\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"525\".*font=\"3\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"538\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"743\".*font=\"3\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"927\".*font=\"3\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"1054\".*font=\"3\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"1096\".*font=\"3\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"1142\".*font=\"3\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"1189\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1198\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1204\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1224\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"121.\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"1230\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"126.\".*font=\"3\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"331\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"1339\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"134.\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
						}' \
	| sed '{
			/^<program/s/^/<\/training>%<\/program>%/g
			/^<course_title>/s/^/<\/training>%<training>%/g
						}' \
	| tr '%' '\n' \
	| perl -00pe 's/(<program name.*)\n<\/training>/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program name.*>\n(<student_unit>)/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program name.*>\n(<quantity>)/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program name.*>\n(<us_unit>)/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g' \
	| awk -F '\t' '/^<program/ {print "<\/country>\n<country name=\"" $2 "\">"} ; {print}' \
	| awk 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"} ; {print} ; END {print "<\/training>\n<\/program>\n<\/country>\n<\/countries>"}' \
	| perl -00pe 's/(<program name.*>)\n<\/training>/\1/g' \
	| sed '3d ; 4d ; 5d ; s/	/, /g' \
	> output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"

xmllint --huge output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/3_xml_errors/"errors_${y}_${t}_fmtrpt.xml"

xml tr src/deduplicate_training_items.xsl output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml"

xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	',us_unit,'	',student_unit,'	',start_date,'	',end_date,'	',location,'	',quantity,'	',total_cost)" -n output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tsource"};{print $0"\t"p}' \
	> output/5_xml_tsv/"${y}_${t}_fmtrpt.tsv"

	done < src/fmtrpt_fy_2002_2003_other_sections
