********************************************************************************
    * File: table A11.do
    * Purpose: Table A11: CUE-GMM and DML-IV sensitivity models.
    * Input: analysis_main.dta
    * Output: ${output}
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************
clear
set more off

use "${analysis_data}", clear

* Absorb the published high-dimensional fixed effects before CUE and DML.
* The residualized covariates remain included in both estimators.
local residualize $outcomes snf occupancy $covariates
local residual_covariates

foreach variable of local residualize {
    quietly reghdfe `variable', absorb($absorb_main) residuals(r_`variable')
}

foreach variable of global covariates {
    local residual_covariates `residual_covariates' r_`variable'
}


* Panel A: continuously updated GMM (CUE), with the same covariates and FE.
foreach outcome of global outcomes {
    ivreg2 r_`outcome' `residual_covariates' (r_snf=r_occupancy), cue cluster(hsa) noconstant
}

* Panel B: cross-fitted DML-IV using a stacked ensemble of regularized
* regression, gradient-boosted trees, and random forests.
set seed 20250609
foreach outcome of global outcomes {
    capture ddml drop m0
    ddml init iv, kfolds(5) fcluster(hsa)
    ddml E[Y|X]: pystacked r_`outcome' `residual_covariates', ///
        type(reg) methods(lassocv ridgecv gradboost rf)
    ddml E[D|X]: pystacked r_snf `residual_covariates', ///
        type(reg) methods(lassocv ridgecv gradboost rf)
    ddml E[Z|X]: pystacked r_occupancy `residual_covariates', ///
        type(reg) methods(lassocv ridgecv gradboost rf)
    ddml crossfit
    ddml estimate, robust cluster(hsa)
}


