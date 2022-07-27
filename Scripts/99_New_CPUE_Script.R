require(data.table); require(tidyverse); require(mgcv): require(RColorBrewer); require(openxlsx); require(boot); require(gridExtra); require(grid); require(viridis)

Sp <- "APRU"


root_dir <- this.path::here(.. = 1) # establish directories using this.path
#dir.create(paste0(root_dir,"/Outputs/SS3_Inputs/CPUE"),recursive=T,showWarnings=F)
#dir.create(paste0(root_dir,"/Outputs/Summary/CPUE figures"),recursive=T,showWarnings=F)

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
#C <- C[as.numeric(YEAR)>=minYr&as.numeric(YEAR)<=maxYr]; length(unique(C$INTERVIEW_PK))

D <- C[SPECIES==Sp]

table(D$AREA_C,D$YEAR) # All interviews
table(D[PRES==1]$AREA_C,D[PRES==1]$YEAR) # Pos-only interviews

# Merge Banks with Tutuila
D[AREA_C=="Bank"]$AREA_C <- "Tutuila" 


#if(Sp=="VALO"&Ar=="Manua") return(message("Cannot run VALO for Manua, since no good VALO data before 2015 and no data after 2010 in the Manuas."))
#if(Sp=="LERU"&Ar=="Manua")  return(message("No LERU data in the Manuas."))

nrow(D); nrow(D[CPUE>0]) # Check interview counts

# Remove years with no catches of this species (model can't make prediction for these years)
YR.CATCH <- D[,list(CPUE=sum(CPUE)),by=YEAR]
YR.CATCH <- YR.CATCH[CPUE>0]
YR.CATCH <- select(YR.CATCH,-CPUE)
D        <- merge(D,YR.CATCH,by="YEAR")

# Add data point weights so that each YxMxR strata have the same weight in the GAM  models
#WGHT.P                <- data.table(  table(D[CPUE>0]$YEAR,D[CPUE>0]$SEASON,D[CPUE>0]$AREA_C)  ); setnames(WGHT.P,c("YEAR","SEASON","AREA_C","N"))# }
#WGHT.P$Nobs_Nstrata   <- sum(WGHT.P$N)/nrow(WGHT.P[N>0]) # Add the Nobs / Nstrata ratio (note: I use the number of strata with at least 1 interview)
#WGHT.P$W.P            <- WGHT.P$Nobs_Nstrata * 1/WGHT.P$N
#WGHT.P[W.P==Inf]$W.P  <- 0
#WGHT.P                <- WGHT.P[order(YEAR,SEASON)]
#WGHT.P                <- select(WGHT.P,-N,-Nobs_Nstrata)
#D                     <- merge(D,WGHT.P,by=c("YEAR","SEASON","AREA_C"),all.x=T) #}

#WGHT.B                <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WGHT.B,c("YEAR","SEASON","AREA_C","N")) # }
#WGHT.B$Nobs_Nstrata   <- sum(WGHT.B$N)/nrow(WGHT.B[N>0]) # Add the Nobs / Nstrata ratio
#WGHT.B$W.B            <- WGHT.B$Nobs_Nstrata * 1/WGHT.B$N
#WGHT.B[W.B==Inf]$W.B  <- 0
#WGHT.B                <- WGHT.B[order(YEAR,SEASON)]
#WGHT.B                <- select(WGHT.B,-N,-Nobs_Nstrata)
#D                     <- merge(D,WGHT.B,by=c("YEAR","SEASON","AREA_C"),all.x=T)

# Cancel data weight calculations and revert to same weights for all points
D$W.B <- 1
D$W.P <- 1

D <- D[!(AREA_C=="Manua"&YEAR>=2009)] # Remove the 7 random post-2009 Manua interviews

# Backward selection: Positive catch-only models
Model.String  <- 'gam(data=D[CPUE>0],weights=W.P,log(CPUE)~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY, method="REML")'

aModel        <- eval(parse(text=Model.String))
PreviousAIC   <- AIC(aModel)
P.SelResults  <- data.table(DESCRIPTION="Full model",FORMULA=as.character(aModel$formula[3]),AIC=PreviousAIC,DELT_AIC=0)
for(i in 1:10){
  
  a             <- data.table( TERMS=rownames(anova(aModel)$pTerms.pv), PVALUE=as.numeric(anova(aModel)$pTerms.pv) )
  b             <- data.table( TERMS=rownames(anova(aModel)$s.table), PVALUE=as.numeric(anova(aModel)$s.table[,4]) )
  if((nrow(a)==1&nrow(b)==0)) break
  if(nrow(a)>0&nrow(b)>0)  c <- rbind(a,b)
  if(nrow(b)==0) c <- a
  if(nrow(a)==0) c <- b
  c             <- c[!(TERMS=="YEAR"|TERMS=="AREA_C")] # Keep those 2 variables, no matter what
  if (max(c$PVALUE)==0) break; # End model selection if the p-values left are so low, they equal "0"
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
    LastModel.P  <- aModel
  }
}

Best.P.Model.Formula   <- gsub(" ","",as.character(LastModel$formula[3]))
P.SelResults           <- rbind(P.SelResults,data.table(DESCRIPTION="Best model",FORMULA=as.character(LastModel$formula[3]),AIC=AIC(LastModel),DELT_AIC=0))
P.SelResults$CPUE_TYPE <- "Positive-only CPUE" 
P.SelResults           <- select(P.SelResults,CPUE_TYPE,DESCRIPTION,FORMULA,AIC,DELT_AIC)

# Backward selection: Probability of catch-only models
#Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR*AREA_C+s(HOURS_FISHED,k=3),family=binomial(link="logit"),method="REML")'


aModel        <- eval(parse(text=Model.String))
PreviousAIC   <- AIC(aModel)
B.SelResults  <- data.table(DESCRIPTION="Full model",FORMULA=as.character(aModel$formula[3]),AIC=PreviousAIC,DELT_AIC=0)
for(i in 1:10){
  
  a             <- data.table( TERMS=rownames(anova(aModel)$pTerms.pv), PVALUE=anova(aModel)$pTerms.pv )
  b             <- data.table( TERMS=rownames(anova(aModel)$s.table), PVALUE=anova(aModel)$s.table[,4] )
  if((nrow(a)==1&nrow(b)==0)) break
  if(nrow(a)>0&nrow(b)>0)  c <- rbind(a,b)
  if(nrow(b)==0) c <- a
  if(nrow(a)==0) c <- b
  c             <- c[!(TERMS=="YEAR"|TERMS=="AREA_C")] # Keep those 2 variables, no matter what
  if (max(c$PVALUE)==0) break; # End model selection if the p-values left are so low, they equal "0"
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
    LastModel.B  <- aModel
  }
}

#========================Generate standardized CPUE index for all models========================================
# Create Walter's large table template and add add median for continuous variables and most commmon variable for categorical ones
WLT <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WLT,c("YEAR","SEASON","AREA_C","N")) #}
WLT <- select(WLT,-N)
WLT$HOURS_FISHED <- median(D$HOURS_FISHED)
WLT$NUM_GEAR     <- median(D$NUM_GEAR)
WLT$TYPE_OF_DAY  <- "WD"
WLT$PC1          <- median(D$PC1)
WLT$PC2          <- median(D$PC2)
WLT$WINDSPEED    <- median(D$WINDSPEED)

# Give AREAS their geographical weights
WLT$WEIGHT                    <- 1.0 # This is the value for the Manua I. model, which only has 1 AREA_C
WLT[AREA_C=="Tutuila"]$WEIGHT <- 0.87
WLT[AREA_C=="Manua"]$WEIGHT   <- 0.13

# Calculate standardize index for all positive-only models
  aP.Model         <- LastModel.P # P.Models[[i]]
  aWLT             <- WLT
  aWLT$MODEL       <- P.Model.Names[i]$MODEL
  aWLT$MODEL_ORDER <- P.Model.Names[i]$MODEL_ORDER
  
  # Predict expected positive catch for all level combinations and calculate standard errors
  LOG.CPUE       <- predict.gam(aP.Model,newdata=WLT, se.fit=T)$fit
  SD.LOG.CPUE    <- predict.gam(aP.Model,newdata=WLT, se.fit=T)$se
  aWLT           <- cbind(aWLT,LOG.CPUE)
  aWLT           <- cbind(aWLT,SD.LOG.CPUE)
  aWLT$CPUE      <- exp(aWLT$LOG.CPUE+aWLT$SD.LOG.CPUE[i]^2/2 )
  aWLT$LOWER95   <- exp(aWLT$LOG.CPUE-1.96*aWLT$SD.LOG.CPUE)
  aWLT$UPPER95   <- exp(aWLT$LOG.CPUE+1.96*aWLT$SD.LOG.CPUE)
  aWLT$SD.CPUE   <- (aWLT$UPPER95-aWLT$LOWER95)/3.92
  aWLT$CPUE_TYPE <- "POS"
  Results.P       <- select(aWLT,CPUE_TYPE,YEAR,SEASON,AREA_C,WEIGHT,CPUE,SD.CPUE)


# Calculate standardize index for all probability of catch models
  aB.Model         <- LastModel.B # B.Models[[i]]
  aWLT             <- WLT
  aWLT$MODEL       <- B.Model.Names[i]$MODEL
  aWLT$MODEL_ORDER <- B.Model.Names[i]$MODEL_ORDER
  
  # Predict expected positive catch for all level combinations and calculate standard errors
  LOGIT.CPUE     <- predict.gam(aB.Model,newdata=aWLT,se.fit=T)$fit
  SD.LOGIT.CPUE  <- predict.gam(aB.Model,newdata=aWLT,se.fit=T)$se
  aWLT           <- cbind(aWLT,LOGIT.CPUE)
  aWLT           <- cbind(aWLT,SD.LOGIT.CPUE)
  aWLT$CPUE      <- inv.logit(aWLT$LOGIT.CPUE)
  aWLT$LOWER95   <- inv.logit(aWLT$LOGIT.CPUE-1.96*aWLT$SD.LOGIT.CPUE)
  aWLT$UPPER95   <- inv.logit(aWLT$LOGIT.CPUE+1.96*aWLT$SD.LOGIT.CPUE)
  aWLT$SD.CPUE   <- (aWLT$UPPER95-aWLT$LOWER95)/3.92
  aWLT$CPUE_TYPE <- "PROB"
  Results.B      <- select(aWLT,CPUE_TYPE,YEAR,SEASON,AREA_C,WEIGHT,CPUE,SD.CPUE)
  
# Combine all results in one table
Results      <- rbind(Results.P,Results.B)
Results$YEAR <- as.numeric(Results$YEAR)

# Calculate the combined CPUE for the best model only
Best.Mod <- Results
Best.Mod <- dcast(Best.Mod,YEAR+SEASON+AREA_C+WEIGHT~CPUE_TYPE,value.var=c("CPUE","SD.CPUE"))

Best.Mod$CPUE_TOT    <- Best.Mod$CPUE_POS*Best.Mod$CPUE_PROB
Best.Mod$SD.CPUE_TOT <- sqrt(  Best.Mod$SD.CPUE_POS^2*Best.Mod$SD.CPUE_PROB^2+Best.Mod$SD.CPUE_POS^2*Best.Mod$CPUE_PROB^2+Best.Mod$SD.CPUE_PROB^2*Best.Mod$CPUE_POS^2    )

# 3 options to fill missing Manua 2009-2021 years

Best.Mod <- select(Best.Mod,YEAR,SEASON,AREA_C,WEIGHT,CPUE_TOT,SD.CPUE_TOT)
LAST_5YR <- mean(Best.Mod[AREA_C=="Manua"&(YEAR>=2004&YEAR<2009)]$CPUE_TOT) # Manua CPUE average from 2004 to 2008 (last 5 years of good data)

Best.Mod$CPUE_TOTA <- Best.Mod$CPUE_TOT 
Best.Mod$CPUE_TOTB <- Best.Mod$CPUE_TOT

nyearpost2009 <- length(unique(Best.Mod[AREA_C=="Manua"&YEAR>=2009]$YEAR))
  
Best.Mod[AREA_C=="Manua"&YEAR>=2009]$CPUE_TOTA <- LAST_5YR*rep(1.05^seq(1,nyearpost2009,1),each=4) # Scenario 1: Increasing by 5% every year
Best.Mod[AREA_C=="Manua"&YEAR>=2009]$CPUE_TOTB <- LAST_5YR*rep(0.95^seq(1,nyearpost2009,1),each=4) # Scenario 2: Decreasing by 5% every year

# Compare Manua trends

MANUA_DATA <- Best.Mod[AREA_C=="Manua",list(CPUE_TOT=mean(CPUE_TOT),CPUE_TOTA=mean(CPUE_TOTA),CPUE_TOTB=mean(CPUE_TOTB)),by=list(YEAR,AREA_C)] # Average all 4 SEASONs per year
M1         <- ggplot(data=MANUA_DATA,aes(x=YEAR))+geom_line(aes(y=CPUE_TOTA),col="green",size=0.7)+geom_line(aes(y=CPUE_TOTB),col="red",size=0.7)+geom_line(aes(y=CPUE_TOT),col="black",size=0.7)+theme_bw()

Best.Mod <- Best.Mod[,list(CPUE_TOT=sum(CPUE_TOT*WEIGHT),SD.CPUE_TOT=sum(SD.CPUE_TOT*WEIGHT),CPUE_TOTA=sum(CPUE_TOTA*WEIGHT),CPUE_TOTB=sum(CPUE_TOTB*WEIGHT)),by=list(YEAR,SEASON)] # Sum abundance in all region, by regional weight
Best.Mod <- Best.Mod[,list(CPUE_TOT=mean(CPUE_TOT),SD.CPUE_TOT=mean(SD.CPUE_TOT),CPUE_TOTA=mean(CPUE_TOTA),CPUE_TOTB=mean(CPUE_TOTB)),by=list(YEAR)] # Average all 4 SEASONs per year

# Compare final CPUE trends
M2 <- ggplot(data=Best.Mod,aes(x=YEAR))+geom_ribbon(aes(ymin=(CPUE_TOT-SD.CPUE_TOT*1.0),ymax=(CPUE_TOT+SD.CPUE_TOT*1.96)),fill="lightgray")+
  geom_line(aes(y=CPUE_TOTA),col="green",size=0.7)+geom_line(aes(y=CPUE_TOTB),col="red",size=0.7)+
  geom_line(aes(y=CPUE_TOT),col="black",size=0.7)+theme_bw()

grid.arrange(M1,M2,ncol=1)



