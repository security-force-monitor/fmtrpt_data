#!/bin/bash
#
# Foreign Military Training and Assistance dataset
# Create sqlite database using Datasette's sqlite-utils tool
#
# tl@sfm	2024-11-

set -euo pipefail

i="final_fmtrpt_all_202410041854.tsv"

# Fields in 202410041854:
#
# 1   training:id:admin
# 2   training:country
# 3   qa:training_country_iso_3166_1
# 4   training:program
# 5   training:course_title
# 6   training:delivery_unit
# 7   training:recipient_unit
# 8   training:start_date_raw
# 9   qa:training_start_date_clean
# 10  training:end_date_raw
# 11  qa:training_end_date_clean
# 12  training:location
# 13  training:quantity
# 14  training:total_cost
# 15  training:page_number
# 16  training:date_first_seen:admin
# 17  training:data_scraped:admin
# 18  training:status:admin
# 19  training:source_at_publication_level:admin
# 20  training:source_at_volume_section_level:admin
# 21  qa:training_group
# 22  qa:training_source_url
# 23  training:citation_id:admin
# 24  training:source_title_with_volume_section:admin

_createDatabase () {
	# Insert TSV of FMTRPT data into sqlite database

	sqlite-utils insert src/state-department-data.db "training-data" input/"$i" \
		--tsv \
		--pk="training:id:admin" \
		--replace

}

_convertIntegers () {
	# Convert total_cost and training quantity into integers

	sqlite-utils transform src/state-department-data.db "training-data" \
		--type "training:total_cost" integer \
		--type "training:quantity" integer

}

_createIndex () {

	# Index all fields

	sqlite-utils create-index src/state-department-data.db "training-data" \
		"training:id:admin" \
		"training:country" \
		"qa:training_country_iso_3166_1" \
		"training:program" \
		"training:course_title" \
		"training:delivery_unit" \
		"training:recipient_unit" \
		"training:start_date_raw" \
		"qa:training_start_date_clean" \
		"training:end_date_raw" \
		"qa:training_end_date_clean" \
		"training:location" \
		"training:quantity" \
		"training:total_cost" \
		"training:page_number" \
		"training:date_first_seen:admin" \
		"training:data_scraped:admin" \
		"training:status:admin" \
		"training:source_at_publication_level:admin" \
		"training:source_at_volume_section_level:admin" \
		"qa:training_group" \
		"qa:training_source_url" \
		"training:citation_id:admin" \
		"training:source_title_with_volume_section:admin" 
}

_createFullText () {

	# Enable full text search on all fields

	sqlite-utils enable-fts src/state-department-data.db "training-data" \
		"training:id:admin" \
		"training:country" \
		"qa:training_country_iso_3166_1" \
		"training:program" \
		"training:course_title" \
		"training:delivery_unit" \
		"training:recipient_unit" \
		"training:start_date_raw" \
		"qa:training_start_date_clean" \
		"training:end_date_raw" \
		"qa:training_end_date_clean" \
		"training:location" \
		"training:quantity" \
		"training:total_cost" \
		"training:page_number" \
		"training:date_first_seen:admin" \
		"training:data_scraped:admin" \
		"training:status:admin" \
		"training:source_at_publication_level:admin" \
		"training:source_at_volume_section_level:admin" \
		"qa:training_group" \
		"qa:training_source_url" \
		"training:citation_id:admin" \
		"training:source_title_with_volume_section:admin"
}

_main () {

	# Sequence

	_createDatabase
	_convertIntegers
	_createIndex
	_createFullText

}

_main
