# Notes on parsing the 2016-2017 FMT report

## Runs

We have procesed the 2016-2017 report twice:

 * 201903171306: initial scrape
 * 202407121057: second scrape to obtain page numbers, made with updated PDF-XML steps. Around 55 rows could not be matched automatically with the earlier dataset, using a hash.

## Notes

- intial scrape don with script derived from the one used on the 2017-2018 report.
-  second scrape done with updated scripting (so may throw some diffeences up).
- `pdftohtml` throws a "bad annotation destination" warning when parsing, but this does not affect the outputs.
- made some updates to the xml cleanup bit of the extraction script for the 202407121057 run. A few loose tags appeared!

