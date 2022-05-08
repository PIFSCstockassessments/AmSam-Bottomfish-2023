require(data.table); require(ggplot2); require(mgcv): require(dplyr); require(RColorBrewer); require(emmeans); require(forcats); require(boot); require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

C <- readRDS(paste0(root_dir,"/Outputs/CPUE_B.rds")); length(unique(C$INTERVIEW_PK))
S <- data.table(  read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")  )
S <- select(S,SPECIES_PK,SPECIES)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
C <- merge(C,S,by.x="SPECIES_FK",by.y="SPECIES_PK")
C <- select(C,-SPECIES_FK)

# Last filters
C <- C[NUM_GEAR<=6]
C <- C[HOURS_FISHED<=24]

# Select species and area 
Sp <- "PRFL"
Ar <- "Tutuila"

# Run selections
if(Ar=="Tutuila") D <- C[AREA_C=="Tutuila"|AREA_C=="Bank"] 
if(Ar=="Manua")   D <- C[AREA_C=="Manua"]
length(unique(D$INTERVIEW_PK))

D <- D[SPECIES==Sp]

# Remove years with no catches of this species (model can't make prediction for these years)
YR.CATCH <- D[,list(CPUE=sum(CPUE)),by=YEAR]
YR.CATCH <- YR.CATCH[CPUE>0]
YR.CATCH <- select(YR.CATCH,-CPUE)
D        <- merge(D,YR.CATCH,by="YEAR")

# Nominal CPUE
NOMI       <- D[,list(CPUE=mean(CPUE/HOURS_FISHED/NUM_GEAR)),by=list(YEAR)]
NOMI$STAND <- NOMI$CPUE/mean(NOMI$CPUE)*100
NOMI$MODEL <- "NOMI"
NOMI       <- select(NOMI,-CPUE)
NOMI$YEAR  <- as.numeric(as.character((NOMI$YEAR)))

D <- droplevels(D)

# Run standardization analyses - old data - This step can take a while.
P.Models      <- list()
P.Models[[1]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR, method="REML")
P.Models[[2]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3), method="REML")
P.Models[[3]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH, method="REML")
P.Models[[4]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C, method="REML")
P.Models[[5]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY, method="REML")
P.Models[[6]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID), method="REML")
P.Models[[7]] <- bam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID)+s(PC1)+s(PC2), method="REML")

B.Models      <- list()
B.Models[[1]] <- bam(data=D,PRES~YEAR,family=binomial(link="logit"), method="REML")
B.Models[[2]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3),family=binomial(link="logit"), method="REML")
B.Models[[3]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH,family=binomial(link="logit"), method="REML")
B.Models[[4]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C,family=binomial(link="logit"), method="REML")
B.Models[[5]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY,family=binomial(link="logit"), method="REML")
B.Models[[6]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID),family=binomial(link="logit"), method="REML")
B.Models[[7]] <- bam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID)+s(PC1)+s(PC2),family=binomial(link="logit"), method="REML")

aP.Model <- P.Models[[4]]

Results <- list()
for(i in 1:length(B.Models)){
  
  aB.Model <- B.Models[[i]]
  
  # Create Walter's large table and run predictions
  WLT <- data.table(  table(D$YEAR,D$MONTH,D$AREA_C)  )
  setnames(WLT,c("YEAR","MONTH","AREA_C","N"))
  
  # Add median for continuous variables
  WLT$HOURS_FISHED <- median(D$HOURS_FISHED)
  WLT$NUM_GEAR     <- median(D$NUM_GEAR)
  WLT$PROP_UNID    <- median(D$PROP_UNID)
  WLT$TYPE_OF_DAY  <- "WD"
  WLT$PC1          <- median(D$PC1)
  WLT$PC2          <- median(D$PC2)
  
  
  # Predict expected values for all level combinations
  POSCPUE     <- predict.bam(aP.Model,newdata=WLT)
  WLT         <- cbind(WLT,POSCPUE)
  WLT$POSCPUE <- exp(WLT$POSCPUE)
  
  # Predict expected probabilities
  PROBCPUE     <- predict.bam(aB.Model,newdata=WLT)
  WLT          <- cbind(WLT,PROBCPUE)
  WLT$PROBCPUE <- inv.logit(WLT$PROBCPUE)
  
  # Put back together
  WLT$SDCPUE <- WLT$POSCPUE*WLT$PROBCPUE
  
  # Give AREAS proportional geographical weights
  RW  <- data.table(AREA_C=c("Tutuila","Bank","Manua"),WEIGHT=c(0.79,0.08,0.13))
  WLT <- merge(WLT,RW,by="AREA_C")
  
  WLT1 <- WLT[,list(SDCPUE=sum(SDCPUE*WEIGHT)),by=list(YEAR,MONTH)] # Sum abundance in all region, by regional weight
  WLT1 <- WLT1[,list(SDCPUE=mean(SDCPUE)),by=list(YEAR)] # Average all 12 months per year
  
  WLT1$YEAR <- as.numeric(WLT1$YEAR)
  
  WLT1$STAND  <- WLT1$SDCPUE/mean(WLT1$SDCPUE)*100
  WLT1        <- select(WLT1,-SDCPUE)
  WLT1$MODEL  <- paste0("Model",i)
  
  Results[[i]] <- WLT1
  
}

Final   <- rbindlist(Results)
Final   <- rbind(Final,NOMI)

ggplot(data=Final,aes(x=YEAR,group=MODEL))+geom_smooth(aes(y=STAND,color=MODEL),se=F,span=0.3)+
  scale_color_brewer(palette = "Set2")+theme_bw()

#ggplot(data=D,aes(x=FYEAR))+geom_point(aes(y=PERC),color="blue",size=1)+geom_point(aes(y=PERC1),color="red",size=1)+
#  geom_smooth(aes(y=PERC),span=0.3,col="blue")+geom_smooth(aes(y=PERC1),span=0.3,col="red")+theme_bw()
