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



*** This graph shows the decline in calls per area over the groups of distances recorded

graph bar CallxArea, over(dist_group) title("Calls by Area for Each Distance") ytitle("Calls By Area") b1title("Distance Groups")
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


*** Now we will use a paired t test to measure the statisical likelyhood that one ring will have greater median of calls compared to the next larger ring

table (command) (result), command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_100 == dist_group_250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_250 == dist_group_500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_500 == dist_group_750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_750 == dist_group_1000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1000 == dist_group_1250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1250 == dist_group_1500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1500 == dist_group_1750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1750 == dist_group_2000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2000 == dist_group_2250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2250 == dist_group_2500) nformat(%9.3f) stars(p_value 0.1 "*" 0.05 "**" 0.01 "***", shownote) name(t_test) replace
collect set t_test
collect export "Visual Graphics\t_test.tex", replace


*** This will run a ratio for each pair of distance groups

ratio (dist_group_100/dist_group_250) (dist_group_250/dist_group_500) (dist_group_500/dist_group_750) (dist_group_750/dist_group_1000) (dist_group_1000/dist_group_1250) (dist_group_1250/dist_group_1500) (dist_group_1500/dist_group_1750) (dist_group_1750/dist_group_2000) (dist_group_2000/dist_group_2250) (dist_group_2250/dist_group_2500), fvwrap(1)


*** This creates a matrix to store the results

matrix ratio_results = J(10, 6, 0)

*** This takes the numerical data from the ratio command and stores the ratio result

matrix ratio_results[1,1] = e(b)[1,1]
matrix ratio_results[2,1] = e(b)[1,2]
matrix ratio_results[3,1] = e(b)[1,3]
matrix ratio_results[4,1] = e(b)[1,4]
matrix ratio_results[5,1] = e(b)[1,5]
matrix ratio_results[6,1] = e(b)[1,6]
matrix ratio_results[7,1] = e(b)[1,7]
matrix ratio_results[8,1] = e(b)[1,8]
matrix ratio_results[9,1] = e(b)[1,9]
matrix ratio_results[10,1] = e(b)[1,10]

*** This takes the numerical data from the ratio command and stores the Standard Error

matrix ratio_results[1,2] = r(table)[2,1]
matrix ratio_results[2,2] = r(table)[2,2]
matrix ratio_results[3,2] = r(table)[2,3]
matrix ratio_results[4,2] = r(table)[2,4]
matrix ratio_results[5,2] = r(table)[2,5]
matrix ratio_results[6,2] = r(table)[2,6]
matrix ratio_results[7,2] = r(table)[2,7]
matrix ratio_results[8,2] = r(table)[2,8]
matrix ratio_results[9,2] = r(table)[2,9]
matrix ratio_results[10,2] = r(table)[2,10]

*** This takes the numerical data from the ratio command and stores the lower Confidence Interval

matrix ratio_results[1,3] = r(table)[5,1]
matrix ratio_results[2,3] = r(table)[5,2]
matrix ratio_results[3,3] = r(table)[5,3]
matrix ratio_results[4,3] = r(table)[5,4]
matrix ratio_results[5,3] = r(table)[5,5]
matrix ratio_results[6,3] = r(table)[5,6]
matrix ratio_results[7,3] = r(table)[5,7]
matrix ratio_results[8,3] = r(table)[5,8]
matrix ratio_results[9,3] = r(table)[5,9]
matrix ratio_results[10,3] = r(table)[5,10]

*** This takes the numerical data from the ratio command and stores the upper Confidence Interval

matrix ratio_results[1,4] = r(table)[6,1]
matrix ratio_results[2,4] = r(table)[6,2]
matrix ratio_results[3,4] = r(table)[6,3]
matrix ratio_results[4,4] = r(table)[6,4]
matrix ratio_results[5,4] = r(table)[6,5]
matrix ratio_results[6,4] = r(table)[6,6]
matrix ratio_results[7,4] = r(table)[6,7]
matrix ratio_results[8,4] = r(table)[6,8]
matrix ratio_results[9,4] = r(table)[6,9]
matrix ratio_results[10,4] = r(table)[6,10]

*** This takes the numerical data from the ratio command and stores the T score

matrix ratio_results[1,5] = r(table)[3,1]
matrix ratio_results[2,5] = r(table)[3,2]
matrix ratio_results[3,5] = r(table)[3,3]
matrix ratio_results[4,5] = r(table)[3,4]
matrix ratio_results[5,5] = r(table)[3,5]
matrix ratio_results[6,5] = r(table)[3,6]
matrix ratio_results[7,5] = r(table)[3,7]
matrix ratio_results[8,5] = r(table)[3,8]
matrix ratio_results[9,5] = r(table)[3,9]
matrix ratio_results[10,5] = r(table)[3,10]

*** This takes the numerical data from the ratio command and stores the P value

matrix ratio_results[1,6] = r(table)[4,1]
matrix ratio_results[2,6] = r(table)[4,2]
matrix ratio_results[3,6] = r(table)[4,3]
matrix ratio_results[4,6] = r(table)[4,4]
matrix ratio_results[5,6] = r(table)[4,5]
matrix ratio_results[6,6] = r(table)[4,6]
matrix ratio_results[7,6] = r(table)[4,7]
matrix ratio_results[8,6] = r(table)[4,8]
matrix ratio_results[9,6] = r(table)[4,9]
matrix ratio_results[10,6] = r(table)[4,10]

*** Display the results

matrix list ratio_results

*** This changes the row and column names
matrix rownames ratio_results = "100/250" "250/500" "500/750" "750/1000" "1000/1250" "1250/1500" "1500/1750" "1750/2000" "2000/2250" "2250/2500"

matrix colnames ratio_results = "Ratio" "Std. Err."

*** Export the Graph

estout matrix(ratio_results) using "Visual Graphics\ratio_results.tex", title("Ratio Analysis") replace


*** Clear any matrices stores in Stata

matrix drop _all


*** Create two new matrices for storing Confidence Interval data

matrix lci = J(11, 1, .) 
matrix uci = J(11, 1, .)  

*** List of variables to be groupped for looping

local groups dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500 

*** Begin loop by telling Stata which row to begin at

local row_index = 1
foreach var of local groups {
   *** Calculate basic statistics
   summarize `var', detail
   
   *** Mean of the variable
   local mean = r(mean)
   
   *** Standard deviation of the variable
   local sd = r(sd)
   
   *** Number of observations
   local n = r(N)
   
   *** Degrees of freedom
   local df = `n' - 1
   
   *** Calculate standard error
   local se = `sd' / sqrt(`n')
   
   *** Calculate t-critical value
   scalar t_crit = invttail(`df', 0.025)
   
   *** Calculate confidence interval
   local ci_lower = `mean' - (t_crit * `se')
   local ci_upper = `mean' + (t_crit * `se')
   
   *** Display Data to check if correct
   display "Variable: `var'"
   display "Mean: `mean'"
   display "Standard Deviation: `sd'"
   display "Number of Observations: `n'"
   display "Degrees of Freedom: `df'"
   display "Standard Error: `se'"
   display "CI Lower: `ci_lower'"
   display "CI Upper: `ci_upper'"
   
   *** Store in matrices
   matrix lci[`row_index', 1] = `ci_lower'
   matrix uci[`row_index', 1] = `ci_upper'
   
   *** Increment row index
   local row_index = `row_index' + 1
}

*** Display final matrices to check if correct

matrix list lci
matrix list uci

*** Reshape the data to be over distance instead of treatment center

reshape long dist_group_, i(near_fid) j(distance)

*** Collapse the data to be the mean number of calls at each distance

collapse (mean) dist_group_, by(distance)

*** Turn the two matrices into seperate variables 

svmat lci, names(lci)
svmat uci, names(uci)


*** Create a bar graph with confidence interval data on it

graph twoway (bar dist_group_ distance, lwidth(2)) (rcap lci1 uci1 distance, lcolor(black)),  ytitle(Mean Calls, angle(horizontal)) legend(label (1 "Mean Calls per Km^2") label(2 "Confidence Intervals"))

*** Export Graph
graph export "Visual Graphics\CI_Graph.png", replace


log close



