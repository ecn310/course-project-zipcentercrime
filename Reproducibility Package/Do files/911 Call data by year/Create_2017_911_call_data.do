/***********************************************************************
This program proccesses our raw 911 call data to limit the data to only calls made in 2017.

Created October 8, 2024

Author Rachel Gaudreau

Updated December 5, 2024 RG
***********************************************************************/
* Set cd to computer path where the calls_final.csv file is saved and import the raw data
cd "C:\Users\regaudre\OneDrive - Syracuse University\documents"
import delimited "calls_final", clear 

* Create specific year variable
gen year = call_timestamp
replace year = substr(year, 1, 4)

* Delete all calls made in years other than 2017
keep if year == "2017"

* Save 2017 911 call data for later use
save "documents\2017_911_call_data"