
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
	count
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
	count
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
		//Don't recommend using "gen food_code=sb_code" - It created a float variable instead of double (which was the original type) and later rounded some of the food codes.
		rename sb_code food_code
		
		save "$Analysis/Substitution/2015-16/2-3_Sub_only_nutri_ghg/`file_str'_nutri_ghg.dta", replace
		*count >1,000 rows
}

******** C. 1 substitution scenario - Beverages

cd "$Analysis/Substitution/2015-16/1_Empty"
local files: dir "$Analysis/Substitution/2015-16/1_Empty" files "*dataset_emp.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 4 characters suffix
	local file_str = substr("`file'",1,strlen("`file'") - 8)

	use `file',clear
	
	*Filter out only records with substitution - SUBSET
	keep if (subpop==1 & _merge_sublist == 3)
	count
	keep seqn dr1ikcal sb_code mgid
	
	*Merge with subs list of nutrition and ghg PER KCAL
	merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", generate(_merge_subinfo)

	keep if _merge_subinfo==3
	
	*Multiply info per cal x original kcal (isocaloric substitution)

		foreach var of varlist subgrams-subghg_cons {
		replace `var' = `var'*dr1ikcal
			}
///
create a new variable and check (gen)
assert var1==var2 (proceed if true)

		drop subkcal dr1ikcal

		*Rename back to original column names to do the update replace
		rename sub* dr1i*
		rename dr1igrams grams
		rename dr1ighg_cons ghg_consumed 
		rename sb_description drxfcsd

		*Need to rename to food_code to merge with the list of foods that were not changed
		//Don't recommend using "gen food_code=sb_code" - It created a float variable instead of double (which was the original type) and later rounded some of the food codes.
		rename sb_code food_code
		
*		save "$Analysis/Substitution/2015-16/2-3_Sub_only_nutri_ghg/`file_str'_nutri_ghg.dta", replace
		*count >1,000 rows
}

////01/25/23
*Verify whether replace is multiplying all values correctly
*Not loop

	use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/1_Empty/Beverages_Sub_dataset_emp.dta", clear
	
	*Filter out only records with substitution - SUBSET
	keep if (subpop==1 & _merge_sublist == 3)
	count
	keep seqn dr1ikcal sb_code mgid
	
	*Merge with subs list of nutrition and ghg PER KCAL
	merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", generate(_merge_subinfo)

	keep if _merge_subinfo==3
	
	*Multiply info per cal x original kcal (isocaloric substitution)

	gen double newgrams = subgrams*dr1ikcal
	gen double newatoc = subatoc*dr1ikcal
	
	replace subgrams = subgrams*dr1ikcal
	*(1,934 real changes made)
	replace subatoc = subatoc*dr1ikcal
	*(1,890 real changes made)
	
	assert newgrams == subgrams
	assert newatoc == subatoc
	
	gen grams_check = 0
	replace grams_check = 1 if newgrams == subgrams
	
	gen atoc_check = 0
	replace atoc_check = 1 if newatoc == subatoc
	
//////


	use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/1_Empty/Milk_Sub_dataset_low_emp.dta", clear
	
	*Filter out only records with substitution - SUBSET
	keep if (subpop==1 & _merge_sublist == 3)
	count
	keep seqn dr1ikcal sb_code_lo mgid
	
	*Merge with subs list of nutrition and ghg PER KCAL
	rename sb_code_lo sb_code
	merge m:1 sb_code using "$Analysis/MasterLists/2015-16/List_sub foods nutrients ghg_isocal per kcal.dta", generate(_merge_subinfo)

	keep if _merge_subinfo==3
	
	*Multiply info per cal x original kcal (isocaloric substitution)

	gen double newgrams = subgrams*dr1ikcal
	gen double newatoc = subatoc*dr1ikcal
	
	replace subgrams = subgrams*dr1ikcal
	*(1,934 real changes made)
	replace subatoc = subatoc*dr1ikcal
	*(1,890 real changes made)
	
	assert newgrams == subgrams
	assert newatoc == subatoc
	
	gen grams_check = 0
	replace grams_check = 1 if newgrams == subgrams
	
	gen atoc_check = 0
	replace atoc_check = 1 if newatoc == subatoc

	
///check whether the sb_code changes from long to double
*variable type changes automatically when there is a merge

*Sb_code as long
mean sb_code
display %12.0g _b[sb_code]
*68747239.79

recast double sb_code
mean sb_code
display %12.0g _b[sb_code]
*68747239.79
