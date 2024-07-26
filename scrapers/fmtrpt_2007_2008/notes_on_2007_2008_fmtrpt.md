# Notes: 2007-2008 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2008/index.htm):

 * Africa: http://www.state.gov/documents/organization/126573.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/126574.pdf
 * Europe: http://www.state.gov/documents/organization/126575.pdf
 * Near East: http://www.state.gov/documents/organization/126576.pdf
 * South Central Asia: http://www.state.gov/documents/organization/126577.pdf
 * Western Hemispheric Region: http://www.state.gov/documents/organization/126578.pdf

Download these and plonk them in the input directory.

This report is not available in a single PDF.

## Runs

We have processed the 2007-2008 report twices:

- 201903171306: Original scrape.
- 202407121057: Rescrape to get page numbers. Complete match by hash. Four new rows were extracted, adding data on Countries that had no reported activities. These need manually appending to the output, along with fresh IDs.

## Notes

List of problems in 2007-2008 PDFs

- Western Hemisphere changed to Western Hemispheric Region in the source PDFs. Keeping it to the shorter version for consistency.
- column left values are changed, so script needs updating.
- the column  called "Students" is equivalent to "Qty" in later reports so I've labelled it as such.
- fontsize values are changed; script updated. A major change is not filtering out rows where fontsize is `0`, as some program is `0` in these pdfs.
- There is a column for `US unit` but it is empty in all pdfs. No point parsing - will include a message to the extent that it is not recorded.
- this report contains countries for which there is no expenditure, and hence no trainings. However, their existence in the PDF presents some challenges. First, it means we have to close the country tag manually, whihc is easy; second, it will not be included in the out-reporting, which goes deep into the XML tree to find the training, and the works bakcwards to fill in the program and the country. So, no training, no record in the output. In the original scrape, I did not fix this but in the 2024 scrape I did!
- when rescraping remember to check the various exclusion patterns that are used at the top of `_cleanXML`. If any are wiping out rows using criteria (e.g. font="0") that you rely on to assign a tag, then they won't be there and it'll look mysterious (and you'll feel stupid too!).
- the rescrape data from 2024 has four new rows covering countries that are listed but don't have a training acvitity reported. As these are new they don't have IDs on which to join, so can't be matched. They must be added in manually.
