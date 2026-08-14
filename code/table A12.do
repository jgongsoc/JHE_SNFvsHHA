********************************************************************************
    * File: table A12.do
    * Purpose: Table A12: alternative minimum HSA discharge thresholds.
    * Input: analysis_market_thresholds.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${threshold_data}", clear

foreach threshold in 40 20 30 50 80 100 {
    reghdfe snf occupancy $covariates if market_discharges>=`threshold', absorb($absorb_main) vce(cluster hsa) keepsingletons
    test occupancy
    local first_stage_F=r(F)
    eststo clear
    foreach outcome of global outcomes {
        ivreghdfe `outcome' $covariates (snf=occupancy) if market_discharges>=`threshold', absorb($absorb_main) vce(cluster hsa) keepsingletons
        estadd scalar first_stage_F=`first_stage_F'
        eststo `outcome'
    }
	
    esttab readmit30 mortality30 pac_spending ///
        using "${tables}/table A12 threshold `threshold'.rtf", replace ///
        keep(snf) cells(b(star fmt(4)) se(par fmt(4))) ///
        stats(first_stage_F N, labels("First-stage F-statistic" "Observations")) ///
        star(* .10 ** .05 *** .01)
}

