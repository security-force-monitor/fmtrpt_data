# Notes: 2019-2020 FMT Part I report

## Sources

This report was published on 4 or 5 August 2021 in a single PDF, listed on the report's [landing page](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2019-2020/). This report was published nearly a year late.

* All: https://www.state.gov/wp-content/uploads/2021/08/Volume-I-508-Compliant.pdf

The report covers:

 * Africa
 * East Asia and Pacific
 * Europe
 * Near East
 * South Central Asia
 * Western Hemispheric Region

## Processing Runs

We have processed the 2019-2020 FMT report twice:

 * 202108131700: original first scrape
 * 202402071355: Re-scrape with page number added

The two scrapes were done with the same PDF extractor, so there's no difference in how the original XML looked, and therefore no issues matching up the later, enhanced data with the earlier set to grab the training UUIDS.

## List of problems in 2019-2020

 * The report follows the same format as the 2018-2019 report, which has been in place since 2007.
 * Page 101 is a blank table, which truncates the data on Angola, and clips the head off the data on Benin. The problem this creates is that we can't tell where data on the two countries begins and ends. It is likely the scraper will, in this situation, merge the Angola and Benin data. As a consequence,we have removed Angole from this data upload until an updated version of the report correcting the problem is released by DoS (which will never happen!)
 * `pdftohtml` has difficulty extracting portions of this specific pdf and won't respect the start/end pages we give it. To work around this, we've used GhostScript to perform an initial slicing of the pdf, and the use `pdftohtml` on this to get the XML.
 * The `xml el` command is extremely useful in debugging xml problems, in addition to the detailed error report `xmllint` gives you.
 * Created a helper script (`analyze_xml.sh`) that looks at the XML of each section of the report, and tells us the variations in left position and font for the column header labels. We can use this info to generate the `sed` statements that do the lifting of assigning rows the correct attribute name.
