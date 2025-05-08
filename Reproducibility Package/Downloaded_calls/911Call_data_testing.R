## Read needed packages ----
library(readr)
library(dplyr)
library(lubridate)
library(magrittr)
library(tidyverse)
library(readxl)
library(arsenal)

# Set working directory to where the downloaded 911 call files are stored ----
setwd("C://Users/rachelgaudreau/")
###  Import the original data set of 911 Calls from Prof. Deza -----
calls <- read_csv("Downloads/calls_final.csv")
View(calls)

### Import 911 call data set downloaded from the Detroit Open Data Source ----
updated_calls <- read_csv("Downloads/Police_Serviced_911_Calls_6235174473015125577.csv")
View(updated_calls)

# Clean both data sets ----

### Delete unnecessary variables from the original data set----
calls <- select(calls, -agency, -priority, -callcode, -intaketime, -dispatchtime, -traveltime, -totalresponsetime, -time_on_scene, -totaltime, -block_id, -oid)
updated_calls <- select(updated_calls, -"Call Source", -Priority, -"Nature Code", -"Call Group", -"Intake Time", -"Dispatch Time", -"Travel Time", -"On Scene Time", -"Total Response Time", -"Total Time", -ESRI_OID)
### Delete unnecessary variables from the downloaded data set, and rename certain varaibles to improve efficiency ----
updated_calls <- updated_calls %>%
  rename(priority = Priority)
  rename(calldescription = `Code Description`)
  rename(zip_code = "Zip Code")
  rename(incident_id = "Incident ID")

# Create Year Variable ----
### in the original data set ----
calls$call_timestamp <- ymd_hms(calls$call_timestamp)  # Convert to datetime format
calls$date_only <- as.Date(calls$call_timestamp)
calls$year <- year(calls$call_timestamp)  # Extract the year
### in the downloaded data set ----
updated_calls$`Call Time` <- mdy_hms(updated_calls$`Call Time`)
updated_calls$year <- year(updated_calls$`Call Time`)

### Filter the dataset to keep only rows where 'year' is 2017 ----
updated_calls <- updated_calls %>% filter(year == 2017)
calls <- calls %>% filter(year == 2017)


# Ratio Tests ----
### Ratio test of zip codes ----

options(scipen = 999) #prevent scientific notation

# Create Summary of the original 911 Call data set zip codes
# Create Data Frame to display the number of times a zip code appears in the original 911 Call data set
calls_summary <- calls %>%
  group_by(zip_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
View(calls_summary)
# Define Value of total Calls in the new 911 Data set
total_calls <- nrow(calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the original data set
calls_summary <- calls_summary %>%
  mutate(proportion = count / total_calls)

# Create Summary of the new 911 Call data set zip codes
# Create Data Frame to display the number of times a zip code appears in the new 911 Call data set
updated_calls_summary <- updated_calls %>%
  group_by(zip_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
View(updated_calls_summary)
# Define Value of total Calls in the new 911 Data set
total_updated_calls <- nrow(updated_calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the new data set
updated_calls_summary <- updated_calls_summary %>%
  mutate(proportion = count / total_updated_calls)

# Create Full join based on the zip codes to compare summaries and porpotions
merged_summary <- calls_summary %>%
  full_join(updated_calls_summary, by = "zip_code")
View(merged_summary)

# Calculate the percentage change of calls per zip code
merged_summary <- merged_summary %>%
  mutate(percentage_change = ((count.y - count.x) / count.x) * 100)
# calculate the difference in proportions between the original and the new 911 calls
merged_summary <- merged_summary %>%
  mutate(proportion_diff = proportion.x - proportion.y)


### Ratio test by call description ----
calls_summary_description <- calls %>%
  group_by(calldescription) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
View(calls_summary_description)
# Define Value of total Calls in the new 911 Data set
total_calls <- nrow(calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the original data set
calls_summary_description <- calls_summary_description %>%
  mutate(proportion = count / total_calls)

# Create Summary of the new 911 Call data set zip codes
# Create Data Frame to display the number of times a zip code appears in the new 911 Call data set
updated_calls_summary_description <- updated_calls %>%
  group_by(calldescription) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
View(updated_calls_summary_description)
# Define Value of total Calls in the new 911 Data set
total_updated_calls <- nrow(updated_calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the new data set
updated_calls_summary_description <- updated_calls_summary_description %>%
  mutate(proportion = count / total_updated_calls)

# Create Full join based on the zip codes to compare summaries and porpotions
merged_summary_description <- calls_summary_description %>%
  full_join(updated_calls_summary_description, by = "calldescription")
View(merged_summary_description)

# Calculate the percentage change of calls per zip code
merged_summary_description <- merged_summary_description %>%
  mutate(percentage_change = ((count.y - count.x) / count.x) * 100)
# calculate the difference in proportions between the original and the new 911 calls
merged_summary_description <- merged_summary_description %>%
  mutate(proportion_diff = proportion.x - proportion.y)

### Ratio test by priority ----
calls_summary_priority <- calls %>%
  group_by(priority) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
# Define Value of total Calls in the new 911 Data set
total_calls <- nrow(calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the original data set
calls_summary_priority <- calls_summary_priority %>%
  mutate(proportion = count / total_updated_calls)

# Create Summary of the new 911 Call data set zip codes
# Create Data Frame to display the number of times a zip code appears in the new 911 Call data set
updated_calls_summary_priority <- updated_calls %>%
  group_by(priority) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
# Define Value of total Calls in the new 911 Data set
total_updated_calls <- nrow(updated_calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the new data set
updated_calls_summary_priority <- updated_calls_summary_priority %>%
  mutate(proportion = count / total_updated_calls)

# Create Full join based on the zip codes to compare summaries and porpotions
merged_summary_priority <- calls_summary_priority %>%
  full_join(updated_calls_summary_priority, by = "priority")
View(merged_summary_priority)

# Calculate the percentage change of calls per zip code
merged_summary_priority <- merged_summary_priority %>%
  mutate(percentage_change = ((count.y - count.x) / count.x) * 100)
# calculate the difference in proportions between the original and the new 911 calls
merged_summary_priority <- merged_summary_priority %>%
  mutate(proportion_diff = proportion.x - proportion.y)

