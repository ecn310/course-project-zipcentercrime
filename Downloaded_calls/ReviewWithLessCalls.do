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

