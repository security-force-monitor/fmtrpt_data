#/bin/bash
#
# FMTRPT data: Add citations down to the report and page level
#
# Each row of data comes from a specific page range from within a specific section of a specific FMTRPT.
# These are enumerated in input/fmtrpt_citation_permutations. This script loads citation and full FMTRPT data
# and joins them to create a single output.
#
# tl@sfm	2024-10-
#

# Define inputs

fmtrpt="final_fmtrpt_all_202410041854.tsv"
citations="fmtrpt_citation_permutations.tsv"


_checkSqliteFile () {

	# Remove the old db if it's there, just to be sure we're using the right data.
	# Probably better to figure out how to use sqlite-utils to achieve the same.

	if [ -s notes/fmtrpt_all.db ] 
	then
		echo " ...  Deleting old db"
		rm notes/fmtrpt_all.db
	else
		echo " .... No db to delete."
		:
	fi

}

_insertToSQLite () {

	# Insert into same sqlite database. Column datatypes not specified.

	sqlite-utils insert "notes/fmtrpt_all.db" fmtrpt input/"${fmtrpt}" --tsv --silent	
	sqlite-utils insert "notes/fmtrpt_all.db" citations  input/"${citations}" --tsv --silent

}

# Main join and merge query

_queryAddCitations () {

	# Query that obtains unique claim ID for citation at report, section, page level
	# Fieldname in "citations":
	# 1   training:source
	# 2   qa:training_group
	# 3   qa:fiscal_year
	# 4   qa:region
	# 5   training:page_number
	# 6   qa:training_source_url
	# 7   qa:source_name_to_section_level
	# 8   training:page_level_citation_id
	
	# Fieldnames in "fmtrpt":
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
	# 19  qa:training_date_first_seen
	# 20  qa:training_date_scraped
	# 21  training:status:admin

	sqlite-utils query notes/fmtrpt_all.db \
		"SELECT
		  fmtrpt.[training:id:admin],
		  fmtrpt.[training:source],
		  fmtrpt.[qa:training_group],
		  fmtrpt.[training:country],
		  fmtrpt.[training:country_iso_3166_1],
		  fmtrpt.[training:program],
		  fmtrpt.[training:course_title],
		  fmtrpt.[training:delivery_unit],
		  fmtrpt.[training:recipient_unit],
		  fmtrpt.[qa:training_start_date],
		  fmtrpt.[training:start_date],
		  fmtrpt.[qa:training_end_date],
		  fmtrpt.[training:end_date],
		  fmtrpt.[training:location],
		  fmtrpt.[training:quantity],
		  fmtrpt.[training:total_cost],
		  fmtrpt.[training:page_number],
		  fmtrpt.[qa:training_source_url],
		  fmtrpt.[qa:training_date_first_seen],
		  fmtrpt.[qa:training_date_scraped],
		  fmtrpt.[training:status:admin],
		  citations.[qa:source_name_to_section_level] AS [training:source_section_title],
		  citations.[training:page_level_citation_id] AS [training:claim_id:admin]
	 	FROM
	 	  fmtrpt
		JOIN
		  citations on fmtrpt.[training:source] = citations.[training:source] AND
		              fmtrpt.[qa:training_group] = citations.[qa:training_group] AND
			      fmtrpt.[training:page_number] = citations.[training:page_number]
		  ;" --tsv

}

# Main controls

_main () {

	# Delete old DB and Insert into sqlite
	
	_checkSqliteFile
	_insertToSQLite

	# Create merged output of nondups and output of just dups

	_queryAddCitations > output/cits_"${fmtrpt}"

}

_main
