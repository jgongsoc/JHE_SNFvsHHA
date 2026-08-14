********************************************************************************
    * File: table A9.do
    * Purpose: Table A9: exclude bottom/top 1 percent of occupancy.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

summarize occupancy, detail
local lower=r(p1)
local upper=r(p99)
keep if inrange(occupancy,`lower',`upper')

reghdfe snf occupancy $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons
test occupancy
local first_stage_F=r(F)

eststo clear

foreach outcome of global outcomes {
    ivreghdfe `outcome' $covariates (snf=occupancy), absorb($absorb_main) vce(cluster hsa) keepsingletons
    estadd scalar first_stage_F=`first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending using "${tables}/table A9.rtf", replace ///
    keep(snf) cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)

