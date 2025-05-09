## Planning and tracking on progresss 
The general tracking of our total progress on the project can be found in in the [Group Log](https://github.com/ecn310/course-project-zipcentercrime/issues/2) issue.  For more detailed description on work done on each problem and task that has arised please conisder our list of issues.

### File Locations 
  - [Data by Year](https://github.com/ecn310/course-project-zipcentercrime/tree/main/Data%20by%20year) | Includes 911 call data set and drug treatment center data set, both seperated by year
  - [**Team Contract**](https://github.com/ecn310/course-project-zipcentercrime/blob/main/team_contract.md) 
  - [Literature Review](https://github.com/ecn310/course-project-zipcentercrime/tree/main/Lit_Review) | Includes initial lit review paper summarys
  - [**ArcGIS Reproducibility**](https://github.com/ecn310/course-project-zipcentercrime/blob/main/ArcGIS_Reproducability.md) |
  - [Visual Graphics](https://github.com/ecn310/course-project-zipcentercrime/tree/main/Visual%20Graphics) | Currently has the .pngs of each two sample t-test performed
  - [**project_crime.tex**](https://github.com/ecn310/course-project-zipcentercrime/blob/main/project_crime.tex) | the github viewing window of the research paper written in overleaf
  - [data.tex](https://github.com/ecn310/course-project-zipcentercrime/blob/main/data.tex) | project documents updates from overleaf
  - [projecttemplate.tex](https://github.com/ecn310/course-project-zipcentercrime/blob/main/data.tex) | project template from overleaf
  - [Reproducability Package Folder](https://github.com/ecn310/course-project-zipcentercrime/tree/main/Reproducibility%20Package) | includes all the files we currently are using to create the reproducability package
    - [Raw Data](https://github.com/ecn310/course-project-zipcentercrime/tree/main/Reproducibility%20Package/RawData) | this store the raw data and their codebooks
    - [**Reproducibility Package**](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Replication_Package.md) | Draft of reporducability package: Has links to all datasets used (fromn raw datasets to manipulated ones)

### Issues
  - **#2** [**Group Log**](https://github.com/ecn310/course-project-zipcentercrime/issues/2)
  - *#16* [Data Manipulation](https://github.com/ecn310/course-project-zipcentercrime/issues/16) | As of 11/8, refer to do files of 2017 data isolation and arcGIS do file to see current data manipulation progress
  - *#10* [Data Documentation](https://github.com/ecn310/course-project-zipcentercrime/issues/10) | As of 11/8, refer to do files of 2017 data isolation and arcGIS do file to see current data documentation progress
  - *#14* [Outliers in 911 Call Data](https://github.com/ecn310/course-project-zipcentercrime/issues/14) | As of 11/8 not needed, can ignore
  - *#12* [Data Analysis in ArcGIS/Documentation](https://github.com/ecn310/course-project-zipcentercrime/issues/12) | as of 11/8 not filled in yet, refer to arcGIS reproducibility file for arcGIS current progress
  - *#8* [Substance Abuse Treatment Center Variable](https://github.com/ecn310/course-project-zipcentercrime/issues/8)


### Drug Treatment Center data(#8)
  - *Drug treatment center dataset originated from **SAMHSA** (Substance Abuse and Mental Health Services Administration). Request a data set within these parameters: **a)** drugtreatment centers in Detroit, MI metropolitan area **b)** between the yeras of 2015 and 2021. We are only using 2017 data*
  -  [SAMHSA Facility Code Key](https://github.com/ecn310/course-project-zipcentercrime/blob/main/samhsa_services.pdf)
  - [drug treatment center_raw_data](https://github.com/ecn310/course-project-zipcentercrime/blob/main/detroit_samhsa_sud_2015_2021.dta) | stata file
  - [Do file to isolate the 2017 data](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/911%20call%20data%20by%20year/do%20files/Create_2017_911_call_data.do)

### 911 Calls 
  - *911 calls dataset origniatefd from the City of Detroit Open Data Portal's Police Serviced 911 Calls. Dataset avaible online at this [link](https://data.detroitmi.gov/datasets/detroitmi::police-serviced-911-calls/about) and starts from year 2016. We are only using 2017 data*
  -   [911 calls raw data](https://www.dropbox.com/scl/fi/mvlni30fz74qx4fclofmc/calls_final.csv?rlkey=drs9rkqlgyo9i8gsf9823prof&dl=0)
  -   [attribute table information](https://data.detroitmi.gov/datasets/detroitmi::police-serviced-911-calls/about)
  -   [Do file to isolate the 2017 data](https://github.com/ecn310/course-project-zipcentercrime/blob/main/Data%20by%20year/Treatment%20center%20data%20by%20year/do%20files/create_2017_treatment_center_data.do)

