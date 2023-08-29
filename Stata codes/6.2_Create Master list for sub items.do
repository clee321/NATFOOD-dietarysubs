
*Create Master List of Sub items

**List of only sub foods - unique codes

cd "$Analysis"

import excel "MasterLists/2015-16/Sub lists/Merged_ghg100/Protein_Substitutes_v3_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 67
save "$Analysis/MasterLists/2015-16/List_Protein sub foods.dta", replace

import excel "MasterLists/2015-16/Sub lists/Merged_ghg100/MxDishes_Substitutes_v3_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 87
save "$Analysis/MasterLists/2015-16/List_MxDishes sub foods.dta", replace


import excel "MasterLists/2015-16/Sub lists/Merged_ghg100/Milk_Substitutes_v1_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 10
save "$Analysis/MasterLists/2015-16/List_Milk sub foods.dta", replace

import excel "MasterLists/2015-16/Sub lists/Merged_ghg100/Beverages_Substitutes_v3_fruit_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 21
save "$Analysis/MasterLists/2015-16/List_Beverages sub foods.dta", replace


**All subs

use "$Analysis/MasterLists/2015-16/List_Protein sub foods.dta", clear
append using "$Analysis/MasterLists/2015-16/List_MxDishes sub foods.dta"
append using "$Analysis/MasterLists/2015-16/List_Milk sub foods.dta"
append using "$Analysis/MasterLists/2015-16/List_Beverages sub foods.dta"
*count 185
*there are sb_code duplicates. Need to drop them.
duplicates drop sb_code, force
*count 183
save "$Analysis/MasterLists/2015-16/List_All sub foods.dta", replace

*********

*STEPS
*Merge isocal sub lists w NHANES
*Divide nutrition and ghg data by calories for isocal list

**** Isocal list

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear
rename food_code sb_code

*Merge with isocal sub foods list
merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_All sub foods.dta", generate(_mergecal)
keep if _mergecal == 3
*count 12433

*Selected nutrients and ghg
keep seqn sb_code drxfcsd grams-dr1isele ghg_consumed

rename dr1i* sub*
rename grams subgrams
rename drxfcsd sb_description
rename ghg_consumed subghg_cons

order seqn sb_code sb_description

*export excel "$Analsis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal_before collapse.xlsx", firstrow(variables) keepcellfmt replace

//Some observations were 0 kcal
//Error dividing with 0 to calcute nutrients per kcal (missing values)
//But also for water, regardless of how much one drinks, it will be 0 kcal and multiplying with 0 kcal won't multiply the other nutrients.

tab sb_description if subkcal==0

//Drop the 2 items (grapes, tea) that is not water - to ensure it does not impact the average 
drop if subkcal==0 & sb_code!=94000100 

*Create Ref kcal table. Divide all nutrients and ghg by refkcal
gen double refkcal = subkcal

*Divide with kcal to generate data per kcal
foreach var of varlist subgrams-subghg_cons{
    replace `var' = `var'/refkcal
}

///need to get nutrition info from NHANES because we don't have another nutrition source
collapse (mean) sub* (count) freq = seqn, by(sb_code sb_description)
//Average data is the same with or without 0 kcal observations (different *frequency* though).

*Replace missing values with 0 for all variables (water)
foreach x of varlist subgrams-subghg_cons{
    replace `x' = 0 if `x'==.
}

export excel "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.xlsx", firstrow(variables) keepcellfmt replace

save "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", replace





