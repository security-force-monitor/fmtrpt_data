#!/bin/bash
set -eup pipefail

data="final_fmtrpt_all_20210806.tsv"
tmpfile="tmp.tsv" 

# Add a uuid to each row
# Takes ~5 minutes to complete
# Only really need to run this once to mint the uuids. 

gawk -F"\t" '("uuidgen" | getline uuid) > 0 {print "\""tolower(uuid)"\"" FS $0} {close("uuidgen")}' input/"$data" > notes/"$tmpfile"

# Rename headers to match training model fieldset:

# Input headers:
# 1   [a uuid]
# 2   source_uuid
# 3   group
# 4   country
# 5   iso_3166_1
# 6   program
# 7   course_title
# 8   us_unit
# 9   student_unit
# 10  start_date
# 11  start_date_fixed
# 12  end_date
# 13  end_date_fixed
# 14  location
# 15  quantity
# 16  total_cost
# 17  source_url
# 18  row_status
# 19  date_first_seen
# 20  date_scraped

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
		$17 = "\"qa:training_source_url\"" 	;
		$18 = "\"training:status:admin\"" 	;
		$19 = "\"qa:training_date_first_seen\"" ;
		$20 = "\"qa:training_date_scraped\"" }  ;
		{print $0}' notes/"$tmpfile" > output/"$data"
