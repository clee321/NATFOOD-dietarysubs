## Replication files for "Potential impacts of simple dietary substitutions on carbon footprints and dietary quality across diverse segments of the US population"

### Description
This repository includes Stata codes, folder structure, and raw data files to reproduce the analysis of the manuscript "Potential impacts of simple dietary substitutions on carbon footprints and dietary quality across diverse segments of the US population".


### Instructions to reproduce the analysis:

1) Clone the repository to a preferred location.

2) Unzip 'Project folders-files.zip'  
The zip file contains the folder structure and raw data files needed for the analysis (except dataFRIENDS dataset which is not publicly available at this time). Folder tree is shown below.

3) Open `0_Analysis Parent File.do`  
The Analysis Parent File lists in sequence all the necessary codes for the analysis.  
3.1) Customize the user file paths to reflect your username as well as the folder location (from step 2).  
3.2) Run the do file.

4) Stata outputs will be generated and saved under the folders from step 2.  
Each do file lists specific folder locations where outputs will be saved.

*****

Folder tree of zip file:
```bash
Project folders-files/
├── Data/
│   ├── dataFRIENDS/
│   ├── FPED/
│   │   └── FPED_1516.xls
│   ├── NHANES/
│   │   └── 2015-2016/
│   │       ├── DEMO_I.XPT
│   │       ├── DR1IFF_I.XPT
│   │       ├── DRXFCD_I.XPT
│   │       └── v2_racecat/
│   └── WWEIA/
│       ├── WWEIA_1516.xlsx
│       └── WWEIA_2015-16_foodcat_list_uppercats.xlsx
│
├── Analysis/
│   ├── HEI/
│   │   └── Intermediate/
│   ├── MasterLists/
│   │   └── 2015-16/
│   │       └── Sub lists/
│   │           └── Merged_ghg100/
│   │               ├── Beverages_Substitutes_v3_fruit_ghg100.xlsx
│   │               ├── Milk_Substitutes_v1_ghg100.xlsx
│   │               ├── MxDishes_Substitutes_v3_ghg100.xlsx
│   │               └── Protein_Substitutes_v3_ghg100.xlsx
│   ├── Ranking/
│   │   └── 2015-16/
│   │       ├── ghg_intensity/
│   │       ├── overlap/
│   │       │   └── IntermediateData/
│   │       └── total_ghg/
│   └── Substitution/
│       └── 2015-16/
│           ├── 1_Empty/
│           ├── 2-3_Sub_only_nutri_ghg/
│           ├── 4_Sub_dataset/
│           ├── 5_OrixSub_dataset/
│           ├── 6_OrixSub_totals/
│           │   └── Intermediary/
│           ├── 7_OrixSub_ttl_diff_perc/
│           └── Seqn lists/
│
└── Results/
    └── 2015-16/
        ├── Descriptive/
        ├── HEI/
        │   ├── Overall pop/
        │   └── Substituters/
        └── Mean_nutri_ghg/
            ├── Overall pop/
            └── Substituters/

```
*****

Abbreviations:  
NHANES - National Health and Nutrition Examination Survey  
WWEIA - What We Eat In America Database  
dataFRIENDS - Database of Food Recall Impacts on the Environment for Nutrition and Dietary Studies  
FPED - Food Patterns Equivalents Database  
HEI – Health Eating Index  