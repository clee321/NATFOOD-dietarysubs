cd "$Analysis"

*Prepare the reference docs for merge

*********
**Protein
**Need to create two separate lists for the two lower ang higher ghg scenarios
import excel "MasterLists/2015-16/Sub lists/Merged_ghg100/Protein_Substitutes_v3_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep food_code sb_num sb_code sb_description
duplicates drop food_code sb_code, force
drop if food_code==.

**Reshaped to wide
reshape wide sb_code sb_description, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
save "$Analysis/MasterLists/2015-16/List_Protein_substitutions_wide.dta", replace

**Unique original food_codes to check if seqns consumed them more than once per day
duplicates drop food_code, force
keep food_code
save "$Analysis/MasterLists/2015-16/List_Protein original foods.dta", replace


*******
**Mixed dishes
import excel "$Analysis/MasterLists/2015-16/Sub lists/Merged_ghg100/MxDishes_Substitutes_v3_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep food_code sb_num sb_code sb_description
duplicates drop food_code sb_code, force
drop if food_code==.

**Reshaped
reshape wide sb_code sb_description, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
save "$Analysis/MasterLists/2015-16/List_MxDishes_substitutions_wide.dta", replace

**Unique original food_codes to check if seqns consumed them more than once per day
duplicates drop food_code, force
keep food_code
save "$Analysis/MasterLists/2015-16/List_MxDishes original foods.dta", replace

*******
**Milk
import excel "$Analysis/MasterLists/2015-16/Sub lists/Merged_ghg100/Milk_Substitutes_v1_ghg100.xlsx", sheet("Sheet1") firstrow  clear
*Remove dairy items w/o subs (e.g., cheese)
drop if sb_code== .
keep food_code sb_num sb_code sb_description
duplicates drop food_code sb_code, force
*none
drop if food_code==.

**Reshaped
reshape wide sb_code sb_description, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
save "$Analysis/MasterLists/2015-16/List_Milk_substitutions_wide.dta", replace

**Unique original food_codes to check if seqns consumed them more than once per day
duplicates drop food_code, force
keep food_code
save "$Analysis/MasterLists/2015-16/List_Milk original foods.dta", replace

*******
**Non-alcoholic beverages
import excel "$Analysis/MasterLists/2015-16/Sub lists/Merged_ghg100/Beverages_Substitutes_v3_fruit_ghg100.xlsx", sheet("Sheet1") firstrow  clear
keep food_code sb_code sb_description fruit
duplicates drop food_code sb_code, force
drop if food_code==.

**Don't need reshape - doesn't have two sub scenario alternatives
save "$Analysis/MasterLists/2015-16/List_Beverages_substitutions_wide.dta", replace

**Create version to merge for All Subs (below)
drop fruit
rename sb_code sb_code_lo
rename sb_description sb_desc_lo
gen long sb_code_hi = sb_code_lo
gen sb_desc_hi = sb_desc_lo
save "$Analysis/MasterLists/2015-16/List_Beverages_substitutions_wide_tomerge.dta", replace

**Unique original food_codes to check if seqns consumed them more than once per day
duplicates drop food_code, force
keep food_code
save "$Analysis/MasterLists/2015-16/List_Beverages original foods.dta", replace


**All subs

use "$Analysis/MasterLists/2015-16/List_Protein_substitutions_wide.dta", clear
append using "$Analysis/MasterLists/2015-16/List_MxDishes_substitutions_wide.dta"
append using "$Analysis/MasterLists/2015-16/List_Milk_substitutions_wide.dta"
append using "$Analysis/MasterLists/2015-16/List_Beverages_substitutions_wide_tomerge.dta"


duplicates drop food_code, force
*none
save "$Analysis/MasterLists/2015-16/List_All_substitutions_wide.dta", replace


