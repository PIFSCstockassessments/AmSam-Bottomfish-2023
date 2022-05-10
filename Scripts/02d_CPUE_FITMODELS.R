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
Sp <- "APVI"
Ar <- "Tutuila"

# Run selections
if(Ar=="Tutuila") D <- C[AREA_C=="Tutuila"|AREA_C=="Bank"] 
if(Ar=="Manua")   D <- C[AREA_C=="Manua"]

D <- D[SPECIES==Sp]

nrow(D); nrow(D[CPUE>0]) # Check interview counts

# Remove years with no catches of this species (model can't make prediction for these years)
YR.CATCH <- D[,list(CPUE=sum(CPUE)),by=YEAR]
YR.CATCH <- YR.CATCH[CPUE>0]
YR.CATCH <- select(YR.CATCH,-CPUE)
D        <- merge(D,YR.CATCH,by="YEAR")
D        <- droplevels(D)

# Run standardization analyses - old data - This step can take a while.
P.Models      <- list()
P.Models[[1]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR, method="REML")
P.Models[[2]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3), method="REML")
P.Models[[3]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH, method="REML")
P.Models[[4]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C, method="REML")
P.Models[[5]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY, method="REML")
P.Models[[6]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID), method="REML")
P.Models[[7]] <- gam(data=D[CPUE>0],log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID)+s(PC1)+s(PC2), method="REML")

B.Models      <- list()
B.Models[[1]] <- gam(data=D,PRES~YEAR,family=binomial(link="logit"), method="REML")
B.Models[[2]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3),family=binomial(link="logit"), method="REML")
B.Models[[3]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH,family=binomial(link="logit"), method="REML")
B.Models[[4]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C,family=binomial(link="logit"), method="REML")
B.Models[[5]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY,family=binomial(link="logit"), method="REML")
B.Models[[6]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID),family=binomial(link="logit"), method="REML")
B.Models[[7]] <- gam(data=D,PRES~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+AREA_C+TYPE_OF_DAY+s(PROP_UNID)+s(PC1)+s(PC2),family=binomial(link="logit"), method="REML")

Model.Names <- data.table(MODEL=as.factor(c("YEAR","+HOURS_FISHED+NUM_GEAR","+MONTH","+AREA","+TYPE_OF_DAY","+PROP_UNID","+PC1+PC2")),ORDER=c(1,2,3,4,5,6,7))
Model.Names$MODEL <- fct_reorder(Model.Names$MODEL,Model.Names$ORDER,min)
Model.Names <- select(Model.Names,-ORDER)

Results <- list()
for(i in 1:length(B.Models)){
  
  aP.Model    <- P.Models[[i]]
  aB.Model     <- B.Models[[i]]
  
  # Create Walter's large table and run predictions
  WLT       <- data.table(  table(D$YEAR,D$MONTH,D$AREA_C)  )
  setnames(WLT,c("YEAR","MONTH","AREA_C","N"))
  WLT       <- select(WLT,-N)
  WLT$MODEL <- Model.Names[i]
  
  
  # Add median for continuous variables
  WLT$HOURS_FISHED <- median(D$HOURS_FISHED)
  WLT$NUM_GEAR     <- median(D$NUM_GEAR)
  WLT$PROP_UNID    <- median(D$PROP_UNID)
  WLT$TYPE_OF_DAY  <- "WD"
  WLT$PC1          <- median(D$PC1)
  WLT$PC2          <- median(D$PC2)
  
  # Predict expected values for all level combinations
  POSCPUE     <- predict.gam(aP.Model,newdata=WLT)
  WLT         <- cbind(WLT,POSCPUE)
  WLT$POSCPUE <- exp(WLT$POSCPUE)
  
  # Predict expected probabilities
  PROBCPUE     <- predict.gam(aB.Model,newdata=WLT)
  WLT          <- cbind(WLT,PROBCPUE)
  WLT$PROBCPUE <- inv.logit(WLT$PROBCPUE)
  
  # Put back together
  WLT$CPUE <- WLT$POSCPUE*WLT$PROBCPUE
  
  # Give AREAS proportional geographical weights
  RW  <- data.table(AREA_C=c("Tutuila","Bank","Manua"),WEIGHT=c(0.79,0.08,0.13))
  WLT <- merge(WLT,RW,by="AREA_C")
  
  WLT1 <- WLT[,list(TOTCPUE=sum(CPUE*WEIGHT),POSCPUE=mean(POSCPUE*WEIGHT),PROBCPUE=mean(PROBCPUE*WEIGHT)),by=list(MODEL,YEAR,MONTH)] # Sum abundance in all region, by regional weight
  WLT1 <- WLT1[,list(TOTCPUE=mean(TOTCPUE),POSCPUE=mean(POSCPUE),PROBCPUE=mean(PROBCPUE)),by=list(MODEL,YEAR)] # Average all 12 MONTHs per year
  
  WLT1$YEAR     <- as.numeric(WLT1$YEAR)
  WLT1$TOTCPUE  <- WLT1$TOTCPUE/mean(WLT1$TOTCPUE)*100
  WLT1$POSCPUE  <- WLT1$POSCPUE/mean(WLT1$POSCPUE)*100
  WLT1$PROBCPUE <- WLT1$PROBCPUE/mean(WLT1$PROBCPUE)*100
  
  Results[[i]] <- WLT1
}

Final   <- rbindlist(Results)

# Add nominal CPUE information
NOMI1         <- D[PRES>0,list(POSCPUE=mean(CPUE/HOURS_FISHED/NUM_GEAR)),by=list(YEAR)]
NOMI          <- D[,list(TOTCPUE=mean(CPUE/HOURS_FISHED/NUM_GEAR),PROBCPUE=mean(PRES/HOURS_FISHED/NUM_GEAR)),by=list(YEAR)]
NOMI          <- merge(NOMI,NOMI1,by="YEAR")
NOMI$TOTCPUE  <- NOMI$TOTCPUE/mean(NOMI$TOTCPUE)*100
NOMI$PROBCPUE <- NOMI$PROBCPUE/mean(NOMI$PROBCPUE)*100
NOMI$POSCPUE  <- NOMI$POSCPUE/mean(NOMI$POSCPUE)*100
NOMI$MODEL    <- "NOMI"
NOMI$YEAR     <- as.numeric(as.character((NOMI$YEAR)))
Final         <- rbind(Final,NOMI)

# Melt all types of cpue
Final <- melt(Final,id.var=1:2,variable.name="CPUE_TYPE",value.name="CPUE")

p1 <- ggplot(data=Final,aes(x=YEAR,group=MODEL))+geom_smooth(aes(y=CPUE,color=MODEL),se=F,span=0.2)+
      scale_color_manual(values=c("red", "blue", "green","orange","darkblue","darkgreen","purple","black"))+
      facet_wrap(~CPUE_TYPE)+theme_bw()

# Put model results together in a table
P.Results <- list(); B.Results <- list()
for(i in 1:length(P.Models)){
  
  aP.Table         <- data.table()
  aP.Model         <- P.Models[[i]]
  aP.Table$Formula <- as.character(summary(aP.Model)$formula[3])
  aP.Table$AIC     <- round(AIC(aP.Model),1)

  aB.Table         <- data.table()
  aB.Model         <- B.Models[[i]]
  aB.Table$Formula <- as.character(summary(aB.Model)$formula[3])
  aB.Table$AIC     <- round(AIC(aB.Model),1)

  P.Results[[i]] <- aP.Table
  B.Results[[i]] <- aB.Table

}

P.Final <- rbindlist(P.Results)
B.Final <- rbindlist(B.Results)

P.Final$DELT.AIC <- 0
P.Final[2:nrow(P.Final),]$DELT.AIC <- round(diff(P.Final$AIC),1)

B.Final$DELT.AIC <- 0
B.Final[2:nrow(B.Final),]$DELT.AIC <- round(diff(B.Final$AIC),1)





