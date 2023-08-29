
*Analysis Overall: 
	*Step 1: Totals per seqn for original and substituted datasets
		*Export to excel on different sheets
	*Step 2: Difference between substituted and originals

*Analysis per Demo group


*********
**#A) Analysis Substituters
*********
**Mean changes in GHG emissions and nutrition outcomes per person per day after substitutions for the substituters sample.

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

	svy, subpop (if subpop==1 & sub_flag==1): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/Mean_nutri_ghg_seqn_subflag.xlsx", sheet ("`filename'") modify
		putexcel A1 = ("`filename'_original")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames

	**#Substituted
	svy, subpop (if subpop==1 & sub_flag==1): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/Mean_nutri_ghg_seqn_subflag.xlsx", sheet ("`filename'") modify
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
	*	svy, subpop (if subpop==1 & sub_flag==1): reg `var'
	*}

*Same results as regression
	**#Difference
	svy, subpop (if subpop==1 & sub_flag==1): mean (diff_grams-diff_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/Mean_nutri_ghg_seqn_subflag.xlsx", sheet ("`filename'") modify
		putexcel Q1 = ("`filename'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames

******
	**#Percentage difference overall
	*Add formula	
 
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/Mean_nutri_ghg_seqn_subflag.xlsx", sheet ("`filename'") modify
		putexcel X1 = ("`filename'_% diff")
		
		forvalues i=3/50 {
			putexcel X`i' = formula(R`i'*100/B`i')
		}

*Total ghg difference across the entire sample for one day
	svy, subpop (if subpop==1 & sub_flag==1): total (diff_ghgcons)
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

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/Mean_nutri_ghg_seqn_subflag.xlsx", sheet ("`filename'") modify
		putexcel AA1 = ("`filename'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames

		
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
		svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel A1 = ("`filename'_AgeCat_`f'_original")
		putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel I1 = ("`filename'_AgeCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Q1 = ("`filename'_AgeCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel X1 = ("`filename'_AgeCat_`f'% diff")
		forvalues i=3/50 {
			putexcel X`i' = formula(R`i'*100/B`i')
		}
		
		
		//total ghg difference
		svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): total (diff_ghgcons)
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel AA1 = ("`filename'_AgeCat_`f'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames
				
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
	
	**#genderCat
	forval f=1/2 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel A1 = ("`filename'_genderCat_`f'_original")
		putexcel C1 = ("Gender_Labels 1: Male 2: Female")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel I1 = ("`filename'_genderCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel Q1 = ("`filename'_genderCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel X1 = ("`filename'_genderCat_`f'% diff")
		
		forvalues i=3/50 {
		putexcel X`i' = formula(R`i'*100/B`i')
		}
		
		//total ghg difference
		svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): total (diff_ghgcons)
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel AA1 = ("`filename'_genderCat_`f'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames
				
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
		svy, subpop (if subpop==1 & sub_flag==1 & eduCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel A1 = ("`filename'_eduCat_`f'_original")
		putexcel C1 = ("Edu_Labels 1: Less than high school | 2: High school graduate or GED | 3: Some college | 4: College degree or higher")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & sub_flag==1 & eduCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel I1 = ("`filename'_eduCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & sub_flag==1 & eduCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel Q1 = ("`filename'_eduCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel X1 = ("`filename'_eduCat_`f'% diff")
		
		forvalues i=3/50 {
		putexcel X`i' = formula(R`i'*100/B`i')
		}
		
		//total ghg difference
		svy, subpop (if subpop==1 & sub_flag==1 & eduCat==`f'): total (diff_ghgcons)
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("eduCat_`f'") modify
		putexcel AA1 = ("`filename'_eduCat_`f'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames
				
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
		svy, subpop (if subpop==1 & sub_flag==1 & pirCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel A1 = ("`filename'_pirCat_`f'_original")
		putexcel C1 = ("pir_Labels 1: <1.00 | 2: 1.00 to <2.00 | 3: 2.00 to <5.00 | 4: 5.00 or higher | 99: missing")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & sub_flag==1 & pirCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel I1 = ("`filename'_pirCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & sub_flag==1 & pirCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel Q1 = ("`filename'_pirCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel X1 = ("`filename'_pirCat_`f'% diff")
		
		forvalues i=3/50 {
		putexcel X`i' = formula(R`i'*100/B`i')
		}
		
		//total ghg difference
		svy, subpop (if subpop==1 & sub_flag==1 & pirCat==`f'): total (diff_ghgcons)
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("pirCat_`f'") modify
		putexcel AA1 = ("`filename'_pirCat_`f'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames
				
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
	
	**#raceCat //5 race/ethn categories
	forval f=1/5 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel A1 = ("`filename'_raceCat_`f'_original")
		putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel I1 = ("`filename'_raceCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel Q1 = ("`filename'_raceCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel X1 = ("`filename'_raceCat_`f'% diff")
		
		forvalues i=3/50 {
		putexcel X`i' = formula(R`i'*100/B`i')
		}
		
		//total ghg difference
		svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): total (diff_ghgcons)
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/`filename'_mean_nutri_ghg_seqn_subflag_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel AA1 = ("`filename'_raceCat_`f'_total ghg difference for one day across entire sample")
		putexcel AA2 = matrix(b), names nformat(#,###)
		putexcel AD2 = matrix(ci), colnames nformat(#,###)
		putexcel AF2 = matrix(p), colnames
				
	}

}


	
