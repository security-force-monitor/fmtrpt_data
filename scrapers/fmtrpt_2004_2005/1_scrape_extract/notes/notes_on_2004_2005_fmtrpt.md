# Notes: 2004-2005 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2005/index.htm):

 * Africa: http://www.state.gov/documents/organization/45785.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/45787.pdf
 * Europe: http://www.state.gov/documents/organization/45788.pdf
 * Near East: http://www.state.gov/documents/organization/45789.pdf
 * South Asia: http://www.state.gov/documents/organization/45791.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/45793.pdf

Download these and plonk them in the input directory.

The report is not available in a single PDF.

## Runs

## Notes

### List of problems in 2004-2005 PDFs

-  PDF format same as 2005 with some minor changes to the font sizing in the FIRST pdf. However, as this is a split PDF the assignment of the font numbering is different, which breaks the extractor script. We'll have to do it in two waves probably - the first section (Africa), and then the remainders, which will likely share a lot in common. We can keep the common output structure.
- some issues with repeating header rows and orphan elements (e.g. us_units); fix with a perl munge to remove the offending lines
- usual sorts of fiddly tag opening and closing issues; remember when crafting a fix that it may be down to sequencing e.g. a fix won't work because it's in the wrong part of the script (and the stuff it relies on has not yet been inserted e.g.end matter or somesuch."
- the Africa output has two rows where no country is records; I think we take care of these later on when assigning ISO codes.