*** First, connect the pathway to where all these files are stored

cd "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package"

*** Then, start log 

log using "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package\Do files\Analysis_dofiles\DifferentRingDistances.log", replace

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

*dist_group2 of 2500 doesnt' have an uppderbound, so there won't be anything
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

*** When collapse (count), it reduced the number of total calls to 35,731, when at the beginning there was 415,216 calls. What is going on here?

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

*** To check, add up the dist~500 column to see what total calls come out t

egen row_sum = rowtotal(dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500)
summarize row_sum, meanonly
display r(sum)


***Couldn't we also collapse count by the CallxArea variable? No, if we did, then we wouldn't be taking in SATCs into the final analysis (in the unit) at all. We need to do mean calls per ring per SATC center?
***So now, we have number of total 911 calls by ring for each SATC (1-44). How do we go about doing a two sample t-test now? Either do a matrix, or this new thing I will try out.

local vars dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500

*** Create a blank matrix for the data to go in

matrix Summary_Results = J(1, 6, .)

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
    
    matrix Summary_Results = Summary_Results \ (`N', `mean', `sd', `sum', `min', `max')
	}

	*** Change column and row names
matrix colnames Summary_Results = "Obs" "Mean" "Std. dev." "Sum" "Min" "Max"

*** Delete empty row from matrix

matrix Summary_Results = Summary_Results[2..11, 1..colsof(Summary_Results)]

*** Rename the rows
matrix rownames Summary_Results = "250m" "500m" "750m" "1000m" "1250m" "1500m" "1750m" "2000m" "2250m" "2500m"

matrix list Summary_Results

*** Export table

esttab matrix(Summary_Results) using "Visual Graphics\New_Call_Summary_Stats.tex", replace

*** Do one-sample t-tests for every adjacent ring

* Step 1: Initialize the matrix for storing t-test results
matrix t_tests = J(9, 4, .)  // 9 comparisons, 4 columns (Mean 1, Mean 2, Difference, p_value)

* Run the first t-test: dist_group_250 vs. dist_group_500
ttest dist_group_250 == dist_group_500
matrix t_tests[1, 1] = r(mu_1)   // Mean of dist_group_250
matrix t_tests[1, 2] = r(mu_2)   // Mean of dist_group_500
matrix t_tests[1, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[1, 4] = r(p)     // p-value

* Run the second t-test: dist_group_500 vs. dist_group_750
ttest dist_group_500 == dist_group_750
matrix t_tests[2, 1] = r(mu_1)   // Mean of dist_group_500
matrix t_tests[2, 2] = r(mu_2)   // Mean of dist_group_750
matrix t_tests[2, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[2, 4] = r(p)     // p-value

* Run the third t-test: dist_group_750 vs. dist_group_1000
ttest dist_group_750 == dist_group_1000
matrix t_tests[3, 1] = r(mu_1)   // Mean of dist_group_750
matrix t_tests[3, 2] = r(mu_2)   // Mean of dist_group_1000
matrix t_tests[3, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[3, 4] = r(p)     // p-value

* Run the fourth t-test: dist_group_1000 vs. dist_group_1250
ttest dist_group_1000 == dist_group_1250
matrix t_tests[4, 1] = r(mu_1)   // Mean of dist_group_1000
matrix t_tests[4, 2] = r(mu_2)   // Mean of dist_group_1250
matrix t_tests[4, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[4, 4] = r(p)     // p-value

* Run the fifth t-test: dist_group_1250 vs. dist_group_1500
ttest dist_group_1250 == dist_group_1500
matrix t_tests[5, 1] = r(mu_1)   // Mean of dist_group_1250
matrix t_tests[5, 2] = r(mu_2)   // Mean of dist_group_1500
matrix t_tests[5, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[5, 4] = r(p)     // p-value

* Run the sixth t-test: dist_group_1500 vs. dist_group_1750
ttest dist_group_1500 == dist_group_1750
matrix t_tests[6, 1] = r(mu_1)   // Mean of dist_group_1500
matrix t_tests[6, 2] = r(mu_2)   // Mean of dist_group_1750
matrix t_tests[6, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[6, 4] = r(p)     // p-value

* Run the seventh t-test: dist_group_1750 vs. dist_group_2000
ttest dist_group_1750 == dist_group_2000
matrix t_tests[7, 1] = r(mu_1)   // Mean of dist_group_1750
matrix t_tests[7, 2] = r(mu_2)   // Mean of dist_group_2000
matrix t_tests[7, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[7, 4] = r(p)     // p-value

* Run the eighth t-test: dist_group_2000 vs. dist_group_2250
ttest dist_group_2000 == dist_group_2250
matrix t_tests[8, 1] = r(mu_1)   // Mean of dist_group_2000
matrix t_tests[8, 2] = r(mu_2)   // Mean of dist_group_2250
matrix t_tests[8, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[8, 4] = r(p)     // p-value

* Run the ninth t-test: dist_group_2250 vs. dist_group_2500
ttest dist_group_2250 == dist_group_2500
matrix t_tests[9, 1] = r(mu_1)   // Mean of dist_group_2250
matrix t_tests[9, 2] = r(mu_2)   // Mean of dist_group_2500
matrix t_tests[9, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[9, 4] = r(p)     // p-value

* Now, name the rows and columns for the one-sample t-test table 
matrix colnames t_tests = "Lower Ring Mean" "Upper Ring Mean" "Mean Difference" "P-Value"
matrix rownames t_tests = "250m-500m" "500m-750m" "750m-1000m" "1000m-1250m" "1250m-1500m" "1500m-1750m" "1750m-2000m" "2000m-2250m"
 
 **Now, put the matrix into a .tex file named t_tests 
file open t_tests_file using "Visual Graphics\t_tests_results.tex", write replace
file write t_tests_file "\begin{table}[htbp]" _n
file write t_tests_file "\centering" _n
file write t_tests_file "\begin{tabular}{l|c c c c}" _n
file write t_tests_file "\hline" _n
file write t_tests_file "Comparison & Mean 1 & Mean 2 & Difference & P-value \\" _n
file write t_tests_file "\hline" _n

local rownames 250m-500m 500m-750m 750m-1000m 1000m-1250m 1250m-1500m 1500m-1750m 1750m-2000m 2000m-2250m
local i = 1
foreach row of local rownames {
	local mean1 = string(el(t_tests, `i', 1), "%9.1f")
	local mean2 = string(el(t_tests, `i', 2), "%9.1f")
	local diff  = string(el(t_tests, `i', 3), "%9.1f")
	local pval  = string(el(t_tests, `i', 4), "%9.3f")
	file write t_tests_file "`row' & `mean1' & `mean2' & `diff' & `pval' \\" _n
	local i = `i' + 1
}

file write t_tests_file "\hline" _n
file write t_tests_file "\end{tabular}" _n
file write t_tests_file "\caption{\textbf{One-sample T-test Results by Distance Ring}}" _n
file write t_tests_file "\label{tab:ttests}" _n
file write t_tests_file "\end{table}" _n
file close t_tests_file

** End of New try
 
*** Clear any matrices stores in Stata

matrix drop _all


*** Create two new matrices for storing Confidence Interval data

matrix lci = J(10, 1, .) 
matrix uci = J(10, 1, .)  

*** List of variables to be groupped for looping

local groups dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500 

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
   matrix lci[`row_index',1] = `ci_lower'
   matrix uci[`row_index',1] = `ci_upper'
   
   *** Increment row index
   local row_index = `row_index' + 1
}

*** Display final matrices to check if correct

matrix list lci
matrix list uci

*** Reshape the data to be over distance instead of treatment center  - what was this purpose?

reshape long dist_group_, i(near_fid) j(Distance)

*** Collapse the data to be the mean number of calls at each distance

collapse (mean) dist_group_, by(Distance)

rename dist_group mean

*** Turn the two matrices into seperate variables 

svmat lci, names(lci)
svmat uci, names(uci)

rename mean Mean 

*** Plot the graph
graph twoway (bar Mean Distance, lwidth(02) color(navy)) (rcap lci1 uci1 Distance, lcolor(black) lwidth(thin)), ytitle("Mean Calls per Km²", angle(horizontal))  xtitle("Distance Groups (m)", size(medsmall))  legend(label (1 "Mean Calls per Km^2") label(2 "95% Confidence Intervals")) graphregion(color(white)) title("Mean Calls by Distance Group with 95% CIs", size(medium))

*** Export Graph
graph export "Visual Graphics\CI_Graph.png", replace


log close

 
 ***********************************************************************************************************************
 Run same data anaylsis, but for larger groups 

import delimited "ExtraFiles\2017_Arc_Data.csv"
 
*** Then, drop any values that were further than 2500 meters from any treatment center

drop if near_dist == -1

ssc install outreg2
ssc install estout

*** Then, create the distance rings. This is the farther bound of the distance ring

gen dist_group = 500 if near_dist <= 500
replace dist_group = 1000 if (near_dist <= 1000 & near_dist >500)
replace dist_group = 1500 if (near_dist <= 1500 & near_dist >1000)
replace dist_group = 2000 if (near_dist <= 2000 & near_dist >1500)
replace dist_group = 2500 if (near_dist <= 2500 & near_dist >2000)

*** Then, create the lower bound of the distance rings. 

gen dist_group2 = 0 if near_dist <= 500 
replace dist_group2 = 500 if (near_dist <= 1000 & near_dist >500)
replace dist_group2 = 1000 if (near_dist <= 1500 & near_dist >1000)
replace dist_group2 = 1500 if (near_dist <= 2000 & near_dist >1500)
replace dist_group2 = 2000 if (near_dist <= 2500 & near_dist >2000)


*dist_group2 of 2500 doesnt' have an uppderbound, so there won't be anything
*** At this point, every call has an assigned SATC, The distance it is from that SATC, and a assigned upperbound distance ring and lowerbound distance ring. 
***Now, we count up the amount of observations per assigned dist_group and identify that number. 

egen freq = count(near_dist), by(dist_group)

***Then, we found the area for each respective group

gen area = (c(pi) * dist_group^2) - (c(pi) * dist_group2^2) 

*** taking that difference in area and dividing the amount of calls in that specific distance group by the new ring of area will give us the number of calls per the increase in area from one ring to the next largest, to standardize the total calls by their repestive area sizes

gen CallxArea = freq / area

***these commands create new seperate variables for each distance group 
gen dist_group_500 = 1 if near_dist <= 500
gen dist_group_1000 = 1 if (near_dist <= 1000 & near_dist >500)
gen dist_group_1500 = 1 if (near_dist <= 1500 & near_dist >1000)
gen dist_group_2000 = 1 if (near_dist <= 2000 & near_dist >1500)
gen dist_group_2500 = 1 if (near_dist <= 2500 & near_dist >2000)


*** This is now total calls per ring. 
***This command collapses our data down, Using the various variables we created for each seperate distance groups we can now collapse the data by the count of how many of our observations are within each individual distance groups per SATC center

collapse (count) dist_group_500 dist_group_1000 dist_group_1500 dist_group_2000 dist_group_2500, by(near_fid)

*** When collapse (count), it reduced the number of total calls to 35,731, when at the beginning there was 415,216 calls. What is going on here?

*** To check, add up the dist~500 column to see what total calls come out t

egen row_sum = rowtotal(dist_group_500 dist_group_1000 dist_group_1500 dist_group_2000 dist_group_2500)
summarize row_sum, meanonly
display r(sum)


***Couldn't we also collapse count by the CallxArea variable? No, if we did, then we wouldn't be taking in SATCs into the final analysis (in the unit) at all. We need to do mean calls per ring per SATC center?
***So now, we have number of total 911 calls by ring for each SATC (1-44). How do we go about doing a two sample t-test now? Either do a matrix, or this new thing I will try out.

local vars dist_group_500 dist_group_1000 dist_group_1500 dist_group_2000 dist_group_2500

matrix Long_Summary_Results = J(1, 6, .)

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
    
    matrix Long_Summary_Results = Long_Summary_Results \ (`N', `mean', `sd', `sum', `min', `max')
	}

	*** Change column and row names
matrix colnames Long_Summary_Results = "Obs" "Mean" "Std. dev." "Sum" "Min" "Max"

*** Delete empty row from matrix

matrix Long_Summary_Results = Long_Summary_Results[2..11, 1..colsof(Summary_Results)]

*** Rename the rows
matrix rownames Long_Summary_Results = "500m" "1000m" "1500m" "2000m" "2500m"

matrix list Long_Summary_Results

*** Export table
esttab matrix(Long_Summary_Results) using "Visual Graphics\Long_Dist_Summary_Stats.tex", replace

*** Do one-sample t-tests for every adjacent ring

* Step 1: Initialize the matrix for storing t-test results
matrix t_tests = J(4, 4, .)  // 4 comparisons, 4 columns (Mean 1, Mean 2, Difference, p_value)

* Run the first t-test: dist_group_500 vs. dist_group_1000
ttest dist_group_500 == dist_group_1000
matrix t_tests[1, 1] = r(mu_1)   // Mean of dist_group_250
matrix t_tests[1, 2] = r(mu_2)   // Mean of dist_group_500
matrix t_tests[1, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[1, 4] = r(p)     // p-value

* Run the second t-test: dist_group_1000 vs. dist_group_1500
ttest dist_group_1000 == dist_group_1500
matrix t_tests[2, 1] = r(mu_1)   // Mean of dist_group_500
matrix t_tests[2, 2] = r(mu_2)   // Mean of dist_group_750
matrix t_tests[2, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[2, 4] = r(p)     // p-value

* Run the third t-test: dist_group_1500 vs. dist_group_2000
ttest dist_group_1500 == dist_group_2000
matrix t_tests[3, 1] = r(mu_1)   // Mean of dist_group_750
matrix t_tests[3, 2] = r(mu_2)   // Mean of dist_group_1000
matrix t_tests[3, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[3, 4] = r(p)     // p-value

* Run the fourth t-test: dist_group_1000 vs. dist_group_1250
ttest dist_group_2000 == dist_group_2500
matrix t_tests[4, 1] = r(mu_1)   // Mean of dist_group_1000
matrix t_tests[4, 2] = r(mu_2)   // Mean of dist_group_1250
matrix t_tests[4, 3] = r(mu_1) - r(mu_2)  // Difference of means
matrix t_tests[4, 4] = r(p)     // p-value

* Now, name the rows and columns for the one-sample t-test table 
matrix colnames t_tests = "Lower Ring Mean" "Upper Ring Mean" "Mean Difference" "P-Value"
matrix rownames t_tests = "500m-1000m" "1000m-1500m" "1500m-2000m" "2000m-2500m"

file open t_tests_file using "larger_t_tests_results.tex", write replace
file write t_tests_file "{\begin{table}[htbp] \centering \begin{tabular}{|l|c|c|c|} \hline"
file write t_tests_file "Comparison & Mean 1 & Mean 2 & Difference & p-value \\\\ \hline" 

local rownames 500m-1000m 1000m-1500m 1500m-2000m 2000m-2500m

local i = 1
foreach row of local rownames {
    * Write the row to the LaTeX file
    file write larger_t_tests_file "`row' & " 
    file write larger_t_tests_file matrix(t_tests)[`i',1] & " & " 
    file write larger_t_tests_file matrix(t_tests)[`i',2] & " & " 
    file write larger_t_tests_file matrix(t_tests)[`i',3] & " & " 
    file write larger_t_tests_file matrix(t_tests)[`i',4] & " \\\\ \hline" 

    * Increment row index
    local i = `i' + 1
}

file write larger_t_tests_file "\end{tabular} \end{table}"
file close larger_t_tests_file
 * This should export the file in a tex file, but am having some issues. I will come back to this. 


















