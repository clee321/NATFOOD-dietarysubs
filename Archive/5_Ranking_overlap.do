*Overlapping lists

*Set length of overlap to conside

foreach major in Protein MxDishes Milk Beverages Snacks {

if "`major'"=="Protein" {
	local majorlongname = "Protein Foods"	
	local topx = 100
}
 
else if "`major'"=="MxDishes" {
	local majorlongname = "Mixed Dishes"	
	local topx = 100
}

else if "`major'"=="Milk" {
	local majorlongname = "Milk and Dairy"
	local topx = 100
}

else if "`major'"=="Beverages" {
	local majorlongname = "Beverages, Nonalcoholic"	
	local topx = 100
}

else if "`major'"=="Snacks" {
	local majorlongname = "Snacks and Sweets"	
	local topx = 100
}



*Total GHG Ranking

import excel "$Analysis/Ranking/total_ghg/Analysis_foodcodes_ghgconsumed_weighted.xlsx", sheet("`majorlongname'") firstrow clear

rename total_ghgcons total_ghg

gsort -total_ghg
gen rank_total_ghg = _n

gen top`topx'_total_ghg = .
	replace top`topx'_total_ghg = 1 if inrange(rank, 1,`topx')
	replace top`topx'_total_ghg = 0 if rank>`topx' & rank !=.

save "$Analysis/Ranking/overlap/IntermediateData/`major'_totalGHG_ranked.dta", replace



*Intensity GHG Ranking

import excel "$Analysis/Ranking/ghg_intensity/Analysis_foodcodes_ghg.xlsx", sheet("`majorlongname'") firstrow clear

gsort -mean_ghg100
gen rank_ghg100 = _n

gen top`topx'_ghg100 = .
	replace top`topx'_ghg100 = 1 if inrange(rank, 1,`topx')
	replace top`topx'_ghg100 = 0 if rank>`topx' & rank !=. 

	save "$Analysis/Ranking/overlap/IntermediateData/`major'_GHG100_ranked.dta", replace

	
*Merge lists
merge 1:1 food_code using "$Analysis/Ranking/overlap/IntermediateData/`major'_totalGHG_ranked.dta"

gen top`topx'_both = .
	replace top`topx'_both = 1 if top`topx'_ghg100==1 & top`topx'_total_ghg==1
	replace top`topx'_both = 0 if top`topx'_ghg100==0 | top`topx'_total_ghg==0
	
keep if top`topx'_both==1
gsort -total_ghg


*Convert grams to kg
gen total_kg = total_grams/1000 

rename drxfcsd description
 
order food_code description total_ghg mean_ghg100 total_kg rank_total_ghg rank_ghg100

*Export to excel
keep food_code description total_ghg mean_ghg100 total_kg rank_total_ghg rank_ghg100


*Count used for excel formating
count
local rows=r(N)
local ++rows 

export excel using "$Analysis/Ranking/overlap/`major'_RankedOverlap.xlsx", firstrow(variables) replace

*Format excel 
putexcel set "$Analysis/Ranking/overlap/`major'_RankedOverlap.xlsx", modify
putexcel C2:C`rows', nformat(#,###)
putexcel D2:D`rows', nformat(##.##0)
putexcel E2:E`rows', nformat(#,###)

} 
