# Notes: 2020-2021 FMT Part I report

## Sources

This report was published on 16 March 2022, but first appeared on the State Department website on 24 March 2022. It is published in separate PDFs corresponding to the regional grouping commonly used in this report. The files are listed on the report's [landing page](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2020-2021/). This report was published nearly six months later than usual.

The report covers:

 * [Africa](https://www.state.gov/wp-content/uploads/2022/03/10-Volume-I-Section-IV-Part-IV-I-Africa.pdf)
 * [East Asia and Pacific](https://www.state.gov/wp-content/uploads/2022/03/11-Volume-I-Section-IV-Part-IV-II-East-Asia-and-Pacific.pdf)
 * [Europe](https://www.state.gov/wp-content/uploads/2022/03/12-Volume-I-Section-IV-Part-IV-III-Europe.pdf)
 * [Near East](https://www.state.gov/wp-content/uploads/2022/03/13-Volume-I-Section-IV-Part-IV-IV-Near-East.pdf)
 * [South Central Asia](https://www.state.gov/wp-content/uploads/2022/03/14-Volume-I-Section-IV-Part-IV-V-South-Central-Asia.pdf)
 * [Western Hemispheric Region](https://www.state.gov/wp-content/uploads/2022/03/15-Volume-I-Section-IV-Part-IV-VI-Western-Hemisphere.pdf)

## List of problems with processing the 2020-2021 report

 * In a few cases, the raw XML from `pdftohtml` concatenates column values, which has downstream effects if not manually corrected:
  * p16, Africa: the student unit "Ministry of Youth and Employment Promotion" is elided with the US unit "ACSS - 0" in the raw XML.
  * p17, Europe: the student unit "Police-Criminal Intelligence and Analysis Unit" is elided with the US unit "N/A - 0" in the raw XML.
