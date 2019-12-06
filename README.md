# Foreign Military and Training Report: Parsing project

A dataset on unclassified training activities for non-US security forces arranged and funded by the United States Department of State and Department of Defence between 2001 and 2019. Sources, scraping, cleaning and publishing toolset included.

Access the data at: [https://trainingdata.securityforcemonitor.org](https://trainingdata.securityforcemonitor.org)

## 1. Overview

At Security Force Monitor we create data on organizational structure, command personnel, geographical footprint of police, military and other security forces. We connect this to information about human rights abuses, assisting human rights researchers, litigators and investigative journalists in their work to hold security forces to account. All our data is published on [WhoWasInCommand.com](https://whowasincommand.com). 

A key question we have is whether specific units and personnel implicated in human rights abuses have received training or assistance from the United States government. Whether the training or assistance was given prior to or after the unit's implication in a human rights abuse, it raises important questions about the effectiveness of the implementation of the "[Leahy laws](https://www.state.gov/key-topics-bureau-of-democracy-human-rights-and-labor/human-rights/leahy-law-fact-sheet/)", which are a vetting and due diligence processes in place to prevent this from happening. 

These questions can in part be answered by looking at the joint Department of State and Department of Defence report, "Foreign Military Training and DoD Engagement Activities of Interest". Released annually since 2000 (the 2000 report covered the U.S. government's fiscal year 1999-2000) this important, statutorily-mandated report shows in great detail how the US has spent much of its training and assistance budget, and with what aims. Generally, the US Department of State will release these reports as PDFs. They  can be found at the following locations online:

 * FY 2016-2019 onwards are available here: [https://www.state.gov/foreign-military-training-and-dod-engagement-activities-of-interest/](https://www.state.gov/foreign-military-training-and-dod-engagement-activities-of-interest/)
 * FY 1999-2000 to FY 2015-2016: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/index.htm)

Training activities that were completed in each fiscal year are recorded in `Volume I: Section IV` of the report, mostly in tabular form. For most years this data includes the name of the training course, the trainee unit, their country, the exact start and end date of the training, and so on. We include more detail on this below.

The value of the data is high, but its accessibility is low because of the way the data are published. To establish, for example, every training a single student unit had received since 1999, an analyst would have to manually search over 80 different PDFs.

This project addresses this challenge by providing clean, accurate and standardized machine-readable copy of all the data contained in the reports. We also aim to provide a simple and effective way for anyone to search the data and retrieve it in a standard, easy to use format. Importantly, we also show how the data were created and processed, keeping a direct link between the original report and the data. We also wanted to create a way to quickly update and analyse the dataset with each new release from the Department of State.

There is an existing dataset created by the team at the excellent Security Assistance Monitor (SAM) and downloadable without cost [here](https://securityassistance.org/content/military-trainees-downloads). For our needs, there are two limitations to this dataset. First, though SAM have included the fiscal year in which a training was carried out, they have not included the data on `start date` and `end date` of trainings, which are critical to our research aims. Second, the detailed dataset ends with FY 2015-2016 and we're unclear whether SAM have plans to revisit and extend the data in the future. Unfortunately, it is easier to start from scratch than to attempt to extend this existing work.

Longer term, our aim is to integrate this dataset from the DoS/DoD with that contained in WhoWasinCommand.com, which will give our users even further insight into who is supporting the security forces they are researching.

## 2. Data and data model

The final dataset is comprised of the fields described in the table below.


Field|Description|Example of use|
|:--:|:--|:--|
|source\_uuid|Unique code used by SFM to identify the source of the data|"048fb2d9-6651-4ba0-b36a-a526539f4cfd"|
|group|file containing the first, raw scrape of data SFM made; use for audit|"2001\_2002\_Africa_fmtrpt.tsv"|
|country|Country of training recipient|"Cote d'Ivoire"|
|iso\_3166\_1|ISO-3166-1 standard code for country of training recipient|"CIV"|
|program|DoD/DoS financing program|East Asia and Pacific Region, Thailand, International Military Education and Training (IMET), FY01|
|course\_title|Name of training course|"HOT SHIP XFER 180 FT PAC"|
|us_unit|US security force unit(s) involved in delivery of training|"1/10 SFG, 7 SOS"|
|student_unit|Name of recipient(s) of training|"SPECIAL SERVICES GROUP NAVY, ST-3 PLT F, SBU-12 RIB DET N, SDVT-1 TU BAHRAINI NAVY"|
|start\_date|Start date of training as stated in source (mostly `m-dd-yy`)|"1/16/01"|
|start\_date_fixed|Start date of training, in ISO 8601 (`YYYY-MM-DD`)|"2001-01-16"|
|end\_date|End date of training (mostly `m-dd-yy`)|"1/31/01"|
|end\_date_fixed|End date of training as stated in source, in ISO 8601 (`YYYY-MM-DD`)|"2001-01-31"|
|location|Place where the training was held|"LACKLAND AFB, TX 78236"|
|quantity|Number of trainees|"30"|
|total\_cost|Total cost of that specific training, in USD|"8000"|
|source\_url|Specific PDF or web-page from which the row is extracted|"https://2009-2017.state.gov/documents/organization/10967.pdf"|
|row\_status|Whether the row has been hand checked against the source|"Not checked against source; verify accuracy before use"|
|date\_first_seen|Date that row of data was first made available publicly (`YYYY-MM-DD`, or parts thereof)|"2002-03"|
|date\_scraped|Date that row of data was obtained and scraped by SFM (`YYYY-MM-DD`) |"2019-07-17"|




## 3. Data sources and coverage

In the table below, we provide an overview of the available source materials, where to get them, what data are contained within them, and whether we have included the material in the dataset. In summary, we have included everything from the 2001-2002 onwards. With the exception of a four year streak where data in the `US unit` field was not included in the data, the field coverage is consistent year on year.

||Source (Vol. 1 - Training Activities)|Included in dataset?|Country|DOD/DOS Program|Course Title|US Unit|Student Unit|Start date|End date|Location|Quantity|Total Cost|
|:---:|:--:|:--:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|[FY 2018-2019](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/12/FMT_Volume-I_FY2018_2019.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2017-2018](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2017-2018/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/04/fmt_vol1_17_18.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2016-2017](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2016-2017/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/04/fmt_vol1_16_17.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2015-2016](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2016/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/265162.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2014-2015](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm)|PDF: [All](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm), [A](https://2009-2017.state.gov/documents/organization/243021.pdf), [EAP](https://2009-2017.state.gov/documents/organization/243030.pdf),[E](https://2009-2017.state.gov/documents/organization/243031.pdf), [NE](https://2009-2017.state.gov/documents/organization/243032.pdf), [SCA](https://2009-2017.state.gov/documents/organization/243033.pdf), [WH](https://2009-2017.state.gov/documents/organization/243034.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2013-2014](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2014/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/230192.pdf), [A](https://2009-2017.state.gov/documents/organization/230209.pdf), [EAP](https://2009-2017.state.gov/documents/organization/230211.pdf), [E](https://2009-2017.state.gov/documents/organization/230213.pdf), [NE](https://2009-2017.state.gov/documents/organization/230215.pdf), [SCA](https://2009-2017.state.gov/documents/organization/230217.pdf), [WH](https://2009-2017.state.gov/documents/organization/230219.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2012-2013](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2013/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/213444.pdf), [A](https://2009-2017.state.gov/documents/organization/213460.pdf), [EAP](https://2009-2017.state.gov/documents/organization/213462.pdf), [E](https://2009-2017.state.gov/documents/organization/213464.pdf), [NE](https://2009-2017.state.gov/documents/organization/213466.pdf), [SCA](https://2009-2017.state.gov/documents/organization/213468.pdf), [WH](https://2009-2017.state.gov/documents/organization/213470.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2011-2012](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2012/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/197595.pdf), [A](https://2009-2017.state.gov/documents/organization/197610.pdf), [EAP](https://2009-2017.state.gov/documents/organization/197611.pdf), [E](https://2009-2017.state.gov/documents/organization/197612.pdf), [NE](https://2009-2017.state.gov/documents/organization/197613.pdf), [SCA](https://2009-2017.state.gov/documents/organization/197614.pdf), [WH](https://2009-2017.state.gov/documents/organization/197615.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2010-2011](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2011/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/171494.pdf), [A](https://2009-2017.state.gov/documents/organization/171509.pdf), [EAP](https://2009-2017.state.gov/documents/organization/171510.pdf), [E](https://2009-2017.state.gov/documents/organization/171511.pdf), [NE](https://2009-2017.state.gov/documents/organization/171512.pdf), [SCA](https://2009-2017.state.gov/documents/organization/171513.pdf), [WH](https://2009-2017.state.gov/documents/organization/171514.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|
|[FY 2009-2010](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2010/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/155982.pdf), [A](https://2009-2017.state.gov/documents/organization/155997.pdf), [EAP](https://2009-2017.state.gov/documents/organization/155998.pdf), [E](https://2009-2017.state.gov/documents/organization/155999.pdf), [NE](https://2009-2017.state.gov/documents/organization/156000.pdf), [SCA](https://2009-2017.state.gov/documents/organization/156001.pdf), [WH](https://2009-2017.state.gov/documents/organization/156002.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|
|[FY 2008-2009](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2009/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/152778.pdf), [A](https://2009-2017.state.gov/documents/organization/152766.pdf), [EAP](https://2009-2017.state.gov/documents/organization/152767.pdf), [E](https://2009-2017.state.gov/documents/organization/152768.pdf), [NE](https://2009-2017.state.gov/documents/organization/152770.pdf), [SCA](https://2009-2017.state.gov/documents/organization/152773.pdf), [WH](https://2009-2017.state.gov/documents/organization/152774.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|
|[FY 2007-2008](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2008/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/126573.pdf), [EAP](https://2009-2017.state.gov/documents/organization/126574.pdf), [E](https://2009-2017.state.gov/documents/organization/126575.pdf), [NE](https://2009-2017.state.gov/documents/organization/126576.pdf), [SCA](https://2009-2017.state.gov/documents/organization/126577.pdf), [WH](https://2009-2017.state.gov/documents/organization/126578.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|
|[FY 2006-2007](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/index.htm)|HTML: <strike>All</strike>, [A](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92084.htm), [EAP](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92085.htm), [E](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92086.htm), [NE](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92087.htm), [SCA](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92088.htm), [WH](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92089.htm)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2005-2006](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2006/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/75058.pdf), [A](https://2009-2017.state.gov/documents/organization/74795.pdf), [EAP](https://2009-2017.state.gov/documents/organization/74796.pdf), [E](https://2009-2017.state.gov/documents/organization/74797.pdf), [NE](https://2009-2017.state.gov/documents/organization/74798.pdf), [SA](https://2009-2017.state.gov/documents/organization/74799.pdf), [WH](https://2009-2017.state.gov/documents/organization/74800.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2004-2005](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2005/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/45785.pdf), [EAP](https://2009-2017.state.gov/documents/organization/45787.pdf), [E](https://2009-2017.state.gov/documents/organization/45788.pdf), [NE](https://2009-2017.state.gov/documents/organization/45789.pdf), [SA](https://2009-2017.state.gov/documents/organization/45791.pdf), [WH](https://2009-2017.state.gov/documents/organization/45793.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2003-2004](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2004/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/34329.pdf), [EAP](https://2009-2017.state.gov/documents/organization/34330.pdf), [E](https://2009-2017.state.gov/documents/organization/34331.pdf), [NE](https://2009-2017.state.gov/documents/organization/34334.pdf), [NIS](https://2009-2017.state.gov/documents/organization/34336.pdf) [SA](https://2009-2017.state.gov/documents/organization/34337.pdf), [WH](https://2009-2017.state.gov/documents/organization/34338.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2002-2003](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/21817.pdf), [EAP](https://2009-2017.state.gov/documents/organization/21818.pdf), [E](https://2009-2017.state.gov/documents/organization/21819.pdf), [NE](https://2009-2017.state.gov/documents/organization/21820.pdf), [NIS](https://2009-2017.state.gov/documents/organization/21821.pdf), [SA](https://2009-2017.state.gov/documents/organization/21822.pdf), [WH](https://2009-2017.state.gov/documents/organization/21823.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2001-2002](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2002/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/10964.pdf), [EAP](https://2009-2017.state.gov/documents/organization/10965.pdf), [E](https://2009-2017.state.gov/documents/organization/10966.pdf), [NE](https://2009-2017.state.gov/documents/organization/10967.pdf), [NIS](https://2009-2017.state.gov/documents/organization/10968.pdf), [SA](https://2009-2017.state.gov/documents/organization/10969.pdf), [WH](https://2009-2017.state.gov/documents/organization/10970.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2000-2001](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2001/index.htm)|PDF: <strike>All</strike>, [A + EAP](https://2009-2017.state.gov/documents/organization/3164.pdf), [E + NE + NIS](https://2009-2017.state.gov/documents/organization/3165.pdf), [SCA + WH](https://2009-2017.state.gov/documents/organization/3166.pdf)|No|✓|✓|✓|✗|✗|✗|✗|✗|✓|✓|
|[FY 1999-2000](https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html)*|HTML: <strike>All</strike>, A [1](https://web.archive.org/web/20170601013645/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_a2gam.html) [2](https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_gha2rwa.html) [3](https://web.archive.org/web/20170105062147/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_sao2zim.html), EAP [1](https://web.archive.org/web/20170105154743/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eap_aust2papua.html) [2](https://web.archive.org/web/20170106050009/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eap_phil2viet.html), E [1](https://web.archive.org/web/20170106050500/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eur_alb2est.html) [2](https://web.archive.org/web/20170106054830/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eur_latv2switz.html), NE [1](https://web.archive.org/web/20170106061730/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nea_alg2eg.html) [2](https://web.archive.org/web/20170106062351/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nea_ir2ye.html) NIS [1](https://web.archive.org/web/20170106062400/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nis_all.html), SA [1](https://web.archive.org/web/20170106062410/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_sasia_all.html), WH [1](https://web.archive.org/web/20170106062413/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_a2ch.html) [2](https://web.archive.org/web/20170106062415/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_col2ecua.html) [3](https://web.archive.org/web/20170106062417/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_el2jama.html) [3](https://web.archive.org/web/20170106062419/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_mex2peru.html) [4](https://web.archive.org/web/20170106062422/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_stk2ven.html)|No|✓|✓|✓|✗|✗|✗|✗|✗|✓|✓|

Key:

A: Africa

EAP: East Asia and Pacific

E: Europe

NE: Near East

NIS: Newly Independent States

SCA: South Central Asia

SA: South Asia

WH: Western Hemisphere

\* Unavailable on official website, available in Internet Archive

## 4. Notes on specific reports

### 2018-2019 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/)

Data from the 2018-2019 report are included in the dataset. The 2018-2019 report is published on the State Department website as a single PDF file.

### 2017-2018 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2017-2018/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2017-2018/)

Data from the 2017-2018 report are included in the dataset. The 2017-2018 report is available in the 2009-2017 archives of the State Department website, and is published as a single PDF file. 

### 2016-2017 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2016-2017/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2016-2017/)

Data from the 2016-2017 report are included in the dataset. The 2016-2017 report is available in the 2009-2017 archives of the State Department website, and is published as a single PDF file. This PDF is in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent.

### 2015-2016 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2016/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2016/index.htm)

Data from the 2015-2016 report are included in the dataset. The 2015-2016 report is available in the 2009-2017 archives of the State Department website, and is published as a single PDF file. This PDF is in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent.

### 2014-2015 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm)

Data from the 2014-2015 report are included in the dataset. The 2014-2015 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent.

### 2013-2014 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2014/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2014/index.htm)

Data from the 2013-2014 report are included in the dataset. The 2013-2014 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent.

### 2012-2013 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2013/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2013/index.htm)

Data from the 2012-2013 report are included in the dataset. The 2012-2013 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent.

### 2011-2012 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2012/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2012/index.htm)

Data from the 2011-2012 report are included in the dataset. The 2011-2012 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent. The name of the US unit along with another value called  `US qty` (the number of personnel involved perhaps?) are included in the same field; it only happens in this report, and we have not extracted `US qty` into the dataset. 

### 2010-2011 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2011/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2011/index.htm)

Data from the 2010-2011 report are included in the dataset. The 2010-2011 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent. The name of the US unit involved in delivering the activities is not recorded in the 2010-2011 report; we have noted this in the relevant rows.

### 2009-2010 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2010/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2010/index.htm)

Data from the 2009-2010 report are included in the dataset. The 2009-2010 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent. The name of the US unit involved in delivering the activities is not recorded in the 2009-2010 report; we have noted this in the relevant rows.

### 2008-2009 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2009/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2009/index.htm)

Data from the 2008-2009 report are included in the dataset. The 2006-2009 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are in the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent. The name of the US unit involved in delivering the activities is not recorded in the 2008-2009 report; we have noted this in the relevant rows.

### 2007-2008 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2008/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2008/index.htm)

Data from the 2007-2008 report are included in the dataset. The 2007-2008 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. These PDFs are the first of the format that remains until at least the publication of the 2017-2018 report, which at the time of writing is the most recent. The name of the US unit involved in delivering the activities is not recorded in the 2007-2008 report; we have noted this in the relevant rows.

### 2006-2007 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/index.htm)

Data from the 2006-2007 report are included in the dataset. The 2006-2007 report is available in the 2009-2017 archives of the State Department website, and is published only as a set of HTML pages. As a result, we wrote a separate parser for this report.

### 2005-2006 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2006/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2006/index.htm)

Data from the 2005-2006 report are included in the dataset. The 2005-2006 report is available in the 2009-2017 archives of the State Department websites, and is published as a set of PDF files. The PDF structure is similar to the 2001-2002 report, but this is the last year that this structure is used; the 2006-2007 structure is very different.

### 2004-2005 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2005/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2005/index.htm)

Data from the 2004-2005 report are included in the dataset. The 2004-2005 report is available in the 2009-2017 archives of the State Department websites, and is published as a set of PDF files. The PDF structure is similar to the 2001-2002 report. 

### 2003-2004 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2004/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2004/index.htm)

Data from the 2003-2004 report are included in the daaset. The 2003-2004 report is available in the 2009-2017 archives of the State Department websites, and is published as a set of PDF files.  The PDF structure is similar to the 2001-2002 report.

### 2002-2003 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm)

Data from the 2002-2003 report are included in the dataset. The 2002-2003 report is available in the 2009-2017 archives of the State Department website, and is published as a set of PDF files. The PDF structure is similar to the 2001-2002 report.

### 2001-2002 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2002/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2002/index.htm)

Data from the 2001-2002 report are included in the dataset. The 2001-2002 report is available in the 2009-2017 archives of the State Department website, and is available as a set of PDF files. There are minor differences in formatting between the different files that constitute the 2001-2002 report, and sometimes rows of data are split across pages causing occasional parser errors that need correcting. Further, because of the PDF structure for this particular report, the training quantity is sometimes included inside the parser output for the location. This can be fixed in bulk at a later data cleaning stage. This PDF structure persists, albeit with a number of small structural and aesthetic changes, until 2005-2006.

### 2000-2001 report

Report home page: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2001/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2001/index.htm)

Data from the 2000-2001 report is not included in the dataset. The 2001-2001 report is available in the 2009-2017 archives of the State Department website, and is available as a PDF. The 2000-2001 report does not contain the name of the US unit and the student unit, the location, start date or end date of the training. Accordingly, we did not parse out this report for inclusion in the dataset. Should we later decide to parse them, note that The PDFs are formatted into two columns which makes  parsing trickier than for later releases.

### 1999-2000 report 

Report home page (Internet Archive only): [https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html](https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html)

Data from the 1999-2000 report is not included in the dataset.The 1999-2000 report is available in the 2009-2017 archives of the State Department website, and is only avaailable from an official source in HTML format. This report does not contain the name of the US unit and the student unit, the location, start date or end date of the training. Accordingly, we did not parse out this report for inclusion in the dataset.

## 5. Technical

### Approach to extraction and cleaning

All the PDFs contain tabular data, with some variances in content structure and appearance. All the PDFs have been generated directly from another program - likely MS Word - rather than scanned in and processed with OCR.  

We sought to extract this data in a replicable, programmatic way rather than cut-and-paste our way through the tables once.  The reports are mostly in a tabular structure, ordered by country of the recipient units, and the program through which the Department of State or Department of Defence made the expenditure. The available data fields are mostly the same across the 19 publications released to date. The key differences are in the formatting and layout: there are five different formats across the publication set, but two formats cover the majority of the publications. There are, however, small variations even in the same formats, which presents some challenges to creating an automated extraction process (see below on report structures).

We have taken the below approach to extracting and parsing data from these reports:

 * Establish the page ranges in a PDF or group of PDFs that contain different sections of data (e.g. Africa, Europe) and use that to structure the overall parsing process and its outputs.
 * Convert the PDF files to very verbose XML that pulls out every table item or paragraph into a separate row containing detailed paragraph positioning and font-sizing.
 * Filter out anything that isn't in the tables (including, sadly, page numbering), and use the left-right positioning and font-size to determine what the content is. For example, in the 2017-2018 report, text with a `<left>` value of 27 and `<font>` type of 1 is consistently going to contain the country name. In most PDFs, particularly the older ones, this value will vary though the content will be the same.
 * Use the linear document structure, which is naturally ordered into Country, Program, Training item and values (e.g. Course name, US unit) as the basis of a nested XML structure.
 * Lint the XML output to show errors in the structure, and massage it until the linter stops flagging errors. This is mostly a matter of figuring out the logic of opening and closing tags, and finding where the particular PDF might break it. The lint will usually show the line numbers where the problem occurs, and the sort of error, giving us enough to fix it.
 * Use eXtensible Stylesheet Language Transformations (XSLT) to deduplicate training items. In some PDFs, the value for a particular row will go on over one or more columns, meaning that we have orphans. The process so far will capture this and correctly flag what the value is (e.g. location, or student unit). However, we want to merge these items so we can later export them into a flat format. A technique called "Muenchian Grouping" enables us to perform this deduplication at the correct level in the nested structure.
 * Flatten the XML and export the data in a flat, tab-separated format.
 * Post-process to standardize countries, dates and fix other issues that emerged during parsing and may be common to different chunks of data. For example, it makes sense to standardize dates and countries in bulk at this later stage. The variety of ways that a training location can be spelled in 20 years of data is huge, so it makes sense to reveal this and fix them all at once in bulk.

The toolset we used is `bash` on OSX:

 * Basic tools: `sed`, `awk`, `grep`, `tr`, `perl`
 * Additional tools: `pdftohtml`, `xmlstartlet`, `xmllint` (and  `csvkit` to write some helper scripts)

The approach is crude but (at least so far) effective as it dealt with a range of problems thrown up by the formatting of the PDFs. There are better ways to approach this problem, but these are the tools we knew. In retrospect, we would have done this with `python` and a bunch of specialised libraries. We would probably also make better use of `make` to chain together a replicable and predictable build process for the data.

### Project structure and operations

The `scrapers/` folder contains the source files, tools and steps used for each annual publication. In `group_and_clean/` there are tools to pull together the raw data extracted from each report, aggregate it, and then clean it up.  The final, aggregated and cleaned data is contained in the `data/` folder. 

```
.
├── README.md
├── data
│   └── final_fmtrpt_all_20190716.tsv
├── group_and_clean
│   ├── 0_get_data_files
│   ├── 1_pre_stack_clean
│   ├── 2_stack_em_up
│   └── 3_big_clean
└── scrapers 
    ├── fmtrpt_1999_2000
    ├── fmtrpt_2000_2001
    ├── fmtrpt_2001_2002
    ├── fmtrpt_2002_2003
    ├── fmtrpt_2003_2004
    ├── fmtrpt_2004_2005
    ├── fmtrpt_2005_2006
    ├── fmtrpt_2006_2007
    ├── fmtrpt_2007_2008
    ├── fmtrpt_2008_2009
    ├── fmtrpt_2009_2010
    ├── fmtrpt_2010_2011
    ├── fmtrpt_2011_2012
    ├── fmtrpt_2012_2013
    ├── fmtrpt_2013_2014
    ├── fmtrpt_2014_2015
    ├── fmtrpt_2015_2016
    ├── fmtrpt_2016_2017
    ├── fmtrpt_2017_2018
    └── fmtrpt_2018_2019

27 directories, 2 files
```
### Running the scrapers and getting the data out of the PDFs

Each annual report has its own scraper. In more detail, here's what the completed scraper process looks like for the report of the Fiscal Year 2017-2018:

```
scrapers/fmtrpt_2017_2018/
├── doc
├── input
│   └── 284930.pdf
├── notes
│   └── 2017_2018_process_notes.md
├── output
│   ├── 1_pdf_xml
│   │   ├── 2017_2018_Africa_fmtrpt.xml
│   │   ├── 2017_2018_East_Asia_and_Pacific_fmtrpt.xml
│   │   ├── 2017_2018_Europe_fmtrpt.xml
│   │   ├── 2017_2018_Near_East_fmtrpt.xml
│   │   ├── 2017_2018_South_Central_Asia_fmtrpt.xml
│   │   └── 2017_2018_Western_Hemisphere_fmtrpt.xml
│   ├── 2_xml_refine
│   │   ├── 2017_2018_Africa_fmtrpt_raw.xml
│   │   ├── 2017_2018_East_Asia_and_Pacific_fmtrpt_raw.xml
│   │   ├── 2017_2018_Europe_fmtrpt_raw.xml
│   │   ├── 2017_2018_Near_East_fmtrpt_raw.xml
│   │   ├── 2017_2018_South_Central_Asia_fmtrpt_raw.xml
│   │   └── 2017_2018_Western_Hemisphere_fmtrpt_raw.xml
│   ├── 3_xml_errors
│   │   ├── errors_2017_2018_Africa_fmtrpt.xml
│   │   ├── errors_2017_2018_East_Asia_and_Pacific_fmtrpt.xml
│   │   ├── errors_2017_2018_Europe_fmtrpt.xml
│   │   ├── errors_2017_2018_Near_East_fmtrpt.xml
│   │   ├── errors_2017_2018_South_Central_Asia_fmtrpt.xml
│   │   └── errors_2017_2018_Western_Hemisphere_fmtrpt.xml
│   ├── 4_xml_dedup
│   │   ├── 2017_2018_Africa_fmtrpt_dedup.xml
│   │   ├── 2017_2018_East_Asia_and_Pacific_fmtrpt_dedup.xml
│   │   ├── 2017_2018_Europe_fmtrpt_dedup.xml
│   │   ├── 2017_2018_Near_East_fmtrpt_dedup.xml
│   │   ├── 2017_2018_South_Central_Asia_fmtrpt_dedup.xml
│   │   └── 2017_2018_Western_Hemisphere_fmtrpt_dedup.xml
│   └── 5_xml_tsv
│       ├── 2017_2018_Africa_fmtrpt.tsv
│       ├── 2017_2018_East_Asia_and_Pacific_fmtrpt.tsv
│       ├── 2017_2018_Europe_fmtrpt.tsv
│       ├── 2017_2018_Near_East_fmtrpt.tsv
│       ├── 2017_2018_South_Central_Asia_fmtrpt.tsv
│       └── 2017_2018_Western_Hemisphere_fmtrpt.tsv
└── src
    ├── deduplicate_training_items.xsl
    ├── extractor_2017_2018_all_sections.sh
    └── fmtrpt_fy_2017_2018_sections

10 directories, 35 files
```

The scraper is `src/extractor_2017_2018_all_sections.sh`, which operates on `input/284930.pdf`. The file `src/fmtrpt_fy_2017_2018_sections` tells the scraper which file and page range to associate with data on which region (e.g. "Near East"). It works through a sequence of steps, the output of each is contained in `output/`:

 * `output/1_pdf_xml/` contains a verbose XML version of the PDF.
 * `output/2_xml_refine/` contains a simpler, cleaner XML of just the training items
 * `output/3_xml_errors/` contains the output of XML linting. When this passes, the script will move to the next steps.
 * `output/4_xml_dedup/` contains the output of an XSLT operation (contained in `src/deduplicate_training_items.xsl`)
 * `output/5_xml_tsv/` converts the clean, deduplicated XML to a flat, tab-separated, final output.

We've structured it this way to make the production process very transparent.

### Grouping and cleaning up the scraper outputs

After running all the scraper scripts and getting .tsv files into the `output/5_xml_tsv` folders of each scraper, the next step is to aggregate them. The toolset and process to do this is contained in `group_and_clean/`:

```
group_and_clean/
├── 0_get_data_files
├── 1_pre_stack_clean
├── 2_stack_em_up
└── 3_big_clean

4 directories, 0 files
```

Starting at `group_and_clean/0_get_data_files/` the outputs of each step form the input of the next. The relevant script is in the `src` directory in each step:

 * `0_get_data_files/` pull all the .tsv files from every `output/5_xml_tsv/` in the directory tree.  
 * `1_pre_stack_clean/` escapes all speech marks in all the files (which fixes a quoting/sniffing problem for the next step)
 * `2_stack_em_up/` aggregates all the .tsv files into a single .tsv.
 * `3_big_clean/` moves the aggregated .tsv through a number of transformations (cleaning, standardizing, filtering) to produce a superior output.

The file dropped in `group_and_clean/3_big_clean/output` can be copied to `data/` as the final outcome of the scraping and cleaning process.

### Publishing the data

Convert the data to `sqlite` (we used `csvsql`), and use [datasette](https://github.com/simonw/datasette) ([docs](https://datasette.readthedocs.io/en/stable/)) to publish the data online in a useful and highly functional way. Include the full text search and indexing functions outlined in the [documentation](https://datasette.readthedocs.io/en/stable/full_text_search.html). We have used Heroku to serve the data, routing to a subdomain of https://securityforcemonitor.org.

### A note on report structures

Since the first publication in 2000 the report has changed structure and content a number of times. Crude parsers like the ones we have written use the font size and positioning values to determine what field a particular piece of text should be placed in. These values change in each report format, but the changes can easily be seen inside the XML and changes made to the parser per those values. 

The current format ("E"), is the easiest to parse and was implemented for the FY2007-2008 report, and has remained broadly stable since then. Format "C", used between FY2000-2001 and FY 2005-2006 is more tricky.


|Report|Pattern|Format
|:--:|:--:|:--:
FY 2018-2019|E| PDF
FY 2017-2018|E| PDF
FY 2016-2017|E| PDF
FY 2015-2016|E| PDF
FY 2014-2015|E| PDF
FY 2013-2014|E| PDF
FY 2012-2013|E| PDF
FY 2011-2012|E| PDF
FY 2010-2011|E| PDF
FY 2009-2010|E| PDF
FY 2008-2009|E| PDF
FY 2007-2008|E| PDF
FY 2006-2007|D| HTML
FY 2005-2006|C| PDF
FY 2004-2005|C| PDF
FY 2003-2004|C| PDF
FY 2002-2003|C| PDF
FY 2001-2002|C| PDF
FY 2000-2001|B| PDF
FY 1999-2000|A| HTML
