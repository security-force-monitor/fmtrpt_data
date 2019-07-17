# Notes: 2002-2003 FMT report

## Sources

This report is in seven different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm):

 * Africa: http://www.state.gov/documents/organization/21817.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/21818.pdf
 * Europe: http://www.state.gov/documents/organization/21819.pdf
 * Near East: http://www.state.gov/documents/organization/21820.pdf
 * Newly Independent States: http://www.state.gov/documents/organization/21821.pdf
 * South Asia: http://www.state.gov/documents/organization/21822.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/21823.pdf

Download these and plonk them in the input directory.

The report is not available in a single PDF.

## Issues encountered

## List of problems in the 2002-2003 PDFs

- Report is in the 2005-2006 format but is shifted to the right side considerably, and the font ordering is a little different.
- Again, first PDF needs a little different treatment from the remainder. The font ordering will be differenet in non-Africa PDFs, so the initial filtering will need updating, as will the main sed groupings. It may help to diff the two extractor scripts rather than nuke one of them, as the "otther sections" script has a few extra steps that I always forget to reinclude.
- a few issues where program titles are repeated, breaking a training tag (remove with a perl slurp) 
- there are some issues where extra tabbing in the source table pushes the values across to the right and breaks the row, meaning we see start dates in end dates, and end dates as orphans in the position of course title. There aren't many, and largely they appear as `<text>` rows so we can find them easily. Not much point fixing these mechanically. 
