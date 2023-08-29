*Clean incomplete food descriptions in Supplemental Table

*List of food with incomplete description (following order from suppl. tables - there are duplicate codes)
import excel "$Results/2015-16/Clean descriptions/Food code_incomplete description.xlsx", firstrow clear
save "$Results/2015-16/Clean descriptions/Food code_incomplete description.dta", replace

*Open Rrference doc with full descriptions
import excel "$Analysis/MasterLists/2015-16/Reference docs/2015-2016 FNDDS At A Glance - Foods and Beverages.xlsx", cellrange (A2) firstrow clear

*Merge Reference doc with List of incompl. descriptions
merge 1:m Foodcode using "$Results/2015-16/Clean descriptions/Food code_incomplete description.dta"

keep if _merge==3

sort Order

order Order

export excel "$Results/2015-16/Clean descriptions/Food code_complete description merged.xlsx", firstrow(variables) keepcellfmt replace
