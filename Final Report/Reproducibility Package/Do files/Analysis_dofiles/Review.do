*** First, connect the pathway to where all these files are stored

cd "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package"

*** Then, start log 

log using "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package\Do files\Analysis_dofiles\DifferentRingDistances.log"

*** Then, import the dataset

 import delimited "ExtraFiles\2017_Arc_Data.csv"
 
*** Then, drop any values that were further than 2500 meters from any treatment center

drop if near_dist == -1

ssc install outreg2
ssc install estout

*** Then, create the distance rings. This is the farther bound of the distance ring

gen dist_group = 250 if near_dist <= 250
replace dist_group = 500 if (near_dist <= 500 & near_dist >250)
replace dist_group = 750 if (near_dist <= 750 & near_dist >500)
replace dist_group = 1000 if (near_dist <= 1000 & near_dist >750)
replace dist_group = 1250 if (near_dist <= 1250 & near_dist >1000)
replace dist_group = 1500 if (near_dist <= 1500 & near_dist >1250)
replace dist_group = 1750 if (near_dist <= 1750 & near_dist >1500)
replace dist_group = 2000 if (near_dist <= 2000 & near_dist >1750)
replace dist_group = 2250 if (near_dist <= 2250 & near_dist >2000)
replace dist_group = 2500 if (near_dist <= 2500 & near_dist >2250)
*** Then, create the lower bound of the distance rings. 

gen dist_group2 = 0 if near_dist <= 250 
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

*** At this point, every call has an assigned SATC, The distance it is from that SATC, and a assigned upperbound distance ring and lowerbound distance ring. 
***Now, we count up the amount of observations per assigned dist_group and identify that number. 

egen freq = count(near_dist), by(dist_group)

***Then, we found the area for each respective group

gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2) 

*** taking that difference in area and dividing the amount of calls in that specific distance group by the new ring of area will give us the number of calls per the increase in area from one ring to the next largest, to standardize the total calls by their repestive area sizes

gen CallxArea = freq / area

***these commands create new seperate variables for each distance group 
gen dist_group_250 = 1 if near_dist <= 250
gen dist_group_500 = 1 if (near_dist <= 500 & near_dist >250)
gen dist_group_750 = 1 if (near_dist <= 750 & near_dist >500)
gen dist_group_1000 = 1 if (near_dist <= 1000 & near_dist >750)
gen dist_group_1250 = 1 if (near_dist <= 1250 & near_dist >1000)
gen dist_group_1500 = 1 if (near_dist <= 1500 & near_dist >1250)
gen dist_group_1750 = 1 if (near_dist <= 1750 & near_dist >1500)
gen dist_group_2000 = 1 if (near_dist <= 2000 & near_dist >1750)
gen dist_group_2250 = 1 if (near_dist <= 2250 & near_dist >2000)
gen dist_group_2500 = 1 if (near_dist <= 2500 & near_dist >2250)

*** This is now total calls per ring. 
***This command collapses our data down, Using the various variables we created for each seperate distance groups we can now collapse the data by the count of how many of our observations are within each individual distance groups per SATC center

collapse (count) dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500, by(near_fid)

***Couldn't we also collapse count by the CallxArea variable? No, if we did, then we wouldn't be taking in SATCs into the final analysis (in the unit) at all. We need to do mean calls per ring per SATC center?
***So now, we have number of total 911 calls by ring for each SATC (1-44). How do we go about doing a two sample t-test now? Either do a matrix, or this new thing I will try out.


















** below are different matrix codes I've been working on/trying to get going
clear matrix results
foreach g in 250 500 750 1000 1250 1500 1750 2000 {
    local next = `g' + 250
    
    // Run paired t-test
    ttest dist_group_`g' == dist_group_`next'
    
    // Extract values
    local t_stat = r(t)
    local p_value = r(p)
    local mean_diff = r(mu_1) - r(mu_2)
    
    // Display results
    di "Comparison: `g' vs `next'"
    di "T-Statistic: `t_stat'"
    di "P-Value: `p_value'"
    di "Mean Difference: `mean_diff'"
}
* Create an empty matrix to store results
local comparisons = 8  // Number of group comparisons (250 to 500, ..., 2000 to 2250)
matrix results = J(`comparisons', 4, .)  // 4 columns: Group, T, P, Mean Diff

* Loop through each pair and run paired t-tests
local i = 1
foreach g in 250 500 750 1000 1250 1500 1750 2000 {
    local next = `g' + 250
    
    * Run paired t-test
    ttest dist_group_`g' == dist_group_`next'
    
    * Extract values
    local t_stat = r(t)
    local p_value = r(p)
    local mean_diff = r(mu_1) - r(mu_2)
    
    * Store results in matrix
    matrix results[`i', 1] = `g'
    matrix results[`i', 2] = `next'
    matrix results[`i', 3] = `t_stat'
    matrix results[`i', 4] = `p_value'
    matrix results[`i', 5] = `mean_diff'
    
    local i = `i' + 1
}
* Create an empty matrix: 8 comparisons, 6 columns (Group 1, Group 2, T, P, Mean Diff, Cohen's d)
matrix results = J(8, 6, .)

* Initialize row counter
local i = 1

* Loop through each pair and run paired t-tests
foreach g in 250 500 750 1000 1250 1500 1750 2000 {
    local next = `g' + 250
    
    * Run paired t-test
    ttest dist_group_`g' == dist_group_`next'
    
    * Extract values
    local t_stat = r(t)
    local p_value = r(p)
    local mean_diff = r(mu_1) - r(mu_2)
    local sd_diff = r(sd)  // Standard deviation of the differences
    local N = r(N)         // Number of pairs
    
    * Calculate Cohen's d
    local cohens_d = `mean_diff' / `sd_diff'
    
    * Calculate Pearson's r
    local r_value = sqrt((`t_stat'^2) / (`t_stat'^2 + `N' - 1))
    
    * Store results in matrix
    matrix results[`i', 1] = `g'
    matrix results[`i', 2] = `next'
    matrix results[`i', 3] = `t_stat'
    matrix results[`i', 4] = `p_value'
    matrix results[`i', 5] = `mean_diff'
    matrix results[`i', 6] = `cohens_d'
    
    * Increment row counter
    local i = `i' + 1
}

* Display the matrix as a table
matrix list results

* Optional: Export to Excel
putexcel set ttest_results.xlsx, replace
putexcel A1 = ("Group 1") B1 = ("Group 2") C1 = ("T-Statistic") D1 = ("P-Value") E1 = ("Mean Difference") F1 = ("Cohen's d") G1 = ("Pearson's r")
putexcel A2 = matrix(results)

* Create an empty matrix to store results
local comparisons = 8  
**Number of group comparisons (250 to 500, ..., 2000 to 2250)
matrix results = J(`comparisons', 6, .)  
** 4 columns: Group, Next T, P, Mean Diff

* Loop through each pair and run paired t-tests
local i = 1
foreach g in 250 500 750 1000 1250 1500 1750 2000 {
    local next = `g' + 250
    
    * Run paired t-test
    ttest dist_group_`g' == dist_group_`next'
    
    * Extract values
    local t_stat = r(t)
    local p_value = r(p)
    local mean_diff = r(mu_1) - r(mu_2)
    
    * Store results in matrix
    matrix results[`i', 1] = `g'
    matrix results[`i', 2] = `next'
    matrix results[`i', 3] = `t_stat'
    matrix results[`i', 4] = `p_value'
    matrix results[`i', 5] = `mean_diff'
    
    local i = `i' + 1
}

* Display the matrix as a table
matrix list results

* Export with stars
esttab using "ttest_results.tex",
    p stars(* 0.05 ** 0.01 *** 0.001) 
    label booktabs replace

* Optional: Export to Excel
putexcel set ttest_results.xlsx, replace
putexcel A1 = ("Group 1") B1 = ("Group 2") C1 = ("T-Statistic") D1 = ("P-Value") E1 = ("Mean Difference")
putexcel A2 = matrix(results)

