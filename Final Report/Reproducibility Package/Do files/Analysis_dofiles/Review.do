*** First, connect the pathway to where all these files are stored
cd "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package"
*** Then, start log 
log using "C:\Users\sgortizh\OneDrive - Syracuse University\EconResearch\course-project-zipcentercrime\Final Report\Reproducibility Package\Do files\Analysis_dofiles\DifferentRingDistances.log"
*** Then, import the dataset
 import delimited "ExtraFiles\2017_Arc_Data.csv"
*** Then, drop any values that were further than 2500 meters from any treatment center
drop if near_dist == -1
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

***later when I come back to this, I will continue doing the rest of the stuff up until the matrix. Then, I will try a different code to generate the t-tests. I will also update the tables in general on LaTEX.