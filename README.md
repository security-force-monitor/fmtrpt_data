# United States Foreign Military and Training Report: data extraction project

A dataset of over 250,000 unclassified training activities performed  by United States security forces for foreign (that is, non-US) forces beteween between 1999 and 2021, arranged and funded by the United States Department of State and Department of Defence. All sources, data scraping, cleaning and publishing tools are included.

Access the live data at: [https://trainingdata.securityforcemonitor.org](https://trainingdata.securityforcemonitor.org)

## 1. Overview

At Security Force Monitor we create data on organizational structure, command personnel, geographical footprint of police, military and other security forces. We connect this to information about human rights abuses, assisting human rights researchers, litigators and investigative journalists in their work to hold security forces to account. All our data is published on [WhoWasInCommand.com](https://whowasincommand.com). 

A key question we have is whether specific units and personnel implicated in human rights abuses have received training or assistance from the United States government. Whether the training or assistance was given prior to or after the unit's implication in a human rights abuse, it raises important questions about the effectiveness of the implementation of the "[Leahy laws](https://www.state.gov/key-topics-bureau-of-democracy-human-rights-and-labor/human-rights/leahy-law-fact-sheet/)", which are a vetting and due diligence processes in place to prevent this from happening. 

These questions can in part be answered by looking at the joint Department of State and Department of Defence report, "Foreign Military Training and DoD Engagement Activities of Interest". Released annually since 2000 (the 2000 report covered the U.S. government's fiscal year 1999-2000) this important, statutorily-mandated report shows in great detail how the US has spent much of its training and assistance budget, and with what aims. Generally, the US Department of State will release these reports as PDFs. They  can be found at the following locations online:

 * FY 2016-2017 to FY 2020-2021 and onwards are available here: [https://www.state.gov/foreign-military-training-and-dod-engagement-activities-of-interest/](https://www.state.gov/foreign-military-training-and-dod-engagement-activities-of-interest/)
 * FY 1999-2000 to FY 2015-2016: [https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/index.htm](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/index.htm)

Training activities that were completed in each fiscal year are recorded in `Volume I: Section IV` of the report, mostly in tabular form. For most years this data includes the name of the training course, the trainee unit, their country, the exact start and end date of the training, and so on. We include more detail on this below.

The value of the data is high, but its accessibility is low because of the way the data are published. To establish, for example, every training a single student unit had received since 1999, an analyst would have to manually search over 80 different PDFs.

This project addresses this challenge by providing clean, accurate and standardized machine-readable copy of all the data contained in the reports. We also aim to provide a simple and effective way for anyone to search the data and retrieve it in a standard, easy to use format. Importantly, we also show how the data were created and processed, keeping a direct link between the original report and the data. We also wanted to create a way to quickly update and analyse the dataset with each new release from the Department of State.

There is an existing dataset created by [Center for International Policy's excellent Security Assistance Monitor (SAM) team](https://securityassistance.org/foreign-military-training/). The platform they have created gives a great way to explore the dataset, setting out spending and delivery trends really clearly. For our needs, there are two limitations to this dataset and platform. First, though SAM have included the fiscal year in which a training was carried out, they have not included the data on start date and end date of every training, which are critical to our specific research aims. Second, at the time we initiated this project in 2019 the detailed dataset ended at FY 2015-2016 and we were unclear whether SAM had future plans to revisit and extend the data. Unfortunately, it was easier to start from scratch than to attempt to extend this existing work, hence this project. The ideal future situation, of course, is that the DoD/DoS would release this important data in a machine readable form in the first place so no parsing was necessary. We live in hope!

Longer term, our aim is to extend this dataset to include non-US security assistance and training, including that provided bilaterally by governments, and by international organizations like the United Nations and the European Union. We also intend to integrate this dataset with the information on our  WhoWasinCommand.com platform, which will give our community even greater insight into who has provided support to the security forces they are researching.

## 2. Data and data model

The final dataset is comprised of the fields described in the table below. The fieldnames were updated in November 2024 to include data on page numbers and a set of more precise source and citation identifiers.

Field|Description|Example of use|
|:--:|:--|:--|
|`training:id:admin`|Unique code for each training item in the dataset, which enables referencing.|"6077cea5-e571-4fa9-b2aa-f0ead4d34760"|
|`training:country`|Country of training recipient, as printed in the report (with a few typo corrections)|"Cote d'Ivoire"|
|`qa:training_country_iso_3166_1`|ISO-3166-1 standard code for country of training recipient.|"CIV"|
|`training:program`|The DoD/DoS program that authorised and financed the training. |"East Asia and Pacific Region, Thailand, International Military Education and Training (IMET), FY01"|
|`training:course_title`|Name of training course. |"HOT SHIP XFER 180 FT PAC"|
|`training:delivery_unit`|Where included, the United States security force unit(s) involved in delivery of the training course.|"1/10 SFG, 7 SOS"|
|`training:recipient_unit`|Where included, the name of recipient(s) of training course.|"SPECIAL SERVICES GROUP NAVY, ST-3 PLT F, SBU-12 RIB DET N, SDVT-1 TU BAHRAINI NAVY"|
|`training_start_date`|Start date of training as stated in the source (mostly in the format `m-dd-yy`).|"1/16/01"|
|`qa:training_start_date_clean`|Start date of training, reformatted into the international ISO 8601 standard (`YYYY-MM-DD`)|"2001-01-16"|
|`training_end_date`|End date of training as stated in the source (mostly `m-dd-yy`)|"1/31/01"|
|`qa:training_end_date_clean`|End date of training, reformatted into the international ISO 8601 standard (`YYYY-MM-DD`)|"2001-01-31"|
|`training:location`|Where included, the place where the training was held.|"LACKLAND AFB, TX 78236"|
|`training:quantity`|The number of trainees on the course.|"30"|
|`training:total_cost`|The total cost of that specific training in United States Dollars.|"8000"|
|`training:page_number`|Where available, the page number from which the row of data was extracted from the original report. Prefixes such as section numerals ("IV-") were removed. Explicit report page number often differs from PDF page number because reports are often published in multiple PDFs where the report page number continues to increase but the PDF page resets to 1. |"203"|
|`training:date_first_seen:admin`|Date that row of data was first made available publicly (`YYYY-MM-DD`, or parts thereof).|"2002-03-"|
|`training:date_scraped:admin`|Date that row of data was obtained and scraped, or re-scraped, by Security Force Monitor to create this dataset (`YYYY-MM-DD`).|"2019-07-17"|
|`training:status:admin`|Indicates whether the row has been hand checked against the source, which in nearly all cases it has not.|"Not checked against source; verify accuracy before use"|
|`training:source_at_publication_level:admin`|Unique code used by SFM to identify source publication from which the row of data was extracted. Other columns provide a unqiue code for both the volume and the specific page inside the publication from which the row of data was extracted. |"048fb2d9-6651-4ba0-b36a-a526539f4cfd"|
|`training:source_at_volume_section_level:admin`|Unique code used by SFM to identify the specific section (or volume) of the source publication from which the row of data was extracted.|"2c626217-cd72-47b1-bffd-8001bf070bf8"|
|`qa:training_group`|The file containing the raw data scraped from the original reports. This is used by SFM for organising the dataset, and tracking down any problems with it.|"2001\_2002\_Africa_fmtrpt.tsv"|
|`qa:training_source_url`|The URL of the specific PDF or web-page from which the row of data is extracted. This is included as a helper and debug column for SFM, and as a convenience to data users. |"https://2009-2017.state.gov/documents/organization/10967.pdf"|
|`training:citation_id:admin`|Unique code used by SFM to identify the specific publication, volume or section, and page from which the row of data was extracted.|`9dbae1d9-ac3d-4b2a-a4d0-d04eb5d302ba`|
|`training:source_title_with_volume_section:admin`|Readable identifier describing the publication and volume or section from which the row of data was extracted.|"Foreign Military Training and DoD Engagement Activities of Interest, 2007-2008, Volume I - Section IV. Country Training Activities - I. Africa Region"|

Fields prefixed with `qa` are "quality assurance" fields - these include helper or debugging fields, and clean or standardised version of other fields. For example `training:start_date` contains verbatim the date included in the reports, usually in month-day-year ("1/1/1999"), the format most common to the United States - the field `qa:training_start_date_clean` is a version of that date in the international format year-month-day ("1999-01-01"). The field `qa:training_group` tells the name of the file that contains the raw data for that row, so we can go back and look at it if there any problems. Fields that end with `:admin` contain data about the data which we have created to administer the dataset. These fields including unique identifiers (like `training:id:admin` or `training:citation_id:admin`, which identify the specific training itself, and the specific report, section and page the data was scraped from) and data about the processing history or state of the dataset (such as `training:data_scraped:admin`, which tells us when we scraped that row of data).

For the November 2024 update, we went back and rescraped everything to obtain the page numbers for each row of data. This created a huge improvement in provenance and integrity in such a large dataset by giving users of the data the ability to go back quickly to the exact place in a source document where the original data are found. It also enables us to provide more precise subsets of data: all the data from a specific page, and section or volume, rather than just the overall publication itself.

## 3. Data sources and coverage

In the table below we provide an overview of the available source materials, where to get them, what data are contained within them, and whether we have included the material in the dataset. The 1999 and 2000 editions were not published with core data like the participant units, or training data, but we have included them for the sake of completion. Otherwise, with the exception of a four year streak where data in the `US unit` field was not included in the data, the field coverage is consistent year on year.

||Source (Vol. 1 - Training Activities)|Included in dataset?|Country|DOD/DOS Program|Course Title|US Unit|Student Unit|Start date|End date|Location|Quantity|Total Cost|Page number|
|:---:|:--:|:--:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|[FY 2020-2021](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2020-2021/)|PDF: <strike>All</strike>, [A](https://www.state.gov/wp-content/uploads/2022/03/10-Volume-I-Section-IV-Part-IV-I-Africa.pdf), [EAP](https://www.state.gov/wp-content/uploads/2022/03/11-Volume-I-Section-IV-Part-IV-II-East-Asia-and-Pacific.pdf),[E](https://www.state.gov/wp-content/uploads/2022/03/12-Volume-I-Section-IV-Part-IV-III-Europe.pdf), [NE](https://www.state.gov/wp-content/uploads/2022/03/13-Volume-I-Section-IV-Part-IV-IV-Near-East.pdf), [SCA](https://www.state.gov/wp-content/uploads/2022/03/14-Volume-I-Section-IV-Part-IV-V-South-Central-Asia.pdf), [WH](https://www.state.gov/wp-content/uploads/2022/03/15-Volume-I-Section-IV-Part-IV-VI-Western-Hemisphere.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2019-2020](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2019-2020/)|PDF: [All](https://www.state.gov/wp-content/uploads/2021/08/Volume-I-508-Compliant.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2018-2019](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/12/FMT_Volume-I_FY2018_2019.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2017-2018](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2017-2018/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/04/fmt_vol1_17_18.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2016-2017](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2016-2017/)|PDF: [All](https://www.state.gov/wp-content/uploads/2019/04/fmt_vol1_16_17.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2015-2016](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2016/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/265162.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2014-2015](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm)|PDF: [All](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2015/index.htm), [A](https://2009-2017.state.gov/documents/organization/243021.pdf), [EAP](https://2009-2017.state.gov/documents/organization/243030.pdf),[E](https://2009-2017.state.gov/documents/organization/243031.pdf), [NE](https://2009-2017.state.gov/documents/organization/243032.pdf), [SCA](https://2009-2017.state.gov/documents/organization/243033.pdf), [WH](https://2009-2017.state.gov/documents/organization/243034.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2013-2014](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2014/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/230192.pdf), [A](https://2009-2017.state.gov/documents/organization/230209.pdf), [EAP](https://2009-2017.state.gov/documents/organization/230211.pdf), [E](https://2009-2017.state.gov/documents/organization/230213.pdf), [NE](https://2009-2017.state.gov/documents/organization/230215.pdf), [SCA](https://2009-2017.state.gov/documents/organization/230217.pdf), [WH](https://2009-2017.state.gov/documents/organization/230219.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2012-2013](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2013/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/213444.pdf), [A](https://2009-2017.state.gov/documents/organization/213460.pdf), [EAP](https://2009-2017.state.gov/documents/organization/213462.pdf), [E](https://2009-2017.state.gov/documents/organization/213464.pdf), [NE](https://2009-2017.state.gov/documents/organization/213466.pdf), [SCA](https://2009-2017.state.gov/documents/organization/213468.pdf), [WH](https://2009-2017.state.gov/documents/organization/213470.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2011-2012](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2012/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/197595.pdf), [A](https://2009-2017.state.gov/documents/organization/197610.pdf), [EAP](https://2009-2017.state.gov/documents/organization/197611.pdf), [E](https://2009-2017.state.gov/documents/organization/197612.pdf), [NE](https://2009-2017.state.gov/documents/organization/197613.pdf), [SCA](https://2009-2017.state.gov/documents/organization/197614.pdf), [WH](https://2009-2017.state.gov/documents/organization/197615.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2010-2011](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2011/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/171494.pdf), [A](https://2009-2017.state.gov/documents/organization/171509.pdf), [EAP](https://2009-2017.state.gov/documents/organization/171510.pdf), [E](https://2009-2017.state.gov/documents/organization/171511.pdf), [NE](https://2009-2017.state.gov/documents/organization/171512.pdf), [SCA](https://2009-2017.state.gov/documents/organization/171513.pdf), [WH](https://2009-2017.state.gov/documents/organization/171514.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|✓|
|[FY 2009-2010](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2010/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/155982.pdf), [A](https://2009-2017.state.gov/documents/organization/155997.pdf), [EAP](https://2009-2017.state.gov/documents/organization/155998.pdf), [E](https://2009-2017.state.gov/documents/organization/155999.pdf), [NE](https://2009-2017.state.gov/documents/organization/156000.pdf), [SCA](https://2009-2017.state.gov/documents/organization/156001.pdf), [WH](https://2009-2017.state.gov/documents/organization/156002.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|✓|
|[FY 2008-2009](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2009/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/152778.pdf), [A](https://2009-2017.state.gov/documents/organization/152766.pdf), [EAP](https://2009-2017.state.gov/documents/organization/152767.pdf), [E](https://2009-2017.state.gov/documents/organization/152768.pdf), [NE](https://2009-2017.state.gov/documents/organization/152770.pdf), [SCA](https://2009-2017.state.gov/documents/organization/152773.pdf), [WH](https://2009-2017.state.gov/documents/organization/152774.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|✓|
|[FY 2007-2008](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2008/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/126573.pdf), [EAP](https://2009-2017.state.gov/documents/organization/126574.pdf), [E](https://2009-2017.state.gov/documents/organization/126575.pdf), [NE](https://2009-2017.state.gov/documents/organization/126576.pdf), [SCA](https://2009-2017.state.gov/documents/organization/126577.pdf), [WH](https://2009-2017.state.gov/documents/organization/126578.pdf)|Yes|✓|✓|✓|✗|✓|✓|✓|✓|✓|✓|✓|
|[FY 2006-2007](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/index.htm)|HTML: <strike>All</strike>, [A](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92084.htm), [EAP](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92085.htm), [E](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92086.htm), [NE](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92087.htm), [SCA](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92088.htm), [WH](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2007/92089.htm)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✗|
|[FY 2005-2006](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2006/index.htm)|PDF: [All](https://2009-2017.state.gov/documents/organization/75058.pdf), [A](https://2009-2017.state.gov/documents/organization/74795.pdf), [EAP](https://2009-2017.state.gov/documents/organization/74796.pdf), [E](https://2009-2017.state.gov/documents/organization/74797.pdf), [NE](https://2009-2017.state.gov/documents/organization/74798.pdf), [SA](https://2009-2017.state.gov/documents/organization/74799.pdf), [WH](https://2009-2017.state.gov/documents/organization/74800.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2004-2005](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2005/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/45785.pdf), [EAP](https://2009-2017.state.gov/documents/organization/45787.pdf), [E](https://2009-2017.state.gov/documents/organization/45788.pdf), [NE](https://2009-2017.state.gov/documents/organization/45789.pdf), [SA](https://2009-2017.state.gov/documents/organization/45791.pdf), [WH](https://2009-2017.state.gov/documents/organization/45793.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2003-2004](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2004/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/34329.pdf), [EAP](https://2009-2017.state.gov/documents/organization/34330.pdf), [E](https://2009-2017.state.gov/documents/organization/34331.pdf), [NE](https://2009-2017.state.gov/documents/organization/34334.pdf), [NIS](https://2009-2017.state.gov/documents/organization/34336.pdf) [SA](https://2009-2017.state.gov/documents/organization/34337.pdf), [WH](https://2009-2017.state.gov/documents/organization/34338.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2002-2003](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2003/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/21817.pdf), [EAP](https://2009-2017.state.gov/documents/organization/21818.pdf), [E](https://2009-2017.state.gov/documents/organization/21819.pdf), [NE](https://2009-2017.state.gov/documents/organization/21820.pdf), [NIS](https://2009-2017.state.gov/documents/organization/21821.pdf), [SA](https://2009-2017.state.gov/documents/organization/21822.pdf), [WH](https://2009-2017.state.gov/documents/organization/21823.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2001-2002](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2002/index.htm)|PDF: <strike>All</strike>, [A](https://2009-2017.state.gov/documents/organization/10964.pdf), [EAP](https://2009-2017.state.gov/documents/organization/10965.pdf), [E](https://2009-2017.state.gov/documents/organization/10966.pdf), [NE](https://2009-2017.state.gov/documents/organization/10967.pdf), [NIS](https://2009-2017.state.gov/documents/organization/10968.pdf), [SA](https://2009-2017.state.gov/documents/organization/10969.pdf), [WH](https://2009-2017.state.gov/documents/organization/10970.pdf)|Yes|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|✓|
|[FY 2000-2001](https://2009-2017.state.gov/t/pm/rls/rpt/fmtrpt/2001/index.htm)|PDF: <strike>All</strike>, [A + EAP](https://2009-2017.state.gov/documents/organization/3164.pdf), [E + NE + NIS](https://2009-2017.state.gov/documents/organization/3165.pdf), [SCA + WH](https://2009-2017.state.gov/documents/organization/3166.pdf)|Yes|✓|✓|✓|✗|✗|✗|✗|✗|✓|✓|✓|
|[FY 1999-2000](https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html)\*|HTML: <strike>All</strike>, A [1](https://web.archive.org/web/20170601013645/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_a2gam.html) [2](https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_gha2rwa.html) [3](https://web.archive.org/web/20170105062147/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_af_sao2zim.html), EAP [1](https://web.archive.org/web/20170105154743/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eap_aust2papua.html) [2](https://web.archive.org/web/20170106050009/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eap_phil2viet.html), E [1](https://web.archive.org/web/20170106050500/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eur_alb2est.html) [2](https://web.archive.org/web/20170106054830/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_eur_latv2switz.html), NE [1](https://web.archive.org/web/20170106061730/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nea_alg2eg.html) [2](https://web.archive.org/web/20170106062351/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nea_ir2ye.html) NIS [1](https://web.archive.org/web/20170106062400/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_nis_all.html), SA [1](https://web.archive.org/web/20170106062410/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_sasia_all.html), WH [1](https://web.archive.org/web/20170106062413/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_a2ch.html) [2](https://web.archive.org/web/20170106062415/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_col2ecua.html) [3](https://web.archive.org/web/20170106062417/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_el2jama.html) [3](https://web.archive.org/web/20170106062419/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_mex2peru.html) [4](https://web.archive.org/web/20170106062422/https://1997-2001.state.gov/www/global/arms/fmtrain/cta_wha_stk2ven.html)|Yes|✓|✓|✓|✗|✗|✗|✗|✗|✓|✓|✗|

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

### 2020-2021 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2020-2021/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2020-2021/)

Date from the 2020-2021 report are included in the dataset. The 2020-2021 report is published on the State Department website in separate PDFs corresponding to the regional groupings commonly in use in this publication.

### 2019-2020 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2019-2020/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2019-2020/)

Data from the 2019-2020 report are included in the dataset. The 2019-2020 report is published on the State Department website as a single PDF file. 

Page 101 of the PDF initally published in August 2021 is corrupted and contains an empty table where the conclusion of the year's report of training activities in Angola ends and those in Benin begins. We have removed both Angola and Benin from the dataset until this is fixed (as at November 2024, it is not fixed).

### 2018-2019 report

Report home page: [https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/](https://www.state.gov/reports/foreign-military-training-and-dod-engagement-activities-of-interest-2018-2019/)

Data from the 2018-2019 report are included in the dataset. The 2019-2020 report is published on the State Department website as a single PDF file.

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

Data from the 2006-2007 report are included in the dataset. The 2006-2007 report is available in the 2009-2017 archives of the State Department website, and is published only as a set of HTML pages. The data we have extracted from this report does not have page numbers, but we have included in each row extracted and identifier for the specific HTML page instead.

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

Data from the 2000-2001 report was included in the dataset in November 2021. The 2001-2001 report is available in the 2009-2017 archives of the State Department website, and is available as a PDF. The 2000-2001 report does not contain the name of the US unit and the student unit, the location, start date or end date of the training. Accordingly, we did not originally in 2019 parse out this report for inclusion in the dataset, but included it in our November 2024 update.

### 1999-2000 report 

Report home page (Internet Archive only): [https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html](https://web.archive.org/web/20170322193536/https://2009-2017.state.gov/www/global/arms/fmtrain/toc.html)

Data from the 1999-2000 report is included in the dataset.The 1999-2000 report is available in the 2009-2017 archives of the State Department website, and is only available from an official source in HTML format. This report does not contain the name of the US unit and the student unit, the location, start date or end date of the training. Accordingly, we did not originally in 2019 parse out this report for inclusion in the dataset, but included it in our November 2024 update. The data we have extracted from this report does not have page numbers, but we have included in each row extracted and identifier for the specific HTML page instead.

## 5. Technical

### General approach to extraction and cleaning

All the PDFs published by the Department of State contain tabular data, with some variances in content structure and appearance. All the PDFs have been generated directly from another program - likely MS Word - rather than scanned in and processed using Optical Character Recognition (OCR) software.

We sought to extract this data in a replicable, programmatic way rather than cut-and-paste our way through the tables once.  The reports are mostly in a tabular structure, ordered by country of the  units that are receiving the training from the US forces, and the program through which the Department of State or Department of Defence made the expenditure. The available data fields are mostly the same across the publications released to date. The key differences are in the formatting and layout: there are five different formats across the publication set, but two formats cover the majority of the publications. There are, however, small variations even in the same formats and individual documents, which present some challenges to creating an automated extraction process (see below on report structures).

We have taken the below approach to extracting and parsing data from these reports:

 * Establish the page ranges in a PDF or group of PDFs that contain different sections of data (e.g. Africa, Europe, etc) and use that information to structure the overall parsing process and its outputs.
 * Convert the PDF files to very verbose XML that pulls out every table item or paragraph into a separate row containing detailed paragraph positioning and font-sizing.
 * Filter out anything that isn't in the tables and use the `left` right positioning and `font-size` variables to determine what the content on that row is. For example, in the 2017-2018 report, text with a `<left>` value of 27 and `<font>` type of 1 is consistently going to contain the name of the country. In most PDFs, particularly the older ones, this value will vary even though the content will be the same.
 * Use the linear document structure, which is naturally ordered into Country, Program, Training item and values (e.g. Course name, US unit) as the basis of a nested XML structure.
 * Test or [lint](https://en.wikipedia.org/wiki/Lint_(software)) the XML output to show errors in the structure, and massage the XML until the linter stops flagging errors. This is mostly a matter of figuring out the logic of the XML's opening and closing tags, and finding where the content of a specific PDF might break it. The linter will usually show the line numbers where the problem occurs, and the sort of error, giving us enough information to fix it.
 * Use eXtensible Stylesheet Language Transformations (XSLT) to deduplicate training items. In some PDFs the value for a particular row will go on over one or more columns, which creates incomplete and orhpaned values. The processing workflow captures this and correctly flags what the value is (e.g. location, or student unit). However, we want to merge these items so we can later export them into a flat format as a single value. A technique called [Muenchian Grouping](https://www.jenitennison.com/xslt/grouping/muenchian.xml) enables us to perform this deduplication process at the correct level within the nested XML structure.
 * Flatten the XML and export the data in a flat, tab-separated format.
 * Post-process to standardize countries, dates and fix other issues that emerged during parsing. 
 * Add metadata such as unique identifiers, information about sourcing for each row of data, and other hooks that make the data easier to use and manage.

The toolset is created in `bash` and operated entirely within a terminal environment:

 * Basic tools: `sed`, `awk`, `grep`, `tr`, `perl`
 * Additional tools: `ghostscript`, `pdftohtml`, `xmlstartlet`, `xmllint`, `csvkit` and `xsv`. I have also found VisiData (`vd`) extremely helpful. 

The approach I have taken	is really mechanical, uses quite "old school" tooking, and contains a huge amount of structure and micro-control over process - it's definitely not to everyone's taste! The organising concept is inspired by Dr Patrick Ball's article [The Task is a Quantum of Workflow](https://hrdag.org/2016/06/14/the-task-is-a-quantum-of-workflow/), which emphasises the value of creating a sequence of distinct, one-step processes the purpose of which is immediately obvious. At least so far, it has been effective in dealing with the wide range of problems  thrown up by the formatting of the PDFs, which can be infuriatingly fiddly. There may of course be better ways to approach this problem, but for now It Does The Job!

### Overall project structure and operations in more detail

The overall project is structured like this:

```
.
├── LICENSE.md
├── README.md
├── data
│   ├── fmtrpt_all_data
│   └── fmtrpt_data_by_report
├── publish
│   ├── input
│   └── src
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
    ├── fmtrpt_2018_2019
    ├── fmtrpt_2019_2020
    ├── fmtrpt_2020_2021
    └── fmtrpt_tools

31 directories, 2 files

```

The `scrapers/` folder contains self-contained sub-projects for extracting data from each annual publication. The reason for this is that although the overall extraction workflow is similar for each report, the PDFs released each year contain considerable variation in the configuration, exceptions and cleaning requirements. In November 2024, we integrated the cleaning workflow into the sub-projects for each year, rather than have them as a standalone toolset (as was the case up until then). 

The final, aggregated and cleaned data is contained in the `data/` folder, both in a single file and split by year. The `publish/` folder contains scripts to convert the data into a `sqlite` database, which can be published online using a tool called `datasette`.

### Running the scrapers to get the data out of the PDFs

For each annual report, we have created a distinct scraper workflow and toolset, housed in the sub-project. I'll run through the structure of the sub-project built to extract data from the report for the Fiscal Year 2000-2001. These PDFs are much older, cranky and more exception-ridden. They also have two columns (which most don't) and are  missing key data attributes such as the recipient unit, and the start and end dates of each training. However, these quirks make this a more interesting example of how the data extraction process works. Here's the top level folder structure for the 2000-2001 report:

```
fmtrpt_2000_2001
├── 1_scrape_extract
├── 2_clean_structure
├── 3_final_dataset
└── notes_on_2000_2001_fmtrpt.md

4 directories, 1 file

```
The scraping and parsing process is task-based (it should be clear what each step does), linear (the output of one step is the input of another) and verbose (there's a data output at each stage, so we can see what the step does). It makes extensive use of the file system to describe the structure and manage the workflow. The sub-project is further sub-divided as below:

- `1_scrape_extract`: extracts data from the PDFs into TSV outputs. The final output of this step is six or seven separate TSVs containing the data about each geographical region included in the report.
- `2_clean_structure`: in this part of the workflow, we group the raw data extracts together, clean them up, restructure them, add unique identifiers and citation information. We can also compare them to earlier runs of the scraper to see what has changed.
- `3_final_dataset`: a place where the final data is stored.
- `notes_on_2000_20001.md`: a Markdown file where we record useful observations about the scraping processing.

#### Step 1: Scrape and Extract

Let's look closely at what is contained in `1_scrape_extract/` folder for the 2000-2001 report sub-project:

```
fmtrpt_2000_2001/1_scrape_extract
├── input
│   ├── 3164.pdf
│   ├── 3165.pdf
│   └── 3166.pdf
├── notes
│   ├── country_program_list.tsv
│   └── helpers_understand_program_titles.sh
├── output
│   └── 202407121057
│       ├── 0_pdf_slice
│       ├── 1_pdf_xml
│       │   ├── 2000_2001_Africa_fmtrpt.xml
│       │   ├── 2000_2001_East_Asia_and_Pacific_fmtrpt.xml
│       │   ├── 2000_2001_Europe_fmtrpt.xml
│       │   ├── 2000_2001_Near_East_fmtrpt.xml
│       │   ├── 2000_2001_Newly_Independent_States_fmtrpt.xml
│       │   ├── 2000_2001_South_Asia_Region_fmtrpt.xml
│       │   └── 2000_2001_Western_Hemisphere_Region_fmtrpt.xml
│       ├── 2_xml_refine
│       │   ├── 2000_2001_Africa_fmtrpt_raw.xml
│       │   ├── 2000_2001_East_Asia_and_Pacific_fmtrpt_raw.xml
│       │   ├── 2000_2001_Europe_fmtrpt_raw.xml
│       │   ├── 2000_2001_Near_East_fmtrpt_raw.xml
│       │   ├── 2000_2001_Newly_Independent_States_fmtrpt_raw.xml
│       │   ├── 2000_2001_South_Asia_Region_fmtrpt_raw.xml
│       │   └── 2000_2001_Western_Hemisphere_Region_fmtrpt_raw.xml
│       ├── 3_xml_errors
│       │   ├── errors_2000_2001_Africa_fmtrpt.xml
│       │   ├── errors_2000_2001_East_Asia_and_Pacific_fmtrpt.xml
│       │   ├── errors_2000_2001_Europe_fmtrpt.xml
│       │   ├── errors_2000_2001_Near_East_fmtrpt.xml
│       │   ├── errors_2000_2001_Newly_Independent_States_fmtrpt.xml
│       │   ├── errors_2000_2001_South_Asia_Region_fmtrpt.xml
│       │   └── errors_2000_2001_Western_Hemisphere_Region_fmtrpt.xml
│       ├── 4_xml_dedup
│       │   ├── 2000_2001_Africa_fmtrpt_dedup.xml
│       │   ├── 2000_2001_East_Asia_and_Pacific_fmtrpt_dedup.xml
│       │   ├── 2000_2001_Europe_fmtrpt_dedup.xml
│       │   ├── 2000_2001_Near_East_fmtrpt_dedup.xml
│       │   ├── 2000_2001_Newly_Independent_States_fmtrpt_dedup.xml
│       │   ├── 2000_2001_South_Asia_Region_fmtrpt_dedup.xml
│       │   └── 2000_2001_Western_Hemisphere_Region_fmtrpt_dedup.xml
│       └── 5_xml_tsv
│           ├── 2000_2001_Africa_fmtrpt.tsv
│           ├── 2000_2001_East_Asia_and_Pacific_fmtrpt.tsv
│           ├── 2000_2001_Europe_fmtrpt.tsv
│           ├── 2000_2001_Near_East_fmtrpt.tsv
│           ├── 2000_2001_Newly_Independent_States_fmtrpt.tsv
│           ├── 2000_2001_South_Asia_Region_fmtrpt.tsv
│           └── 2000_2001_Western_Hemisphere_Region_fmtrpt.tsv
└── src
    ├── deduplicate_training_items.xsl
    ├── extractor_2000_2001_group_1.sh
    ├── extractor_2000_2001_group_2.sh
    ├── sections_2000_2001_group_1
    └── sections_2000_2001_group_2

12 directories, 45 files
```

The set of steps here describe the linear workflow that moves data from inside the PDFs of the 2000-2001 report to a tabular output in TSV format: 

- `input`: contains the original PDFs published by the Department of State. In this case there are three PDFs but for more recent publications the publciation is either in a single PDF or broken up by "region" (one PDF for Africa, one PDF for Europe, and so on).
- `src`: contains  extractor scripts (files ending `.sh`), along with set of configuration files. In this case, we have two scripts: `extractor_2000_2001_group_1.sh` and `extractor_2000_2001_group_2.sh` with corresponding config files. The reason for this is that in these input PDFs, the formatting of the section on Africa (in `input/3164.pdf`) is very different than the remaining sections, for reasons I can't fathom. So in this case we just create a separate scraper, but integrate its output into the common `output` directories.
- `output`: holds the output of the five main processing routines in the extraction files, in sequence, and by "run" identifier.  

The first thing to do is set the basic flow control variables for each report section (Africa, Western Hemisphere, etc). For the 2000-2001 scraper these configuration variables are set in `src/sections_2000_2001_group_1` (covering just Africa) and `src/sections_2000_2001_group_2` (covering the remainder of the sections). These files contain space-separated data about each section, telling the extract script(s) where to find source files, the page ranges for particular datasets, and what to call outputs:

```
3164 2000_2001 East_Asia_and_Pacific 20 32 20 32 202407121057
3165 2000_2001 Europe 1 15 33 47 202407121057
3165 2000_2001 Near_East 15 32 47 64 202407121057
3165 2000_2001 Newly_Independent_States 32 39 64 71 202407121057
3166 2000_2001 South_Asia_Region 1 4 72 75 202407121057
3166 2000_2001 Western_Hemisphere_Region 4 37 75 108 202407121057
```
From left to right, space-separated, these correspond to:

 - the file in which we find the data, without file extension: `3164`.
 - the fiscal year of the report: `2000_2001`.
 - the report section or region name: `Africa`.
 - the PDF page number where data for this region begins: `20`.
 - the PDF page number where data for this region ends: `32`.
 - the page number as stated in the report where data for this region starts: `20`.
 - The page number as stated in the report where data for this region ends: `32`.
 - the "run" identifier, as a timestamp, used to group outputs done at different times: `202402071355`.

In this configuration, you can see that the the PDF page numbers and the report page numbering begin to diverge. So the data for Europe are found on pages 1 to 15 of the file `input/3165.pdf` but the actual page numbering in the report is 33-47. The way to get these configuation variables is just to eyeball the PDFs.

The "run" variable was added for the November 2024 edition to allow for different scrapes of the data to co-exist, and act as an audit and integrity measure. In the 2000-2001 scraper, there is only one "run" in `202407121057`, because it's the first time we extracted this data. However, in the 2019-2020 sub-project, you can see there are two "runs" from 2021 and 2024: `202108131700` and `202402071355`.

With the flow control variables in place, we can now use the extraction script. The script, written in `bash` is controlled from the `_main` function, which sits at the end of the script. The main sub-routines are outlined in the table below:

Sequence|Function name|Input location|Output location|What it does|
|:---:|:---:|:---:|:---:|:---:|
|Control|`_main`|N/A|N/A|Overall script control function, also ingests flow control variables from configuration files.|
|Helper|`_progMsg`|User specified text|Terminal|A user defined message that says what is going on, inserted at the relevant part in the workflow.|
|Helper|`_setupOutputFolders`|N/A|File system|Where they don't exist, create the output folder structure for a particular run.|
|0|`_extractPages`|PDFs in `input/`|`output/202407121057/0_pdf_slice`|Extract page range of larger PDF into separate PDF using Ghostscipt.  |
|1|`_xmlConvert`|PDFs in `output/202407121057/0_pdf_slice`|`output/202407121057/1_pdf_xml`|Convert PDFs into verbose XML using `pdftohtml`|
|0 & 1|`_extractPagesXMLConvert`|PDFs in `input/`|`output/202407121057/1_pdf_xml`|Skip step 0, avoiding Ghostscript, and use `pdftohtml` to operate on original input PDF. Sometimes working on Ghostscipt output is cleaner; other times it's not.|
|2|`_cleanXML`|XML files in `output/202407121057/1_pdf_xml`|XML files in `output/202407121057/2_xml_refine`|Work through sequence of steps (`_firstFixes`, `_trimLeadingTrailingItems`, `_cleanProgramTitle`, etc) that use a combination of tools to tranform the verbose line-based XML into a nested XML version of the same data.|
|3|`_errorCheckXML`|XML files in `output/202407121057/2_xml_refine`|`output/202407121057/3_xml_errors`|Analyse cleaned data using `xmllint`, flagging structural/nesting errors which tell us that the `_cleanXML` subroutine isn't yet working. When `_errorCheckXML` produces a file output, the data are  structured correctly, otherwise read and act on the terminal errors.|
|4|`_deduplicateXML`|XML files in `output/202407121057/3_xml_errors`|XML files to `output/202407121057/4_xml_dedup`|Uses `xmlstarlet` (`xml`) to execute an Extensible Stylesheet Language Transformation (XSLT) (outlined in `src/deduplicate_training_items.xsl`) which groups attributes inside each training item and re-groups the dataset by country and program name.|
|5|`_generateOutput`|XML files in `output/202407121057/4_xml_dedup`|XML files in `output/202407121057/5_xml_tsv`|Uses `xmlstarlet` (`xml`) to transforms deduplicated XML into a single flat TSV output for that section/region's data.|

The aim is to get to the point where the process works cleanly from `0` or `1` through to `5`. Most of your time will be spent massaging the various cleanup steps in `_cleanXML` to export cleanly and structured data: the linter in the `_errorCheckXML` step is unforgiving! 

Let's dive into what `_cleanXML` does in this script. The `_cleanXML` subroutine is made up of a set of sequential steps all of which solve a specific problem in turning the raw, verbose XML taken from the PDFs into nested XML that we can process effectively. Here's the function:

```
_cleanXML () {

	cat output/"${r}"/1_pdf_xml/"${y}_${t}_fmtrpt.xml" \
		| _firstFixes \
		| _trimLeadingTrailingItems \
		| _composeProgramTitle \
		| _cleanProgramTitle \
		| _filterOutUselessLines \
		| _assignTrainingAttributes \
		| _filterOutNonText \
		| _addTrainingTagsToProgram \
		| _splitLines \
		| _wrapPageTags \
		| _assignPageNumbers \
		| _removeOldPageTags \
		| _massageXMLStructure \
		| _finaliseXMLStructure \
		| _closingFixes \
	> output/"${r}"/2_xml_refine/"${y}_${t}_fmtrpt_raw.xml"
}
```

What sort of input does `_cleanXML` take? The PDFs are tables accompanied by non-tabular metadata. For example, here's the first 41 lines of the raw XML for the Africa section of `input/3154.pdf`. It contains the document type and some metadata, and the line and column positioning of every item in the PDF table.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pdf2xml SYSTEM "pdf2xml.dtd">

<pdf2xml producer="poppler" version="24.04.0">
<page number="1" position="absolute" top="0" left="0" height="1188" width="918">
	<fontspec id="0" size="15" family="Times" color="#000000"/>
	<fontspec id="1" size="12" family="Times" color="#000000"/>
	<fontspec id="2" size="12" family="Times" color="#000000"/>
<text top="1120" left="455" width="7" height="13" font="0">1</text>
<text top="100" left="87" width="224" height="11" font="1"> <b>IV.  COUNTRY TRAINING ACTIVITIES</b></text>
<text top="114" left="87" width="259" height="11" font="2"><b>Africa Region, Angola, Africa Center for Strategic</b></text>
<text top="128" left="87" width="74" height="11" font="2"><b>Studies, FY 00</b></text>
<text top="154" left="125" width="198" height="11" font="1">Title </text>
<text top="154" left="151" width="368" height="11" font="1">of # </text>
<text top="154" left="368" width="22" height="11" font="1">Cost</text>
<text top="182" left="87" width="259" height="11" font="2"><b>Angola, Africa Center for Strategic Studies, FY 00</b></text>
<text top="197" left="87" width="97" height="11" font="1">Leadership Seminar</text>
<text top="197" left="314" width="6" height="11" font="1">2</text>
<text top="197" left="373" width="33" height="11" font="1">$7,462</text>
<text top="212" left="87" width="111" height="11" font="1">Senior Leader Seminar</text>
<text top="212" left="314" width="6" height="11" font="1">2</text>
<text top="212" left="373" width="33" height="11" font="1">$6,960</text>
<text top="226" left="96" width="73" height="11" font="2"><b>FY 00 Totals: </b></text>
<text top="226" left="314" width="6" height="11" font="2"><b>4</b></text>
<text top="226" left="367" width="39" height="11" font="2"><b>$14,422</b></text>
<text top="251" left="87" width="258" height="11" font="2"><b>Angola, Africa Center for Strategic Studies, FY 01</b></text>
<text top="265" left="87" width="96" height="11" font="1">Leadership Seminar</text>
<text top="265" left="314" width="6" height="11" font="1">2</text>
<text top="265" left="373" width="33" height="11" font="1">$7,577</text>
<text top="280" left="87" width="111" height="11" font="1">Senior Leader Seminar</text>
<text top="280" left="314" width="6" height="11" font="1">2</text>
<text top="280" left="373" width="33" height="11" font="1">$9,033</text>
<text top="295" left="96" width="73" height="11" font="2"><b>FY 01 Totals: </b></text>
<text top="295" left="314" width="6" height="11" font="2"><b>4</b></text>
<text top="295" left="367" width="39" height="11" font="2"><b>$16,610</b></text>
<text top="308" left="96" width="88" height="11" font="2"><b>Program Totals: </b></text>
<text top="308" left="314" width="6" height="11" font="2"><b>8</b></text>
<text top="308" left="367" width="39" height="11" font="2"><b>$31,032</b></text>
<text top="322" left="96" width="89" height="11" font="2"><b> Country Totals: </b></text>
<text top="322" left="314" width="6" height="11" font="2"><b>8</b></text>
<text top="322" left="367" width="39" height="11" font="2"><b>$31,032</b></text>
...
``` 

The `_cleanXML` function transforms the above (and the other 6123 lines of that file) into this clean, nested XML:

```
<?xml version="1.0" encoding="UTF-8"?>
<countries>
  <country name="Angola">
    <program name="Africa Center for Strategic Studies, FY 00">
</program>
  </country>
  <country name="Angola">
    <program name="Africa Center for Strategic Studies, FY 00">
      <training>
        <course_title>Leadership Seminar</course_title>
        <quantity>2</quantity>
        <total_cost>$7,462</total_cost>
        <page_number>1</page_number>
      </training>
      <training>
        <course_title>Senior Leader Seminar</course_title>
        <quantity>2</quantity>
        <total_cost>$6,960</total_cost>
        <page_number>1</page_number>
      </training>
    </program>
  </country>
  <country name="Angola">
    <program name="Africa Center for Strategic Studies, FY 01">
      <training>
        <course_title>Leadership Seminar</course_title>
        <quantity>2</quantity>
        <total_cost>$7,577</total_cost>
        <page_number>1</page_number>
      </training>
      <training>
        <course_title>Senior Leader Seminar</course_title>
        <quantity>2</quantity>
        <total_cost>$9,033</total_cost>
        <page_number>1</page_number>
      </training>
    </program>
  </country>
  ...
```

The foundational function in the `_cleanXML`sub-routine is `_assignTrainingAttributes`. This function uses the number found in `left` and `font` attributes of each row of the raw XML to decide what the attribute is and assign to it one a substantive attribute name. For example:

```
<text top="197" left="87" width="97" height="11" font="1">Leadership Seminar</text>
```
In this case, a row containing `left="87"` and `font="1"` will be the title of the course. So in, `_assignTrainingAttribute` for this scraper there is this `sed` statement:

```
s/^.*left=\"87\".*font=\"1\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
```

A function covering all the attributes we need for each training item can built up progressively by looking closely at the raw XML structure:

```
_assignTrainingAttributes () {
	sed -E '{
			# Left column
			s/^.*left=\"87\".*font=\"1\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"3[01][23458]\".*font=\"1\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"3[5-9][0-9]\".*font="\1\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			# Right column
			s/^.*left=\"486\".*font=\"1\">(.*)<\/text>$/<course_title>\1<\/course_title>/g
			s/^.*left=\"7[01][23478]\".*font=\"1\">(.*)<\/text>$/<quantity>\1<\/quantity>/g
			s/^.*left=\"7[5-9][0-9]\".*font="\1\">(.*)<\/text>$/<total_cost>\1<\/total_cost>/g
			# Pages
			s/^.*top=\"1120\".*height=\"13\".*>([0-9]+)<\/text>$/<page>\1<\/page>/g
			# Program
			s/<text program/<program/g
		}'

}
```
There is always variation, however. For example the above version of `_assignTrainingAttributes` deals with a two-column PDF and also handles attributes where the `left` value changes: "quantity" can be found in `left` values that range from "302" to "318", so we build a `sed` statement to cover that.

You can see from the below excerpt of raw XML that there are also other substantive attributes we need to extract. For example:

```
<text top="114" left="87" width="259" height="11" font="2"><b>Africa Region, Angola, Africa Center for Strategic</b></text>
<text top="128" left="87" width="74" height="11" font="2"><b>Studies, FY 00</b></text>
```
In this particular XML, these rows contain the "program title" and "country" attributes we want to extract. So, rows where `left="87"` and `font="2"` will be processed by the `_composeProgramTitle`, `_cleanProgramTitle` and `_massageXMLStructure` functions of the `_cleanXML` subroutine. In the above example of lines containing program title, the data we want to extract ("Africa Region, Angola, Africa Centre for Strategic Studies, FY 00") is spread across two lines, so we will need to concatenate them.

The `_cleanXML` subroutine and its set of function has built up over time as I've addressed particular problems thrown up by over 20 years of PDFs. The order in which they are used matters; sometimes they address general structural issues, other times specific one-time annoyances. To close this section, here's a quick overview of each function in the `_cleanXML` sub-routine:


* `_firstFixes`: basically a manual fix step for text and rows that contain one-off or very specific errors which it's easier to have a  "fix by hand" approach.
* `_trimLeadingTrailingItems`: refines further the range of rows that contain material from a particular region by removing leading and trailing items _before_ further cleanup. An alternative approach is to process them fully, and then filter them out at the end.
* `_composeProgramTitle`: finds rows where the program title attribute is spread across more than one line, combines them together and assigns a placeholder attribute tag so we can identify them for further processing.
* `_cleanProgramTitle`: strips XML tags, whitespace and other annoyances from program title attributes, and tab-separates the main parts (country, program, fiscal year) so we can work on them later.
* `_filterOutUselessLines`: removes lines that contain  data we don't need, such as repeated column header names, program totals, and empty lines.
* `_assignTrainingAttributes`: picks out rows that contain specific attributes (e.g. Course Name, Cost, Quantity, Start and End date) and assigns them a new, substantive XML tag.
* `_filterOutNonText`: remove anything that still has `<text>` tag, as we don't need it.
* `_addTrainingTagsToProgram`: prefix a `<training>` tag to `<program>`, building the XML nesting structure. In the 2000-2001 report we also deal with a problem where some items are out of order and need to be shuffled around.
* `_splitLines`: insert line breaks where needed
* `_wrapPageTags`: Make sure `<page>` tags aren't gathered up inside a `<training>` attribute at this point.
* `_assignPageNumbers`: find the current page number, and transpose it to a new attribute  inside every training item until the next page number.
* `_removeOldPageTags`: filter out the original page tags, because we don't need them.
* `_massageXMLStructure`: handle cases where there aren't yet the correct combinations of opening and closing tags, and also pull out the country name from the program name and assign it a distinct tag.
* `_finaliseXMLStructure`: add XML standard opening and closing matter, including the closing page number.
* `_closingFixes`: deal with any last annoyances that aren't structural, but keep cropping up.


Once the XML is in a nested form and passes the linter, two sub-processes remain: `_deduplicateXML` and `_generateOutput`. The `_deduplicateXML` function is an XSLT step, which deals with cases where data about a single attribute is expressed across two of that attribute. For example, if a training item has two `<course_title>` attributes, on with "Leadership" and the other with "Seminar", `_deduplicateXML` merges them into a single tag with the value "Leadership Seminar". This process is a robust way to ensure that all levels of the XML are deduplicated and consistent at the right level. 

The final step - `_generateOutput` - flattens the XML into a single, tab-delimited output with a specific field ordering. The most interesting part of this function is the use of the `ancestor` function in `xmlstarlet`, which ensures the country and program name fields of each training item are populated. 

#### Step 2: Clean and Structure

The first stage of the data extraction workflow are in `1_scrape_extract`and take us from PDFs to tabular data for each geographical region for which data are published in a specific year. The second part of the workflow in `2_clean_structure` takes these raw output, aggregates and cleans them up. Here's the top level structure of this part of the workflow:

```
fmtrpt_2000_2001/2_clean_structure
└── 202407121057
    ├── 0_get_data_files
    ├── 1_pre_stack_clean
    ├── 2_stack_em_up
    ├── 3_big_clean
    └── 4_training_uuids

7 directories, 0 files
```

As before with the PDF extractor and structuring steps, this part of the workflow is also structured by the scraper "run" identifier - in this case, it's `202407121057`. Other scraper sub-projects may have multuple runs, so we use the `run` variable (manually creating the folder with that name) to keep them separate but side-by-side. We manually move the data from the output of one step into the input for the next step. The stages of this part of the workflow are:

 * `0_get_data_files/`: here, we find the output `.tsv` files from `fmtrpt_2000_2001/output/202407121057/5_xml_tsv` (or the year of the current sub-project) and bring copies of them into this cleanup passage of the workflow.
 * `1_pre_stack_clean/`: this little script escapes all speech marks in all the files. This fixes a quoting/sniffing problem for the next step, which aggregates the files. 
 * `2_stack_em_up/`: here, we aggregate all the `.tsv` files for a particular fiscal year into a single `.tsv` file.
 * `3_big_clean/`: This step moves the aggregated `.tsv` with all that year's data in it through a number of transformations (cleaning, standardizing, filtering) to produce a much better output. For example, this step links the country name stated in the original reports to a standard ISO code, aiding comparability. It also assigns administrative metadata (such as the "first seen" and "first scraped" data. It finds values that are in the wrong column (mostly because they're in the wrong place in the source PDF) and fixes them. 
 * `4_training_uuids`: mints a UUID for  each row of data, which we can use as a reference for that specific training intervention. This step in the process should only be run on newly acquired data. Here, we also rename the headers and reorder the output.

The end result of this part of the workflow is a cleaner, more standardized output for that year's data. We can extend this output further to address challenge that may exist with specific datasets. For example:


 * `5_prepub_filters`: a step where we can remove any data that can't be properly extracted and doens't meet the quality standard for inclusion in the final dataset. For example, the 2019-2020 data has a problem with the Angola data - there is a page missing from the source PDF - so we remove use this step until that is fixed.

 * `6_match_prior_ids`: in `~/fmtrpt_data/scrapers/fmtrpt_tools/fmtrpt_additional_proc_components` there is code for an additional component called `match_prior_ids` that we can add to `2_clean_structure`. This step compares the core fields of different versions of the same data produced by different scrape runs. It was originally developed as a way to link the original idenfifiers minted for each training item when we first performed the data extraction to the data on training items produced by later scrapes. We have no way of knowing which training item links to which ID _before_ we scrape it match it to an earlier version. It works in about 95% of cases - meaning that rescraped data keeps its older ids. However the size of overall dataset (around 250,000 rows) left us with more manual checking than we have resource to do, so we minted new ids after rescraping.

#### Step 3: Final data

The output of the workflow described in `1_scrape_extract` and `2_clean_structure` is a single tab-separated file containing all the clean data for that year. For each run performed on that year's source files we place a copy of this final dataset in the `3_final_dataset` directory:

```
fmtrpt_2000_2001/3_final_dataset
└── 202407121057
    └── final_fmtrpt_2000_2001_202407121057.tsv

2 directories, 1 file
```
 
### Aggregation and whole dataset operations

Each sub-project produces a single file of clean data for a specific year. There remains two final tasks: aggregation of all 20 years of data, and the addition of source and citation information for each training items. These steps are handled by the scripts in `fmtrpt_tools`:

```
fmtrpt_tools
├── fmtrpt_add_citations
├── fmtrpt_additional_proc_components
├── fmtrpt_aggregator
└── tools_readme.md

4 directories, 1 file
```
 * `fmtrpt_additional_proc_components`: this is where we store additional components that can be added to `2_clean_structure` where needed.
 * `fmtrpt_aggregator`: This tool aggregates the datasets created by every sub-project into a single file.
 * `fmtrpt_add_citations`: This tool merges the aggregated, complete dataset with a set of citations. The output gives everything needed to properly reference a specific row of data to its report, report section, and page. This was first used after we re-scraped the entire corpus to obtain page numbers (and hence granular provenance). It made sense to do this operation on the complete dataset after re-scraping, but as we receive and scrape future reports, it will only be necessary to operate on newly-acquired data.

The final data for each run is placed in the root `data/fmtrpt_all_data` directory.
 
### Finalisation and publication

```
publish
├── input
│   └── final_fmtrpt_all_20210806.tsv
└── src
    ├── createdb.sh
    ├── deploy.sh
    ├── metadata.yaml
    └── state-department-data.db # Removed in git repo, as it's quite large

2 directories, 5 files
```

Convert the data to `sqlite` (we used `sqlite-utils`), and use [datasette](https://github.com/simonw/datasette) ([docs](https://datasette.readthedocs.io/en/stable/)) to publish the data online in a useful and highly functional way. We include the full text search and indexing functions outlined in the [documentation](https://sqlite-utils.datasette.io/en/stable/cli.html#configuring-full-text-search). We have used Heroku to serve the data, routing to a subdomain of [https://securityforcemonitor.org](https://securityforcemonitor.org).

The scripts to do this are contained in the `publish/` directory. You'll need to set up `heroku` locally in order to use them. Note that `heroku` may not allow you to overwrite an existing application - each time you deploy, it must be to a new application name, after which the `CNAME` record for trainingdata.securityforcemonitor.org will need updating with a new target.

### A final note on variations in report structures

Since the first publication in 2000 the report has changed structure and content a number of times. Parsers like the ones I have written use the font size and positioning values to determine what field a particular piece of text should be placed in. These values change in each report format, but the changes can easily be seen inside the XML and changes made to the parser per those values. 

The current format ("E"), is the easiest to parse and was implemented for the FY2007-2008 report, and has remained broadly stable since then. Format "C", used between FY2000-2001 and FY 2005-2006 is more tricky.

|Report|Pattern|Format
|:--:|:--:|:--:
FY 2020-2021|E| PDF
FY 2019-2020|E| PDF
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
	