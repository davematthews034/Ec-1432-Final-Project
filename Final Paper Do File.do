* Ec 1432: Final Paper by David Matthews
* Capital Flows and Trust in Europe
*
*
* Sources:
* http://data.worldbank.org/data-catalog/GDP-ranking-table (GDP)
*
* Cultural Biases in Economic Exchange
* /Users/Dave/Desktop/Ec 1432/Final Paper/Role of Social Capital....pdf
* /Users/Dave/Desktop/Ec 1432/Final Paper/Trusting Stock Market.pdf
* /Users/Dave/Desktop/Ec 1432/Final Paper/OECD DITS.xlsx
* EVS
* http://ec.europa.eu/public_opinion/archives/ebs/ebs_243_sum_en.pdf
* https://www.ecb.europa.eu/pub/pdf/scpwps/ecbwp685.pdf?0dd8aed7fff420528485979737e71a7d
*
* European Commission (2012): Eurobarometer 46.0 (Oct-Nov 1996). INRA, Brussels. GESIS Data Archive, Cologne. ZA2898 Data file Version 1.0.1, doi:10.4232/1.10923
*
*
*

import delimited "/Users/Dave/Desktop/Ec 1432/Final Paper/dataset.csv", encoding(ISO-8859-1)clear

* Creating the log of various measures
gen logvalue = log(value)
gen loggdp = log(gdp)
gen logexports = log(value) if flow == "EXP"
gen logimports = log(value) if flow == "IMP"
gen logfdi = log(netfdi)

egen countrytotaltrades = sum(value), by(reportercountry)
* Because of Stata's odd groupings, you need to replace ill-placed values 
* (i.e. exports in the imports category) with null values.
egen countrytotalexp = sum(value), by(reportercountry flow)
egen countrytotalimp = sum(value), by(reportercountry flow)
replace countrytotalexp = . if flow == "IMP"
replace countrytotalimp = . if flow == "EXP"
gen logcountrytotaltrades = log(countrytotaltrades)
gen logcountrytotalexp = log(countrytotalexp)
gen logcountrytotalimp = log(countrytotalimp)

