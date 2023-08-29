**Convert dataFRIENDS from excel to .dta

cd "$Data"

import excel "$Data/dataFRIENDS/dataFRIENDS_2.0_20221215_correct rice.xlsx", sheet("Data")  firstrow clear

save "$Data/dataFRIENDS/dataFRIENDS_2.0_20221215.dta", replace

