library(readr)
library(dplyr)
library(lubridate)
library(magrittr)
library(tidyverse)
library(readxl)
library(arsenal)


calls <- read_csv("Downloads/calls_final.csv")
View(calls)

updated_calls <- read_csv("Downloads/Police_Serviced_911_Calls_6235174473015125577.csv")
View(updated_calls)

calls <- select(calls, -agency, -priority, -callcode, -intaketime, -dispatchtime, -traveltime, -totalresponsetime, -time_on_scene, -totaltime, -block_id, -oid)
updated_calls <- select(updated_calls, -"Call Source", -Priority, -"Nature Code", -"Call Group", -"Intake Time", -"Dispatch Time", -"Travel Time", -"On Scene Time", -"Total Response Time", -"Total Time", -ESRI_OID)
updated_calls <- updated_calls %>%
  rename(priority = Priority)
  rename(calldescription = `Code Description`)
  rename(zip_code = "Zip Code")

# Create Year Variable
calls$call_timestamp <- ymd_hms(calls$call_timestamp)  # Convert to datetime format
calls$date_only <- as.Date(calls$call_timestamp)
calls$year <- year(calls$call_timestamp)  # Extract the year

matching_calls$call_timestamp <- ymd_hms(matching_calls$call_timestamp)  # Convert to datetime format
matching_calls$date_only <- as.Date(matching_calls$call_timestamp)
# Assuming your dataset is named 'updated_calls' and the column is 'Call Time'

# Create year variable in updated_calls
updated_calls$`Call Time` <- mdy_hms(updated_calls$`Call Time`)
updated_calls$year <- year(updated_calls$`Call Time`)

# Filter the dataset to keep only rows where 'year' is 2017
updated_calls <- updated_calls %>% filter(year == 2017)
calls <- calls %>% filter(year == 2017)


updated_calls <- updated_calls %>%
  rename(incident_id = "Incident ID")

merged_calls <- full_join(calls, updated_calls, by = "incident_id")
View(merged_calls)

matching_calls <- inner_join(calls, updated_calls, by = "incident_id")
View(matching_calls)


comparison_result <- matching_calls$longitude == matching_calls$Longitude

# Check if the two variables are identical across the entire dataset
identical(matching_calls$longitude, matching_calls$x)

# Find rows where 'variable1' does not match 'variable2'
non_matching_rows <- matching_calls %>% filter(longitude != Longitude, latitude != Latitude)
non_matching_rows <- select(non_matching_rows, incident_id, longitude, Longitude, latitude, Latitude, calldescription, `Code Description`)

identical(matching_calls$call_timestamp, matching_calls$`Call Time`)
identical(matching_calls$calldescription, matching_calls$`Code Description`)

# compare the two dataframes and output a list of all the discrepancies between them
DDE_output = comparedf(calls, updated_calls)
discrepancies = diffs(DDE_output)


# Find rows in `calls` that are NOT in `updated_calls`
not_merged <- anti_join(updated_calls, matching_calls)

duplicates <- matching_calls[
  duplicated(matching_calls[, c("incident_address", "date_only")]) |
    duplicated(matching_calls[, c("incident_address", "date_only")], fromLast = TRUE),
]


sum(is.na(updated_calls$"Nearest Intersection"))

not_merged_calls <- anti_join(calls, matching_calls)


# Ratio Tests 
## Ratio test of zip codes

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
  mutate(proportion = count / total_updated_calls)

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


### Ratio test by call description
calls_summary_description <- calls %>%
  group_by(calldescription) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
View(calls_summary_description)
# Define Value of total Calls in the new 911 Data set
total_calls <- nrow(calls)
# Calculate the number of calls which appear in each zip code per total number of 911 calls from the original data set
calls_summary_description <- calls_summary_description %>%
  mutate(proportion = count / total_updated_calls)

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

### Ratio test by priority
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

