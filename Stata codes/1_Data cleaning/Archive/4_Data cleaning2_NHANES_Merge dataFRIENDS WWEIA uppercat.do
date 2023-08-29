**Merge Dietary data (NHANES,WWEIA) with DataFRIENDS**

cd "$Data/WWEIA"

import excel "WWEIA_2015-16_foodcat_list_uppercats.xlsx", sheet("Sheet2")  firstrow clear
save "WWEIA_2015-16_foodcat_list_uppercats.dta", replace


cd "$Data/NHANES"

*Use NHANES appended data for 3 waves
use "DR1IFF_2015-16_FCD_DEMO_WWEIA.dta", clear

**Merge with Food Codes & Mod Codes from DataFRIENDS**
merge m:1 food_code using "$Data/dataFRIENDS/dataFRIENDS_2.0_20221215.dta", generate(_merge_dtFR)

*-----------------------------------------------------------------
    *Not matched                         7,465
		
		*In NHANES, but not dataFRIENDS
        *from master                     3,335  (_merge_dtFR==1)
		
		*In dataFRIENDS, but not in NHANES
        *from using                      4,130  (_merge_dtFR==2)

    *Matched                           118,146  (_merge_dtFR==3)
*-----------------------------------------------------------------

*mostly baby food and items with low frequency
tab drxfcsd if _merge_dtFR==1 

*Drop values from dataFRIENDS that did not match NHANES
drop if _merge_dtFR==2

*mostly baby food and alcoholic beverages without ghg
tab drxfcsd if missing(ghg100)

save "NHANES_WWEIA_DataFRIENDS_2015-16", replace


**Merge with WWEIA upper categories

merge m:1 category_number using "$Data/WWEIA/WWEIA_2015-16_foodcat_list_uppercats.dta", generate(_merge_WWEIAup)

*Drop values from 'using' that did not match
drop if _merge_WWEIAup==2

save "NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16", replace


