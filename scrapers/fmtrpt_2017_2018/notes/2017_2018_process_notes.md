# Notes: PDF extractor 2017-2018 Foreign Military Trainings Report

tl / 20190327

This is a first cut of a crude PDF extractor for the FMT reports. The loose process is described below and we use it as a template for extracting other reports too.


## PDF to XML

This conversion step turns the PDF into simple XML that captures the recurrent pattern of the tables that we wish to extract.

## Improving the XML

A large number of filters and regexes whittles down the XML produced by PDF convertor, removing irrelevant lines. Using specific criteria we then begin to introduce a nested structure into the document. By the end of it, we have well formed XML.


## XSLT phase

In the original PDF from the State Department, some values in some cells had line breaks - usually `US Unit` and `Location`. The initial PDF to XML conversion treated each of these lines as a new row, and subsequent parsing then turned each, correctly, into a distinct item as part of the training element. This is allowable under XML, but distorts a flattened output like TSV. XSLT can be used to deal with this problem, as described in this Stack Overflow question I asked (the issue was beyond me!):

https://stackoverflow.com/questions/55299442/xml-group-and-merge-elements-whilst-keeping-all-element-text
