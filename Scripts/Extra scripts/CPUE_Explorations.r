require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx);require(ggplot2)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 2) # establish directories using this.path


B <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))

# How many interviews?
I <- B[,list(ONES=1),by=list(YEAR,INTERVIEW_PK,METHOD_FK,BMUS)] # 3048 interviews
I <- dcast(I,INTERVIEW_PK+METHOD_FK~BMUS,value.var="ONES")






I[IS.BMUS==1|IS.BMUS.GROUP==1]


table(B$METHOD_FK)

# Explore the number of vessels with a registration number
Test <- B[,list(N=.N),by=list(INTERVIEW_PK,VESSEL_REGIST_NO)]
Test <- data.table(  table(Test$VESSEL_REGIST_NO)  )
Test[V1=="NULL"]$N/sum(Test$N) # 15% of interviews contain vessel_regist_no == NULL




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




