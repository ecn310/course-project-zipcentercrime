*open dataset use 
use "C:\Users\sgortizh\Downloads\detroit_samhsa_sud_2015_2021 (2).dta"
browse
*run some summary statistics for year - I don't have the export commands in year
sum year
tab year
histogram year 
*run some summary statistics for zipcodes
sum zip
tab zip
histogram zip 
*find the disctinct name for SATC and their primary services
ssc install distinct 
distinct name 
distinct service1

