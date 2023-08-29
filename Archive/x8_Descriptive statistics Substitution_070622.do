
cd "$Analysis/Statistics"

use "$Analysis/Statistics/Dataset with ttl and diff.dta", clear

*seqn with no duplicates, filtered by subpop == 1 (ranking ind)
*25,663

**Declare data as Survey set - Using new DEMO weight 
svyset sdmvpsu [pw=wtint6yr], strata(sdmvstra)

*Proportion of subpop
svy, subpop (if sub_flag==1): prop ageCat

svy, subpop (if sub_flag==1): prop genderCat

svy, subpop (if sub_flag==1): prop eduCat

svy, subpop (if sub_flag==1): prop pirCat

svy, subpop (if sub_flag==1): prop raceCat
