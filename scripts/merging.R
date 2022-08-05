library(readr)
library(dplyr)
library(modelr)


family <- read_csv("outputs/family.csv")
site <- read_csv("outputs/site.csv")
exposome_set <- read.csv("outputs/exposome_set.csv")
exposome_sum_set <- read_csv("outputs/exposome_sum_set.csv")
externalize_dataset <- read_csv("outputs/externalize_dataset.csv")
geo_data <- read_csv("outputs/geo_data.csv")
ksad_y_diagnosis <- read_csv("outputs/ksad_y_diagnosis.csv")
physicalhealth_sum <- read_csv("outputs/physicalhealth_sum.csv")
psychopathology <- read_csv("outputs/psychopathology.csv")
psychopathology_sum <- read_csv("outputs/psychopathology_sum_scores.csv")
suicide_set <- read_csv("outputs/suicide_set.csv")
demographics_baseline <- read.csv("outputs/demographics_baseline.csv")
demographics_long <- read.csv("outputs/demographics_long.csv")

# combine the demographics to one dataset
demo_race = demographics_baseline[,grep("src|race|hisp", colnames(demographics_baseline))]

demographics_long = merge(demographics_long, demo_race)
demographics_long = demographics_long[demographics_long$eventname != "baseline_year_1_arm_1",]
demographics = bind_rows(demographics_baseline, demographics_long)


dataset <- merge(exposome_set, exposome_sum_set, all = T)
dataset <- merge(dataset, externalize_dataset, all = T)
dataset <- merge(dataset, ksad_y_diagnosis, all = T)
dataset <- merge(dataset, physicalhealth_sum, all = T)
dataset <- merge(dataset, psychopathology, all = T)
dataset <- merge(dataset, psychopathology_sum, all = T)
dataset <- merge(dataset, suicide_set, all = T)
dataset <- merge(dataset, site, all = T)
dataset <- merge(dataset, demographics, all =T )

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

write.csv(file = "outputs/dataset_SGM_3tp.csv", x = dataset, row.names = F, na = "")

# Create data for mixed models (at 1-year and 2-year follow-up)
dataset_long <- dataset[dataset$eventname %in% c("1","2"),]
dataset_long <- dataset_long[,colSums(is.na(dataset_long)) != nrow(dataset_long)]
# dataset_long <- dataset_long %>% 
#   mutate(eventname = recode(eventname, 
#                             `1_year_follow_up_y_arm_1` = "1",
#                             `2_year_follow_up_y_arm_1` = "2"),
#          age_year = age/12)

# dataset_long$SI_y <- as.factor(dataset_long$SI_y)
# dataset_long$SA_y <- as.factor(dataset_long$SA_y)

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

write.csv(file = "outputs/dataset_SGM_long_mm.csv", x = dataset_long, row.names = F, na = "")






