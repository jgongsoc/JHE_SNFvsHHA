********************************************************************************
    * File: table 3.do
    * Purpose: Table 3: first-stage effect of occupancy on SNF discharge.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

eststo clear

* all 
reghdfe snf occupancy $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons
test occupancy
estadd scalar first_stage_F = r(F)
eststo all

* stroke
reghdfe snf occupancy $covariates if disease==1, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons
test occupancy
estadd scalar first_stage_F = r(F)
eststo stroke

* chf
reghdfe snf occupancy $covariates if disease==2, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons
test occupancy
estadd scalar first_stage_F=r(F)
eststo chf


esttab all stroke chf using "${tables}/table 3.rtf", replace ///
    keep(occupancy) cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, labels("First-stage F-statistic" "Observations") fmt(2 0)) ///
    star(* .10 ** .05 *** .01)

