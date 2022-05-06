require(dplyr); require(this.path); require(data.table);require(openxlsx)
options(scipen=999)		              # this option just forces R to never use scientific notation
root_dir <- this.path::here(.. = 1) # establish directories using this.path


G <- readRDS(paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))

#======= Calculate uku targeting principal component values (Winker et al. 2013)============
require(data.table); require(dplyr); require(ggplot2); require(ggfortify)
C <- readRDS(paste0("Outputs/CPUE_",Gear.name,"_StepB.rds"))
C$SPECIES <- paste0("S",C$SPECIES)

#Determine which species to include in the xij variables which is 0 or 1 for each trip j, if species i is caught in it. 
#Use those species i making up 99% of the cumulative catch
SP_CATCH           <- C[,list(LBS=sum(LBS)),by=list(SPECIES)]
SP_CATCH           <- SP_CATCH[SPECIES!=999&SPECIES!=20]  # Remove unknown species and uku
SP_CATCH           <- SP_CATCH[order(LBS)]
SP_CATCH$PROP      <- SP_CATCH$LBS/sum(SP_CATCH$LBS)
SP_CATCH$CUMU      <- cumsum(SP_CATCH$LBS)
SP_CATCH$CUMU_PROP <- round(SP_CATCH$CUMU/sum(SP_CATCH$LBS),4)
#SP_REJECT           <- SP_CATCH[CUMU_PROP<0.01] #Drop species after 99% of the cumulative catch
SP_REJECT          <- SP_CATCH[PROP<0.01&SPECIES!="S20"]      #Alternatively, drop species corresponding to less than 1% of total catch (Winker et al. 2013)
No.species         <- length(unique(SP_CATCH[PROP>0.01|SPECIES=="S20"]$SPECIES))

if(add.wind==T) No.variables <- 17
if(add.wind==F) No.variables <- 14

# Only keep the species making up 99% of the catch and uku (obviously)
if(add.wind==T) D <- dcast(C,TRIP+FYEAR+MONTH+DATE+FISHER+CUM_EXP+AREA+AREA_A+AREA_B+AREA_C+LAT+LONG+GEAR+SPEED+XDIR+YDIR+HOURS~SPECIES,value.var="CPUE",fun.aggregate=sum)
if(add.wind==F) D <- dcast(C,TRIP+FYEAR+MONTH+DATE+FISHER+CUM_EXP+AREA+AREA_A+AREA_B+AREA_C+LAT+LONG+GEAR+HOURS~SPECIES,value.var="CPUE",fun.aggregate=sum)

D <- data.table(D)
D <- D[, (SP_REJECT$SPECIES):=NULL]

D <- dplyr::select(D,1:No.variables,S20,(No.variables+1):ncol(D))

# Calculate prop. of each species per trip
#PROPS               <- D[,S20:ncol(D)]/rowSums(D[,S20:ncol(D)]) # Keeps uku in the PCA analyses - uncomment to create dataset for DCA analyses of Winker
PROPS               <- D[,(No.variables+2):ncol(D)]/rowSums(D[,(No.variables+2):ncol(D)])
PROPS[is.na(PROPS)] <- 0 
PROPS               <- (PROPS)^(1/4) # Square-root transformation to increase weight of rarer species
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
E <- cbind(D[,1:S20],PCA$x[,1:4],PC_KEEP)

# Save this record
if(add.wind==T) E <- dplyr::select(E,TRIP,FYEAR,MONTH,DATE,FISHER,CUM_EXP,LAT,LONG,SPEED,XDIR,YDIR,AREA,AREA_A,AREA_B,AREA_C,PC1,PC2,PC3,PC4,PC_KEEP,HOURS,UKUCPUE=S20)
if(add.wind==F) E <- dplyr::select(E,TRIP,FYEAR,MONTH,DATE,FISHER,CUM_EXP,LAT,LONG,AREA,AREA_A,AREA_B,AREA_C,PC1,PC2,PC3,PC4,PC_KEEP,HOURS,UKUCPUE=S20)

E <- E[order(DATE,AREA_C,TRIP)]


