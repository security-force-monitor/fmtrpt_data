# Foreign Military Training and DoD Engagement Activities of Interest, Volume I, 1999-2000

## Sources

This report was published online in HTML form on 1 March 2000 on the website of the US Department of State. We can retrieve the report from the official archive of government sites from this time. Part I, section IV is divided into 15 parts at the following URLS:

 * Africa Region (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_af_a2gam.html`
 * Africa Region (2): `https://1997-2001.state.gov/global/arms/fmtrain/cta_af_gha2rwa.html`
 * Africa Region (3): `https://1997-2001.state.gov/global/arms/fmtrain/cta_af_sao2zim.html`
 * East Asia and Pacific Region (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_eap_aust2papua.html`
 * East Asia and Pacific Region (2): `https://1997-2001.state.gov/global/arms/fmtrain/cta_eap_phil2viet.html`
 * Europe Region (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_eur_alb2est.html`
 * Europe Region (2): `https://1997-2001.state.gov/global/arms/fmtrain/cta_eur_latv2switz.html`
 * Near East Region (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_nea_alg2eg.html`
 * Near East Region (2): `https://1997-2001.state.gov/global/arms/fmtrain/cta_nea_ir2ye.html`
 * Newly Independent States (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_nis_all.html`
 * South Asia Region (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_sasia_all.html`
 * Western Hemisphere (1): `https://1997-2001.state.gov/global/arms/fmtrain/cta_wha_a2ch.html`
 * Western Hemisphere (2): `https://1997-2001.state.gov/global/arms/fmtrain/cta_wha_col2ecua.html`
 * Western Hemisphere (3): `https://1997-2001.state.gov/global/arms/fmtrain/cta_wha_el2jama.html`
 * Western Hemisphere (4): `https://1997-2001.state.gov/global/arms/fmtrain/cta_wha_mex2peru.html`
 * Western Hemisphere (5): `https://1997-2001.state.gov/global/arms/fmtrain/cta_wha_stk2ven.html`

The report is not available in PDF form, either separated by region or in a single document. The official archive is also fully captured in the Internet Archive.

## Processing Runs

We have processed this report once:

 * 202407121057: 8471 rows of data extracted from 15 HTML pages. 

This report does not contain any data on `student unit` or `US units`, or the start date, end date or locations of trainings. We did not parse this report in our first run in 2019. The 2024 run is for mostly done out of completionist urges!

## Notes

 * This report was released in HTML format. We can adapt the main scraper workflow to parse the HTML into XML, and then deduplicate and flatten it into TSV format. The main work was to adapt the `_cleanHTML` subroutine.
 * I wrote a simple `curl`-based retrieval function for this script. If it fails, try updating the user agent.
 * The main challenge in parsing this report was dealing with an old-fashion `<TR><TD>` type table in which some items had been split across across rows. This meant dealing with a large number of exceptions, which you can see reflected in the many regex in the script. 
 * The data are much less rich than those published in later reports because the key details about participants, dates and locations are missing.
 * As there is no prior dataset to compare with, no reconciliation step is required.
