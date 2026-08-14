********************************************************************************
    * File: table A2.do
    * Purpose: Table A2: 2017 HSA characteristics by occupancy quartile.
    * Input: analysis_market_2017.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${market_data}", clear

xtile occupancy_quartile=occupancy, nq(4)

local characteristics ma_beneficiaries ma_share snf_count hha_count hospital_count ///
    aco_beneficiaries aco_share rn_lpn_hours zip_income sdi share_age65 ///
    snf_beds snf_forprofit_share snf_rating snf_fivestar_share ///
    hha_rating hha_fivestar_share hospital_rating
collapse (mean) `characteristics' (count) hsa_count=hsa, by(occupancy_quartile)
export excel using "${tables}/table A2.xlsx", firstrow(variables) replace

