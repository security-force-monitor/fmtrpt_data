# Notes: 2001-2002 FMT report

## Sources

This report is in seven different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2002/10849.htm):

 * Africa: http://www.state.gov/documents/organization/10964.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/10965.pdf
 * Europe: http://www.state.gov/documents/organization/10966.pdf
 * Near East: http://www.state.gov/documents/organization/10967.pdf
 * Newly Independent States: http://www.state.gov/documents/organization/10968.pdf
 * South Asia: http://www.state.gov/documents/organization/10969.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/10970.pdf

The report is not available in a single PDF.

## Runs

We have processed this report twice:

- 201903171306: original scrape.
- 202407121057: rescrape to get page number and improve extraction performance. We were able to get the the training quantities, a more accurate location, and fix a number of orphaned items. The downside is that with this additional data we are unable to match much of the rescraped data with the earlier data in order to grab the IDs. 

## Notes on 2001-2002 data extraction

### Issues from 201903171306

- US units are rarely noted in these pdfs.
- The pdfs are not cleanly split across regions, so at the start and end of each PDF you will get rows from the previous and subsequent region. We will parse them anyhow, and filter out at a later stage.
- Some specific challenges to do with font ordering may mean creating a script for each :( Here are the left values for programs and training values:

 * Africa: keep 0 and 3
 * East Asia and Pacific: keep 0 and 3
 * Europe: keep 0 and 2
 * Near East: keep 0 and 2
 * Newly Independent States: keep 0 and 2
 * South Asia: keep 0 and 3 
 * Western Hemisphere: keep 0 and 2

- So we can run the scripe in two groups:
 - Group 1: Africa, South Asia, East Asia and Pacific
 - Group 2: Europe, Near East, Newly Independent States, Western Hemisphere

- However, there are some more issues that have been emerging that caused us to use three groups again: largely, this is down to the removal of front matter that I said earlier didn't matter - it causes some issues with closing program tags. To work around this I have added another variable to the script whcih enables us to specify ranges that we might want to remove prior to parsing. 
- one issue here is that quantities of training are not parsed out into a separate item by pdf2text. We will have to deal with this at a later stage.

### Issues from 202407121057

- The presence in some PDFs of training data from other regions - usually on the first and last pages -  is fixed by removing these items from the raw XML before processing them further. This case be done with a `case` statement anchored around the region name variable. 
- We can process these in two groups as before; originally the third group was only the Newly Independent States, but we can deal with this in group 2. 
- A few tweaks means we now handle cases where the `location` item was blended in with the `quantity` item. This is done with capture groups. This does comparisons with the earlier data a bit more difficult.
- There are a few edge cases that defy auto processing.
