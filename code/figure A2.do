********************************************************************************
	* File: figure A2.do
	* Purpose: Figure A2: baseline and alternative 2SLS specifications.
	* Input: analysis_main.dta
	* Output: ${figures}/figure A2.png
	* Author: Geng, Gong, Gozalo, and Grabowski

********************************************************************************

clear
set more off

use "${analysis_data}", clear

tempfile figure_a2_results
tempname results
postfile `results' byte specification str12 outcome double estimate se first_stage_f ///
    using `figure_a2_results', replace

forvalues specification = 1/5 {
    local controls ""
    local fixed_effects "$absorb_main"

    if `specification' == 2 local controls "$patient_covariates"
    if `specification' >= 3 local controls "$covariates"
    if `specification' == 4 local fixed_effects "hsa_quarter state_year disease"
    if `specification' == 5 local fixed_effects "hsa_quarter state_year month_year disease"

    foreach outcome of global outcomes {
        quietly ivreghdfe `outcome' `controls' (snf = occupancy), ///
            absorb(`fixed_effects') cluster(hsa) keepsingletons

        local iv_estimate = _b[snf]
        local iv_se = _se[snf]
        tempvar iv_sample
        generate byte `iv_sample' = e(sample)

        quietly reghdfe snf occupancy `controls' if `iv_sample', ///
            absorb(`fixed_effects') vce(cluster hsa) keepsingletons

        quietly test occupancy
        local first_stage_f = r(F)

        post `results' (`specification') ("`outcome'") ///
            (`iv_estimate') (`iv_se') (`first_stage_f')
        drop `iv_sample'
    }
}
postclose `results'

use `figure_a2_results', clear

generate lower = estimate - invnormal(.975) * se
generate upper = estimate + invnormal(.975) * se
generate plot_order = 6 - specification

label define specification_order ///
    5 "Alt model 1" ///
    4 "Alt model 2" ///
    3 "{bf:Baseline}" ///
    2 "Alt model 3" ///
    1 "Alt model 4"
label values plot_order specification_order

format estimate %9.4f

twoway ///
    (rcap lower upper plot_order if outcome == "readmit30", horizontal ///
        lcolor(blue*1.2) lwidth(medium)) ///
    (scatter plot_order estimate if outcome == "readmit30", ///
        msymbol(O) msize(*0.8) mcolor(blue*1.2) ///
        mlabel(estimate) mlabposition(12) mlabgap(*2.5) ///
        mlabformat(%9.4f) mlabcolor(blue*1.2)), ///
    ylabel(1/5, valuelabel nogrid labsize(*1.1)) ///
    yscale(range(0.75 5.25)) ytitle("") ///
    xline(0, lcolor(gs8) lpattern(dash)) ///
    xlabel(-0.04(0.02)0.08, nogrid labsize(*1.1)) ///
    xscale(range(-0.04 0.09)) ///
    xtitle("30-day rehospitalization rate") ///
    legend(off) scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_a2_readmit, replace)

twoway ///
    (rcap lower upper plot_order if outcome == "mortality30", horizontal ///
        lcolor(red*1.2) lwidth(medium)) ///
    (scatter plot_order estimate if outcome == "mortality30", ///
        msymbol(T) msize(*0.8) mcolor(red*1.2) ///
        mlabel(estimate) mlabposition(12) mlabgap(*2.5) ///
        mlabformat(%9.4f) mlabcolor(red*1.2)), ///
    ylabel(1/5, valuelabel nogrid labsize(*1.1)) ///
    yscale(range(0.75 5.25)) ytitle("") ///
    xline(0, lcolor(gs8) lpattern(dash)) ///
    xlabel(-0.04(0.02)0.08, nogrid labsize(*1.1)) ///
    xscale(range(-0.04 0.09)) ///
    xtitle("30-day mortality rate") ///
    legend(off) scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_a2_mortality, replace)

generate first_stage_label = string(first_stage_f, "%9.2f")
generate first_stage_x = 11000

twoway ///
    (rcap lower upper plot_order if outcome == "pac_spending", horizontal ///
        lcolor(green*1.2) lwidth(medium)) ///
    (scatter plot_order estimate if outcome == "pac_spending", ///
        msymbol(S) msize(*0.8) mcolor(green*1.2) ///
        mlabel(estimate) mlabposition(12) mlabgap(*2.5) ///
        mlabformat(%9.1f) mlabcolor(green*1.2)) ///
    (scatter plot_order first_stage_x if outcome == "pac_spending", ///
        msymbol(none) mlabel(first_stage_label) mlabposition(0) ///
        mlabcolor(black) mlabsize(*0.85)), ///
    ylabel(1/5, valuelabel nogrid labsize(*1.1)) ///
    yscale(range(0.75 5.55)) ytitle("") ///
    xline(0, lcolor(gs8) lpattern(dash)) ///
    xlabel(0(2000)10000, nogrid labsize(*1.1)) ///
    xscale(range(0 12000)) ///
    xtitle("Medicare spending") ///
    text(5.48 11000 "First-stage" "F-statistic", place(c) ///
        color(black) size(*0.85) linegap(1.1)) ///
    legend(off) scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_a2_spending, replace)

graph combine figure_a2_readmit figure_a2_mortality figure_a2_spending, ///
    cols(3) graphregion(color(white)) xsize(12) ysize(6)

graph export "${figures}/figure A2.png", width(3000) replace


