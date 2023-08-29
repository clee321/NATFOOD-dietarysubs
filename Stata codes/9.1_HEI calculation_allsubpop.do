*HEI Scores Calculation - Original and Substituted dataset Loop

*Step 1: Merge NHANES, DEMO + FPED - use NHANES dataset with allpop (not filtered by subpop)
*Step 2: Multiply all 37 HEI components by grams - create variables DR1T_*
*Step 3: Aggregate HEI components by SEQN and keep one row per SEQN
*Step 4: Create additional required variables: FWHOLEFRT, MONOPOLY, VTOTALLEG, VDRKGRLEG, PFALLPROTLEG and PFSEAPLANTLEG
**Export intermediate dataset
*Step 5: HEI Macro - calculate density and scores


********
**#Step 1: Merge NHANES, DEMO + FPED

/////Ori) 

cd "$Analysis/Substitution/2015-16/5_OrixSub_dataset"
local files: dir "$Analysis/Substitution/2015-16/5_OrixSub_dataset" files "*origxsub.dta"
foreach file in `files'{
	dir `file'
	
	*Substring used later to save the file name - two steps because have to keep some of the middle words
	local file_int = regexr("`file'","_Sub_dataset","")
	local filename = regexr("`file_int'","_orig(.*).dta","")
	
	use `file', clear

	merge m:1 food_code using "$Data/FPED/FPED_1516.dta", generate(_merge_FPED)

	*tab DESCRIPTION if _merge_FPED==2 
	*Probably foods not consumed by NHANES participants
	drop if _merge_FPED==2

	/////Sub)

	merge m:1 sub_code using "$Data/FPED/FPED_1516_sub.dta", generate(_merge_FPED_sub)

	drop if _merge_FPED_sub==2


********
**#Step 2: Multiply all 37 HEI components by grams - create variables DR1T_*
*FPED: HEI component per 100g (see FPED user guide pdf) x Xg of food consumed / 100g

/////Ori) 

*Loop multiplying HEI components with grams
foreach v0 of varlist F_* V_* G_* PF_* D_* OILS SOLID_FATS ADD_SUGARS A_DRINKS{
     local v = substr("`v0'",1,.)
	 gen DR1T_ori_`v' = `v'*origrams/100
 }

mdesc origrams
tab drxfcsd if origrams==.
tab drxfcsd if DR1T_ori_F_CITMLB==.



/////Sub)

*Loop multiplying HEI components with grams
foreach v0 of varlist sub_F_* sub_V_* sub_G_* sub_PF_* sub_D_* sub_OILS sub_SOLID_FATS sub_ADD_SUGARS sub_A_DRINKS{
     local v = substr("`v0'",1,.)
	 gen DR1T_`v0' = `v0'*subgrams/100
 }

mdesc subgrams
tab sub_descr if subgrams==.
tab sub_descr if DR1T_sub_F_CITMLB==.



********
**#Step 3: Aggregate HEI components by SEQN and keep one row per SEQN

/////Ori) 

*Loop SUM of HEI components by SEQN
foreach v1 of varlist DR1T_ori_* orimfat oripfat orisfat orikcal orisodi{
     local v = substr("`v1'",1,.)
	 bysort seqn: egen T_`v' = total(`v')
 }

rename T_orikcal kcal


/////Sub) 

*Loop SUM of HEI components by SEQN
foreach v2 of varlist DR1T_sub_* submfat subpfat subsfat subkcal subsodi{
     local v = substr("`v2'",1,.)
	 bysort seqn: egen T_`v' = total(`v')
 }

*Drop duplicates keeping one row per seqn
///Drop seqn after second aggregation
duplicates drop seqn, force
*count rows 8,505

rename T_subkcal skcal


********
**#Step 4: Create additional required variables: FWHOLEFRT, MONOPOLY, VTOTALLEG, VDRKGRLEG, PFALLPROTLEG and PFSEAPLANTLEG */

/////Ori)

*All whole fruits
  gen oFWHOLEFRT = T_DR1T_ori_F_CITMLB + T_DR1T_ori_F_OTHER

*Mono and Polyunsaturated fats
  gen oMONOPOLY = T_orimfat + T_oripfat

*VTOTALLEG sums together all vegetables and legumes
  gen oVTOTALLEG = T_DR1T_ori_V_TOTAL + T_DR1T_ori_V_LEGUMES
  
*VDRKGRLEG sums together dark green vegetables and legumes 
  gen oVDRKGRLEG = T_DR1T_ori_V_DRKGR + T_DR1T_ori_V_LEGUMES

*PFALLPROTLEG sums together all animal and plant proteins, including meat, poultry, fish, eggs, nuts, seeds, soy, and legumes 
  gen oPFALLPROTLEG = T_DR1T_ori_PF_MPS_TOTAL + T_DR1T_ori_PF_EGGS + T_DR1T_ori_PF_NUTSDS + T_DR1T_ori_PF_SOY + T_DR1T_ori_PF_LEGUMES
 
*PFSEAPLANTLEG sums together all fish and plant proteins, including fish, nuts, seeds, soy, and legumes
  gen oPFSEAPLANTLEG = T_DR1T_ori_PF_SEAFD_HI + T_DR1T_ori_PF_SEAFD_LOW + T_DR1T_ori_PF_NUTSDS + T_DR1T_ori_PF_SOY + T_DR1T_ori_PF_LEGUMES
  
  
/////Sub)
 
*All whole fruits
  gen sFWHOLEFRT = T_DR1T_sub_F_CITMLB + T_DR1T_sub_F_OTHER

*Mono and Polyunsaturated fats
  gen sMONOPOLY = T_submfat + T_subpfat

*VTOTALLEG sums together all vegetables and legumes
  gen sVTOTALLEG = T_DR1T_sub_V_TOTAL + T_DR1T_sub_V_LEGUMES
  
*VDRKGRLEG sums together dark green vegetables and legumes 
  gen sVDRKGRLEG = T_DR1T_sub_V_DRKGR + T_DR1T_sub_V_LEGUMES

*PFALLPROTLEG sums together all animal and plant proteins, including meat, poultry, fish, eggs, nuts, seeds, soy, and legumes 
  gen sPFALLPROTLEG = T_DR1T_sub_PF_MPS_TOTAL + T_DR1T_sub_PF_EGGS + T_DR1T_sub_PF_NUTSDS + T_DR1T_sub_PF_SOY + T_DR1T_sub_PF_LEGUMES
 
*PFSEAPLANTLEG sums together all fish and plant proteins, including fish, nuts, seeds, soy, and legumes
  gen sPFSEAPLANTLEG = T_DR1T_sub_PF_SEAFD_HI + T_DR1T_sub_PF_SEAFD_LOW + T_DR1T_sub_PF_NUTSDS + T_DR1T_sub_PF_SOY + T_DR1T_sub_PF_LEGUMES

  
save "$Analysis/HEI/Intermediate/NHANES_DEMO_GHG_FPED_for_HEI_calc_allsubpop_`filename'.dta", replace
		
}
  
********

cd "$Analysis/HEI/Intermediate"
local files: dir "$Analysis/HEI/Intermediate" files "*calc_allsubpop_*.dta"

foreach file in `files'{
	dir `file'

	
	*Substring used later to save the file name - two steps because have to keep some of the middle words
	local filename = regexr("`file'","NHANES_DEMO_GHG_FPED_for_HEI_calc_allsubpop_","")
	
	use `file', clear
	

**#Step 5: HEI Macro - calculate density and scores
*Standard for max or min per 1,000 kcal

/////Ori)

**** Total Veg

**Density
gen oVEGDEN = .
	replace oVEGDEN= oVTOTALLEG/(kcal/1000) if kcal>0
	replace oVEGDEN= 0 if kcal== 0
	
*tab seqn if kcal==0  		46 seqns with kcal==0
*tab seqn if VEGDEN==0		677 seqns

**Scoring
gen ozHEI2015C1_TOTALVEG=5*(oVEGDEN/1.1) 
gen oHEI2015C1_TOTALVEG = ozHEI2015C1_TOTALVEG
	replace oHEI2015C1_TOTALVEG=5 if ozHEI2015C1_TOTALVEG !=. & ozHEI2015C1_TOTALVEG > 5

**** Green & Beans

gen oGRBNDEN = .
	replace oGRBNDEN= oVDRKGRLEG/(kcal/1000) if kcal>0
	replace oGRBNDEN= 0 if kcal== 0

gen ozHEI2015C2_GREEN_AND_BEAN=5*(oGRBNDEN/0.2) 
gen oHEI2015C2_GREEN_AND_BEAN = ozHEI2015C2_GREEN_AND_BEAN
	replace oHEI2015C2_GREEN_AND_BEAN=5 if ozHEI2015C2_GREEN_AND_BEAN !=. & ozHEI2015C2_GREEN_AND_BEAN > 5

**** Total Fruits

gen oFRTDEN = .
	replace oFRTDEN= T_DR1T_ori_F_TOTAL/(kcal/1000) if kcal>0
	replace oFRTDEN= 0 if kcal== 0

gen ozHEI2015C3_TOTALFRUIT=5*(oFRTDEN/0.8) 
gen oHEI2015C3_TOTALFRUIT = ozHEI2015C3_TOTALFRUIT
	replace oHEI2015C3_TOTALFRUIT=5 if ozHEI2015C3_TOTALFRUIT !=. & ozHEI2015C3_TOTALFRUIT > 5
	
**** Whole Fruits

gen oWHFRDEN = .
	replace oWHFRDEN= oFWHOLEFRT/(kcal/1000) if kcal>0
	replace oWHFRDEN= 0 if kcal== 0

gen ozHEI2015C4_WHOLEFRUIT=5*(oWHFRDEN/0.4) 
gen oHEI2015C4_WHOLEFRUIT = ozHEI2015C4_WHOLEFRUIT
	replace oHEI2015C4_WHOLEFRUIT=5 if ozHEI2015C4_WHOLEFRUIT !=. & ozHEI2015C4_WHOLEFRUIT > 5

**** Whole Grains

gen oWGRNDEN = .
	replace oWGRNDEN= T_DR1T_ori_G_WHOLE/(kcal/1000) if kcal>0
	replace oWGRNDEN= 0 if kcal== 0

gen ozHEI2015C5_WHOLEGRAIN=10*(oWGRNDEN/1.5) 
gen oHEI2015C5_WHOLEGRAIN = ozHEI2015C5_WHOLEGRAIN
	replace oHEI2015C5_WHOLEGRAIN=10 if ozHEI2015C5_WHOLEGRAIN !=. & ozHEI2015C5_WHOLEGRAIN > 10

**** Dairy

gen oDAIRYDEN = .
	replace oDAIRYDEN= T_DR1T_ori_D_TOTAL/(kcal/1000) if kcal>0
	replace oDAIRYDEN= 0 if kcal== 0

gen ozHEI2015C6_TOTALDAIRY=10*(oDAIRYDEN/1.3) 
gen oHEI2015C6_TOTALDAIRY = ozHEI2015C6_TOTALDAIRY
	replace oHEI2015C6_TOTALDAIRY=10 if ozHEI2015C6_TOTALDAIRY !=. & ozHEI2015C6_TOTALDAIRY > 10

**** Total Protein

gen oPROTDEN = .
	replace oPROTDEN= oPFALLPROTLEG/(kcal/1000) if kcal>0
	replace oPROTDEN= 0 if kcal== 0

gen ozHEI2015C7_TOTPROT=5*(oPROTDEN/2.5) 
gen oHEI2015C7_TOTPROT = ozHEI2015C7_TOTPROT
	replace oHEI2015C7_TOTPROT=5 if ozHEI2015C7_TOTPROT !=. & ozHEI2015C7_TOTPROT > 5
	
**** Seafood and Plant Proteins

gen oSEAPLDEN = .
	replace oSEAPLDEN= oPFSEAPLANTLEG/(kcal/1000) if kcal>0
	replace oSEAPLDEN= 0 if kcal== 0

gen ozHEI2015C8_SEAPLANT_PROT=5*(oSEAPLDEN/0.8) 
gen oHEI2015C8_SEAPLANT_PROT = ozHEI2015C8_SEAPLANT_PROT
	replace oHEI2015C8_SEAPLANT_PROT=5 if ozHEI2015C8_SEAPLANT_PROT !=. & ozHEI2015C8_SEAPLANT_PROT > 5

**** Fatty Acids

gen oFARATIO = .
	replace oFARATIO= oMONOPOLY/T_orisfat if T_orisfat>0
	replace oFARATIO= 0 if T_orisfat== 0

gen oHEI2015C9_FATTYACID = .
	replace oHEI2015C9_FATTYACID = 10 if (T_orisfat == 0) & (oMONOPOLY == 0)
	*make sure the command below does not assign 10 to missing FARATIO values such as human milk // there are no missing values though
	replace oHEI2015C9_FATTYACID=10 if oFARATIO!=. & oFARATIO >= 2.5
	replace oHEI2015C9_FATTYACID=0 if oFARATIO <= 1.2
	replace oHEI2015C9_FATTYACID=10*((oFARATIO-1.2)/(2.5-1.2)) if oHEI2015C9_FATTYACID ==.
	
**** Sodium

gen oSODDEN = .
	replace oSODDEN = T_orisodi/kcal if kcal>0
	*they did not divide kcal by 1000 to convert sodium mg to g
	replace oSODDEN= 0 if kcal== 0

gen oHEI2015C10_SODIUM = .
	replace oHEI2015C10_SODIUM=10 if oSODDEN <= 1.1
	replace oHEI2015C10_SODIUM=0 if oSODDEN !=. & oSODDEN >= 2.0
	replace oHEI2015C10_SODIUM=10-(10*(oSODDEN-1.1)/(2.0-1.1)) if oHEI2015C10_SODIUM ==.

**** Refined Grains

gen oRGDEN = .
	replace oRGDEN = T_DR1T_ori_G_REFINED/(kcal/1000) if kcal>0
	replace oRGDEN= 0 if kcal== 0

gen oHEI2015C11_REFINEDGRAIN = .
	replace oHEI2015C11_REFINEDGRAIN=10 if oRGDEN <= 1.8
	replace oHEI2015C11_REFINEDGRAIN=0 if oRGDEN !=. & oRGDEN >= 4.3
	replace oHEI2015C11_REFINEDGRAIN=10-(10*(oRGDEN-1.8)/(4.3-1.8)) if oHEI2015C11_REFINEDGRAIN ==.	

**** Saturated Fat

gen oSFAT_PERC = .
	replace oSFAT_PERC = 100*(T_orisfat*9/kcal) if kcal>0
	replace oSFAT_PERC= 0 if kcal== 0

gen oHEI2015C12_SFAT = .
	replace oHEI2015C12_SFAT=10 if oSFAT_PERC <= 8
	replace oHEI2015C12_SFAT=0 if oSFAT_PERC!=. & oSFAT_PERC >= 16
	replace oHEI2015C12_SFAT=10-(10*(oSFAT_PERC-8)/(16-8)) if oHEI2015C12_SFAT ==.
 
**** Added Sugars

gen oADDSUG_PERC = .
	replace oADDSUG_PERC = 100*(T_DR1T_ori_ADD_SUGARS*16/kcal) if kcal>0
	replace oADDSUG_PERC= 0 if kcal== 0

gen oHEI2015C13_ADDSUG = .
	replace oHEI2015C13_ADDSUG=10 if oADDSUG_PERC <= 6.5
	replace oHEI2015C13_ADDSUG=0 if oADDSUG_PERC!=. & oADDSUG_PERC >= 26
	replace oHEI2015C13_ADDSUG=10-(10*(oADDSUG_PERC-6.5)/(26-6.5)) if oHEI2015C13_ADDSUG ==.

*tab ageCat if HEI2015C13_ADDSUG > 9

  replace oHEI2015C1_TOTALVEG=0 if kcal==0
  replace oHEI2015C2_GREEN_AND_BEAN=0 if kcal==0
  replace oHEI2015C3_TOTALFRUIT=0 if kcal==0
  replace oHEI2015C4_WHOLEFRUIT=0 if kcal==0
  replace oHEI2015C5_WHOLEGRAIN=0 if kcal==0
  replace oHEI2015C6_TOTALDAIRY=0 if kcal==0
  replace oHEI2015C7_TOTPROT=0 if kcal==0
  replace oHEI2015C8_SEAPLANT_PROT=0 if kcal==0
  replace oHEI2015C9_FATTYACID=0 if kcal==0
  replace oHEI2015C10_SODIUM=0 if kcal==0
  replace oHEI2015C11_REFINEDGRAIN=0 if kcal==0
  replace oHEI2015C12_SFAT=0 if kcal==0
  replace oHEI2015C13_ADDSUG=0 if kcal==0

/**Calculate HEI-2015 total score**/
/*total HEI-2015 score is the sum of 13 HEI component scores*/

gen oHEI2015_TOTAL_SCORE = oHEI2015C1_TOTALVEG + oHEI2015C2_GREEN_AND_BEAN + oHEI2015C3_TOTALFRUIT + oHEI2015C4_WHOLEFRUIT + oHEI2015C5_WHOLEGRAIN + oHEI2015C6_TOTALDAIRY + oHEI2015C7_TOTPROT + oHEI2015C8_SEAPLANT_PROT + oHEI2015C9_FATTYACID + oHEI2015C10_SODIUM + oHEI2015C11_REFINEDGRAIN + oHEI2015C12_SFAT + oHEI2015C13_ADDSUG


*Data check
sum oHEI2015_TOTAL_SCORE



/////Sub)

**** Total Veg

**Density
gen sVEGDEN = .
	replace sVEGDEN= sVTOTALLEG/(kcal/1000) if kcal>0
	replace sVEGDEN= 0 if kcal== 0
	
*tab seqn if kcal==0  		46 seqns with kcal==0
*tab seqn if VEGDEN==0		677 seqns

**Scoring
gen szHEI2015C1_TOTALVEG=5*(sVEGDEN/1.1) 
gen sHEI2015C1_TOTALVEG = szHEI2015C1_TOTALVEG
	replace sHEI2015C1_TOTALVEG=5 if szHEI2015C1_TOTALVEG !=. & szHEI2015C1_TOTALVEG > 5

**** Green & Beans

gen sGRBNDEN = .
	replace sGRBNDEN= sVDRKGRLEG/(kcal/1000) if kcal>0
	replace sGRBNDEN= 0 if kcal== 0

gen szHEI2015C2_GREEN_AND_BEAN=5*(sGRBNDEN/0.2) 
gen sHEI2015C2_GREEN_AND_BEAN = szHEI2015C2_GREEN_AND_BEAN
	replace sHEI2015C2_GREEN_AND_BEAN=5 if szHEI2015C2_GREEN_AND_BEAN !=. & szHEI2015C2_GREEN_AND_BEAN > 5

**** Total Fruits

gen sFRTDEN = .
	replace sFRTDEN= T_DR1T_sub_F_TOTAL/(kcal/1000) if kcal>0
	replace sFRTDEN= 0 if kcal== 0

gen szHEI2015C3_TOTALFRUIT=5*(sFRTDEN/0.8) 
gen sHEI2015C3_TOTALFRUIT = szHEI2015C3_TOTALFRUIT
	replace sHEI2015C3_TOTALFRUIT=5 if szHEI2015C3_TOTALFRUIT !=. & szHEI2015C3_TOTALFRUIT > 5
	
**** Whole Fruits

gen sWHFRDEN = .
	replace sWHFRDEN= sFWHOLEFRT/(kcal/1000) if kcal>0
	replace sWHFRDEN= 0 if kcal== 0

gen szHEI2015C4_WHOLEFRUIT=5*(sWHFRDEN/0.4) 
gen sHEI2015C4_WHOLEFRUIT = szHEI2015C4_WHOLEFRUIT
	replace sHEI2015C4_WHOLEFRUIT=5 if szHEI2015C4_WHOLEFRUIT !=. & szHEI2015C4_WHOLEFRUIT > 5

**** Whole Grains

gen sWGRNDEN = .
	replace sWGRNDEN= T_DR1T_sub_G_WHOLE/(kcal/1000) if kcal>0
	replace sWGRNDEN= 0 if kcal== 0

gen szHEI2015C5_WHOLEGRAIN=10*(sWGRNDEN/1.5) 
gen sHEI2015C5_WHOLEGRAIN = szHEI2015C5_WHOLEGRAIN
	replace sHEI2015C5_WHOLEGRAIN=10 if szHEI2015C5_WHOLEGRAIN !=. & szHEI2015C5_WHOLEGRAIN > 10

**** Dairy

gen sDAIRYDEN = .
	replace sDAIRYDEN= T_DR1T_sub_D_TOTAL/(kcal/1000) if kcal>0
	replace sDAIRYDEN= 0 if kcal== 0

gen szHEI2015C6_TOTALDAIRY=10*(sDAIRYDEN/1.3) 
gen sHEI2015C6_TOTALDAIRY = szHEI2015C6_TOTALDAIRY
	replace sHEI2015C6_TOTALDAIRY=10 if szHEI2015C6_TOTALDAIRY !=. & szHEI2015C6_TOTALDAIRY > 10

**** Total Protein

gen sPROTDEN = .
	replace sPROTDEN= sPFALLPROTLEG/(kcal/1000) if kcal>0
	replace sPROTDEN= 0 if kcal== 0

gen szHEI2015C7_TOTPROT=5*(sPROTDEN/2.5) 
gen sHEI2015C7_TOTPROT = szHEI2015C7_TOTPROT
	replace sHEI2015C7_TOTPROT=5 if szHEI2015C7_TOTPROT !=. & szHEI2015C7_TOTPROT > 5
	
**** Seafood and Plant Proteins

gen sSEAPLDEN = .
	replace sSEAPLDEN= sPFSEAPLANTLEG/(kcal/1000) if kcal>0
	replace sSEAPLDEN= 0 if kcal== 0

gen szHEI2015C8_SEAPLANT_PROT=5*(sSEAPLDEN/0.8) 
gen sHEI2015C8_SEAPLANT_PROT = szHEI2015C8_SEAPLANT_PROT
	replace sHEI2015C8_SEAPLANT_PROT=5 if szHEI2015C8_SEAPLANT_PROT !=. & szHEI2015C8_SEAPLANT_PROT > 5

**** Fatty Acids

gen sFARATIO = .
	replace sFARATIO= sMONOPOLY/T_subsfat if T_subsfat>0
	replace sFARATIO= 0 if T_subsfat== 0

gen sHEI2015C9_FATTYACID = .
	replace sHEI2015C9_FATTYACID = 10 if (T_subsfat == 0) & (sMONOPOLY == 0)
	*make sure the command below does not assign 10 to missing FARATIO values such as human milk // there are no missing values though
	replace sHEI2015C9_FATTYACID=10 if sFARATIO!=. & sFARATIO >= 2.5
	replace sHEI2015C9_FATTYACID=0 if sFARATIO <= 1.2
	replace sHEI2015C9_FATTYACID=10*((sFARATIO-1.2)/(2.5-1.2)) if sHEI2015C9_FATTYACID ==.
	
**** Sodium

gen sSODDEN = .
	replace sSODDEN = T_subsodi/kcal if kcal>0
	*they did not divide kcal by 1000 to convert sodium mg to g
	replace sSODDEN= 0 if kcal== 0

gen sHEI2015C10_SODIUM = .
	replace sHEI2015C10_SODIUM=10 if sSODDEN <= 1.1
	replace sHEI2015C10_SODIUM=0 if sSODDEN !=. & sSODDEN >= 2.0
	replace sHEI2015C10_SODIUM=10-(10*(sSODDEN-1.1)/(2.0-1.1)) if sHEI2015C10_SODIUM ==.

**** Refined Grains

gen sRGDEN = .
	replace sRGDEN = T_DR1T_sub_G_REFINED/(kcal/1000) if kcal>0
	replace sRGDEN= 0 if kcal== 0

gen sHEI2015C11_REFINEDGRAIN = .
	replace sHEI2015C11_REFINEDGRAIN=10 if sRGDEN <= 1.8
	replace sHEI2015C11_REFINEDGRAIN=0 if sRGDEN !=. & sRGDEN >= 4.3
	replace sHEI2015C11_REFINEDGRAIN=10-(10*(sRGDEN-1.8)/(4.3-1.8)) if sHEI2015C11_REFINEDGRAIN ==.	

**** Saturated Fat

gen sSFAT_PERC = .
	replace sSFAT_PERC = 100*(T_subsfat*9/kcal) if kcal>0
	replace sSFAT_PERC= 0 if kcal== 0

gen sHEI2015C12_SFAT = .
	replace sHEI2015C12_SFAT=10 if sSFAT_PERC <= 8
	replace sHEI2015C12_SFAT=0 if sSFAT_PERC!=. & sSFAT_PERC >= 16
	replace sHEI2015C12_SFAT=10-(10*(sSFAT_PERC-8)/(16-8)) if sHEI2015C12_SFAT ==.
 
**** Added Sugars

gen sADDSUG_PERC = .
	replace sADDSUG_PERC = 100*(T_DR1T_sub_ADD_SUGARS*16/kcal) if kcal>0
	replace sADDSUG_PERC= 0 if kcal== 0

gen sHEI2015C13_ADDSUG = .
	replace sHEI2015C13_ADDSUG=10 if sADDSUG_PERC <= 6.5
	replace sHEI2015C13_ADDSUG=0 if sADDSUG_PERC!=. & sADDSUG_PERC >= 26
	replace sHEI2015C13_ADDSUG=10-(10*(sADDSUG_PERC-6.5)/(26-6.5)) if sHEI2015C13_ADDSUG ==.

*tab ageCat if HEI2015C13_ADDSUG > 9

  replace sHEI2015C1_TOTALVEG=0 if kcal==0
  replace sHEI2015C2_GREEN_AND_BEAN=0 if kcal==0
  replace sHEI2015C3_TOTALFRUIT=0 if kcal==0
  replace sHEI2015C4_WHOLEFRUIT=0 if kcal==0
  replace sHEI2015C5_WHOLEGRAIN=0 if kcal==0
  replace sHEI2015C6_TOTALDAIRY=0 if kcal==0
  replace sHEI2015C7_TOTPROT=0 if kcal==0
  replace sHEI2015C8_SEAPLANT_PROT=0 if kcal==0
  replace sHEI2015C9_FATTYACID=0 if kcal==0
  replace sHEI2015C10_SODIUM=0 if kcal==0
  replace sHEI2015C11_REFINEDGRAIN=0 if kcal==0
  replace sHEI2015C12_SFAT=0 if kcal==0
  replace sHEI2015C13_ADDSUG=0 if kcal==0

/**Calculate HEI-2015 total score**/
/*total HEI-2015 score is the sum of 13 HEI component scores*/

gen sHEI2015_TOTAL_SCORE = sHEI2015C1_TOTALVEG + sHEI2015C2_GREEN_AND_BEAN + sHEI2015C3_TOTALFRUIT + sHEI2015C4_WHOLEFRUIT + sHEI2015C5_WHOLEGRAIN + sHEI2015C6_TOTALDAIRY + sHEI2015C7_TOTPROT + sHEI2015C8_SEAPLANT_PROT + sHEI2015C9_FATTYACID + sHEI2015C10_SODIUM + sHEI2015C11_REFINEDGRAIN + sHEI2015C12_SFAT + sHEI2015C13_ADDSUG


*Data check
sum sHEI2015_TOTAL_SCORE


**#Step 6: Calculate the difference between original and substituted diets

	foreach v of var sHEI2015* { 
 	*String without "s"
     local p = substr("`v'", 2, .) 
     gen diff_`p' = s`p' - o`p'
	}

	
**Step 7: Calculate %difference by seqn
//This yields a significant number of missing values since we are dividing some of data by zero (original data)


	 foreach v of var diff_* { 
		*String without "diff_"
		 local p = substr("`v'", 6, .) 
		 gen perc_`p' = diff_`p'*100/o`p'
	}

**Used overall percent difference for manuscript - calculated manually
**Overall Percent Difference
** (Mean sub - Mean ori)/ Mean ori


save "$Analysis/HEI/Intermediate/HEI_total_score_per_seqn_allpop1_`filename'", replace
}

*******
**Substituters flag to be used in subset analysis

cd "$Analysis/HEI/Intermediate"
local files: dir "$Analysis/HEI/Intermediate" files "*score_per_seqn_allpop1_*.dta"

foreach file in `files'{
	dir `file'

	*Substring used later to save the file name - two steps because have to keep some of the middle words
	local filename = regexr("`file'","HEI_total_score_per_seqn_allpop1_","")
	local file_str = regexr("`filename'","_(.*)","")
	local file_str = regexr("`file_str'",".dta","")
	
	use `file', clear

*Merge seqn flag
	merge m:1 seqn using "$Analysis/Substitution/2015-16/Seqn lists/List_`file_str'_substitutions_uniqueseqn.dta", update replace generate(_merge_subflag)
	
save "$Analysis/HEI/HEI_total_score_per_seqn_allpop_`filename'", replace	
	
}
	

*LABEL HEI2015_TOTAL_SCORE='TOTAL HEI-2015 SCORE'
*      HEI2015C1_TOTALVEG='HEI-2015 COMPONENT 1 TOTAL VEGETABLES'
*      HEI2015C2_GREEN_AND_BEAN='HEI-2015 COMPONENT 2 GREENS AND BEANS'
*      HEI2015C3_TOTALFRUIT='HEI-2015 COMPONENT 3 TOTAL FRUIT'
*      HEI2015C4_WHOLEFRUIT='HEI-2015 COMPONENT 4 WHOLE FRUIT'
*      HEI2015C5_WHOLEGRAIN='HEI-2015 COMPONENT 5 WHOLE GRAINS'
*      HEI2015C6_TOTALDAIRY='HEI-2015 COMPONENT 6 DAIRY'
*      HEI2015C7_TOTPROT='HEI-2015 COMPONENT 7 TOTAL PROTEIN FOODS'
*      HEI2015C8_SEAPLANT_PROT='HEI-2015 COMPONENT 8 SEAFOOD AND PLANT PROTEIN'
*      HEI2015C9_FATTYACID='HEI-2015 COMPONENT 9 FATTY ACID RATIO'
*      HEI2015C10_SODIUM='HEI-2015 COMPONENT 10 SODIUM'
*      HEI2015C11_REFINEDGRAIN='HEI-2015 COMPONENT 11 REFINED GRAINS'
*      HEI2015C12_SFAT='HEI-2015 COMPONENT 12 SAT FAT'
*      HEI2015C13_ADDSUG='HEI-2015 COMPONENT 13 ADDED SUGAR'
*      VEGDEN='DENSITY OF TOTAL VEGETABLES PER 1000 KCAL'
*      GRBNDEN='DENSITY OF DARK GREEN VEG AND BEANS PER 1000 KCAL'
*      FRTDEN='DENSITY OF TOTAL FRUIT PER 1000 KCAL'
*      WHFRDEN='DENSITY OF WHOLE FRUIT PER 1000 KCAL'
*      WGRNDEN='DENSITY OF WHOLE GRAIN PER 1000 KCAL'
*      DAIRYDEN='DENSITY OF DAIRY PER 1000 KCAL'
*      PROTDEN='DENSITY OF TOTAL PROTEIN PER 1000 KCAL'
*      SEAPLDEN='DENSITY OF SEAFOOD AND PLANT PROTEIN PER 1000 KCAL'
*      FARATIO='FATTY ACID RATIO'
*      SODDEN='DENSITY OF SODIUM PER 1000 KCAL'
*      RGDEN='DENSITY OF REFINED GRAINS PER 1000 KCAL'
*      SFAT_PERC='PERCENT OF CALORIES FROM SAT FAT'
*      ADDSUG_PERC='PERCENT OF CALORIES FROM ADDED SUGAR'







