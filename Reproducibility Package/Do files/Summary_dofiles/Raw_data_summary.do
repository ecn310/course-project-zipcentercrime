*open call_final dataset
 import delimited "C:\Users\wrmaechl\OneDrive - Syracuse University\Desktop\test\calls_final"
*summary statistics
ssc install estout
ssc install distinct
gen year = call_timestamp
replace year = substr(year, 1, 4)
destring year, gen(year_num)
estpost tab year_num
esttab using "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package\Visual Graphics\Call_Years.tex", replace tex varlabels("Freq." "Percent" "Cum.")

twoway (scatter latitude longitude, sort msize(medsmall)) (scatter latitude longitude if year_num == 2017, sort mcolor(green%50) msize(medsmall)), legend(order(1 "All Years" 2 "2017 Only")) title(Long/Lat for Call Data) name(Scatter)

graph export "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package\Visual Graphics\LongLat_Graph.png", replace

clear


use "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package\RawData\detroit_samhsa_sud_2015_2021.dta"

estpost tab year
esttab using "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package\Visual Graphics\Center_Years.tex", replace tex varlabels("Freq." "Percent" "Cum.")

twoway (scatter latitude longitude, title(Long/Lat for Call Data) msymbol(triangle) sort mcolor(yellow%75) msize(medsmall)) (scatter latitude longitude if year == 2017, title(Long/Lat for Center Data) msymbol(triangle) sort mcolor(red%75) msize(medsmall)), yscale(range(42 42.8)) yscale(extend fextend) ylabel(42(0.1)42.8) ymtick(, valuelabel alternate nogmin gmax gextend) xscale(range(-84.5 -82.5)) xlabel(-84.5(.75)-82.5) legend(order(1 "All Years" 2 "2017 Only")) title(Long/Lat for Center Data) name(Scatter2)  

graph combine Scatter Scatter2, xcommon ycommon commonscheme

graph export "C:\Users\wrmaechl\OneDrive - Syracuse University\Documents\GitHub\course-project-zipcentercrime\Reproducibility Package\Visual Graphics\Combined_Scatter.png", replace