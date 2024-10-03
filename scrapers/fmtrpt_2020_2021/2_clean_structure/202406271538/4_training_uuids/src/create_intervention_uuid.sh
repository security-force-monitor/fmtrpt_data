#!/bin/bash
#
# Mint UUID for training intervention entity or prepare new dataset for matching with old UUIDs
# 
# tl@sfm	2024-06-19 updated to add newly scraped page_number field
# 			   and blank training ID field for datasets that will
# 			   be later merged with earlier versions of themselves

set -euo pipefail

data="final_fmtrpt_2020_2021_202406271538.tsv"
tmpfile="tmp.tsv" 
blankidcol="blankidcol.tsv"
withids="withids.tsv"

_mintTrainingUUID () {

	# Add a uuid to each row
	# Takes ~5 minutes to complete uuid generation (for full ~250,000k row set)
	# This is run only once to generate IDs

	awk -F"\t" '("uuidgen" | getline uuid) > 0 {print "\""tolower(uuid)"\"" FS $0} {close("uuidgen")}' $1

}

_makeEmptyIDCol () {

	# Where we have rescraped (e.g. to add a new attribute from the PDFs)
	# we will need to match updated dataset with its former uuids
	# A prelimimary step is to add a column to hold the matched training uuid.

	gawk 'BEGIN {FS=OFS="\t"}
			NR==1 {print "\"training:id:admin\"" FS $0}
			NR>1  {print "" FS $0}
			' input/"$data" > notes/"$blankidcol"

}

_renameHeaders () {

# Rename headers to match training model fieldset.
# Raw incoming fieldset has the following headers:
# 1    [a uuid]
# 2    source_uuid
# 3    group
# 4    country
# 5    iso_3166_1
# 6    program
# 7    course_title
# 8    us_unit
# 9    student_unit
# 10   start_date
# 11  start_date_fixed
# 12  end_date
# 13  end_date_fixed
# 14  location
# 15  quantity
# 16  total_cost
# 17  page_number
# 18  source_url
# 19  date_first_seen
# 20  row_status
# 21  date_scraped

gawk 'BEGIN {FS=OFS="\t"}				;
	NR==1 { $1 = "\"training:id:admin\"" 		;
		$2 = "\"training:source\"" 		;
		$3 = "\"qa:training_group\"" 		;
		$4 = "\"training:country\"" 		;
		$5 = "\"training:country_iso_3166_1\"" 	;
		$6 = "\"training:program\"" 		;
		$7 = "\"training:course_title\"" 	;
		$8 = "\"training:delivery_unit\"" 	;
		$9 = "\"training:recipient_unit\"" 	;
		$10 = "\"qa:training_start_date\"" 	;
		$11 = "\"training:start_date\"" 	;
		$12 = "\"qa:training_end_date\"" 	;
		$13 = "\"training:end_date\"" 		;
		$14 = "\"training:location\"" 		;
		$15 = "\"training:quantity\"" 		;
		$16 = "\"training:total_cost\"" 	;
		$17 = "\"training:page_number\""	;
		$18 = "\"qa:training_source_url\"" 	;
		$19 = "\"qa:training_date_first_seen\"" ;
		$20 = "\"training:status:admin\"" ;
		$21 = "\"qa:training_date_scraped\"" }  ;
		{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$21,$20 }' $1

#	Note: longhand printout in final line just reorders the columns

}

_main () {

	# If needed, mind new IDs for each row
        _mintTrainingUUID input/"$data" > notes/"$withids"

	# Just create a new blank column we can use in later steps
#	_makeEmptyIDCol input/"$data" > notes/"$blankidcol"

	# Swap $blankidcol for $withids if working with minted id version
	_renameHeaders notes/"$withids" > output/"$data"

}
_main

