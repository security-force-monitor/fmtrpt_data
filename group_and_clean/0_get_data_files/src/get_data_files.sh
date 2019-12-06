#!/bin/bash
#
# Find FMTRPT scraper output data files and pull them into once place
#
# tl  	2019-07-17 original
#	2019-12-06 updated

# Script safety and debug
set -eu
shopt -s failglob

# Navigate to project root directory
# Set your own root directory, or it could get messy

i="/Users/sfm0/Documents/work/sfm/org/research/fmtrpt/processing"

# Find all the final output files for each of the FMTRPT years
# Copy them to the output folder
# Remove the echo statement to run this for real

find ${i}/scrapers/fmtrpt*/output/5_xml_tsv -name "*.tsv" -exec echo cp {} ${i}/group_and_clean/0_get_data_files/output \;

# Also bring in 2006-2007 data
# This was a HTML parse
# So the output folder structure was different than the other scrapes
# Remove the echo statement to run this for real

find ${i}/scrapers/fmtrpt_2006_2007/output -name "*.tsv" -exec echo cp {} ${i}/group_and_clean/0_get_data_files/output \;
