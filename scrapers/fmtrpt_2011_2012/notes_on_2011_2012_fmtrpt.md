# Notes: 2011-2012 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2012/index.htm):

 * Africa: https://www.state.gov/documents/organization/197610.pdf
 * East Asia and Pacific: https://www.state.gov/documents/organization/197611.pdf
 * Europe: https://www.state.gov/documents/organization/197612.pdf 
 * Near East: https://www.state.gov/documents/organization/197613.pdf
 * South Central Asia: https://www.state.gov/documents/organization/197614.pdf
 * Western Hemisphere: https://www.state.gov/documents/organization/197615.pdf

Download these and plonk them in the input directory.

## Runs

We have processed the 2012-2023 FMT report PDFs twice:

 - 201903171306: original scrape.
 - 202407121057: re-scrape to extact page numbers. Around 66 rows of data from the earlier scrape were not matched automatically by hash and will need manually reconciling.

## Changes to column headings

Column `US unit` is changed to `US Unit - US Qty` in this report. A quick eyeball shows that this second value is rarely filled out, and the value "N/A" is inlcuded; in some cases the value is filled out though, so we will have to consider how to handle this.
