# Notes: 2005-2006 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2006/index.htm):

 * Africa: http://2009-2017.state.gov/documents/organization/74795.pdf
 * East Asia and Pacific: http://2009-2017.state.gov/documents/organization/74796.pdf
 * Europe: https://2009-2017.state.gov/documents/organization/74797.pdf
 * Near East: http://2009-2017.state.gov/documents/organization/74798.pdf
 * South Central Asia: http://2009-2017.state.gov/documents/organization/74799.pdf
 * Western Hemispheric Region: http://2009-2017.state.gov/documents/organization/74800.pdf

Download these and plonk them in the input directory.

The report is also available in single PDF here:

http://www.state.gov/documents/organization/75058.pdf

## Runs

We have procssed the 2005-2006 report twice:

- 201903171306:
- 202407121057:


## Notes

### List of problems in 2005-2006 PDFs

- PDF format changed considerable from the later reports, so I needed to re-write the section of the parser that deals with the raw XML to refine the XML bit.
- using `course_name` as an anchor against which to create a training tag has a some problems if there are duplicate rows that contain `course_name` (because that means duplicate trainings will be created). Not quite sure how to solve this one; possibly, if they are on consecutive lines in the raw output they could be merged there? A good example of this problem is "CGSC CORRESPONDENCE COURSE", which is split into "CGSC CORRESPONDENCE" and "COURSE". The XSLT deduplicator will not pick this up because the two items are not siblings in the XML.
- in this PDF, multiple units are squashed into a single cell, very messily. May create some sources of error.
- here, the start and end of a country is not clearly defined with its own tag, but is always included in the program. So, we can bound each program with a country. This doesn't matter because the country name is still the correct ancestor to the training when we convert it to TSV.
