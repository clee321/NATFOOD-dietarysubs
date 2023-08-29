

cd "$Analysis/Substitution/2015-16/6_OrixSub_totals"
local files: dir "$Analysis/Substitution/2015-16/6_OrixSub_totals" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local file_int = regexr("`file'","_dataset","")
	local filename = regexr("`file_int'","_total(.*).dta","")
	
	use `file', clear

	**Declare data as Survey set - Using one day dietary weight 
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	*Calculate mean + SE per sub_flag (entire sample) - table 3 and 4

	svy, subpop (if subpop==1): mean (ttl_origrams-ttl_orisele ttl_orighgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/test2.xlsx", sheet ("`filename'") modify
		putexcel A1 = ("`filename'_original")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames


	svy, subpop (if subpop==1): mean (ttl_subgrams-ttl_subsele ttl_subghgcons)
	
	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/test2.xlsx", sheet ("`filename'") modify
		putexcel I1 = ("`filename'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames


	foreach v of var ttl_ori* { 
 	*String without "ttl_ori"
     local p = substr("`v'", 8, .) 
     gen diff_`p' = ttl_sub`p' - ttl_ori`p'
	}
	*count 8,505 x 339 columns

*Regression - Paired t-test
	*foreach var of var diff* {
	*	svy: reg `var'
	*}

*Same results as regression
	svy, subpop (if subpop==1): mean (diff_grams-diff_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/test2.xlsx", sheet ("`filename'") modify
		putexcel Q1 = ("`filename'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames

******
*Calculate percentage difference for each seqn
 
	 foreach v of var diff_* { 
		*String without "diff_"
		 local p = substr("`v'", 6, .) 
		 gen perc_`p' = diff_`p'*100/ttl_ori`p'
	}

*Calculate percent change (mean of individual percent changes)
	svy, subpop (if subpop==1): mean (perc_grams-perc_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/test2.xlsx", sheet ("`filename'") modify
		putexcel Y1 = ("`filename'_% diff")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames

******
*Total ghg difference across the entire sample for one day
	svy, subpop (if subpop==1): total (diff_ghgcons)
	display %12.0g _b[diff_ghgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel set "$Results/2015-16/Mean_nutri_ghg/test2.xlsx", sheet ("`filename'") modify
		putexcel AG1 = ("`filename'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames

}
