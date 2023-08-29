	
	
		**# Mean %Difference
		svy, subpop (if subpop==1): mean (perc_HEI2015*)

		return list
		matrix a = r(table)
		matrix list a
		matrix b = a[1..2,1...]'
		matlist b
		matrix ci = a[5..6,1...]'
		matlist ci
		matrix p = a[4,1...]'
		matlist p
	
		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames
	
	
	
	**#Percent Difference per seqn


	**Mean Percent Difference
	*Calculate percent change (mean of individual percent changes)
	svy, subpop (if subpop==1 & sub_flag==1): mean (perc_grams-perc_ghgcons)

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p
	

		putexcel Y1 = ("`filename'_% difference")
		putexcel Y2 = matrix(b), names nformat(number_d2)
		putexcel AB2 = matrix(ci), colnames nformat(number_d2)
		putexcel AD2 = matrix(p), colnames


	**#Total ghg difference across the entire sample for one day
	**Original
	svy, subpop (if subpop==1 & sub_flag==1): total (ttl_orighgcons)
	display %12.0g _b[ttl_orighgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel AG1 = ("`filename'_total ghg difference for one day across entire sample")
		putexcel AG2 = matrix(b), names nformat(#,###)
		putexcel AJ2 = matrix(ci), colnames nformat(#,###)
		putexcel AL2 = matrix(p), colnames
		
	**Substituted
	svy, subpop (if subpop==1 & sub_flag==1): total (ttl_subghgcons)
	display %12.0g _b[ttl_subghgcons]

	return list
	matrix a = r(table)
	matrix list a
	matrix b = a[1..2,1...]'
	matlist b
	matrix ci = a[5..6,1...]'
	matlist ci
	matrix p = a[4,1...]'
	matlist p

		putexcel AG4 = matrix(b), rownames nformat(#,###)
		putexcel AJ4 = matrix(ci), nformat(#,###)
		putexcel AL4 = matrix(p)


	**Difference
	svy, subpop (if subpop==1 & sub_flag==1): total (diff_ghgcons)
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

		putexcel AG5 = matrix(b), rownames nformat(#,###)
		putexcel AJ5 = matrix(ci), nformat(#,###)
		putexcel AL5 = matrix(p)

		
	**#Percentage difference overall
	*Add formula	
 
		putexcel AG6 = ("ghg_% diff")
		putexcel AH6 = formula(AH5*100/AH3)
		
		
	**#N count	
	count if sub_flag==1
		scalar sb = r(N)
	count if subpop==1
		scalar tt = r(N)
		
		putexcel AG8 = "Subflag N"
		putexcel AH8=sb
		putexcel AG9 = "Subpop N"
		putexcel AH9=tt
		putexcel AI8 = sb/tt, nformat(percent)
		