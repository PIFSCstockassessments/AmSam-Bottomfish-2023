require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx);require(ggplot2)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 2) # establish directories using this.path


B <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))


# Explore patterns related to interviews with BOTH species-level BMUS and potential group-level BMUS 
B$BMUS <- 0
B[SPECIES_FK=="247"|SPECIES_FK=="239"|SPECIES_FK=="111"|SPECIES_FK=="249"|
    SPECIES_FK=="248"|SPECIES_FK=="267"|SPECIES_FK=="231"|SPECIES_FK=="242"|
    SPECIES_FK=="241"|SPECIES_FK=="245"|SPECIES_FK=="229"]$BMUS <- 1

B$GROUPID <- 0
B[SPECIES_FK=="109"|SPECIES_FK=="110"|SPECIES_FK=="200"|SPECIES_FK=="210"|
    SPECIES_FK=="230"|SPECIES_FK=="240"|SPECIES_FK=="260"|SPECIES_FK=="380"|
    SPECIES_FK=="390"]$GROUPID <- 1

Test      <- B[METHOD_FK==4,list(BMUS=sum(BMUS),GROUPID=sum(GROUPID)),by=list(YEAR,INTERVIEW_PK)]

Test$BOTH <- 0
Test[BMUS>0&GROUPID>0]$BOTH <- 1

Test <- Test[,list(NTOT=.N,BOTH=sum(BOTH)),by=list(YEAR)]

ggplot(data=Test,aes(x=YEAR))+geom_line(aes(y=BOTH),col="red")+geom_line(aes(y=NTOT),col="black")
