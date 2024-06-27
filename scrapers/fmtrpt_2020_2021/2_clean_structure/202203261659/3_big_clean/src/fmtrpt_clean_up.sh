#!/bin/bash
#
# Cleaners: process aggregated FMTRPT dataset using an gawkful lot of gawk
#
# tl / 	2019-07-16
#	2019-12-06 updated
#	2021-08-06 updated
#	2022-03-25 updated for 2020-2021 FY data
#
# Script safety and debugging

set -eu
shopt -s failglob

# Declare variables
# Source for input data (and derived products by filename)

i="fmtrpt_2020_2021_20220325.tsv"

## Check notes folder
mkdir -p notes

# Add a column for ISO

echo "And we're off...."
echo "Adding a column for ISO-3166-1 values"

gawk 'BEGIN { FS=OFS="\t"}; {$2 = $2 FS "\"0\"" ; print $0}' "input/${i}" \
	| gawk 'BEGIN { FS=OFS="\t"}; {if (NR==1) $3="\"iso_3166_1\"" ; print $0}' \
	> notes/"1_${i}"

# Cleanup country names 

echo "Cleaning out whitespace and other stuff from the country names"

gawk 'BEGIN { FS=OFS="\t"} ; {gsub(/[ ]+"$/,"\"",$2); gsub(/^"[ ]+/,"\"",$2); print $0}' "notes/1_${i}" \
	> "notes/2_${i}"

# Match clean names to ISO 3166-1 alpha-3 country letter codes
# Source: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
# Exceptions: For Kosovo we use  "XKX", a temprorary designation used
# by the European Union pending a final designation by ISO.
# Notes on this gawk program:
# - Straighforward substitutions. Remember to tag a "{print $0}" statement at the end.
# - I chose not to include the double quotes as part of the field separator.
# - Use this to make any ad-hoc fixes needed to country name e.g. see Fiji

echo "Adding in standardized ISO-3166-1 values"

gawk '			BEGIN { FS=OFS="\t"} \
			{if ($2=="\"\"") $3="\"NaN\""} \
			{if ($2=="\"Afghanistan\"") $3="\"AFG\""} \
			{if ($2=="\"Albania\"") $3="\"ALB\""} \
			{if ($2=="\"Algeria\"") $3="\"DZA\""} \
			{if ($2=="\"Andorra\"") $3="\"AND\""} \
			{if ($2=="\"Angola\"") $3="\"AGO\""} \
			{if ($2=="\"Antigua And Barbuda (UK)\"") $3="\"ATG\""} \
			{if ($2=="\"Antigua And Barbuda\"") $3="\"ATG\""} \
			{if ($2=="\"Antigua and Barbuda\"") $3="\"ATG\""} \
			{if ($2=="\"Argentina\"") $3="\"ARG\""} \
			{if ($2=="\"Armenia\"") $3="\"ARM\""} \
			{if ($2=="\"Australia\"") $3="\"AUS\""} \
			{if ($2=="\"Austria\"") $3="\"AUT\""} \
			{if ($2=="\"Azerbaijan\"") $3="\"AZE\""} \
			{if ($2=="\"Bahamas\"") $3="\"BHS\""} \
			{if ($2=="\"Bahrain\"") $3="\"BHR\""} \
			{if ($2=="\"Bangladesh\"") $3="\"BGD\""} \
			{if ($2=="\"Barbados\"") $3="\"BRB\""} \
			{if ($2=="\"Belarus\"") $3="\"BLR\""} \
			{if ($2=="\"Belize (UK)\"") $3="\"BLZ\""} \
			{if ($2=="\"Belize\"") $3="\"BLZ\""} \
			{if ($2=="\"Benin\"") $3="\"BEN\""} \
			{if ($2=="\"Bhutan\"") $3="\"BTN\""} \
			{if ($2=="\"Bolivia INC\"") $3="\"BOL\""} \
			{if ($2=="\"Bolivia\"") $3="\"BOL\""} \
			{if ($2=="\"Bosnia & Herzegovina\"") $3="\"BIH\""} \
			{if ($2=="\"Botswana\"") $3="\"BWA\""} \
			{if ($2=="\"Brazil\"") $3="\"BRA\""} \
			{if ($2=="\"Brunei\"") $3="\"BRN\""} \
			{if ($2=="\"Bulgaria\"") $3="\"BGR\""} \
			{if ($2=="\"Burkina Faso\"") $3="\"BFA\""} \
			{if ($2=="\"Burma\"") $3="\"MMR\""} \
			{if ($2=="\"Burundi\"") $3="\"BDI\""} \
			{if ($2=="\"COLOR VISION\"") $3="\"NaN\""} \
			{if ($2=="\"Cambodia\"") $3="\"KHM\""} \
			{if ($2=="\"Cameroon\"") $3="\"CMR\""} \
			{if ($2=="\"Cape Verde (Republic of)\"") $3="\"CPV\""} \
			{if ($2=="\"Cape Verde, Republic Of\"") $3="\"CPV\""} \
			{if ($2=="\"Cape Verde, Republic of\"") $3="\"CPV\""} \
			{if ($2=="\"Cayman Islands (UK)\"") $3="\"CYM\""} \
			{if ($2=="\"Cayman Islands\"") $3="\"CYM\""} \
			{if ($2=="\"Central African Republic\"") $3="\"RCA\""} \
			{if ($2=="\"Chad\"") $3="\"TCD\""} \
			{if ($2=="\"Chile\"") $3="\"RCH\""} \
			{if ($2=="\"China (Peoples Republic of)\"") $3="\"CHN\""} \
			{if ($2=="\"China\"") $3="\"CHN\""} \
			{if ($2=="\"China, People'\''s Republic Of\"") $3="\"CHN\""} \
			{if ($2=="\"China, People'\''s Republic of\"") $3="\"CHN\""} \
			{if ($2=="\"Colombia\"") $3="\"COL\""} \
			{if ($2=="\"Comoros\"") $3="\"COM\""} \
			{if ($2=="\"Congo, Democratic Republic of (Kinshasa)\"") $3="\"COD\""} \
			{if ($2=="\"Congo, Republic Of (Brazzaville)\"") $3="\"COG\""} \
			{if ($2=="\"Congo, Republic of (Brazzaville)\"") $3="\"COG\""} \
			{if ($2=="\"Cook Islands\"") $3="\"COK\""} \
			{if ($2=="\"Costa Rica\"") $3="\"CRI\""} \
			{if ($2=="\"Cote D'\''Ivoire\"") $3="\"CIV\""} \
			{if ($2=="\"Cote D'\''Ivoire, Republic of\"") $3="\"CIV\""} \
			{if ($2=="\"Cote D’Ivoire, Republic of\"") $3="\"CIV\""} \
			{if ($2=="\"Cote D’ivoire, Republic Of\"") $3="\"CIV\""} \
			{if ($2=="\"Cote d'\''Ivoire\"") $3="\"CIV\""} \
			{if ($2=="\"Croatia\"") $3="\"HRV\""} \
			{if ($2=="\"Cyprus\"") $3="\"CYP\""} \
			{if ($2=="\"Côte d'\''Ivoire, Republic of\"") $3="\"CIV\""} \
			{if ($2=="\"Democratic Republic of Congo (Congo - Kinshasa)\"") $3="\"COD\""} \
			{if ($2=="\"Democratic Republic of Congo\"") $3="\"COD\""} \
			{if ($2=="\"Djibouti\"") $3="\"DJI\""} \
			{if ($2=="\"Dominica\"") $3="\"DMA\""} \
			{if ($2=="\"Dominican Republic\"") $3="\"DOM\""} \
			{if ($2=="\"East Timor\"") $3="\"TLS\""} \
			{if ($2=="\"Ecuador\"") $3="\"ECU\""} \
			{if ($2=="\"Egypt\"") $3="\"EGY\""} \
			{if ($2=="\"El Salvador\"") $3="\"SLV\""} \
			{if ($2=="\"Equatorial Guinea\"") $3="\"GNQ\""} \
			{if ($2=="\"Eritrea\"") $3="\"ERI\""} \
			{if ($2=="\"Estonia\"") $3="\"EST\""} \
			{if ($2=="\"Ethiopia\"") $3="\"ETH\""} \
			{if ($2=="\"Fiji   IMET - FY 2006 DoS Training\"") { $2 = "\"Fiji\"" ; $3="\"FJI\""}} \
			{if ($2=="\"Fiji\"") $3="\"FJI\""} \
			{if ($2=="\"Finland\"") $3="\"FIN\""} \
			{if ($2=="\"French Polynesia\"") $3="\"PYF\""} \
			{if ($2=="\"Gabon\"") $3="\"GAB\""} \
			{if ($2=="\"Gambia\"") $3="\"GMB\""} \
			{if ($2=="\"Gambia, The\"") $3="\"GMB\""} \
			{if ($2=="\"Georgia\"") $3="\"GEO\""} \
			{if ($2=="\"Ghana\"") $3="\"GHA\""} \
			{if ($2=="\"Grenada\"") $3="\"GRD\""} \
			{if ($2=="\"Guatemala\"") $3="\"GTM\""} \
			{if ($2=="\"Guinea - Bissau\"") $3="\"GNB\""} \
			{if ($2=="\"Guinea\"") $3="\"GIN\""} \
			{if ($2=="\"Guinea-Bissau\"") $3="\"GNB\""} \
			{if ($2=="\"Guyana\"") $3="\"GUY\""} \
			{if ($2=="\"Haiti\"") $3="\"HTI\""} \
			{if ($2=="\"Honduras\"") $3="\"HND\""} \
			{if ($2=="\"Hong Kong\"") $3="\"HKG\""} \
			{if ($2=="\"India\"") $3="\"IND\""} \
			{if ($2=="\"Indochina\"") $3="\"NaN\""} \
			{if ($2=="\"Indonesia\"") $3="\"IDN\""} \
			{if ($2=="\"Iran\"") $3="\"IRN\""} \
			{if ($2=="\"Iraq\"") $3="\"IRQ\""} \
			{if ($2=="\"Ireland\"") $3="\"IRL\""} \
			{if ($2=="\"Israel\"") $3="\"ISR\""} \
			{if ($2=="\"Jamaica\"") $3="\"JAM\""} \
			{if ($2=="\"Japan\"") $3="\"JPN\""} \
			{if ($2=="\"Jordan\"") $3="\"JOR\""} \
			{if ($2=="\"Kazakhstan\"") $3="\"KAZ\""} \
			{if ($2=="\"Kazakhstan, Republic Of\"") $3="\"KAZ\""} \
			{if ($2=="\"Kenya\"") $3="\"KEN\""} \
			{if ($2=="\"Kiribati\"") $3="\"KIR\""} \
			{if ($2=="\"Korea (Republic of)\"") $3="\"KOR\""} \
			{if ($2=="\"Korea - South (Republic of)\"") $3="\"KOR\""} \
			{if ($2=="\"Korea - South\"") $3="\"KOR\""} \
			{if ($2=="\"Korea, Republic of South\"") $3="\"KOR\""} \
			{if ($2=="\"Korea, Republic of\"") $3="\"KOR\""} \
			{if ($2=="\"Kosovo\"") $3="\"XKX\""} \
			{if ($2=="\"Kuwait\"") $3="\"KWT\""} \
			{if ($2=="\"Kyrgyzstan\"") $3="\"KGZ\""} \
			{if ($2=="\"Laos\"") $3="\"LAO\""} \
			{if ($2=="\"Latvia\"") $3="\"LVA\""} \
			{if ($2=="\"Lebanon\"") $3="\"LBN\""} \
			{if ($2=="\"Lesotho\"") $3="\"LSO\""} \
			{if ($2=="\"Liberia\"") $3="\"LBR\""} \
			{if ($2=="\"Libya\"") $3="\"LBY\""} \
			{if ($2=="\"Lithuania\"") $3="\"LTU\""} \
			{if ($2=="\"Macedonia (FYROM)\"") $3="\"MKD\""} \
			{if ($2=="\"Macedonia\"") $3="\"MKD\""} \
			{if ($2=="\"Madagascar\"") $3="\"MDG\""} \
			{if ($2=="\"Malawi\"") $3="\"MWI\""} \
			{if ($2=="\"Malaysia\"") $3="\"MYS\""} \
			{if ($2=="\"Maldives\"") $3="\"MDV\""} \
			{if ($2=="\"Mali\"") $3="\"MLI\""} \
			{if ($2=="\"Malta\"") $3="\"MLT\""} \
			{if ($2=="\"Marshall Islands\"") $3="\"MHL\""} \
			{if ($2=="\"Mauritania\"") $3="\"MRT\""} \
			{if ($2=="\"Mauritius\"") $3="\"MUS\""} \
			{if ($2=="\"Mexico\"") $3="\"MEX\""} \
			{if ($2=="\"Micronesia\"") $3="\"FSM\""} \
			{if ($2=="\"Moldova\"") $3="\"MDA\""} \
			{if ($2=="\"Monaco\"") $3="\"MCO\""} \
			{if ($2=="\"Mongolia\"") $3="\"MNG\""} \
			{if ($2=="\"Montenegro, Republic of\"") $3="\"NME\""} \
			{if ($2=="\"Morocco\"") $3="\"MAR\""} \
			{if ($2=="\"Mozambique\"") $3="\"MOZ\""} \
			{if ($2=="\"Namibia\"") $3="\"NAM\""} \
			{if ($2=="\"Nauru\"") $3="\"NRU\""} \
			{if ($2=="\"Nepal\"") $3="\"NPL\""} \
			{if ($2=="\"Netherlands Antilles\"") $3="\"ANT\""} \
			{if ($2=="\"New Caledonia\"") $3="\"NCL\""} \
			{if ($2=="\"New Zealand\"") $3="\"NZL\""} \
			{if ($2=="\"Nicaragua\"") $3="\"NIC\""} \
			{if ($2=="\"Niger\"") $3="\"NER\""} \
			{if ($2=="\"Nigeria\"") $3="\"NGA\""} \
			{if ($2=="\"Niue\"") $3="\"NIU\""} \
			{if ($2=="\"Oman\"") $3="\"OMN\""} \
			{if ($2=="\"Pakistan\"") $3="\"PAK\""} \
			{if ($2=="\"Palau\"") $3="\"PLW\""} \
			{if ($2=="\"Palestinian Authority\"") $3="\"PSE\""} \
			{if ($2=="\"Panama\"") $3="\"PAN\""} \
			{if ($2=="\"Papua New Guinea\"") $3="\"PNG\""} \
			{if ($2=="\"Papua-New Guinea\"") $3="\"PNG\""} \
			{if ($2=="\"Paraguay\"") $3="\"PRY\""} \
			{if ($2=="\"Peru\"") $3="\"PER\""} \
			{if ($2=="\"Philippines\"") $3="\"PHL\""} \
			{if ($2=="\"Qatar\"") $3="\"QAT\""} \
			{if ($2=="\"Republic of Congo (Brazzaville)\"") $3="\"COG\""} \
			{if ($2=="\"Republic of Congo (Congo - Brazzaville)\"") $3="\"COG\""} \
			{if ($2=="\"Republic of Montenegro\"") $3="\"MNE\""} \
			{if ($2=="\"Republic of Serbia\"") $3="\"SRB\""} \
			{if ($2=="\"Romania\"") $3="\"ROU\""} \
			{if ($2=="\"Russia\"") $3="\"RUS\""} \
			{if ($2=="\"Rwanda\"") $3="\"RWA\""} \
			{if ($2=="\"Saint Kitts & Nevis\"") $3="\"KNA\""} \
			{if ($2=="\"Saint Lucia\"") $3="\"LCA\""} \
			{if ($2=="\"Samoa\"") $3="\"WSM\""} \
			{if ($2=="\"Sao Tome And Principe\"") $3="\"STP\""} \
			{if ($2=="\"Sao Tome and Principe\"") $3="\"STP\""} \
			{if ($2=="\"Saudi Arabia\"") $3="\"SAU\""} \
			{if ($2=="\"Senegal\"") $3="\"SEN\""} \
			{if ($2=="\"Serbia and Montenegro\"") $3="\"SCG\""} \
			{if ($2=="\"Serbia\"") $3="\"SRB\""} \
			{if ($2=="\"Serbia, Republic of\"") $3="\"SRB\""} \
			{if ($2=="\"Seychelles\"") $3="\"SYC\""} \
			{if ($2=="\"Sierra Leone\"") $3="\"SLE\""} \
			{if ($2=="\"Singapore\"") $3="\"SGP\""} \
			{if ($2=="\"Slovakia\"") $3="\"SVK\""} \
			{if ($2=="\"Slovenia\"") $3="\"SVN\""} \
			{if ($2=="\"Solomon Islands\"") $3="\"SLB\""} \
			{if ($2=="\"Somalia\"") $3="\"SOM\""} \
			{if ($2=="\"South Africa\"") $3="\"ZAF\""} \
			{if ($2=="\"Sri Lanka\"") $3="\"LKA\""} \
			{if ($2=="\"St Kitts & Nevis\"") $3="\"KNA\""} \
			{if ($2=="\"St Kitts And Nevis\"") $3="\"KNA\""} \
			{if ($2=="\"St Lucia\"") $3="\"LCA\""} \
			{if ($2=="\"St Vincent And Grenadines\"") $3="\"VCT\""} \
			{if ($2=="\"St Vincent and Grenadines\"") $3="\"VCT\""} \
			{if ($2=="\"Sudan\"") $3="\"SDN\""} \
			{if ($2=="\"Sudan, Government of Southern\"") $3="\"SSD\""} \
			{if ($2=="\"Sudan, Republic of South\"") $3="\"SSD\""} \
			{if ($2=="\"Sudan, Republic of Southern\"") $3="\"SSD\""} \
			{if ($2=="\"Suriname\"") $3="\"SUR\""} \
			{if ($2=="\"Swaziland\"") $3="\"SWZ\""} \
			{if ($2=="\"Sweden\"") $3="\"SWE\""} \
			{if ($2=="\"Switzerland\"") $3="\"CHE\""} \
			{if ($2=="\"Syria\"") $3="\"SYR\""} \
			{if ($2=="\"Taiwan\"") $3="\"TWN\""} \
			{if ($2=="\"Tajikistan\"") $3="\"TJK\""} \
			{if ($2=="\"Tanzania\"") $3="\"TZA\""} \
			{if ($2=="\"Tanzania, United Republic of\"") $3="\"TZA\""} \
			{if ($2=="\"Thailand\"") $3="\"THA\""} \
			{if ($2=="\"Timor-Leste\"") $3="\"TLS\""} \
			{if ($2=="\"Timor-Leste, Democratic Republic of\"") $3="\"TLS\""} \
			{if ($2=="\"Togo\"") $3="\"TGO\""} \
			{if ($2=="\"Tokelau\"") $3="\"TKL\""} \
			{if ($2=="\"Tonga\"") $3="\"TON\""} \
			{if ($2=="\"Trinidad - Tobago\"") $3="\"TTO\""} \
			{if ($2=="\"Trinidad -Tobago\"") $3="\"TTO\""} \
			{if ($2=="\"Trinidad and Tobago\"") $3="\"TTO\""} \
			{if ($2=="\"Tunisia\"") $3="\"TUN\""} \
			{if ($2=="\"Turkmenistan\"") $3="\"TKM\""} \
			{if ($2=="\"Turks and Caicos\"") $3="\"TCA\""} \
			{if ($2=="\"Tuvalu\"") $3="\"TUV\""} \
			{if ($2=="\"Uganda\"") $3="\"UGA\""} \
			{if ($2=="\"Ukraine\"") $3="\"UKR\""} \
			{if ($2=="\"United Arab Emirates\"") $3="\"ARE\""} \
			{if ($2=="\"Uruguay\"") $3="\"URY\""} \
			{if ($2=="\"Uzbekistan\"") $3="\"UZB\""} \
			{if ($2=="\"Vanuatu\"") $3="\"VUT\""} \
			{if ($2=="\"Venezuela\"") $3="\"VEN\""} \
			{if ($2=="\"Vietnam\"") $3="\"VNM\""} \
			{if ($2=="\"Yemen\"") $3="\"YEM\""} \
			{if ($2=="\"Yugoslavia\"") $3="\"YUG\""} \
			{if ($2=="\"Zambia\"") $3="\"ZMB\""} \
			{if ($2=="\"Zimbabwe\"") $3="\"ZWE\""} \
			{print $0}' \
			"notes/2_${i}" \
		> "notes/3_${i}"

# Add a column for sources and bring in source UUID numbers

echo "Adding a column for the source ID numbers"

gawk 'BEGIN { FS=OFS="\t"}; {$1 = "\"0\"" FS $1; print $0}' "notes/3_${i}" \
	| gawk 'BEGIN { FS=OFS="\t"}; {if (NR==1) $1="\"source_uuid\"" ; print $0}' \
	> "notes/4_${i}"

# The source UUID is SFM's citation management device; we'll also use it later to add in some other data
# Remember to update this each time the script is run

echo "Bringing in source ID numbers"

gawk '			BEGIN { FS=OFS="\t" } \
			{ if ($2 ~ /^"2000_/) $1="\"7713f87d-605c-4563-acc2-0072d7dcc957\""} \
			{ if ($2 ~ /^"2001_/) $1="\"03221d24-92ea-4ccc-a6a2-bd88dbfcd9fb\""} \
			{ if ($2 ~ /^"2002_/) $1="\"048fb2d9-6651-4ba0-b36a-a526539f4cfd\""} \
			{ if ($2 ~ /^"2003_/) $1="\"04ac6784-aa03-4c20-978e-960d2d59ca02\""} \
			{ if ($2 ~ /^"2004_/) $1="\"055ffb82-b20c-412e-a126-5addf71aa3b0\""} \
			{ if ($2 ~ /^"2005_/) $1="\"15615dc2-0798-4dd7-84fe-b12d603b4601\""} \
			{ if ($2 ~ /^"2006_/) $1="\"1fcf235c-b155-4dde-bf01-3f209af7227f\""} \
			{ if ($2 ~ /^"2007_/) $1="\"258be1a1-a9e5-4d7f-b8b0-0500a2714580\""} \
			{ if ($2 ~ /^"2008_/) $1="\"333125f2-0bae-4feb-bdde-8c6fd26d0ccb\""} \
			{ if ($2 ~ /^"2009_/) $1="\"3ae10e65-b946-4e3d-86d5-5dfbce339ebd\""} \
			{ if ($2 ~ /^"2010_/) $1="\"4189374e-437e-49a6-a769-023b2b22de02\""} \
			{ if ($2 ~ /^"2011_/) $1="\"4bb42ad2-5ae2-4d21-b512-23eef531daaa\""} \
			{ if ($2 ~ /^"2012_/) $1="\"4faaea83-ee29-409a-8859-20f1be2b6c95\""} \
			{ if ($2 ~ /^"2013_/) $1="\"5c5f3950-1925-417b-b333-fed3650d87ea\""} \
			{ if ($2 ~ /^"2014_/) $1="\"79e14f58-ea87-47c9-ad07-49d8742d8b3d\""} \
			{ if ($2 ~ /^"2015_/) $1="\"7afbcfe9-7e9d-4a45-8c24-c9246a4b250e\""} \
			{ if ($2 ~ /^"2016_/) $1="\"841f634e-6db0-4c1c-a2e3-4d6ff76505d4\""} \
			{ if ($2 ~ /^"2017_/) $1="\"8602229d-5b77-42e5-b1bc-83fad2eda1b9\""} \
			{ if ($2 ~ /^"2018_/) $1="\"8d439057-bc2d-4141-8ff3-48d6842150eb\""} \
			{ if ($2 ~ /^"2019_/) $1="\"730b2c0f-4eb6-4dbb-af57-2be9eb32031a\""} \
			{ if ($2 ~ /^"2020_/) $1="\"491fdf73-cf75-42bf-93e8-9aad65ed8762\""} \
			{ print $0 }' \
			"notes/4_${i}" \
		> "notes/5_${i}"

# Filter out rows containing program summary data

echo "Filtering out rows that contain program summary data"

gawk -F'\t' '$6 !~ /Program Totals/' \
	"notes/5_${i}" \
	> "notes/6_${i}"


# Deal with dates that have got sucked into the costings field
# - Splits totals field into array, checks for presence of backslashes (ie. dates)
# - moves various bits of the array into start_date,end_date or total_costs as required
# - problem affects about 1680 rows

echo "Dealing with dates that got sucked into the costings fields"

gawk '	BEGIN 	{ FS=OFS="\t" 	} ;							\
		{ if ($13 ~ /\//) {  gsub(/ "$/,"\"",$13) ; 				\
		  		     gsub(/"/,"",$13) ;					\
		  		     n=split($13,t," ") ;				\
				     if ( $9 ~ /""/ && t[1] ~ /\// )			\
						$9=t[1] ;				\
				     if ( $9 ~ /""/ && $10 ~ /""/ && n == 1)	\
						$9=t[1]  ;				\
				     if ( $9 !~ /""/ && t[1] ~ /\// ) 		\
		       		     		$9=t[1]  ; 				\
				     else if ( $9 ~ /""/ && n == 2 )			\
						$9=t[2]  ;				\
				     else if ( $10 ~ /""/ && n == 2 )			\
						$10=t[2]  ; 				\
				     else if ( $9 ~ /""/ && $10 ~ /""/ && n == 3)	\
						{ $9=t[2] ; $10=t[3] }  ; 		\
				     if ( t[1] !~ /\// )				\
						 $13=t[1] ;				\
				     else if ( t[1] ~ /\// )				\
						 $13="\"\"" ;				\
				     }; print						\
		}' \
		"notes/6_${i}" \
		> notes/7_${i}

# Deal with 2009-2010 data dates, which are in the same column

echo "Dealing with errors in the 2009-2010 dates, which are in the same column"

gawk 'BEGIN	{ FS=OFS="\t"};						\
		{	gsub(/"/,"",$9) ;				\
			split($9,date," ") ;				\
			s=date[1] ;					\
			e=date[2] ;					\
			if ( $2 ~ /2009_2010/ && $9 ~ / / ) {$9=s ; $10=e} ; 	\
			print 						\
		}' \
		"notes/7_${i}"  \
		 > notes/8_${i}

# Parse start dates to standard formats
# Create column for start_date_fixed
# todo: figure out why we need a separate gawk process to rename column 10

echo "Creating a column to store standardized value for start date"

gawk 'BEGIN { FS=OFS="\t"} ; {$9 = $9 FS "\"\"" } ; { print}' "notes/8_${i}" \
	| gawk 'BEGIN{ FS=OFS="\t"} ; { if (NR==1) $10="\"start_date_fixed\""}; {print $0}' \
        > notes/"9_${i}"
 
# Deal with start dates

echo "Standardizing start dates"

gawk 'BEGIN 	{ FS=OFS="\t"}; 						\
		{ 	gsub(/"/,"",$9) ;					\
			split($9,date,"/") ;					\
				y=date[3] ;					\
				d=date[2] ;					\
				m=date[1] ;					\
				gsub(/^0/,"200",y) ; 				\
				g=sprintf("%04d-%02d-%02d",y,m,d) ;		\
				$10="\""g"\"";					\
				if (NR==1) $10="\"start_date_fixed\"";		\
				print \
		}' \
		"notes/9_${i}" \
		> notes/10_${i}

# Parse end dates to standard formats

# Create column for end_date_fixed

echo "Creating a column to store standardized value for end date"

gawk 'BEGIN { FS=OFS="\t"} ; {$11 = $11 FS "\"\"" } ; { print}' "notes/10_${i}" \
	| gawk 'BEGIN{ FS=OFS="\t"} ; { if (NR==1) $12="\"end_date_fixed\""}; {print $0}' \
        > notes/"11_${i}"

# Deal with end dates

echo "Standardizing end dates"

gawk 'BEGIN 	{ FS=OFS="\t"}; 						\
		{ 	gsub(/"/,"",$11) ;					\
			split($11,date,"/") ;					\
				y=date[3] ;					\
				d=date[2] ;					\
				m=date[1] ;					\
				gsub(/^0/,"200",y) ; 				\
				g=sprintf("%04d-%02d-%02d",y,m,d) ;		\
				$12="\""g"\"";					\
				if (NR==1) $12="\"end_date_fixed\"";		\
				print \
		}' \
		"notes/11_${i}" \
		> notes/12_${i}

# Remove empty dates values

echo "Removing empty end date values from the data"

gawk 'BEGIN	{ FS=OFS="\t"};							\
		{ if ($10 ~ /0000-00-00/ || $12 ~ /0000-00-00/ ) {gsub(/0000-00-00/,"",$10) ; gsub(/0000-00-00/,"",$12) } ;\
		print \
		}' \
		"notes/12_${i}" \
		> notes/13_${i}

# In 2001/2002 data, training quantity couldn't be extracted directy from location
# The training quantity is always a number at the beginning of the location
# This gawk script:
# - filters for 2001/2001 data
# - splits the location field using space as a sep
# - assigns the first split array value to the training quantity column
# - tidies up quoting in the quantity column for all rows
# - removes the numerical value from the start of the quotation field 
# - removes any location fields that are just numbers

echo "Splitting out training quantities from location fields in 2001-2002 data"

gawk 'BEGIN 	{ FS=OFS="\t" };								\
		{ if ( $2 ~ /2001_2002_/ ) 							\
			{	split($13,loc," ") ;						\
				q=loc[1] ;							\
				$14=q ;								\
				gsub(/"/,"",$14) ;						\
				gsub(/^/,"\"",$14) ;						\
				sub(/$/,"\"",$14) ;						\
				sub(/^"[0-9]{1,4} /,"\"",$13);					\
				sub(/^"[0-9]{1,4}"$/,"\"\"",$13) }				\
		print }' \
		"notes/13_${i}"  \
		> notes/14_${i}


# gawk to remove relevant non-numberical characters and whitespace

echo "Clearing out some non-numerical characters and whitepsace from costings field"

gawk ' 	BEGIN 	{ FS=OFS="\t" } ; 			\
		 NR==1 ; NR > 1 			\
		{ 	gsub(/\$/,"",$15);		\
			gsub(/ /,"",$15) ;		\
			gsub(/,/,"",$15) ;		\
			gsub(/[aA-zA]/,"",$15) 	;	\
		print }' \
		"notes/14_${i}" \
		> notes/15_${i} 

# The original source column has the filename from which the data were extracted
# These are easily turned into full URLs, so we will do that
# For 2020-2021, the file names did not contain the year, so instead
# we use source_id as the condition

echo "Adding in source file url for each row, and rename the column to reflect this"

gawk 	'BEGIN { FS=OFS="\t" }	;											\
	 { gsub(/"/,"",$16) } ;												\
	 { if (NR > 1 && $16 ~ /\.htm/) $16 = "https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/" $16  ; 	\
	   else if (NR > 1 && $16 == "") $16 = "Error: no source provided" ;							\
	   else if (NR > 1 && $16 ~ /FMT_Volume-I_FY2018_2019/ ) $16 = "https://www.state.gov/wp-content/uploads/2019/12/FMT_Volume-I_FY2018_2019.pdf" ; \
	   else if (NR > 1 && $16 ~ /FMT_Volume-I_FY2019_2020/ ) $16 = "https://www.state.gov/wp-content/uploads/2021/08/Volume-I-508-Compliant.pdf" ; \
	   else if (NR > 1 && $1 ~ /491fdf73-cf75-42bf-93e8-9aad65ed8762/ ) $16 = "https://www.state.gov/wp-content/uploads/2022/03/" $16 ".pdf" ; \
	   else if (NR > 1 ) $16 = "https://2009-2017.state.gov/documents/organization/" $16 ".pdf" ;		\
	   if (NR == 1 ) $16 = "source_url" ; 										\
	   gsub(/^/,"\"",$16) ; gsub(/$/,"\"",$16) } ;									\
	   { print } '		\
	"notes/15_${i}" 	\
	> notes/16_${i}

# https://www.state.gov/wp-content/uploads/2022/03/10-Volume-I-Section-IV-Part-IV-I-Africa.pdf

## Add in a column and note to make it clear that the data has not been manually checked against source

echo "Adding a row_status field, and a boilerplate note that the data has not been checked against source"

gawk 'BEGIN { FS=OFS="\t"}; {$16 = $16 FS "\"Not checked against source; verify accuracy before use\""; print $0}' "notes/16_${i}" \
	| gawk 'BEGIN { FS=OFS="\t"}; {if (NR==1) $17="\"row_status\"" ; print $0}' \
	> "notes/17_${i}"


## Add a column for date_first_seen and populate with publication date drawn from source metadata

echo "Adding date_first_seen column and populating with data on source publication date"

gawk 'BEGIN { FS=OFS="\t"}; { $17 = $17 FS "\"date_first_seen\""; print $0 }' "notes/17_${i}" \
	| gawk 'BEGIN { FS=OFS="\t"} ; 								\
		{if ($1 ~ /7713f87d-605c-4563-acc2-0072d7dcc957/) $18 = "\"2001-01\"" } 	\
		{if ($1 ~ /03221d24-92ea-4ccc-a6a2-bd88dbfcd9fb/) $18 = "\"2002-03\"" } 	\
		{if ($1 ~ /048fb2d9-6651-4ba0-b36a-a526539f4cfd/) $18 = "\"2003-05\"" } 	\
		{if ($1 ~ /04ac6784-aa03-4c20-978e-960d2d59ca02/) $18 = "\"2004-06\"" } 	\
		{if ($1 ~ /055ffb82-b20c-412e-a126-5addf71aa3b0/) $18 = "\"2005-04\"" } 	\
		{if ($1 ~ /15615dc2-0798-4dd7-84fe-b12d603b4601/) $18 = "\"2006-09\"" } 	\
		{if ($1 ~ /1fcf235c-b155-4dde-bf01-3f209af7227f/) $18 = "\"2007-08\"" } 	\
		{if ($1 ~ /258be1a1-a9e5-4d7f-b8b0-0500a2714580/) $18 = "\"2008-01-31\"" } 	\
		{if ($1 ~ /333125f2-0bae-4feb-bdde-8c6fd26d0ccb/) $18 = "\"2009\"" } 		\
		{if ($1 ~ /3ae10e65-b946-4e3d-86d5-5dfbce339ebd/) $18 = "\"2010\"" } 		\
		{if ($1 ~ /4189374e-437e-49a6-a769-023b2b22de02/) $18 = "\"2011\"" } 		\
		{if ($1 ~ /4bb42ad2-5ae2-4d21-b512-23eef531daaa/) $18 = "\"2012\"" } 		\
		{if ($1 ~ /4faaea83-ee29-409a-8859-20f1be2b6c95/) $18 = "\"2013\"" } 		\
		{if ($1 ~ /5c5f3950-1925-417b-b333-fed3650d87ea/) $18 = "\"2014\"" } 		\
		{if ($1 ~ /79e14f58-ea87-47c9-ad07-49d8742d8b3d/) $18 = "\"2015\"" } 		\
		{if ($1 ~ /7afbcfe9-7e9d-4a45-8c24-c9246a4b250e/) $18 = "\"2016\"" } 		\
		{if ($1 ~ /841f634e-6db0-4c1c-a2e3-4d6ff76505d4/) $18 = "\"2017-10-27\"" } 	\
		{if ($1 ~ /8602229d-5b77-42e5-b1bc-83fad2eda1b9/) $18 = "\"2018-08-15\"" } 	\
		{if ($1 ~ /8d439057-bc2d-4141-8ff3-48d6842150eb/) $18 = "\"2019-12-06\"" }	\
		{if ($1 ~ /730b2c0f-4eb6-4dbb-af57-2be9eb32031a/) $18 = "\"2021-08-04\"" }	\
		{if ($1 ~ /491fdf73-cf75-42bf-93e8-9aad65ed8762/) $18 = "\"2022-03-16\"" }	\
		{ print $0 }'\
		> notes/18_${i}

## Add a column for date_scraped, indicated when the material was obained and scraped
## This will need changing for each scrape run.

echo "Adding data_scraped column, and putting current scrape/parse date in there"

gawk 'BEGIN { FS=OFS="\t"} ;										\
		{if ($1 ~ /7713f87d-605c-4563-acc2-0072d7dcc957/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /03221d24-92ea-4ccc-a6a2-bd88dbfcd9fb/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /048fb2d9-6651-4ba0-b36a-a526539f4cfd/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /04ac6784-aa03-4c20-978e-960d2d59ca02/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /055ffb82-b20c-412e-a126-5addf71aa3b0/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /15615dc2-0798-4dd7-84fe-b12d603b4601/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /1fcf235c-b155-4dde-bf01-3f209af7227f/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /258be1a1-a9e5-4d7f-b8b0-0500a2714580/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /333125f2-0bae-4feb-bdde-8c6fd26d0ccb/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /3ae10e65-b946-4e3d-86d5-5dfbce339ebd/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /4189374e-437e-49a6-a769-023b2b22de02/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /4bb42ad2-5ae2-4d21-b512-23eef531daaa/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /4faaea83-ee29-409a-8859-20f1be2b6c95/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /5c5f3950-1925-417b-b333-fed3650d87ea/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /79e14f58-ea87-47c9-ad07-49d8742d8b3d/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /7afbcfe9-7e9d-4a45-8c24-c9246a4b250e/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /841f634e-6db0-4c1c-a2e3-4d6ff76505d4/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /8602229d-5b77-42e5-b1bc-83fad2eda1b9/) $18 = $18 FS "\"2019-07-16\"" }	\
		{if ($1 ~ /8d439057-bc2d-4141-8ff3-48d6842150eb/) $18 = $18 FS "\"2019-12-06\"" }	\
		{if ($1 ~ /730b2c0f-4eb6-4dbb-af57-2be9eb32031a/) $18 = $18 FS "\"2021-08-06\"" }	\
		{if ($1 ~ /491fdf73-cf75-42bf-93e8-9aad65ed8762/) $18 = $18 FS "\"2022-03-25\"" }	\
		{print $0}' "notes/18_${i}" \
	| gawk 'BEGIN { FS=OFS="\t"} ; {if (NR==1) $19 = "\"date_scraped\"" ; print $0}' \
	> notes/19_${i}

# Remove lines that have no source_url
# This is a proxy for rows that are generally malformatted 
# There should only be 6 of them

echo "Removing rows with no source"

grep -v "Error: no source provided" notes/19_${i} > output/final_${i}


# Close it out

echo ""
echo "That's a wrap! All done!"
