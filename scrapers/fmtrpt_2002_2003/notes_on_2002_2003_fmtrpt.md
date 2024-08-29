# Notes: 2002-2003 FMT report

## Sources

This report is in seven different PDFs, listed on the report's [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm):

 * Africa: http://www.state.gov/documents/organization/21817.pdf
 * East Asia and Pacific: http://www.state.gov/documents/organization/21818.pdf
 * Europe: http://www.state.gov/documents/organization/21819.pdf
 * Near East: http://www.state.gov/documents/organization/21820.pdf
 * Newly Independent States: http://www.state.gov/documents/organization/21821.pdf
 * South Asia: http://www.state.gov/documents/organization/21822.pdf
 * Western Hemisphere: http://www.state.gov/documents/organization/21823.pdf

The report is not available in a single PDF.

## Runs

This report has been processed twice:

 - 201903171306: initial scrape and parse of report.
 - 202407121057: rescrape to collect page numbers. I made some changes to edge case handling which mean there are a few extra, complete items in this updated dataset; this results in 277 rows of older data that can't be matched and will need manual reconciliation.

## Notes

### Issues encountered in 201903171306 scrape

- Report is in the 2005-2006 format but is shifted to the right side considerably, and the font ordering is a little different.
- Again, first PDF needs a little different treatment from the remainder. The font ordering will be differenet in non-Africa PDFs, so the initial filtering will need updating, as will the main sed groupings. It may help to diff the two extractor scripts rather than nuke one of them, as the "otther sections" script has a few extra steps that I always forget to reinclude.
- a few issues where program titles are repeated, breaking a training tag (remove with a perl slurp) 
- there are some issues where extra tabbing in the source table pushes the values across to the right and breaks the row, meaning we see start dates in end dates, and end dates as orphans in the position of course title. There aren't many, and largely they appear as `<text>` rows so we can find them easily. Not much point fixing these mechanically. 

### Issues encountered in 202407121057 scrape

I noticed in the Africa PDF that a few course titles become orphan items in the output TSV because they are split across rows in the initial XML e.g.

```
8382 <text top="357" left="324" width="117" height="12" font="6">MANAGING ENG LANG </text>
8383 <text top="350" left="441" width="5" height="20" font="2"> </text>
8384 <text top="357" left="525" width="6" height="12" font="6">1</text>
8385 <text top="350" left="531" width="5" height="20" font="2"> </text>
8386 <text top="357" left="538" width="130" height="12" font="6">LACKLAND AFB, TX 78236</text>
8387 <text top="350" left="668" width="5" height="20" font="2"> </text>
8388 <text top="357" left="743" width="43" height="12" font="6">Air Force</text>
8389 <text top="350" left="785" width="5" height="20" font="2"> </text>
8390 <text top="357" left="1210" width="32" height="12" font="6">$8,141</text>
8391 <text top="350" left="1242" width="5" height="20" font="2"> </text>
8392 <text top="357" left="1262" width="41" height="12" font="6">12/10/01</text>
8393 <text top="350" left="1303" width="5" height="20" font="2"> </text>
8394 <text top="357" left="1344" width="29" height="12" font="6">2/1/02</text>
8395 <text top="354" left="1374" width="4" height="15" font="7"> </text>
8396 <text top="369" left="324" width="54" height="12" font="6">TNG(MELT</text>
8397 <text top="368" left="378" width="3" height="13" font="6"> </text>
```
In this XML, the itme "TNG(MELT" is split from "MANAGING ENG LANG" - so the proper title should be "MANAGING ENG LANG TNG(MELT" (there isn't a closing parenthesis in the PDF). Our script correctly assigns them the tag of `<course_title>` based on the `left` and `font` positions, but because the text "TNG(MELT" appears after the end date value, the script converts it into a new training item, which turns out to be just a course title. Because there are only a few of these cases, We can correct them with some substitutions that append the orphan text to its parent, and then remove the orphan text so it will not be turned into a `<course_title>` item (the regex for which will not operate on blanks). This generates a few more complete items than in the first scrape, which leads to more items that don't reconcile by hash comparison with earlier data - so, so eyeballing and manual work will be required.

A small number of rows in the report are pushed a column to the right, meaning that total cost value appears in the start date, and the end date is pushed onto the next row and risks becoming an orphan. For example, in the raw XML of the Western Hemisphere report we can see this:

```
2423 <text top="138" left="324" width="78" height="12" font="3">CHDS Programs</text>
2424 <text top="131" left="402" width="5" height="20" font="0"> </text>
2425 <text top="138" left="525" width="6" height="12" font="3">4</text>
2426 <text top="131" left="531" width="5" height="20" font="0"> </text>
2427 <text top="138" left="538" width="77" height="12" font="3">Washington, DC</text>
2428 <text top="131" left="614" width="5" height="20" font="0"> </text>
2429 <text top="138" left="743" width="187" height="12" font="3">Techint Organization, Universidad de la </text>
2430 <text top="131" left="929" width="5" height="20" font="0"> </text>
2431 <text top="138" left="1054" width="188" height="12" font="3">Center for Hemispheric Defense Studies</text>
2432 <text top="131" left="1242" width="5" height="20" font="0"> </text>
2433 <text top="138" left="1263" width="38" height="12" font="3">$31,996</text>
2434 <text top="131" left="1301" width="5" height="20" font="0"> </text>
2435 <text top="138" left="1342" width="35" height="12" font="3">1/28/02</text>
2436 <text top="143" left="324" width="5" height="20" font="0"> </text>
2437 <text top="150" left="331" width="35" height="12" font="3">2/15/02</text>
2438 <text top="147" left="366" width="4" height="15" font="4"> </text>
2439 <text top="155" left="324" width="5" height="20" font="0"> </text>
```

Here, we would not expect the dollar value of $31,996 to appear with a left value of 1263 - that's usually where start date appears. So, we can filter this out by testing for a dollar sign in there when we assign a tag. Similarly, we don't expect the date of 2/15/02 to appear with a left value of 331 - that's usually where a course title goes. So, again we can assign it an end date tag. In the grouping stage, what will happen here is that we have two end date values concatenated into the field: "1/28/02 2/15/02". There is a sfunction in the cleanup script that handles this for the 2009 report, but we can adapt it for this one easily:

```
gawk 'BEGIN	{ FS=OFS="\t"};						\
		{	gsub(/"/,"",$9) ;				\
			split($9,date," ") ;				\
			s=date[1] ;					\
			e=date[2] ;					\
			if ( $2 ~ /2009_2010/ && $9 ~ / / ) {$9=s ; $10=e} ; 	\
			print 						\
		}' \
		"notes/7_${i}"  \
		 > notes/8_${i}
```

This will pull the first of the two date values into the start date column; the function can be adapted to handle two cases: both dates in start date column, and both dates in end date column. 


