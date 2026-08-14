********************************************************************************
    * File: table A3.do
    * Purpose: Table A3: placebo first-stage F-statistics at alternate dates.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

local instruments occupancy_lag365 occupancy_lead365 occupancy_lag1 occupancy_lead1

tempname results
postfile `results' str24 timing ///
    double all double stroke double chf ///
    using "${temp}/tableA3.dta", replace

foreach instrument of local instruments {
    foreach cohort in all stroke chf {
        local restriction ""
        local absorb "$absorb_main"
        if "`cohort'"=="stroke" {
            local restriction "if disease==1"
            local absorb "hsa_quarter year"
        }
        if "`cohort'"=="chf" {
            local restriction "if disease==2"
            local absorb "hsa_quarter year"
        }
        reghdfe snf `instrument' $covariates `restriction', absorb(`absorb') vce(cluster hsa) keepsingletons
        test `instrument'
        local F_`cohort'=r(F)
    }
    post `results' ("`instrument'") (`F_all') (`F_stroke') (`F_chf')
}
postclose `results'

use "${temp}/tableA3.dta", clear
export excel using "${tables}/table A3.xlsx", firstrow(variables) replace

