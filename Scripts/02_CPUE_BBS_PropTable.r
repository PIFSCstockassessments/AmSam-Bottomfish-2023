require(data.table); require(tidyverse); require(gridExtra); require(directlabels);require(openxlsx)
options(scipen = 999)
root_dir <- this.path::here(.. = 1) 

Z <- readRDS(paste0(root_dir,"/Outputs/CPUE_A.rds"))
Z <- select(Z,YEAR,AREA_C,SPECIES_FK,INTERVIEW_PK,CATCH_PK,SCIENTIFIC_NAME,METHOD_FK,EST_LBS)
Z <- Z[,list(EST_LBS=max(EST_LBS)),by=list(INTERVIEW_PK,CATCH_PK,YEAR,AREA_C,SPECIES_FK,SCIENTIFIC_NAME,METHOD_FK)]
Z$SPECIES_FK <- as.numeric(Z$SPECIES_FK)

# Append species group association table
SKEY <- data.table(  read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="ALLSPECIES")  )
#SKEY$SPECIES_PK <- as.character(SKEY$SPECIES_PK)
SKEY            <- SKEY[,-(2:7)]
Z               <- merge(Z,SKEY,by.x="SPECIES_FK",by.y="SPECIES_PK")

Z[SPECIES_FK==109]$SPECIES_FK <- 110 # Merge Trevallies and Jacks
Z[SPECIES_FK==380]$SPECIES_FK <- 210 # Merge Inshore groupers and groupers

# Define the time PERIOD used to calculate species proportions
Z$PERIOD <- 999
Z[YEAR>1985&YEAR<=1995]$PERIOD <- 1995
Z[YEAR>1995&YEAR<=2005]$PERIOD  <- 2005
Z[YEAR>2005&YEAR<=2015]$PERIOD  <- 2015
Z[YEAR>2015&YEAR<=2025]$PERIOD  <- 2025

# Merge banks and Tutuila, since most bank trips are surveyed by the same surveyors in Tutuila
Z[AREA_C=="Bank"]$AREA_C <- "Tutuila"

# Establish list of taxonomic groups (groups that are only composed of species)
Group.listA <- c("Jacks_110","Groupers_210","Prist_Etelis_240","Emperors_260","Inshore_groupers_380","Inshore_snappers_390")

# 2nd tier list (groups that are composed of species and one of the subgroups in listA)
Group.listB <- c("Deep_snappers_230")

# 3rd tier list (group that is composed of species and all of the subgroups above)
Group.listC <- c("Bottomfishes_200")


# Calculate species proportion for all groups that only contain species
ResultsA <- list()
for(i in 1:length(Group.listA)){

   aGroup      <- Group.listA[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
    
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group

   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   ResultsA[[i]] <- Prop
}

# Put prop dataset together
FinalA <- rbindlist(ResultsA)

# Calculate species proportion for groups that contain 1 subgroup
ResultsB <- list()
for(i in 1:length(Group.listB)){
   
   aGroup      <- Group.listB[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   Prop        <- select(Prop,-EST_LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalA,by.x=c("SPECIES_FK","PERIOD","AREA_C"),by.y=c("GROUP_FK","PERIOD","AREA_C"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK <- Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(SPECIES_FK,PERIOD,AREA_C)]
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   Prop          <- Prop[order(PERIOD,AREA_C,SPECIES_FK)]
   ResultsB[[i]] <- Prop
}

# Put prop dataset together
FinalB <- rbindlist(ResultsB)
FinalB <- rbind(FinalA, FinalB)

# Calculate species proportion for final group that contains all subgroups (bottomfish)
ResultsC <- list()
for(i in 1:length(Group.listC)){
   
   aGroup      <- Group.listC[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   Prop        <- select(Prop,-EST_LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalB,by.x=c("SPECIES_FK","PERIOD","AREA_C"),by.y=c("GROUP_FK","PERIOD","AREA_C"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK <- Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(SPECIES_FK,PERIOD,AREA_C)]
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   Prop          <- Prop[order(PERIOD,AREA_C,SPECIES_FK)]
   ResultsC[[i]] <- Prop
}

# Put prop dataset together
FinalC <- rbindlist(ResultsC)
Final  <- rbind(FinalB,FinalC)


Final <- Final[,list(Prop=sum(Prop)),by=list(GROUP_FK,PERIOD,AREA_C,SPECIES_FK)]
Final <- Final[order(GROUP_FK,PERIOD,AREA_C,SPECIES_FK)]

# Some graphical exploration of species proportion evolution
Test <- Final[SPECIES_FK==111|SPECIES_FK==229|SPECIES_FK==231|SPECIES_FK==239|SPECIES_FK==241|SPECIES_FK==242|SPECIES_FK==245|
                 SPECIES_FK==247|SPECIES_FK==248|SPECIES_FK==267]
ggplot(data=Test[GROUP_FK==200&AREA_C=="Tutuila"])+geom_line(aes(x=PERIOD,y=Prop,col=as.character(SPECIES_FK)))
ggplot(data=Test[GROUP_FK==230&AREA_C=="Tutuila"])+geom_line(aes(x=PERIOD,y=Prop,col=as.character(SPECIES_FK)))


# Output table for further use
saveRDS(Final,file=paste0(root_dir,"/Outputs/BBS_Prop_Table.rds"))

#============================Apply the species proportion table to the CPUE data for CPUE indices purposes===============================================================

D   <- readRDS(paste0(root_dir,"/Outputs/CPUE_A.rds"))
PT  <- readRDS(paste0(root_dir, "/Outputs/BBS_Prop_Table.rds"))  # Species composition of groups, by group x period x region

PT$GROUP_FK   <- as.character(PT$GROUP_FK)
PT$SPECIES_FK <- as.character(PT$SPECIES_FK)

D$PERIOD <- 999 # Add time period that matches the one used for prop table (PT)
D[YEAR>1985&YEAR<=1995]$PERIOD  <- 1995
D[YEAR>1995&YEAR<=2005]$PERIOD  <- 2005
D[YEAR>2005&YEAR<=2015]$PERIOD  <- 2015
D[YEAR>2015&YEAR<=2025]$PERIOD  <- 2025

# Replace all the grouped catch into species using the proportion table calculated above.
X            <- D[BMUS=="BMUS_Containing_Group"]
X            <- merge(X,PT,by.x=c("SPECIES_FK","PERIOD","AREA_C"),by.y=c("GROUP_FK","PERIOD","AREA_C"),allow.cartesian=T)
X$SPECIES_FK <- X$SPECIES_FK.y
X$EST_LBS    <- X$EST_LBS*X$Prop
X            <- select(X,-SPECIES_FK.y,-Prop,-PERIOD)
X$SOURCE     <- "Group-level"

# Remove the grouped catch from the original data so it can be merge with the new table where groups were broken down by species
Y        <- select(D,-PERIOD )
Y        <- Y[BMUS!="BMUS_Containing_Group"]
Y$SOURCE <- "Species-level"

L <- rbind(X,Y)
L <- select(L,-FAMILY,-BMUS,-SCIENTIFIC_NAME)

#=======Final re-organization=================

# Re-add some species-specific fields
S <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="ALLSPECIES")   )
S <- select(S,SPECIES_PK,SCIENTIFIC_NAME,FAMILY,BMUS)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
L <- merge(L,S,by.x="SPECIES_FK",by.y="SPECIES_PK",all.x=T)

L <- select(L,INTERVIEW_PK:PROP_UNID,AREA_C,SOURCE:BMUS,SPECIES_FK,EST_LBS)

saveRDS(L,file=paste0(root_dir,"/Outputs/CPUE_B.rds"))





