**Prepare dataset for HEI calculation

cd "$Analysis/HEI"

*For Original dataset: Food Patterns Equivalents Database per 100 grams of FNDDS 2015-2016 foods
*Convert FPED from .XLS to .DTA
import excel "$Data/FPED/FPED_1516.xls", firstrow clear
rename FOODCODE food_code
rename *cupeq *
rename *ozeq *
rename *grams *
rename *tspeq *
rename *noofdrinks *
*no duplicates on FOODCODE
save "$Data/FPED/FPED_1516.dta", replace

*For Substituted dataset: Food Patterns Equivalents Database per 100 grams of FNDDS 2015-2016 foods
*Convert FPED from .XLS to .DTA
import excel "$Data/FPED/FPED_1516.xls", firstrow clear
rename *cupeq *
rename *ozeq *
rename *grams *
rename *tspeq *
rename *noofdrinks *

foreach x of var * { 
	rename (`x') (sub_`x')
} 

rename (sub_FOODCODE) (sub_code) 
///rename to sub_code to merge with sub data
*no duplicates on FOODCODE

save "$Data/FPED/FPED_1516_sub.dta", replace
