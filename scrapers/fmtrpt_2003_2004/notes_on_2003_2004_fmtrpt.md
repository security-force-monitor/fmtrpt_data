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

## Notes

### List of problems in 2003-2004 PDFs

- Report is in the 2005-2006 format, so we can re-use parts of the scraper from there.
- similar to 2004/05 the issue is that the first of the pdfs has a different font ordering so needs to be treated separately.
- some issues emerging from mistakes in the source document which throw errors, such as US units appears in the column for start dates. These can usually be fished out by grepping for rows that retain `<text>` tags. We should run sa general check on every preceeding output to ensure we have caught these rows and figured out how to deal with them.
