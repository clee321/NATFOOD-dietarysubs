**Overall percent difference was used in the manuscript. It was calculated manually. (HEI difference divided by original HEI)
	
**#All Pop
cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	**#Original

	svy, subpop (if subpop==1): mean (oHEI2015*)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_overall.xlsx", sheet ("`filename'") modify
		putexcel A1 = ("`filename'_original")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames


	**#Substituted

	svy, subpop (if subpop==1): mean (sHEI2015*)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_overall.xlsx", sheet ("`filename'") modify
		putexcel I1 = ("`filename'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames

	**#Difference
	svy, subpop (if subpop==1): mean (diff_HEI2015*)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_overall.xlsx", sheet ("`filename'") modify
		putexcel Q1 = ("`filename'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
	
	**# Mean %Difference
	svy, subpop (if subpop==1): mean (perc_HEI2015*)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames


}


**#By demo groups

cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	**#AgeCat
	forval f=1/8 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & ageCat==`f'): mean (oHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel A1 = ("`filename'_AgeCat_`f'_original")
		putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames	
		
		//substituted
		svy, subpop (if subpop==1 & ageCat==`f'): mean (sHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel I1 = ("`filename'_AgeCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (diff_HEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("ageCat_`f'") modify
		putexcel Q1 = ("`filename'_AgeCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference	
		svy, subpop (if subpop==1 & ageCat==`f'): mean (perc_HEI2015*)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
		
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
			
	}
	
	**#genderCat
	forval f=1/2 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & genderCat==`f'): mean (oHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel A1 = ("`filename'_genderCat_`f'_original")
		putexcel C1 = ("Gender_Labels 1: Male 2: Female")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames	
		
		//substituted
		svy, subpop (if subpop==1 & genderCat==`f'): mean (sHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel I1 = ("`filename'_genderCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (diff_HEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("genderCat_`f'") modify
		putexcel Q1 = ("`filename'_genderCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & genderCat==`f'): mean (perc_HEI2015*)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
		
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
	
	}
		
}	

		
cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)		
		
	
	**#raceCat //5 race/ethn categories
	forval f=1/5 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & raceCat==`f'): mean (oHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel A1 = ("`filename'_raceCat_`f'_original")
		putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & raceCat==`f'): mean (sHEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel I1 = ("`filename'_raceCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & raceCat==`f'): mean (diff_HEI2015*)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/HEI/Overall pop/HEI_`filename'_all_bydemo.xlsx", sheet ("raceCat_`f'") modify
		putexcel Q1 = ("`filename'_raceCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & raceCat==`f'): mean (perc_HEI2015*)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
	
	}
}
