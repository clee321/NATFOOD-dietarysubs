Comparison between dataFRIENDS versions

cd "$Data/dataFRIENDS"

*** 1) Convert Excel to .dta, add column with version to compare versions
import excel "dataFRIENDS_2.0_20220204.xlsx", sheet("Data")  firstrow clear
recast float ghg100
gen version = "2"
gen ghg100_2 = ghg100
save "dataFRIENDS_2.0b.dta", replace

*** 2) Rename food_code to merge food description with dataFRIENDS table
*use "$Data/NHANES/2015-2016/DRXFCD_2015-16.dta",clear
*rename drxfdcd food_code
*save "$Data/NHANES/2015-2016/DRXFCD_2015-16_renamed.dta", replace

*** 3) Merge dataFRIENDS with food description
***There are items that are not in dataFRIENDS (merge==2)
use "$Data/dataFRIENDS/dataFRIENDS_2.0b.dta", clear
merge 1:1 food_code using "$Data/NHANES/2015-2016/DRXFCD_2015-16_renamed.dta", generate(_mergev2)
save "$Data/dataFRIENDS/Comparison/dataFRIENDS_2.0 w fooddescr.dta", replace
export excel "$Data/dataFRIENDS/Comparison/dataFRIENDS_2.0 w fooddescr.xlsx", firstrow(variables) replace

dataFRIENDS v2: 57 items without ghg100

 Not matched                         3,304
 
		*dataFRIENDS food codes without NHANES food description
        from master                     1,821  (_mergev2==1)
		
		*NHANES food codes not present in dataFRIENDS
		*ghg unavailable for excluded food categories (baby foods, etc), but also chocolate milk, hot dogs, fish dishes, cereals, etc.
        from using                      1,483  (_mergev2==2)
		
 Matched                             7,207  (_mergev2==3)

*** 1) Convert Excel to .dta, add column with version to compare versions
import excel "dataFRIENDS_1.0.xlsx", sheet("Data")  firstrow clear
recast float ghg100
gen version_ = "1"
gen ghg100_1 = ghg100
save "$Data/dataFRIENDS/dataFRIENDS_1.0b.dta", replace

*** 2) Rename food_code to merge food description with dataFRIENDS table
*use "$Data/NHANES/2009-2010/DRXFCD_2009-10.dta",clear
*rename drxfdcd food_code
*save "$Data/NHANES/2009-2010/DRXFCD_2009-10_renamed.dta", replace

*** 3) Merge dataFRIENDS with food description
***There are items that are not in dataFRIENDS (merge==2)
use "$Data/dataFRIENDS/dataFRIENDS_1.0b.dta", clear
merge m:1 food_code using "$Data/NHANES/2009-2010/DRXFCD_2009-10_renamed.dta", generate(_mergev1)
save "$Data/dataFRIENDS/Comparison/dataFRIENDS_1.0 w fooddescr.dta", replace
export excel "$Data/dataFRIENDS/Comparison/dataFRIENDS_1.0 w fooddescr.xlsx", firstrow(variables) replace

dataFRIENDS v1: 22 items without ghg100
(Used only one cycle of NHANES for this version comparison than all 3 cycles)

 Not matched                         1,615
 
		*dataFRIENDS food codes not present in NHANES (no food description)
        from master                       679  (_mergev1==1)
		
		*NHANES food codes not present in dataFRIENDS
        from using                        936  (_mergev1==2)
		
 Matched                            10,979  (_mergev1==3)


*** 4) Merge version 2 with version 1
*** Check which items are in v2 that are not in v1 ()
use "$Data/dataFRIENDS/Comparison/dataFRIENDS_2.0 w fooddescr.dta", clear
merge 1:m food_code using "$Data/dataFRIENDS/Comparison/dataFRIENDS_1.0 w fooddescr.dta", generate(_merge_versions)
save "$Data/dataFRIENDS/Comparison/comparison_dataFRIENDS_1x2.dta", replace
export excel "$Data/dataFRIENDS/Comparison/comparison_dataFRIENDS_1x2b.xlsx", firstrow(variables) replace

 Not matched                         3,328
 
		*dataFRIENDS v2 food codes not present in v1
		*New itms: non-dairy milk, greek yogurt, chicken items (rotisserie, grilled, wings...), fish items, cheeseburger
		from master                     3,058  (_merge_versions==1)
		
		*dataFRIENDS v1 food codes not present in v2
		*mostly old items without GHG info
		from using                        270  (_merge_versions==2)

 Matched                            12,324  (_merge_versions==3)

