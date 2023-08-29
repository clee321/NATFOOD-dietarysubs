
*Create Master List of Sub items

**List of only sub foods - unique codes

cd "$Analysis"

import excel "MasterLists/2015-16/AG lists/Merged_ghg100/Protein_Substitutes_v3_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 67
save "$Analysis/MasterLists/2015-16/List_Protein sub foods.dta", replace

import excel "MasterLists/2015-16/AG lists/Merged_ghg100/MxDishes_Substitutes_v3_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 87
save "$Analysis/MasterLists/2015-16/List_MxDishes sub foods.dta", replace

**Isocaloric subs
append using "$Analysis/MasterLists/2015-16/List_Protein sub foods.dta"
*count 154
*there are sb_code duplicates. Need to drop them.
duplicates drop sb_code, force
*count 152
save "$Analysis/MasterLists/2015-16/List_Protein MxDishes sub foods_isocal.dta", replace

********
import excel "MasterLists/2015-16/AG lists/Merged_ghg100/Milk_Substitutes_v1_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 10
save "$Analysis/MasterLists/2015-16/List_Milk sub foods.dta", replace

import excel "MasterLists/2015-16/AG lists/Merged_ghg100/Beverages_Substitutes_v3 fruit_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear
keep sb_code
duplicates drop sb_code, force
drop if sb_code==.
*count 12
save "$Analysis/MasterLists/2015-16/List_Beverages sub foods.dta", replace

**Isovolumetric subs
append using "$Analysis/MasterLists/2015-16/List_Milk sub foods.dta"
*count 22
*no sb_code duplicates
save "$Analysis/MasterLists/2015-16/List_Milk Bev sub foods_isovol.dta", replace

*********

*STEPS
*Merge isocal and isovol lists w NHANES
*Divide nutrition and ghg data by calories for isocal list
*Divide by volume for isovol list - need to find densities

**** Isocal list

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear
rename food_code sb_code

*Merge with isocal sub foods list
merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_Protein MxDishes sub foods_isocal.dta", generate(_mergecal)
keep if _mergecal == 3
*count 2274

*Selected nutrients
keep seqn sb_code drxfcsd grams-dr1isele ghg_consumed

rename dr1i* sub*
rename grams subgrams
rename drxfcsd sb_description
rename ghg_consumed subghg_cons

order seqn sb_code sb_description

export excel "MasterLists/2015-16/List_sub foods nutrients ghg_isocal_before collapse.xlsx", firstrow(variables) keepcellfmt replace

*Create Ref kcal table. Divide all nutrients and ghg by refkcal
gen refkcal = subkcal

foreach var of varlist subgrams-subghg_cons{
    replace `var' = `var'/refkcal
}

///need to get nutrition info from nhanes because we don't have another nutrition source
collapse (mean) sub* (count) freq = seqn, by(sb_code sb_description)
*count 152 (same as sub foods unique codes list)

export excel "MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.xlsx", firstrow(variables) keepcellfmt replace

save "MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", replace


*** Standard Deviation

import excel "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal_before collapse.xlsx", sheet("Sheet1")  firstrow clear

gen refkcal = subkcal

foreach var of varlist subgrams-subghg_cons {
    replace `var' = `var'/refkcal
}
collapse (sd) sub* (count) freq = seqn, by(sb_code sb_description)

export excel "MasterLists/2015-16/List_sub foods nutrients ghg_isocal_std dev.xlsx", firstrow(variables) keepcellfmt replace



***** Isovol list - need densities

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear
rename food_code sb_code

*Merge with isocal sub foods list
merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_Milk Bev sub foods_isovol.dta", generate(_mergevol)
keep if _mergevol == 3
*count 7653

*Selected nutrients
keep seqn sb_code drxfcsd grams-dr1isele ghg_consumed

rename dr1i* sub*
rename grams subgrams
rename drxfcsd sb_description
rename ghg_consumed subghg_cons

order seqn sb_code sb_description

*Need to find density.
*Create Ref kcal table. Divide all nutrients and ghg by refkcal

gen refgrams = subgrams

foreach var of varlist subgrams-subghg_cons{
    replace `var' = (`var'/refgrams)*food_density
}

collapse (mean) sub* (count) freq = seqn, by(sb_code sb_description)

export excel "MasterLists/vol_Master list per mL_soy milk.xlsx", firstrow(variables) keepcellfmt replace


collapse (mean) sub* (count) freq = seqn, by(sb_code sb_description)
*count 152 (same as sub foods unique codes list)

export excel "MasterLists/2015-16/List_sub foods nutrients ghg_isocal.xlsx", firstrow(variables) keepcellfmt replace

save "MasterLists/2015-16/List_sub foods nutrients ghg_isocal.dta", replace







