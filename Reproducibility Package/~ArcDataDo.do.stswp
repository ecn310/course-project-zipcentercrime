*** This pathway should lead to the folder where you are saving the exported data from ArcGIS
cd "C:\Users\wrmaechl\OneDrive - Syracuse University\ZipCenterCrime"

*** This is to log the work done by the dofile
log using "DTA log", text replace 

*** This should be the file you exported from ArcGIS
import delimited "DTA.csv"

*** This drops any values that were further than 2500 meters from any treatment center
drop if near_dist == -1

*** this is install a program that may or may not be usefull in exporting tables
ssc install outreg2

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
gen dist_group_100 = 100 if near_dist <= 100
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

*** This graph shows the decline in calls per area over the groups of distances recorded
graph bar CallxArea, over(dist_group) title("Calls by Area for Each Distance") ytitle("Calls By Area") b1title("Distance Groups")
graph export "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Visual Graphics\Calls_Distance.png", replace

*** This command colapses our data down, Using the various variables we created for each seperate distance groups we can now collapse the data by the count of how many of our observations are within each individual distance groups by the id number for the treatment center it was nearest.
collapse (count) dist_group_100 dist_group_250 dist_group_500 dist_group_750 dist_group_1000 dist_group_1250 dist_group_1500 dist_group_1750 dist_group_2000 dist_group_2250 dist_group_2500, by(near_fid)

*** once our data is collapsed we use these commands to standardize the number of calls by the areas of the rings we calculated previously 
replace dist_group_100 = dist_group_100 / 31415.9265
replace dist_group_250 = dist_group_250 / 164933.6143
replace dist_group_500 = dist_group_500 / 589048.6225
replace dist_group_750 = dist_group_750 / 981747.7042
replace dist_group_1000 = dist_group_1000 / 1374446.786
replace dist_group_1250 = dist_group_1250 / 1767145.868
replace dist_group_1500 = dist_group_1500 / 2159844.949
replace dist_group_1750 = dist_group_1750 / 2552544.031
replace dist_group_2000 = dist_group_2000 / 2945243.113
replace dist_group_2250 = dist_group_2250 / 3337942.194
replace dist_group_2500 = dist_group_2500 / 3730641.276

*** Now we will use a paired t test to measure the statisical likelyhood that one ring will have greater median of calls compared to the next larger ring
table (command) (result), command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_100 == dist_group_250) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_250 == dist_group_500) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_500 == dist_group_750) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_750 == dist_group_1000) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1000 == dist_group_1250) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1250 == dist_group_1500) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1500 == dist_group_1750) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_1750 == dist_group_2000) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2000 == dist_group_2250) command(M2=r(mu_2) M1=r(mu_1) Difference= (r(mu_2) -r(mu_1)) p_value = r(p) Tailed_p = r(p_u): ttest dist_group_2250 == dist_group_2500) nformat(%9.6f) stars(Tailed_p 0.1 "*" 0.05 "**" 0.01 "***", shownote)  name(t_test) replace
collect set t_test
collect export "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Visual Graphics\t_test.tex", replace



*** This test shows the sum of each variable divided by the sum of the next largest variable to show an estimate of how many more or less calls you can expect going from one ring to an adjecent one
ratio (dist_group_100/dist_group_250) (dist_group_250/dist_group_500) (dist_group_500/dist_group_750) (dist_group_750/dist_group_1000) (dist_group_1000/dist_group_1250) (dist_group_1250/dist_group_1500) (dist_group_1500/dist_group_1750) (dist_group_1750/dist_group_2000) (dist_group_2000/dist_group_2250) (dist_group_2250/dist_group_2500), fvwrap(1) 

outreg2 using "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Visual Graphics\Ratio.tex", replace sum(log)


log close



