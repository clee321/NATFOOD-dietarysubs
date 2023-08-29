

**********************
*Ranking by intensity*
**********************

use "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder", clear

*Collapse by foodcat_lvl1
collapse (mean) mean_ghg100 = ghg100 (median) med_ghg100 = ghg100 (sd) sd_ghg100 = ghg100 (count) freq = seqn, by(food_code drxfcsd foodcat_lvl1)

order foodcat_lvl1

gsort -mean_ghg100

export excel "Analysis_foodcodes_ghg.xlsx", firstrow(variables) keepcellfmt replace


levelsof foodcat, local(foodcat_lvl1)
foreach f of local foodcat_lvl1 {
        export excel using "Analysis_foodcodes_ghg.xlsx" ///
         if foodcat =="`f'", sheet("`f'") firstrow(variables) keepcellfmt sheetmodify
}

******* by Food category 3

use "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder", clear

*Collapse by foodcat_lvl1
collapse (mean) mean_ghg100 = ghg100 (count) freq = seqn, by(category_number category_description foodcat_lvl1)

order foodcat_lvl1

gsort -mean_ghg100

export excel "Analysis_foodlvl3_ghg100.xlsx", firstrow(variables) keepcellfmt replace


levelsof foodcat, local(foodcat_lvl1)
foreach f of local foodcat_lvl1 {
        export excel using "Analysis_foodlvl3_ghg100.xlsx" ///
         if foodcat =="`f'", sheet("`f'") firstrow(variables) keepcellfmt sheetmodify
}

*******



