require(dplyr); require(this.path); require(data.table);require(openxlsx); require(ggplot2); require(ggfortify)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path

C <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_B.rds")))
C <- C[METHOD_FK==4] # Only do CPUE with bottomfishing gear (not BTM)
C <- C[,list(LBS=sum(EST_LBS)),by=list(INTERVIEW_PK,YEAR,MONTH,TYPE_OF_DAY,AREA_C,WINDSPEED,PROP_UNID,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]

C$SPECIES_FK <- paste0("S",C$SPECIES_FK)

No.variables <- ncol(C)-1

length(unique(C$INTERVIEW_PK))

#======= Calculate uku targeting principal component values (Winker et al. 2013)============

#Determine which species to include in the xij variables which is 0 or 1 for each trip j, if species i is caught in it. 
#Use those species i making up 99% of the cumulative catch
SP_CATCH           <- C[,list(LBS=sum(LBS)),by=list(SPECIES_FK)]
SP_CATCH           <- SP_CATCH[order(LBS)]
SP_CATCH$PROP      <- SP_CATCH$LBS/sum(SP_CATCH$LBS)
SP_CATCH$CUMU      <- cumsum(SP_CATCH$LBS)
SP_CATCH$CUMU_PROP <- round(SP_CATCH$CUMU/sum(SP_CATCH$LBS),4)
SP_REJECT          <- SP_CATCH[PROP<0.01]      # Drop SPECIES_FK corresponding to less than 1% of total catch (Winker et al. 2013)
No.SPECIES_FK      <- length(unique(SP_CATCH[PROP>0.01]$SPECIES_FK))

# Only keep the SPECIES_FK making up 99% of the catch
D <- dcast(C,INTERVIEW_PK+YEAR+MONTH+TYPE_OF_DAY+AREA_C+WINDSPEED+PROP_UNID+HOURS_FISHED+NUM_GEAR~SPECIES_FK,value.var="LBS",fill=0)
D <- D[,(SP_REJECT$SPECIES_FK):=NULL]
D <- data.table(D)

# Calculate prop. of each SPECIES_FK per trip
PROPS               <- D[,(No.variables+1):ncol(D)]/rowSums(D[,(No.variables+1):ncol(D)])
PROPS[is.na(PROPS)] <- 0 
PROPS               <- (PROPS)^(1/4) # Fourth-root transformation to increase weight of rarer SPECIES_FK
#PROPS               <- PROPS[rowSums(PROPS)>0,]

PCA <- prcomp(PROPS,center=T,scale.=T)
summary(PCA)

autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# Implement non-graphical Scree test to select best PCs (Winker et al. 2014)
require(nFactors)
eigenvalues <- PCA$sdev^2   # Extracts the observed eigenvalues
nsubjects   <- nrow(PROPS)  # Extracts the number of subjects
variables   <- length(eigenvalues) # Computes the number of variables   
rep         <- 100 # Number of replications for PA analysis
cent        <- 0.95 # Centile value of PA analysis

## PARALLEL ANALYSIS (qevpea for the centile criterion, mevpea for the mean criterion)
aparallel <- parallel(var = variables,
                      subject = nsubjects,
                      rep = rep,
                      cent = cent)$eigen$qevpea  

## NUMBER OF FACTORS RETAINED ACCORDING TO DIFFERENT RULES
results <- nScree(x=eigenvalues, aparallel=aparallel)
NF      <- results$Analysis
plotnScree(results)

# Number of factors to keep for CPUE standardization model is the min of the Optimal Coordinate and Kaiser rule (Winker 2014)
for(i in 1:variables) if(NF$Eigenvalues[i]>=1&(NF$Eigenvalues[i]>=NF$Pred.eig[i])){PC_KEEP<-i}else{break} 

# Add first four principal components back in dataset
E <- cbind(D[,1:(No.variables-1)],PCA$x[,1:4],PC_KEEP)

# Save this record
E <- dplyr::select(E,TRIP,FYEAR,MONTH,DATE,FISHER,CUM_EXP,LAT,LONG,SPEED,XDIR,YDIR,AREA,AREA_A,AREA_B,AREA_C,PC1,PC2,PC3,PC4,PC_KEEP,HOURS,UKUCPUE=S20)

E <- E[order(DATE,AREA_C,TRIP)]


