********************************************************************************
    * File: master.do
    * Purpose: Master replication script
	* Author: Geng, Gong, Gozalo, and Grabowski
    ********************************************************************************

clear all
set more off
    
do "${code}/config.do"

do "${code}/figure 1.do"
do "${code}/table 1.do"
do "${code}/table 2.do"
do "${code}/table 3.do"
do "${code}/table 4.do"
do "${code}/table 5.do"
do "${code}/table 6.do"

do "${code}/figure A2.do"
do "${code}/table A1.do"
do "${code}/table A2.do"
do "${code}/table A3.do"
do "${code}/table A4.do"
do "${code}/table A5.do"
do "${code}/table A6.do"
do "${code}/table A7.do"
do "${code}/table A8.do"
do "${code}/table A9.do"
do "${code}/table A10.do"
do "${code}/table A11.do"
do "${code}/table A12.do"
