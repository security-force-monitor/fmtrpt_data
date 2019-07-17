#!/bin/bash
#
# Get HTML for 2006-2007 FMTRPT
#
# Helper script to the 2006-2007 report
# Run in the directory you want the files to be dumped

curl -f -s -o "Africa_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92084.htm"
curl -f -s -o "East_Asia_and_Pacific_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92085.htm"
curl -f -s -o "Europe_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92086.htm"
curl -f -s -o "Near_East_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92087.htm"
curl -f -s -o "South_Central_Asia_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92088.htm"
curl -f -s -o "Western_Hemisphere_2006_2007.html" --url "https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92089.htm"
