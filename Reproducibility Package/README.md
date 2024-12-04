# Full Reproduibility ReadMe: ZipCenterCrime
Everything below will be run using a combination of Stata 18 and ArcGIS Pro

# Sourcing the Data 
Using these steps you will be able to access all of the raw data used for our analysis 
### 911 Calls
1. Follow [THIS link](https://data.detroitmi.gov/datasets/detroitmi::police-serviced-911-calls/about) to the raw 911 Call data.
2. Select the download option at the top of the page
3. A menu will apear to select the format for the data. Select CSV to download the data as a .csv file
### Treatment Centers
1. Follow [THIS link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/RawData/detroit_samhsa_sud_2015_2021.dta) to the raw treatment center data and download the raw data file
# Limiting data set
Follow these steps to limit the data sets to data from 2017
### 2017 911 Calls
1. Open Create_2017_911_call_data.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/911%20Call%20data%20by%20year/Create_2017_911_call_data.do) or by clicking Do Files\911 Call data by year\Create_2017_911_call_data.do
2. Edit the working directory and file paths to where the 911 call raw data set is saved on your computer
3. Run the do file
### 2017 Treatment Centers
1. Open create_2017_treatment_center_data.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/Treatment%20Center%20by%20year/create_2017_treatment_center_data.do) or by clicking Do Files\Treatment Center by year\create_2017_treatment_center_data.do
2. Edit the working directory and file paths to where the 911 call raw data set is saved on your computer
3. Run the do file
# ArcGIS Pro Process
Follow these steps to reproduce the geocoded data 
### Set up
1. Open ArcGIS and create a new project with the map option as your base template.
2. Select the Map option from the toolbar.
3. Under Layer, select add data and select browse.
4. Navigate to where you downloaded the .csv data files and import them into ArcGIS
5. *Once your data appears as a Standalone Table in the conents section on the left, right click your first data set to reveal more options.
6. *Select Create Points from Table, then select XY Table to Point
7. *Make sure X Field is set to longitude, Y Field is set to latitude, and the Coordinate System is set to GCS_WGS_1984, the select ok.
8. Repeat steps with a * for the second data set
9. Right click on the red dot underneath the treatment center map layer and convert color to green
10. Right click on treatment center layer and select attribute table
11. Right click on 911 calls layer and select attribute table
### Data manipulation
1. Select the Tools option under the analysis page
2. Select the Near tool
3. Your parameters should be set to the following:
     - Input Features will be the layer of plotted 911 call data.
     - Your Near Features will be the layer of plotted treatment centers.
     - Search radius will be 2500 meters.
     - Method will be Geodesic
     - all of your distances will be set to meters.
4. Hit Run
5. Check the attribute table for 911 Call Data to confirm these two new variables below have been created:
near fid: This assigned every 911 call with one SATC, the center geographically closest to it. Variable is a numeric integer, with values ranging from 1 to 44.
near dist: This is the distance in meters the 911 call observation is from the SATC it is associated with in near fid.
### Export geocoded data
1. Right click on the layer for your 911 Call Data points
2. Select Data
3. Select Export Table
4. Choose your prefered location to save the file
5. When naming the file end it with .csv so that it is able to export as a text doccument
# Data Analysis
1. Open ArcDataDo.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/ArcDataDo.do) or by clicking Do files\ArcDataDo.do
2. Edit the working directory to where you stored the data previously exported from ArcGIS Pro
3. Run lines 1-11 to import the data and open a log file
4. Run lines 12-62 to find the number of calls per the increase in area from one ring to the next largest
5. Run lines 63-77 to create new, seperate variables for each distance group
6. To create and export the Calls by Area for Each Distance graph run lines 78-82
7. Run lines 83-104 to run a paired t test which measures the statisical likelyhood that one distance ring will have greater median of calls compared to the next larger distance ring
8. Run lines 109-111 to test the sum of each variable divided by the sum of the next largest variable to show an estimate of how many more or less calls you can expect going from one ring to an adjecent one
