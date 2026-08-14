********************************************************************************
    * File: table 6.do
    * Purpose: Table 6: 2SLS heterogeneity by market/neighborhood.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************

clear
set more off

use "${analysis_data}", clear

summarize zip_income, detail
generate high_income = zip_income > r(p50) if !missing(zip_income)

* Panel A1: States with CON
reghdfe snf occupancy $covariates if con_state==1, absorb($absorb_main) vce(cluster hsa) keepsingletons
test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if con_state==1, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 con_state_1.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)


* Panel A2: States without CON
reghdfe snf occupancy $covariates if con_state==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if con_state==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 con_state_0.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)

* Panel B1: Rural areas
reghdfe snf occupancy $covariates if rural==1, absorb($absorb_main) vce(cluster hsa) keepsingletons

test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if rural==1, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 rural_1.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)

	
* Panel B2: Urban areas
reghdfe snf occupancy $covariates if rural==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if rural==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 rural_0.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)
	
	
* Panel C1: Low-income neighborhoods
reghdfe snf occupancy $covariates if high_income==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if high_income==0, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 high_income_0.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)

	
* Panel C2: High-income neighborhoods
reghdfe snf occupancy $covariates if high_income==1, absorb($absorb_main) vce(cluster hsa) keepsingletons

test occupancy
local first_stage_F = r(F)

eststo clear

foreach outcome of global outcomes {

    ivreghdfe `outcome' $covariates (snf = occupancy) if high_income==1, absorb($absorb_main) vce(cluster hsa) keepsingletons

    estadd scalar first_stage_F = `first_stage_F'
    eststo `outcome'
}

esttab readmit30 mortality30 pac_spending ///
    using "${tables}/table 6 high_income_1.rtf", replace ///
    keep(snf) ///
    cells(b(star fmt(4)) se(par fmt(4))) ///
    stats(first_stage_F N, ///
        labels("First-stage F-statistic" "Observations")) ///
    star(* .10 ** .05 *** .01)	
	
	

