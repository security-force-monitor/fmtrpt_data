#!/bin/bash
#
# Find specific year of FMTRPT scraper output data files and pull them into onc place for analysis
#
# tl  	2019-07-17 original
#	2019-12-06 updated
#	2021-08-06 updated
#	2022-03-25 updated
#	2024-06-27 updated to reflect new file structures

# Script safety and debug

set -eu
shopt -s failglob

# Navigate to project root directory
# Set your own root directory, or it could get messy

i="/Users/sfm1/Documents/work/sfm/org/fmtrpt_data"

# Set which year we're working on

y="fmtrpt_2008_2009"

# Set which scraper run we're working on for that year

r="202407121057"

# Find all the final output files for each of the FMTRPT years, for any particular scraper run
# Copy them to the output folder
# Remove the echo statement to run this for real

# find "${i}"/scrapers/"${y}"/1_scrape_extract/output/"${r}"/5_xml_tsv -name "*.tsv" -exec echo cp {} ${i}/scrapers/"${y}"/2_clean_structure/"${r}"/0_get_data_files/output \;

find "${i}"/scrapers/"${y}"/1_scrape_extract/output/"${r}"/5_xml_tsv -name "*.tsv" -exec cp {} ${i}/scrapers/"${y}"/2_clean_structure/"${r}"/0_get_data_files/output \;

# Note: if the 2006-2007 data ever needs working on again ...
# This was a HTML parse
# So the output folder structure was different than the other scrapes
# Remove the echo statement to run this for real
# find ${i}/scrapers/fmtrpt_2006_2007/output -name "*.tsv" -exec echo cp {} ${i}/group_and_clean/0_get_data_files/output \;

