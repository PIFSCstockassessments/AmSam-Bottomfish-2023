require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx);require(ggplot2)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 2) # establish directories using this.path


B <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))

# How many interviews?
I <- B[,list(ONES=1),by=list(YEAR,INTERVIEW_PK,METHOD_FK,BMUS)] 
I <- dcast(I,INTERVIEW_PK+YEAR+METHOD_FK~BMUS,value.var="ONES",fill=0) # 3048 interviews (Method 4 or 5)

nrow(I[METHOD_FK==4])/(nrow(I[METHOD_FK==4])+nrow(I[METHOD_FK==5])) # 75% of interviews are Bottomfishing
I <- I[METHOD_FK==4]

I$BOTH            <- ifelse(I$BMUS_Containing_Group==1&I$BMUS_Species==1,1,0)
I2                <- I[BMUS_Containing_Group==1|BMUS_Species==1,list(GROUP=sum(BMUS_Containing_Group),BSPECIES=sum(BMUS_Species),BOTH=sum(BOTH)),by=list(YEAR)]
I2$N_ONLY_SPECIES <- I2$BSPECIES-I2$BOTH
ggplot(data=I2,aes(x=YEAR,y=N_ONLY_SPECIES))+geom_line()
       # If we filtered for only interviews where ALL the BMUS catch is identified at the species level, we would get only about 10 to 30 interviews per year pre-2016.

# Explore the number of vessels with a registration number
VE <- B[METHOD_FK==4,list(N=.N),by=list(INTERVIEW_PK,VESSEL_REGIST_NO)]
VE <- data.table(  table(VE$VESSEL_REGIST_NO)  )
VE[V1=="NULL"]$N/sum(VE$N) # 20% of bfish interviews contain vessel_regist_no == NULL


# Explore patterns related to how many METHODS are contained with a single INTERVIEW_PK
Test <- B[,list(ONES=1),by=list(INTERVIEW_PK,METHOD_FK)]
Test <- Test[,list(N=sum(ONES)),by=list(INTERVIEW_PK)]   
Test[N>1] # This shows an INTERVIEW_PK always contains a single METHOD   


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

Test$PERC <- Test$BOTH/Test$NTOT*100
ggplot(data=Test,aes(x=YEAR,y=PERC))+geom_point(col="red")+geom_smooth() # This shows many interviews pre-2016 where both BMUS and BMUS.GROUPS are present.




