# FMTRPT Tools

A set of tools for creating and working on an aggregate of all the FMTRPT datasets.

1. `fmtrpt_aggregator`

This tool pulls together the final output files from each scraper project and collates them into a single file.

2. `fmtrpt_additional_proc_components`

The scrapers are built with a set of components chained into a linear process. This folder contains additional components that a scraper project might need:

 - `match_prior_ids`: a component that is used to compare outputs of different scraper runs on the same data (by hashing core fields in both, and outputting the product). It is used, specifically, to retain previously minted ID numbers for training events. 

3. `fmtrpt_add_citation`

This tool merges the aggregated, complete dataset with a set of citations. The output gives everything needed to properlly reference a specific row of data to its report, report section, and page. This was first used after we re-scraped the entire corpus to obtain page numbers (and hence granular provenance). It made sense to do this operation on the complete dataset after re-scraping, but as we receive and scrape future reports, it will only be necessary to operate on the newly acquired data.

