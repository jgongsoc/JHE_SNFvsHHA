********************************************************************************
    * File: table 1.do
    * Purpose: Table 1: balance by high/low daily occupancy.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

bysort year quarter: egen occupancy_median=median(occupancy)
generate high_occupancy=occupancy>occupancy_median if !missing(occupancy)

local variables $patient_covariates $market_covariates

tempname results
postfile `results' str40 variable ///
    double high double low double difference ///
    using "${temp}/table1.dta", replace

foreach variable of local variables {
    summarize `variable' if high_occupancy==1
    local high=r(mean)
    
	summarize `variable' if high_occupancy==0
    local low=r(mean)
	
    post `results' ("`variable'") (`high') (`low') (`high'-`low')
}

postclose `results'

use "${temp}/table1.dta", clear
export excel using "${tables}/table 1.xlsx", firstrow(variables) replace

