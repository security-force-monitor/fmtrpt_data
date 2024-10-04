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
 * Related to the above, there are two methods we can use to obtain the page numbers. First, pull it from the `<page>` tag in the XML; or, second, pull it directly from the content. For example, here's what we have with the `<page>` tag:

```
grep "^<page" 1_pdf_xml/2018_2019_Africa_fmtrpt.xml|head -n10
<page number="1" position="absolute" top="0" left="0" height="918" width="1188">
<page number="2" position="absolute" top="0" left="0" height="918" width="1188">
<page number="3" position="absolute" top="0" left="0" height="918" width="1188">
<page number="4" position="absolute" top="0" left="0" height="918" width="1188">
<page number="5" position="absolute" top="0" left="0" height="918" width="1188">
<page number="6" position="absolute" top="0" left="0" height="918" width="1188">
<page number="7" position="absolute" top="0" left="0" height="918" width="1188">
<page number="8" position="absolute" top="0" left="0" height="918" width="1188">
<page number="9" position="absolute" top="0" left="0" height="918" width="1188">
<page number="10" position="absolute" top="0" left="0" height="918" width="1188">
```

  And here is what we have if we filter on the position of the page numbering within the text itself, which is `top="881"` and `left="552"`:

```
grep "<text top=.881" 1_pdf_xml/2018_2019_Africa_fmtrpt.xml|head -n10
<text top="881" left="592" width="7" height="10" font="0"><b>1 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>2 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>3 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>4 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>5 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>6 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>7 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>8 </b></text>
<text top="881" left="592" width="7" height="10" font="0"><b>9 </b></text>
<text top="881" left="589" width="12" height="10" font="0"><b>10 </b></text>
```

  Either method works, and where there is a difference between the PDF numbering scheme and the inline page numbering, the latter approach will be more accurate and should be used.
