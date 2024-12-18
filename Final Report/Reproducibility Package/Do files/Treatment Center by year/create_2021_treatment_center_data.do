cd "C:\Users\regaudre\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime"
use "detroit_samhsa_sud_2015_2021"
save "Data by year\Treatment center data by year\2021_treatment_center_data", replace

keep if year == 2021

save "Data by year\Treatment center data by year\2021_treatment_center_data", replace
