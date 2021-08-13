# FMTRPT aggregations and clean-up overview

tl / 2019-07-16
     2019-12-06
     2021-08-6

## What does the clean up script actually do?

Running `cleanup/big_clean/src/fmtrpt_clean_up.sh` runs a number of transformations on .tsv of data aggregated from the various scrapers in this project. At each stage, the script creates a version of the data and stores it in the `notes` folder to help with any troubleshooting; the final transform is saved to the `output` folder. 

input -> 1: adds new column for ISO_3166_1 codes
1 -> 2: clean and trim whitespace from country names
2 -> 3: match country names with ISO_3166_1 codes
3 -> 4: add in new column for source name
4 -> 5: insert source UUIDs
5 -> 6: filter out rows containing program totals
6 -> 7: extracts dates that were sucked into the `total_cost` field
7 -> 8 : splits values from 2009_2010 groups that have start and end date in same column  
8 -> 9: adds `start_date_fixed` column
9 -> 10: cleans up start dates, populates `start_date_fixed` with clean values
10 -> 11: adds `end_date_fixed` column
11 -> 12: cleans up end dates, populates `end_date_fixed` with clean values
12 -> 13: removes empty values from `end_date_fixed` and `start_date_fixed`
13 -> 14: pull out training quantity from location and put in quantity field; remove quantity value from location field
14 -> 15: removes non numerical and special characters from the values in `total_cost` 
15 -> 16: changes `source` to `source_url` and adapts the value to form a valid url for the data's source file
16 -> 17: adds a `row_status` field, and populates it with a warning to check the data against the source
17 -> 18: add in `date_first_seen` field, and populates it with publication date of source
18 -> 19: add in `date_scraped` field, showing when SFM scraped the data
19 -> final: removes a small number of rows that have no source, which are going to be errors.

There are more detailed descriptions of each step in the script itself.

# Things to remember when incorporating data from new reports

 * Create a new uuid for the new report and add it in
 * Ensure that the "data first seen" value is specified for the sources
 * Update the URL for the source
 * Update the date scraped value
