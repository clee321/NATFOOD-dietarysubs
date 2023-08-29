*Drafts

*6.5 Analysis overall Step 1
*Using one file (no loop withing folder)

use "$Analysis/Substitution/2015-16/6_OrixSub_totals/Protein_Sub_dataset_high_total_by_seqn.dta", clear

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

*tabstat ``a'', stat(mean sd) save

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("Protein_sub_high") modify
putexcel A1 = ("Protein_sub_high_original")
putexcel A2 = matrix(b), names nformat(number_d2)
putexcel D2 = matrix(ci), colnames nformat(number_d2)
putexcel F2 = matrix(p), colnames

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("MxDishes_sub_high") modify
putexcel A1 = ("MxDishes_sub_high_original")
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

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("Protein_sub_high") modify
putexcel I1 = ("Protein_sub_high_substituted")
putexcel I2 = matrix(b), names nformat(number_d2)
putexcel L2 = matrix(ci), colnames nformat(number_d2)
putexcel N2 = matrix(p), colnames

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn1.xlsx", sheet ("MxDishes_sub_high") modify
putexcel I1 = ("MxDishes_sub_high_substituted")
putexcel I2 = matrix(b), names nformat(number_d2)
putexcel L2 = matrix(ci), colnames nformat(number_d2)
putexcel N2 = matrix(p), colnames

***********

*6.5 Step 2 - difference, %diff

use "$Analysis/Substitution/2015-16/6_OrixSub_totals/Protein_Sub_dataset_high_total_by_seqn.dta", clear

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

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn2.xlsx", sheet ("Protein_Sub_high") modify
putexcel Q1 = ("Protein_Sub_high_difference")
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

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn2.xlsx", sheet ("Protein_Sub_high") modify
putexcel Y1 = ("Protein_Sub_high_% difference")
putexcel Y2 = matrix(b), names nformat(number_d2)
putexcel AB2 = matrix(ci), colnames nformat(number_d2)
putexcel AD2 = matrix(p), colnames


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

putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn2.xlsx", sheet ("Protein_Sub_high") modify
putexcel AG1 = ("Protein_Sub_high_total ghg difference for one day across entire sample")
putexcel AG2 = matrix(b), names nformat(#,###)
putexcel AJ2 = matrix(ci), colnames nformat(#,###)
putexcel AL2 = matrix(p), colnames


**** 6.5 Step 2B - loop files and loop variable categories

8 ageCat  * 4 prot, mx scenarios
	
**AgeCat
	forval f=1/8 {
		display `f'
		
		//original
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_orikcal-ttl_orisele ttl_orighgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn_bydemo test.xlsx", sheet ("ageCat_`f'") modify
		putexcel A1 = ("AgeCat_`f'_original")
		putexcel C1 = ("Age_Labels 0: 0-1 | 1: 2-5 | 2: 6-11 | 3: 12-17 | 4: 18-25 | 5: 26-39 | 6: 40-49 | 7: 50-59 | 8: 60 and over")
		putexcel A2 = matrix(b), names nformat(number_d2)
		putexcel D2 = matrix(ci), colnames nformat(number_d2)
		putexcel F2 = matrix(p), colnames
		
		//substituted
		svy, subpop (if subpop==1 & ageCat==`f'): mean (ttl_subkcal-ttl_subsele ttl_subghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn_bydemo test.xlsx", sheet ("ageCat_`f'") modify
		putexcel I1 = ("AgeCat_`f'_substituted")
		putexcel I2 = matrix(b), names nformat(number_d2)
		putexcel L2 = matrix(ci), colnames nformat(number_d2)
		putexcel N2 = matrix(p), colnames
				
		//difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (diff_kcal-diff_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn_bydemo test.xlsx", sheet ("ageCat_`f'") modify
		putexcel Q1 = ("AgeCat_`f'_difference")
		putexcel Q2 = matrix(b), names nformat(number_d2)
		putexcel T2 = matrix(ci), colnames nformat(number_d2)
		putexcel V2 = matrix(p), colnames
				
		//%difference
		svy, subpop (if subpop==1 & ageCat==`f'): mean (perc_kcal-perc_ghgcons)
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn_bydemo test.xlsx", sheet ("ageCat_`f'") modify
		putexcel Y1 = ("AgeCat_`f'_%difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
		
		//total ghg difference
		svy, subpop (if subpop==1 & ageCat==`f'): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		
		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel set "$Results/2015-16/Mean_nutri_ghg/Mean_nutri_ghg_seqn_bydemo test.xlsx", sheet ("ageCat_`f'") modify
		putexcel AG1 = ("AgeCat_`f'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
				
	}
	
