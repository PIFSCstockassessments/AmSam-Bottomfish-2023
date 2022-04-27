require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx);  require(dplyr);require(stringr)
options(scipen = 999)

# establish directories using this.path::
root_dir <- this.path::here(.. = 1)
set.seed(11111) # It is critical to fix the random number generation for reproducability

# ----------- STEP 1: read in the complete "flatview" datafile for AmSam Shore based survey, 
#				do some data manipulation

D <- fread(paste(root_dir, "/Data/AmSam_SBS_Sep10.csv", sep=""),header=T, stringsAsFactors=FALSE) 
R <- fread(paste(root_dir, "/Data/sb_route_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
M <- fread(paste(root_dir, "/Data/sb_gear_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 

names(D) <- toupper(names(D)) # Capitalize all headers
setnames(D,"EST_WHOLE_LBS","EST_LBS")

D$YEAR      <- year(D$SAMPLE_DATE)
D$ROUTE     <- as.character(D$ROUTE)
D$EST_LBS   <- as.numeric(D$EST_LBS)
M$METHOD_FK <- as.character((M$METHOD_FK))

# fix P. rutilans
D[SPECIES_FK==243]$SPECIES_FK      <-241
D[SPECIES_FK==243]$SCIENTIFIC_NAME <-'Pristipomoides flavipinnis'

# keep only 1990 to 2020 (to match SB expanded landings from Hongguang). 
D <- D[YEAR>=1990]

D <- D[CATCH_PK!="NULL"]

# No catch + Est_LBS >0 - delete
D <- D[!(COMMON_NAME=="No Catch"&EST_LBS>0)]

# Simplify gears and routes
D <- merge(D,R,by.x=c("ROUTE_FK","ROUTE_NAME"),by.y=c("ROUTE","ROUTE_NAME"))
D <- merge(D,M,by=c("METHOD_FK","FISHING_METHOD"))

# Simplify dataset

D <- D[,list(EST_LBS=max(EST_LBS)),by=list(INTERVIEW_PK,CATCH_PK,YEAR,SPECIES_FK)]

# calculate proportion of Variola louti vs albimarginata for Years > 2015

Prop.Variola <- D[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK)]
Prop.Variola <- Prop.Variola[YEAR>2015&(SPECIES_FK=="220"|SPECIES_FK=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK)]
Prop.Louti   <- Prop.Variola[SPECIES_FK=="229"]$EST_LBS/(Prop.Variola[SPECIES_FK=="220"]$EST_LBS+Prop.Variola[SPECIES_FK=="229"]$EST_LBS)
Prop.Louti   <- round(Prop.Louti,3)

# For all interview records (using CATCH_PK variable) of V. louti or albimarginata for years <= 2015, randomly assign record as "V. louti" proportionally to Prop.Louti (all fish in an interview)

D$SPECIES_FK2      <- D$SPECIES_FK # Create a "corrected" SPECIES_FK2 field
CATCH_PK.list      <- unique(D[YEAR<=2015]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- D[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="220"|aSpecies=="229"){
    
    if(runif(n=1,0,1)<=Prop.Louti){    
      D[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "229"
    } else {
      D[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "220"  
    }
  }
}	

Test <- D[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK2)]
Test <- Test[YEAR<=2015&(SPECIES_FK2=="220"|SPECIES_FK2=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]
Prop.Louti; Test[SPECIES_FK2=="229"]$EST_LBS/sum(Test$EST_LBS)


# ============= Calculate species proportion table for shore-based surveys (see 02_BBS_proptable code)=============================

# Append species group association table
SKEY            <- fread(file="Data\\AmSam_BBS-SBS_GroupKey2.csv")
SKEY$SPECIES_PK <- as.character(SKEY$SPECIES_PK)
SKEY            <- SKEY[,-(2:6)]
D               <- merge(D,SKEY,by.x="SPECIES_FK",by.y="SPECIES_PK")

D[SPECIES_FK==109]$SPECIES_FK <- 110 # Merge Trevallies and Jacks
D[SPECIES_FK==280]$SPECIES_FK <- 210 # Merge Inshore groupers and groupers
D[SPECIES_FK==230]$SPECIES_FK <- 390 # Merge deep with inshore snappers (only a few deep records, likely inshore snappers)

# Define the time PERIOD used to calculate species proportions
D$PERIOD <- 2025 # Single period going from 1990 to 2025 (2025 doesn't mean anything itself)

# Establish list of taxonomic groups (groups that are only composed of species)
Group.listA <- c("Jacks_110","Groupers_210","Prist_Etelis_240","Emperors_260","Inshore_groupers_380","Inshore_snappers_390")

# Calculate species proportion for all groups that only contain species
ResultsA <- list()
for(i in 1:length(Group.listA)){
  
  aGroup      <- Group.listA[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
  
  Total.Sp      <- D[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD)] # Catch by species by year
  Total.Overall <- D[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD)] # Total of identified catch in group
  
  # Calculate proportion of each species composing group by PERIOD
  Prop        <- merge(Total.Sp,Total.Overall,by="PERIOD")
  Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
  
  Prop$GROUP_FK <- aSPECIES_FK
  Prop          <- select(Prop,GROUP_FK,PERIOD,SPECIES_FK,Prop)
  ResultsA[[i]] <- Prop
}

# Put prop dataset together
Final <- rbindlist(ResultsA)
Final <- select(Final,-PERIOD) # We don't use time periods for the shore-based prop. matrix

Final <- Final[,list(Prop=sum(Prop)),by=list(GROUP_FK,SPECIES_FK)]
Final <- Final[order(GROUP_FK,SPECIES_FK)]

saveRDS(Final,paste0(root_dir, "//Outputs//SBS_Prop_Table.rds"))






