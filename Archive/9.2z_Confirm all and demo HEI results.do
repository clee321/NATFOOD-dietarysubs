**Confirm HEI results without loop

use "$Analysis/HEI/HEI_total_score_per_seqn_allpop_Protein_high.dta", clear

**#By all

	//Declare survey set every time when opening new file
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)
		
	svy, subpop (if subpop==1): mean (oHEI2015*)

	svy, subpop (if subpop==1): mean (sHEI2015*)
	
	svy, subpop (if subpop==1): mean (diff_HEI2015*)
	
Survey: Mean estimation

Number of strata = 15                             Number of obs   =       8,505
Number of PSUs   = 30                             Population size = 316,468,266
                                                  Subpop. no. obs =       7,753
                                                  Subpop. size    = 302,664,256
                                                  Design df       =          15

-------------------------------------------------------------------------------
                              |             Linearized
                              |       Mean   std. err.     [95% conf. interval]
------------------------------+------------------------------------------------
      diff_HEI2015C1_TOTALVEG |   .0000209   .0000139     -8.80e-06    .0000506
diff_HEI2015C2_GREEN_AND_BEAN |          0  (omitted)
    diff_HEI2015C3_TOTALFRUIT |          0  (omitted)
    diff_HEI2015C4_WHOLEFRUIT |          0  (omitted)
    diff_HEI2015C5_WHOLEGRAIN |  -.0062265   .0011597     -.0086982   -.0037547
    diff_HEI2015C6_TOTALDAIRY |  -.0010577   .0005972     -.0023306    .0002152
       diff_HEI2015C7_TOTPROT |   .0243809   .0043344      .0151424    .0336195
 diff_HEI2015C8_SEAPLANT_PROT |   .0055096    .002883     -.0006355    .0116547
     diff_HEI2015C9_FATTYACID |   .1304632   .0092372      .1107746    .1501518
       diff_HEI2015C10_SODIUM |  -.1275591   .0135933     -.1565326   -.0985856
 diff_HEI2015C11_REFINEDGRAIN |    .006674   .0020056      .0023993    .0109488
         diff_HEI2015C12_SFAT |   .1898752   .0168263      .1540108    .2257396
       diff_HEI2015C13_ADDSUG |  -.0022505   .0004173       -.00314   -.0013609
     diff_HEI2015_TOTAL_SCORE |   .2198301   .0203262      .1765058    .2631544
-------------------------------------------------------------------------------


	
	
**#By demo groups

	**#AgeCat

	svy, subpop (if subpop==1 & ageCat==4): mean (oHEI2015*)
	
	svy, subpop (if subpop==1 & ageCat==4): mean (sHEI2015*)
	
	svy, subpop (if subpop==1 & ageCat==4): mean (diff_HEI2015*)


Survey: Mean estimation

Number of strata = 15                            Number of obs   =        8,505
Number of PSUs   = 30                            Population size =  316,468,266
                                                 Subpop. no. obs =          682
                                                 Subpop. size    = 29,720,806.5
                                                 Design df       =           15

-------------------------------------------------------------------------------
                              |             Linearized
                              |       Mean   std. err.     [95% conf. interval]
------------------------------+------------------------------------------------
      diff_HEI2015C1_TOTALVEG |          0  (omitted)
diff_HEI2015C2_GREEN_AND_BEAN |          0  (omitted)
    diff_HEI2015C3_TOTALFRUIT |          0  (omitted)
    diff_HEI2015C4_WHOLEFRUIT |          0  (omitted)
    diff_HEI2015C5_WHOLEGRAIN |  -.0052943   .0028009     -.0112642    .0006757
    diff_HEI2015C6_TOTALDAIRY |   .0002244    .000185       -.00017    .0006189
       diff_HEI2015C7_TOTPROT |     .00345   .0048929     -.0069788    .0138789
 diff_HEI2015C8_SEAPLANT_PROT |   .0020343   .0020344     -.0023019    .0063704
     diff_HEI2015C9_FATTYACID |   .1159122   .0302717      .0513895    .1804349
       diff_HEI2015C10_SODIUM |  -.1005656   .0325217     -.1698839   -.0312473
 diff_HEI2015C11_REFINEDGRAIN |  -.0020611   .0061496     -.0151688    .0110465
         diff_HEI2015C12_SFAT |   .1704131    .036968      .0916177    .2492084
       diff_HEI2015C13_ADDSUG |  -.0011544   .0005763     -.0023828     .000074
     diff_HEI2015_TOTAL_SCORE |   .1829586   .0575685      .0602542     .305663
-------------------------------------------------------------------------------

	svy, subpop (if subpop==1 & eduCat==3): mean (diff_HEI2015*)

	
Survey: Mean estimation

Number of strata = 15                            Number of obs   =        8,505
Number of PSUs   = 30                            Population size =  316,468,266
                                                 Subpop. no. obs =        2,539
                                                 Subpop. size    = 99,943,890.4
                                                 Design df       =           15

-------------------------------------------------------------------------------
                              |             Linearized
                              |       Mean   std. err.     [95% conf. interval]
------------------------------+------------------------------------------------
      diff_HEI2015C1_TOTALVEG |   .0000406   .0000408     -.0000464    .0001277
diff_HEI2015C2_GREEN_AND_BEAN |          0  (omitted)
    diff_HEI2015C3_TOTALFRUIT |          0  (omitted)
    diff_HEI2015C4_WHOLEFRUIT |          0  (omitted)
    diff_HEI2015C5_WHOLEGRAIN |   -.010935   .0031906     -.0177357   -.0041343
    diff_HEI2015C6_TOTALDAIRY |    -.00167   .0014652      -.004793     .001453
       diff_HEI2015C7_TOTPROT |   .0316682   .0036119      .0239697    .0393667
 diff_HEI2015C8_SEAPLANT_PROT |   .0096802   .0068455     -.0049108    .0242711
     diff_HEI2015C9_FATTYACID |   .1362807   .0164524      .1012133    .1713482
       diff_HEI2015C10_SODIUM |  -.1357842   .0225087     -.1837603    -.087808
 diff_HEI2015C11_REFINEDGRAIN |   .0142274   .0044266      .0047924    .0236624
         diff_HEI2015C12_SFAT |   .2063464   .0302701      .1418273    .2708655
       diff_HEI2015C13_ADDSUG |   -.002713   .0007483     -.0043079   -.0011181
     diff_HEI2015_TOTAL_SCORE |   .2471414   .0298877      .1834372    .3108456
-------------------------------------------------------------------------------


*%difference

svy, subpop (if subpop==1): total (diff_*)
display %12.0g _b[diff_HEI2015_TOTAL_SCORE]
* 66534720.91

svy, subpop (if subpop==1): total (oHEI2015*)
display %24.0g _b[oHEI2015_TOTAL_SCORE]
* 15237107898.26098251

display 66534720.91*100/15237107898.26098251
* 0.4366624



use "$Analysis/HEI/HEI_total_score_per_seqn_allpop_MxDishes_high.dta", clear

	//Declare survey set every time when opening new file
	svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

**#By demo groups

	**#edu
	svy, subpop (if subpop==1 & eduCat==4): mean (oHEI2015*)
	
	svy, subpop (if subpop==1 & eduCat==4): mean (sHEI2015*)
	
	svy, subpop (if subpop==1 & eduCat==4): mean (diff_HEI2015*)
