#!/bin/bash
#
# Helpers: finding things out that we need to fix
#
# tl / 2019-07-24
#
# Script safety and debug

set -eu
shopt -s failglob

# Declare input file
# Choose a version of the data to run the helpers against

i="fmtrpt_all_20190606.tsv"

## Get a list of countries, and clean up whitespace
## Use this as basis of determining which ISO code to apply

awk -F "\t" '{gsub(/[ ]+\"$/,"\"",$2); gsub(/^\"[ ]+/,"\"",$2); print $2}' "${i}" \
	| sed 1d \
	| sort \
	| uniq > output/countries

## Get a list of programs, and clean up white space

rm output/programs

awk 	'BEGIN {FS=OFS="\t"} ; {gsub(/[ ]+\"$/,"\"",$3); gsub(/^\"[ ]+/,"\"",$3); gsub(/"/,"",$3); print $3}' "input/${i}" \
		| sed 1d \
		| sort \
		| uniq \
		> output/programs

## Extract program type

rm output/programs_clean

awk 	'BEGIN {FS=OFS=","; print "region,country,program_raw,fy,program_abb"} \
	{print $0}' \
	"output/programs" \
	> output/programs_clean 


## Show me rows where both start date and end date are empty

awk	'BEGIN {FS=OFS="\t"} \
	{if($6=="\"\"" && $7=="\"\"") print $0}' \
	"input/${i}" \
	> output/without_dates.tsv

