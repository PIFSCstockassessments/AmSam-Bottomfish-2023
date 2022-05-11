Standardize_CPUE <- function(Sp, Ar) {
  
  require(data.table); require(ggplot2); require(mgcv): require(dplyr); require(RColorBrewer); require(forcats); require(openxlsx); require(boot)
  
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

# Add data weights so that each YxMxR strata have the same weight in the GAM models
if(Ar=="Tutuila"){ WGHT <- data.table(  table(D$YEAR,D$MONTH,D$AREA_C)  ); setnames(WGHT,c("YEAR","MONTH","AREA_C","N")) }
if(Ar=="Manua")  { WGHT <- data.table(  table(D$YEAR,D$MONTH)  )         ; setnames(WGHT,c("YEAR","MONTH","N"))          }

WGHT$Nobs_Nstrata        <- sum(WGHT$N)/nrow(WGHT[N>0]) # Add the Nobs / Nstrata ratio
WGHT$STAT.W              <- WGHT$Nobs_Nstrata * 1/WGHT$N
WGHT[STAT.W==Inf]$STAT.W <- 0
WGHT                     <- WGHT[order(YEAR,MONTH)]
WGHT                     <- select(WGHT,-N,-Nobs_Nstrata)

if(Ar=="Tutuila") D <- merge(D,WGHT,by=c("YEAR","MONTH","AREA_C"))
if(Ar=="Manua")   D <- merge(D,WGHT,by=c("YEAR","MONTH"))

# Run standardization models 
P.Models      <- list()
P.Models[[1]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR, method="REML")
P.Models[[2]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3), method="REML")
P.Models[[3]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH, method="REML")
P.Models[[4]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2), method="REML")
P.Models[[5]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID), method="REML")
P.Models[[6]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID)+TYPE_OF_DAY, method="REML")
if(Ar=="Tutuila") P.Models[[7]] <- gam(data=D[CPUE>0],weights=STAT.W,log(CPUE)~YEAR+s(HOURS_FISHED)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID)+TYPE_OF_DAY+AREA_C, method="REML")

B.Models      <- list()
B.Models[[1]] <- gam(data=D,weights=STAT.W,PRES~YEAR,family=binomial(link="logit"), method="REML")
B.Models[[2]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3),family=binomial(link="logit"), method="REML")
B.Models[[3]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH,family=binomial(link="logit"), method="REML")
B.Models[[4]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2),family=binomial(link="logit"), method="REML")
B.Models[[5]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID),family=binomial(link="logit"), method="REML")
B.Models[[6]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID)+TYPE_OF_DAY,family=binomial(link="logit"), method="REML")
if(Ar=="Tutuila") B.Models[[7]] <- gam(data=D,weights=STAT.W,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+MONTH+s(PC1,PC2)+s(PROP_UNID)+TYPE_OF_DAY+AREA_C,family=binomial(link="logit"), method="REML")

if(Ar=="Tutuila") Model.Names <- data.table(MODEL=as.factor(c("NOMI","YEAR","+HOURS_FISHED+NUM_GEAR","+MONTH","+s(PC1,PC2)","+PROP_UNID","+TYPE_OF_DAY","+AREA")),ORDER=c(1,2,3,4,5,6,7,8))
if(Ar=="Manua")   Model.Names <- data.table(MODEL=as.factor(c("NOMI","YEAR","+HOURS_FISHED+NUM_GEAR","+MONTH","+s(PC1,PC2)","+PROP_UNID","+TYPE_OF_DAY")),ORDER=c(1,2,3,4,5,6,7))
Model.Names$MODEL             <- fct_reorder(Model.Names$MODEL,Model.Names$ORDER,min)
Model.Names                   <- select(Model.Names,-ORDER)

# Generate standardized CPUE trends for all models
Results <- list()
for(i in 1:length(B.Models)){
  
  aP.Model <- P.Models[[i]]
  aB.Model <- B.Models[[i]]
  
  # Create Walter's large table and run predictions
  if(Ar=="Tutuila"){ WLT <- data.table(  table(D$YEAR,D$MONTH,D$AREA_C)  ); setnames(WLT,c("YEAR","MONTH","AREA_C","N")) }
  if(Ar=="Manua")  { WLT <- data.table(  table(D$YEAR,D$MONTH)  )         ; setnames(WLT,c("YEAR","MONTH","N"))          }
  WLT       <- select(WLT,-N)
  WLT$MODEL <- Model.Names[i+1]
  
  
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
  if(Ar=="Tutuila"){
   RW  <- data.table(AREA_C=c("Tutuila","Bank","Manua"),WEIGHT=c(0.91,0.09))
   WLT <- merge(WLT,RW,by="AREA_C")
  } else { WLT$WEIGHT=1.0 } # Give Manua a weight of "1"
  
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

p1 <- ggplot(data=Final,aes(x=YEAR,group=MODEL))+geom_smooth(aes(y=CPUE,color=MODEL,linetype=MODEL),se=F,size=0.4)+theme_bw()+
       facet_wrap(~CPUE_TYPE,labeller=labeller(CPUE_TYPE=c("TOTCPUE"="Combined CPUE","POSCPUE"="Positive-only CPUE","PROBCPUE"="Probability CPUE")))+
       scale_linetype_manual(values=c("dashed","solid","solid","solid","solid","solid","solid","solid"))+scale_color_brewer(palette="Dark2")+
       theme(legend.text=element_text(size=6),legend.key.height = unit(0.2, 'cm'))+labs(col=paste0("Models (",Ar,")"),linetype=paste0("Models (",Ar,")"))+xlab("Year")
  
 ggsave(p1,file=paste0(root_dir,"/Outputs/Graphs/CPUE/",Sp,"_",Ar,"_Trends.png"),height=2,width=8,unit="in")


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

Final.Table <- rbind(B.Final,P.Final)

# Add table to excel worksheet
File.Name  <- paste0(root_dir,"/Outputs/Graphs/CPUE/CPUE models.xlsx")
Sheet.Name <- paste0(Sp,"_",Ar)
wb         <- loadWorkbook(File.Name)
if(!(Sheet.Name %in% getSheetNames(File.Name))) addWorksheet(wb, sheetName = Sheet.Name)
writeData(wb, sheet = Sheet.Name, Final.Table,colNames=T)
setColWidths(wb,widths="auto",sheet=Sheet.Name,cols=1:10)
saveWorkbook(wb,File.Name,overwrite = T)

# Print results
#windows(width=12,height=3);p1;View(Final.Table)



} # End of function

