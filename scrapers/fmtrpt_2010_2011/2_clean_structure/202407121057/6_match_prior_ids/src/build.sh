#/bin/bash
#
# FMTRPT data: Match re-scraped data with existing data
#
# tl@sfm	2024-06-28
#
# SFM has released earlier versions of this training data, with UUIDs for each row.
# We need to honour these UUIDs both for SFM internal use and for uses that third 
# parties may have made of them. 
#
# Method:
# - md5 hash a combination a core fields that exist in earlier and new data
# - use sqlite (controlled with sqlite-utils) to create a merged output where the later dataset (which may have new attribute)
#   gains the UUID of the earlier data based on md5 match. 
# - diagnostics can show us where there is a hash collision within either dataset
# - an inner join on the old and new data will do the job
# - test the output for non-matches

# old = Input file with last good data with UUIDs
# new = Input file with re-scraped data, shaped to match old data

old="final_fmtrpt_2010_2011_201903171306.tsv"
new="final_fmtrpt_2010_2011_202407121057.tsv"

_makeHashField () {

	# Create new field containing hash of 11 core fielsd that are common to old and new datasets
	# ditchheader, print uuid, concatenate fieldset,  remove punctuation
	# define shell command in awk, execute against each line, output
	# openssl md5 is the hash alg choice. shasum is an alternative.

	gawk 'BEGIN { FS=OFS="\t"}
		NR==1 {print $0 FS "\"qa:hash\""};
		NR>1 {a = gensub (/[_|\.|\$|\*|'\''|"|\-| |,|)|(|\|\\|\//]/,"","g", $3$4$6$7$8$9$11$13$14$15$16) ;
	       	      cmd = "echo \047" a "\047 |openssl md5 | cut -f2 -d\" \""
		        if ( (cmd | getline hash ) > 0 ) {
		    	close(cmd)
		 	print $0 FS "\""hash"\""}}' $1
}

_checkSqliteFile () {

	# Remove the old db if it's there.
	# Probably better to figure out how to use sqlite-utils to achieve the same

	if [ -s notes/trainingdata.db ]
	then
		echo " ...  Deleting old db"
		rm notes/trainingdata.db
	else
		echo " .... No db to delete."
		:
	fi

}

_insertToSQLite () {

	# Insert into same sqlite database. Column datatypes not specified.

	sqlite-utils insert "notes/trainingdata.db" old notes/hashed_"${old}" --tsv --silent
	sqlite-utils insert "notes/trainingdata.db" new notes/hashed_"${new}" --tsv --silent

}

# Main merge query

_queryJoinOnHash () {

	# Bring training uuid from older dataset into new dataset by matching on content hash id
	# Group by training uuid handles cases where qa:hash isn't unique but uuid is
	# Sort on group,  page number, country, and start date to approximate order from PDFs
	# Cast page number as integer to avoid 1,10,11... issue
	# Outputs unquoted tsv

	sqlite-utils query notes/trainingdata.db \
		"SELECT
		  old.[training:id:admin] as [training:id:admin],
		  new.[training:source],
		  new.[qa:training_group],
		  new.[training:country],
		  new.[training:country_iso_3166_1],
		  new.[training:program],
		  new.[training:course_title],
		  new.[training:delivery_unit],
		  new.[training:recipient_unit],
		  new.[qa:training_start_date],
		  new.[training:start_date],
		  new.[qa:training_end_date],
		  new.[training:end_date],
		  new.[training:location],
		  new.[training:quantity],
		  new.[training:total_cost],
		  new.[training:page_number],
		  new.[qa:training_source_url],
		  new.[training:status:admin],
		  new.[qa:training_date_first_seen],
		  new.[qa:training_date_scraped]
	 	FROM
	 	  old
  	 	JOIN
	       	  new ON old.[qa:hash] = new.[qa:hash]
	 	GROUP BY
	       	  old.[training:id:admin]
		ORDER BY
		  new.[qa:training_group],
		  CAST (new.[training:page_number] as integer),
		  new.[training:country_iso_3166_1],
		  new.[training:program],
		  new.[training:start_date] ASC
		  ;" --tsv

}

# Some helpful diagnostic queries

_diagnosticQueryHashNonMatchs () {

	# Output UUID of rows of old data which are not matched by hash on the new data
	# Uses EXCEPT clause

	sqlite-utils query notes/trainingdata.db \
		"SELECT	*
		  FROM old
		  where old.[qa:hash] IN
		  ( SELECT
		    [qa:hash] from old
		    EXCEPT SELECT
		    [qa:hash] from new )
		  ;" --tsv

}

_diagnosticQueryNoDupHash () {

	# Merge old and new datasets based on hash, but only where in the old data the has is unique
	# output as tsv

	sqlite-utils query notes/trainingdata.db \
		"SELECT old.*, new.[training:page_number]
		  FROM old
		  JOIN new
		  USING ([qa:hash])
		  WHERE old.[qa:hash] IN
		   (SELECT old.[qa:hash]
		    FROM old
		    GROUP BY old.[qa:hash]
		    HAVING count(*) = 1);" --tsv

}

_diagnosticQueryOldDups () {

	# Output rows from old dataset where hash isn't unique

	sqlite-utils query notes/trainingdata.db \
		"SELECT old.*
		  FROM old
		  WHERE old.[qa:hash] IN
		   (SELECT old.[qa:hash]
		    FROM old
		    GROUP BY old.[qa:hash]
		    HAVING count(*) > 1);" --tsv

}

_diagnosticQueryNewDups () {

	# Output rows from old dataset where hash isn't unique

	sqlite-utils query notes/trainingdata.db \
		"SELECT new.*
		  FROM new
		  WHERE new.[qa:hash] IN
		   (SELECT new.[qa:hash]
		    FROM new
		    GROUP BY new.[qa:hash]
		    HAVING count(*) > 1);" --tsv

}

_reportNonJoins () {

	echo "How'd we do?"

	if [ -e notes/diagnostic_missing_from_merge ]
	 then
		a=$(xsv count -d "\t" notes/diagnostic_missing_from_merge)
		if [ -n "${a}" ]
		then
		 echo " ... ${a} rows of old could not be matched using a hash."
		else
		 echo " ...Either all rows were matched or the diagnostic hasn't worked."
		fi
	 else
	  echo " ... Error: there is no diagnostic file."
	 fi

}

# Main controls

_main () {

	# Check notes folders
	mkdir -p notes

	# Create hash field in old and new datasets
	# Only need to run this first time

	_makeHashField input/"${new}" > notes/hashed_"${new}"
	_makeHashField input/"${old}" > notes/hashed_"${old}"

	# Delete old DB and Insert into sqlite

	_checkSqliteFile
	_insertToSQLite

	# Diagnostics

	_diagnosticQueryNoDupHash > notes/diagnostic_nodupash.tsv
	_diagnosticQueryOldDups > notes/diagnostic_oldups.tsv
	_diagnosticQueryNewDups > notes/diagnostic_newdups.tsv
	_diagnosticQueryHashNonMatchs > notes/diagnostic_missing_from_merge

	# Create merged output of nondups and output of just dups

	_queryJoinOnHash > output/merged_${new}

	# Quick check on matches

	_reportNonJoins
	cp notes/diagnostic_missing_from_merge output/"not_merged_${old}"

	# Useful quick post-processing checks:
	# - test overall row count
	# - compare UUIDs from "old" with merged output
	# - any discrepancies may unfortunately go back to the XML extraction step :(

}

_main

