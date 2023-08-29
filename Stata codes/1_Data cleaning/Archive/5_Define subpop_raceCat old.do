
*** Declared data as survey set, recoded demographic variables, defined the subpopulation
*Demo variables Codebook at https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DEMO_I.htm

cd "$Data/NHANES/2015-2016"

*Use dataset
use "NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16", clear

count

*** SURVEY SET
**Declare data as Survey set - Using DEMO weight 
svyset sdmvpsu [pw=wtint2yr], strata(sdmvstra)


*** RECODED SOCIODEMOGRAPHIC VARIABLES
**Age groups**
recode ridageyr (0/1 = 0) (2/5 = 1) (6/11 = 2) (12/17 = 3) (18/25 = 4) (26/39 = 5) (40/49 = 6) (50/59 = 7) (60/100 = 8), generate(ageCat)
label define Age_Labels 0 "0-1" 1 "2-5" 2 "6-11" 3 "12-17" 4 "18-25" 5 "26-39" 6 "40-49" 7 "50-59" 8 "60 and over"
label values ageCat Age_Labels


**Gender**
recode riagendr (1=1) (2=2), generate(genderCat)
label define Gender_Labels 1"Male" 2"Female"
label values genderCat Gender_Labels


**Education**

*Recode education for HH Ref Person
recode dmdhredu (1/2 = 1) (3=2) (4=3) (5=4) (7=.) (9=.) (.=.), generate (eduHHRefCat)
label define EduHHRef_Labels 1"Less than high school" 2"High school graduate or GED" 3"Some college" 4"College degree or higher"

*Recode education for HH Ref Person's Spouse
recode dmdhsedu (1/2 = 1) (3=2) (4=3) (5=4) (7=.) (9=.) (.=.), generate (eduHHSpoCat)
label define EduHHSpo_Labels 1"Less than high school" 2"High school graduate or GED" 3"Some college" 4"College degree or higher"

*Combine education for HH Ref and Spouse - highest value
gen eduCat = max(eduHHRefCat,eduHHSpoCat)
label define Edu_Labels 1"Less than high school" 2"High school graduate or GED" 3"Some college" 4"College degree or higher"
label values eduCat Edu_Labels


**Poverty income ratio** (Ratio of family income to poverty)
recode indfmpir (0/0.99=1) (1.00/1.99=2) (2.00/4.99=3) (5.00=4) (.=99), generate (pirCat)
label define pir_Labels 1"<1.00" 2"1.00 to <2.00" 3"2.00 to <5.00" 4"5.00 or higher" 99"missing"
label values pirCat pir_Labels


**Race** 
recode ridreth1 (3=1) (4=2) (1/2=3) (5=4) (.=.), generate (raceCat)
label define race_Labels 1"Non-Hispanic White" 2"Non-Hispanic Black" 3"Mexican American and other Hispanic" 4"Other Race"
label values raceCat race_Labels


*** Define subpopulation (analytical sample)
*Analytical sample - older than 2, non-missing values, weight (non-missing values for diet file)
gen subpop = .
replace subpop = 1 if ridageyr >= 2 & ridageyr !=. & riagendr !=. & eduCat !=. & pirCat !=. & ridreth1 !=. & wtdrd1 !=.
replace subpop = 0 if (ridageyr < 2 | ridageyr ==. | riagendr ==. | eduCat ==. | pirCat ==. | ridreth1 ==. | wtdrd1 ==.)

tab subpop

*     subpop |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |      9,603        7.90        7.90
*          1 |    111,878       92.10      100.00
*------------+-----------------------------------
*      Total |    121,481      100.00


save "NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_subpop.dta", replace
