# Zip-Center-Crime Reproducability Package
### Accessing the Raw Data 
#### 911 call data
The 911 call data we used can be found from the City of Detroits Open Data Portal and searching "Police Serviced 911 Calls" or via this [link](https://data.detroitmi.gov/datasets/detroitmi::police-serviced-911-calls/about).
#### Drug Treatment Center Data
The drug treatment center data was provided to us directly from a Professor Deza, but originated from the Substance Abuse and Mental Health Service Administration (SAMHSA). The raw data can be downloaded through GitHub [here](https://github.com/ecn310/course-project-zipcentercrime/blob/main/detroit_samhsa_sud_2015_2021.dta), or the data can be requested through SAMSHA with these parameters: a) drugtreatment centers in Detroit, MI metropolitan area b) between the yeras of 2015 and 2021
### Pre-analysis data work
We are only analizing 2017 data from both data sets
- The 2017 911 Call data set can be accessed through OneDrive via this [link](https://sumailsyr-my.sharepoint.com/my?id=%2Fpersonal%2Fregaudre%5Fsyr%5Fedu%2FDocuments%2FECN%20310%20%2D%20Zip%20Center%20Crime%20data%2F911%20Calls%20Yearly%20data) and the do file used to seperate the 2017 data from the raw data can be found in GitHub [here](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/911%20call%20data%20by%20year/do%20files/Create_2017_911_call_data.do)
- The 2017 Treatment Center data can be accessed in GitHub [here](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/Treatment%20center%20data%20by%20year/2017_treatment_center_data.dta), and the do file can be accessed also in GitHub through following this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/Treatment%20center%20data%20by%20year/do%20files/create_2017_treatment_center_data.do)
### Data Analysis
- The ArcGIS Reproducability Document can be accessed in GitHub or through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/ArcGIS_Reproducability.md). This document explains how to reproduce the process of seperating 911 calls by distance from a drug treatment center.
- The NewData2.csv file created from the ArcGIS Reproducability Package above can be accessed and downloaded through this [GitHub file](https://github.com/ecn310/course-project-zipcentercrime/blob/main/ArcGIS%20files/NewData2Download.md)
- ArcData.do uses NewData2.csv to collapse the data and run analysis through conducting t-tests at each distance range