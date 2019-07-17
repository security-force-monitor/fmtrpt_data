#!/bin/bash
#
# US DOS FMTRPT 2006-2007 parser: html edition
#
#  tl@sfm / 2014-04-05

# Decription:
#  - parses out html table for 2006-2007 DOD/S FMT report
#  - basically find the right table, which is helpfully flagged in the HTML
#  - collapse the HTML into one row one line
#  - remove all tags and add tabs as field separators
#  - push whole dataset across two tabs
#  - bring programs back one tab, and countries two tags
#  - fill down both country and program using awk (nifty!)
#  - filter out rows with no substantive values, add a header row
#  - bring in the name of the source file by defining as the bash variable p and appending

# Script safety and debug

set -eu
shopt -s failglob

# Extractor loop

while read -r s o p ; do

cat input/"${s}" \
	| awk '/CENTERBLOCK START/,/CENTERBLOCK END/' \
	| sed '/beige/s/<\/B>$/<\/B><\/TR>/g' \
	| sed 's/\(<\/TR>\)/\1£/g' \
	| tr '\n' ' ' \
	| tr '£' '\n' \
	| sed -E '{
			s/<P>//g
			s/<\/P>//g
			s/<TR> <TD>//g
			s/<\/TD> <TD>/	/g
			s/<\/TD><\/TR>//g
			s/<\/TR>//g
			s/<B>//g
			s/<\/B>//g
			s/<U>//g
			s/<\/U>//g
			s/<STRONG>//g
			s/<\/STRONG>//g
			s/&nbsp;/BOO/g
			/FY 2006.*Totals/d
			/Course Title/d
			s/^/		/g
			/beige/s/^		//g
			/BOO.*BOO.*BOO/s/^		/	/g 
			s/BOO//g
			s/&amp;/\&/g
			/CENTERBLOCK END/d
			s/<!--.*<TR>//g
			s/^.*beige.*8>//g
			s/	 {1,}/	/g
			s/ {1,}	//g
			}' \
	| awk 'BEGIN {print "country\tprogram\tcourse_title\tquantity\tlocation\tstudent_unit\tus_unit\tcost\tstart_date\tend_date\tsource"};{print}' \
	| awk '		BEGIN { FS=OFS="\t" } \
			{ if ($1 ~ /^[ \t]*$/) $1=ch; else ch=$1 } 1 \
			{ if ($2 ~ /^[ \t]*$/) $2=ci; else ci=$2 } 2 \
			{ if ($3 != "" && $4!= "") print} ' \
	| awk -F '\t' -v p="${p}" '{ print $1"\t"$2"\t"$3"\t"$7"\t"$6"\t"$9"\t"$10"\t"$5"\t"$4"\t"$8"\t"p } ' \
	| awk 'BEGIN {FS=OFS="\t"}; { NR == 1 ; if ( NR == 1 ) $11 = "source" ; print $0}' \
	> output/"${o}.tsv"
	done < src/2006_2007_source_list
