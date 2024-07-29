#!/bin/bash

# Add page_number columnn to 2006 FMT data

# tl@sfm 2024-07-24 Add page_number columnn to 2006 FMT data to make it compatible with 2024 rescrape data

# Current input from 2019 scrape:
# 
# 1   training:id:admin
# 2   training:source
# 3   qa:training_group
# 4   training:country
# 5   training:country_iso_3166_1
# 6   training:program
# 7   training:course_title
# 8   training:delivery_unit
# 9   training:recipient_unit
# 10  qa:training_start_date
# 11  training:start_date
# 12  qa:training_end_date
# 13  training:end_date
# 14  training:location
# 15  training:quantity
# 16  training:total_cost
# 17  qa:training_source_url
# 18  training:status:admin
# 19  qa:training_date_first_seen
# 20  qa:training_date_scraped

# Expected output for 2024 update:
#
# 1   training:id:admin
# 2   training:source
# 3   qa:training_group
# 4   training:country
# 5   training:country_iso_3166_1
# 6   training:program
# 7   training:course_title
# 8   training:delivery_unit
# 9   training:recipient_unit
# 10  qa:training_start_date
# 11  training:start_date
# 12  qa:training_end_date
# 13  training:end_date
# 14  training:location
# 15  training:quantity
# 16  training:total_cost
# 17  training:page_number
# 18  qa:training_source_url
# 19  training:status:admin
# 20  qa:training_date_first_seen
# 21  qa:training_date_scraped

set -eou pipefail

in="final_fmtrpt_2006_2007_201903171306.tsv"
out="final_fmtrpt_2006_2007_202406271538.tsv"

_addPageColumn () {
	# Add a new column called "training:page_number" in position 17
	# gawk needs to rebuild the structure first, which can't be done in a single process
	# Includes note explaining why 2006 report doesn't have any page numbers (it was web only)
	gawk 'BEGIN {FS=OFS="\t"};
		{ $16 = $16 FS  ; print}' "$1" \
	| gawk ' BEGIN {FS=OFS="\t"};
		NR==1 { $17 = "\"training:page_number\""; print } ;
		NR>1  { $17 = "\"No page numbers: 2006-2007 report was published as web-page, not document.\"" ; print }'

}

_checkColumn () {
	# Verify column has been added by diffing new header output against expected
	# It just reports if there is a difference
	xsv headers -d "\t" "$1" > "notes/ActualOutputHeaders"
	diff -q "notes/ActualOutputHeaders" "notes/ExpectedOutputHeaders"
}

_main () {
	#Add column
	_addPageColumn input/"${in}" > output/"${out}"
	#Check it's worked
	_checkColumn output/"${out}"

}

_main
