# Notes and scraps: 2003-2004 report

## Scraps

Addition `perl` reshapers:

```
s/(<program name.*)\n<\/training>/\1/g ;
s/(<program name.*>)\n<page_number>.*<\/page_number>\n<\/training>/\1/g ;
s/<\/training>\n<\/program>\n<program name.*>\n(<student_unit)/\1/g ;
s/<\/training>\n<\/program>\n<program.*>\n<location>/<location>/g ;
s/<\/student_unit>\n<page_number>.*<\/page_number>\n<student_unit>/<\/student_unit>\n<student_unit>/g ;
s/<\/end_date>\n<page_number>.*<\/page_number>\n<student_unit>/<\/end_date>\n<student_unit>/g ;
s/<\/location>\n<page_number>.*<\/page_number>\n<location>/<\/location>\n<location>/g
```
