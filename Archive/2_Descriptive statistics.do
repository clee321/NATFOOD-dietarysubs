
*** CALCULATION OF DESCRIPTIVE STATISTICS

cd "$Data/NHANES/2015-2016/v2_racecat"

use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear

*** SURVEY SET
**Declare data as Survey set - Using DEMO weight 
svyset sdmvpsu [pw=wtint2yr], strata(sdmvstra)


*Drop duplicates for analysis
duplicates drop seqn, force

*-----------------------------
*112,976 observations deleted
*  8,505 observations left
*-----------------------------

tab subpop

*     subpop |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |        752        8.84        8.84
*          1 |      7,753       91.16      100.00
*------------+-----------------------------------
*      Total |      8,505      100.00


*Proportion of subpop for each of the sociodemographic variables

svy, subpop (if subpop==1): prop ageCat

svy, subpop (if subpop==1): prop genderCat

svy, subpop (if subpop==1): prop eduCat

svy, subpop (if subpop==1): prop pirCat

svy, subpop (if subpop==1): prop raceCat





