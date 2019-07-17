#!/bin/bash
#
# Parsing  FMTRPT FY 2001-2002 from PDF to a tsv (Africa, South Asia, East Asia and Pacific )
#
# tl@sfm / 2017-04-02

# Script safety measures

set -e
shopt -s failglob

# This script just deals with the Africa,  South Asia and East Asia PDFs from 2001-2002, which share a pattern
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
	| grep -v -e "height=\"18\" font=\"0\"" \
	| grep -v -e "font=\"1\"" \
	| grep -v -e "font=\"2\"" \
	| grep -v -e "font=\"4\"" \
	| grep -v -e "font=\"5\"" \
	| grep -v -e "font=\"6\"" \
	| grep -v -e "font=\"7\"" \
	| grep -v -e "font=\"8\"" \
	| grep -v -e "font=\"9\"" \
	| sed -E '/height=\"17\" font=\"0\"/ {
	 		s/^.*<b>//g
			s/<\/b>.*$//g
	 		s/Korea, Republic of/Korea (Republic of)/g
	 		s/Cape Verde, Republic Of/Cape Verde (Republic of)/g
	 		s/Region, /Region	/g
	 		s/(,|, )(FY(01| 01))/	FY01/g
	 		s/,/	/
			s/^/<program name="/g
			s/$/">/g
			1d
						 }' \
	| sed -E '{
			s/^.*left=\"54\".*font=\"3\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"525\".*font=\"3\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"244\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"249\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"250\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"255\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"266\".*font=\"3\">(.*)<\/text>$/<location>\1<\/location>/g
			s/^.*left=\"472\".*font=\"3\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"473\".*font=\"3\">(.*)<\/text>$/<student_unit>\1<\/student_unit>/g
			s/^.*left=\"657\".*font=\"3\">(.*)<\/text>$/<us_unit>\1<\/us_unit>/g
			s/^.*left=\"920\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"928\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"929\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"934\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"940\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"949\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"955\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"960\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"961\".*font=\"3\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			s/^.*left=\"992\".*font=\"3\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"995\".*font=\"3\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"998\".*font=\"3\">(.*)<\/text>$/<start_date>\1<\/start_date>/g
			s/^.*left=\"1068\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"1069\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"1071\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"1072\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g
			s/^.*left=\"1074\".*font=\"3\">(.*)<\/text>$/<end_date>\1<\/end_date>/g

						}' \
	| sed '{
			/^<program/s/^/<\/training>%<\/program>%/g
			/^<course_title>/s/^/<\/training>%<training>%/g
						}' \
	| tr '%' '\n' \
	| perl -00pe 's/(<program name.*)\n<\/training>/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program name.*>\n(<student_unit>)/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program name.*>\n(<us_unit>)/\1/g' \
	| perl -00pe 's/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g' \
	| awk -F '\t' '/^<program/ {print "<\/country>\n<country name=\"" $2 "\">"} ; {print}' \
	| awk 'BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<countries>"} ; {print} ; END {print "<\/training>\n<\/program>\n<\/country>\n<\/countries>"}' \
	| sed '3d ; 4d ; 5d ; s/	/, /g' \
	> output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"

xmllint --huge output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/3_xml_errors/"errors_${y}_${t}_fmtrpt.xml"

xml tr src/deduplicate_training_items.xsl output/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml" > output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml"

xml sel -T -t -m "//training" -v "concat(ancestor::country/@name,'	',ancestor::program/@name,'	',course_title,'	',us_unit,'	',student_unit,'	',start_date,'	',end_date,'	',location,'	',quantity,'	',total_cost)" -n output/4_xml_dedup/"${y}_${t}_fmtrpt_dedup.xml" \
	| sed 's/ \{2,\}/ /g ; s/	 /	/g ; s/ 	/	/g' \
	| awk -v p="${p}" 'BEGIN{print "country\tprogram\tcourse_title\tus_unit\tstudent_unit\tstart_date\tend_date\tlocation\tquantity\ttotal_cost\tsource"};{print $0"\t"p}' \
	> output/5_xml_tsv/"${y}_${t}_fmtrpt.tsv"

	done < src/sections_group_1
