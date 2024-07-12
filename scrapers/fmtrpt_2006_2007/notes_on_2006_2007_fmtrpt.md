# Notes: 2006-2007 FMT report

## Sources

This report is not in a PDF format, but instead is in HTML, divided by the usual sections noted in the [landing page](https://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92083.htm):

 * Africa: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92084.htm
 * East Asia and Pacific: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92085.htm
 * Europe: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92086.htm
 * Near East: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92087.htm
 * South Central Asia: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92088.htm
 * Western Hemisphere: http://www.state.gov/t/pm/rls/rpt/fmtrpt/2007/92089.htm

There is no single page containing all the data for this report.

## Runs


## Notes

- The tools to extract data from this report are different from most of the others.
- I wrote a dirty `bash` parser for this one; should probably re-write it with `beautifulsoup` or somesuch.
- There are 48 rows where, inexplicably, the end date ends up in the costings column. This is something to do with the html in the Swaziland section, as it moves from the sections on "CTFP - FY 2006 DoD Training" to  "IMET - FY 2006 DoS Training". We fix some of this downstream but we'd welcome someone to figure out what is going wrong here.
