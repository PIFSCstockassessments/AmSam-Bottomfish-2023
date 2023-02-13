Standardize_CPUE3 <- function(Sp, Interaction=T,minYr=2016,maxYr=2021) {
  
require(data.table); require(tidyverse); require(mgcv): require(DHARMa); require(mgcViz); require(RColorBrewer); require(openxlsx); require(boot); require(gridExtra); require(grid); require(viridis)

Model.Years <- paste0(minYr,"_",maxYr)
Fig.Folder  <- paste0(root_dir,"/Outputs/Summary/CPUE figures ",Model.Years)
SS.Folder   <- paste0(root_dir,"/Outputs/SS3_Inputs/CPUE_",Model.Years)
    
dir.create(SS.Folder,recursive=T,showWarnings=F)
dir.create(Fig.Folder,recursive=T,showWarnings=F)
                                                              
C <- readRDS(file.path(root_dir,"Outputs","CPUE_C.rds")); length(unique(C$INTERVIEW_PK))
S <- data.table(  read.xlsx(file.path(root_dir,"Data","METADATA.xlsx"),sheet="BMUS")  )
S <- select(S,SPECIES_PK,SPECIES)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
C <- merge(C,S,by.x="SPECIES_FK",by.y="SPECIES_PK")
C <- select(C,-SPECIES_FK)
length(unique(C$INTERVIEW_PK))

# Last filter
C <- C[as.numeric(YEAR)>=minYr&as.numeric(YEAR)<=maxYr]; length(unique(C$INTERVIEW_PK))
#C[AREA_C=="Bank"]$AREA_C <-"Tutuila" # Merge Bank with Tutuila 

# Select species
D <- C[SPECIES==Sp]

if(Sp=="LERU") D <- D[AREA_C!="Manua"] # Filter out Manua data for LERU, it's too bad to use

# Run selections
#if(Sp=="VALO")    D <- D[YEAR>=2016]

nrow(D); nrow(D[CPUE>0]) # Check interview counts

# Remove years with no catches of this species (model can't make prediction for these years)
YR.CATCH <- D[,list(CPUE=sum(CPUE)),by=YEAR]
YR.CATCH <- YR.CATCH[CPUE>0]
YR.CATCH <- select(YR.CATCH,-CPUE)
D        <- merge(D,YR.CATCH,by="YEAR")


# Add data point weights so that each YxMxR strata have the same weight in the GAM  models
WGHT.P                <- data.table(  table(D[CPUE>0]$YEAR,D[CPUE>0]$SEASON,D[CPUE>0]$AREA_C)  ); setnames(WGHT.P,c("YEAR","SEASON","AREA_C","N"))# }
WGHT.P$Nobs_Nstrata   <- sum(WGHT.P$N)/nrow(WGHT.P[N>0]) # Add the Nobs / Nstrata ratio (note: I use the number of strata with at least 1 interview)
WGHT.P$W.P            <- WGHT.P$Nobs_Nstrata * 1/WGHT.P$N
WGHT.P[W.P==Inf]$W.P  <- 0
WGHT.P                <- WGHT.P[order(YEAR,SEASON)]
WGHT.P                <- select(WGHT.P,-N,-Nobs_Nstrata)
D                     <- merge(D,WGHT.P,by=c("YEAR","SEASON","AREA_C"),all.x=T) #}

WGHT.B                <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WGHT.B,c("YEAR","SEASON","AREA_C","N")) # }
WGHT.B$Nobs_Nstrata   <- sum(WGHT.B$N)/nrow(WGHT.B[N>0]) # Add the Nobs / Nstrata ratio
WGHT.B$W.B            <- WGHT.B$Nobs_Nstrata * 1/WGHT.B$N
WGHT.B[W.B==Inf]$W.B  <- 0
WGHT.B                <- WGHT.B[order(YEAR,SEASON)]
WGHT.B                <- select(WGHT.B,-N,-Nobs_Nstrata)
D                     <- merge(D,WGHT.B,by=c("YEAR","SEASON","AREA_C"),all.x=T)

# Cancel data weight calculations and revert to same weights for all points
D$W.B <- 1
D$W.P <- 1

# Factors
D$AREA_C      <- factor(D$AREA_C) 
D$AREA_C      <- relevel(D$AREA_C, "Tutuila")
D$SEASON      <- factor(D$SEASON,levels=c("fall","spring","summer","winter"))
D$TYPE_OF_DAY <- factor(D$TYPE_OF_DAY,levels=c("WD","WE"))
D$YEAR        <- factor(D$YEAR)

# Backward selection: Positive catch-only models
if(Interaction==T){
  #interaction between area and year "YEAR:AREA_C"
   Model.String <- 'gam(data=D[CPUE>0],weights=W.P,log(CPUE)~YEAR+AREA_C+YEAR:AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY, method="REML")'
   
   out   <- tryCatch(eval(parse(text=Model.String)),error = function(e) e)
   Error <- any(class(out) == "error")
   
   if(Error==TRUE){
   Model.String <- 'gam(data=D[CPUE>0],weights=W.P,log(CPUE)~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(PC1)+TYPE_OF_DAY, method="REML")'
   }
   
} else{

   Model.String <- 'gam(data=D[CPUE>0],weights=W.P,log(CPUE)~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY, method="REML")'
}

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
  #c             <- c[!(TERMS=="YEAR")] # Keep those 2 variables, no matter what
  if(nrow(c)==0) break; #Stops if "c" variable list is empty
  if (max(c$PVALUE)==0) break; # End model selection if the p-values left are so low, they equal "0" 
  RM            <- c[PVALUE==max(c$PVALUE)]$TERMS
  if(RM=="s(HOURS_FISHED)") RM <- "s(HOURS_FISHED,k=3)"
  if(RM=="s(NUM_GEAR)")     RM <- "s(NUM_GEAR,k=3)"
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  LastModel     <- aModel
  aModel        <- eval(parse(text=Model.String))
  NewAIC        <- AIC(aModel)
  Diff          <- NewAIC-PreviousAIC
  
  if(Diff>2){ break; } else { 
    P.SelResults <- rbind(P.SelResults,data.table(DESCRIPTION="Reduced model",FORMULA=gsub("+","-",RM,fixed=T),AIC=NewAIC,DELT_AIC=Diff))
    PreviousAIC  <- NewAIC 
    LastModel    <- aModel
    }
}

Best.P.Model.Formula   <- gsub(" ","",as.character(LastModel$formula[3]))
P.SelResults           <- rbind(P.SelResults,data.table(DESCRIPTION="Best model",FORMULA=as.character(LastModel$formula[3]),AIC=AIC(LastModel),DELT_AIC=0))
P.SelResults$CPUE_TYPE <- "Positive-only CPUE" 
P.SelResults           <- select(P.SelResults,CPUE_TYPE,DESCRIPTION,FORMULA,AIC,DELT_AIC)

# Generate model diagnostic figures
par(mfrow=c(1,4))
gam.check(LastModel)
M1 <- recordPlot()
png(file.path(Fig.Folder,paste0(Sp,"_DiagsPos1.png")),width=8,height=2,unit="in",res=300)
replayPlot(M1)
dev.off()

N_nonlinear <- nrow(anova(LastModel)$s.table>0)
if(!is.null(N_nonlinear)){ # Check if there are nonlinear terms to plot
 par(mfrow=c(1,N_nonlinear))
 plot(LastModel,residuals=T,shade=T,shift = coef(LastModel)[1], seWithMean = TRUE)
 M2 <- recordPlot()
 png(file.path(Fig.Folder,paste0(Sp,"_DiagsPos2.png")),width=8,height=2,unit="in",res=300)
 replayPlot(M2)
 dev.off()
}

# Backward selection: Probability of catch-only models
if(Interaction==T){

  Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+YEAR:AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
  aModel        <- eval(parse(text=Model.String))
  
  if(aModel$outer.info$conv=="step failed"){ # If model failed to converge, likely due to interaction term. Remove.
  Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
  }
  
} else {
Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
}  

#if(Sp=="VALO"){
#  Model.String  <- 'gam(data=D,weights=W.B,PRES~YEAR+AREA_C+s(HOURS_FISHED,k=3)+s(NUM_GEAR,k=3)+SEASON+s(WINDSPEED)+s(PC1)+s(PC2)+TYPE_OF_DAY,family=binomial(link="logit"),method="REML")'
#}

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
  #c             <- c[!(TERMS=="YEAR")] # Keep those 2 variables, no matter what
  if(nrow(c)==0) break; #Stops if "c" variable list is empty
  if (max(c$PVALUE)==0) break; # End model selection if the p-values left are so low, they equal "0"
  RM            <- c[PVALUE==max(c$PVALUE)]$TERMS
  if(RM=="s(HOURS_FISHED)") RM <- "s(HOURS_FISHED,k=3)"
  if(RM=="s(NUM_GEAR)")     RM <- "s(NUM_GEAR,k=3)"
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  LastModel     <- aModel
  aModel        <- eval(parse(text=Model.String))
  NewAIC        <- AIC(aModel)
  Diff          <- NewAIC-PreviousAIC
  
  if(Diff>2){ break; } else {
    B.SelResults <- rbind(B.SelResults,data.table(DESCRIPTION="Reduced model",FORMULA=gsub("+","-",RM,fixed=T),AIC=NewAIC,DELT_AIC=Diff))
    PreviousAIC  <- NewAIC 
    LastModel    <- aModel
  }
}

Best.B.Model.Formula    <- gsub(" ","",as.character(LastModel$formula[3]))
B.SelResults            <- rbind(B.SelResults,data.table(DESCRIPTION="Best model",FORMULA=as.character(LastModel$formula[3]),AIC=AIC(LastModel),DELT_AIC=0))
B.SelResults$CPUE_TYPE  <- "Probability CPUE" 
B.SelResults            <- select(B.SelResults,CPUE_TYPE,DESCRIPTION,FORMULA,AIC,DELT_AIC)

# Check model results
par(mfrow=c(1,4))
gam.check(LastModel)
dev.off()

# QQ plots for logistic GAM using DHARMa package
#par(mfrow=c(1,4))
simulationOutput <- simulateResiduals(fittedModel = LastModel)
png(file.path(Fig.Folder,paste0(Sp,"_DiagsProb1.png")),width=1.27,height=1.27,unit="in",res=300,pointsize=5)
plotQQunif(simulationOutput, testDispersion = FALSE,testUniformity = FALSE,testOutliers = FALSE)
dev.off()

N_nonlinear <- nrow(anova(LastModel)$s.table>0)
if(!is.null(N_nonlinear)){ # Check if there are nonlinear terms to plot
  par(mfrow=c(1,N_nonlinear))
  plot(LastModel,trans=plogis,shade=T,residuals=T,shift = coef(LastModel)[1], seWithMean = TRUE)
  M2 <- recordPlot()
  png(file.path(Fig.Folder,paste0(Sp,"_DiagsProb2.png")),width=8,height=2,unit="in",res=300)
  replayPlot(M2)
  dev.off()
}

# Put final summary table together and export CPUE index for input into SS3 
Final          <- rbind(P.SelResults,B.SelResults)
Final$AIC      <- round(Final$AIC,1)
Final$DELT_AIC <- round(Final$DELT_AIC,1)

# Function to clean up model names
clean.formula <- function(text){
    text <- gsub("s\\(","",text)
    text <- gsub("\\)","",text)
    text <- gsub(", k = 3","",text)
    text <- gsub(",k=3","",text)
        return (text) }

Final$FORMULA   <- clean.formula(Final$FORMULA)
Final$TIMESTAMP <- format(Sys.time(), "%a %b %d %X %Y")
Final[2:nrow(Final)]$TIMESTAMP <- NA

# Add table to excel worksheet
File.Name    <- paste0(root_dir,"/Outputs/Summary/CPUE models_",Model.Years,".xlsx")
wb <- tryCatch({loadWorkbook(File.Name)}, error=function(e){createWorkbook()})
Sheet.Name   <- paste0(Sp,"_Int")
if(Sheet.Name %in% sheets(wb)) removeWorksheet(wb,Sheet.Name)
addWorksheet(wb, sheetName = Sheet.Name)
writeData(wb, sheet = Sheet.Name, Final,colNames=T)
setColWidths(wb,widths="auto",sheet=Sheet.Name,cols=1:10)
saveWorkbook(wb,File.Name,overwrite = T)

#==================CPUE index creation and comparison between models=============================


# This function finds Year x Area grids that don't have estimates and fills them with nearest neighbor values
Fill.Grid <- function(aModel){
  
  Fixed.Model <- aModel
  
  # Fill missing interaction terms grids with nearest value
  Coefs <- data.frame(VAL=Fixed.Model$coefficients )
  Coefs <- setDT(Coefs, keep.rownames = TRUE)[]
  setnames(Coefs,"rn","NAME")
  Coefs <- Coefs[grepl( ":", Coefs$NAME, fixed = TRUE)]
  
  Area.List <- c("Manua","Bank")
  for(a in 1:2){
    
    anArea <- Area.List[a] 
    aCoefs <- Coefs[grepl(anArea,Coefs$NAME,fixed=TRUE)]
    
    aCoefs[aCoefs==0] <- NA
    aCoefs <- fill(aCoefs,VAL,.direction = "downup" )
    
    Fixed.Model$coefficients[grepl(paste0(":AREA_C",anArea),names(Fixed.Model$coefficients),fixed=TRUE)] <- aCoefs$VAL # Replace "NAs" with nearest value
  }
  return(Fixed.Model)
}


# For model comparison purposes, take the final models and re-run simpler models to evaluate the effect of each variables
P.Models      <- list()
Model.String  <- paste0('gam(data=D[CPUE>0],weights=W.P,log(CPUE)~',Best.P.Model.Formula,',method="REML")')
for(i in 1:20){
  P.Models[[i]] <- eval(parse(text=Model.String))
  
  if(any(grepl(":",names(P.Models[[i]]$coefficients),fixed=TRUE))){ # Finds if interaction is present
  P.Models[[i]] <- Fill.Grid(P.Models[[i]])  
  }
  
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
  
  if(any(grepl(":",names(B.Models[[i]]$coefficients),fixed=TRUE))){ # Finds if interaction is present
    B.Models[[i]] <- Fill.Grid(B.Models[[i]])  
  }
  
  RM            <- gsub(" ","",as.character(B.Models[[i]]$formula[3]))
  RM            <- strsplit(RM,"\\+") 
  RM            <- RM[[1]][length(RM[[1]])]
  RM            <- paste0("+",RM)
  Model.String  <- gsub(RM,"",Model.String,fixed=T)
  if(RM=="+YEAR") break
}

# Make a list of model names for the figure legend
P.Model.Names       <- data.table(MODEL=clean.formula(P.Models[[1]]$formula[3]),MODEL_ORDER=1)
TM                  <- data.table(  MODEL=as.character(strsplit( gsub(" ","",P.Model.Names$MODEL),"\\+"  )[[1]]), MODEL_ORDER=1 )
TM$MODEL_ORDER      <- seq((nrow(TM)+1),2)
TM$MODEL            <- paste0("- ",TM$MODEL)
P.Model.Names       <- rbind(P.Model.Names,TM[-1,])
P.Model.Names       <- P.Model.Names[order(MODEL_ORDER)]

B.Model.Names       <- data.table(MODEL=clean.formula(B.Models[[1]]$formula[3]),MODEL_ORDER=1)
TM                  <- data.table(  MODEL=as.character(strsplit( gsub(" ","",B.Model.Names$MODEL),"\\+"  )[[1]]), MODEL_ORDER=1 )
TM$MODEL_ORDER      <- seq((nrow(TM)+1),2)
TM$MODEL            <- paste0("- ",TM$MODEL)
B.Model.Names       <- rbind(B.Model.Names,TM[-1,])
B.Model.Names       <- B.Model.Names[order(MODEL_ORDER)]

#========================Generate standardized CPUE index for all models========================================
# Create Walter's large table template and add add median for continuous variables and most common variable for categorical ones
WLT <- data.table(  table(D$YEAR,D$SEASON,D$AREA_C)  ); setnames(WLT,c("YEAR","SEASON","AREA_C","N")) #}
WLT <- select(WLT,-N)
WLT$HOURS_FISHED <- median(D$HOURS_FISHED)
WLT$NUM_GEAR     <- median(D$NUM_GEAR)
WLT$TYPE_OF_DAY  <- "WD"
WLT$PC1          <- median(D$PC1)
WLT$PC2          <- median(D$PC2)
WLT$WINDSPEED    <- median(D$WINDSPEED)

# Give AREAS their geographical weights
WLT$WEIGHT                    <- 1.0
WLT[AREA_C=="Tutuila"]$WEIGHT <- 0.79
WLT[AREA_C=="Bank"]$WEIGHT    <- 0.08
WLT[AREA_C=="Manua"]$WEIGHT   <- 0.13

# Calculate standardize index for all positive-only models
Results.P <- list()
for(i in 1:length(P.Models)){
  
  aP.Model         <- P.Models[[i]]
  aWLT             <- WLT
  aWLT$MODEL       <- P.Model.Names[i]$MODEL
  aWLT$MODEL_ORDER <- P.Model.Names[i]$MODEL_ORDER
  
  # Predict expected positive catch for all level combinations and calculate standard errors
  LOG.CPUE       <- predict.gam(aP.Model,newdata=aWLT, se.fit=T)$fit 
  SD.LOG.CPUE    <- predict.gam(aP.Model,newdata=aWLT, se.fit=T)$se  
  aWLT           <- cbind(aWLT,LOG.CPUE)
  aWLT           <- cbind(aWLT,SD.LOG.CPUE)
  aWLT$CPUE      <- exp(aWLT$LOG.CPUE+aWLT$SD.LOG.CPUE[i]^2/2 )
  aWLT$LOWER95   <- exp(aWLT$LOG.CPUE-1.96*aWLT$SD.LOG.CPUE)
  aWLT$UPPER95   <- exp(aWLT$LOG.CPUE+1.96*aWLT$SD.LOG.CPUE)
  aWLT$SD.CPUE   <- (aWLT$UPPER95-aWLT$LOWER95)/3.92
  aWLT$CPUE_TYPE <- "POS"
  Results.P[[i]] <- select(aWLT,CPUE_TYPE,MODEL,MODEL_ORDER,YEAR,SEASON,AREA_C,WEIGHT,CPUE,SD.CPUE)
}

# Calculate standardize index for all probability of catch models
Results.B <- list()
for(i in 1:length(B.Models)){
  
  aB.Model         <- B.Models[[i]]
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
  Results.B[[i]] <- select(aWLT,CPUE_TYPE,MODEL,MODEL_ORDER,YEAR,SEASON,AREA_C,WEIGHT,CPUE,SD.CPUE)
}

# Combine all results in one table
Results      <- rbind(rbindlist(Results.P),rbindlist(Results.B))
Results$YEAR <- as.numeric(Results$YEAR)

# Calculate the combined CPUE for the best model only
Best.Mod <- Results[MODEL_ORDER==1]
Best.Mod <- dcast(Best.Mod,YEAR+SEASON+AREA_C+WEIGHT~CPUE_TYPE,value.var=c("MODEL","CPUE","SD.CPUE"))

Best.Mod$CPUE_TOT    <- Best.Mod$CPUE_POS*Best.Mod$CPUE_PROB
Best.Mod$SD.CPUE_TOT <- sqrt(  Best.Mod$SD.CPUE_POS^2*Best.Mod$SD.CPUE_PROB^2+Best.Mod$SD.CPUE_POS^2*Best.Mod$CPUE_PROB^2+Best.Mod$SD.CPUE_PROB^2*Best.Mod$CPUE_POS^2    )

# These 2 lines are to export the CPUE timeseries before merging the two areas (for diagnostic purposes only)
#Best.Mod <- Best.Mod[,list(CPUE_TOT=mean(CPUE_TOT),SD.CPUE_TOT=mean(SD.CPUE_TOT),CPUE_POS=mean(CPUE_POS),CPUE_PROB=mean(CPUE_PROB)),by=list(MODEL_POS,MODEL_PROB,AREA_C,YEAR)] # Average all 12 SEASONs per year
#write.xlsx(Best.Mod,file=paste0(root_dir,"/Outputs/Summary/CPUE_APRU_TutVMan2.xlsx"))

Best.Mod <- Best.Mod[,list(CPUE_TOT=sum(CPUE_TOT*WEIGHT),SD.CPUE_TOT=sqrt(sum(SD.CPUE_TOT^2*WEIGHT^2)),CPUE_POS=sum(CPUE_POS*WEIGHT),CPUE_PROB=sum(CPUE_PROB*WEIGHT)),by=list(MODEL_POS,MODEL_PROB,YEAR,SEASON)] # Sum abundance in all region, by regional weight
Best.Mod <- Best.Mod[,list(CPUE_TOT=mean(CPUE_TOT),SD.CPUE_TOT=mean(SD.CPUE_TOT),CPUE_POS=mean(CPUE_POS),CPUE_PROB=mean(CPUE_PROB)),by=list(MODEL_POS,MODEL_PROB,YEAR)] # Average all 12 SEASONs per year

Best.Mod$CPUE_TOT.STD    <- Best.Mod$CPUE_TOT/mean(Best.Mod$CPUE_TOT)*100
Best.Mod$SD.CPUE_TOT.STD <- Best.Mod$SD.CPUE_TOT/mean(Best.Mod$SD.CPUE_TOT)*100
Best.Mod$CPUE_POS.STD    <- Best.Mod$CPUE_POS/mean(Best.Mod$CPUE_POS)*100
Best.Mod$CPUE_PROB.STD   <- Best.Mod$CPUE_PROB/mean(Best.Mod$CPUE_PROB)*100

Best.Mod$LOGSD.CPUE_TOT <- sqrt( log((Best.Mod$SD.CPUE_TOT/Best.Mod$CPUE_TOT)^2+1)   )

# Save final CPUE trend for SS model
Best.Mod.Final <- select(Best.Mod,YEAR,CPUE_TOT,LOGSD.CPUE_TOT)
Best.Mod.Final[LOGSD.CPUE_TOT<0.2]$LOGSD.CPUE_TOT <- 0.2 # Insure that the CV for any year is at least 0.2
  
write.csv(Best.Mod.Final,file=file.path(SS.Folder,paste0("CPUE_",Sp,"_",Model.Years,".csv")),row.names =F)

# Add nominal CPUE information
NOMI1              <- D[PRES>0,list(CPUE_POS=mean(CPUE)),by=list(YEAR,SEASON,AREA_C)]
NOMI               <- D[,list(CPUE_TOT=mean(CPUE),CPUE_PROB=mean(PRES)),by=list(YEAR,SEASON,AREA_C)]
NOMI               <- merge(NOMI,NOMI1,by=c("YEAR","SEASON","AREA_C"))
NOMI$CPUE_TOT      <- NOMI$CPUE_PROB*NOMI$CPUE_POS
NOMI$WEIGHT                    <- 1.0 # This is the value for the Manua I. model, which only has 1 AREA_C
NOMI[AREA_C=="Tutuila"]$WEIGHT <- 0.79
NOMI[AREA_C=="Bank"]$WEIGHT    <- 0.08
NOMI[AREA_C=="Manua"]$WEIGHT   <- 0.13
NOMI <- NOMI[,list(CPUE_TOT=sum(CPUE_TOT*WEIGHT),CPUE_POS=sum(CPUE_POS*WEIGHT),CPUE_PROB=sum(CPUE_PROB*WEIGHT)),by=list(YEAR,SEASON)] # Sum abundance in all region, by regional weight
NOMI <- NOMI[,list(CPUE_TOT=mean(CPUE_TOT),CPUE_POS=mean(CPUE_POS),CPUE_PROB=mean(CPUE_PROB)),by=list(YEAR)] # Average all 12 SEASONs per year
NOMI$CPUE_TOT.STD  <- NOMI$CPUE_TOT/mean(NOMI$CPUE_TOT)*100
NOMI$CPUE_PROB.STD <- NOMI$CPUE_PROB/mean(NOMI$CPUE_PROB)*100
NOMI$CPUE_POS.STD  <- NOMI$CPUE_POS/mean(NOMI$CPUE_POS)*100
NOMI$MODEL_PROB    <- NOMI$MODEL_POS <- "NOMI"
NOMI$YEAR          <- as.numeric(as.character((NOMI$YEAR)))
NOMI               <- select(NOMI,MODEL_PROB,MODEL_POS,YEAR,CPUE_TOT.STD,CPUE_POS.STD,CPUE_PROB.STD)

Best.Mod <- rbind(select(Best.Mod,MODEL_POS,MODEL_PROB,YEAR,CPUE_TOT.STD,CPUE_POS.STD,CPUE_PROB.STD),NOMI) 
Best.Mod <- melt(Best.Mod,id.var=1:3,variable.name="CPUE_TYPE",value.name="CPUE")

Best.Mod$MODLABEL <- paste0("Non-zero model\n",str_wrap(Best.Mod$MODEL_POS,20),"\nProb. of catch model\n",str_wrap(Best.Mod$MODEL_PROB,20))
Best.Mod[MODEL_POS=="NOMI"]$MODLABEL <- "Nominal"

# Best model vs. NOMI graph
P1 <- ggplot(data=Best.Mod,aes(x=YEAR,y=CPUE,col=MODLABEL))+geom_line()+
       facet_wrap(~CPUE_TYPE,labeller=labeller(CPUE_TYPE=c("CPUE_TOT.STD"="Combined CPUE","CPUE_POS.STD"="Non-zero CPUE","CPUE_PROB.STD"="Prob. of catch CPUE")))+
       labs(col=paste0("Model type"),linetype=paste0("Model type"))+xlab("Year")+ylab("Standard CPUE (%)")+theme_bw()+
       theme(axis.title=element_text(size=8),legend.text=element_text(size=6),legend.key.height=unit(1.5,'cm'))

#print(P1)
ggsave(P1,file=file.path(Fig.Folder,paste0(Sp,"_Inter","_BestModel.png")),height=2,width=8,unit="in")


#=======================Create trend comparison graphs==============================
Comp.Mod <- Results[,list(CPUE=sum(CPUE*WEIGHT)),by=list(CPUE_TYPE,MODEL,MODEL_ORDER,YEAR,SEASON)] # Sum abundance in all region, by regional weight
Comp.Mod <- Comp.Mod[,list(CPUE=mean(CPUE)),by=list(CPUE_TYPE,MODEL,MODEL_ORDER,YEAR)] # Average all 12 SEASONs per year

Comp.AllYrs       <- Comp.Mod[,list(CPUE.ALLYRS=mean(CPUE)),by=list(CPUE_TYPE,MODEL,MODEL_ORDER)] # Average all 12 SEASONs per year
Comp.Mod          <- merge(Comp.Mod,Comp.AllYrs,by=c("CPUE_TYPE","MODEL","MODEL_ORDER"))
Comp.Mod$CPUE.STD <- Comp.Mod$CPUE/Comp.Mod$CPUE.ALLYRS*100
Comp.Mod$YEAR     <- as.numeric(Comp.Mod$YEAR)
Comp.Mod          <- select(Comp.Mod,-CPUE.ALLYRS)

Comp.Mod.P       <- Comp.Mod[CPUE_TYPE=="POS"]
Comp.Mod.P$MODEL <- fct_reorder(as.factor(Comp.Mod.P$MODEL),Comp.Mod.P$MODEL_ORDER,min)
levels(Comp.Mod.P$MODEL) <- str_wrap(levels(Comp.Mod.P$MODEL),20)
Comp.Mod.B       <- Comp.Mod[CPUE_TYPE=="PROB"]
Comp.Mod.B$MODEL <- fct_reorder(as.factor(Comp.Mod.B$MODEL),Comp.Mod.B$MODEL_ORDER,min)
levels(Comp.Mod.B$MODEL) <- str_wrap(levels(Comp.Mod.B$MODEL),20)


P3 <- ggplot()+geom_line(data=NOMI,aes(x=YEAR,y=CPUE_POS.STD),col="lightgray",size=3)+
       geom_line(data=Comp.Mod.P,aes(x=YEAR,y=CPUE.STD,col=MODEL))+
       scale_color_viridis(option="viridis",discrete=T,direction=1)+
       xlab("Year")+ylab("Non-zero CPUE (%)")+
       theme_bw()+theme(legend.position="right",axis.title=element_text(size=8),legend.title=element_blank(),legend.text=element_text(size=6),legend.key.height=unit(0.1,'cm'))

P4 <- ggplot()+geom_line(data=NOMI,aes(x=YEAR,y=CPUE_PROB.STD),col="lightgray",size=3)+
       geom_line(data=Comp.Mod.B,aes(x=YEAR,y=CPUE.STD,col=MODEL))+
       scale_color_viridis(option="viridis",discrete=T,direction=1)+
       xlab("Year")+ylab("Prob. of catch CPUE (%)")+
       theme_bw()+theme(legend.position="right",axis.title=element_text(size=8),legend.title=element_blank(),legend.text=element_text(size=6),legend.key.height=unit(0.1,'cm'))

gA <- ggplotGrob(P3)
gB <- ggplotGrob(P4)
Comp.Graph <- cbind(gA,gB)
ggsave(Comp.Graph,file=file.path(Fig.Folder,paste0(Sp,"_Inter","_ModelComps.png")),height=2,width=8,unit="in")

print(paste("Done with", Sp))

} # End of function

