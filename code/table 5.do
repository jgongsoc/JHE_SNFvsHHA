********************************************************************************
    * File: table 5.do
    * Purpose: Table 5: baseline OLS and 2SLS outcome models.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************

clear
set more off

use "${analysis_data}", clear

eststo clear

foreach outcome of global outcomes {
    reghdfe `outcome' snf $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons
    eststo ols_`outcome'
}

foreach outcome of global outcomes {
    ivreghdfe `outcome' $covariates (snf=occupancy), absorb($absorb_main) vce(cluster hsa) keepsingletons
    eststo iv_`outcome'
}


esttab ///
    ols_readmit30 ols_mortality30 ols_pac_spending ///
    iv_readmit30 iv_mortality30 iv_pac_spending ///
    using "${tables}/table 5.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    mgroups("OLS" "2SLS", pattern(1 0 0 1 0 0)) ///
    star(* .10 ** .05 *** .01)
	