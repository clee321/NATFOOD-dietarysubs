
*********
**#A) Analysis Overall
*********
**Mean changes in GHG emissions and nutrition outcomes per person per day after substitutions for the entire sample.

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

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
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

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel Q1 = ("`filename'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames

******
	**#Percent Difference per seqn
		 foreach v of var diff_* { 
		*String without "diff_"
		 local p = substr("`v'", 6, .) 
		 gen perc_`p' = diff_`p'*100/ttl_ori`p'
	}

	**Mean Percent Difference
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
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames


	**#Total ghg difference across the entire sample for one day
	**Original
	svy, subpop (if subpop==1): total (ttl_orighgcons)
	display %12.0g _b[ttl_orighgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel AG1 = ("`filename'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
		
	**Substituted
	svy, subpop (if subpop==1): total (ttl_subghgcons)
	display %12.0g _b[ttl_subghgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel AG4 = matrix(b), rownames nformat(#,###)
		putexcel AJ4 = matrix(ci), nformat(#,###)
		putexcel AL4 = matrix(p)


	**Difference
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

		putexcel AG5 = matrix(b), rownames nformat(#,###)
		putexcel AJ5 = matrix(ci), nformat(#,###)
		putexcel AL5 = matrix(p)

		
	**#Percentage difference overall
	*Add formula	
 
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
		putexcel AG6 = ("ghg_% diff")
		putexcel AH6 = formula(AH5*100/AH3)
		
		
	**#N count	
	count if sub_flag==1
		scalar sb = r(N)
	count if subpop==1
		scalar tt = r(N)
		
		putexcel AG8 = "Subflag N"
		putexcel AH8=sb
		putexcel AG9 = "Subpop N"
		putexcel AH9=tt
		putexcel AI8 = sb/tt, nformat(percent)
		
		
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
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel A1 = ("`filename'_AgeCat_`f'_original")
		putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel I1 = ("`filename'_AgeCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Q1 = ("`filename'_AgeCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		
		svy, subpop (if subpop==1 & ageCat==`f'): mean (perc_grams-perc_ghgcons)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Y1 = ("`filename'_AgeCat_`f'% diff")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		
		//total ghg difference
			**Original
		svy, subpop (if subpop==1 & ageCat==`f'): total (ttl_orighgcons)
		display %12.0g _b[ttl_orighgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
		
		putexcel AG1 = ("`filename'_AgeCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
		
			**Substituted
		svy, subpop (if subpop==1 & ageCat==`f'): total (ttl_subghgcons)
		display %12.0g _b[ttl_subghgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p

		putexcel AG4 = matrix(b), rownames nformat(#,###)
		putexcel AJ4 = matrix(ci), nformat(#,###)
		putexcel AL4 = matrix(p)
		
			**Difference
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
		
		putexcel AG5 = matrix(b), rownames nformat(#,###)
		putexcel AJ5 = matrix(ci), nformat(#,###)
		putexcel AL5 = matrix(p)

	
		**#Percentage difference overall
		*Add formula	
 
		putexcel AG6 = ("ghg_% diff")
		putexcel AH6 = formula(AH5*100/AH3)
		
				
	}

}

**#Gender

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
		svy, subpop (if subpop==1 & genderCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel A1 = ("`filename'_genderCat_`f'_original")
		putexcel C1 = ("Gender_Labels 1: Male 2: Female")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & genderCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel I1 = ("`filename'_genderCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel Q1 = ("`filename'_genderCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (perc_grams-perc_ghgcons)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel Y1 = ("`filename'_genderCat_`f'% diff")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames

		
		//total ghg difference
		
		**Original
		svy, subpop (if subpop==1 & genderCat==`f'): total (ttl_orighgcons)
		display %12.0g _b[ttl_orighgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p

			putexcel AG1 = ("`filename'_genderCat_`f'_total ghg difference for one day across entire sample")
			putexcel AG2 = matrix(b), names nformat(#,###)
			putexcel AJ2 = matrix(ci), colnames nformat(#,###)
			putexcel AL2 = matrix(p), colnames
			
		
		**Substituted
		svy, subpop (if subpop==1 & genderCat==`f'): total (ttl_subghgcons)
		display %12.0g _b[ttl_subghgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p

			putexcel AG4 = matrix(b), rownames nformat(#,###)
			putexcel AJ4 = matrix(ci), nformat(#,###)
			putexcel AL4 = matrix(p)


		**Difference
		svy, subpop (if subpop==1 & genderCat==`f'): total (diff_ghgcons)
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

			putexcel AG5 = matrix(b), rownames nformat(#,###)
			putexcel AJ5 = matrix(ci), nformat(#,###)
			putexcel AL5 = matrix(p)
			

		**#Percentage difference overall
		*Add formula	
	 
			putexcel AG6 = ("ghg_% diff")
			putexcel AH6 = formula(AH5*100/AH3)
			
				
	}

}
	
**#Race	
	
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
		svy, subpop (if subpop==1 & raceCat==`f'): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel A1 = ("`filename'_raceCat_`f'_original")
		putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & raceCat==`f'): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel I1 = ("`filename'_raceCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & raceCat==`f'): mean (diff_grams-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/`filename'_mean_nutri_ghg_seqn_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel Q1 = ("`filename'_raceCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference

		svy, subpop (if subpop==1 & raceCat==`f'): mean (perc_grams-perc_ghgcons)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel Y1 = ("`filename'_raceCat_`f'% diff")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		
		//total ghg difference
		**Original
		svy, subpop (if subpop==1 & raceCat==`f'): total (ttl_orighgcons)
		display %12.0g _b[ttl_orighgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p

			*putexcel set "$Results/2015-16/Mean_nutri_ghg/Overall pop/Mean_nutri_ghg_seqn.xlsx", sheet ("`filename'") modify
			putexcel AG1 = ("`filename'_total ghg difference for one day across entire sample")
			putexcel AG2 = matrix(b), names nformat(#,###)
			putexcel AJ2 = matrix(ci), colnames nformat(#,###)
			putexcel AL2 = matrix(p), colnames
			
		**Substituted
		svy, subpop (if subpop==1 & raceCat==`f'): total (ttl_subghgcons)
		display %12.0g _b[ttl_subghgcons]

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p

			putexcel AG4 = matrix(b), rownames nformat(#,###)
			putexcel AJ4 = matrix(ci), nformat(#,###)
			putexcel AL4 = matrix(p)


		**Difference
		svy, subpop (if subpop==1 & raceCat==`f'): total (diff_ghgcons)
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

			putexcel AG5 = matrix(b), rownames nformat(#,###)
			putexcel AJ5 = matrix(ci), nformat(#,###)
			putexcel AL5 = matrix(p)

		
		**#Percentage difference overall
		*Add formula	
	 
			putexcel AG6 = ("ghg_% diff")
			putexcel AH6 = formula(AH5*100/AH3)	
							
	}

}
	
