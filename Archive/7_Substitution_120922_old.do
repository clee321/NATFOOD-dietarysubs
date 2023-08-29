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

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_Protein_substitutions_wide.dta", generate(_merge_sublist)

*merged 1,530

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

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop.dta", clear
*count 121,481

merge m:1 food_code using "$Analysis/MasterLists/2015-16/List_MxDishes_substitutions_wide.dta", generate(_merge_sublist)
*merged 1,943

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
*STEP 2. Create a subset by selecting only the rows with original items to be substituted
*STEP 3. Merge subset from step 2 with nutrition and ghg data per kcal
**Protein & Mixed Dishes
*********

******** A. Low
****Separate loops btw low and high ghg sub items because columns have different names

cd "$Analysis/Substitution/2015-16/1_Empty"
local files: dir "$Analysis/Substitution/2015-16/1_Empty" files "*low_emp.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 8 characters suffix
	local file_str = substr("`file'",1,strlen("`file'") - 8)

	use `file',clear
	
	*Filter out only records with substitution - SUBSET
	keep if (subpop==1 & _merge_sublist == 3)
	keep seqn dr1ikcal sb_code_lo mgid
	
	*Merge with subs list of nutrition and ghg PER KCAL
	rename sb_code_lo sb_code
	merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", generate(_merge_subinfo)

	keep if _merge_subinfo==3
	
	*Multiply info per cal x original kcal (isocaloric substitution)

		foreach var of varlist subgrams-subghg_cons {
		replace `var' = `var'*dr1ikcal
			}

		drop subkcal dr1ikcal

		*Rename back to original column names to do the update replace
		rename sub* dr1i*
		rename dr1igrams grams
		rename dr1ighg_cons ghg_consumed 
		rename sb_description drxfcsd

		*Need to rename to food_code to merge with the list of foods that were not changed
		rename sb_code food_code
		
		save "$Analysis/Substitution/2015-16/2-3_Sub_only_nutri_ghg/`file_str'_nutri_ghg.dta", replace
		*count >1,000 rows
}

******** B. High
****Separate loops btw low and high ghg sub items because columns have different names

cd "$Analysis/Substitution/2015-16/1_Empty"
local files: dir "$Analysis/Substitution/2015-16/1_Empty" files "*high_emp.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 8 characters suffix
	local file_str = substr("`file'",1,strlen("`file'") - 8)

	use `file',clear
	
	*Filter out only records with substitution - SUBSET
	keep if (subpop==1 & _merge_sublist == 3)
	keep seqn dr1ikcal sb_code_hi mgid
	
	*Merge with subs list of nutrition and ghg PER KCAL
	rename sb_code_hi sb_code
	merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", generate(_merge_subinfo)

	keep if _merge_subinfo==3
	
	*Multiply info per cal x original kcal (isocaloric substitution)

		foreach var of varlist subgrams-subghg_cons {
		replace `var' = `var'*dr1ikcal
			}

		drop subkcal dr1ikcal

		*Rename back to original column names to do the update replace
		rename sub* dr1i*
		rename dr1igrams grams
		rename dr1ighg_cons ghg_consumed 
		rename sb_description drxfcsd

		*Need to rename to food_code to merge with the list of foods that were not changed
		//Don't recommend using "gen food_code=sb_code" - It created a float variable insted of double (which was the original type) and later rounded some of the food codes.
		rename sb_code food_code
		
		save "$Analysis/Substitution/2015-16/2-3_Sub_only_nutri_ghg/`file_str'_nutri_ghg.dta", replace
		*count >1,000 rows
}


***********
*STEP 4. Merge subset from step 3 with large dataset with erased info from step 1
***********

cd "$Analysis/Substitution/2015-16/1_Empty"
local files: dir "$Analysis/Substitution/2015-16/1_Empty" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 8 characters suffix
	local file_str = subinstr("`file'","_emp.dta","",.)
		
	display "`file_str'_nutri_ghg.dta"
	
	use `file',clear
	
	merge m:1 mgid using "$Analysis/Substitution/2015-16/2-3_Sub_only_nutri_ghg/`file_str'_nutri_ghg.dta", update replace generate(_merge_sublr)

	rename dr1i* sub*
	rename food_code sub_code
	rename drxfcsd sub_descr
	rename ghg_consumed subghgcons

	keep uniqid sub_code sub_descr subkcal grams-subsele subghgcons _merge_subinfo _merge_sublr

	order uniqid sub_code sub_descr 

	save "$Analysis/Substitution/2015-16/4_Sub_dataset/`file_str'_large.dta", replace
	*count 121,481 x 49
}

***********
*STEP 5: Merge Original dataset with Substitution dataset -  Wide
***********

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop.dta", clear
*count 121,481

*Create unique variable (unique id) 
tostring seqn dr1iline, replace
gen uniqid = seqn + dr1iline
destring seqn dr1iline, replace

*Remove prefix dr1i from variables
rename dr1i* ori*
rename grams origrams
rename ghg_consumed orighgcons

*save "$Analysis/Substitution/2015-16/5_OrixSub dataset/Original_large_dataset.dta", replace

*Merge with Substitution dataset on uniqid

cd "$Analysis/Substitution/2015-16/4_Sub_dataset"
local files: dir "$Analysis/Substitution/2015-16/4_Sub_dataset" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 8 characters suffix
	local file_str = subinstr("`file'","_large.dta","",.)

	use `file',clear
	
	merge 1:1 uniqid using "$Analysis/Substitution/2015-16/5_OrixSub_dataset/Original_large_dataset.dta", generate(_merge_orig)

	rename grams subgrams
	
	save "$Analysis/Substitution/2015-16/5_OrixSub_dataset/`file_str'_origxsub.dta", replace
	*count 121,481 x 205 columns
}
