# Notes: 2018-2019 FMT Part I report

## Sources

This report was published on 5 or 6 December 2019 in a single PDF, listed on the report's [landing page](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/):

* All: https://www.state.gov/wp-content/uploads/2019/12/FMT_Volume-I_FY2018_2019.pdf

The report covers:

 * Africa
 * East Asia and Pacific
 * Europe
 * Near East
 * South Central Asia
 * Western Hemispheric Region

## Processing runs

We have processed the 2018-2019 FMT report three times:

 * 201912061605: first scrape of report
 * 202407101002: re-scrape to add page numbers, using older PDF extraction approach
 * 202407120948: re-scrape to add page numbers, using the newer PDF extraction approach (and having some manual matching to do)

## List of problems in 2018-2010

 * The report follows the same format as the 2017-2018 report, which with a few minor changes has been in place since 2007
 * This report required a little more fiddling with the xml tags to get it to lint properly
 * The `xml el` command is extremely useful in debugging xml problems, in addition to the detailed error report `xmllint` gives you.
 * When reprocessing this PDF to get the page number out (2024 run), I noticed a difference in the PDF to raw XML outputs that `pdftohtml` gives when working directly on the original PDF versus working on pages extracted using GhostScript. Where pages were first extracted with GhostScript, some of the entries in "Course Title" containing hyphens were split across attributes, creating orphaned values. This meant that some rows could not be fully extracted. A good example are the "UN Civil-Military Coordination Officers’ Course" on page 4, in the Cambodia section; GhostScript splits this into two rows at the hyphen, but `pdftohtml` does not. The upshot here is when re-extracting, stick with the process that was first used; also, for new reports, if the issue repeats, you can try both approaches.
 * `pdftohtml` has a weakness though: it calculates page numbers based on the complete PDF, rather than PDFs that are correctly sliced to allign with the page numbering. So there is tradeoff: accurate page numbers, vs rows that might not quite match because of parsing issues.
 * The above issue may surface at the point where a hash is made to enable the original uuids to travel to the newly extracted data.
