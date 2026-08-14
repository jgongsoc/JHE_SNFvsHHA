********************************************************************************
    * File: config.do
    * Purpose: Project paths and shared model definitions.
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************

clear 
set more off
set maxvar 32767


global project_root "" // Edit this line to the environment path
global code   "${project_root}/code"
global data   "${project_root}/data"
global temp   "${project_root}/temp"
global output "${project_root}/output"
global figures "${output}/figures"
global tables  "${output}/tables"

capture mkdir "${temp}"
capture mkdir "${output}"
capture mkdir "${figures}"
capture mkdir "${tables}"

global analysis_data "${data}/analysis_main.dta"
global destination_data "${data}/analysis_destinations.dta"
global market_data "${data}/analysis_market_2017.dta"
global threshold_data "${data}/analysis_market_thresholds.dta"

* Covariates 
global patient_covariates age female white black zip_income dual_full dual_partial ///
    ihd copd diabetes prostate_cancer lung_cancer colorectal_cancer breast_cancer ///
    organ_transplant hyperlipidemia adrd osteoporosis rheumatoid_arthritis ///
    heart_valve_disorder pulmonary_circulation_disorder hypertension ///
    neurological_disorder chronic_lung_disease hypothyroidism renal_failure ///
    tumor coagulation_disorder anemia weight_loss obesity ///
    elixhauser_mortality elixhauser_readmission distance_irf_km
global market_covariates ma_penetration aco_share quality_rating
global covariates $patient_covariates $market_covariates
global outcomes readmit30 mortality30 pac_spending

* Baseline fixed effects and inference: HSA-by-quarter, year, disease;
* heteroskedasticity-robust standard errors clustered by HSA.
global absorb_main hsa_quarter year disease

