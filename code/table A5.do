********************************************************************************
    * File: table A5.do
    * Purpose: Table A5: falsification test in low-occupancy markets.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

quietly summarize occupancy, detail
local occupancy_p25=r(p25)
keep if occupancy<`occupancy_p25'

eststo clear
foreach outcome of global outcomes {
    reghdfe `outcome' occupancy $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending using "${tables}/table A5.rtf", replace ///
    keep(occupancy) cells(b(star fmt(4)) se(par fmt(4))) stats(N) ///
    star(* .10 ** .05 *** .01)

