*** This pathway should lead to the folder where you are saving the exported data from ArcGIS
cd "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package"
*** This is to log the work done by the dofile
log using "DTA log", text replace 
*** This should be the file you exported from ArcGIS
import delimited "DTA.csv"
*** This drops any values that were further than 2500 meters from any treatment center
drop if near_dist == -1
gen dist_group = 50 if near_dist <= 50
replace dist_group = 100 if (near_dist <= 100 & near_dist >50)
replace dist_group = 250 if (near_dist <= 250 & near_dist >100)
replace dist_group = 500 if (near_dist <= 500 & near_dist >250)
replace dist_group = 750 if (near_dist <= 750 & near_dist >500)
replace dist_group = 1000 if (near_dist <= 1000 & near_dist >750)
replace dist_group = 1250 if (near_dist <= 1250 & near_dist >1000)
replace dist_group = 1500 if (near_dist <= 1500 & near_dist >1250)
replace dist_group = 1750 if (near_dist <= 1750 & near_dist >1500)
replace dist_group = 2000 if (near_dist <= 2000 & near_dist >1750)
*** May Be Useless for now 
gen dist_group2 = 0 if near_dist <= 50
replace dist_group2 = 50 if (near_dist <= 100 & near_dist >50)
replace dist_group2 = 100 if (near_dist <= 250 & near_dist >100)
replace dist_group2 = 250 if (near_dist <= 500 & near_dist >250)
replace dist_group2 = 500 if (near_dist <= 750 & near_dist >500)
replace dist_group2 = 750 if (near_dist <= 1000 & near_dist >750)
replace dist_group2 = 1000 if (near_dist <= 1250 & near_dist >1000)
replace dist_group2 = 1250 if (near_dist <= 1500 & near_dist >1250)
replace dist_group2 = 1500 if (near_dist <= 1750 & near_dist >1500)
replace dist_group2 = 1750 if (near_dist <= 2000 & near_dist >1750)
egen freq = count(near_dist), by(dist_group)
gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2)
*** ^^^
gen dist_group_50 = 50 if near_dist <= 50
gen dist_group_100 = 100 if (near_dist <= 100 & near_dist >50)
gen dist_group_250 = 250 if (near_dist <= 250 & near_dist >100)
gen dist_group_500 = 500 if (near_dist <= 500 & near_dist >250)
gen dist_group_750 = 750 if (near_dist <= 750 & near_dist >500)
gen dist_group_1000 = 1000 if (near_dist <= 1000 & near_dist >750)
gen dist_group_1250 = 1250 if (near_dist <= 1250 & near_dist >1000)
gen dist_group_1500 = 1500 if (near_dist <= 1500 & near_dist >1250)
gen dist_group_1750 = 1750 if (near_dist <= 1750 & near_dist >1500)
gen dist_group_2000 = 2000 if (near_dist <= 2000 & near_dist >1750)
gen dist_group_2250 = 2250 if (near_dist <= 2250 & near_dist >2000)
gen dist_group_2500 = 2500 if (near_dist <= 2500 & near_dist >2250)
collapse (count) dist_group_50 dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000, by(near_fid)
summarize dist_group_50 dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000,detail
ttest dist_group_50 == dist_group_100
ttest dist_group_100 == dist_group_250
ttest dist_group_250 == dist_group_500
ttest dist_group_500 == dist_group_750
ttest dist_group_750 == dist_group_1000
ttest dist_group_1000 == dist_group_1250
ttest dist_group_1250 == dist_group_1500
ttest dist_group_1500 == dist_group_1750
ttest dist_group_1750 == dist_group_2000
log close