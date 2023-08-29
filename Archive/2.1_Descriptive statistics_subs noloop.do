
*** CALCULATION OF DESCRIPTIVE STATISTICS


use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc/All_Sub_low_ttl-diff-perc.dta", clear

*** SURVEY SET
**Declare data as Survey set - Using DEMO weight 
svyset sdmvpsu [pw=wtint2yr], strata(sdmvstra)


tab subpop

*     subpop |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |        752        8.84        8.84
*          1 |      7,753       91.16      100.00
*------------+-----------------------------------
*      Total |      8,505      100.00


//Sub_flag should not have missing values for the test
replace sub_flag=0 if sub_flag==.

//Replace 0 with missing - tab code doesn't work with categories with 0
replace ageCat=. if ageCat==0


//Test of Independence
*Proportion of subpop for each of the sociodemographic variables

svy, subpop (if subpop==1): tab ageCat sub_flag, pearson

*ereturn list

putexcel set "$Results/2015-16/Descriptive/Descriptive_subflag tt.xlsx", replace

local row=3
putexcel A`row' = matrix(e(Prop)), rownames nformat(percent)
local row = `row'+e(r)

putexcel A`row' = matrix(e(p_Pear)), names nformat(number_d4)

svy, subpop (if subpop==1 & sub_flag==1): tab ageCat

svy, subpop (if subpop==1): tab genderCat sub_flag, pearson

svy, subpop (if subpop==1): tab raceCat sub_flag, pearson

svy, subpop (if subpop==1): tab eduCat sub_flag, pearson

svy, subpop (if subpop==1): tab pirCat sub_flag, pearson







