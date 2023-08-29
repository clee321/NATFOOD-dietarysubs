***********
*STEP 4. Create Substitution Scenario - Merge subset from step 3 with large dataset with erased info from step 1
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

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear
*count 121,481

*Create unique variable (unique id) 
tostring seqn dr1iline, replace
gen uniqid = seqn + dr1iline
destring seqn dr1iline, replace

*Remove prefix dr1i from variables
rename dr1i* ori*
rename grams origrams
rename ghg_consumed orighgcons

save "$Analysis/Substitution/2015-16/5_OrixSub_dataset/Original_large_dataset.dta", replace

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
