
cd "$Analysis"

**********(1)
**********

*Create list of seqn with substitutions
**Check if same seqn consumed more than once of one food item, or consumed more than one food item.

**Protein

**dataset with subpop==1
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

**Original foods subset
merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Protein original foods.dta", generate(_merge_sublist)

*Filter out only records with substitution - SUBSET
keep if _merge_sublist == 3

keep seqn food_code drxfcsd grams dr1ikcal

sort seqn

duplicates tag seqn, gen(seqn_dupl)

gsort -dr1ikcal
gsort -seqn_dupl

export excel "Substitution/2015-16/Seqn lists/Seqns_Protein original foods.xlsx", firstrow(variables) keepcellfmt replace

tab seqn_dupl
*seqns that consumed only 1 original food per day was 77%

**MxDishes

**dataset with subpop==1
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

**Original foods subset
merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_MxDishes original foods.dta", generate(_merge_sublist)

*Filter out only records with substitution - SUBSET
keep if _merge_sublist == 3

keep seqn food_code drxfcsd grams dr1ikcal

sort seqn

duplicates tag seqn, gen(seqn_dupl)

gsort -dr1ikcal
gsort -seqn_dupl


export excel "Substitution/2015-16/Seqn lists/Seqns_MxDishes original foods.xlsx", firstrow(variables) keepcellfmt replace

tab seqn_dupl
*seqns that consumed only 1 original food per day was 77%


**Milk

**dataset with subpop==1
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

**Original foods subset
merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Milk original foods.dta", generate(_merge_sublist)

*Filter out only records with substitution - SUBSET
keep if _merge_sublist == 3

keep seqn food_code drxfcsd grams dr1ikcal

sort seqn

duplicates tag seqn, gen(seqn_dupl)

gsort -dr1ikcal
gsort -seqn_dupl


export excel "Substitution/2015-16/Seqn lists/Seqns_Milk original foods.xlsx", firstrow(variables) keepcellfmt replace

tab seqn_dupl
*seqns that consumed only 1 original food per day was 41%
*removed cheese from the original list


**Beverages

**dataset with subpop==1
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

**Original foods subset
merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Beverages original foods.dta", generate(_merge_sublist)

*Filter out only records with substitution - SUBSET
keep if _merge_sublist == 3

keep seqn food_code drxfcsd grams dr1ikcal

sort seqn

duplicates tag seqn, gen(seqn_dupl)

gsort -dr1ikcal
gsort -seqn_dupl


export excel "Substitution/2015-16/Seqn lists/Seqns_Beverages original foods.xlsx", firstrow(variables) keepcellfmt replace

tab seqn_dupl
*seqns that consumed only 1 original food per day was 65%

