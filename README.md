##########
# ABCD_SGM


#### This project uses the following ABCD instruments [version 4.0]:

1. pdem02
2. abcd_lpds01
3. abcd_ydmes01
4. acspsw03
5. abcd_cb01 
6. abcd_lpksad01
7. abcd_rhds01
8. abcd_yksad01
9. abcd_cbcls01
10. abcd_mhy02
11. abcd_yssbpm01
12. abcd_ksad501
13. abcd_lt01


#### How to run the code:

1. update the [config.R](config.R) to reflect the location of the instruments above.
2. In the "data scripts"" folder, run scripts in any order. These scripts go over the abcd instruments and create new variables and datasets that are placed in the “data” folder.
In the demographics folder, the script [organize_demographics.R](data scripts/organize_demographics.R) should be run after the other two scripts.
3. Run the [merging.R](scripts/merging.R) and [merging_wide_data.Rmd](scripts/merging_wide_data.Rmd) script to create the long and wide format dataset.
4. Run the [creating_table1.Rmd](scripts/creating_table1.Rmd) to generate table 1 of the main paper and supplement.
5. Run the [correlation_plot.Rmd](scripts/correlation_plot.Rmd) to generate correlation plot.
5. Run the [creating_plots.Rmd](scripts/creating_plots.Rmd) to generate plots.
6. Run the [mixed_models.Rmd](scripts/mixed_models.Rmd) for mixed models.
7. Run the [mediation.Rmd](scripts/mediation.Rmd) for mediation analyses.