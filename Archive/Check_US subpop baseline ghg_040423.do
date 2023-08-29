*Check GHG baseline

use "$Data/NHANES/2015-2016/v2_racecat/NHANES_WWEIA_DataFRIENDS_WWEIAup_2015-16_ghgcons_allsubpop_v2.dta", clear

bysort seqn: egen ttl_ghg = total(ghg_consumed)

duplicates drop seqn, force

svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

svy, subpop (if subpop==1): total (ttl_ghg)
display %12.0g _b[ttl_ghg]

*Survey: Total estimation

*Number of strata = 15            Number of obs   =       8,505
*Number of PSUs   = 30            Population size = 316,468,266
*                                 Subpop. no. obs =       7,753
*                                 Subpop. size    = 302,664,256
*                                 Design df       =          15
*
*--------------------------------------------------------------
*             |             Linearized
*             |      Total   std. err.     [95% conf. interval]
*-------------+------------------------------------------------
*     ttl_ghg |   1.32e+09   8.00e+07      1.15e+09    1.49e+09
*--------------------------------------------------------------

*1,318,391,473 kg C02e (for our paper)

/////
**#Filter adult population only (compare with Willits-Smith 2020 paper)

keep if ridageyr>=18 & ridageyr<=65
* 4,140 counts

tab ridageyr

svyset sdmvpsu [pw=wtdrd1], strata(sdmvstra)

svy, subpop (if subpop==1): total (ttl_ghg)
//Same total with or without subpop since data was filtered already
display %12.0g _b[ttl_ghg]

*Survey: Total estimation

*Number of strata = 15            Number of obs   =       4,140
*Number of PSUs   = 30            Population size = 196,109,804
*                                 Subpop. no. obs =       4,030
*                                 Subpop. size    = 191,386,372
*                                 Design df       =          15
*
*--------------------------------------------------------------
*             |             Linearized
*             |      Total   std. err.     [95% conf. interval]
*-------------+------------------------------------------------
*     ttl_ghg |   9.08e+08   5.07e+07      8.00e+08    1.02e+09
*--------------------------------------------------------------

*908,070,640.5 kg C02e

/////
*Use 2005-2010 NHANES dataset (from Capstone)

use "$Data/NHANES/Appended/NHANES_WWEIA_DataFRIENDS_WWEIAup_2005-10_2yrolder_ghgconsumed.dta", clear
//already filtered subpop

bysort seqn: egen ttl_ghg = total(ghg_consumed)

duplicates drop seqn, force

svyset sdmvpsu [pw=diet_weight6yr], strata(sdmvstra)

svy, subpop (if subpop==1): total (ttl_ghg)
//Same total with or without subpop since data was filtered already
display %12.0g _b[ttl_ghg]

Survey: Total estimation

Number of strata = 46            Number of obs   =      25,663
Number of PSUs   = 93            Population size = 284,067,131
                                 Subpop. no. obs =      25,663
                                 Subpop. size    = 284,067,131
                                 Design df       =          47

--------------------------------------------------------------
             |             Linearized
             |      Total   std. err.     [95% conf. interval]
-------------+------------------------------------------------
     ttl_ghg |   1.27e+09   4.57e+07      1.18e+09    1.37e+09
--------------------------------------------------------------

*1,273,581,761

/////
**#Filter adult population only (compare with Willits-Smith 2020 paper)

keep if ridageyr>=18 & ridageyr<=65
*  12,959 counts

tab ridageyr

svyset sdmvpsu [pw=diet_weight6yr], strata(sdmvstra)

svy, subpop (if subpop==1): total (ttl_ghg)
//Same total with or without subpop since data was filtered already
display %12.0g _b[ttl_ghg]

Survey: Total estimation

Number of strata = 46            Number of obs   =      12,959
Number of PSUs   = 93            Population size = 185,463,581
                                 Subpop. no. obs =      12,959
                                 Subpop. size    = 185,463,581
                                 Design df       =          47

--------------------------------------------------------------
             |             Linearized
             |      Total   std. err.     [95% conf. interval]
-------------+------------------------------------------------
     ttl_ghg |   9.06e+08   3.33e+07      8.39e+08    9.73e+08
--------------------------------------------------------------

* 906,352,673.7

