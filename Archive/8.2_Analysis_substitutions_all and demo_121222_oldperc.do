

*Step 1: Create list of seqn with substitutions
*Create flag identifying seqn that had substitutions (for subset analysis)

*Step 2: Merge Original & Sub Large dataset with Seqn flag from step 1
*Step 2.1: Create totals for each nutrition and ghg info by Seqn
*Drop duplicates on Seqn

"$Code/2015-16/8.1_Prepare data for analysis_121222.do"


*Analysis Overall: 
	*Step 1: Totals per seqn for original and substituted datasets
		*Export to excel on different sheets
	*Step 2: Difference between substituted and originals

*Analysis for only Seqns with substitutions:

*Analysis per Demo group:

*HEI difference




*********
**#Analysis Overall
*********
**Mean changes in GHG emissions and nutrition outcomes per person per day after substitutions among those with substitutions and for the entire sample.

********
**#STEP 1: Totals per seqn for original and substituted datasets
*Export to excel in separate sheets
********
** seqn total count = 8505
** seqn subpop==1 count= 7753


cd "$Analysis/Substitution/2015-16/6_OrixSub_totals"
local files: dir "$Analysis/Substitution/2015-16/6_OrixSub_totals" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","_dataset","")
	local filename = regexr("`file_int'","_total(.*).dta","")
	
	use `file', clear

	**Declare data as Survey set - Using one day dietary weight 
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	*Calculate mean + SE per sub_flag (entire sample) - table 3 and 4
	**#Original

	svy, subpop (if subpop==1): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel A1 = ("`filename'_original")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames

	**#Substituted
	svy, subpop (if subpop==1): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel I1 = ("`filename'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames

}


********
**#STEP 2: Calculate difference between substituted and original totals for the same seqn
********

cd "$Analysis/Substitution/2015-16/6_OrixSub_totals"
local files: dir "$Analysis/Substitution/2015-16/6_OrixSub_totals" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","_dataset","")
	local filename = regexr("`file_int'","_total(.*).dta","")
	
	use `file', clear
	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	foreach v of var ttl_ori* { 
 	*String without "ttl_ori"
     local p = substr("`v'", 8, .) 
     gen diff_`p' = ttl_sub`p' - ttl_ori`p'
	}
	*count 8,505 x 339 columns

*Regression - Paired t-test
	*foreach var of var diff* {
	*	svy: reg `var'
	*}

*Same results as regression
	**#Difference
	svy, subpop (if subpop==1): mean (diff_grams-diff_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel Q1 = ("`filename'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames

******
*Calculate percentage difference for each seqn
 
	 foreach v of var diff_* { 
		*String without "diff_"
		 local p = substr("`v'", 6, .) 
		 gen perc_`p' = diff_`p'*100/ttl_ori`p'
	}

	**#Percent Difference
	*Calculate percent change (mean of individual percent changes)
	svy, subpop (if subpop==1): mean (perc_grams-perc_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel Y1 = ("`filename'_% diff")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames


*Total ghg difference across the entire sample for one day
	svy, subpop (if subpop==1): total (diff_ghgcons)
	display %12.0g _b[diff_ghgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel AG1 = ("`filename'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames

		
	save "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc/`filename'_ttl-diff-perc.dta", replace
		*count 8,505 x 383 columns
}



********
**#STEP 2B: Calculate difference between substituted and original totals for the same seqn
*by DEMOGRAPHIC GROUP
********

cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#AgeCat
	forval f=1/8 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel A1 = ("`filename'_AgeCat_`f'_original")
		putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel I1 = ("`filename'_AgeCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Q1 = ("`filename'_AgeCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Y1 = ("`filename'_AgeCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & ageCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel AG1 = ("`filename'_AgeCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}

}


//note: count for perc_* are lower than regular count


cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#genderCat
	forval f=1/2 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & genderCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel A1 = ("`filename'_genderCat_`f'_original")
		putexcel C1 = ("Gender_Labels 1: Male 2: Female")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & genderCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel I1 = ("`filename'_genderCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel Q1 = ("`filename'_genderCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel Y1 = ("`filename'_genderCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & genderCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel AG1 = ("`filename'_genderCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}

}
	
cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#eduCat
	forval f=1/4 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & eduCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel A1 = ("`filename'_eduCat_`f'_original")
		putexcel C1 = ("Edu_Labels 1: Less than high school | 2: High school graduate or GED | 3: Some college | 4: College degree or higher")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & eduCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel I1 = ("`filename'_eduCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & eduCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel Q1 = ("`filename'_eduCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & eduCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel Y1 = ("`filename'_eduCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & eduCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel AG1 = ("`filename'_eduCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}

}
	
	
cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#pirCat
	foreach f of numlist 1/4 99 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & pirCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel A1 = ("`filename'_pirCat_`f'_original")
		putexcel C1 = ("pir_Labels 1: <1.00 | 2: 1.00 to <2.00 | 3: 2.00 to <5.00 | 4: 5.00 or higher | 99: missing")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & pirCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel I1 = ("`filename'_pirCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & pirCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel Q1 = ("`filename'_pirCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & pirCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel Y1 = ("`filename'_pirCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & pirCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel AG1 = ("`filename'_pirCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}

}
	
	
cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#raceCat
	forval f=1/4 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & raceCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel A1 = ("`filename'_raceCat_`f'_original")
		putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Other Race")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & raceCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel I1 = ("`filename'_raceCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & raceCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel Q1 = ("`filename'_raceCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & raceCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel Y1 = ("`filename'_raceCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & raceCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel AG1 = ("`filename'_raceCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}

}
	

	
///////// not updated yet	
********
******** B) SUBSET: SEQN with substitution

use "$Analysis/Statistics/Dataset with ttl and diff.dta", clear

* Analyze subset of those with substitution

*keep if sub_flag == 1
* count 13,363

*Calculate mean + SE - table 3 and 4 ('keep' x 'subpop' gives the same mean and SE)

svy, subpop (if sub_flag==1): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)

svy, subpop (if sub_flag==1): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)

*Calculate absolute difference: paired t-test


*Regression - Paired t-test
foreach var of var diff* {
	svy, subpop (if sub_flag==1): reg `var'
}

*Same results as regression
svy, subpop (if sub_flag==1): mean (diff_kcal-diff_ghgcons)


*Calculate percent change (mean of individual percent changes)
*To show confidence interval have to run from the dataset (don't run keep if)
svy, subpop (if sub_flag==1): mean (perc_kcal-perc_ghgcons)


*Total ghg difference across the entire sample for one day
svy, subpop (if sub_flag==1): total (diff_ghgcons)

*Show entire number
di %12.0g _b[diff_ghgcons]


**Results by population group
**HEI by demo group
