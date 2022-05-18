require(this.path);require(data.table)
root_dir <- this.path::here(.. = 1)

# Load function that fits CPUE models and generate outputs
source(paste0(root_dir,paste0("/Scripts/05a_CPUE_BBS_Standardize_Function.r")))

#APRU, APVI, CALU, LERU, LUKA, ETCA, ETCO, PRFI, PRFL, PRZO, VALO


Sp <- "CALU"
Ar <- c("Tutuila","Manua") [2]

Standardize_CPUE(Sp=Sp,Ar=Ar)


minYr=1988;maxYr=2021
