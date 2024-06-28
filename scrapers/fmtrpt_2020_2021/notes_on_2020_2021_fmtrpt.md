# Notes: 2020-2021 FMT Part I report

## Sources

This report was published on 16 March 2022, but first appeared on the State Department website on 24 March 2022. It is published in separate PDFs corresponding to the regional groupings commonly used in this report. The files are listed on the report's [landing page](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2020-2021/). This report was published nearly six months later than usual.

The report covers:

 * [Africa](https://www.state.gov/wp-content/uploads/2022/03/10-Volume-I-Section-IV-Part-IV-I-Africa.pdf)
 * [East Asia and Pacific](https://www.state.gov/wp-content/uploads/2022/03/11-Volume-I-Section-IV-Part-IV-II-East-Asia-and-Pacific.pdf)
 * [Europe](https://www.state.gov/wp-content/uploads/2022/03/12-Volume-I-Section-IV-Part-IV-III-Europe.pdf)
 * [Near East](https://www.state.gov/wp-content/uploads/2022/03/13-Volume-I-Section-IV-Part-IV-IV-Near-East.pdf)
 * [South Central Asia](https://www.state.gov/wp-content/uploads/2022/03/14-Volume-I-Section-IV-Part-IV-V-South-Central-Asia.pdf)
 * [Western Hemispheric Region](https://www.state.gov/wp-content/uploads/2022/03/15-Volume-I-Section-IV-Part-IV-VI-Western-Hemisphere.pdf)

## Processing runs

We have processed the 2020-2021 FMT twice:

 * 202203261659: original scrape run with primary extract script at commit 7414deb3628c70702ec9dd2efd32cad539c2ca32
 * 202406271538: second scrape to extract page numbers using updated extract script at commit 3feedf2298985ac2d5377a40d545f1a9a6ea1159

## List of problems with processing the 2020-2021 report

 * In a small number of cases in the 2020-2021 PDFs, the raw XML produced by `pdftohtml` concatenates column values, which has downstream effects if not manually corrected in the XML or later in the process:
  * p15, Africa: the student unit "Ministry of Youth and Employment Promotion" is elided with the US unit "ACSS - 0" in the raw XML, meaning there is no entry in delivery unit.
  * p17, Europe: the student unit "Police-Criminal Intelligence and Analysis Unit" is elided with the US unit "N/A - 0" in the raw XML.
 * A few start training start dates are outside of the FY in question (e.g. 4/1/2016 as start date for a Communication Training for the Jordan army, which ends on 4/30/2020"
