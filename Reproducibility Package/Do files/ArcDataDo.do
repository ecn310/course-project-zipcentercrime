/***********************************************************************
This program runs the data analysis used for our report

Created October 8, 2024

Author Weston Maechling and Sophia Oritz-Heaney
***********************************************************************/
*** This pathway should lead to the folder where you are saving the exported data from ArcGIS

cd "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package"

*** This is to log the work done by the dofile

log using "Data_log", text replace 

*** This should be the file you exported from ArcGIS

import delimited "2017_Arc_Data.csv"

*** This drops any values that were further than 2500 meters from any treatment center

drop if near_dist == -1

*** this is install programs that are usefull in exporting tables

ssc install outreg2
ssc install estout

*** these commands seperate the data points from ArcGIS into groups based on their calculated distance to the nearest treatment center in meters

gen dist_group = 100 if near_dist <= 100 
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

*** these commands are used to make a second variable that is one distance size smaller than its actrual group which allows us to calculate the difference in area between the two radii

gen dist_group2 = 0 if near_dist <= 100 
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
replace dist_group2 = 2500 if (near_dist <= 2750 & near_dist >2500)

*** this uses the two distance groups calculated above as radii to find the area of that circle and subtract the area of the smaller adjecent circle to calculate the total area of the ring that those calls came from to standardize the data as Calls per Area

egen freq = count(near_dist), by(dist_group)
gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2) 

*** This is used to get the exact amount of area so that we can divide our count of calls for each distance group once we collapse the data on line 71

tab area 

*** taking that difference in area and dividing the amount of calls in that specific distance group by the new ring of area will give us the number of calls per the increase in area from one ring to the next largest

gen CallxArea = freq / area

*** these commands create new seperate variables for each distance group 

gen dist_group_100 = 1 if near_dist <= 100
gen dist_group_250 = 1 if (near_dist <= 250 & near_dist >100)
gen dist_group_500 = 1 if (near_dist <= 500 & near_dist >250)
gen dist_group_750 = 1 if (near_dist <= 750 & near_dist >500)
gen dist_group_1000 = 1 if (near_dist <= 1000 & near_dist >750)
gen dist_group_1250 = 1 if (near_dist <= 1250 & near_dist >1000)
gen dist_group_1500 = 1 if (near_dist <= 1500 & near_dist >1250)
gen dist_group_1750 = 1 if (near_dist <= 1750 & near_dist >1500)
gen dist_group_2000 = 1 if (near_dist <= 2000 & near_dist >1750)
gen dist_group_2250 = 1 if (near_dist <= 2250 & near_dist >2000)
gen dist_group_2500 = 1 if (near_dist <= 2500 & near_dist >2250)

mkat dist_group, matrix(dist)

*** This graph shows the decline in calls per area over the groups of distances recorded

graph bar CallxArea, over(dist_group) title("Calls by Area for Each Distance") ytitle("Calls By Area") b1title("Distance Groups")
graph save graph.gph, replace
graph export "Visual Graphics\Calls_Distance.png", replace

*** This command colapses our data down, Using the various variables we created for each seperate distance groups we can now collapse the data by the count of how many of our observations are within each individual distance groups by the id number for the treatment center it was nearest.

collapse (count) dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500, by(near_fid)

*** once our data is collapsed we use these commands to standardize the number of calls by the areas of the rings we calculated previously 

replace dist_group_100 = (dist_group_100 / 31415.9265) * 1000000
replace dist_group_250 = (dist_group_250 / 164933.6143) * 1000000
replace dist_group_500 = (dist_group_500 / 589048.6225) * 1000000
replace dist_group_750 = (dist_group_750 / 981747.7042) * 1000000
replace dist_group_1000 = (dist_group_1000 / 1374446.786) * 1000000
replace dist_group_1250 = (dist_group_1250 / 1767145.868) * 1000000
replace dist_group_1500 = (dist_group_1500 / 2159844.949) * 1000000
replace dist_group_1750 = (dist_group_1750 / 2552544.031) * 1000000
replace dist_group_2000 = (dist_group_2000 / 2945243.113) * 1000000
replace dist_group_2250 = (dist_group_2250 / 3337942.194) * 1000000
replace dist_group_2500 = (dist_group_2500 / 3730641.276) * 1000000

***Find the average of total number of calls in each distance group and collapse the data
collapse (mean) dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500

***Bar Graph the Results
graph bar dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500, title("Mean Calls") ytitle("Calls/km^2") b1title("Mean Calls in Each Distance Group")
graph save graph.gph, replace

*** Now we will use a paired t test to measure the statisical likelyhood that one ring will have greater median of calls compared to the next larger ring
rename dist_group_100 Dat01_dist_group_100
rename dist_group_250 Dat02_dist_group_250
rename dist_group_500 Dat03_dist_group_500
rename dist_group_750 Dat04_dist_group_750
rename dist_group_1000 Dat05_dist_group_1000
rename dist_group_1250 Dat06_dist_group_1250
rename dist_group_1500 Dat07_dist_group_1500
rename dist_group_1750 Dat08_dist_group_1750
rename dist_group_2000 Dat09_dist_group_2000
rename dist_group_2250 Dat10_dist_group_2250
rename dist_group_2500 Dat11_dist_group_2500

global DatVars"Dat01_dist_group_100 Dat02_dist_group_250 Dat03_dist_group_500 Dat04_dist_group_750 Dat05_dist_group_1000 Dat06_dist_group_1250 Dat07_dist_group_1500 Dat08_dist_group_1750 Dat09_dist_group_2000 Dat10_dist_group_2250 Dat11_dist_group_2500"         
local nvars : word count $DatVars
forval i = 1/`nvars'-1 {
	local var1: word `i' of $DatVars
	local var2: word `=`i'+1' of $DatVars
	ttest `var1' == `var2'
}




foreach pair in $DatVars {
	local prevar: word `i' of $DatVars
	local postvar: word `=`i'+1' of $DatVars
	ttest `prevar' == `postvar'   
estimates store `var'}     
            
      
      //Graph with signficance 
      twoway      (bar  LabMatAll Question if HH_MotherRespond==1&running<=11, bcolor(orange) sort(LabMatAll)) ///
                  (bar  LabMatAll Question if HH_MotherRespond==0&running<=11, bcolor(ltblue)) ///                
                  (rcap LabMatAllhi LabMatAlllow Question if HH_MotherRespond==0&running<=11, lcolor(black))  /// 
                  (rcap LabMatAllhi LabMatAlllow Question if HH_MotherRespond==1&running<=12, lcolor(black)) ///
                        xlabel(1 4 7 10 13 16 19 22 25 28 31 , valuelabe angle(60)) ///
                  ytitle("Strongly agree/Agree") ///
            legend( order(  1 "Mother" 2 "Father") )


global dist_group_Vars "dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500" 


table (command) (result), command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_100 == dist_group_250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_250 == dist_group_500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_500 == dist_group_750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_750 == dist_group_1000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1000 == dist_group_1250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1250 == dist_group_1500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1500 == dist_group_1750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1750 == dist_group_2000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2000 == dist_group_2250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2250 == dist_group_2500) nformat(9.3f) stars(p_value 0.1 "*" 0.05 "**" 0.01 "***", shownote)  name(t_test) replace
collect set t_test
collect export "Visual Graphics\t_test.tex", replace



*** This test shows the sum of each variable divided by the sum of the next largest variable to show an estimate of how many more or less calls you can expect going from one ring to an adjecent one

ratio (dist_group_100/dist_group_250) (dist_group_250/dist_group_500) (dist_group_500/dist_group_750) (dist_group_750/dist_group_1000) (dist_group_1000/dist_group_1250) (dist_group_1250/dist_group_1500) (dist_group_1500/dist_group_1750) (dist_group_1750/dist_group_2000) (dist_group_2000/dist_group_2250) (dist_group_2250/dist_group_2500), fvwrap(1) 

matrix ci = J(2, 10, 0)


matrix ci[1,1] = r(table)[5,1]
matrix ci[1,2] = r(table)[5,2]
matrix ci[1,3] = r(table)[5,3]
matrix ci[1,4] = r(table)[5,4]
matrix ci[1,5] = r(table)[5,5]
matrix ci[1,6] = r(table)[5,6]
matrix ci[1,7] = r(table)[5,7]
matrix ci[1,8] = r(table)[5,8]
matrix ci[1,9] = r(table)[5,9]
matrix ci[1,10] = r(table)[5,10]


matrix ci[2,1] = r(table)[6,1]
matrix ci[2,2] = r(table)[6,2]
matrix ci[2,3] = r(table)[6,3]
matrix ci[2,4] = r(table)[6,4]
matrix ci[2,5] = r(table)[6,5]
matrix ci[2,6] = r(table)[6,6]
matrix ci[2,7] = r(table)[6,7]
matrix ci[2,8] = r(table)[6,8]
matrix ci[2,9] = r(table)[6,9]
matrix ci[2,10] = r(table)[6,10]


matrix colnames ci = "100/250" "250/500" "500/750" "750/1000" "1000/1250" "1250/1500" "1500/1750" "1750/2000" "2000/2250" "2250/2500"

matrix rownames ci = "lci" "uci"


matrix list ci

graph twoway (bar dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000) (rcap ci[1,1] ci[1,2] dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000)


esttab matrix(ratio_results) using "Visual Graphics\ratio_results.tex", title("Ratio Analysis") replace latex




log close



