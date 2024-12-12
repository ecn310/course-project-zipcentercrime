*** This pathway should lead to the folder where you are saving the exported data from ArcGIS
cd "C:\Users\sgortizh\OneDrive - Syracuse University\Intro to Econ Research\ArcGIS"
*** This is to log the work done by the dofile
log using "DTA log", text replace 
*** This should be the file you exported from ArcGIS
import delimited "ArcGISmdata.csv"
*** This drops any values that were further than 2500 meters from any treatment center
drop if near_dist == -1
*create new variable: dist_group: It assigns every observation in its parameter the higher end of its parameters. 
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
replace dist_group = 2250 if (near_dist <= 2250 & near_dist >2000)
replace dist_group = 2500 if (near_dist <= 2500 & near_dist >2250)
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
replace dist_group2 = 2000 if (near_dist <= 2250 & near_dist >2000)
replace dist_group2 = 2250 if (near_dist <= 2500 & near_dist >2250)
egen freq = count(near_dist), by(dist_group)
gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2)
*** ^^^
tab area
gen CallxArea = freq /area
***
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
browse
help collaspe
collapse (count) dist_group_50 dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500, by(near_fid)
***Now, normalize it***
replace dist_group_50 = dist_group_50 / 7853.981
replace dist_group_100 = dist_group_100 / 23561.95
replace dist_group_250 = dist_group_250 / 164933.6
replace dist_group_500 = dist_group_500 / 589048.6
replace dist_group_750 = dist_group_750 / 981747.7
replace dist_group_1000 = dist_group_1000 / 1374447
replace dist_group_1250 = dist_group_1250 / 1767146
replace dist_group_1500 = dist_group_1500 / 2159845
replace dist_group_1750 = dist_group_1750 / 2552544
replace dist_group_2000 = dist_group_2000 / 2945243
replace dist_group_2250 = dist_group_2250 / 3337942
replace dist_group_2500 = dist_group_2500 / 3730641
*Summary Statistics*
collapse (sum) dist_group_50 dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500
browse
summarize dist_group_50 dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500,detail
ttest dist_group_50 == dist_group_100
ttest dist_group_100 == dist_group_250
ttest dist_group_250 == dist_group_500
ttest dist_group_500 == dist_group_750
ttest dist_group_750 == dist_group_1000
ttest dist_group_1000 == dist_group_1250
ttest dist_group_1250 == dist_group_1500
ttest dist_group_1500 == dist_group_1750
ttest dist_group_1750 == dist_group_2000
clear
log close