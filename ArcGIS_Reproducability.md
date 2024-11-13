# ArcGIS Reproducability Document
### Step 1. 
- Download 911 Call [data](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/911%20call%20data%20by%20year/2017_911_call_data_access.md) for 2017.
- Download Treatment Center [data](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/Treatment%20center%20data%20by%20year/2017_treatment_center_data.dta) for 2017.
- Open StataMP 18, select file, open, and select one of the files you downloaded
- Once opened in Stata, select file, export, Text Data.
- In the box under "Write to the File" select save as, and save to your prefered file location, leave all other boxes blank and select OK
- Repeat the same steps with the second dataset
- If this does not work, use the export delimited command in stata to manually save it to a csv. Directions on this [do file](https://sumailsyr-my.sharepoint.com/:u:/r/personal/sgortizh_syr_edu/Documents/Intro%20to%20Econ%20Research/GitHub/course-project-zipcentercrime/Data%20by%20year/Convert_datasets_to_csv.do?csf=1&web=1&e=8ODvER) or this [log file](https://sumailsyr-my.sharepoint.com/:u:/r/personal/sgortizh_syr_edu/Documents/Documents/GitHub/course-project-zipcentercrime/Data%20by%20year/2017_datasets.log?csf=1&web=1&e=Seke2J)

### Step 2.
- Open ArcGIS and create a new project with the map option as your base template.
- Select the Map option from the toolbar.
- Under Layer, select add data and select browse.
- Navigate to where you downloaded the .csv data files and import them into ArcGIS
- *Once your data appears as a Standalone Table in the conents section on the left, right click your first data set to reveal more options.
- *Select Create Points from Table, then select XY Table to Point
- *Make sure X Field is set to longitude, Y Field is set to latitude, and the Coordinate System is set to GCS_WGS_1984, the select ok.
- Repeat steps with a * for the second data set

### Step 3. 
- Right click on the red dot underneath the treatment center map layer and convert color to green
- Right click on treatment center layer and select attribute table
- Right click on 911 calls layer and select attribute table

### Step 4.
- Select the Tools option under the analysis page
- Select the Near tool
- Your parameters should be set to the following. Input Features will be the layer of plotted 911 call data. Your Near Features will be the layer of plotted treatment centers. Search radius will be 2500 meters. Method will be Geodesic, and all of your distances will be set to meters.
- Hit Run
- Check the attribute table for 911 Call Data to confirm the new variables have been created

### Step 5
- Right click on the layer for your 911 Call Data points
- Select Data
- Select Export Table
- Choose your prefered location to save the file
- When naming the file end it with .csv so that it is able to export as a text doccument

