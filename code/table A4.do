********************************************************************************
    * File: table A4.do
    * Purpose: Table A4: IV validity checks using quality-related outcomes.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

eststo clear

reghdfe nursing_hours occupancy $covariates if snf==1, absorb($absorb_main) vce(cluster hsa) keepsingletons
eststo ols_nursing_hours

reghdfe quality_rating occupancy $covariates if snf==1, absorb($absorb_main) vce(cluster hsa) keepsingletons
eststo ols_quality_rating

reghdfe hospital_los occupancy $covariates, absorb($absorb_main) vce(cluster hsa) keepsingletons
eststo ols_hospital_los

esttab ols_nursing_hours ols_quality_rating ols_hospital_los ///
    using "${tables}/table A4.rtf", ///
    replace keep(occupancy) ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    stats(N) ///
    star(* .10 ** .05 *** .01)
	
	
	