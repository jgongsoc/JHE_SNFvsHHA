********************************************************************************
    * File: table A6.do
    * Purpose: Table A6: disease-specific 2SLS outcome estimates.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

* stroke
eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if disease==1, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons

    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table A6 stroke.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)

	
* chf
eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if disease==2, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons

    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table A6 chf.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)	
	
	
	