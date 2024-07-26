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

 - 201903171306: original data scrape.
 - 202407121057: rescrape to extract page numbers for each item. Thirteen of ~16000 rows from the earlier scrape wouldn't match the new one based on hash comparison, and will need manual checking.


## Notes

### Changes to column headings

The column `US unit` does not exist in this document. In the parser script, I have removed the extraction/filtering around `US unit` but retained the column in the output, which means it will keep compatible with later versions of the report data where `US unit` is specified.

The column `Training location` is just called `Location` in this report, meaning that table headers rows don't get filtered out before the xml is refined, breaking the layout.

### List of problems in 2008-2009 PDFs
- Program name is in Italic, so `sed` statement needs updating to capture program titles successfully.
- For the 202407121057 scrape, the PDF table positions from the original script worked fine, alongside the generic reshaping steps handling the numerous edge cases that this process throws up on the voyage between PDF and tsv. Note that the main extractor here is based on the revised 2009-2010 script, which had to deal with a lot of issues around page numbers that would not extract because the `<page>` tag would break up the "training" object.
