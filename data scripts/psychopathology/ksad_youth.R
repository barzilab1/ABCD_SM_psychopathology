source("config.R")
source("utility_fun.R")
library(dplyr)

ksad_y <- load_instrument("abcd_ksad501", abcd_files_path)

#555 and 888 will be treated as NA
ksad_y[ksad_y == "888" | ksad_y == "555"] = NA


# ksad_y_diagnosis <- ksad_y[,grepl("src|inter|event|sex|_((8[3-4][0-9])|863|864|869|870|(9[1-2][1-4])|969|970)|(91[7-9])|920|945|956_t",colnames(ksad_y))]
#remove empty col
ksad_y_diagnosis <- ksad_y[,!colSums(is.na(ksad_y)) == nrow(ksad_y)]

#create diagnosis variables
#if 0 or NA then 0
ksad_y_diagnosis$diagnosis_bipolar_y = apply(ksad_y_diagnosis[,grepl("ksads_2_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_bipolar_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_bipolar_y) & 
                                                  (apply(ksad_y_diagnosis[,which(grepl("ksads_2_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                               0, ksad_y_diagnosis$diagnosis_bipolar_y)


ksad_y_diagnosis$diagnosis_depression_y = apply(ksad_y_diagnosis[,grepl("ksads_1_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_depression_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_depression_y) & 
                                                     (apply(ksad_y_diagnosis[,which(grepl("ksads_1_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                                  0, ksad_y_diagnosis$diagnosis_depression_y)


ksad_y_diagnosis$diagnosis_DMDD_y = ksad_y_diagnosis$ksads_3_848_t



ksad_y_diagnosis$diagnosis_anxiety_y = apply(ksad_y_diagnosis[,grepl("ksads_(8|10)_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_anxiety_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_anxiety_y) & 
                                                  (apply(ksad_y_diagnosis[,which(grepl("ksads_(8|10)_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                               0, ksad_y_diagnosis$diagnosis_anxiety_y)


ksad_y_diagnosis$diagnosis_sleep_y = apply(ksad_y_diagnosis[,grepl("ksads_22_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_sleep_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_sleep_y) & 
                                                (apply(ksad_y_diagnosis[,which(grepl("ksads_22_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                             0, ksad_y_diagnosis$diagnosis_sleep_y)


ksad_y_diagnosis$diagnosis_ocd_y = apply(ksad_y_diagnosis[,grepl("ksads_11_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_ocd_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_ocd_y) & 
                                              (apply(ksad_y_diagnosis[,which(grepl("ksads_11_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                           0, ksad_y_diagnosis$diagnosis_ocd_y)


ksad_y_diagnosis$diagnosis_ptsd_y = apply(ksad_y_diagnosis[,grepl("ksads_21_.*_t", colnames(ksad_y_diagnosis))], 1, function(x) {any(x == 1)*1})
ksad_y_diagnosis$diagnosis_ptsd_y = ifelse( (is.na(ksad_y_diagnosis$diagnosis_ptsd_y) & 
                                               (apply(ksad_y_diagnosis[,which(grepl("ksads_21_.*_t", colnames(ksad_y_diagnosis)))], 1, function(x) {any(x == 0)}))), 
                                            0, ksad_y_diagnosis$diagnosis_ptsd_y)


summary(ksad_y_diagnosis[ksad_y_diagnosis$eventname == "baseline_year_1_arm_1",]) 
summary(ksad_y_diagnosis[ksad_y_diagnosis$eventname == "1_year_follow_up_y_arm_1",]) 
summary(ksad_y_diagnosis[ksad_y_diagnosis$eventname == "2_year_follow_up_y_arm_1",]) 

write.csv(file = "outputs/ksad_y_diagnosis.csv", x = ksad_y_diagnosis, row.names=F, na = "")
