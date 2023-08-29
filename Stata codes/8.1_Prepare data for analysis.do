*Step 1: Create list of seqn with substitutions
*Create flag identifying seqn that had substitutions (for subset analysis)

*Step 2: Merge Original & Sub Large dataset with Seqn flag from step 1
*Step 2.1: Create totals for each nutrition and ghg info by Seqn
*Drop duplicates on Seqn

*********
*STEP 1: Create list of seqn with substitutions
*Create flag identifying seqn that had substitutions (for subset)
*********


cd "$Analysis/MasterLists/2015-16"
local files: dir "$Analysis/MasterLists/2015-16" files "*_wide.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - remove 8 characters suffix
	local file_str = substr("`file'",1,strlen("`file'") - 9)

	use `file',clear
	
	merge 1:m food_code using "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", generate(_merge_seqn)
	
	*Filter out only records with substitution - SUBSET
	*Unique seqn
	keep if (subpop==1 & _merge_seqn == 3)
	keep seqn
	sum
	duplicates drop seqn, force
	count
	
	gen sub_flag = 1
	
	save "$Analysis/Substitution/2015-16/Seqn lists/`file_str'_uniqueseqn.dta", replace
}

* count Seqn before dropping duplicates - compared to the other lists (Substitutions/Step 2-3, seqn list)
* Protein  1,456 -> 1,281
* MxDishes 1,875 -> 1,653
* Beverages 1,993 -> 1,614
* Milk  5,445 -> 3,534
*All  10,769 ->  5,676


********
*STEP 2.0: Merge Original & Sub Large dataset with Seqn flag from step 1
********

cd "$Analysis/Substitution/2015-16/5_OrixSub_dataset"
local files: dir "$Analysis/Substitution/2015-16/5_OrixSub_dataset" files "*_origxsub.dta"
*count 121,481 x 205 columns

foreach file in `files'{
	dir `file'

	use `file', clear

*Substring used later to save the file name - remove 8 characters suffix
	local file_str = regexr("`file'","_Sub(.*).dta","")
	local filename = subinstr("`file'","_origxsub.dta","",.)

*Merge seqn flag
	merge m:1 seqn using "$Analysis/Substitution/2015-16/Seqn lists/List_`file_str'_substitutions_uniqueseqn.dta", update replace generate(_merge_subflag)
	
	order subgrams, before(subkcal)
	
	save "$Analysis/Substitution/2015-16/6_OrixSub_totals/Intermediary/`filename'_orig-sub-seqnflag.dta", replace
	
}

********
*STEP 2.1: Create totals for each nutrition and ghg info by Seqn
*Drop duplicates on Seqn
********

cd "$Analysis/Substitution/2015-16/6_OrixSub_totals/Intermediary"
local files: dir "$Analysis/Substitution/2015-16/6_OrixSub_totals/Intermediary" files "*.dta"
*count 121,481 x 207 columns

foreach file in `files'{
	dir `file'

	use `file', clear
	
	local filename = subinstr("`file'","_orig-sub-seqnflag.dta","",.)
	
	foreach var of varlist origrams-orisele orighgcons subgrams-subsele subghgcons {
		bysort seqn: egen ttl_`var' = total(`var')
	}
		sort seqn oriline
	
		*keep only one total row per seqn
		duplicates drop seqn, force
	
		save "$Analysis/Substitution/2015-16/6_OrixSub_totals/`filename'_total_by_seqn.dta", replace
		*count 8,505 x 295 columns
}
