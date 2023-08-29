*Test Protein_Sub_high_AgeCat_4

********
*Using DATASET 6 - multiple entries for same seqn

cd "$Analysis/Substitution/2015-16/6_OrixSub_totals"
use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/6_OrixSub_totals/Protein_Sub_dataset_high_total_by_seqn.dta", clear
*121,481 rows

	**Declare data as Survey set - Using one day dietary weight 
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

	*Calculate mean + SE per sub_flag (entire sample) - table 3 and 4

//original
	svy, subpop (if subpop==1): mean (ttl_origrams-ttl_orisugr)
	*orisele ttl_orighgcons)

Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
ttl_origrams |   3190.759   53.99258      3075.677    3305.842
 ttl_orikcal |   2046.395   18.99617      2005.906    2086.885
 ttl_oriprot |   78.70252   1.119148      76.31711    81.08793
 ttl_oricarb |   243.1809   2.073003      238.7624    247.5994
 ttl_orisugr |   106.3446   1.572009      102.9939    109.6953
--------------------------------------------------------------

	svy, subpop (if subpop==1 & ageCat==4): mean (ttl_origrams-ttl_orisugr)
	*orisele ttl_orighgcons)
	

Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
ttl_origrams |   3268.432   112.9498      3027.685    3509.179
 ttl_orikcal |    2211.53   67.39643      2067.878    2355.182
 ttl_oriprot |   87.11732   4.630123      77.24845     96.9862
 ttl_oricarb |   260.1966   8.118918      242.8915    277.5016
 ttl_orisugr |   113.0118   4.275036      103.8998    122.1239
--------------------------------------------------------------

//substituted

	svy, subpop (if subpop==1): mean (ttl_subgrams-ttl_subsugr)

Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
ttl_subgrams |   3198.536   53.96638       3083.51    3313.563
 ttl_subkcal |   2046.395   18.99617      2005.906    2086.885
 ttl_subprot |   80.14052   1.177091      77.63161    82.64943
 ttl_subcarb |   243.3739   2.074571      238.9521    247.7958
 ttl_subsugr |   106.3637   1.573787      103.0092    109.7181
--------------------------------------------------------------


	svy, subpop (if subpop==1 & ageCat==4): mean (ttl_subgrams-ttl_subsugr)
	*subsele ttl_subghgcons)
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
ttl_subgrams |   3275.171   113.2535      3033.776    3516.565
 ttl_subkcal |    2211.53   67.39643      2067.878    2355.182
 ttl_subprot |   88.39747   4.627859      78.53342    98.26152
 ttl_subcarb |   260.4892   8.084247       243.258    277.7204
 ttl_subsugr |   113.0214    4.27524       103.909    122.1339
--------------------------------------------------------------


********
*A) STEP 2: Calculate difference between substituted and original totals for the same seqn, percentage difference by seqn, total ghg difference across the sample
********

	foreach v of var ttl_ori* { 
 	*String without "ttl_ori"
     local p = substr("`v'", 8, .) 
     gen diff_`p' = ttl_sub`p' - ttl_ori`p'
	}


*Same results as regression

	svy, subpop (if subpop==1): mean (diff_grams-diff_sugr)
	
Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  diff_grams |   7.776969   .9666729      5.716555    9.837384
   diff_kcal |          0  (omitted)
   diff_prot |   1.438003   .1874351      1.038495    1.837512
   diff_carb |   .1930495   .0351002      .1182352    .2678637
   diff_sugr |   .0190743   .0034345      .0117538    .0263948
--------------------------------------------------------------


	
	svy, subpop (if subpop==1 & ageCat==4): mean (diff_grams-diff_sugr)
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  diff_grams |   6.738348   1.857025      2.780194     10.6965
   diff_kcal |          0  (omitted)
   diff_prot |   1.280145   .4265784      .3709143    2.189375
   diff_carb |   .2926251   .1569979      -.042008    .6272581
   diff_sugr |    .009608   .0095502     -.0107476    .0299637
--------------------------------------------------------------

	svy, subpop (if subpop==1 & ageCat==5): mean (diff_grams-diff_sugr)
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =        1,178
                                Subpop. size    = 58,022,053.8
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  diff_grams |   10.17714   2.155387      5.583039    14.77124
   diff_kcal |          0  (omitted)
   diff_prot |   1.723501   .3683472      .9383878    2.508615
   diff_carb |   .2802962   .1369567     -.0116201    .5722125
   diff_sugr |   .0000246   .0039076     -.0083041    .0083534
--------------------------------------------------------------

	
******
*Calculate percentage difference for each seqn
 
	 foreach v of var diff_* { 
		*String without "diff_"
		 local p = substr("`v'", 6, .) 
		 gen perc_`p' = diff_`p'*100/ttl_ori`p'
	}

*Calculate percent change (mean of individual percent changes)


**different n and coefficients
	svy, subpop (if subpop==1): mean (perc_grams-perc_sugr)

Number of strata = 15            Number of obs   =       8,504
Number of PSUs   = 30            Population size = 316,462,192
                                 Subpop. no. obs =       7,752
                                 Subpop. size    = 302,658,182
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  perc_grams |    .273036   .0373221      .1934858    .3525862
   perc_kcal |          0  (omitted)
   perc_prot |   1.744795   .2034198      1.311216    2.178374
   perc_carb |   .1130385   .0219987      .0661493    .1599277
   perc_sugr |   .0224085   .0076715       .006057      .03876
--------------------------------------------------------------

	svy, subpop (if subpop==1): mean (perc_grams-perc_ghgcons)
	
Number of strata = 15             Number of obs   =      1,220
Number of PSUs   = 30             Population size = 38,841,113
                                  Subpop. no. obs =        468
                                  Subpop. size    = 25,037,103
                                  Design df       =         15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  perc_grams |   .2413701   .0748857      .0817551    .4009852
   perc_kcal |          0  (omitted)
   perc_prot |   1.593137   .7471821      .0005563    3.185718
   perc_carb |    .129941   .0844939     -.0501535    .3100356
   perc_sugr |   .0265533   .0159111     -.0073604    .0604671
   perc_fibe |  -.0127189   .0298304     -.0763008    .0508631
...

	svy, subpop (if subpop==1 & ageCat==4): mean (perc_grams-perc_sugr)
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  perc_grams |   .2218735   .0540139      .1067457    .3370013
   perc_kcal |          0  (omitted)
   perc_prot |   1.348793   .3823244      .5338874    2.163698
   perc_carb |   .2042156    .108719     -.0275135    .4359446
   perc_sugr |   .0081003    .013591     -.0208683    .0370689
--------------------------------------------------------------


******
*Total ghg difference across the entire sample for one day
	svy, subpop (if subpop==1 & ageCat==4): total (diff_ghgcons)
	display %12.0g _b[diff_ghgcons]
-14,829,381.22

	svy, subpop (if subpop==1): total (diff_ghgcons)
	display %12.0g _b[diff_ghgcons]
-186,684,183.4
	
********
********
********
*Using DATASET 7 - after seqn duplicates were dropped

cd "$Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc"
use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/7_OrixSub_ttl_diff_perc/Protein_Sub_high_ttl-diff-perc.dta", clear

**Important!
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

		//original
		svy, subpop (if subpop==1 & ageCat==4): mean (ttl_orikcal-ttl_orisugr)
		*sele ttl_orighgcons)

	**WITH SVYSET code - same result as dataset 6
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
 ttl_orikcal |    2211.53   67.39643      2067.878    2355.182
 ttl_oriprot |   87.11732   4.630123      77.24845     96.9862
 ttl_oricarb |   260.1966   8.118918      242.8915    277.5016
 ttl_orisugr |   113.0118   4.275036      103.8998    122.1239
--------------------------------------------------------------

	**WITH SVYSET code from dataset 6 - may be wrong (*excel version*)
	**Need to export data to excel again
	
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  279,650,535
                                Subpop. no. obs =          682
                                Subpop. size    = 26,003,015.4
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
 ttl_orikcal |   2222.325   63.25882      2087.492    2357.158
 ttl_oriprot |   85.47022   3.281003      78.47692    92.46351
 ttl_oricarb |   264.6973   8.203259      247.2125    282.1822
 ttl_orisugr |   115.3739   4.367171      106.0655    124.6823
--------------------------------------------------------------

		
		svy, subpop (if subpop==1): mean (ttl_origrams-ttl_orisugr)
		*OK
		*sele ttl_orighgcons)
		
		
Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
ttl_origrams |   3190.759   53.99258      3075.677    3305.842
 ttl_orikcal |   2046.395   18.99617      2005.906    2086.885
 ttl_oriprot |   78.70252   1.119148      76.31711    81.08793
 ttl_oricarb |   243.1809   2.073003      238.7624    247.5994
 ttl_orisugr |   106.3446   1.572009      102.9939    109.6953
--------------------------------------------------------------

		
		//substituted
		svy, subpop (if subpop==1 & ageCat==4): mean (ttl_subkcal-ttl_subsugr)
		*sele ttl_subghgcons)

Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
 ttl_subkcal |    2211.53   67.39643      2067.878    2355.182
 ttl_subprot |   88.39747   4.627859      78.53342    98.26152
 ttl_subcarb |   260.4892   8.084247       243.258    277.7204
 ttl_subsugr |   113.0214    4.27524       103.909    122.1339
--------------------------------------------------------------


		
		svy, subpop (if subpop==1): mean (ttl_subkcal-ttl_subsugr)
		*sele ttl_subghgcons)
		
Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
 ttl_subkcal |   2046.395   18.99617      2005.906    2086.885
 ttl_subprot |   80.14052   1.177091      77.63161    82.64943
 ttl_subcarb |   243.3739   2.074571      238.9521    247.7958
 ttl_subsugr |   106.3637   1.573787      103.0092    109.7181
--------------------------------------------------------------

			
			
		//difference
		svy, subpop (if subpop==1 & ageCat==4): mean (diff_kcal-diff_sugr)
		

*With new survey set

Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
   diff_kcal |          0  (omitted)
   diff_prot |   1.280145   .4265784      .3709143    2.189375
   diff_carb |   .2926251   .1569979      -.042008    .6272581
   diff_sugr |    .009608   .0095502     -.0107476    .0299637
--------------------------------------------------------------

		
*Without survey set (or survey set from dataset 6) - wrong/excel

Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  279,650,535
                                Subpop. no. obs =          682
                                Subpop. size    = 26,003,015.4
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
   diff_kcal |          0  (omitted)
   diff_prot |   1.158352   .3842997      .3392368    1.977468
   diff_carb |   .1715433   .0981968     -.0377583    .3808449
   diff_sugr |   .0080076   .0094584     -.0121524    .0281676
--------------------------------------------------------------

		svy, subpop (if subpop==1): mean (diff_kcal-diff_sugr)
		
Number of strata = 15            Number of obs   =       8,505
Number of PSUs   = 30            Population size = 316,468,266
                                 Subpop. no. obs =       7,753
                                 Subpop. size    = 302,664,256
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
   diff_kcal |          0  (omitted)
   diff_prot |   1.438003   .1874351      1.038495    1.837512
   diff_carb |   .1930495   .0351002      .1182352    .2678637
   diff_sugr |   .0190743   .0034345      .0117538    .0263948
--------------------------------------------------------------

		
		//%difference
		svy, subpop (if subpop==1 & ageCat==4): mean (perc_kcal-perc_sugr)
Number of strata = 15           Number of obs   =        8,505
Number of PSUs   = 30           Population size =  316,468,266
                                Subpop. no. obs =          682
                                Subpop. size    = 29,720,806.5
                                Design df       =           15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
   perc_kcal |          0  (omitted)
   perc_prot |   1.348793   .3823244      .5338874    2.163698
   perc_carb |   .2042156    .108719     -.0275135    .4359446
   perc_sugr |   .0081003    .013591     -.0208683    .0370689
--------------------------------------------------------------

*different coefficients with different number of variables

		svy, subpop (if subpop==1): mean (perc_kcal-perc_sugr)
		
Number of strata = 15            Number of obs   =       8,504
Number of PSUs   = 30            Population size = 316,462,192
                                 Subpop. no. obs =       7,752
                                 Subpop. size    = 302,658,182
                                 Design df       =          15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
   perc_kcal |          0  (omitted)
   perc_prot |   1.744795   .2034198      1.311216    2.178374
   perc_carb |   .1130385   .0219987      .0661493    .1599277
   perc_sugr |   .0224085   .0076715       .006057      .03876
--------------------------------------------------------------


	svy, subpop (if subpop==1): mean (perc_grams-perc_ghgcons)
	
Number of strata = 15             Number of obs   =      1,220
Number of PSUs   = 30             Population size = 38,841,113
                                  Subpop. no. obs =        468
                                  Subpop. size    = 25,037,103
                                  Design df       =         15

--------------------------------------------------------------
             |             Linearized
             |       Mean   std. err.     [95% conf. interval]
-------------+------------------------------------------------
  perc_grams |   .2413701   .0748857      .0817551    .4009852
   perc_kcal |          0  (omitted)
   perc_prot |   1.593137   .7471821      .0005563    3.185718
   perc_carb |    .129941   .0844939     -.0501535    .3100356
   perc_sugr |   .0265533   .0159111     -.0073604    .0604671
...
		
		//total ghg difference
		svy, subpop (if subpop==1 & ageCat==4): total (diff_ghgcons)
		di %12.0g _b[diff_ghgcons]
		-14,829,381.22
