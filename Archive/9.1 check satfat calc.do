**Check SatFat calculation - range of HEI SATFAT %diff was too large

use "/Users/clee/Dropbox/Aim 1/Analysis/Substitution/2015-16/5_OrixSub_dataset/Protein_Sub_dataset_low_origxsub.dta", clear

*keep if seqn == 88956
keep if seqn == 91904

egen T_orisfat = total(orisfat)

egen T_subsfat = total(subsfat)


egen T_orikcal = total(orikcal)

egen T_subkcal = total(subkcal)


gen oSFAT_PERC = 100*(T_orisfat*9/T_orikcal)

gen sSFAT_PERC = 100*(T_subsfat*9/T_subkcal)


gen sHEI2015C12_SFAT=10-(10*(sSFAT_PERC-8)/(16-8))

gen oHEI2015C12_SFAT=10-(10*(oSFAT_PERC-8)/(16-8))


gen diff = sHEI2015C12_SFAT-oHEI2015C12_SFAT
