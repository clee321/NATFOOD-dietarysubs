**Convert NHANES data (DRXFCD, DRXMCD, DEMO, DR1IFF) from .XPT to .DTA

*****2015-2016*****

foreach file in DR1IFF DRXFCD DEMO  {
	cd "$Data/NHANES"
	clear
	import sasxport5 `file'_I.xpt
	save `file'_2015-16.dta, replace
}

**Convert WWEIA category lists from excel to .dta

cd "$Data/WWEIA"

import excel "WWEIA_1516.xlsx", sheet("Foods and Beverages")  firstrow clear
rename Foodcode food_code
rename WWEIACategorycode category_number
rename WWEIACategorydescription category_description

save "WWEIA_1516.dta", replace

**Convert dataFRIENDS from excel to .dta

cd "$Data"

import excel "$Data/dataFRIENDS/dataFRIENDS_2.0_20221215_correct rice.xlsx", sheet("Data")  firstrow clear

save "$Data/dataFRIENDS/dataFRIENDS_2.0_20221215.dta", replace
