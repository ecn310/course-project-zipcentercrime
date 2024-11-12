cd "C:\Users\wrmaechl\OneDrive - Syracuse University\"
import delimited "NewData2.csv"
drop if near_dist == -1
gen dist_group = 50 if near_dist <= 50
replace dist_group = 100 if (near_dist <= 100 & near_dist >50)
replace dist_group = 250 if (near_dist <= 250 & near_dist >100)
replace dist_group = 500 if (near_dist <= 500 & near_dist >250)
replace dist_group = 750 if (near_dist <= 750 & near_dist >500)
replace dist_group = 1000 if (near_dist <= 1000 & near_dist >750)
gen dist_group2 = 0 if near_dist <= 50
replace dist_group2 = 50 if (near_dist <= 100 & near_dist >50)
replace dist_group2 = 100 if (near_dist <= 250 & near_dist >100)
replace dist_group2 = 250 if (near_dist <= 500 & near_dist >250)
replace dist_group2 = 500 if (near_dist <= 750 & near_dist >500)
replace dist_group2 = 750 if (near_dist <= 1000 & near_dist >750)
egen freq = count(near_dist), by(dist_group)
gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2)
gen Call_by_Area = freq / area
table near_fid dist_group
