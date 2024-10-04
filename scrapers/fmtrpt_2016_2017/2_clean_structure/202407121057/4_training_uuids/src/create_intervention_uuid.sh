#!/bin/bash
#
# Mint UUID for training intervention entity and prepare new dataset for matching with old UUIDs
# 
# tl@sfm	2024-06-19 updated to add newly scraped page_number field
# 			   and blank training ID field for datasets that will
# 			   be later merged with earlier versions of themselves
# 	 	2024-10-   Update to create versions with and without ID numbers
# 	 		   Added a few safety checks and reporting so we don't 
# 	 		   overwrite files with minted IDs by accident

set -euo pipefail

data="final_fmtrpt_2016_2017_202407121057.tsv"
tmpfile="tmp.tsv" 
blankidcol="blankidcol.tsv"
withids="withids.tsv"
timenow=$(date +"%Y%m%d%H%M%S")

_progMsgTitle () {

	printf "\n%s %s %s\n\n" "## " "$1"  " ##"
}

_progMsgReport () {

	printf "%s %s\n" "  - " "$1" 
}

_progMsgWarn () {
	
	printf "%s %s\n" " !! " "$1"
}

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

_testForProcFiles () {

	if [ -s notes/"$withids" ]; then
		_progMsgWarn "WARNING: You have already made a version with IDs. Going to back it up in case you did not mean to run this script."
		mv notes/"$withids" notes/"${timenow}_${withids}"
		_progMsgWarn "... moved notes/$withids to notes/${timenow}_${withids}"
	else
		_progMsgReport "No existing working file with IDs - Promising news!"
		:
	fi

	if [ -s output/"$data" ]; then
		_progMsgWarn "WARNING: There is an existing output file with minted IDs. Going to stop you right there!"
		_progMsgWarn "... output/$data may already have IDs, and you really don't want to overwrite them!"
		_progMsgWarn "... exiting!"
		exit
	else
		_progMsgReport "No existing output file with IDs - Promising news!"
		:
	fi

}

_cleanUp () {

	if [ -s notes/"$blankidcol" ]; then
		_progMsgReport "Deleting that blank ID col working version. You don't need it anymore."
		rm notes/"$blankidcol"
	else
		:
	fi

}

_main () {

	_progMsgTitle "Minting new training UUIDs for the data in this FMT report"
	# If needed, mind new IDs for each row
	# If there's either an exising notes/withids.tsv or an output file with ids the script bails
	_progMsgReport "Checking for working or final outfiles that already have ID numbers ..."
	_testForProcFiles
	_progMsgReport "Getting on with minting some new ID numbers!"
        _mintTrainingUUID input/"$data" > notes/"$withids"
	# Just create a new blank column we can use in later steps
	_progMsgReport "Creating a version with a blank column for ID numbers!"
	_makeEmptyIDCol input/"$data" > notes/"$blankidcol"
	# Swap $blankidcol for $withids if working with minted id version
	_progMsgReport "Making outputs ..." 
	_renameHeaders notes/"$withids" > output/"$data"
	_renameHeaders notes/"$blankidcol" > output/no_uuids_"$data"
	_progMsgReport "Cleaning up ..."
	_cleanUp
	_progMsgReport "All done!"
}

_main
