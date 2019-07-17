# Notes: 2009-2010 FMT report

## Sources

This report is in six different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2010/index.htm):

 * Africa: https://www.state.gov/documents/organization/155997.pdf
 * East Asia and Pacific: https://www.state.gov/documents/organization/155998.pdf
 * Europe: https://www.state.gov/documents/organization/155999.pdf 
 * Near East: https://www.state.gov/documents/organization/156000.pdf
 * South Central Asia: https://www.state.gov/documents/organization/156001.pdf
 * Western Hemisphere: https://www.state.gov/documents/organization/156002.pdf

Download these and plonk them in the input directory.

There is also a single document version of this report, available here:

http://www.state.gov/documents/organization/155982.pdf

## Changes to column headings

The column `US unit` does not exist in this document. In the parser script, I have removed the extraction/filtering around `US unit` but retained the column in the output, which means it will keep compatible with later versions of the report data where `US unit` is specified.

The column `Training location` is just called `Location` in this report, meaning that table headers rows don't get filtered out before the xml is refined, breaking the layout.

## General parsing problems with the 2009-201 report

- These PDFs do not parse as cleanly as the laters ones do. The `pdftohtml` tool that we use is splitting words in places it should not, which is depriving us of some unit names (the way around this will be to specify a range for the left position for each block of text, rather than a single value. But I'm not sure how to do this at the moment.
- the early breaks, or lack of detection of breaks in columns, means that some groups of text get pulled into the wrong xml element, which means a tagset might not be closed. I've dealt with this by putting in regex that look for early closure patterns for the training element, and then sub in the relevant closing tag.
- Also, the Cyprus total figure is in bold, which breaks the initial filtering (e.g. text is not categorised as "0" but 3); filtered out specifically in the script (with no loss to use, as it's not a substantive training)
- We can also specifiy a second row for `Student Unit`, which is sometimes split on 2 rows. The delineator is `664` pixels. 
