require(data.table); require(ggplot2); require(mgcv): require(dplyr); require(RColorBrewer); require(emmeans); require(forcats); require(boot)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

C <- readRDS(paste0(root_dir,"/Outputs/CPUE_B.rds")); length(unique(C$INTERVIEW_PK))

# Select species and area 
Sp <- "229"
Ar <- "Tutuila"

# Run selections
if(Ar=="Tutuila") D <- C[AREA_C=="Tutuila"|AREA_C=="Bank"] 
if(Ar=="Manua")   D <- C[AREA_C=="Manua"]
length(unique(D$INTERVIEW_PK))

D <- D[SPECIES_FK==Sp]; length(unique(D$INTERVIEW_PK))

# Nominal CPUE
NML       <- D[,list(CPUE=mean(CPUE)),by=list(YEAR)]
NML$STD   <- NML$CPUE/mean(NML$CPUE)*100
NML$MODEL <- "NOMI"
NML       <- select(NML,-CPUE)
NML$YEAR  <- as.numeric(as.character((NML$YEAR)))

# Run standardization analyses - old data - This step can take a while.
P.Models      <- list()
P.Models[[1]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR, method="REML")
P.Models[[2]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+AREA_C, method="REML")
P.Models[[3]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+AREA_C+MONTH, method="REML")
P.Models[[4]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+AREA_C+MONTH+s(PC1)+s(PC2), method="REML")
P.Models[[5]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+AREA_C+MONTH+s(PC1,PC2), method="REML")
P.Models[[6]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+AREA_C+MONTH+s(PC1)+s(PC2)+s(PC3)+s(PC4), method="REML")

B.Models      <- list()
B.Models[[1]] <- bam(data=D,PRES~YEAR,family=binomial(link="logit"), method="REML")
B.Models[[2]] <- bam(data=D,PRES~YEAR+AREA_C,family=binomial(link="logit"), method="REML")
B.Models[[3]] <- bam(data=D,PRES~YEAR+AREA_C+MONTH,family=binomial(link="logit"), method="REML")

