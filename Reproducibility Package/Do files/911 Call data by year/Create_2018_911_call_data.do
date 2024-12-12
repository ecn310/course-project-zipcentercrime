import delimited "C:\Users\regaudre\OneDrive - Syracuse University\calls_final", clear 

gen year = call_timestamp
replace year = substr(year, 1, 4)


cd "C:\Users\regaudre\OneDrive - Syracuse University\Documents"
save "2018_911_call_data", replace

keep if year == "2018"

save "2018_911_call_data", replace
