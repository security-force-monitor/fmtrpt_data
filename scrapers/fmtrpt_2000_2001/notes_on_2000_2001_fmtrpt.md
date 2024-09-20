# Notes: 2000-2001 FMT report

## Sources

This report is in three different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2001/3121.htm):

 * Africa, Asia and Pacific: http://www.state.gov/documents/organization/3164.pdf
 * Europe, Near East, and Newly Independent States: http://www.state.gov/documents/organization/3165.pdf
 * South Asia, Western Hemisphere: http://www.state.gov/documents/organization/3166.pdf

Download these and plonk them in the input directory.

The report is not available in a single PDF.

## Processing runs

This report has been processed once:

 - 202407121057: first scrape, yielding 9190 discrete training items.

It was not processed in 2019 along with the others because it does not contain start date, end date, student unit and US unit - the four datapoints that enable us to connect US training to current security and defence force structures. However, for completion's sake we processed it in 2024.

## Issues encountered

- Program titles can be spread across lines in these PDFS. Resolved with some pattern matching and a refactor of the cleanup alg we use for it.
- The PDFs are columnar, but `pdftoxml` treats it as a single output each page. This means we have two sets of "left" and font values to work on each time when assigning the attribute tags.
- The content is not cleanly divided into Regions with a page break or a different PDF. So, for example, in 3165.pdf the Europe sectios is in pages 1-15, and the Near East section is on 15-32. However, the latter begins mid-way down page 15. If we ignored it, it would mean that we likely captured some rows twice: the first Near East rows would be the last of the Europe ones, and there would be the last page of Europe items in the Near East data. We don't deduplicate training items at any stage in the process, because we can never be entirely sure that there aren't legitimate duplicates. The solution in this case has been to trim the raw XML before we process it, removing any leading and trailing material. 
- Building on the previous point, 3164.pdf contains the Africa and East Asia data. The Africa section has different font assignment rules, so we process it separately.
- We extract the `page_number` information from inside the content, and don't use the `<page>` tag. This is just proved more accurate, because the `<page>` tag is specific to the PDF, and not the _content_. For example the data on Western Hemispheric region is on PDF pages 4 to 37, but the content numbering is pages 75 to 108. The page extraction alg works the same whatever numerical input it has. 
- I refactored `_cleanXML` into a subprocess composed of discrete one-step functions. This makes it a lot more legible and adaptable, and far easier to dedug.
- Cleanup stage stops at stage 4 as we don't have any prior data to compare it to, nor do we need to remove erroneous rows. 
