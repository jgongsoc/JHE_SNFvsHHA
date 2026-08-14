********************************************************************************
    * File: table A1.do
    * Purpose: Table A1: first post-acute discharge locations.
    * Input: analysis_destinations.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${destination_data}", clear

local destinations snf hha irf ltch home
tempname results
postfile `results' str20 destination all stroke chf using "${temp}/tableA1.dta", replace
foreach destination of local destinations {
    summarize `destination'
    local all=r(mean)
    
	summarize `destination' if disease==1
    local stroke=r(mean)
    
	summarize `destination' if disease==2
    local chf=r(mean)
    
	post `results' ("`destination'") (`all') (`stroke') (`chf')
}
postclose `results'

use "${temp}/tableA1.dta", clear
export excel using "${tables}/table A1.xlsx", firstrow(variables) replace

