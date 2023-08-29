*Analysis Parent File

*Replace xxx with your Stata username
*Replace yyy with the applicable folder location

*User file paths
else if "`c(username)'" =="xxx" {
	global Data 	"/yyy/Project folders-files/Data"
	global Analysis "/yyy/Project folders-files/Analysis"
	global Results 	"/yyy/Project folders-files/Results"
	global Code 	"/yyy/NATFOOD-dietarysubs/Stata codes"
	
}

*Run the codes below:
*(Estimated time to run all codes below: 1h 10min)

*************
*Data cleaning and preparation - part 1

*Convert raw datasets from NHANES, WWEIA, dataFRIENDS to Stata format
run "$Code/1_Data cleaning/1_Convert datasets to Stata format.do"

*Convert raw datasets from FPED (used for HEI) to Stata format
run "$Code/1_Data cleaning/2_FPED cleaning for HEI.do"

*Merge NHANES datasets: DR1IFF + FCD + DEMO + WWEIA
run "$Code/1_Data cleaning/3_Data cleaning1_NHANES_Merge DR1IFF-FCD-DEMO-WWEIA.do"

*Merge Dietary data (NHANES, WWEIA) with DataFRIENDS
run "$Code/1_Data cleaning/4_Data cleaning2_NHANES_Merge dataFRIENDS WWEIA uppercat.do"

*Define subpopulation
run "$Code/1_Data cleaning/5_Define subpop.do"

*Calculate GHG emissions proportional to the amount of foods consumed
run "$Code/1_Data cleaning/6_Added ghgcons with subpop versions.do"


*************
*Data Analysis - part 1: Descriptive statistics and ranking by GHGE

*Calculation of Descriptive Statistics for overall sample
run "$Code/2_Descriptive statistics.do"

*Ranking by GHGE intensity
run "$Code/3_Ranking_ind ghg.do"

*Ranking by Total GHGE 
run "$Code/4_Ranking_total ghg.do"

*Ranking of overlap of Total GHG with GHG intensity (Target Foods list)
run "$Code/5_Ranking_overlap.do"

*************
*Data preparation - part 2

*Convert Excel substitution list tables to Stata tables
run "$Code/6.1_Prepare data for substitution.do"

*List of nutrition and GHGE per kcal (to be multiplied with calories for isocaloric substitution)
run "$Code/6.2_Create Master list for sub items.do"

*Create substitution datasets shell
run "$Code/7.1_Substitution list shell.do"

*Substitution foods subset multiplied with list of nutrition and GHGE per kcal
run "$Code/7.2_Sub foods subset_nutri_ghg.do"

*Create Substitution dataset (merge shell with substitution subset) and merged it with Original foods dataset
run "$Code/7.3_Substitution list with original.do"

*Aggregate nutrition and GHGE totals for before and after substitution per person (seqn). Substitution flag (subflag) for those whose target food was substituted.
run "$Code/8.1_Prepare data for analysis.do"

*************
*Data Analysis - part 2: mean GHGE after substitutions

*Analysis of mean changes in GHGE emissions and nutrition outcomes per person per day after substitutions for the overall sample and demographic groups
run "$Code/8.2_Analysis_substitutions_all and demo.do"

*Analysis of changes in GHGE emissions and nutrition outcomes per person per day after substitutions among those with substitutions and demographic groups
run "$Code/8.3_Analysis_substitutions_subflag and demo.do"

*Pairwise comparisons of GHGE mean change across demographic categories (among those with substitutions)
run "$Code/8.3.1_Analysis pairwise_substitutions_subflag and demo.do"

*Calculation of Descriptive Statistics among those with substitutions
run "$Code/2.1_Descriptive statistics_subflag.do"

*************
*Data preparation and calculation of HEI
run "$Code/9.1_HEI calculation_allsubpop.do"

*Analysis of changes in HEI per person per day after substitutions for the overall sample and demographic groups
run "$Code/9.2_HEI analysis_all and demo.do"

*Analysis of changes in HEI per person per day after substitutions among those with substitutions and demographic groups
run "$Code/9.3_HEI analysis_subflag and demo.do"

*Pairwise comparisons of HEI mean change across demo categories (among those with substitutions)
run "$Code/9.3.1_HEI analysis pairwise_subflag and demo.do"






