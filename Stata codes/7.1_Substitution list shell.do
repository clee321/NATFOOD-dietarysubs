******
*Steps:
*1. Seqns that consumed original items will have their nutrition and ghg data erased
**We are creating hypothetical scenarios by substituting original items with new items

*2. Create a subset by selecting the rows with original items

*3. Merge subset from step 2 with nutrition and ghg data per kcal
**Multiply with kcal consumed for an isocaloric substitution

*4. Merge subset from step 3 back with large dataset with erased info from step 1
**By merging we are updating the nutritional and ghg data in the large dataset - creating a hypothetical consumption dataset
**Merge using mgid = sb_code+seqn+dr1iline

*5. Merge original large dataset with subs large dataset (from 4)
**Using a wide format to calculate the diffence for each row
**Merge using uniqid = seqn+dr1iline


cd "$Analysis"
********
*STEP 1. Create dataset with empty cells
**Protein
********

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Protein_substitutions_wide.dta", generate(_merge_sublist)

*merged 1,530

distinct food_code if _merge_sublist == 3

order seqn dr1ikcal 

foreach var of varlist grams-dr1ip226 {
    replace `var' = . if (_merge_sublist == 3 & subpop==1)
}
*1,456 changes
replace ghg_consumed =. if (_merge_sublist == 3 & subpop==1)
replace drxfcsd ="" if (_merge_sublist == 3 & subpop==1)

**Check if items with null grams were matched or not
tab _merge_sublist if grams==.
**Show the food description of foods with null grams and not matched - human milk
tab drxfcsd if (grams==. & _merge_sublist==1)

**Create unique variable (merge id) to merge with substitution subset - check for duplicates
tostring seqn dr1iline, replace

gen uniqid = seqn + dr1iline

frame copy default subdivide
frame change subdivide
drop sb_code_hi sb_desc_hi

tostring sb_code_lo, replace
gen mgid = "n"
replace mgid = sb_code_lo + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_lo seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/Protein_Sub_dataset_low_emp.dta", replace

frame change default
drop sb_code_lo sb_desc_lo

tostring sb_code_hi, replace
gen mgid = "n"
replace mgid = sb_code_hi + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_hi seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/Protein_Sub_dataset_high_emp.dta", replace

frame drop subdivide


*********
*STEP 1. Create dataset with empty cells
**Mixed Dishes
*********

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_MxDishes_substitutions_wide.dta", generate(_merge_sublist)
*merged 1,943

distinct food_code if _merge_sublist == 3

order seqn dr1ikcal 

foreach var of varlist grams-dr1ip226 {
    replace `var' = . if (_merge_sublist == 3 & subpop==1)
}
*1,875 changes
replace ghg_consumed =. if (_merge_sublist == 3 & subpop==1)
replace drxfcsd ="" if (_merge_sublist == 3 & subpop==1)

**Check if items with null grams were matched or not
tab _merge_sublist if grams==.
**Show the food description of foods with null grams and not matched - human milk
tab drxfcsd if (grams==. & _merge_sublist==1)

**Create unique variable (merge id) to merge with substitution subset - check for duplicates
tostring seqn dr1iline, replace

gen uniqid = seqn + dr1iline

frame copy default subdivide
frame change subdivide
drop sb_code_hi sb_desc_hi

tostring sb_code_lo, replace
gen mgid = "n"
replace mgid = sb_code_lo + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_lo seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/MxDishes_Sub_dataset_low_emp.dta", replace

frame change default
drop sb_code_lo sb_desc_lo

tostring sb_code_hi, replace
gen mgid = "n"
replace mgid = sb_code_hi + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_hi seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/MxDishes_Sub_dataset_high_emp.dta", replace
*count 121,481 rows

frame drop subdivide


*********
*STEP 1. Create dataset with empty cells
**Milk
*********

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Milk_substitutions_wide.dta", generate(_merge_sublist)
*merged 6,149

distinct food_code if _merge_sublist == 3

order seqn dr1ikcal 

foreach var of varlist grams-dr1ip226 {
    replace `var' = . if (_merge_sublist == 3 & subpop==1)
}
*5,445 changes
replace ghg_consumed =. if (_merge_sublist == 3 & subpop==1)
replace drxfcsd ="" if (_merge_sublist == 3 & subpop==1)

**Check if items with null grams were matched or not
tab _merge_sublist if grams==.
**Show the food description of foods with null grams and not matched - human milk
tab drxfcsd if (grams==. & _merge_sublist==1)

**Create unique variable (merge id) to merge with substitution subset - check for duplicates
tostring seqn dr1iline, replace

gen uniqid = seqn + dr1iline

frame copy default subdivide
frame change subdivide
drop sb_code_hi sb_desc_hi

tostring sb_code_lo, replace
gen mgid = "n"
replace mgid = sb_code_lo + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_lo seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/Milk_Sub_dataset_low_emp.dta", replace

frame change default
drop sb_code_lo sb_desc_lo

tostring sb_code_hi, replace
gen mgid = "n"
replace mgid = sb_code_hi + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_hi seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/Milk_Sub_dataset_high_emp.dta", replace
*count 121,481 rows

frame drop subdivide


*********
*STEP 1. Create dataset with empty cells
**Beverages
*********

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Beverages_substitutions_wide.dta", generate(_merge_sublist)
*merged 2,214

distinct food_code if _merge_sublist == 3

order seqn dr1ikcal 

foreach var of varlist grams-dr1ip226 {
    replace `var' = . if (_merge_sublist == 3 & subpop==1)
}
*1,993 changes
replace ghg_consumed =. if (_merge_sublist == 3 & subpop==1)
replace drxfcsd ="" if (_merge_sublist == 3 & subpop==1)

**Check if items with null grams were matched or not
tab _merge_sublist if grams==.
**Show the food description of foods with null grams and not matched - human milk
tab drxfcsd if (grams==. & _merge_sublist==1)

**Create unique variable (merge id) to merge with substitution subset - check for duplicates
tostring seqn dr1iline, replace

gen uniqid = seqn + dr1iline

drop fruit

tostring sb_code, replace
gen mgid = "n"
replace mgid = sb_code + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code seqn dr1iline, replace

///There is only 1 substitution scenario
save "$Analysis/Substitution/2015-16/1_Empty/Beverages_Sub_dataset_emp.dta", replace
*count 121,481 rows


*********
*STEP 1. Create dataset with empty cells
**ALL 4 Categories
*********

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_All_substitutions_wide.dta", generate(_merge_sublist)
*merged 11,836

distinct food_code if _merge_sublist == 3

order seqn dr1ikcal 

foreach var of varlist grams-dr1ip226 {
    replace `var' = . if (_merge_sublist == 3 & subpop==1)
}
*10,769 changes
replace ghg_consumed =. if (_merge_sublist == 3 & subpop==1)
replace drxfcsd ="" if (_merge_sublist == 3 & subpop==1)

**Check if items with null grams were matched or not
tab _merge_sublist if grams==.
**Show the food description of foods with null grams and not matched - human milk
tab drxfcsd if (grams==. & _merge_sublist==1)

**Create unique variable (merge id) to merge with substitution subset - check for duplicates
tostring seqn dr1iline, replace

gen uniqid = seqn + dr1iline

frame copy default subdivide
frame change subdivide
drop sb_code_hi sb_desc_hi

tostring sb_code_lo, replace
gen mgid = "n"
replace mgid = sb_code_lo + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_lo seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/All_Sub_dataset_low_emp.dta", replace

frame change default
drop sb_code_lo sb_desc_lo

tostring sb_code_hi, replace
gen mgid = "n"
replace mgid = sb_code_hi + seqn + dr1iline if (_merge_sublist == 3 & subpop==1)

destring sb_code_hi seqn dr1iline, replace

save "$Analysis/Substitution/2015-16/1_Empty/All_Sub_dataset_high_emp.dta", replace
*count 121,481 rows

frame drop subdivide


