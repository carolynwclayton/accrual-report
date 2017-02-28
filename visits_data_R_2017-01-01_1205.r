#Clear existing data and graphics
graphics.off()
#Load Hmisc library
library(Hmisc)
#Read Data
data=read.csv('visits_data_DATA_2017-01-01_1205.csv')
#Setting Labels

label(data$pid)="Participant ID (PID)"
label(data$redcap_event_name)="Event Name"
label(data$age)="Age"
label(data$nih_sex)="Sex at birth"
label(data$nih_race)="Race  (Choose those with which you identify)"
label(data$nih_ethnicity)="Ethnicity  (Choose the one with which you MOST CLOSELY identify)"
label(data$first_treatment)="Initial Treatment"
label(data$second_treatment)="Second Treatment"
label(data$ae_new)="Is there an adverse event?"
label(data$ae_severity)="Severity"
label(data$ae_experience)="Adverse Event Experience"
label(data$ae_new2)="Is there another adverse event?"
label(data$ae_severity2)="Severity"
label(data$ae_experience2)="Adverse Event Experience"
label(data$ae_new3)="Is there another adverse event?"
label(data$ae_severity3)="Severity"
label(data$ae_experience3)="Adverse Event Experience"
label(data$ae_new4)="Is there another adverse event?"
label(data$ae_severity4)="Severity"
label(data$ae_experience4)="Adverse Event Experience"
#Setting Units


#Setting Factors(will create new variable for factors)
data$nih_race.factor <- factor(data$nih_race,levels=c("1","2","3","4"))
data$nih_sex.factor <- factor(data$nih_sex,levels=c("1","2"))
data$nih_ethnicity.factor <- factor(data$nih_ethnicity,levels=c("1","2"))
data$first_treatment.factor <- factor(data$first_treatment,levels=c("1","2", "3", "4"))
data$second_treatment.factor <- factor(data$second_treatment,levels=c("1","2", "3", "4"))
data$ae_new.factor <- factor(data$ae_new, levels=c("0", "1"))
data$ae_experience.factor <- factor(data$ae_experience, levels=c("1", "2", "3", "4"))
data$ae_severity.factor <- factor(data$ae_severity, levels=c("0", "1"))
data$ae_new2.factor <- factor(data$ae_new2, levels=c("0", "1"))
data$ae_experience2.factor <- factor(data$ae_experience2, levels=c("1", "2", "3", "4"))
data$ae_severity2.factor <- factor(data$ae_severity2, levels=c("0", "1"))
data$ae_new3.factor <- factor(data$ae_new3, levels=c("0", "1"))
data$ae_experience3.factor <- factor(data$ae_experience3, levels=c("1", "2", "3", "4"))
data$ae_severity3.factor <- factor(data$ae_severity3, levels=c("0", "1"))
data$ae_new4.factor <- factor(data$ae_new4, levels=c("0", "1"))
data$ae_experience4.factor <- factor(data$ae_experience4, levels=c("1", "2", "3", "4"))
data$ae_severity4.factor <- factor(data$ae_severity4, levels=c("0", "1"))

levels(data$nih_race.factor) <- c("White","Black or African-American", "More than one race", "Unknown or not reported")
levels(data$nih_sex.factor) <- c("Female", "Male")
levels(data$nih_ethnicity.factor) <- c("Hispanic or Latino", "Not Hispanic or Latino")
levels(data$first_treatment.factor) <- c("Treatment 1", "Treatment 2", "Treatment 3", "Treatment 4")
levels(data$second_treatment.factor) <- c("Treatment 1", "Treatment 2", "Treatment 3", "Treatment 4")
levels(data$ae_new.factor) <- c("No", "Yes")
levels(data$ae_experience.factor) <- c("Headache", "Nausea", "Diarrhea", "Other")
levels(data$ae_severity.factor) <- c("Moderate", "Severe")
levels(data$ae_new2.factor) <- c("No", "Yes")
levels(data$ae_experience2.factor) <- c("Headache", "Nausea", "Diarrhea", "Other")
levels(data$ae_severity2.factor) <- c("Moderate", "Severe")
levels(data$ae_new3.factor) <- c("No", "Yes")
levels(data$ae_experience3.factor) <- c("Headache", "Nausea", "Diarrhea", "Other")
levels(data$ae_severity3.factor) <- c("Moderate", "Severe")
levels(data$ae_new4.factor) <- c("No", "Yes")
levels(data$ae_experience4.factor) <- c("Headache", "Nausea", "Diarrhea", "Other")
levels(data$ae_severity4.factor) <- c("Moderate", "Severe")

