cd "$Analysis"

******
****** ENTIRE SAMPLE

use "$Analysis/Substitution/Original and Sub dataset.dta", clear

merge m:1 seqn using "$Analysis/Substitution/Seqn with substitutions.dta", generate(_merge_subflag)

******
*Create totals per seqn
foreach var of varlist origrams-orisele orighgcons subkcal-subsele subghgcons {
	bysort seqn: egen ttl_`var' = total(`var')
}

sort seqn oriline

******
*Calculate difference between 2 rows of same seqn

 
 foreach v of var ttl_ori* { 
     local p = substr("`v'", 8, .) 
     gen diff_`p' = ttl_sub`p' - ttl_ori`p'
}

*keep if diff_ghgcons > 0

sort seqn oriline

keep if _merge_subinfo == 3

keep seqn cycle food_code drxfcsd orikcal origrams ghg100 orighgcons sub_code sub_descr subkcal subgrams subghgcons diff_ghgcons   
*there are duplicates of seqn

order seqn cycle food_code drxfcsd orikcal origrams ghg100 orighgcons sub_code sub_descr subkcal subgrams subghgcons diff_ghgcons   

export excel "Substitution/Troubleshoot_ghg greater than 0.xlsx", firstrow(variables) keepcellfmt replace

