//Final Thesis Do-file

clear mata
capture log close
clear

cd "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S2/Final_Thesis"

global dirraw "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S1/Econometrics_TD/Rawdata"
global dirdata "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S1/Econometrics_TD/dirdata"
global dirlog "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S1/Econometrics_TD/dirlog"
global dirfig "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S1/Econometrics_TD/dirfig"
global dirtab "/Users/jasonsuri/Documents/Pantheon_Sorbonne_docs/S1/Econometrics_TD/dirtab"

log using $dirdata/TD5.log, replace

//Importing UN Dataset
import delimited "$dirraw/AgreementScoresAll_Jun2024.csv", clear
save "$dirdata/AgreementScoresAll_Jun2024.dta", replace

//Importing trade share or Exports_and_Imports_by_Areas_and_Co_new dataset
import excel "$dirraw/Exports_and_Imports_by_Areas_and_Co_new.xlsx", clear sheet("Imports, CIF") firstrow 
save "$dirdata/trade_import.dta", replace
//Amount in millions

import excel "$dirraw/Exports_and_Imports_by_Areas_and_Co_new.xlsx", clear sheet("Exports, FOB") firstrow 
save "$dirdata/trade_export.dta", replace
//Amount in millions


//Importing FDI share of China Dataset
import excel "$dirraw/FDIshare_out.xlsx", sheet("China_Outward") firstrow clear
save "$dirdata/fdi_outward.dta", replace
import excel "$dirraw/FDIshare_out.xlsx", sheet("China_Inward") firstrow clear
save "$dirdata/fdi_inward.dta", replace

//Importing Geographical distance dataset
use "$dirraw/Geo_Dis.dta", clear
rename iso_o stateabb
save "$dirdata/Geo_Dis.dta", replace

**Merging FDI dataset
use "$dirdata/fdi_outward.dta", clear
duplicates drop Countries, force
reshape long Y, i(Countries) j(Year)
rename Y outward
save "$dirdata/fdi_outward.dta", replace

use "$dirdata/fdi_inward.dta", clear
duplicates drop Countries, force
reshape long Y, i(Countries) j(Year)
rename Y inward
save "$dirdata/fdi_inward.dta", replace

use "$dirdata/fdi_outward.dta", clear
merge 1:1 Countries Year using "$dirdata/fdi_inward.dta"
drop _merge
replace Countries = "Afghanistan" if Countries == "Afghanistan, Islamic Rep. of"
replace Countries = "Andorra" if Countries == "Andorra, Principality of"
replace Countries = "Armenia" if Countries == "Armenia, Rep. of"
replace Countries = "Aruba" if Countries == "Aruba, Kingdom of the Netherlands"
replace Countries = "Azerbaijan" if Countries == "Azerbaijan, Rep. of"
replace Countries = "Bahrain" if Countries == "Bahrain, Kingdom of"
replace Countries = "Belarus" if Countries == "Belarus, Rep. of"
replace Countries = "Hong Kong SAR" if Countries == "China, P.R.: Hong Kong"
replace Countries = "Macao SAR" if Countries == "China, P.R.: Macao"
replace Countries = "China" if Countries == "China, P.R.: Mainland"
replace Countries = "Central African Republic" if Countries == "Central African Rep."
replace Countries = "Comoros" if Countries == "Comoros, Union of the"
replace Countries = "Croatia" if Countries == "Croatia, Rep. of"
replace Countries = "Czech Republic" if Countries == "Czech Rep."
replace Countries = "Democratic Republic of the Congo" if Countries == "Congo, Dem. Rep. of the"
replace Countries = "Republic of Congo" if Countries == "Congo, Rep. of"
replace Countries = "Egypt" if Countries == "Egypt, Arab Rep. of"
replace Countries = "Equatorial Guinea" if Countries == "Equatorial Guinea, Rep. of"
replace Countries = "Eritrea" if Countries == "Eritrea, The State of"
replace Countries = "Estonia" if Countries == "Estonia, Rep. of"
replace Countries = "Eswatini" if Countries == "Eswatini, Kingdom of"
replace Countries = "Ethiopia" if Countries == "Ethiopia, The Federal Dem. Rep. of"
replace Countries = "Fiji" if Countries == "Fiji, Rep. of"
replace Countries = "Iran" if Countries == "Iran, Islamic Rep. of"
replace Countries = "Korea" if Countries == "Korea, Rep. of"
replace Countries = "Kosovo" if Countries == "Kosovo, Rep. of"
replace Countries = "Kyrgyz Republic" if Countries == "Kyrgyz Rep."
replace Countries = "Lao P.D.R." if Countries == "Lao People's Dem. Rep."
replace Countries = "Lesotho" if Countries == "Lesotho, Kingdom of"
replace Countries = "Madagascar" if Countries == "Madagascar, Rep. of"
replace Countries = "Mauritania" if Countries == "Mauritania, Islamic Rep. of"
replace Countries = "Micronesia" if Countries == "Micronesia, Federated States of"
replace Countries = "Moldova" if Countries == "Moldova, Rep. of"
replace Countries = "Mozambique" if Countries == "Mozambique, Rep. of"
replace Countries = "Nauru" if Countries == "Nauru, Rep. of"
replace Countries = "North Macedonia" if Countries == "North Macedonia, Republic of"
replace Countries = "Palau" if Countries == "Palau, Rep. of"
replace Countries = "Poland" if Countries == "Poland, Rep. of"
replace Countries = "San Marino" if Countries == "San Marino, Rep. of"
replace Countries = "Serbia" if Countries == "Serbia, Rep. of"
replace Countries = "Slovenia" if Countries == "Slovenia, Rep. of"
replace Countries = "South Sudan" if Countries == "South Sudan, Rep. of"
replace Countries = "Sao Tome and Principe" if Countries == "São Tomé and Príncipe, Dem. Rep. of"
replace Countries = "Tajikistan" if Countries == "Tajikistan, Rep. of"
replace Countries = "Tanzania" if Countries == "Tanzania, United Rep. of"
replace Countries = "Timor-Leste" if Countries == "Timor-Leste, Dem. Rep. of"
replace Countries = "Türkiye" if Countries == "Türkiye, Rep. of"
replace Countries = "Uzbekistan" if Countries == "Uzbekistan, Rep. of"
replace Countries = "Venezuela" if Countries == "Venezuela, Rep. Bolivariana de"
replace Countries = "Yemen" if Countries == "Yemen, Rep. of"
save "$dirdata/fdi_merge.dta", replace



**Merging Exports_and_Imports_by_Areas_and_Co dataset
use "$dirdata/trade_import.dta", clear
duplicates drop Countries, force
reshape long yr, i(Countries) j(Year)
rename yr imports
save "$dirdata/trade_import.dta", replace

use "$dirdata/trade_export.dta", clear
duplicates drop Countries, force
reshape long yr, i(Countries) j(Year)
rename yr exports
save "$dirdata/trade_export.dta", replace

use "$dirdata/trade_export.dta", clear
merge 1:1 Countries Year using "$dirdata/trade_import.dta"
drop _merge

* Standardize country names in Trade_merge dataset
replace Countries = "Afghanistan" if Countries == "Afghanistan, Islamic Rep. of"
replace Countries = "Armenia" if Countries == "Armenia, Rep. of"
replace Countries = "Azerbaijan" if Countries == "Azerbaijan, Rep. of"
replace Countries = "Bahrain" if Countries == "Bahrain, Kingdom of"
replace Countries = "Belarus" if Countries == "Belarus, Rep. of"
replace Countries = "Cape Verde" if Countries == "Cabo Verde"
replace Countries = "Congo - Brazzaville" if Countries == "Congo, Rep. of"
replace Countries = "Egypt" if Countries == "Egypt, Arab Rep. of"
replace Countries = "Eswatini" if Countries == "Eswatini, Kingdom of"
replace Countries = "Ethiopia" if Countries == "Ethiopia, The Federal Dem. Rep. of"
replace Countries = "Gambia" if Countries == "Gambia, The"
replace Countries = "Iran" if Countries == "Iran, Islamic Rep. of"
replace Countries = "Kyrgyzstan" if Countries == "Kyrgyz Rep."
replace Countries = "Laos" if Countries == "Lao People's Dem. Rep."
replace Countries = "North Macedonia" if Countries == "North Macedonia, Republic of"
replace Countries = "Russia" if Countries == "Russian Federation"
replace Countries = "Slovakia" if Countries == "Slovak Rep."
replace Countries = "Slovenia" if Countries == "Slovenia, Rep. of"
replace Countries = "Syria" if Countries == "Syrian Arab Rep."
replace Countries = "Tanzania" if Countries == "Tanzania, United Rep. of"
replace Countries = "Turkey" if Countries == "Türkiye, Rep of"
replace Countries = "Venezuela" if Countries == "Venezuela, Rep. Bolivariana de"
replace Countries = "Hong Kong" if Countries == "China, P.R.: Hong Kong"
replace Countries = "Macao" if Countries == "China, P.R.: Macao"
replace Countries = "China" if Countries == "China, P.R.: Mainland"
replace Countries = "Aruba" if Countries == "Aruba, Kingdom of the Netherlands"
replace Countries = "Sint Maarten" if Countries == "Sint Maarten, Kingdom of the Netherlands"
replace Countries = "Ivory Coast" if Countries == "Côte d'Ivoire"
replace Countries = "South Korea" if Countries == "Korea, Rep. of"
replace Countries = "North Korea" if Countries == "Korea, Dem. People's Rep. of"
replace Countries = "Taiwan" if Countries == "Taiwan Province of China"
replace Countries = "United States of America" if Countries == "United States"
replace Countries = "Bahamas" if Countries == "Bahamas, The"
replace Countries = "Czech Republic" if Countries == "Czech Rep."
replace Countries = "Dominican Republic" if Countries == "Dominican Rep."
replace Countries = "Eritrea" if Countries == "Eritrea, The State of"
replace Countries = "Lesotho" if Countries == "Lesotho, Kingdom of"
replace Countries = "Marshall Islands" if Countries == "Marshall Islands, Rep. of the"
replace Countries = "Mauritania" if Countries == "Mauritania, Islamic Rep. of"
replace Countries = "Netherlands" if Countries == "Netherlands, The"
replace Countries = "Macedonia" if Countries == "North Macedonia"
replace Countries = "Democratic Republic of the Congo" if Countries == "Congo, Dem. Rep. of the"
replace Countries = "Brunei" if Countries == "Brunei Darussalam"
replace Countries = "Antigua & Barbuda" if Countries == "Antigua and Barbuda"
replace Countries = "Central African Republic" if Countries == "Central African Rep."
replace Countries = "Comoros" if Countries == "Comoros, Union of the"
replace Countries = "Congo" if Countries == "Congo - Brazzaville"
replace Countries = "Sao Tome and Principe" if Countries == "São Tomé and Príncipe, Dem. Rep. of"
replace Countries = "East Timor" if Countries == "Timor-Leste, Dem. Rep. of"
replace Countries = "Federated States of Micronesia" if Countries == "Micronesia, Federated States of"

* Clean residual "Rep. of" suffixes using regex
replace Countries = regexr(Countries, ", Rep\. of$", "")
save "$dirdata/Trade_merge.dta", replace

*Importing Total Export and Import dataset for Denominator to calculate trade share
import excel "$dirraw/Total_Imports_new.xlsx", clear firstrow 
save "$dirdata/Total_trade_import.dta", replace

import excel "$dirraw/Total_Exports_new.xlsx", clear firstrow 
save "$dirdata/Total_trade_export.dta", replace
//all data in millions
*********
**Merging Total Exports and Imports dataset
use "$dirdata/Total_trade_import.dta", clear
duplicates drop Countries, force
reshape long yr, i(Countries) j(Year)
rename yr imports
save "$dirdata/Total_trade_import.dta", replace

use "$dirdata/Total_trade_export.dta", clear
duplicates drop Countries, force
reshape long yr, i(Countries) j(Year)
rename yr exports
save "$dirdata/Total_trade_export.dta", replace

use "$dirdata/Total_trade_export.dta", clear
merge 1:1 Countries Year using "$dirdata/Total_trade_import.dta"
drop _merge
rename exports totalexports
rename imports totalimports
save "$dirdata/Total_Trade_merge.dta", replace

use "$dirdata/Trade_merge.dta", clear
merge 1:1 Countries Year using "$dirdata/Total_Trade_merge.dta"
drop _merge
save "$dirdata/Trade_merge.dta", replace


// Merging country_codes file with UN dataset
import delimited "$dirraw/AgreementScoresAll_Jun2024.csv", clear 
rename ccode2 ccode 
drop if !inlist(year, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2023, 2024, 2025)
save "$dirdata/AgreementScoresAll_Jun2024.dta", replace

import delimited "$dirraw/COW-country-codes.csv", clear 
rename statenme Countries
duplicates drop stateabb, force
save "$dirdata/COW-country-codes.dta", replace

use "$dirdata/AgreementScoresAll_Jun2024.dta", clear
merge m:1 ccode using "$dirdata/COW-country-codes.dta"
drop if _merge == 2
drop _merge
rename year Year
rename Countries Countries_from
rename ccode ccode2
save "$dirdata/UN_merge.dta", replace

use "$dirdata/UN_merge.dta", clear
rename ccode1 ccode
save "$dirdata/UN_merge.dta", replace

use "$dirdata/UN_merge.dta", clear
merge m:1 ccode using "$dirdata/COW-country-codes.dta"
drop if _merge == 2
drop _merge
//rename Countries Countries_to
rename ccode ccode1
*************** To make data from countries to China
drop if Countries_from != "China"
***************
save "$dirdata/UN_merge.dta", replace



//Merging all dataset together
use "$dirdata/Trade_merge.dta", clear
merge 1:1 Countries Year using "$dirdata/UN_merge.dta"
drop _merge
keep Countries Year exports imports idealpointdistance Countries_from totalexports totalimports
save "$dirdata/Panel_merge.dta", replace

//1) merging Geo with COW-country-codes
use "$dirdata/Geo_Dis.dta", clear
merge m:1 stateabb using "$dirdata/COW-country-codes.dta"
drop if _merge== 1
drop _merge
rename Countries Countries_from
rename stateabb iso_o
save "$dirdata/Geo_merge.dta", replace

use "$dirdata/Geo_merge.dta", clear
rename iso_d stateabb
save "$dirdata/Geo_merge.dta", replace

use "$dirdata/Geo_merge.dta", clear
merge m:1 stateabb using "$dirdata/COW-country-codes.dta"
drop if _merge== 1
drop _merge
keep Countries Countries_from distcap
save "$dirdata/Geo_merge.dta", replace

//Merging Panel_merge with Geo_merge
use "$dirdata/Panel_merge.dta", clear
merge m:1 Countries Countries_from using "$dirdata/Geo_merge.dta"
drop if _merge== 1
drop _merge
save "$dirdata/Panel_merge.dta", replace

//Importing X variable of WEO dataset
import excel "$dirraw/WEOOct2024all.xlsx", firstrow clear

*Keeping only the relevant Subject Descriptors (GDP, Inflation)
keep if SubjectDescriptor == "Gross domestic product, current prices" | ///
        SubjectDescriptor == "Inflation, average consumer prices"

* Keeping only specific units
keep if Units == "U.S. dollars" | Units == "Index"


*Renaming necessary columns 
rename AR Y2014
rename AS Y2015
rename AT Y2016
rename AU Y2017
rename AV Y2018
rename AW Y2019

keep ISO SubjectDescriptor Units Scale Country Y2014 Y2015 Y2016 Y2017 Y2018 Y2019 Y2020 Y2021 Y2022 Y2023 Y2024 Y2025
replace SubjectDescriptor = "GDP" if SubjectDescriptor == "Gross domestic product, current prices"
replace SubjectDescriptor = "Inflation" if SubjectDescriptor == "Inflation, average consumer prices"
rename Country Countries

*Reshaping
reshape long Y, i(Countries SubjectDescriptor Units) j(Year)
rename Y Amount

drop Units Scale ISO

*Reshape again to wide format
reshape wide Amount, i(Countries Year) j(SubjectDescriptor) string

* Modify Countries to match the simpler names from Countries_WEO
replace Countries = "Hong Kong" if Countries == "Hong Kong SAR"
replace Countries = "Macao" if Countries == "Macao SAR"
replace Countries = "Taiwan" if Countries == "Taiwan Province of China"
replace Countries = "Laos" if Countries == "Lao P.D.R."
replace Countries = "Iran" if Countries == "Islamic Republic of Iran"
replace Countries = "Kyrgyzstan" if Countries == "Kyrgyz Republic"
replace Countries = "Congo" if Countries == "Republic of Congo"
replace Countries = "DR Congo" if Countries == "Democratic Republic of the Congo"

replace AmountGDP = "" if AmountGDP == "n/a"
destring AmountGDP, replace

replace AmountGDP = AmountGDP / 100
// all amount in millions

save "$dirdata/WEO.dta", replace

* Merging WEO with panel
use "$dirdata/Panel_merge.dta", clear
merge m:1 Countries Year using "$dirdata/WEO.dta"
drop if _merge== 2
drop _merge
save "$dirdata/Panel_merge.dta", replace


*Merging panel with FDI
use "$dirdata/Panel_merge.dta", clear
merge m:1 Countries Year using "$dirdata/fdi_merge.dta"
drop if _merge== 2
drop _merge
save "$dirdata/Panel_merge.dta", replace

*Making a new variable called geopolitical proximity using idealpointdistance
gen idealpointdistance_num = real(idealpointdistance)
gen geopolitical_proximity = 1 - idealpointdistance_num
gen log_distcap = log(distcap)
keep Countries Countries_from Year exports imports geopolitical_proximity AmountGDP AmountInflation log_distcap outward inward totalexports totalimports
save "$dirdata/Panel_merge.dta", replace

*Making New varaible called "TradeShare" which will be our dependent variable
gen trade_with_china = (exports + imports)
*********
*Aggregate trade_with_china by country and year
egen trade_china_total = total(trade_with_china), by(Countries Year)

destring totalexports, replace ignore(",")
destring totalimports, replace ignore(",")

*Compute total exports and imports (denominator)

egen total_exports = total(totalexports), by(Countries Year)
egen total_imports = total(totalimports), by(Countries Year)
gen total_trade = total_exports + total_imports


*Calculate trade share for year t
gen trade_share_china = trade_china_total / total_trade

**Keeping only important variable
keep Countries Countries_from Year trade_share_china geopolitical_proximity AmountGDP AmountInflation log_distcap outward inward totalexports totalimports

save "$dirdata/Panel_merge.dta", replace


** Running the Regression********
* Load the dataset
use "$dirdata/Panel_merge.dta", clear

* Keep only specified variables
keep Countries Countries_from Year trade_share_china geopolitical_proximity AmountGDP AmountInflation log_distcap outward inward

* Create a numeric country identifier from Countries
encode Countries, gen(country_id)
duplicates drop country_id Year, force
* Set panel structure
xtset country_id Year

* Generate variables
gen COVID = (Year >= 2020)
gen geo_covid_interaction = geopolitical_proximity * COVID
gen lag_trade_share = L.trade_share_china



* Run regression
replace AmountInflation = "" if AmountInflation == "n/a"
destring AmountInflation, replace
//replace AmountGDP = "" if AmountGDP == "n/a"
destring AmountGDP, replace

replace outward = outward / 100
replace inward = inward / 100


* Run regression

regress trade_share_china geopolitical_proximity outward inward log_distcap AmountGDP AmountInflation geo_covid_interaction i.Year

summarize trade_share_china geopolitical_proximity outward inward log_distcap AmountGDP AmountInflation geo_covid_interaction Year


//estat hettest
//For Test of heteroskedasticity and Multicollinearity
//vif
//for test

summarize trade_share_china Countries geopolitical_proximity outward inward log_distcap AmountGDP AmountInflation geo_covid_interaction Year



xtreg trade_share_china geopolitical_proximity outward inward log_distcap AmountGDP AmountInflation geo_covid_interaction i.Year, fe vce(robust)


/*
//With FE
xtreg trade_share_china lag_trade_share geopolitical_proximity outward inward ///
      log_distcap AmountGDP AmountInflation geo_covid_interaction i.Year, fe vce(cluster country_id)
*/


**Graphs Analysis

/*
* 1a) Compute annual mean
preserve
collapse (mean) mean_trade_share=trade_share_china, by(Year)

* 1b) Plot
twoway line mean_trade_share Year, ///
    sort ///
    title("Average Trade Share with China (2014–24)") ///
    ytitle("Mean Trade Share") ///
    xtitle("Year") ///
    scheme(s1color)
restore

graph export "$dirfig/avg_trade_share.png", width(1200) height(800) replace
*/

//describe

//summarize










