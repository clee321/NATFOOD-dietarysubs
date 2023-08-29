
**HEI Results Compilation
**#Substituters

cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
local row=2
putexcel set "$Results/2015-16/HEI/HEI_Compilation.xlsx", sheet("Whole") modify
putexcel A1 = "Substituters"
putexcel C`row' = "Before"
putexcel D`row' = "After"
putexcel E`row' = "Difference"
putexcel F`row' = "%_Difference"


foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear
	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	**#Original

	svy, subpop (if subpop==1 & sub_flag==1): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel A`row' = "`filename'"
		*putexcel B`row' = ageCat
		putexcel C`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & sub_flag==1): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel D`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & sub_flag==1): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel E`row' = matrix(b), nformat(number_d2)	
		
		putexcel F`row' = formula(E`row'*100/C`row'), nformat(number_d2)	
	
}

**#Overall Sample (next to Substituters)

local row=2
putexcel set "$Results/2015-16/HEI/HEI_Compilation.xlsx", sheet("Whole") modify
putexcel I1 = "Overall"
putexcel K`row' = "Before"
putexcel L`row' = "After"
putexcel M`row' = "Difference"
putexcel N`row' = "%_Difference"


foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear
	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	**#Original

	svy, subpop (if subpop==1): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel I`row' = "`filename'"
		putexcel K`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel L`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel M`row' = matrix(b), nformat(number_d2)	
		
		putexcel N`row' = formula(M`row'*100/K`row'), nformat(number_d2)	
	
}


**#Substituters by demo group

cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
local row=2

foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
		
	putexcel set "$Results/2015-16/HEI/HEI_Compilation.xlsx", sheet ("`filename'") modify
	putexcel A1 = "Substituters by demo"
	putexcel A2 = "`filename'"
	putexcel C2 = "Before"
	putexcel D2 = "After"
	putexcel E2 = "Difference"
	putexcel F2 = "%_Difference"

		**#AgeCat
	forval f=1/8 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel B`row' = "ageCat_`f'"
		putexcel C`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel D`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & sub_flag==1 & ageCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel E`row' = matrix(b), nformat(number_d2)	
		
		putexcel F`row' = formula(E`row'*100/C`row'), nformat(number_d2)	
			
	}
	
	local ++row
	
		**#GenderCat
	forval f=1/2 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel B`row' = "genderCat_`f'"
		putexcel C`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel D`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & sub_flag==1 & genderCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel E`row' = matrix(b), nformat(number_d2)	
		
		putexcel F`row' = formula(E`row'*100/C`row'), nformat(number_d2)	
			
	}
	
		local ++row
	
		**#RaceCat
	forval f=1/5 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel B`row' = "raceCat_`f'"
		putexcel C`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel D`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & sub_flag==1 & raceCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel E`row' = matrix(b), nformat(number_d2)	
		
		putexcel F`row' = formula(E`row'*100/C`row'), nformat(number_d2)	
			
	}
	
	local row=2
}

**#Overall sample by demo group

cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
local row=2

foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
		
	putexcel set "$Results/2015-16/HEI/HEI_Compilation.xlsx", sheet ("`filename'") modify
	putexcel I1 = "Overall by demo"
	putexcel I2 = "`filename'"
	putexcel K2 = "Before"
	putexcel L2 = "After"
	putexcel M2 = "Difference"
	putexcel N2 = "%_Difference"

		**#AgeCat
	forval f=1/8 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & ageCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel J`row' = "ageCat_`f'"
		putexcel K`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & ageCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel L`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & ageCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel M`row' = matrix(b), nformat(number_d2)	
	
		putexcel N`row' = formula(M`row'*100/K`row'), nformat(number_d2)	
			
	}
	
	local ++row
	
		**#GenderCat
	forval f=1/2 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & genderCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel J`row' = "genderCat_`f'"
		putexcel K`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & genderCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel L`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & genderCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel M`row' = matrix(b), nformat(number_d2)	
		
		putexcel N`row' = formula(M`row'*100/K`row'), nformat(number_d2)	
			
	}
	
		local ++row
	
		**#RaceCat
	forval f=1/5 {
		display `f'
		
	**#Original

	svy, subpop (if subpop==1 & raceCat==`f'): mean (oHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
			
	local ++row
		putexcel J`row' = "raceCat_`f'"
		putexcel K`row' = matrix(b), nformat(number_d2)

	**#Substituted
	svy, subpop (if subpop==1 & raceCat==`f'): mean (sHEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel L`row' = matrix(b), nformat(number_d2)	
	
	**#Difference
	svy, subpop (if subpop==1 & raceCat==`f'): mean (diff_HEI2015_TOTAL_SCORE)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..1,1...]'
	matlist b
	
		putexcel M`row' = matrix(b), nformat(number_d2)	
		
		putexcel N`row' = formula(M`row'*100/K`row'), nformat(number_d2)	
			
	}
	
	local row=2
}
