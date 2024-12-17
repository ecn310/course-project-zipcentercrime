/***********************************************************************
This program runs the data analysis used for our report

Created October 8, 2024

Author Weston Maechling and Sophia Oritz-Heaney
***********************************************************************/
*** This pathway should lead to the folder where you are saving the exported data from ArcGIS

cd "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package"

*** This is to log the work done by the dofile

log using "Do Files\Full_Data_log", text replace 

*** This should be the file you exported from ArcGIS

import delimited "ExtraFiles\2017_Arc_Data.csv"

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

*** This will create a group called vars for this loop to run through

local vars dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500

*** Create a blank matrix for the data to go in

matrix summary_results = J(1, 6, .)

*** Start the loop

foreach var of local vars {
   
   *** This is to summarize each variable 
    summarize `var', detail
    
    *** This will save each of the needed summary stats from the Data

    local N = r(N)
    local mean = r(mean)
    local sd = r(sd)
    local sum = r(sum)
    local min = r(min)
    local max = r(max)
    
	*** This adds the captured data into the Matrix
    
    matrix summary_results = summary_results \ (`N', `mean', `sd', `sum', `min', `max')
	}

	*** Change column and row names
matrix colnames summary_results = "Obs" "Mean" "Std. dev." "Sum" "Min" "Max"
matrix rownames summary_results = "100m" "250m" "500m" "750m" "1000m" "1250m" "1500m" "1750m" "2000m" "2250m" "2500m"

matrix summary_results = summary_results[2..rowsof(summary_results), 1..colsof(summary_results)]

matrix list summary_results

esttab using "Visual Graphics\Call_Summary_Stats.tex", replace

*** Now we will use a paired t test to measure the statisical likelyhood that one ring will have greater median of calls compared to the next larger ring

table (command) (result) , command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_100 == dist_group_250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_250 == dist_group_500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_500 == dist_group_750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_750 == dist_group_1000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_1000 == dist_group_1250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_1250 == dist_group_1500) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_1500 == dist_group_1750) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_1750 == dist_group_2000) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_2000 == dist_group_2250) command(Mean_1=r(mu_1) Mean_2=r(mu_2) Difference= (r(mu_1) -r(mu_2)) p_value = r(p): ttest dist_group_2250 == dist_group_2500) nformat(%9.3f) name(t_test) replace


*** This will change the names of the rows to be more understandable

collect label levels command 1 "100m-250m", modify
collect label levels command 2 "250m-500m", modify
collect label levels command 3 "500m-750m", modify
collect label levels command 4 "750m-1000m", modify
collect label levels command 5 "1000m-1250m", modify
collect label levels command 6 "1250m-1500m", modify
collect label levels command 7 "1500m-1750m", modify
collect label levels command 8 "1750m-2000m", modify
collect label levels command 9 "2000m-2250m", modify
collect label levels command 10 "2250m-2500m", modify

*** This formats them into the proper order 

collect layout (command[1 2 3 4 5 6 7 8 9 10]) (result) (), name(t_test)

*** This will export the table into LateX

collect set t_test
collect export "Visual Graphics\t_test.tex", replace

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
   scalar t_crit = invttail(`df', 0.05)
   
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



