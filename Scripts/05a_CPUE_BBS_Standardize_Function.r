Standardize_CPUE <- function(Sp, Ar,minYr,maxYr) {
  
  require(data.table); require(ggplot2); require(mgcv): require(dplyr); require(RColorBrewer); require(forcats); require(openxlsx); require(boot)
  
root_dir <- this.path::here(.. = 1) # establish directories using this.path

C <- readRDS(paste0(root_dir,"/Outputs/CPUE_C.rds")); length(unique(C$INTERVIEW_PK))
S <- data.table(  read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")  )
S <- select(S,SPECIES_PK,SPECIES)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
C <- merge(C,S,by.x="SPECIES_FK",by.y="SPECIES_PK")
C <- select(C,-SPECIES_FK)
length(unique(C$INTERVIEW_PK))

# Last filters
C <- C[NUM_GEAR<=6]; length(unique(C$INTERVIEW_PK))
C <- C[HOURS_FISHED<=24]; length(unique(C$INTERVIEW_PK))
C <- C[as.numeric(YEAR)>=minYr&as.numeric(YEAR)<=maxYr]; length(unique(C$INTERVIEW_PK))

D <- C[SPECIES==Sp]

# Run selections
if(Ar=="Tutuila") D <- D[AREA_C=="Tutuila"|AREA_C=="Bank"] 
if(Ar=="Manua")   D <- D[AREA_C=="Manua"&YEAR<=2008]

nrow(D); nrow(D[CPUE>0]) # Check interview counts

# Remove years with no catches of this species (model can't make prediction for these years)
YR.CATCH <- D[,list(CPUE=sum(CPUE)),by=YEAR]
YR.CATCH <- YR.CATCH[CPUE>0]
YR.CATCH <- select(YR.CATCH,-CPUE)
D        <- merge(D,YR.CATCH,by="YEAR")
D        <- droplevels(D)

# Add data point weights so that each YxMxR strata have the same weight in the GAM binomial models
if(Ar=="Tutuila"){ WGHT.B <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WGHT.B,c("YEAR","SEASON","AREA_C","N")) }
if(Ar=="Manua")  { WGHT.B <- data.table(  table(D$YEAR,D$SEASON)  )         ; setnames(WGHT.B,c("YEAR","SEASON","N"))          }

WGHT.B$Nobs_Nstrata   <- sum(WGHT.B$N)/nrow(WGHT.B[N>0]) # Add the Nobs / Nstrata ratio
WGHT.B$W.B            <- WGHT.B$Nobs_Nstrata * 1/WGHT.B$N
WGHT.B[W.B==Inf]$W.B  <- 0
WGHT.B                <- WGHT.B[order(YEAR,SEASON)]
WGHT.B                <- select(WGHT.B,-N,-Nobs_Nstrata)

# Add data weights so that each YxMxR strata have the same weight in the GAM models
if(Ar=="Tutuila"){ WGHT.P <- data.table(  table(D[CPUE>0]$YEAR,D[CPUE>0]$SEASON,D[CPUE>0]$AREA_C)  ); setnames(WGHT.P,c("YEAR","SEASON","AREA_C","N")) }
if(Ar=="Manua")  { WGHT.P <- data.table(  table(D[CPUE>0]$YEAR,D[CPUE>0]$SEASON)  )                 ; setnames(WGHT.P,c("YEAR","SEASON","N"))          }

WGHT.P$Nobs_Nstrata   <- sum(WGHT.P$N)/nrow(WGHT.P[N>0]) # Add the Nobs / Nstrata ratio (note: I use the number of strata with at least 1 interview)
WGHT.P$W.P            <- WGHT.P$Nobs_Nstrata * 1/WGHT.P$N
WGHT.P[W.P==Inf]$W.P  <- 0
WGHT.P                <- WGHT.P[order(YEAR,SEASON)]
WGHT.P                <- select(WGHT.P,-N,-Nobs_Nstrata)

if(Ar=="Tutuila"){ D <- merge(D,WGHT.B,by=c("YEAR","SEASON","AREA_C"),all.x=T)
                   D <- merge(D,WGHT.P,by=c("YEAR","SEASON","AREA_C"),all.x=T) }

if(Ar=="Manua"){   D <- merge(D,WGHT.B,by=c("YEAR","SEASON"),all.x=T)
                   D <- merge(D,WGHT.P,by=c("YEAR","SEASON"),all.x=T) }

# Backward selection: Positive catch-only models
Model.String  <- 'gam(data=D[CPUE>0],weights=W.P,log(CPUE)~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(PC1)+s(PC2)+s(PC3)+s(PC4)+TYPE_OF_DAY+AREA_C, method="REML")'
aModel        <- eval(parse(text=Model.String))
PreviousAIC   <- AIC(aModel)
P.SelResults  <- data.table(DESCRIPTION="Full model",FORMULA=as.character(aModel$formula[3]),AIC=PreviousAIC,DELT_AIC=0)
for(i in 1:10){
 
  a             <- data.table( TERMS=names(anova(aModel)$pTerms.pv), PVALUE=anova(aModel)$pTerms.pv )
  b             <- data.table( TERMS=names(anova(aModel)$s.table[,4]), PVALUE=anova(aModel)$s.table[,4] )
  c             <- rbind(a,b)
  c             <- c[TERMS!="YEAR"]
  RM            <- c[PVALUE==max(c$PVALUE)]$TERMS
  if(RM=="s(HOURS_FISHED)") RM <- "s(HOURS_FISHED,k=3)"
  if(RM=="s(NUM_GEAR)")     RM <- "s(NUM_GEAR,k=3)"
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  aModel        <- eval(parse(text=Model.String))
  NewAIC        <- AIC(aModel)
  Diff          <- NewAIC-PreviousAIC
  
  if(Diff>2){ break; } else { 
    
    P.SelResults <- rbind(P.SelResults,data.table(DESCRIPTION="Reduced model",FORMULA=gsub("+","-",RM,fixed=T),AIC=NewAIC,DELT_AIC=Diff))
    PreviousAIC  <- NewAIC 
    LastModel    <- aModel
    }
}

Best.P.Model.Formula <- gsub(" ","",as.character(LastModel$formula[3]))
P.SelResults         <- rbind(P.SelResults,data.table(DESCRIPTION="Best model",FORMULA=as.character(LastModel$formula[3]),AIC=AIC(LastModel),DELT_AIC=0))
P.SelResults$TYPE    <- "Positive-only" 
P.SelResults         <- select(P.SelResults,TYPE,DESCRIPTION,FORMULA,AIC,DELT_AIC)

# Backward selection: Probability of catch-only models
Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(PC1)+s(PC2)+s(PC3)+s(PC4)+TYPE_OF_DAY+AREA_C,family=binomial(link="logit"),method="REML")'
aModel        <- eval(parse(text=Model.String))
PreviousAIC   <- AIC(aModel)
B.SelResults  <- data.table(DESCRIPTION="Full model",FORMULA=as.character(aModel$formula[3]),AIC=PreviousAIC,DELT_AIC=0)
for(i in 1:10){
  
  a             <- data.table( TERMS=names(anova(aModel)$pTerms.pv), PVALUE=anova(aModel)$pTerms.pv )
  b             <- data.table( TERMS=names(anova(aModel)$s.table[,4]), PVALUE=anova(aModel)$s.table[,4] )
  c             <- rbind(a,b)
  c             <- c[TERMS!="YEAR"]
  RM            <- c[PVALUE==max(c$PVALUE)]$TERMS
  if(RM=="s(HOURS_FISHED)") RM <- "s(HOURS_FISHED,k=3)"
  if(RM=="s(NUM_GEAR)")     RM <- "s(NUM_GEAR,k=3)"
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  aModel        <- eval(parse(text=Model.String))
  NewAIC        <- AIC(aModel)
  Diff          <- NewAIC-PreviousAIC
  
  if(Diff>2){ break; } else { 
    
    B.SelResults <- rbind(B.SelResults,data.table(DESCRIPTION="Reduced model",FORMULA=gsub("+","-",RM,fixed=T),AIC=NewAIC,DELT_AIC=Diff))
    PreviousAIC  <- NewAIC 
    LastModel    <- aModel
  }
}

Best.B.Model.Formula <- gsub(" ","",as.character(LastModel$formula[3]))
B.SelResults         <- rbind(B.SelResults,data.table(DESCRIPTION="Best model",FORMULA=as.character(LastModel$formula[3]),AIC=AIC(LastModel),DELT_AIC=0))
B.SelResults$TYPE    <- "Presence" 
B.SelResults         <- select(B.SelResults,TYPE,DESCRIPTION,FORMULA,AIC,DELT_AIC)

# For model comparison purposes, take the final models and re-run simpler models to evaluate the effect of each variables
P.Models      <- list()
Model.String  <- paste0('gam(data=D[CPUE>0],weights=W.P,log(CPUE)~',Best.P.Model.Formula,',method="REML")')
for(i in 1:20){
  
  P.Models[[i]] <- eval(parse(text=Model.String))
  RM            <- gsub(" ","",as.character(P.Models[[i]]$formula[3]))
  RM            <- strsplit(RM,"\\+") 
  RM            <- RM[[1]][length(RM[[1]])]
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  if(RM=="+YEAR") break
}

B.Models      <- list()
Model.String  <- paste0('gam(data=D,weights=W.B,PRES~',Best.B.Model.Formula,',family=binomial(link="logit"),method="REML")')
for(i in 1:20){
  
  B.Models[[i]] <- eval(parse(text=Model.String))
  RM            <- gsub(" ","",as.character(B.Models[[i]]$formula[3]))
  RM            <- strsplit(RM,"\\+") 
  RM            <- RM[[1]][length(RM[[1]])]
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  if(RM=="+YEAR") break
}

# Make a list of model names for the figure legend
P.Model.Names <- data.table(MODEL=as.factor(as.character(P.Models[[1]]$formula[3])),ORDER=1)
TM            <- data.table(  MODEL=as.factor(as.character(strsplit( gsub(" ","",P.Model.Names$MODEL),"\\+"  )[[1]])), ORDER=1 )
TM$ORDER      <- seq((nrow(TM)+1),2)
P.Model.Names <- rbind(P.Model.Names,TM[-1,])
P.Model.Names$MODEL <- fct_reorder(P.Model.Names$MODEL,P.Model.Names$ORDER,min)
P.Model.Names <- select(P.Model.Names,-ORDER)

B.Model.Names <- data.table(MODEL=as.factor(as.character(B.Models[[1]]$formula[3])),ORDER=1)
TM            <- data.table(  MODEL=as.factor(as.character(strsplit( gsub(" ","",B.Model.Names$MODEL),"\\+"  )[[1]])), ORDER=1 )
TM$ORDER      <- seq((nrow(TM)+1),2)
B.Model.Names <- rbind(B.Model.Names,TM[-1,])
B.Model.Names$MODEL <- fct_reorder(B.Model.Names$MODEL,B.Model.Names$ORDER,min)
B.Model.Names <- select(B.Model.Names,-ORDER)

#========================Generate standardized CPUE index for all models========================================
# Create Walter's large table template
if(Ar=="Tutuila"){ WLT <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WLT,c("YEAR","SEASON","AREA_C","N")) }
if(Ar=="Manua")  { WLT <- data.table(  table(D$YEAR,D$SEASON)  )         ; setnames(WLT,c("YEAR","SEASON","N"))          }
WLT       <- select(WLT,-N)

# Add median for continuous variables
WLT$HOURS_FISHED <- median(D$HOURS_FISHED)
WLT$NUM_GEAR     <- median(D$NUM_GEAR)
WLT$TYPE_OF_DAY  <- "WD"
WLT$PC1          <- median(D$PC1)
WLT$PC2          <- median(D$PC2)
WLT$PC3          <- median(D$PC3)
WLT$PC4          <- median(D$PC4)

# Calculate standardize index for all positive-only models
Results.P <- list()
for(i in 1:length(P.Models)){
  
  aP.Model     <- P.Models[[i]]
  aWLT         <- WLT
  aWLT$MODEL.P <- P.Model.Names[i]

  # Predict expected positive catch for all level combinations and calculate standard errors
  LOG.POS.CPUE     <- predict.gam(aP.Model,newdata=WLT, se.fit=T)$fit
  SD.LOG.POS.CPUE  <- predict.gam(aP.Model,newdata=WLT, se.fit=T)$se
  aWLT             <- cbind(aWLT,LOG.POS.CPUE)
  aWLT             <- cbind(aWLT,SD.LOG.POS.CPUE)
  aWLT$POS.CPUE    <- exp(aWLT$LOG.POS.CPUE+aWLT$SD.LOG.POS.CPUE[i]^2/2 )
  aWLT$LOWER95.POS <- exp(aWLT$LOG.POS.CPUE-1.96*aWLT$SD.LOG.POS.CPUE)
  aWLT$UPPER95.POS <- exp(aWLT$LOG.POS.CPUE+1.96*aWLT$SD.LOG.POS.CPUE)
  aWLT$SD.POS.CPUE <- (aWLT$UPPER95.POS-aWLT$LOWER95.POS)/3.92
  Results.P[[i]]   <- select(aWLT,MODEL.P,YEAR,SEASON,AREA_C,POS.CPUE,SD.POS.CPUE)
}

# Calculate standardize index for all probability of catch models
Results.B <- list()
for(i in 1:length(B.Models)){
  
  aB.Model     <- B.Models[[i]]
  aWLT         <- WLT
  aWLT$MODEL.B <- B.Model.Names[i]
  
  # Predict expected positive catch for all level combinations and calculate standard errors
  LOGIT.PROB.CPUE     <- predict.gam(aB.Model,newdata=aWLT,se.fit=T)$fit
  SD.LOGIT.PROB.CPUE  <- predict.gam(aB.Model,newdata=aWLT,se.fit=T)$se
  aWLT                <- cbind(aWLT,LOGIT.PROB.CPUE)
  aWLT                <- cbind(aWLT,SD.LOGIT.PROB.CPUE)
  aWLT$PROB.CPUE      <- inv.logit(aWLT$LOGIT.PROB.CPUE)
  aWLT$LOWER95.PROB   <- inv.logit(aWLT$LOGIT.PROB.CPUE-1.96*aWLT$SD.LOGIT.PROB.CPUE)
  aWLT$UPPER95.PROB   <- inv.logit(aWLT$LOGIT.PROB.CPUE+1.96*aWLT$SD.LOGIT.PROB.CPUE)
  aWLT$SD.PROB.CPUE   <- (aWLT$UPPER95.PROB-aWLT$LOWER95.PROB)/3.92
  Results.B[[i]]      <- select(aWLT,MODEL.B,YEAR,SEASON,AREA_C,PROB.CPUE,SD.PROB.CPUE)
}

# Calculate the combined CPUE for the best model only
Best.Mod             <- merge(Results.P[[1]],Results.B[[1]],by=c("YEAR","SEASON","AREA_C"))
Best.Mod$TOT.CPUE    <- Best.Mod$POS.CPUE*Best.Mod$PROB.CPUE
Best.Mod$SD.TOT.CPUE <- sqrt(  Best.Mod$SD.POS.CPUE^2*Best.Mod$SD.PROB.CPUE^2+Best.Mod$SD.POS.CPUE^2*Best.Mod$PROB.CPUE^2+Best.Mod$SD.PROB.CPUE^2*Best.Mod$POS.CPUE^2    )

# Give AREAS their geographical weights
if(Ar=="Tutuila"){
  RW         <- data.table(AREA_C=c("Tutuila","Bank"),WEIGHT=c(0.91,0.09))
  Best.Mod <- merge(Best.Mod,RW,by="AREA_C")
} else { Best.Mod$WEIGHT=1.0 } # Give Manua a weight of "1"

Best.Mod <- Best.Mod[,list(TOT.CPUE=sum(TOT.CPUE*WEIGHT),SD.TOT.CPUE=sqrt(sum(SD.TOT.CPUE^2*WEIGHT^2)),POS.CPUE=sum(POS.CPUE*WEIGHT),PROB.CPUE=sum(PROB.CPUE*WEIGHT)),by=list(MODEL.P,MODEL.B,YEAR,SEASON)] # Sum abundance in all region, by regional weight
Best.Mod <- Best.Mod[,list(TOT.CPUE=mean(TOT.CPUE),SD.TOT.CPUE=mean(SD.TOT.CPUE),POS.CPUE=mean(POS.CPUE),PROB.CPUE=mean(PROB.CPUE)),by=list(MODEL.P,MODEL.B,YEAR)] # Average all 12 SEASONs per year

Best.Mod$YEAR            <- as.numeric(Best.Mod$YEAR)
Best.Mod$TOT.CPUE.STD    <- Best.Mod$TOT.CPUE/mean(Best.Mod$TOT.CPUE)*100
Best.Mod$SD.TOT.CPUE.STD <- Best.Mod$SD.TOT.CPUE/mean(Best.Mod$SD.TOT.CPUE)*100
Best.Mod$POS.CPUE.STD    <- Best.Mod$POS.CPUE/mean(Best.Mod$POS.CPUE)*100
Best.Mod$PROB.CPUE.STD   <- Best.Mod$PROB.CPUE/mean(Best.Mod$PROB.CPUE)*100

# Add nominal CPUE information
NOMI1              <- D[PRES>0,list(POS.CPUE=mean(CPUE/HOURS_FISHED/NUM_GEAR)),by=list(YEAR)]
NOMI               <- D[,list(TOT.CPUE=mean(CPUE/HOURS_FISHED/NUM_GEAR),PROB.CPUE=mean(PRES/HOURS_FISHED/NUM_GEAR)),by=list(YEAR)]
NOMI               <- merge(NOMI,NOMI1,by="YEAR")
NOMI$TOT.CPUE.STD  <- NOMI$TOT.CPUE/mean(NOMI$TOT.CPUE)*100
NOMI$PROB.CPUE.STD <- NOMI$PROB.CPUE/mean(NOMI$PROB.CPUE)*100
NOMI$POS.CPUE.STD  <- NOMI$POS.CPUE/mean(NOMI$POS.CPUE)*100
NOMI$MODEL.B <- NOMI$MODEL.P <- "NOMI"
NOMI$YEAR          <- as.numeric(as.character((NOMI$YEAR)))
NOMI               <- select(NOMI,MODEL.B,MODEL.P,YEAR,TOT.CPUE.STD,POS.CPUE.STD,PROB.CPUE.STD)

Best.Mod <- rbind(select(Best.Mod,MODEL.P,MODEL.B,YEAR,TOT.CPUE.STD,POS.CPUE.STD,PROB.CPUE.STD),NOMI) 
Best.Mod <- melt(Best.Mod,id.var=1:3,variable.name="CPUE_TYPE",value.name="CPUE")

# Best model vs. NOMI graph
ggplot(data=Best.Mod,aes(x=YEAR,y=CPUE))+geom_line(aes(col=MODEL.B))+facet_wrap(~CPUE_TYPE)






# Create trend comparison graphs
Results.P <- rbindlist(Results.P)
Results.B <- rbindlist(Results.B)





aWLT$PROB.CPUE.STD    <- aWLT$PROB.CPUE/mean(aWLT$PROB.CPUE)*100
aWLT$POS.CPUE.STD     <- aWLT$POS.CPUE/mean(aWLT$POS.CPUE)*100

aWLT <- aWLT[,list(POS.CPUE=mean(POS.CPUE)),by=list(MODEL.P,YEAR)] # Average all seasons per year
aWLT <- aWLT[,list(PROB.CPUE=mean(PROB.CPUE)),by=list(MODEL.B,YEAR)] # Average all seasons per year






Final   <- rbindlist(Results.P)

Final.Trend <- select(Final,MODEL,YEAR,TOT.CPUE,SD.TOT.CPUE) # Select CPUE trend for SS3 model
Final.Comp  <- select(Final,MODEL,YEAR,TOT.CPUE.STD,POS.CPUE.STD,PROB.CPUE.STD)






Final.Comp         <- rbind(Final.Comp,NOMI)

# Melt all types of cpue
Final.Comp <- melt(Final.Comp,id.var=1:2,variable.name="CPUE_TYPE",value.name="CPUE")





p1 <- ggplot(data=Final.Comp,aes(x=YEAR,group=MODEL))+geom_smooth(aes(y=CPUE,color=MODEL,linetype=MODEL),se=F,size=0.4)+theme_bw()+
       facet_wrap(~CPUE_TYPE,labeller=labeller(CPUE_TYPE=c("TOT.CPUE.STD"="Combined CPUE","POS.CPUE.STD"="Positive-only CPUE","PROB.CPUE.STD"="Probability CPUE")))+
       scale_linetype_manual(values=c("dashed","solid","solid","solid","solid","solid","solid","solid"))+scale_color_brewer(palette="Dark2")+
       theme(legend.text=element_text(size=6),legend.key.height = unit(0.2, 'cm'))+labs(col=paste0("Models (",Ar,")"),linetype=paste0("Models (",Ar,")"))+xlab("Year")
  
 ggsave(p1,file=paste0(root_dir,"/Outputs/Graphs/CPUE/",Sp,"_",Ar,"_Trends.png"),height=2,width=8,unit="in")

 windows(width=12,height=3);p1


 
 
 
# PUT TABLE RESULTS TOGETHER 
 
P.Final <- rbindlist(P.Results)
B.Final <- rbindlist(B.Results)

P.Final$DELT.AIC <- 0
P.Final[2:nrow(P.Final),]$DELT.AIC <- round(diff(P.Final$AIC),1)

B.Final$DELT.AIC <- 0
B.Final[2:nrow(B.Final),]$DELT.AIC <- round(diff(B.Final$AIC),1)

Final.Table <- rbind(B.Final,P.Final)
View(Final.Table)

# Add table to excel worksheet
File.Name  <- paste0(root_dir,"/Outputs/Graphs/CPUE/CPUE models.xlsx")
Sheet.Name <- paste0(Sp,"_",Ar)
wb         <- loadWorkbook(File.Name)
if(!(Sheet.Name %in% getSheetNames(File.Name))) addWorksheet(wb, sheetName = Sheet.Name)
writeData(wb, sheet = Sheet.Name, Final.Table,colNames=T)
setColWidths(wb,widths="auto",sheet=Sheet.Name,cols=1:10)
saveWorkbook(wb,File.Name,overwrite = T)

# Save final CPUE trend for SS model
saveRDS(Final.Trend,paste0(root_dir,"/Outputs/CPUE/CPUE_",Sp,"_",Ar,".rds"))

} # End of function

