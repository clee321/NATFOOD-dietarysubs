** Calculate Ranking of total GHG per food category

********************************************************
** TOTAL GHGE BASED ON DIFFERENT FOOD CATEGORY LEVELS **
********************************************************

************************
*Collapse by Food codes*
************************

cd "$Analysis/Ranking/2015-16/total_ghg"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

* Summary table with total GHGE, mean GHGE, mean GHG100, and SEQN count based on Food codes (showing food description and level 1 food categories)
* Adjusted for dietary weight

collapse (sum) total_ghgcons = ghg_consumed (sum) total_grams = grams (mean) mean_ghgcons = ghg_consumed (mean) mean_ghg100 = ghg100 (count) freq=seqn [pw=wtdrd1], by(food_code drxfcsd foodcat_lvl1)

order foodcat_lvl1
gsort -total_ghgcons

* Export to excel: Each level 1 food category has its own tab.
export excel "Analysis_foodcodes_ghgconsumed_weighted.xlsx", firstrow(variables) keepcellfmt replace
levelsof foodcat_lvl1, local(foodcat_lvl1)
foreach f of local foodcat_lvl1 {
        export excel using "Analysis_foodcodes_ghgconsumed_weighted.xlsx" ///
         if foodcat_lvl1 =="`f'", sheet("`f'") firstrow(variables) keepcellfmt sheetmodify
}

******************************
*Collapse by Food Cat Level 3*
******************************

cd "$Analysis/Ranking/2015-16/total_ghg"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

* Summary table with total GHGE, mean GHG100, and SEQN count based on Level 3 food category (showing categ. description and level 1 food categories)
* Adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed (mean) mean_ghg100 = ghg100 (count) freq = seqn [pw=wtdrd1], by(category_number category_description foodcat_lvl1)

order foodcat_lvl1
gsort -total_ghgcons


* Export to excel: Each level 1 food category has its own tab.
export excel "Analysis_foodcatlvl3_ghgconsumed_weighted.xlsx", firstrow(variables) keepcellfmt replace
levelsof foodcat_lvl1, local(foodcat_lvl1)
foreach f of local foodcat_lvl1 {
        export excel using "Analysis_foodcatlvl3_ghgconsumed_weighted.xlsx" ///
         if foodcat_lvl1 =="`f'", sheet("`f'") firstrow(variables) keepcellfmt sheetmodify
}


*********************
*Collapse by Level 2*
*********************

cd "$Analysis/Ranking/2015-16/total_ghg"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

* Summary table with total GHGE, mean GHGE, mean GHG100, and SEQN count based on Level 2 Food category (showing level 1 food categories)
* Adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed (mean) mean_ghgcons = ghg_consumed (mean) mean_ghg100 = ghg100 (count) freq = seqn [pw=wtdrd1], by(foodcat_lvl2 foodcat_lvl1)

order foodcat_lvl1
gsort -total_ghgcons

* Export to excel: Each level 1 food category has its own tab.
export excel "Analysis_foodcatlvl2_ghgconsumed_weighted.xlsx", firstrow(variables) keepcellfmt replace
levelsof foodcat_lvl1, local(foodcat_lvl1)
foreach f of local foodcat_lvl1 {
        export excel using "Analysis_foodcatlvl2_ghgconsumed_weighted.xlsx" ///
         if foodcat_lvl1 =="`f'", sheet("`f'") firstrow(variables) keepcellfmt sheetmodify
}

*********************
*Collapse by Level 1*
*********************

cd "$Analysis/Ranking/2015-16/total_ghg"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

* Summary table with total GHGE, mean GHGE, mean GHG100, and SEQN count based on Level 1 Food category
* Adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed (mean) mean_ghgcons = ghg_consumed (mean) mean_ghg100 = ghg100 (count) freq = seqn [pw=wtdrd1], by(foodcat_lvl1)

order foodcat_lvl1
gsort -total_ghgcons

drop if foodcat_lvl1=="Infant Formula & Baby Food"
drop if total_ghgcons==0

format total_ghgcons %12.0f

* Export to excel
export excel "Analysis_foodcatlvl1_ghgconsumed_weighted.xlsx", firstrow(variables) keepcellfmt replace

*******************************************
*Calculations for Food Cat 1 ranking table*
*******************************************
* Calculate proportion

egen double sum_ghgcons = sum(total_ghgcons)
format sum_ghgcons %14.2f

* Divide  category GHGE by total dietary GHGE
gen perc_ghgcons = (total_ghgcons/sum_ghgcons)
gsort -perc_ghgcons

* Export to excel
export excel "Analysis_foodcatlvl1_ghgconsumed_weighted_prop.xlsx", firstrow(variables) keepcellfmt replace

* Cummulative proportion was calculated in excel.
* Sum of percentage GHGE with next category GHGE

