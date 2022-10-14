source("config.R")
source("utility_fun.R")


########### School Risk and Protective Factors ########### 
rhds01 = load_instrument("abcd_rhds01",abcd_files_path)

rhds01_lean = rhds01[, grepl("^(src|interview|event|sex)|reshist_(state|addr1_adi_(ws|pe))", colnames(rhds01))]

write.csv(file = "outputs/geo_data.csv",x = rhds01_lean, row.names = F, na = "")


