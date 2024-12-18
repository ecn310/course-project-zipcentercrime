# Full Reproduibility ReadMe: ZipCenterCrime
Everything below will be run using a combination of Stata 18 and ArcGIS Pro.

# Sourcing the Data 
Using these steps you will be able to access all of the raw data used for our analysis.
### 911 Calls
1. Follow [THIS link](https://www.dropbox.com/scl/fi/mvlni30fz74qx4fclofmc/calls_final.csv?rlkey=drs9rkqlgyo9i8gsf9823prof&dl=0) and download the calls_final.csv file to get the raw 911 Call data.
2. Select the download option at the top of the page.
3. A menu will apear to select the format for the data. Select CSV to download the data as a .csv file.
### Treatment Centers
1. Follow [THIS link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/RawData/detroit_samhsa_sud_2015_2021.dta) to the raw treatment center data and download the raw data file.
# Limiting Data Set
Follow these steps to limit the data sets to data from 2017.
### 2017 911 Calls
1. Open Create_2017_911_call_data.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/911%20Call%20data%20by%20year/Create_2017_911_call_data.do) or by clicking Do Files\911 Call data by year\Create_2017_911_call_data.do.
2. This program has been tested in Stata16 and Stata18. If your using Stata16 it will likely take a few minutes to load the data due to the size of the raw data set.
3. Edit the working directory in line 11 to where the 911 call raw data set is saved on your computer.
4. Running the do file creates the 2017_911_call_data.csv file.
### 2017 911 Calls only related to Crime
1. Open Crime_911Calls.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/Analysis_dofiles/Crime_911calls.do) or by opening Do files\Crime_911Calls.do.
2. This program has been tested in Stata16 and Stata18. If your using Stata16 it will likely take a few minutes to load the data due to the size of the raw data set.
3. Change the working directory in line 9 to where the calls_final.csv file is stored locally on your computer.
4. Running the do file will create a data set comprised of only 911 calls made in 2017 that are related to crimes.
5. Please note that this do file uses the raw 911 call data set, not the 2017 911 call data set.
### 2017 Treatment Centers
1. Open create_2017_treatment_center_data.do through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/Treatment%20Center%20by%20year/create_2017_treatment_center_data.do) or by clicking Do Files\Treatment Center by year\create_2017_treatment_center_data.do.
2. This program has been tested in Stata16 and Stata18. If your using Stata16 it will likely take a few minutes to load the data due to the size of the raw data set.
3. Edit the working directory in line 11 to where the center raw data is stored in github on your computer.
4. Running this do file creates the 2017_treatment_center_data.csv file.
# ArcGIS Pro Process
Follow these steps to reproduce the geocoded data. 
### Set Up
1. Open ArcGIS and create a new project with the map option as your base template.
2. Select the Map option from the toolbar.
3. Under Layer, select add data and select browse.
4. Navigate to where you downloaded the 2017_treatment_center_data.csv and 2017_911_call_data.csv data files and import them into ArcGIS Pro.
5. *Once your data appears as a Standalone Table in the conents section on the left, right click your first data set to reveal more options.
6. *Select Create Points from Table, then select XY Table to Point.
7. *Make sure X Field is set to longitude, Y Field is set to latitude, (Leave Z Field blank), and the Coordinate System is set to GCS_WGS_1984, the select ok.
8. Repeat steps with a * for the second data set.
9. Right click on the colored dot underneath the treatment center map layer and convert it to a different color than your call data.
10. Right click on treatment center layer and select attribute table.
11. Right click on 911 calls layer and select attribute table.
### Data Manipulation
1. Select the Tools option under the analysis page.
2. Select the Near tool.
3. Your parameters should be set to the following:
     - Input Features will be the layer of plotted 911 call data.
     - Your Near Features will be the layer of plotted treatment centers.
     - Search radius will be 2500, and to the right click on the drop down and select meters.
     - Method will be Geodesic.
     - Under Field Names make sure they are as follows (Feature_ID --> NEAR_FID) and (Distance --> NEAR_DIST)
     - Make sure all of your Distance units are set to meters.
     - Leave all other section blank or unchecked
4. Hit Run.
5. Check the attribute table for 911 Call Data to confirm these two new variables below have been created:
near fid: This assigned every 911 call with one SATC, the center geographically closest to it. Variable is a numeric integer, with values ranging from 1 to 44.
near dist: This is the distance in meters the 911 call observation is from the SATC it is associated with in near fid.
### Export Geocoded Data
1. Right click on the layer for your 911 Call Data points.
2. Select Data.
3. Select Export Table.
4. Choose your preferred location to save the file.
5. When naming the file end it with .csv so that it is able to export as a text doccument.
6. Select the "Fields" drop down and only keep variables "near_dist" and "near_fid" (All other variable are not used in analysis and only takes up storage).
7. Click "OK"

Repeat the steps under Set Up, Data Manipulation, and Export Geocoded Data using the 2017_Crime_911calls.csv data set instead of the 2017_911_call_data.csv data to analize data specifically related to crime.
# Data Analysis
1. Open 2017_FullData_Do.do file through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/Analysis_dofiles/2017_FullData_Do.do) or by clicking Do files\Analysis_dofile\2017_FullData_Do.do.
2. This do file does not correctly import the data from ArcGIS in Stata16. Therefore, we have limited the version used to run this program to Stata18.
3. Edit the working directory in line 10 to the place where this repository is stored locally on your computer.
4. This do file has all of our data analysis work done from the full 2017 data exported from ArcGIS Pro including making the graphs.
5. Open 2017_CrimeData_Do.do file through this [link](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Reproducibility%20Package/Do%20files/Analysis_dofiles/2017_CrimeData_Do.do) or by clicking Do files\Analysis_dofile\2017_CrimeData_Do.do.
2. This do file does not correctly import the data from ArcGIS in Stata16. Therefore, we have limited the version used to run this program to Stata18.
3. Edit the working directory in line 10 to the place where this repository is stored locally on your computer.
4. This do file has all of our data analysis work done from the 2017 data for onyl crime related 911 calls exported from ArcGIS Pro including making the graphs.
