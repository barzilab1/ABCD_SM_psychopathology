library(data.table)
source("config.R")
source("utility_fun.R")

################### cbcls ################### 
cbcls01 = load_instrument("abcd_cbcls01", abcd_files_path)

#get the t scores
cbcls_t_score = cbcls01[, grepl("^(src|interview|event|sex)|totprob_(t|r)$", colnames(cbcls01))]


################### Sum Scores Mental Health Youth ################### 
mhy = load_instrument("abcd_mhy02", abcd_files_path)

#remove nt (Number Total Questions) and nm (Number Missing Answers)
mhy = mhy[, grepl("src|interview|sex|event|ple_y_ss_total_bad|peq.*(aggs|tim|sion)$", colnames(mhy))]

# mhy$pstr_ss_pr = NULL


setDT(mhy)
mhy[,bully_vic:= peq_ss_relational_victim +peq_ss_reputation_victim +peq_ss_overt_victim]
mhy[,bully_aggs:= peq_ss_relational_aggs+peq_ss_reputation_aggs+peq_ss_overt_aggression]

################### Youth Summary Scores BPM and POA ################### 
yssbpm01 = load_instrument("abcd_yssbpm01", abcd_files_path)
yssbpm01 = yssbpm01[, grepl("src|interv|event|sex|prob_(t|r)$", colnames(yssbpm01))]
# yssbpm01 = yssbpm01[yssbpm01$eventname %in% c("2_year_follow_up_y_arm_1", "1_year_follow_up_y_arm_1"), ]



psychopathology_sum_scores = merge(cbcls_t_score, mhy)
psychopathology_sum_scores = merge(psychopathology_sum_scores, yssbpm01, all.x = T)


write.csv(file = "data/psychopathology_sum_scores.csv",x = psychopathology_sum_scores, row.names = F, na = "")

