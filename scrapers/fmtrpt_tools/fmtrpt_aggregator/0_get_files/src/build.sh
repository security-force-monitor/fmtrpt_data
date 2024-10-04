#!/bin/bash
#
# Grab final FMT data files from each scraper project
#
# tl@sfm 2024-10-04

rd="/Users/sfm1/Documents/work/sfm/org/fmtrpt_data/scrapers"

# Script safety

set -euo pipefail

# Get them files

_main () {

while read -r p; do

	cp "$rd/${p}" output/

done < src/filelist


}

_main
