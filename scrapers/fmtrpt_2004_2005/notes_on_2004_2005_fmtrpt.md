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

We have processed these PDFs twice:

 - 201903171306:
 - 202407121057:

## Notes

### Intial observations of problems in 2004-2005 PDFs from 2019 scrape

-  PDF format same as 2005 with some minor changes to the font sizing in the FIRST pdf. However, as this is a split PDF the assignment of the font numbering is different, which breaks the extractor script. We'll have to do it in two waves probably - the first section (Africa), and then the remainders, which will likely share a lot in common. We can keep the common output structure.
- some issues with repeating header rows and orphan elements (e.g. us_units); fix with a perl munge to remove the offending lines
- usual sorts of fiddly tag opening and closing issues; remember when crafting a fix that it may be down to sequencing e.g. a fix won't work because it's in the wrong part of the script (and the stuff it relies on has not yet been inserted e.g.end matter or somesuch."
- the Africa output has two rows where no country is records; I think we take care of these later on when assigning ISO codes.

### Further Notes from 2024 scrape

- These PDFS are in the "template C" structure, which cover 2000 to 2005. As I'm working backwards, the first iteration of this template was the  2005-2006 FMT, so I used the extract script from that as the basis here.
- Kept the approach to doing it in two parts: Africa, and then the other regions. Although the differences between the `left=` values are not all that great, the script isn't wierd to handle this sort of divergance and at this point I'm not re-writing things further. 
- The general approach I've taken is to adapt the extract script first to use the refactored script that places the main  parts of the process into functions, with a `_main` control area. First run uses the PDF-specific parsing settings (all that sed and awk, etc). When I've got an identical output, we then add in the page number extraction parts, and adapt as needed, as there are usually a few structural problems that arise from the insertion of the `<page_number>` tag. 
- `xmllint -huge` and `xml el` remain extremely useful debuggers.
- in some cases, the final item of a page was dragged into the page number of the next. This was, as ever, because of where the original line containing the IV-x style page number appeared, and how it was incorporated into the `<training>` item. The key to fixing this was to ensure that we placed the `<page>` tag in between either `<training>` or `<program>` tags before we calculate the page numbers of all the `<training>` items.
- similarly, in some cases, the page number was assigned twice: that is, the XSLT didn't deduplicate it, but appended it. This was simply because `page_number` had been assigned twice into a `<training>` item, so we just remove the duplicate.
