# Notes: 2010-2011 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2011/index.htm):

 * Africa: https://www.state.gov/documents/organization/171509.pdf
 * East Asia and Pacific: https://www.state.gov/documents/organization/171510.pdf
 * Europe: https://www.state.gov/documents/organization/171511.pdf 
 * Near East: https://www.state.gov/documents/organization/171512.pdf
 * South Central Asia: https://www.state.gov/documents/organization/171513.pdf
 * Western Hemisphere: https://www.state.gov/documents/organization/171514.pdf

Download these and plonk them in the input directory.

## Runs

We have processed the 2010-2011 report twice:

- 201903171306:
- 202407121057:

## Notes

- Changes to column headings: The column `US unit` does not exist in this document. In the parser script, I have removed the extraction/filtering around `US unit` but retained the column in the output, which means it will keep compatible with later versions of the report data where `US unit` is specified.
