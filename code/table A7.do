********************************************************************************
    * File: table A7.do
    * Purpose: Table A7: occupancy and observed SNF patient composition.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

keep if snf==1

tempname results

postfile `results' str40 characteristic ///
    double estimate double se double pvalue ///
    using "${temp}/tableA7.dta", replace


foreach characteristic of global patient_covariates {

    reghdfe `characteristic' occupancy, absorb($absorb_main) vce(cluster hsa) keepsingletons

    test occupancy
    local p = r(p)

    post `results' ("`characteristic'") (_b[occupancy]) (_se[occupancy]) (`p')
}


postclose `results'

use "${temp}/tableA7.dta", clear

export excel using "${tables}/table A7.xlsx", ///
    firstrow(variables) replace
	
	
	
	