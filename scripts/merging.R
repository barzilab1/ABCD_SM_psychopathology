library(readr)
library(dplyr)
library(modelr)
library(lubridate)


family <- read_csv("data/family.csv") %>% 
  mutate(interview_date = mdy(interview_date))
site <- read_csv("data/site.csv") %>% 
  mutate(interview_date = mdy(interview_date))
exposome_set <- read.csv("data/exposome_set.csv") %>% 
  mutate(interview_date = mdy(interview_date))
geo_data <- read_csv("data/geo_data.csv") %>% 
  mutate(interview_date = mdy(interview_date))
psychopathology <- read_csv("data/psychopathology.csv") %>% 
  mutate(interview_date = mdy(interview_date))
psychopathology_sum <- read_csv("data/psychopathology_sum_scores.csv") %>% 
  mutate(interview_date = mdy(interview_date))
suicide_set <- read_csv("data/suicide_set.csv") %>% 
  mutate(interview_date = ymd(interview_date))
demographics_all <- read_csv("data/demographics_all.csv")
demo_race <- read_csv("data/demo_race.csv")

demographics <- merge(demographics_all, demo_race) %>% 
  mutate(interview_date = mdy(interview_date))

dataset <- merge(exposome_set, psychopathology, all = T)
dataset <- merge(dataset, psychopathology_sum, all.x = T)
dataset <- merge(dataset, suicide_set, all = T)
dataset <- merge(dataset, site, all = T)
dataset <- merge(dataset, demographics, all =T)

dataset <- dataset[!dataset$eventname %in% c("3_year_follow_up_y_arm_1"),]

geo_data_baseline <- geo_data[geo_data$eventname == "baseline_year_1_arm_1", grep("src|reshist_state_[^m]|reshist_addr1_adi_perc", colnames(geo_data), value = T)]

dataset <- merge(dataset, family[,c("src_subject_id", "sex", "rel_family_id")], all.x = T)
dataset <- merge(dataset, geo_data_baseline)

dataset <- dataset %>% 
  mutate(eventname = recode(eventname, 
                            `1_year_follow_up_y_arm_1` = "1",
                            `2_year_follow_up_y_arm_1` = "2",
                            baseline_year_1_arm_1 = "bl"),
         age_year = age/12) 

write.csv(file = "data/dataset_SGM_3tp.csv", x = dataset, row.names = F, na = "")

# Create data for mixed models (at 1-year and 2-year follow-up)
dataset_long <- dataset[dataset$eventname %in% c("1","2"),]
dataset_long <- dataset_long[,colSums(is.na(dataset_long)) != nrow(dataset_long)]

# replace parent education - 2y as 1y
edu_2y <- dataset_long %>% filter(eventname == "1") %>% 
  dplyr::select(src_subject_id, parents_avg_edu) %>% 
  rename(parents_avg_edu_2 = "parents_avg_edu") %>% 
  mutate(eventname = "2")

dataset_long <- dataset_long %>% 
  left_join(edu_2y) %>% 
  mutate(parents_avg_edu = coalesce(parents_avg_edu, parents_avg_edu_2)) %>% 
  dplyr::select(-parents_avg_edu_2)

# Regressed out ADI from household income # Create residuals of househ old income
dataset_long <- add_residuals(data = dataset_long,
                              model = lm(scale(household_income) ~ reshist_addr1_adi_perc, data = dataset_long),
                              var = "income_resid")

write.csv(file = "data/dataset_SGM_long_mm.csv", x = dataset_long, row.names = F, na = "")






