
*** CALCULATION OF DESCRIPTIVE STATISTICS

cd "$Data/NHANES/v2_racecat"

use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear

*** SURVEY SET
**Declare data as Survey set - Using DEMO weight 
svyset sdmvpsu [pw=wtint2yr], strata(sdmvstra)

*Drop duplicates for analysis
duplicates drop seqn, force

tab subpop

*Proportion of subpop for each of the sociodemographic variables

//Replace 0 with missing - tab code doesn't work with categories with 0
replace ageCat=. if ageCat==0


//Set up Excel doc
putexcel set "$Results/Descriptive/Descriptive_subpop all.xlsx", modify

putexcel A1 = "Descriptive statistics_all"

local row=3

	foreach var of varlist genderCat ageCat raceCat eduCat pirCat {
		
		svy, subpop (if subpop==1): tab `var'
		
		putexcel A`row' = matrix(e(Prop)), rownames nformat(percent)
		putexcel D`row' = matrix(e(N_sub)), rownames
		local row = `row'+e(r)+1
		
	}

