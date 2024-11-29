import delimited "C:\Users\regaudre\OneDrive - Syracuse University\calls_final", clear 

gen year = call_timestamp
replace year = substr(year, 1, 4)


cd "C:\Users\regaudre\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime"
save "Data by year\911 call data by year\2016_911_call_data", replace

keep if year == "2016"

save "Data by year\911 call data by year\2016_911_call_data", replace
