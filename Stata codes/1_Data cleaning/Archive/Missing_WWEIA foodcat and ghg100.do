**Identify missing Food Categories (Level 2) and GHG100**

cd "$Data/NHANES/Appended"

use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2005-10", clear

**Missing WWEIA foodcat_lvl2 (Same result as foodcat_lvl1)
keep if missing(foodcat_lvl2)

collapse (first) foodcode_str=drxfcsd (count) freq=seqn, by(food_code)

export excel "$Analysis/Foodcatlvl_missing_v2.xls", firstrow(variables) replace

---

**Missing GHG100

*In the entire dataset
use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2005-10", clear

keep if missing(ghg100)

collapse (first) foodcode_str=drxfcsd (count) freq=seqn, by(food_code)

export excel "$Analysis/ghg100_missing_alldata.xls", firstrow(variables) replace

hand code missing categories

*In the dataset >=2 years
use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2005-10_2yrolder", clear

keep if missing(ghg100)

collapse (first) foodcode_str=drxfcsd (count) freq=seqn, by(food_code)

export excel "$Analysis/ghg100_missing_2yrolder.xls", firstrow(variables) replace

*Remove baby foods, sugar, fat and oil


