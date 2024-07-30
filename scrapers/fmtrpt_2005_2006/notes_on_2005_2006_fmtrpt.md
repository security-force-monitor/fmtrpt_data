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

* http://2009-2017.state.gov/documents/organization/75058.pdf

We have used this single PDF as the basis of processing this data.

## Runs

We have procssed the 2005-2006 report twice:

- 201903171306: original scrape.
- 202407121057: second scrape to obtain page numbers. Only 126 rows of the old data couldnt' be matched by hash with that created from the new scrape.


## Notes

### List of problems in 2005-2006 PDFs

- PDF format changed considerable from the later reports, so I needed to re-write the section of the parser that deals with the raw XML to refine the XML bit.
- using `course_name` as an anchor against which to create a training tag has a some problems if there are duplicate rows that contain `course_name` (because that means duplicate trainings will be created). Not quite sure how to solve this one; possibly, if they are on consecutive lines in the raw output they could be merged there? A good example of this problem is "CGSC CORRESPONDENCE COURSE", which is split into "CGSC CORRESPONDENCE" and "COURSE". The XSLT deduplicator will not pick this up because the two items are not siblings in the XML. Difficult to do much other than nuke one part of the orphan course title, if it's predictable.
- in this PDF, multiple units are squashed into a single cell, very messily. Also, unit names crossing multiple lines that can't be reconciled. May create some sources of error.
- here, the start and end of a country is not clearly defined with its own tag, but is always included in the program. So, we can bound each program with a country. This doesn't matter because the country name is still the correct ancestor to the training when we convert it to TSV.
- regions are not clearly broken up by page (e.g. DOD East Asia and Pacific Region begins halfway down page 36, following straight on from the Africa Region reporting), so slicing the PDF into sections prior to processing doesn't have the benefit that it does with later reports that have a better structure. It means we process the report in one go. 
- Page numbering does not correspond exactly to the PDF linear page numbering. In the single PDF version it goes out of sych the _actual_ report page numbers is included in a footer, but in a number of cases has been pushed onto the page following it (e.g. PDF page 211 is actual page number 210, and actual page number 210 doesn't have an actual page number; see also actual page 211). This means I need to pull the page number out from a different part of the XML rather than the helpful `<page>` tag.

## Approach to getting page numbers

- The `<page>` tag produced by `pdftohtml` is misaligned with the actual report page numbers, unlike in later reports, so we have to use a difference method.
- the page number is in the format "IV-23" and is outputted as just another row of XML, so we can just grab rows with those attributes and label them as `<page>`.
- the `gawk` process that does the work to find a page number and drop it into the `<training>` item just before the closing tag is re-used with one significant change. Because the page numbers appear at the bottom of the page, and the script operates downwards, we have to insert a fake page number "IV-o" at the top of the document. Then we add an increment of 1 to every number, so it then reports correctly. The final item needs manually assigning a page number for some reason.
- Anyhow, it works :)
