cd "$Analysis"

import excel "$Analysis/MasterLists/AG lists/Merged_ghg100/Protein_Substitutes_v3_ghg100_CL.xlsx", firstrow clear
	
keep food_code food_description ghg100_fd sb_num sb_code sb_description ghg100_sb
drop if food_code==.
duplicates list food_code sb_code
duplicates drop food_code sb_code, force

**Reshaped to wide
reshape wide sb_code sb_description ghg100_sb, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)
replace ghg100_sb2 = ghg100_sb1 if missing(ghg100_sb2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename ghg100_sb1 ghg100_sb_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
rename ghg100_sb2 ghg100_sb_hi

order food_description ghg100_fd, after(food_code)

export excel "$Analysis/MasterLists/Suppl table/Substitution list_suppl table.xlsx", sheet("Protein") firstrow(variables) sheetmodify


*******
**Mixed dishes
import excel "$Analysis/MasterLists/AG lists/Merged_ghg100/MxDishes_Substitutes_v3_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear

keep food_code food_description ghg100_fd sb_num sb_code sb_description ghg100_sb
drop if food_code==.
duplicates list food_code sb_code
duplicates drop food_code sb_code, force

**Reshaped to wide
reshape wide sb_code sb_description ghg100_sb, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)
replace ghg100_sb2 = ghg100_sb1 if missing(ghg100_sb2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename ghg100_sb1 ghg100_sb_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
rename ghg100_sb2 ghg100_sb_hi

order food_description ghg100_fd, after(food_code)

export excel "$Analysis/MasterLists/Suppl table/Substitution list_suppl table.xlsx", sheet("Mx Dishes") firstrow(variables) sheetmodify

*******
**Milk
import excel "$Analysis/MasterLists/AG lists/Merged_ghg100/Milk_Substitutes_v1_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear

*Remove dairy items w/o subs (e.g., cheese)
drop if sb_code== .
keep food_code food_description ghg100_fd sb_num sb_code sb_description ghg100_sb
drop if food_code==.
duplicates list food_code sb_code
duplicates drop food_code sb_code, force
duplicates list food_code //more than one substitute per food_code?

**Reshaped to wide
reshape wide sb_code sb_description ghg100_sb, i(food_code) j(sb_num)
*Replacing missing values of scenario 2 of subs
replace sb_code2 = sb_code1 if missing(sb_code2)
replace sb_description2 = sb_description1 if missing(sb_description2)
replace ghg100_sb2 = ghg100_sb1 if missing(ghg100_sb2)

rename sb_code1 sb_code_lo
rename sb_description1 sb_desc_lo
rename ghg100_sb1 ghg100_sb_lo
rename sb_code2 sb_code_hi
rename sb_description2 sb_desc_hi
rename ghg100_sb2 ghg100_sb_hi

order food_description ghg100_fd, after(food_code)

export excel "$Analysis/MasterLists/Suppl table/Substitution list_suppl table.xlsx", sheet("Milk") firstrow(variables) sheetmodify

*******
**Non-alcoholic beverages - One sub per food code (no reshaping needed)
import excel "$Analysis/MasterLists/AG lists/Merged_ghg100/Beverages_Substitutes_v3_fruit_ghg100_CL.xlsx", sheet("Sheet1") firstrow  clear
drop if sb_code== .
keep food_code food_description ghg100_fd sb_num sb_code sb_description ghg100_sb
drop if food_code==.
duplicates list food_code sb_code
duplicates drop food_code sb_code, force

export excel "$Analysis/MasterLists/Suppl table/Substitution list_suppl table.xlsx", sheet("Bev") firstrow(variables) sheetmodify
