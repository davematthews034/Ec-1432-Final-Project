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
* http://tjpeiffer.com/crowflies.html
*

import delimited "/Users/Dave/Desktop/Ec 1432/Final Paper/dataset.csv", encoding(ISO-8859-1)clear

* Creating the log of various measures
gen logvalue = log(value)
gen loggdp = log(gdp)
gen logexports = log(value) if flow == "EXP"
gen logimports = log(value) if flow == "IMP"
gen logfdi = log(netfdi)

egen countrytotaltrade = sum(value), by(reportercountry)
* Because of Stata's odd groupings, you need to replace ill-placed values 
* (i.e. exports in the imports category) with null values.
egen countrytotalexp = sum(value), by(reportercountry flow)
egen countrytotalimp = sum(value), by(reportercountry flow)
replace countrytotalexp = . if flow == "IMP"
replace countrytotalimp = . if flow == "EXP"
gen logcountrytotaltrade = log(countrytotaltrade)
gen logcountrytotalexp = log(countrytotalexp)
gen logcountrytotalimp = log(countrytotalimp)

regress logcountrytotaltrade peopletrust loggdp
estimates store m1, title(People)

regress logcountrytotaltrade neighbortrust loggdp
estimates store m2, title(Neighbor)

regress logcountrytotaltrade familytrust loggdp
estimates store m3, title(Family)

regress logcountrytotaltrade personaltrust loggdp
estimates store m4, title(Personal)

regress logcountrytotaltrade othercountrytrust loggdp
estimates store m5, title(OthCountry)

estout m1 m2 m3 m4 m5, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))
estimates clear

regress countrytradepercentofgdp peopletrust
estimates store m1, title(People)
regress countrytradepercentofgdp neighbortrust
estimates store m2, title(Neighbor)
regress countrytradepercentofgdp familytrust
estimates store m3, title(Family)
regress countrytradepercentofgdp personaltrust
estimates store m4, title(Personal)
regress countrytradepercentofgdp othercountrytrust
estimates store m5, title(OthCountry)

estout m1 m2 m3 m4 m5, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))
estimates clear

regress logvalue bilateraltrust loggdp
regress countrytradepercentofgdp bilateraltrust

# Robustness check
regress logfdi bilateraltrust loggdp
regress netfdigdp bilateraltrust

# Introducing controls
regress logvalue bilateraltrust loggdp
estimates store m1, title(Base)
regress logvalue bilateraltrust loggdp englishrate
estimates store m2, title(Base+Eng)
regress logvalue bilateraltrust loggdp englishrate laworigins
estimates store m3, title(+Law)
regress logvalue bilateraltrust loggdp englishrate laworigins rel_sim
estimates store m4, title(+Rel_Sim)
regress logvalue bilateraltrust loggdp englishrate laworigins rel_sim logdis
estimates store m5, title(+Log Dis)
estout m1 m2 m3 m4 m5, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))
estimates clear

# For the gravity equation
gen logdis = log(distance)
gen logpartnergdp = log(partnergdp)



