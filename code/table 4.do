********************************************************************************
    * File: table 4.do
    * Purpose: Table 4: occupancy and all discharge destinations.
    * Input: analysis_destinations.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${destination_data}", clear

* All
eststo clear

foreach outcome in hha irf ltch home {

    reghdfe `outcome' occupancy $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons

    eststo `outcome'
}

esttab hha irf ltch home using "${tables}/table 4 all.rtf", replace ///
    keep(occupancy) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)

	
* Stroke
eststo clear

foreach outcome in hha irf ltch home {

    reghdfe `outcome' occupancy $covariates if disease==1, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons

    eststo `outcome'
}

esttab hha irf ltch home using "${tables}/table 4 stroke.rtf", replace ///
    keep(occupancy) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)

	
* CHF
eststo clear

foreach outcome in hha irf ltch home {

    reghdfe `outcome' occupancy $covariates if disease==2, absorb(hsa_quarter year) vce(cluster hsa) keepsingletons

    eststo `outcome'
}

esttab hha irf ltch home using "${tables}/table 4 chf.rtf", replace ///
    keep(occupancy) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)	
	