
**Merge NHANES datasets: DR1IFF + FCD + DEMO + WWEIA

*****2015-2016*****

cd "$Data/NHANES/2015-2016"


***MERGE***

use "$Data/NHANES/2015-2016/DR1IFF_2015-16.dta", clear
rename dr1ifdcd drxfdcd

**Merge with Food Codes**
merge m:1 drxfdcd using "DRXFCD_2015-16.dta"

*Drop values from Food codes database that did not match with 1st day intake
*Foods not consumed by survey respondents
drop if _merge==2


**Merge with Demographic variables**
merge m:1 seqn using "DEMO_2015-16.dta", generate(_merge2)

*Drop values from Demo dataset that did not match with 1st day intake seqn ids.
*Seqn ids not in NHANES intake dataset
drop if _merge2==2

* Matched - 121,481 records
save "DR1IFF_2015-16_FCD_DEMO.dta", replace


**Merge with WWEIA
rename drxfdcd food_code
merge m:1 food_code using "$Data/WWEIA/WWEIA_1516.dta", generate(_mergeWWEIA)

*Drop values from WWEIA that did not match with NHANES
*Food codes not present in intake survey
drop if _mergeWWEIA==2

save "DR1IFF_2015-16_FCD_DEMO_WWEIA.dta", replace
export excel "$Data/NHANES/2015-2016/DR1IFF_2015-16_FCD_DEMO_WWEIA.xlsx", firstrow(variables) replace

