
*Create Master List of Dairy Milk

cd "$Analysis"

import excel "MasterLists/Table_Milk substitutions.xlsx", sheet("Stata") firstrow  clear
drop food_description sb_code sb_description
*save "MasterLists/Table_Dairy milk.dta", replace

******

use "$Data/NHANES/Appended/NHANES_WWEIA_DataFRIENDS_WWEIAup_2005-10_2yrolder_ghgconsumed", clear

merge m:1 food_code using "MasterLists/Table_Dairy milk.dta", generate(_merge_dairy)

*Filter only dairy milk varieties
keep if _merge_dairy == 3

*Selected nutrients and renamed variables manually on Excel
keep seqn food_code drxfcsd grams-dr1isele ghg_consumed

rename dr1i* ori*
rename grams origrams
rename drxfcsd food_description
rename ghg_consumed orighgcons

gen refkcal = orikcal

order seqn food_code food_description refkcal

*Calculate nutrients and ghg per kcal (gen worked better than replace - lots of data were not calculated)

foreach var of varlist origrams-orighgcons {
    gen n_`var' = `var'/orikcal
}


collapse (mean) n_* (count) freq = seqn, by(food_code food_description)

export excel "MasterLists/Master list per kcal_dairy milk.xlsx", firstrow(variables) keepcellfmt replace


*********
*Merge dairy milk with soy milk to compare nutrients and ghg per kcal

import excel "MasterLists/Master list per kcal_dairy milk.xlsx", sheet("Sheet1") firstrow  clear

merge 1:1 food_code using "MasterLists/Table_Milk substitutions.dta", generate(_merge_subcode)

merge m:1 sb_code using "MasterLists/Master list per kcal_soy milk for merge.dta", generate(_merge_subdata)


export excel "MasterLists/Master list per kcal_dairy-soy milk.xlsx", firstrow(variables) keepcellfmt replace


