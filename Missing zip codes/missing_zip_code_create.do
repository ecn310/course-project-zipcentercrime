/***********************************************************************
This program creates a data set of only the observations with missing zip codes from the 911 call data (detroit_samhsa_sud_2015_2021.csv)

Lines that start with one asterisk explain what the next line of code does.

Created October 8, 20245

Author Rachel Gaudreau

Updated Oct 29, 2024 RG
***********************************************************************/

* To make import the .csv file and create the new data file make sure to change the computer path
import delimited "C:\Users\regaudre\OneDrive - Syracuse University\calls_final", clear 
save "C:\Users\regaudre\OneDrive - Syracuse University\missing_zip_code_calls", replace

* Remove observations which already have zip codes listed
drop if substr(zip_code, 1, 2) == "48"

* Replace any zip codes listed as "0" as missing 
replace zip_code = "" if trim(zip_code) == "0"

*Save as new, seperate data set
save "C:\Users\regaudre\OneDrive - Syracuse University\missing_zip_code_calls", replace