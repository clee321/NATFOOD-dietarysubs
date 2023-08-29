	use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/6_OrixSub_totals/Protein_Sub_dataset_low_total_by_seqn.dta", clear
	
	//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	foreach v of var ttl_ori* { 
 	*String without "ttl_ori"
     local p = substr("`v'", 8, .) 
     gen diff_`p' = ttl_sub`p' - ttl_ori`p'
	}
	*count 8,505 x 339 columns

*Regression - Paired t-test
	foreach var of var diff* {
		svy: reg `var'
	}

*Same results as regression
	**#Difference
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

		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("test") modify
		putexcel Q1 = ("test_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
		
		putexcel B3 = 500
		putexcel B4 = 700

******
*Calculate percentage difference for each seqn
*Add formula
 
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("test") modify
		putexcel Y1 = ("test_% diff")
		
		forvalues i=3/52 {
			putexcel Y`i' = formula(R`i'*100/B`i')
		}
		
///
		

	
//// by demo - % difference

	
	use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc/Milk_Sub_low_ttl-diff-perc.dta", clear
	
	local filename = regexr("Milk_Sub_low_ttl-diff-perc.dta","_ttl(.*).dta","")
	
		**#AgeCat
	forval f=1/8 {
		display `f'
		
			putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo1.xlsx", sheet ("ageCat_`f'") modify
			
			putexcel X1 = ("AgeCat_`f'% diff")
			forvalues i=3/52 {
			putexcel X`i' = formula(R`i'*100/B`i')
		}
	
	}


//// loop

cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
local files: dir "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc" files "*.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name
	local filename = regexr("`file'","_ttl(.*).dta","")
	
	use `file', clear
	
		//important - declare survey set every time when opening new file
		svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
	
	**#AgeCat
	forval f=1/8 {
		display `f'
				
		//%difference

			putexcel set "$Results/2015-16/Mean_nutri_ghg/`filename'_mean_nutri_ghg_seqn_bydemo1.xlsx", sheet ("ageCat_`f'") modify
			
			putexcel X1 = ("AgeCat_`f'% diff")
			putexcel X1 = ("`filename'_AgeCat_`f'% diff")
			putexcel X3 = formula(R3*100/B3)

	}
}
