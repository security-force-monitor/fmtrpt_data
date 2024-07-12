# Notes: 2008-2009 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2009/index.htm)

 * Africa: https://www.state.gov/documents/organization/152766.pdf
 * East Asia and Pacific: https://www.state.gov/documents/organization/152767.pdf
 * Europe: http://www.state.gov/documents/organization/152768.pdf
 * Near East: http://www.state.gov/documents/organization/152770.pdf
 * South Central Asia: http://www.state.gov/documents/organization/152773.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/152774.pdf

Download these and plonk them in the input directory.

There is also a single document version of this report, available here:

http://www.state.gov/documents/organization/152778.pdf

## Runs

We have processed the 2008-2009 report twice:

 -
 -


## Notes

### Changes to column headings

The column `US unit` does not exist in this document. In the parser script, I have removed the extraction/filtering around `US unit` but retained the column in the output, which means it will keep compatible with later versions of the report data where `US unit` is specified.

The column `Training location` is just called `Location` in this report, meaning that table headers rows don't get filtered out before the xml is refined, breaking the layout.

### List of problems in 2008-2009 PDFs
- Program name is in Italic, so `sed` statement needs updating to capture program titles successfully.
