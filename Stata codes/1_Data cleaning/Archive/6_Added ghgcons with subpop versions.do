
*** Dataset with filtered subpop == 1

use "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_subpop", clear

*Filter subpop == 1
keep if subpop == 1

save "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder.dta", replace


*** Calculate total GHG in dataset with subpop == 1

use "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder", clear

*** PREPARE THE DATASET (GHGE proportional to food consumption and dietary weight)
*Calculate GHG emissions proportional to the amount of foods consumed
rename dr1igrms grams

*Formula: GHG/100grams is divided by 100 (to yield GHG/grams) and multiplied with grams consumed
gen ghg_consumed = ghg100*grams/100

save "$Data/NHANES/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed.dta", replace


****** Create dataset without filtering subpop ******
****** To be used in the Substitution and Analysis Steps *******

use "$Data/NHANES/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_subpop_v2", clear

*** PREPARE THE DATASET (GHGE proportional to food consumption and dietary weight)
*Calculate GHG emissions proportional to the amount of foods consumed
rename dr1igrms grams

*Formula: GHG/100grams is divided by 100 (to yield GHG/grams) and multiplied with grams consumed
gen ghg_consumed = ghg100*grams/100

save "$Data/NHANES/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", replace
