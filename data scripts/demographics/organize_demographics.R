library(dplyr)
library(readr)

## organize demographics ####
demographics_baseline <- read_csv("data/demographics_baseline.csv")
demographics_long <- read_csv("data/demographics_long.csv")

demo_race = demographics_baseline[,grep("src|sex|race|hisp|born_in_usa|roster", colnames(demographics_baseline))]
demographics_baseline = demographics_baseline[, grep("race|hisp|born_in_usa|roster", colnames(demographics_baseline), invert= T)]

demographics_long = demographics_long[demographics_long$eventname != "baseline_year_1_arm_1",]
demographics_long = bind_rows(demographics_baseline, demographics_long)


write.csv(file = "data/demographics_all.csv", x = demographics_long, row.names=F, na = "")
write.csv(file = "data/demo_race.csv", x = demo_race, row.names=F, na = "")






















