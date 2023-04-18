source("config.R")
source("utility_fun.R")


################### Youth Diagnostic Interview for DSM-5 Background Items 5 (lgbt/bullying/drop a class) ################### 
yksad01 = load_instrument("abcd_yksad01", abcd_files_path)

yksad01 = yksad01[, !grepl("___|admin|grade|deive", colnames(yksad01))]

yksad01[yksad01 == "777"] = NA

# LGBT: Yes to “Are you gay or bisexual?” or “Are you transgender?”
yksad01$LGBT = (yksad01$kbi_y_sex_orient == 1 | yksad01$kbi_y_trans_id == 1)*1
yksad01$LGBT = ifelse( (is.na(yksad01$LGBT) & (yksad01$kbi_y_sex_orient %in% c(2,3) | yksad01$kbi_y_trans_id %in% c(2,3) )),
                       0, yksad01$LGBT)
# LGBT_inclusive: Yes/Maybe to “Are you gay or bisexual?” or “Are you transgender?”
yksad01$LGBT_inclusive = (yksad01$kbi_y_sex_orient <= 2 | yksad01$kbi_y_trans_id <= 2)*1
yksad01$LGBT_inclusive = ifelse( (is.na(yksad01$LGBT_inclusive) & (yksad01$kbi_y_sex_orient  == 3 | yksad01$kbi_y_trans_id == 3 )),
                       0, yksad01$LGBT_inclusive)

# sex_orient_bin: Yes to “Are you gay or bisexual?”
yksad01$sex_orient_bin = ifelse(yksad01$kbi_y_sex_orient == 1, 1, 0)

# sex_orient_bin_inclusive: Yes/Maybe to “Are you gay or bisexual?”
yksad01$sex_orient_bin_inclusive = ifelse(yksad01$kbi_y_sex_orient <= 2, 1, 0)



write.csv(file = "data/psychopathology.csv",x = yksad01, row.names = F, na = "")

