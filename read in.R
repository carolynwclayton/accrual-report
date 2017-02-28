###
# NOTE: This file reads in a database from REDCAP by finding the most recent .r read-in file of interest in the working directory, so that the appropriate database can be sourced automatically each time the accrual report is run. 
###

### Information of interest: ----------------------------------------------------------
# All files output by REDCAP include the date and time of output in the file name.
# All .r files output by REDCAP under the R output option list the name of the database and then "_R_" in the file name.

# The REDCAP read-in file automatically reads the database into the environment under the object name "data", so be aware if you already have an object in your environment called "data" it will be overwritten.
# This can be changed so that it will not automatically call every new database "data", but would necessitate an extra suppressWarnings("cmd.exe") in try() which would find and replace the "data=read.csv" section of the REDCAP read-in file with the user-input db_name, so it would read something like "example_data_input=read.csv".
# However, I do not currently have this expertise, so we will just save "data" as the user-assigned file_name.

# USER INPUT REQUIRED -----------------------------------------------------------------
# Change to name of database of interest
db_name <- "example_data_input"
# Change to name you wish to save the resulting file as
file_name <- "example_data_output"


# Loading the required libraries. -----------------------------------------------------
library(plyr)
library(dplyr)
# library(tidytext)
library(magrittr)

# READING IN THE DATA FROM REDCAP -----------------------------------------------------

### Find the most recent file in the working directory

# List all the .R read-in files of interest in the working directory.
file_list <- list.files(pattern = paste("^", db_name, "_R_", ".*", ".r$", sep = ""))

# Split the name of the file by "_" or "."
file_list_wide <- strsplit(file_list, "[_ .]") %>%
  sapply(., `[`) %>%
  t %>%
  data.frame(stringsAsFactors = FALSE)

# Identify the file name with the most recent date and time
date_var <- which(sapply(file_list_wide, function(x) any(!is.na(as.Date(x,format="%Y-%m-%d")))))  # Find which variable could be a date and select it (note, this could present some problems if, for some reason, your file name contains two sections which could be dates)
time_var <- date_var + 1  # Note this will not work if the time variable in the name output by REDCAP is not directly to the right of the date variable. 
                          # time_var is hard-coded instead of searching for a format (as in date_var) because it is possible that the database name may include another section that looks like a time. However, REDCAP currently outputs all database files with date then time in the file name.

file_maxdate <- file_list_wide %>%
  .[,date_var] %>%  
  as.Date(format = "%Y-%m-%d")  %>%
  max

file_maxtime <- file_list_wide %>%
  .[as.Date(.[, date_var], format = "%Y-%m-%d") == file_maxdate, time_var] %>%
  max  # We can find the max directly, without converting the time_var to a date/time format because the time is given in military time (24h), and we have already selected only the times that appear on the maxdate.

i <- which(file_list_wide[,date_var] == file_maxdate & file_list_wide[,time_var] == file_maxtime)
  
chosen_file <- as.character(file_list[i])

### Execute the most recent file

# We remove the "rm(list=ls())" line of code (which would clear the environment) in each read-in file, in case we have other objects of interest in our environment currently.

# OPTION 1. Uses the shell to edit the files themselves. Preferrable because it's more flexible, but throws a "status 1" error if the line does not exist in the file (i.e. if this code is run again on the same REDCAP read-in file).
try({  # Curly braces so that multiple lines can be tried
    old <- paste0(chosen_file, ".old")  # concatenate the name of the chosen file and ".old"
    suppressWarnings(system(paste("cmd.exe /c ren", chosen_file, old)))  # change the original file name to the value of the object "old"
    suppressWarnings(system(paste("cmd.exe /c findstr /v rm(list=ls())", old, ">", chosen_file)))  # find the string "rm(list=ls())" in the old file and print (to a new file which will be called the value of chosen_file) only the lines that do not contain a match to that string
    unlink(old, recursive = FALSE, force = FALSE)  # Delete the .old file
})  # Evaluates an expression and stores the error messages. 
# Essentially this allows the code chunk to be tried, but not to break the file run if it fails (because the offending rm(list) line has already been removed).

# Execute the read-in files and assign the database names
source(chosen_file)
assign(file_name, data, envir = .GlobalEnv)  # rename the object "data" to the user-input "file_name" in the global environment. This is done instead of the assignment operator (file_name <- data ) because file_name may be different every time.

# # OPTION 2. Slightly slower and less flexible (i.e. can break if the offending line is not on line 2), but more readable. Uses readLines to read and evaluate all lines except line #2 (which contains "rm(list=ls())").
# eval(parse(readLines(chosen_file)[-2]))

# DATA CLEANING -----------------------------------------------------
###REDO this with filter()
# Split out the adverse events from visits_data
adverse_events <- subset(visits_data, visits_data$redcap_event_name == "ongoing_forms")
adverse_events <- adverse_events[,which(unlist(lapply(adverse_events, function(x)!all(is.na(x)))))]  # Keep columns where the there is at least one piece of data. The lapply is used to make the code run faster, because is.na makes a copy of the object, which for large objects can be a problem.
adverse_events <- adverse_events[,which(unlist(lapply(adverse_events, function(x)!all(is.factor(x) & (x) == ""))))]  # Remove columns where factor variables are == "" in all rows.
adverse_events <- select(adverse_events, -matches("redcap_event_name"))

# Split out the screening visit (demographics) from visits_data
screening_demos <- subset(visits_data, visits_data$redcap_event_name == "screening_visit")
screening_demos <- screening_demos[,which(unlist(lapply(screening_demos, function(x)!all(is.na(x)))))]  # Keep columns where the there is at least one piece of data. The lapply is used to make the code run faster, because is.na makes a copy of the object, which for large objects can be a problem.
screening_demos <- screening_demos[,which(unlist(lapply(screening_demos, function(x)!all(is.factor(x) & (x) == ""))))]  # Remove columns where factor variables are == "" in all rows.
screening_demos <- select(screening_demos, -matches("redcap_event_name"))

# Add a variable, race_cat, to screening_demos which is a combination of nih_race and nih_ethnicity
screening_demos <- mutate(screening_demos, race_cat = paste(nih_race.factor, nih_ethnicity.factor))

# Add a variable, cohort, to screening_demos which a combination of nih_race and nih_sex
screening_demos <- mutate(screening_demos, cohort = paste(nih_race.factor, nih_sex.factor))

# Sort the dataset first by pid, then by redcap_event_name
example_data <- arrange(example_data, pid, redcap_event_name)

# Rename redcap_event_name to visit_number
example_data <- rename(example_data, visit_number = redcap_event_name)

# SAVING THE DATA AND CLEANUP -----------------------------------------------------

# Save Dataset as a .Rda file
save(data, file = paste(file_name, ".Rda", sep = ""))

# Clean the environment of objects used in this read in file
rm(db_name, file_name, file_list, file_list_wide, date_var, time_var, file_maxdate, file_maxtime, i, chosen_file, old, data)