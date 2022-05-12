require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx);require(ggplot2)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 2) # establish directories using this.path


B <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))

# How many interviews?
I <- B[,list(ONES=1),by=list(YEAR,INTERVIEW_PK,METHOD_FK,BMUS)] 
I <- dcast(I,INTERVIEW_PK+YEAR+METHOD_FK~BMUS,value.var="ONES",fill=0) # 3026 interviews (Method 4 or 5)

nrow(I[METHOD_FK==4])/(nrow(I[METHOD_FK==4])+nrow(I[METHOD_FK==5])) # 75% of interviews are Bottomfishing
I <- I[METHOD_FK==4]

I$BOTH            <- ifelse(I$BMUS_Containing_Group==1&I$BMUS_Species==1,1,0)
I2                <- I[BMUS_Containing_Group==1|BMUS_Species==1,list(GROUP=sum(BMUS_Containing_Group),BSPECIES=sum(BMUS_Species),BOTH=sum(BOTH)),by=list(YEAR)]
I2$N_ONLY_SPECIES <- I2$BSPECIES-I2$BOTH
I                 <- I[,]

ggplot(data=I2,aes(x=YEAR,y=N_ONLY_SPECIES))+geom_line()
       # If we filtered for only interviews where ALL the BMUS catch is identified at the species level, we would get only about 10 to 30 interviews per year pre-2016.

# Explore the number of vessels with a registration number
VE <- B[METHOD_FK==4,list(N=.N),by=list(INTERVIEW_PK,VESSEL_REGIST_NO)]
VE <- data.table(  table(VE$VESSEL_REGIST_NO)  )
(VE[V1=="NULL"]$N+VE[V1=="UNREG"]$N)/sum(VE$N) # 20% of bfish interviews contain vessel_regist_no == NULL


# Explore patterns related to how many METHODS are contained with a single INTERVIEW_PK
ME <- B[,list(ONES=1),by=list(INTERVIEW_PK,METHOD_FK)]
ME <- ME[,list(N=sum(ONES)),by=list(INTERVIEW_PK)]   
ME[N>1] # This shows an INTERVIEW_PK always contains a single METHOD   

# Explore pattern between hours_fished and cpue
HF <- B[METHOD_FK==4&HOURS_FISHED<=24,list(EST_LBS=mean(EST_LBS)),by=list(HOURS_FISHED)]
ggplot(data=HF,aes(x=HOURS_FISHED,y=EST_LBS))+geom_point()+geom_smooth(span=0.7)

NG <- B[METHOD_FK==4&NUM_GEAR<=8,list(EST_LBS=mean(EST_LBS)),by=list(NUM_GEAR)]
ggplot(data=NG,aes(x=NUM_GEAR,y=EST_LBS))+geom_point()+geom_smooth(span=0.7)



