# Notes: 2003-2004 FMT report

## Sources

This report is in seven different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2004/34222.htm):

 * Africa: http://www.state.gov/documents/organization/34329.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/34330.pdf
 * Europe: http://www.state.gov/documents/organization/34331.pdf
 * Near East: http://www.state.gov/documents/organization/34334.pdf
 * Newly Independent States: http://www.state.gov/documents/organization/34336.pdf
 * South Asia: http://www.state.gov/documents/organization/34337.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/34338.pdf

Download these and plonk them in the input directory.

The report is not available in a single PDF.

## Runs

We have processed this report twice:

 - 201903171306: original scrape.
 - 202407121057: rescrape to obtain page numbers. Only two rows of old data did not match the rescraped data when compared by hash on common fields, so will need manually reconciling.

## Notes

### List of problems in 2003-2004 PDFs

- Report is in the 2005-2006 format, so we can re-use parts of the scraper from there.
- similar to 2004/05 the issue is that the first of the pdfs has a different font ordering so needs to be treated separately.
- some issues emerging from mistakes in the source document which throw errors, such as US units appears in the column for start dates. These can usually be fished out by grepping for rows that retain `<text>` tags. We should run a general check on every preceeding output to ensure we have caught these rows and figured out how to deal with them.

### Observations and issues from 2024 re-processing

 - will make use of the adapted 2004-2005 scripts, which are better at handling page numbers and wierd stuff.
 - the item positionings have completely changed in the `pdftohtml` output for the 2024 scrape, so we have to recalculate them :(
 - in these "template C" PDFs the column titles do no line up with the data for those columns, so can't take the `left` and `font` values from the titles. Instead, the better approach is to work through the first few complete items in the XML to get the first left/font values, and then search the XML for those values, and then for actual attribute values that are typical for that field. For example, search for common training locations like "LACKLAND" and "BENNING" to see rows for training location. Similarly a regex on `\/..\/` will give you date values, which are only used in rows that should be assigned to `start_date` and `end_date`. I should probably write a better XML profiling tool.
- for the Near East PDF, cut off the PDF extraction at page 66 (and hence the _real_ page number at IV-184). There's nothing that we keep on that final page, and it breaks the XML. 
- for the "other sections" run, the item position values work fine.
- Check the `page_number` column of the TSV files for three things: 
 - Missing ranges of numbers: this means that the number generation alg is having a hard time finding the `<page>` tag. 
 - Blanks: similarly, this likely means something has gone wrong with the alg.
 - duplicated numbers (e.g. "30 30"), which means that a page number has appeared twice within a `<training>` tag, so you'll need to remove one of them.
- Run specific check on the number of missing dates in both start and end dates. Missing dates are usuallly a sign that the positioning values are missing.
- Because we place `page_number` just in front of the closing `<\/training>` tag, the page number assigned will be the page on which the training item finishes. So if a training item spreads across multiple pages, only the last page number will be noted. A good example of this is the course "MET CIV-MILITARY RELATIONS" starting 8/4/2003 in Honduras. The activity listing starts on page 219 but completes on 220. So the page number assigned is page 220.
