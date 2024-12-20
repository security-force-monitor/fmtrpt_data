# Notes: 2017-2018 Foreign Military Training Report

## Sources

This report was published on 15 August 2018 in a single PDF, listed on the report's [landing page](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2017-2018/):

* All: `https://www.state.gov/wp-content/uploads/2019/04/fmt_vol1_17_18.pdf`

The report covers:

 * Africa
 * East Asia and Pacific
 * Europe
 * Near East
 * South Central Asia
 * Western Hemispheric Region

Note that the PDF used for extraction is named `284930.pdf`, which is identical to `fmt_vol1_17_18.pdf`. Possibly the file was renamed after we first obtained it.

## Runs

We have processed the 2017-2018 FMT three times:

- 201903171306: initial scrape.
- 202407111138: second run to grab page numbers.
- 202407111324: third run grabs page numbers, but pre-slices PDFs to allign page numbers correctly with source PDF. A few rows could not be automatically matched with their earlier incarnations, because of small differences in how the PDF to XML functions worked.

## Notes

- This conversion step turns the PDF into simple XML that captures the recurrent pattern of the tables that we wish to extract.
- A large number of filters and regexes whittles down the XML produced by PDF convertor, removing irrelevant lines. Using specific criteria we then begin to introduce a nested structure into the document. By the end of it, we have well formed XML.
- In the original PDF from the State Department, some values in some cells had line breaks - usually `US Unit` and `Location`. The initial PDF to XML conversion treated each of these lines as a new row, and subsequent parsing then turned each, correctly, into a distinct item as part of the training element. This is allowable under XML, but distorts a flattened output like TSV. XSLT can be used to deal with this problem, as described in this Stack Overflow question I asked (the issue was beyond me!): https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text.
 * The 202407111324 re-scrape was necessary because the page numbers extracted using the older `pdftohtml` operation directly on the complete, original PDF were relative to the _whole_ PDF. The GhostScript step carves out each section of the report, accurately matching the page number of the PDF to teh page number printed on each page.
 * In situations where can't allign the PDF page numbers with the content page numbers, adapt the page assignment function to take the page value from within the page content (it's printed there) rather than from the `<page>` tag.
