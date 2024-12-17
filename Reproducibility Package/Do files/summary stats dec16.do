*open call_final dataset
 import delimited "C:\Users\sgortizh\Downloads\calls_final.csv"
*summary statistics
gen year = call_timestamp
replace year = substr(year, 1, 4)
destring year, gen(year_num)
tab year_num

*download package
ssc install asdoc
asdoc tab year_num, save(year_freq.tex) replace
*run the frequency
tab year_num 
local n = r(k) 
forval i = 1/'n'
{
local freq = r(freq_i) 
local percent = r(Percent_i)
collect _freq'i' = 'freq'
collect _percent'i' = 'percent'
}
*create summary for call descriptions