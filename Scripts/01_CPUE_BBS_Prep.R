#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL DATA HANDLING 01_BBS_data_prep.R
#	Data preparation for BOAT BASED creel survey: 
#   *** data updated Oct 6, 2021 with data received from Penlong JIRA ticket 113156
#	    should be ALL interviews, all gears, all years, all species, etc., through 2020
#   *** data updated March 25 2022 with data received from Dios JIRA ticket 113220
#	    should be ALL interviews, all gears, all species, etc., for just 2021
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  modified by Marc Nadon marc.nadon@noaa.gov
#		includes some code written by John Syslo for the 2019 assessment
#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	require(dplyr); require(this.path); require(data.table); require(lunar); require(openxlsx)
  	options(scipen=999)		              # this option just forces R to never use scientific notation
  	root_dir <- this.path::here(.. = 1) # establish directories using this.path
  	set.seed(111) # It is critical to fix the random number generation for reproducability
  	
#  --------------------------------------------------------------------------------------------------------------
#  STEP 1: read in 4 "flatview" datafiles, followed by some basic data handling

   aint_bbs1 <- fread(paste(root_dir, "/Data/a_bbs_int_flat1.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs2 <- fread(paste(root_dir, "/Data/a_bbs_int_flat2.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs3 <- fread(paste(root_dir, "/Data/a_bbs_int_flat3.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs4 <- fread(paste(root_dir, "/Data/a_bbs_int_flat4.csv", sep=""), header=T, stringsAsFactors=FALSE)
   aint_bbs5 <- fread(paste(root_dir, "/Data/PICDR-113220 BB Creel Data_all_columns.csv", sep=""), header=T, stringsAsFactors=FALSE)
	
   aint_bbs5 <- aint_bbs5[,-62]       # drop var 62 ('COMMON_NAME') which is duplicated		
	
  # aint_bbs4 included 2021 interviews through May. Remove these records because they are also in aint_bbs5
   aint_bbs4$YEAR        <- year(aint_bbs4$SAMPLE_DATE)
   aint_bbs4             <- aint_bbs4[YEAR < 2021]								
   aint_bbs4             <- select(aint_bbs4,-YEAR)
	
   A <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		
  
   # -- 99 interviews flagged as incomplete
   A <- A[INCOMPLETE_F=="F"]
   
   # 389 interviews with EST_LBS and CATCH_PK == NA
   A <- A[CATCH_PK!="NULL"]
   
   # -- Filter some strange or missing gear types (removes 19 trips overall, minor filter impact)
   A <- A[FISHING_METHOD!="BLANK"&FISHING_METHOD!="GLEANING"&FISHING_METHOD!="NULL"&
            FISHING_METHOD!="PALOLO FISHING"&FISHING_METHOD!="UNKNOWN - BOAT BASED"&FISHING_METHOD!="VERT. LONGLINE"]
   
   # Important the EST_LBS field is repeated over several SIZE_PK individual fish measurement (do not sum catch across CATCH_PK).
   # This steps gets rid of the size information so that there is 1 EST_LBS per CATCH_PK
   A <- A[,list(EST_LBS=max(EST_LBS)),by=list(INTERVIEW_PK,CATCH_PK,SAMPLE_DATE,TYPE_OF_DAY,
                                               INTERVIEW_TIME,PORT_NAME,VESSEL_REGIST_NO,ISLAND_NAME,AREA_FK,METHOD_FK,SPECIES_FK,HOURS_FISHED,NUM_GEAR)]
   
   A$YEAR         <- as.numeric(year(A$SAMPLE_DATE))
   A$MONTH        <- as.numeric(month(A$SAMPLE_DATE))
   A$HOUR         <- as.numeric(hour(A$INTERVIEW_TIME))
   A$EST_LBS      <- as.numeric(A$EST_LBS)
   A$TOT_EST_LBS  <- as.numeric(A$TOT_EST_LBS)
   A$AREA_FK      <- as.character(A$AREA_FK)
   A$INTERVIEW_PK <- as.character(A$INTERVIEW_PK)
   
   # season: 12-1-2 = summer, 3-4-5 = fall, 6-7-8 = winter, 9-10-11 = spring
   A$SEASON <- "NA"
   A[MONTH>=12|MONTH<=2]$SEASON <- "summer"
   A[MONTH>=3&MONTH<=5]$SEASON  <- "fall"
   A[MONTH>=6&MONTH<=8]$SEASON  <- "winter"
   A[MONTH>=9&MONTH<=11]$SEASON <- "spring"
   
   # Shifts: "morning shift" is 0500-1330, evening shift is 1400-2230 or try 6-hour blocks
   A$SHIFT <- "NA"
   A[HOUR >= 5  &  HOUR < 14]$SHIFT <- 'am' 
   A[HOUR >= 14 & HOUR < 23]$SHIFT  <- 'pm' 
   A[HOUR >= 23 | HOUR < 5]$SHIFT   <- 'other' 
   
   # Time of Day quarter
   A$TOD_QUARTER <- "NA"
   A[HOUR >= 0 & HOUR < 6]$TOD_QUARTER   <- '0000-0600' 
   A[HOUR >= 6 & HOUR < 12]$TOD_QUARTER  <- '0600-1200' 
   A[HOUR >= 12 & HOUR < 18]$TOD_QUARTER <- '1200-1800' 
   A[HOUR >= 18 & HOUR < 24]$TOD_QUARTER <- '1800-2400' 
   
   # Reclassify the non-main ports= ASILI, GENERAL TUTUILA PORT, LEONE, VATIA
   A$PORT_SIMPLE <- A$PORT_NAME
   A[PORT_NAME == 'ASILI'|PORT_NAME == 'GENERAL TUTUILA PORT'|PORT_NAME == 'LEONE'|PORT_NAME == 'VATIA']$PORT_SIMPLE <- "Tutuila_Other" 
   
   # Add more detailed area informations
   AREAS <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="AREAS")   )
   AREAS <- AREAS[DATASET=="BBS"]
   AREAS <- select(AREAS,AREA_ID,AREA_A,AREA_C,AREA_C)
   AREAS$AREA_ID <- as.character(AREAS$AREA_ID)
   A     <- merge(A,AREAS,by.x="AREA_FK",by.y="AREA_ID",all.x=T)
   
   # Assign unknown AREA_C trips to the region they were interviewed (Tutuila or Manua)
   length(unique(A[AREA_FK==0|AREA_FK==99|AREA_FK==100|is.na(AREA_C)]$INTERVIEW_PK)) #135 interviews can be salvaged by assigning the island to the area
   A[AREA_C=="Unk"|is.na(AREA_C)]$AREA_C <- A[AREA_C=="Unk"|is.na(AREA_C)]$ISLAND_NAME
   A <- A[AREA_C!="Imports/Filter"]
   
   #  Add some posix CT variables and moon phase, use require lunar package. Note: American Samoa is UTC -11.
   A <- mutate(A, INTERVIEW_TIME_LOCAL = as.POSIXct(INTERVIEW_TIME, tz='UTC'))
   A <- mutate(A, INTERVIEW_TIME_UTC = INTERVIEW_TIME_LOCAL + 11*60*60)
   A <- mutate(A, MOON_RADIANS = lunar.phase(as.Date(SAMPLE_DATE), shift = 11))
   A <- mutate(A, MOON_DAYS = round(MOON_RADIANS* (29.53/(2*pi)) ,digits=0) )  #  2pi radians = 29.53 days, so...
   
   # Add some large-scale environmental indices
   ENV  <- read.xlsx(paste0(root_dir, "/Data/Environmental data.xlsx"))
   A    <- merge(A,ENV,by=c("YEAR","MONTH"),all.x=T)
   
   # Add some species-specific fields
   SPECIES <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="ALLSPECIES")   )
   SPECIES <- select(SPECIES,SPECIES_PK,SCIENTIFIC_NAME,FAMILY)
   SPECIES$SPECIES_PK <- as.character(SPECIES$SPECIES_PK)
   A       <- merge(A,SPECIES,by.x="SPECIES_FK",by.y="SPECIES_PK",all.x=T)
   
 #=========================STEP 2: Basic Interview Filtering and fixes===============================
   
   A <- A[YEAR != 1985] # Incomplete year
   A <- A[YEAR != 1111] # Database artefact

#  ----------------------------------------------
#	241 'Pristipomoides flavipinnis' has local name "Palu sina (Yelloweye Snapper)"
#	243 'Pristipomoides rutilans' has local name "Palu sina (Yelloweye Opakapaka)"
#	247 'Aphareus rutilans', local name "Palu gutusiliva, Palu makomako"
# Problem: Pristipomoides rutilans is not a valid scientific name. In 2019 assessment and 2022 data report, we assumed P. rutilans = A. rutilans.
# However, it seems most likely that P. rutilans was actually P. flavipinnis, given they share the local name "palu sina" 
#	Fishermen workshops confirmed the name Palu-sina for P. flavipinnis, we concluded 'P. rutilans' (SPECIES_PK 243) is P. flavipinnis 
# Replace SPECIES_FK 243 (Pristipomoides rutilans) with 241 (Pristipomoides flavipinnis)
   A[SPECIES_FK==243]$SCIENTIFIC_NAME <- "Pristipomoides flavipinnis"
   A[SPECIES_FK==243]$SPECIES_FK      <- 241

 # -- 7 CATCH_PK where COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0. In all instances, there were other species caught and recorded within these interviews.
 # So, eliminate the erroneous 'no catch' CATCH_PK, but keep remainder of interview
  A <- A[!(FAMILY=="No Catch"&TOT_EST_LBS>0)]

 # -- 146 records where EST_LBS = 0 but TOT_EST_LBS > 0
  A <- A[!(EST_LBS==0&TOT_EST_LBS>0)]

 # -- 11 interviews where TOT_EST_LBS > 0 but most other fields, including SPECIES_FK and CATCH_PK are NULL
  A <- A[!(TOT_EST_LBS>0&SPECIES_FK=="NULL")]
  A <- A[!(TOT_EST_LBS>0&CATCH_PK=="NULL")]
  
  
 # -- eliminate interviews missing a metric for effort. note: data dictionary is ambiguous, but previously, 
   #  HOURS_FISHED x NUM_GEAR was effort. I checked, for all geartypes this makes sense.
   #  discard any zero effort (note 38 BTM/TRL and BOTTOMFISHING interviews had 0 catch and 0 effort, these were probably canceled trips)
  A <- A[HOURS_FISHED > 0 & NUM_GEAR > 0]
 
 # Filter for the two bottomfishing methods 
  A <- A[METHOD_FK==4|METHOD_FK==5] 
  
  # Make sure HOURS_FISHED is available and exclude some extreme NUM_GEAR values
  A <- A[HOURS_FISHED>0&(NUM_GEAR>0&NUM_GEAR<20)]; length(unique(C$INTERVIEW_PK))
  
  # Check that covariates don't have NAs or other weird values
  table(A$TYPE_OF_DAY,exclude=NULL)
  table(A$MONTH,exclude=NULL)
  table(A$PROP_UNID,exclude=NULL) # Note: the NAs are interviews with no BMUS or potential group BMUS catch
  table(A$AREA_C)
  
  # Check the range of catch values
  range(A$EST_LBS)
  A[EST_LBS==687.348] # 10 hours fishing, unidentified snappers (Code 230)
  
  
  # WATCH OUT- there were 779 interviews, 3105 catch records, that included NUM_KEPT = 0 but catch weight was recorded
	# skimming through, it is obvious that the number of fish that must have been included in these weights was greater than 1.
	# SO- ALWAYS USE CAUTION when talking about numbers: NUM_KEPT IS NOT a dependable record of number of fish caught.
	# for weight-based CPUE, these interviews can be used.
	# For anything numbers or weight per fish based, consider using records by SIZE_PK only, and at the least, exclude these interviews.

#  --------------------------------------------------------------------------------------------------------------
#  STEP 4: update B to address some species identification issues.

# ----- 4a. Variola louti and Variola albimarginata have been confused between 1986-2015. Some fishermen in both workshops
#		indicated that they didn't distinguish between the white-tail and yellow-tail groupers. In Tutuila, they call the
#		yellow tail (louti) velo, and they call the white tail (albimarginata) papa. However, it seems in Manu'a both species
#		are called velo. 'papa' is totally different (the tomato grouper, Cephalopholis sonnerati).
#		We assume 2016-2020 BBS species identifications are reliable

  B <- A
  
# calculate proportion of Variola louti vs albimarginata for Years > 2015
	Prop.Variola <- B[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK,SCIENTIFIC_NAME)]
	Prop.Variola <- Prop.Variola[YEAR>2015&(SPECIES_FK=="220"|SPECIES_FK=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,SCIENTIFIC_NAME)]
	Prop.Louti   <- Prop.Variola[SPECIES_FK=="229"]$EST_LBS/(Prop.Variola[SPECIES_FK=="220"]$EST_LBS+Prop.Variola[SPECIES_FK=="229"]$EST_LBS)
  Prop.Louti   <- round(Prop.Louti,3)
	
# For all interview records (using CATCH_PK variable) of V. louti or albimarginata for years <= 2015, randomly assign record as "V. louti" proportionally to Prop.Louti (all fish in an interview)

B$SPECIES_FK2      <- B$SPECIES_FK # Create a "corrected" SPECIES_FK2 field
CATCH_PK.list      <- unique(B[YEAR<=2015]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- B[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="220"|aSpecies=="229"){
    
    if(runif(n=1,0,1)<=Prop.Louti){    
    B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "229"
    } else {
    B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "220"  
    }
  }
}	

# View(B[INTERVIEW_PK=="20817184804"])
#Test <- B[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK2,SCIENTIFIC_NAME)]
#Test <- Test[YEAR<=2015&(SPECIES_FK2=="220"|SPECIES_FK2=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]
#Prop.Louti; Test[SPECIES_FK2=="229"]$EST_LBS/sum(Test$EST_LBS)


# ----- 4b. Pristipomoides filamentosus and P. flavipinnis were confused between 2010-2015. Assume 2016-2021 species is reliable.
 		 
# calculate proportion of P. filamentosus vs P. flavipinnis for Years > 2015

Prop.Pristi <- B[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Pristi <- Prop.Pristi[YEAR>2015&(SPECIES_FK=="241"|SPECIES_FK=="242"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Flavi  <- Prop.Pristi[SPECIES_FK=="241"]$EST_LBS/(Prop.Pristi[SPECIES_FK=="241"]$EST_LBS+Prop.Pristi[SPECIES_FK=="242"]$EST_LBS)
Prop.Flavi  <- round(Prop.Flavi,3)

# For all interview records (using CATCH_PK variable) of P. flavipinnis or filamentosus for years between 2010 and 2015, randomly assign record as "P. flavi" proportionally to Prop.Flavi (all fish in an interview)
CATCH_PK.list      <- unique(B[YEAR>=2010&YEAR<=2015]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- B[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="241"|aSpecies=="242"){
    
    if(runif(n=1,0,1)<=Prop.Flavi){    
      B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "241"
    } else {
      B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "242"  
    }
  }
}	

# View(B[INTERVIEW_PK=="100603101305"])
# Test <- B[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK2,SCIENTIFIC_NAME)]
# Test <- Test[(YEAR>=2010&YEAR<=2015)&(SPECIES_FK2=="241"|SPECIES_FK2=="242"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]
# Prop.Flavi; Test[SPECIES_FK2=="241"]$EST_LBS/sum(Test$EST_LBS)
 

# ----- 4c. Lethrinidae in Manu'a:
#   Manu'a fishermen said they catch the red-ear emperor (L. rubrioperculatus) all the time ("100% of trips")
#   However: 1) catch of all identified and unidentified emperors in Manu'a is really small. 
#	  and 2) among the catch of emperors that was recorded, rubrioperculatus was observed in only 3 years, and was about as common as
#		L. amboinensis (which is rare in Tutuila). The irregular appearance of identified rubrioperculatus will cause the species to
#		be broken out from unidentified emperors in only small amounts in the 5-year average smoothed break-down.		
#   We address problem 2 here: assume time series average observed proportions of identified emperors, Manu'a only, applies to all Lethrinidae in Manu'a  
#   This will result in more of the unidentified emperors and bottomfish going to rubrioperculatus in the later break-down steps.
#   In Tutuila, fishermen used different names for filoa based on size: -paa when bigger, -ele ele when small, so possible that species
#		identifications have been confused. The fishermen said paomumu come in schools, so if you hit it, you will catch a lot.


# calculate proportion of L. rubrioperculatus (267) in the Manuas, where they barely appear

Prop.Emp    <- B[AREA_C=="Manua",list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,FAMILY,SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Emp    <- Prop.Emp[FAMILY=="Lethrinidae",list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Rub    <- Prop.Emp[SPECIES_FK=="267"]$EST_LBS/sum(Prop.Emp[SPECIES_FK!="260"]$EST_LBS)
Prop.Rub    <- round(Prop.Rub,3)

# For all interview records (using CATCH_PK variable) containing "emperors - 260" ID in Manua (all years), randomly assign record as to L. rubrio according to its proportion in 1986-2010
CATCH_PK.list      <- unique(B[AREA_C=="Manua"]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- B[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="260"){
    
    if(runif(n=1,0,1)<=Prop.Rub){    
      B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "267"
    } else {
      B[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "260"  
    }
  }
}	

# Test <- B[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,AREA_C,INTERVIEW_PK,CATCH_PK,FAMILY,SPECIES_FK2,SCIENTIFIC_NAME)]
# Test <- Test[AREA_C=="Manua"&FAMILY=="Lethrinidae",list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]
# Prop.Rub; Test[SPECIES_FK2=="267"]$EST_LBS/sum(Test$EST_LBS)

# Remove old species unique ID with the corrected one
B <- select(B,-SPECIES_FK,-FAMILY,-SCIENTIFIC_NAME)
setnames(B,"SPECIES_FK2","SPECIES_FK")
B <- merge(B,SPECIES,by.x="SPECIES_FK",by.y="SPECIES_PK")

# Add information as whether the record is a BMUS or part of a multi-species group that could contain BMUS
B$BMUS <- "Non_BMUS"
B[SPECIES_FK=="247"|SPECIES_FK=="239"|SPECIES_FK=="111"|SPECIES_FK=="249"|
    SPECIES_FK=="248"|SPECIES_FK=="267"|SPECIES_FK=="231"|SPECIES_FK=="242"|
    SPECIES_FK=="241"|SPECIES_FK=="245"|SPECIES_FK=="229"]$BMUS <- "BMUS_Species"

B[SPECIES_FK=="109"|SPECIES_FK=="110"|SPECIES_FK=="200"|SPECIES_FK=="210"|
    SPECIES_FK=="230"|SPECIES_FK=="240"|SPECIES_FK=="260"|SPECIES_FK=="380"|
    SPECIES_FK=="390"]$BMUS <- "BMUS_Containing_Group"

# Add proportion unidentified per INTERVIEW_PK
SUM.GROUP   <- B[BMUS=="BMUS_Containing_Group",list(LBS_GROUP=sum(EST_LBS)),by=list(INTERVIEW_PK)]
SUM.BMUS    <- B[BMUS=="BMUS_Species",list(LBS_BMUS=sum(EST_LBS)),by=list(INTERVIEW_PK)]
P           <- merge(SUM.GROUP,SUM.BMUS,by="INTERVIEW_PK")
P$PROP_UNID <- round(P$LBS_GROUP/(P$LBS_BMUS+P$LBS_GROUP),3) 
P           <- select(P,INTERVIEW_PK,PROP_UNID)
B           <- merge(B,P,by="INTERVIEW_PK",all.x=T)

# Select only used variables
B <- select(B,INTERVIEW_PK,CATCH_PK,AREA_C,YEAR,SEASON,MONTH,SAMPLE_DATE,SHIFT,TOD_QUARTER,PORT_SIMPLE,HOUR,INTERVIEW_TIME_LOCAL,INTERVIEW_TIME_UTC,TYPE_OF_DAY,VESSEL_REGIST_NO,METHOD_FK,
            HOURS_FISHED,NUM_GEAR,PROP_UNID,BMUS,SPECIES_FK,FAMILY,SCIENTIFIC_NAME,EST_LBS)

B <- B[order(SAMPLE_DATE,INTERVIEW_TIME_LOCAL,INTERVIEW_PK)]

# save in nullfile()# save in the output folder.
saveRDS(B,file=paste(paste0(root_dir, "/Outputs/CPUE_A.rds")))


