*Ranking of Food codes showing Level 1 Food Categories
*Categories used: Age groups, Gender, Race/Ethnicity

* Summary table with Total GHGE of Food codes (showing food description, categ. description and level 1 food categories) adjusted for dietary weight

***************************
* GHG total by Age Groups *
***************************

cd "$Analysis/Ranking/2015-16/ghg_intensity/by demo"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

**Recode Age groups**
**Create tb_ageCat: tb_ageCat to be used for the manuscript ranking tables per age group
**Checked counts for both ageCat and tb_ageCat ("tab ...")- they were the same 
recode ageCat (2 = 1) (3 = 1) (7 = 6), generate(tb_ageCat)
label define tb_age_Labels 0 "0-1" 1 "2-17" 4 "18-25" 5 "26-39" 6 "40-59" 8 "60 and over"
label values tb_ageCat tb_age_Labels

*Summarize data by food codes and total GHGE, adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed [pw=wtdrd1], by(food_code drxfcsd  category_description foodcat_lvl1 tb_ageCat)

*Change order of columns
order tb_ageCat foodcat_lvl1 category_description

*Sort columns - descending direction for Total GHGE, ascending direction for ageCat
gsort tb_ageCat -total_ghgcons

*Keep only the 5 categories we are interested in
*There was too much data to create the multiple excel sheets
keep if inlist(foodcat_lvl1, "Protein Foods","Mixed Dishes","Milk and Dairy", "Beverages, Nonalcoholic", "Snacks and Sweets")

*Convert ageCat (numeric) to string
tostring tb_ageCat, gen(tb_ageCatstr)

**Export to multiple excel sheets based on two variables: Age categories and Level 1 food categories 
**5 ageCat * 5 foodcat = 25 excel sheets
export excel "Analysis_fdcodes-fdlvl3_ghgcons_by age.xlsx", firstrow(variables) keepcellfmt replace
levelsof tb_ageCatstr, local(tb_ageCatstr)
levelsof foodcat_lvl1, local(foodcat_lvl1)

foreach f of local foodcat_lvl1 {
	foreach g of local tb_ageCatstr {
		export excel using "Analysis_fdcodes-fdlvl3_ghgcons_by age.xlsx" ///
		if tb_ageCatstr =="`g'" & foodcat_lvl1 =="`f'", sheet("`g'`f'") firstrow(variables) keepcellfmt sheetmodify
	}

}


***********************
* GHG total by Gender *
***********************

cd "$Analysis/Ranking/2015-16/ghg_intensity/by demo"

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

*Summarize data by food codes and total GHGE, adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed [pw=wtdrd1], by(food_code drxfcsd  category_description foodcat_lvl1 genderCat)

*Change order of columns
order genderCat foodcat_lvl1 category_description

*Sort columns - descending direction for Total GHGE, ascending direction for genderCat
gsort genderCat -total_ghgcons

*Keep only the 5 categories we are interested in
*There was too much data to create the multiple excel sheets
keep if inlist(foodcat_lvl1, "Protein Foods","Mixed Dishes","Milk and Dairy", "Beverages, Nonalcoholic", "Snacks and Sweets")

*Convert ageCat (numeric) to string
tostring genderCat, gen(genderCatstr)

**Export to multiple excel sheets based on two variables: Gender categories and Level 1 food categories 
**2 genderCat * 5 foodcat = 10 excel sheets
export excel "Analysis_fdcodes-fdlvl3_ghgcons_by gender.xlsx", firstrow(variables) keepcellfmt replace
levelsof genderCatstr, local(genderCatstr)
levelsof foodcat_lvl1, local(foodcat_lvl1)

foreach f of local foodcat_lvl1 {
	foreach g of local genderCatstr {
		export excel using "Analysis_fdcodes-fdlvl3_ghgcons_by gender.xlsx" ///
		if genderCatstr =="`g'" & foodcat_lvl1 =="`f'", sheet("`g'`f'") firstrow(variables) keepcellfmt sheetmodify
	}

}

***************************************
* GHG total by Race/Ethnicity/by demo *
***************************************

cd "$Analysis/Ranking/2015-16/ghg_intensity/by demo"
use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

*Summarize data by food codes and total GHGE, adjusted for dietary weight
collapse (sum) total_ghgcons = ghg_consumed [pw=wtdrd1], by(food_code drxfcsd  category_description foodcat_lvl1 raceCat)

*Change order of columns
order raceCat foodcat_lvl1 category_description

*Sort columns - descending direction for Total GHGE, ascending direction for raceCat
gsort raceCat -total_ghgcons

*Keep only the 5 categories we are interested in
*There was too much data to create the multiple excel sheets
keep if inlist(foodcat_lvl1, "Protein Foods","Mixed Dishes","Milk and Dairy", "Beverages, Nonalcoholic", "Snacks and Sweets")

*Convert raceCat (numeric) to string
tostring raceCat, gen(raceCatstr)

**Export to multiple excel sheets based on two variables: Race categories and Level 1 food categories 
**2 genderCat * 5 foodcat = 10 excel sheets
export excel "Analysis_fdcodes-fdlvl3_ghgcons_by race.xlsx", firstrow(variables) keepcellfmt replace
levelsof raceCatstr, local(raceCatstr)
levelsof foodcat_lvl1, local(foodcat_lvl1)

foreach f of local foodcat_lvl1 {
	foreach g of local raceCatstr {
		export excel using "Analysis_fdcodes-fdlvl3_ghgcons_by race.xlsx" ///
		if raceCatstr =="`g'" & foodcat_lvl1 =="`f'", sheet("`g'`f'") firstrow(variables) keepcellfmt sheetmodify
	}
}
