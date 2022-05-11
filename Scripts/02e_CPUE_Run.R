require(this.path);require(data.table);require(ggplot2);require(dplyr);require(openxlsx);require(RColorBrewer); require(forcats); require(boot)
root_dir <- this.path::here(.. = 1)

# Load function that fits CPUE models and generate outputs
source(paste0(root_dir,paste0("/Scripts/02d_CPUE_FIT_FUNCTION.r")))


# Select species and area 
Sp <- "VALO"
Ar <- c("Tutuila","Manua") [2]

Standardize_CPUE(Sp=Sp,Ar=Ar)


