********************************************************************************
    * File: table A10.do
    * Purpose: Table A10: alternative outcomes.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

gen ln_pac_spending=ln(pac_spending + 1) 

bysort discharge_date: egen median_spending=median(pac_spending)
gen spending_above_median=pac_spending>median_spending if !missing(pac_spending)

local outcomes_alt readmit90 mortality90 mortality180 ln_pac_spending spending_above_median

eststo clear

foreach outcome of local outcomes_alt {
    ivreghdfe `outcome' $covariates (snf=occupancy), absorb($absorb_main) vce(cluster hsa) keepsingletons
    summarize `outcome' if snf==0 & e(sample)
    estadd scalar hha_mean=r(mean)
    eststo `outcome'
}

esttab `outcomes_alt' using "${tables}/table A10.rtf", replace ///
    keep(snf) cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(hha_mean N, labels("HHA mean" "Observations")) star(* .10 ** .05 *** .01)

