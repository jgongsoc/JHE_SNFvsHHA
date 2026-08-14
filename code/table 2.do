********************************************************************************
    * File: table 2.do
    * Purpose: Table 2: characteristics by HHA and SNF treatment.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

local variables $outcomes $patient_covariates $market_covariates

tempname results
postfile `results' str40 variable ///
    double hha double snf ///
    using "${temp}/table2.dta", replace

foreach variable of local variables {

    summarize `variable' if snf==0
    local hha = r(mean)

    summarize `variable' if snf==1
    local snfmean = r(mean)

    post `results' ("`variable'") (`hha') (`snfmean') 
}

postclose `results'


use "${temp}/table2.dta", clear
export excel using "${tables}/table 2.xlsx", firstrow(variables) replace

