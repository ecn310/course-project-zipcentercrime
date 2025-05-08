## Read needed packages
library(readr)
library(dplyr)
library(lubridate)
library(magrittr)
library(tidyverse)
library(readxl)
library(arsenal)

## Set working directory to where the downloaded 911 call file is stored
setwd("C:/Users/rachelgaudreau")

# Bring downloaded 911 call data set into R
updated_calls <- read_csv("Downloads/Police_Serviced_911_Calls_6235174473015125577.csv")
View(updated_calls)

# Create year variable in downloaded 911 call data set
updated_calls$`Call Time` <- mdy_hms(updated_calls$`Call Time`)
updated_calls$year <- year(updated_calls$`Call Time`)

# Filter the dataset to keep only rows where 'year' is 2017
updated_calls <- updated_calls %>% filter(year == 2017)

write_csv(updated_calls, "Documents/GitHub/course-project-zipcentercrime/Reproducibility Package/Downloaded_calls/2017_Downloaded_911Calls.csv")
