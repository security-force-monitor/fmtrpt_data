#!/bin/bash
#
# Foreign Military Training and Assistance dataset
# Create sqlite database

set -euo pipefail

i="final_fmtrpt_all_20220325.tsv"

sqlite-utils insert src/state-department-data.db "training-data" input/"$i" \
	--tsv \
	--pk="training:id:admin" \
	--replace

sqlite-utils transform src/state-department-data.db "training-data" \
	--type "training:total_cost" integer \
	--type "training:quantity" integer

sqlite-utils create-index src/state-department-data.db "training-data" \
	"training:id:admin" \
	"training:source" \
	"qa:training_group" \
	"training:country" \
	"training:country_iso_3166_1" \
	"training:program" \
	"training:course_title" \
	"training:delivery_unit" \
	"training:recipient_unit" \
	"qa:training_start_date" \
	"training:start_date" \
	"qa:training_end_date" \
	"training:end_date" \
	"training:location" \
	"training:quantity" \
	"training:total_cost" \
	"qa:training_source_url" \
	"training:status:admin" \
	"qa:training_date_first_seen" \
	"qa:training_date_scraped" \

sqlite-utils enable-fts src/state-department-data.db "training-data" \
	"training:id:admin" \
	"training:source" \
	"qa:training_group" \
	"training:country" \
	"training:country_iso_3166_1" \
	"training:program" \
	"training:course_title" \
	"training:delivery_unit" \
	"training:recipient_unit" \
	"qa:training_start_date" \
	"training:start_date" \
	"qa:training_end_date" \
	"training:end_date" \
	"training:location" \
	"training:quantity" \
	"training:total_cost" \
	"qa:training_source_url" \
	"training:status:admin" \
	"qa:training_date_first_seen" \
	"qa:training_date_scraped" \
