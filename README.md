##########
# ABCD_SGM


#### This project uses the following ABCD instruments [version 4.0]:

1. pdem02
2. abcd_lpds01
3. abcd_ydmes01
4. abcd_yle01
5. acspsw03
6. abcd_cb01
7. abcd_lpksad01
8. abcd_sscey01
9. abcd_rhds01
10. abcd_ant01
11. abcd_ssphp01
12. abcd_ssphy01
13. abcd_yksad01
14. abcd_ksad01
15. abcd_cbcls01
16. abcd_mhy02
17. abcd_yssbpm01
18. abcd_ksad501
19. abcd_lt01


#### How to run the code:

1. update the [config.R](config.R) to reflect the location of the instruments above.
2. In the data-scripts folder, run scripts in any order. These scripts go over the abcd instruments and create new variables and datasets that are placed in the “outputs” folder.
3. Run the [merging.R](/scripts/merging.R) and [merging_wide_data.R](/scripts/merging_wide_data.R) script to create the long and wide format dataset.
4. Run the [create_table1.Rmd](/scripts/create_table1.Rmd) to generate table 1 of the main paper and supplement.
5. Run the [correlation_plot.Rmd](/scripts/correlation_plot.Rmd) to generate correlation plot.
5. Run the [creating_plots.Rmd](/scripts/creating_plots.Rmd) to generate plots.
6. Run the [mixed_models.Rmd](/script/mixed_models.Rmd) for mixed models.
7. Run the [mediation.Rmd](/script/mediation.Rmd) for mediation analyses.