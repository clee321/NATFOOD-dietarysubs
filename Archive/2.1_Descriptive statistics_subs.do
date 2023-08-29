
*** CALCULATION OF DESCRIPTIVE STATISTICS for Substituters

cd "$Analysis/Substitution/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'

	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl-diff-perc.dta","")

	use `file', clear


*** SURVEY SET
**Declare data as Survey set - Using DEMO weight 
svyset sdmvpsu [pw=wtint2yr], strata(sdmvstra)

tab subpop

//Sub_flag should not have missing values for the test
replace sub_flag=0 if sub_flag==.

//Replace 0 with missing - tab code doesn't work with categories with 0
replace ageCat=. if ageCat==0

//Set up Excel doc
putexcel set "$Results/Descriptive/Descriptive_subflag.xlsx", sheet ("`filename'") modify

putexcel A1 = "Descriptive statistics_substituters"
putexcel B2 = "Subflag_1"

local row=3

	foreach var of varlist genderCat ageCat raceCat eduCat pirCat {
		
		//proportion for sub_flag==1 (total of 100%)
		svy, subpop (if subpop==1 & sub_flag==1): tab `var'
		
		putexcel A`row' = matrix(e(Prop)), rownames nformat(percent)
		local row = `row'+e(r)
		putexcel D`row' = "N"
		putexcel E`row' = matrix(e(N_sub))
				
		//p-value (proportion for each sub_flag is not 100%)
		svy, subpop (if subpop==1): tab `var' sub_flag, pearson
		
		putexcel F`row' = "p-value"
		putexcel G`row' = matrix(e(p_Pear))
		local ++row
		
				display "row is `row'"
	}
}

