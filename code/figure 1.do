********************************************************************************
	* File: figure 1.do
	* Purpose: Figure 1: descriptive statistics for the SNF occupancy instrument.
	* Input: analysis_main.dta
	* Output: ${figures}/three component panels.
	* Author: Geng, Gong, Gozalo, and Grabowski
	
********************************************************************************

clear
set more off

use "${analysis_data}", clear
keep hsa discharge_date year occupancy
drop if missing(hsa)|missing(discharge_date)|missing(year)|missing(occupancy)

collapse (mean) occupancy, by(hsa discharge_date year)

tempfile hsa_day
save `hsa_day'

summarize occupancy, detail
local occupancy_mean_value = r(mean)
local occupancy_mean = string(r(mean), "%5.3f")
local occupancy_min  = string(r(min), "%5.3f")
local occupancy_max  = string(r(max), "%5.3f")

* Panel A
histogram occupancy, density start(0) bin(30) ///
    fcolor(orange%90) lcolor(white) lwidth(vthin) ///
    xline(`occupancy_mean_value', lcolor(red*1.2) lwidth(medthick) ///
        lpattern(shortdash)) ///
    xlabel(0(.2)1, nogrid) ylabel(, nogrid) ///
    xtitle("SNF bed occupancy rate") ytitle("Density") ///
    title("") ///
    text(3.5 .40 "Mean value of" "occupancy rate" ///
        "`occupancy_mean' (min `occupancy_min', max `occupancy_max')", ///
        place(c) size(3.25) color(black) linegap(.8)) ///
    scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_1a, replace)

graph export "${figures}/figure 1a.png", width(3000) replace

* Panel B
use `hsa_day', clear
keep if inrange(year, 2013, 2017)
collapse (mean) occupancy, by(discharge_date year)

generate day_of_year = discharge_date - mdy(1, 1, year) + 1
bysort day_of_year: egen occupancy_mean = mean(occupancy)
egen mean_tag = tag(day_of_year)

twoway ///
    (line occupancy day_of_year if year == 2013, lcolor(gs11) lwidth(vthin)) ///
    (line occupancy day_of_year if year == 2014, lcolor(gs11) lwidth(vthin)) ///
    (line occupancy day_of_year if year == 2015, lcolor(gs11) lwidth(vthin)) ///
    (line occupancy day_of_year if year == 2016, lcolor(gs11) lwidth(vthin)) ///
    (line occupancy day_of_year if year == 2017, lcolor(gs11) lwidth(vthin)) ///
    (line occupancy_mean day_of_year if mean_tag, ///
        lcolor(gs4) lwidth(thick)), ///
    legend(order(6 "Mean: 2013-2017" 1 "Each year") ///
        ring(0) position(2) cols(1) rowgap(.5)) ///
    ylabel(.3(.1).8, nogrid) ///
    xlabel(14 "Jan" 46 "Feb" 74 "Mar" 105 "Apr" 135 "May" 166 "Jun" ///
        196 "Jul" 227 "Aug" 258 "Sep" 288 "Oct" 319 "Nov" 350 "Dec", ///
        nogrid) ///
    xscale(range(1 366) extend) ///
    xtitle("Date") ytitle("SNF bed occupancy rate") ///
    title("") ///
    scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_1b, replace)

graph export "${figures}/figure 1b.png", width(3000) replace

* Panel C
use `hsa_day', clear
keep if hsa == 22009 & year == 2017
generate day_of_year = discharge_date - mdy(1, 1, year) + 1
sort day_of_year

twoway ///
    (line occupancy day_of_year, lcolor(gs6) lwidth(thin)), ///
    legend(off) ///
    ylabel(.3(.1).8, nogrid) ///
    xlabel(14 "Jan" 46 "Feb" 74 "Mar" 105 "Apr" 135 "May" 166 "Jun" ///
        196 "Jul" 227 "Aug" 258 "Sep" 288 "Oct" 319 "Nov" 350 "Dec", ///
        nogrid) ///
    xscale(range(1 365) extend) ///
    xtitle("Date") ytitle("SNF bed occupancy rate") ///
    title("") ///
        "22009 (Cambridge, MA) in 2017", position(11) span size(medsmall)) ///
    scheme(plotplain) graphregion(color(white)) bgcolor(white) ///
    name(figure_1c, replace)

graph export "${figures}/figure 1c.png", width(3000) replace

