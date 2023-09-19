*Pairwise comparisons of HEI mean change across demographic categories (among those with substitutions)

**Analysis HEI
**#By demo groups

cd "$Analysis/HEI"
local files: dir "$Analysis/HEI" files "HEI_total*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","HEI_total_score_per_seqn_allpop_","")
	local filename = regexr("`file_int'",".dta","")
	
	use `file', clear

	
	//declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
		
	*AgeCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_HEI2015_TOTAL_SCORE i.ageCat
		
		pwcompare i.ageCat, mcompare(bonferroni) groups pveffects

*p-values from all pairwise combinations
matrix c = r(table_vs)'
matrix list c
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo_allcombs_`filename'.xlsx", sheet("agecat") modify
putexcel A1 = ("AgeCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(c), names
		
matrix b = r(table)'
matrix list b
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo2_`filename'.xlsx", sheet("agecat") modify
putexcel A1 = ("AgeCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names
		
local row=4
forval f=1/8{
	putexcel K`row'="`r(groups`f')'"
	local ++row
}

		
	*GenderCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_HEI2015_TOTAL_SCORE i.genderCat
		
		pwcompare i.genderCat, pveffects
		*don't need p-value correction since it's 1 comparison.
		
*p-values from all pairwise combinations
matrix c = r(table_vs)'
matrix list c
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo_allcombs_`filename'.xlsx", sheet("gendercat") modify
putexcel A1 = ("GenderCat Pairwise comparisons")
putexcel A2 = "No p-value adjustment"
putexcel C1 = ("Gender_Labels 1: Male 2: Female")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(c), names	
		
matrix b = r(table)'
matrix list b
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo2_`filename'.xlsx", sheet("gendercat") modify
putexcel A1 = ("GenderCat Pairwise comparisons")
putexcel A2 = "No p-value adjustment"
putexcel C1 = ("Gender_Labels 1: Male 2: Female")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names

local row=4
forval f=1/2{
	putexcel K`row'="`r(groups`f')'"
	local ++row
}


	*RaceCat
	
		svy, subpop (if subpop==1 & sub_flag==1): reg diff_HEI2015_TOTAL_SCORE i.raceCat
		
		pwcompare i.raceCat, mcompare(bonferroni) groups pveffects
		
*p-values from all pairwise combinations
matrix c = r(table_vs)'
matrix list c
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo_allcombs_`filename'.xlsx", sheet("racecat") modify
putexcel A1 = ("RaceCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(c), names	
		
matrix b = r(table)'
matrix list b
putexcel set "$Results/2015-16/HEI/Substituters/Pairwise comparisons_HEI_bydemo2_`filename'.xlsx", sheet("racecat") modify
putexcel A1 = ("RaceCat Pairwise comparisons")
putexcel A2 = "Bonferroni adjustment"
putexcel C1 = ("race_Labels 1: Non-Hispanic White | 2: Non-Hispanic Black | 3: Mexican American and other Hispanic | 4: Non-Hispanic Asian | 5: Other Race")
putexcel B1= "`e(cmdline)'"
putexcel A3= matrix(b), names

local row=4
forval f=1/5{
	putexcel K`row'="`r(groups`f')'"
	local ++row
}

}


