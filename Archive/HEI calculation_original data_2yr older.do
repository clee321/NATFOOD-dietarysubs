*HEI Scores Calculation

**Prepare dataset for HEI calculation

cd "$Analysis/HEI"

*Food Patterns Equivalents Database per 100 grams of FNDDS 2015-2016 foods
*Convert FPED from .XLS to .DTA
import excel "$Data/FPED/FPED_1516.xls", firstrow clear
rename FOODCODE food_code
rename *cupeq *
rename *ozeq *
rename *grams *
rename *tspeq *
rename *noofdrinks *
*no duplicates on FOODCODE
save "$Data/FPED/FPED_1516.dta", replace


********
*Step 1: Merge NHANES, DEMO + FPED

use "$Data/NHANES/2015-2016/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_2yrolder_ghgconsumed", clear

merge m:1 food_code using "$Data/FPED/FPED_1516.dta", generate(_merge_FPED)

*   Result                      Number of obs
*   -----------------------------------------
*   Not matched                         3,808
*       from master                         0  (_merge_FPED==1)
*       from using                      3,808  (_merge_FPED==2)
*
*   Matched                           111,878  (_merge_FPED==3)
*   -----------------------------------------

*tab DESCRIPTION if _merge_FPED==2 
*Probably foods not consumed by NHANES participants
drop if _merge_FPED==2

********
*Step 2: Multiply all 37 HEI components by grams - create variables DR1T_*
*FPED: HEI component per 100g (see FPED user guide pdf) x Xg of food consumed / 100g

*Loop multiplying HEI components with grams
foreach v0 of varlist F_* V_* G_* PF_* D_* OILS SOLID_FATS ADD_SUGARS A_DRINKS{
     local v = substr("`v0'",1,.)
	 gen DR1T_`v0' = `v0'*grams/100
 }

*20 missing values -  20 records of Milk,human without grams


********
*Step 3: Aggregate HEI components by SEQN and keep one row per SEQN

*Loop sum of HEI components by SEQN
foreach v1 of varlist DR1T_* dr1imfat dr1ipfat dr1isfat dr1ikcal dr1isodi{
     local v = substr("`v1'",1,.)
	 bysort seqn: egen T_`v1' = total(`v1')
 }

*Drop duplicates keeping one row per seqn
duplicates drop seqn, force

rename T_dr1ikcal kcal

********
*Step 4: Create additional required variables: FWHOLEFRT, MONOPOLY, VTOTALLEG, VDRKGRLEG, PFALLPROTLEG and PFSEAPLANTLEG */

*All whole fruits
  gen FWHOLEFRT = T_DR1T_F_CITMLB + T_DR1T_F_OTHER

*Mono and Polyunsaturated fats
  gen MONOPOLY = T_dr1imfat + T_dr1ipfat

*VTOTALLEG sums together all vegetables and legumes
  gen VTOTALLEG = T_DR1T_V_TOTAL + T_DR1T_V_LEGUMES
  
*VDRKGRLEG sums together dark green vegetables and legumes 
  gen VDRKGRLEG = T_DR1T_V_DRKGR + T_DR1T_V_LEGUMES

*PFALLPROTLEG sums together all animal and plant proteins, including meat, poultry, fish, eggs, nuts, seeds, soy, and legumes 
  gen PFALLPROTLEG = T_DR1T_PF_MPS_TOTAL + T_DR1T_PF_EGGS + T_DR1T_PF_NUTSDS + T_DR1T_PF_SOY + T_DR1T_PF_LEGUMES
 
*PFSEAPLANTLEG sums together all fish and plant proteins, including fish, nuts, seeds, soy, and legumes
  gen PFSEAPLANTLEG = T_DR1T_PF_SEAFD_HI + T_DR1T_PF_SEAFD_LOW + T_DR1T_PF_NUTSDS + T_DR1T_PF_SOY + T_DR1T_PF_LEGUMES

save "$Data/FPED/NHANES_DEMO_GHG_FPED_2015 for HEI calc.dta", replace
  
********
use "$Data/FPED/NHANES_DEMO_GHG_FPED_2015 for HEI calc", clear

*Step 5: HEI Macro - calculate density and scores
*Standard for max or min per 1,000 kcal

**** Total Veg

**Density
gen VEGDEN = .
	replace VEGDEN= VTOTALLEG/(kcal/1000) if kcal>0
	replace VEGDEN= 0 if kcal== 0

**Scoring
gen zHEI2015C1_TOTALVEG=5*(VEGDEN/1.1) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C1_TOTALVEG>5
gen HEI2015C1_TOTALVEG = zHEI2015C1_TOTALVEG
	replace HEI2015C1_TOTALVEG=5 if zHEI2015C1_TOTALVEG !=. & zHEI2015C1_TOTALVEG > 5

**** Green & Beans

gen GRBNDEN = .
	replace GRBNDEN= VDRKGRLEG/(kcal/1000) if kcal>0
	replace GRBNDEN= 0 if kcal== 0

gen zHEI2015C2_GREEN_AND_BEAN=5*(GRBNDEN/0.2) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C2_GREEN_AND_BEAN>5
gen HEI2015C2_GREEN_AND_BEAN = zHEI2015C2_GREEN_AND_BEAN
	replace HEI2015C2_GREEN_AND_BEAN=5 if zHEI2015C2_GREEN_AND_BEAN !=. & zHEI2015C2_GREEN_AND_BEAN > 5

**** Total Fruits

gen FRTDEN = .
	replace FRTDEN= T_DR1T_F_TOTAL/(kcal/1000) if kcal>0
	replace FRTDEN= 0 if kcal== 0

gen zHEI2015C3_TOTALFRUIT=5*(FRTDEN/0.8) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C3_TOTALFRUIT>5
gen HEI2015C3_TOTALFRUIT = zHEI2015C3_TOTALFRUIT
	replace HEI2015C3_TOTALFRUIT=5 if zHEI2015C3_TOTALFRUIT !=. & zHEI2015C3_TOTALFRUIT > 5
	
**** Whole Fruits

gen WHFRDEN = .
	replace WHFRDEN= FWHOLEFRT/(kcal/1000) if kcal>0
	replace WHFRDEN= 0 if kcal== 0

gen zHEI2015C4_WHOLEFRUIT=5*(WHFRDEN/0.4) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C4_WHOLEFRUIT>5
gen HEI2015C4_WHOLEFRUIT = zHEI2015C4_WHOLEFRUIT
	replace HEI2015C4_WHOLEFRUIT=5 if zHEI2015C4_WHOLEFRUIT !=. & zHEI2015C4_WHOLEFRUIT > 5

**** Whole Grains

gen WGRNDEN = .
	replace WGRNDEN= T_DR1T_G_WHOLE/(kcal/1000) if kcal>0
	replace WGRNDEN= 0 if kcal== 0

gen zHEI2015C5_WHOLEGRAIN=10*(WGRNDEN/1.5) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C5_WHOLEGRAIN>5
gen HEI2015C5_WHOLEGRAIN = zHEI2015C5_WHOLEGRAIN
	replace HEI2015C5_WHOLEGRAIN=10 if zHEI2015C5_WHOLEGRAIN !=. & zHEI2015C5_WHOLEGRAIN > 10

**** Dairy

gen DAIRYDEN = .
	replace DAIRYDEN= T_DR1T_D_TOTAL/(kcal/1000) if kcal>0
	replace DAIRYDEN= 0 if kcal== 0

gen zHEI2015C6_TOTALDAIRY=10*(DAIRYDEN/1.3) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C6_TOTALDAIRY>5
gen HEI2015C6_TOTALDAIRY = zHEI2015C6_TOTALDAIRY
	replace HEI2015C6_TOTALDAIRY=10 if zHEI2015C6_TOTALDAIRY !=. & zHEI2015C6_TOTALDAIRY > 10

**** Total Protein

gen PROTDEN = .
	replace PROTDEN= PFALLPROTLEG/(kcal/1000) if kcal>0
	replace PROTDEN= 0 if kcal== 0

gen zHEI2015C7_TOTPROT=5*(PROTDEN/2.5) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C7_TOTPROT>5
gen HEI2015C7_TOTPROT = zHEI2015C7_TOTPROT
	replace HEI2015C7_TOTPROT=5 if zHEI2015C7_TOTPROT !=. & zHEI2015C7_TOTPROT > 5
	
**** Seafood and Plant Proteins

gen SEAPLDEN = .
	replace SEAPLDEN= PFSEAPLANTLEG/(kcal/1000) if kcal>0
	replace SEAPLDEN= 0 if kcal== 0

gen zHEI2015C8_SEAPLANT_PROT=5*(SEAPLDEN/0.8) 
*check which items have score above 5
*table DESCRIPTION if zHEI2015C8_SEAPLANT_PROT>5
gen HEI2015C8_SEAPLANT_PROT = zHEI2015C8_SEAPLANT_PROT
	replace HEI2015C8_SEAPLANT_PROT=5 if zHEI2015C8_SEAPLANT_PROT !=. & zHEI2015C8_SEAPLANT_PROT > 5

**** Fatty Acids

gen FARATIO = .
	replace FARATIO= MONOPOLY/T_dr1isfat if T_dr1isfat>0
	replace FARATIO= 0 if T_dr1isfat== 0

gen HEI2015C9_FATTYACID = .
	replace HEI2015C9_FATTYACID = 10 if (T_dr1isfat == 0) & (MONOPOLY == 0)
	*make sure the command below does not assign 10 to missing FARATIO values such as human milk
	replace HEI2015C9_FATTYACID=10 if FARATIO!=. & FARATIO >= 2.5
	replace HEI2015C9_FATTYACID=0 if FARATIO <= 1.2
	replace HEI2015C9_FATTYACID=10*((FARATIO-1.2)/(2.5-1.2)) if HEI2015C9_FATTYACID ==.
	
**** Sodium

gen SODDEN = .
	replace SODDEN = T_dr1isodi/kcal if kcal>0
	*they did not divide kcal by 1000 to convert sodium mg to g
	replace SODDEN= 0 if kcal== 0

gen HEI2015C10_SODIUM = .
	replace HEI2015C10_SODIUM=10 if SODDEN <= 1.1
	replace HEI2015C10_SODIUM=0 if SODDEN !=. & SODDEN >= 2.0
	replace HEI2015C10_SODIUM=10-(10*(SODDEN-1.1)/(2.0-1.1)) if HEI2015C10_SODIUM ==.

**** Refined Grains

gen RGDEN = .
	replace RGDEN = T_DR1T_G_REFINED/(kcal/1000) if kcal>0
	replace RGDEN= 0 if kcal== 0

gen HEI2015C11_REFINEDGRAIN = .
	replace HEI2015C11_REFINEDGRAIN=10 if RGDEN <= 1.8
	replace HEI2015C11_REFINEDGRAIN=0 if RGDEN !=. & RGDEN >= 4.3
	replace HEI2015C11_REFINEDGRAIN=10-(10*(RGDEN-1.8)/(4.3-1.8)) if HEI2015C11_REFINEDGRAIN ==.	

**** Saturated Fat

gen SFAT_PERC = .
	replace SFAT_PERC = 100*(T_dr1isfat*9/kcal) if kcal>0
	replace SFAT_PERC= 0 if kcal== 0

gen HEI2015C12_SFAT = .
	replace HEI2015C12_SFAT=10 if SFAT_PERC <= 8
	replace HEI2015C12_SFAT=0 if SFAT_PERC!=. & SFAT_PERC >= 16
	replace HEI2015C12_SFAT=10-(10*(SFAT_PERC-8)/(16-8)) if HEI2015C12_SFAT ==.
 
**** Added Sugars

gen ADDSUG_PERC = .
	replace ADDSUG_PERC = 100*(T_DR1T_ADD_SUGARS*16/kcal) if kcal>0
	replace ADDSUG_PERC= 0 if kcal== 0

gen HEI2015C13_ADDSUG = .
	replace HEI2015C13_ADDSUG=10 if ADDSUG_PERC <= 6.5
	replace HEI2015C13_ADDSUG=0 if ADDSUG_PERC!=. & ADDSUG_PERC >= 26
	replace HEI2015C13_ADDSUG=10-(10*(ADDSUG_PERC-6.5)/(26-6.5)) if HEI2015C13_ADDSUG ==.


  replace HEI2015C1_TOTALVEG=0 if kcal==0
  replace HEI2015C2_GREEN_AND_BEAN=0 if kcal==0
  replace HEI2015C3_TOTALFRUIT=0 if kcal==0
  replace HEI2015C4_WHOLEFRUIT=0 if kcal==0
  replace HEI2015C5_WHOLEGRAIN=0 if kcal==0
  replace HEI2015C6_TOTALDAIRY=0 if kcal==0
  replace HEI2015C7_TOTPROT=0 if kcal==0
  replace HEI2015C8_SEAPLANT_PROT=0 if kcal==0
  replace HEI2015C9_FATTYACID=0 if kcal==0
  replace HEI2015C10_SODIUM=0 if kcal==0
  replace HEI2015C11_REFINEDGRAIN=0 if kcal==0
  replace HEI2015C12_SFAT=0 if kcal==0
  replace HEI2015C13_ADDSUG=0 if kcal==0

/**Calculate HEI-2015 total score**/
/*total HEI-2015 score is the sum of 13 HEI component scores*/

gen HEI2015_TOTAL_SCORE = HEI2015C1_TOTALVEG + HEI2015C2_GREEN_AND_BEAN + HEI2015C3_TOTALFRUIT + HEI2015C4_WHOLEFRUIT + HEI2015C5_WHOLEGRAIN + HEI2015C6_TOTALDAIRY + HEI2015C7_TOTPROT + HEI2015C8_SEAPLANT_PROT + HEI2015C9_FATTYACID + HEI2015C10_SODIUM + HEI2015C11_REFINEDGRAIN + HEI2015C12_SFAT + HEI2015C13_ADDSUG


*Data check
sum HEI2015_TOTAL_SCORE

*    Variable |        Obs        Mean    Std. dev.       Min        Max
*-------------+---------------------------------------------------------
*HEI2015_TO~E |      7,753    49.55067    13.82702   6.642652   94.35164


save "$Analysis/HEI/2015-16 HEI Total Score per seqn.dta", replace


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







