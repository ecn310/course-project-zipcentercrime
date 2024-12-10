/***********************************************************************
This program proccesses our raw Treatment Center data to limit the data to only centers open in 2017.

Created October 8, 2024

Author Rachel Gaudreau

Updated December 10, 2024 RG
***********************************************************************/
* Set cd to computer path to where the zipcentercrime GitHub repository is stored to import the raw data
cd "C:\Users\regaudre\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package"
use "RawData\detroit_samhsa_sud_2015_2021.dta", clear

* Open log to track the work done by the do-file
log using "TreatmentCenterLog", text replace

*Delete all other treatment center data from all years other than 2017
keep if year == 2017

*Save 2017 treatment center data for later use
save "Data by year\Treatment center data by year\2017_treatment_center_data"

* Close log
log close
