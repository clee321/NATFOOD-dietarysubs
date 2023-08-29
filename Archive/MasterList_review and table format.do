
cd "$Analysis/Ranking/2015-16/ghg_intensity"

*Add ghg100 columns to review subs

**Prepare ghg100 for merging
import excel "Analysis_foodcodes_ghg.xlsx", firstrow clear

keep food_code drxfcsd mean_ghg100
rename drxfcsd food_desc_check
rename mean_ghg100 ghg100_fd
save "For merges/ghg100_merge MasterList foodcode.dta", replace

rename food_code sb_code
rename food_desc_check sb_desc_check
rename ghg100_fd ghg100_sb
save "For merges/ghg100_merge MasterList sbcode.dta", replace

**Prepare overlap list to flag original overlap items

cd "$Analysis/Ranking/2015-16/overlap"
local files: dir "$Analysis/Ranking/2015-16/overlap" files "*RankedOverlap.xlsx"
foreach file in `files'{
	dir `file'
	import excel `file', firstrow clear
	local fname = subinstr("`file'",".xlsx","",.)
	gen origXadd = "orig"
	keep food_code origXadd
	save "$Analysis/Ranking/2015-16/overlap/Version_dta/`fname'_for Masterlist.dta", replace
}


**Merges with ghg100 - loop

*** (change cd to "activate" folder for the loop code)

cd "$Analysis/MasterLists/2015-16/AG Lists"
local files: dir "$Analysis/MasterLists/2015-16/AG Lists" files "*Substitutes*"
foreach file in `files'{
	dir `file'
	import excel `file', firstrow clear
	local fname = subinstr("`file'",".xlsx","",.)
	
	merge m:1 food_code using "$Analysis/Ranking/2015-16/ghg_intensity/For merges/ghg100_merge MasterList foodcode.dta", generate(_mergeorig)
	drop if _mergeorig==2

	merge m:1 sb_code using "$Analysis/Ranking/2015-16/ghg_intensity/For merges/ghg100_merge MasterList sbcode.dta", generate(_mergesb)
	drop if _mergesb==2
	
	order food_code food_description original_vs_additional food_desc_check ghg100_fd sb_num sb_code sb_description sb_desc_check ghg100_sb _mergeorig _mergesb
	
	gen same_origdesc = ""
		replace same_origdesc = "Y" if food_description == food_desc_check
		replace same_origdesc = "Different" if food_description != food_desc_check
	
	gen same_sbdesc = ""
		replace same_sbdesc = "Y" if sb_description == sb_desc_check
		replace same_sbdesc = "Different" if sb_description != sb_desc_check
	
	gen compare_ghg_origXsub = ""
		replace compare_ghg_origXsub = "ok" if ghg100_fd > ghg100_sb
		replace compare_ghg_origXsub = "review" if ghg100_fd <= ghg100_sb
	
	save "$Analysis/MasterLists/2015-16/AG lists/Merged_ghg100/`fname'_ghg100.dta", replace

}

**Merge with original overlap file to flag original_vs_additional

/Users/clee/Dropbox/Aim 1/Analysis/MasterLists/2015-16/AG lists/Merged_ghg100/MxDishes_Substitutes_v3_ghg100.dta 
/Users/clee/Dropbox/Aim 1/Analysis/MasterLists/2015-16/AG lists/Merged_ghg100/Protein_Substitutes_v3_ghg100.dta 
/Users/clee/Dropbox/Aim 1/Analysis/MasterLists/2015-16/AG lists/Merged_ghg100/Beverages_Substitutes_v2_ghg100.dta 
/Users/clee/Dropbox/Aim 1/Analysis/MasterLists/2015-16/AG lists/Merged_ghg100/Milk_Substitutes_v1_ghg100.dta

***Mixed Dishes
cd "$Analysis/MasterLists/2015-16/AG Lists/Merged_ghg100"

use MxDishes_Substitutes_v3_ghg100.dta, clear
merge m:1 food_code using "$Analysis/Ranking/2015-16/overlap/Version_dta/MxDishes_RankedOverlap_for Masterlist.dta", generate(_mergeflag)

replace origXadd = "add" if origXadd ==""
	
order food_code food_description food_desc_check same_origdesc original_vs_additional origXadd ghg100_fd sb_num sb_code sb_description sb_desc_check same_sbdesc ghg100_sb compare_ghg_origXsub _mergeorig _mergesb _mergeflag

export excel "MxDishes_Substitutes_v3_ghg100.xlsx", firstrow(variables) keepcellfmt replace

***Protein Foods
cd "$Analysis/MasterLists/2015-16/AG Lists/Merged_ghg100"

use Protein_Substitutes_v3_ghg100.dta, clear
merge m:1 food_code using "$Analysis/Ranking/2015-16/overlap/Version_dta/Protein_RankedOverlap_for Masterlist.dta", generate(_mergeflag)

replace origXadd = "add" if origXadd ==""
	
order food_code food_description food_desc_check same_origdesc original_vs_additional origXadd ghg100_fd sb_num sb_code sb_description sb_desc_check same_sbdesc ghg100_sb compare_ghg_origXsub _mergeorig _mergesb _mergeflag

export excel "Protein_Substitutes_v3_ghg100.xlsx", firstrow(variables) keepcellfmt replace

***Beverages
cd "$Analysis/MasterLists/2015-16/AG Lists/Merged_ghg100"

use Beverages_Substitutes_v2_ghg100.dta, clear
merge m:1 food_code using "$Analysis/Ranking/2015-16/overlap/Version_dta/Beverages_RankedOverlap_for Masterlist.dta", generate(_mergeflag)

replace origXadd = "add" if origXadd ==""
	
order food_code food_description food_desc_check same_origdesc original_vs_additional origXadd ghg100_fd sb_num sb_code sb_description sb_desc_check same_sbdesc ghg100_sb compare_ghg_origXsub _mergeorig _mergesb _mergeflag

export excel "Beverages_Substitutes_v2_ghg100.xlsx", firstrow(variables) keepcellfmt replace

***Milk
cd "$Analysis/MasterLists/2015-16/AG Lists/Merged_ghg100"

use Milk_Substitutes_v1_ghg100.dta, clear
merge m:1 food_code using "$Analysis/Ranking/2015-16/overlap/Version_dta/Milk_RankedOverlap_for Masterlist.dta", generate(_mergeflag)

replace origXadd = "add" if origXadd ==""
	
order food_code food_description food_desc_check same_origdesc original_vs_additional origXadd ghg100_fd sb_num sb_code sb_description sb_desc_check same_sbdesc ghg100_sb compare_ghg_origXsub _mergeorig _mergesb _mergeflag

export excel "Milk_Substitutes_v1_ghg100.xlsx", firstrow(variables) keepcellfmt replace



*Review manually


*Reshape from long to wide format

reshape wide sb_code sb_description, i (food_code) j(sb_num)
