*R&R1: Compare GHG mean change across demo categories (for substituters)

cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	*AgeCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_ghgcons i.ageCat
		
		pwcompare i.ageCat, mcompare(bonferroni)
		
matrix b = r(table_vs)'
matrix list b
putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/RR1/Pairwise comparisons_ghg_bydemo_`filename'.xlsx", sheet("agecat") modify
putexcel A1 = ("AgeCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names
		
	*GenderCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_ghgcons i.genderCat
		
		pwcompare i.genderCat
		*don't need p-value correction since it's 1 comparison.
		
matrix b = r(table_vs)'
matrix list b
putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/RR1/Pairwise comparisons_ghg_bydemo_`filename'.xlsx", sheet("gendercat") modify
putexcel A1 = ("AgeCat Pairwise comparisons")
putexcel A2 = "No p-value adjustment"
putexcel C1 = ("Gender_Labels 1: Male 2: Female")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names

	*RaceCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_ghgcons i.raceCat
		
		pwcompare i.raceCat, mcompare(bonferroni)
		
matrix b = r(table_vs)'
matrix list b
putexcel set "$Results/2015-16/Mean_nutri_ghg/Substituters/RR1/Pairwise comparisons_ghg_bydemo_`filename'.xlsx", sheet("racecat") modify
putexcel A1 = ("AgeCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names

}


