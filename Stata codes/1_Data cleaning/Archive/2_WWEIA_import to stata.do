**Convert WWEIA category lists from excel to .dta

cd "$Data/WWEIA"

import excel "WWEIA_1516.xlsx", sheet("Foods and Beverages")  firstrow clear
rename Foodcode food_code
rename WWEIACategorycode category_number
rename WWEIACategorydescription category_description

save "WWEIA_1516.dta", replace

