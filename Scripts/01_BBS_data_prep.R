#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - INITIAL DATA HANDLING 01_BBS_data_prep.R
#	Data preparation for BOAT BASED creel survey: 
#   *** data updated Oct 6, 2021 with data received from Penlong JIRA ticket 113156
#	    should be ALL interviews, all gears, all years, all species, etc., through 2020
#   *** data updated March 25 2022 with data received from Dios JIRA ticket 113220
#	    should be ALL interviews, all gears, all species, etc., for just 2021
#	Erin Bohaboy erin.bohaboy@noaa.gov
#		includes some code written by John Syslo for the 2019 assessment
#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	require(sqldf);	require(dplyr); require(this.path); require(data.table)
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
	
   aint_bbs <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		
   aint_bbs <- data.table(aint_bbs)  
   
   aint_bbs$YEAR        <- as.numeric(year(aint_bbs$SAMPLE_DATE))
   aint_bbs$MONTH       <- as.numeric(month(aint_bbs$SAMPLE_DATE))
   aint_bbs$HOUR        <- as.numeric(hour(aint_bbs$INTERVIEW_TIME))
   aint_bbs$EST_LBS     <- as.numeric(aint_bbs$EST_LBS)
   aint_bbs$TOT_EST_LBS <- as.numeric(aint_bbs$TOT_EST_LBS)
   
   # season: 12-1-2 = summer, 3-4-5 = fall, 6-7-8 = winter, 9-10-11 = spring
   aint_bbs$SEASON <- "NA"
   aint_bbs[MONTH>=12&MONTH<=2]$SEASON <- "summer"
   aint_bbs[MONTH>=3&MONTH<=5]$SEASON  <- "fall"
   aint_bbs[MONTH>=6&MONTH<=8]$SEASON  <- "winter"
   aint_bbs[MONTH>=9&MONTH<=11]$SEASON <- "spring"
   
   # Shifts: "morning shift" is 0500-1330, evening shift is 1400-2230 or try 6-hour blocks
   aint_bbs$SHIFT <- "NA"
   aint_bbs[HOUR >= 5  &  HOUR < 14]$SHIFT <- 'am' 
   aint_bbs[HOUR >= 14 & HOUR < 23]$SHIFT  <- 'pm' 
   aint_bbs[HOUR >= 23 & HOUR < 5]$SHIFT   <- 'other' 
   
   # Time of Day quarter
   aint_bbs$TOD_QUARTER <- "NA"
   aint_bbs[HOUR >= 0 & HOUR < 6]$TOD_QUARTER   <- '0000-0600' 
   aint_bbs[HOUR >= 6 & HOUR < 12]$TOD_QUARTER  <- '0600-1200' 
   aint_bbs[HOUR >= 12 & HOUR < 18]$TOD_QUARTER <- '1200-1800' 
   aint_bbs[HOUR >= 18 & HOUR < 24]$TOD_QUARTER <- '1800-2400' 
   
   # reclassify the non-main ports= ASILI, GENERAL TUTUILA PORT, LEONE, VATIA
   aint_bbs$PORT_SIMPLE <- aint_bbs$PORT_NAME
   aint_bbs[PORT_NAME == 'ASILI'|PORT_NAME == 'GENERAL TUTUILA PORT'|PORT_NAME == 'LEONE'|PORT_NAME == 'VATIA']$PORT_SIMPLE <- "Tutuila_Other" 
   
   # -- convert AREA_FK (which includes specific villages) to John's slightly larger PRIMARY_AREA_FK, see map. PRIMARY_AREA_FK=30 is trash can/unknown
   areas <- fread(paste(root_dir, "/Data/a_area.csv", sep=""), header=T)
   aint_bbs <- merge(aint_bbs,areas,by.x="AREA_FK",by.y="AREA_PK")
   setnames(aint_bbs,"AREA","AREA_B")
   
#=========================STEP 2: Basic Interview Filtering and fixes===============================
   
   aint_bbs <- aint_bbs[YEAR != 1985] # Incomplete year
   aint_bbs <- aint_bbs[YEAR != 1111] # Database artefact

#  ----------------------------------------------
#	241 'Pristipomoides flavipinnis' has local name "Palu sina (Yelloweye Snapper)"
#	243 'Pristipomoides rutilans' has local name "Palu sina (Yelloweye Opakapaka)"
#	247 'Aphareus rutilans', local name "Palu gutusiliva, Palu makomako"
# Problem: Pristipomoides rutilans is not a valid scientific name. In 2019 assessment and 2022 data report, we assumed P. rutilans = A. rutilans.
# However, it seems most likely that P. rutilans was actually P. flavipinnis, given they share the local name "palu sina" 
#	Fishermen workshops confirmed the name Palu-sina for P. flavipinnis, we concluded 'P. rutilans' (SPECIES_PK 243) is P. flavipinnis 
# Replace SPECIES_FK 243 (Pristipomoides rutilans) with 241 (Pristipomoides flavipinnis)
   aint_bbs[SPECIES_FK==243]$SCIENTIFIC_NAME <- "Pristipomoides flavipinnis"
   aint_bbs[SPECIES_FK==243]$SPECIES_FK      <- 241

 # -- 7 CATCH_PK where COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0. In all instances, there were other species caught and recorded within these interviews.
 # So, eliminate the erroneous 'no catch' CATCH_PK, but keep remainder of interview
  aint_bbs <- aint_bbs[!(COMMON_NAME=="No Catch"&TOT_EST_LBS>0)]

 # -- 146 records where EST_LBS = 0 but TOT_EST_LBS > 0
  aint_bbs <- aint_bbs[!(EST_LBS==0&TOT_EST_LBS>0)]

 # -- 11 interviews where TOT_EST_LBS > 0 but most other fields, including SPECIES_FK and CATCH_PK are NULL
  aint_bbs <- aint_bbs[!(TOT_EST_LBS>0&SPECIES_FK=="NULL")]
  aint_bbs <- aint_bbs[!(TOT_EST_LBS>0&CATCH_PK=="NULL")]
  
 # -- 99 interviews flagged as incomplete
  aint_bbs <- aint_bbs[INCOMPLETE_F=="F"]
  
 # -- Filter some strange or missing gear types (removes 19 trips overall, minor filter impact)
  aint_bbs <- aint_bbs[FISHING_METHOD!="BLANK"&FISHING_METHOD!="GLEANING"&FISHING_METHOD!="NULL"&
                FISHING_METHOD!="PALOLO FISHING"&FISHING_METHOD!="UNKNOWN - BOAT BASED"&FISHING_METHOD!="VERT. LONGLINE"]
  
 # -- eliminate interviews missing a metric for effort. note: data dictionary is ambiguous, but previously, 
   #  HOURS_FISHED x NUM_GEAR was effort. I checked, for all geartypes this makes sense.
   #  discard any zero effort (note 38 BTM/TRL and BOTTOMFISHING interviews had 0 catch and 0 effort, these were probably canceled trips)
  aint_bbs <- aint_bbs[HOURS_FISHED > 0 & NUM_GEAR > 0]
  aint_bbs <- droplevels(aint_bbs)		
  
  #  -------  use the all_gears dataset for some figures in the data report
  aint_bbs_all_gears <- aint_bbs		
   
  aint_bbs <- aint_bbs[METHOD_FK==4|METHOD_FK==5] 
  aint_bbs_filtered <- aint_bbs # save this as filtered
   
  # WATCH OUT- there were 779 interviews, 3105 catch records, that included NUM_KEPT = 0 but catch weight was recorded
	# skimming through, it is obvious that the number of fish that must have been included in these weights was greater than 1.
	# SO- ALWAYS USE CAUTION when talking about numbers: NUM_KEPT IS NOT a dependable record of number of fish caught.
	# for weight-based CPUE, these interviews can be used.
	# For anything numbers or weight per fish based, consider using records by SIZE_PK only, and at the least, exclude these interviews.

#  --------------------------------------------------------------------------------------------------------------

   bbs_3C <- aint_bbs
   bbs_3C_before_ID_correct <- bbs_3C # make a copy of bbs_3C

#  --------------------------------------------------------------------------------------------------------------
#  STEP 4: update BBS_3C to address some species identification issues.

# ----- 4a. Variola louti and Variola albimarginata have been confused between 1986-2015. Some fishermen in both workshops
#		indicated that they didn't distinguish between the white-tail and yellow-tail groupers. In Tutuila, they call the
#		yellow tail (louti) velo, and they call the white tail (albimarginata) papa. However, it seems in Manu'a both species
#		are called velo. 'papa' is totally different (the tomato grouper, Cephalopholis sonnerati).
#		We assume 2016-2020 BBS species identifications are reliable
 		
# calculate proportion of Variola louti vs albimarginata for Years > 2015
  
	Prop.Variola <- bbs_3C[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK,SCIENTIFIC_NAME)]
	Prop.Variola <- Prop.Variola[YEAR>2015&(SPECIES_FK=="220"|SPECIES_FK=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,SCIENTIFIC_NAME)]
	Prop.Louti   <- Prop.Variola[SPECIES_FK=="229"]$EST_LBS/(Prop.Variola[SPECIES_FK=="220"]$EST_LBS+Prop.Variola[SPECIES_FK=="229"]$EST_LBS)
  Prop.Louti   <- round(Prop.Louti,3)
	
# For all interview records (using CATCH_PK variable) of V. louti or albimarginata for years <= 2015, randomly assign record as "V. louti" proportionally to Prop.Louti (all fish in an interview)

bbs_3C$SPECIES_FK2 <- bbs_3C$SPECIES_FK # Create a "corrected" SPECIES_FK2 field
CATCH_PK.list      <- unique(bbs_3C[YEAR<=2015]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- bbs_3C[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="220"|aSpecies=="229"){
    
    if(runif(n=1,0,1)<=Prop.Louti){    
    bbs_3C[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "229"
    } else {
    bbs_3C[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "220"  
    }
  }
}	

# View(bbs_3C[INTERVIEW_PK=="20817184804"])
#Test <- bbs_3C[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK2,SCIENTIFIC_NAME)]
#Test <- Test[YEAR<=2015&(SPECIES_FK2=="220"|SPECIES_FK2=="229"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]


# ----- 4b. Pristipomoides filamentosus and P. flavipinnis were confused between 2010-2015. Assume 2016-2021 species is reliable.
 		 
# calculate proportion of P. filamentosus vs P. flavipinnis for Years > 2015

Prop.Pristi <- bbs_3C[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Pristi <- Prop.Pristi[YEAR>2015&(SPECIES_FK=="241"|SPECIES_FK=="242"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,SCIENTIFIC_NAME)]
Prop.Flavi  <- Prop.Pristi[SPECIES_FK=="241"]$EST_LBS/(Prop.Pristi[SPECIES_FK=="241"]$EST_LBS+Prop.Pristi[SPECIES_FK=="242"]$EST_LBS)
Prop.Flavi  <- round(Prop.Flavi,3)

# For all interview records (using CATCH_PK variable) of P. flavipinnis or filamentosus for years between 2010 and 2015, randomly assign record as "P. flavi" proportionally to Prop.Flavi (all fish in an interview)
CATCH_PK.list      <- unique(bbs_3C[YEAR>=2010&YEAR<=2015]$CATCH_PK)
for (i in 1:length(CATCH_PK.list)){
  
  aCatch   <- bbs_3C[CATCH_PK==CATCH_PK.list[i]]
  aSpecies <- aCatch[1,SPECIES_FK] # Just check first line of the CATCH_PK (CATCH_PK is at the species level, so all lines should be the same species)
  
  if(aSpecies=="241"|aSpecies=="242"){
    
    if(runif(n=1,0,1)<=Prop.Flavi){    
      bbs_3C[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "241"
    } else {
      bbs_3C[CATCH_PK==CATCH_PK.list[i]]$SPECIES_FK2 <- "242"  
    }
  }
}	

# View(bbs_3C[INTERVIEW_PK=="100603101305"])
# Test <- bbs_3C[,list(EST_LBS=max(EST_LBS)),by=list(YEAR,INTERVIEW_PK,CATCH_PK,SPECIES_FK2,SCIENTIFIC_NAME)]
# Test <- Test[(YEAR>=2010&YEAR<=2015)&(SPECIES_FK2=="241"|SPECIES_FK2=="242"),list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK2)]



# ----- 4c. Lethrinidae in Manu'a:
#   The Manu'a fishermen told us they catch the red-ear emperor (rubrioperculatus) all the time (like, 100% of trips)
#   There are two problems: 1) catch of all identified and unidentified emperors in Manu'a is really small. 
#	2) among the catch of emperors that was recorded, rubrioperculatus was observed in only 3 years, and was about as common as
#		L. amboinensis (which is rare in Tutuila). The irregular appearence of identified rubrioperculatus will cause the species to
#		be broken out from unidentified emperors in only small amounts in the 5-year average smoothed break-down.		
#   We address problem 2 here: assume time series average observed proportions of identified emperors, Manu'a only, applies to all Lethrinidae in Manu'a  
#   This will result in more of the unidentified emperors and bottomfish going to rubrioperculatus in the later break-down steps.
#   In Tutuila, fishermen used different names for filoa based on size: -paa when bigger, -ele ele when small, so possible that species
#		identifications have been confused. The fishermen said paomumu come in schools, so if you hit it, you will catch a lot.

		# Investigate: list total catch, by species, for Lethrinidae in Manu'a Islands

		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(EST_LBS) AS tot_catch
		  FROM (
			SELECT DISTINCT SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
		  	WHERE AREA_B = 'Manua' AND SPECIES_FK in ('254','255','260','261','262','263','264','266',
				'267','2601','5065','5075','5106','5175','5191','5207','5221','5262'))
		GROUP BY SCIENTIFIC_NAME
		  "
		manua_emperors <- sqldf(string, stringsAsFactors=FALSE)		
			#only 3 species were identified:
			#  262      Lethrinus amboinensis   183.914
			#  261        Lethrinus elongatus    26.314
			#  267 Lethrinus rubrioperculatus   125.315

		# Prepare a check: total lbs surveyed in bbs_3C
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C
		  "
		tot_catch_check_0 <- sqldf(string, stringsAsFactors=FALSE)
		sum(tot_catch_check_0$EST_LBS, na.rm=TRUE)					# 442824.1

		# prepare a check: all lethrinidae, manu'a, 1986-2021
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C
		  WHERE SPECIES_FK in ('262','261','267','260') AND AREA_B = 'Manua'
		  "
		manuaemps_check <- sqldf(string, stringsAsFactors=FALSE)	
		sum_manuaemps <- sum(manuaemps_check$EST_LBS)				# 2078.13 lbs

	# calculate sum(each id species) / sum(all id species)
  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE SPECIES_FK in ('262','261','267') AND AREA_B = 'Manua') 
		  GROUP BY SPECIES_FK"
	manuaemps_1 <- sqldf(string, stringsAsFactors=FALSE)
	p_elongatus <- manuaemps_1$TOT_LBS[1]/(sum(manuaemps_1$TOT_LBS))
	p_amboinensis <- manuaemps_1$TOT_LBS[2]/(sum(manuaemps_1$TOT_LBS))
	p_rubrio <- manuaemps_1$TOT_LBS[3]/(sum(manuaemps_1$TOT_LBS))

	# list all interview_pk, catch_pk that included id and unid emperors, 1986-2020
	string <- "SELECT DISTINCT YEAR, INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
		  	FROM bbs_3C
			WHERE SPECIES_FK in ('262','261','267','260') AND AREA_B = 'Manua'
		  	"
	manuaemps_2 <- sqldf(string, stringsAsFactors=FALSE)	#str(manuaemps_2)		#View(manuaemps_2)  #sum(manuaemps_2$EST_LBS)
	# 148 catch records, 2078.13 lbs total
	
	# divide interviews into those which caught just 1 lethrinidae, and those which caught 2+
		# add N_CATCH_PK column
		string <- "SELECT INTERVIEW_PK, count(CATCH_PK) as N_CATCH_PK
			FROM (SELECT DISTINCT INTERVIEW_PK, CATCH_PK
		  		FROM manuaemps_2)
			GROUP BY INTERVIEW_PK
			ORDER BY N_CATCH_PK
			"
		both_sp_question <- sqldf(string, stringsAsFactors=FALSE)			#View(both_sp_question)	

		string <- "SELECT manuaemps_2.*, both_sp_question.N_CATCH_PK
					FROM manuaemps_2 LEFT JOIN both_sp_question
						ON manuaemps_2.INTERVIEW_PK = both_sp_question.INTERVIEW_PK"
		manuaemps_2B <- sqldf(string, stringsAsFactors=FALSE)		# sum(manuaemps_2B$EST_LBS)		#View(manuaemps_2B)

		just_1_sp <- subset(manuaemps_2B, N_CATCH_PK == 1)			# View(just_1_sp)
		just_1_spB <- just_1_sp[,c(2,3,6)]						# View(just_1_spB)
			rownames(just_1_spB) <- NULL
		both_sp <- subset(manuaemps_2B, N_CATCH_PK > 1)				# View(both_sp)		#sum(both_sp$EST_LBS)

		#  ----- CAREFUL!!!
		#   Always make sure this is happening the way we expect.
		string <- "SELECT INTERVIEW_PK, CATCH_PK, sum(EST_LBS) as sum_manuaemps
			FROM both_sp
			GROUP BY INTERVIEW_PK
			"
		both_sp2 <- sqldf(string, stringsAsFactors=FALSE)	#View(both_sp2)		#sum(both_sp2$sum_manuaemps)	
		names(both_sp2)[3] <- 'EST_LBS'				#sum(both_sp2$EST_LBS)	#74.856, we expect this to be small.

		# List the CATCH_PK (eliminated in previous step) that we will drop later:
		drop_catch_pk <- subset(both_sp, !(CATCH_PK %in% both_sp2$CATCH_PK))

	manuaemps_2C <- rbind(just_1_spB, both_sp2)						# sum(variola_2C$EST_LBS)	

	# make a column of EST_LBS for each species
	manuaemps_3 <- mutate(manuaemps_2C, ELONGATUS_LBS = round(EST_LBS*p_elongatus,3), 
				AMBOINENSIS_LBS = round(EST_LBS*p_amboinensis,3),
				RUBRIO_LBS = round(EST_LBS*p_rubrio,3))	  
			# str(manuaemps_3)   #2078.121, not 2078.13, that is simply rounding loss.
			# sum(manuaemps_3$ELONGATUS_LBS)+sum(manuaemps_3$AMBOINENSIS_LBS)+sum(manuaemps_3$RUBRIO_LBS)

	# loop through manuaemps_3. For each original CATCH_PK, we must create a new CATCH_PK&A, CATCH_PK&E, and CATCH_PK&R 
	#	for each Lethrinus species identified in the data
	  # create dummy df to append to
	  manuaemps_4 <- data.frame(INTERVIEW_PK = 9999, CATCH_PK = 'abc', 
				NEW_CATCH_PK = 'abc', SPECIES_FK = 'abc', SCIENTIFIC_NAME = 'abc', EST_LBS = 9999)		#str(manuaemps_4)		
	
	  for (i in 1:nrow(manuaemps_3)) {
		 add_ambo <- data.frame(INTERVIEW_PK = manuaemps_3$INTERVIEW_PK[i],
					CATCH_PK = manuaemps_3$CATCH_PK[i], NEW_CATCH_PK = paste(manuaemps_3$CATCH_PK[i],'A',sep=""), 
					SPECIES_FK = '262', SCIENTIFIC_NAME = 'Lethrinus amboinensis', EST_LBS = manuaemps_3$AMBOINENSIS_LBS[i])
		 add_elong <- data.frame(INTERVIEW_PK = manuaemps_3$INTERVIEW_PK[i],
					CATCH_PK = manuaemps_3$CATCH_PK[i], NEW_CATCH_PK = paste(manuaemps_3$CATCH_PK[i],'E',sep=""), 
					SPECIES_FK = '261', SCIENTIFIC_NAME = 'Lethrinus elongatus', EST_LBS = manuaemps_3$ELONGATUS_LBS[i])
 		add_rubrio <- data.frame(INTERVIEW_PK = manuaemps_3$INTERVIEW_PK[i],
					CATCH_PK = manuaemps_3$CATCH_PK[i], NEW_CATCH_PK = paste(manuaemps_3$CATCH_PK[i],'R',sep=""), 
					SPECIES_FK = '267', SCIENTIFIC_NAME = 'Lethrinus rubrioperculatus', EST_LBS = manuaemps_3$RUBRIO_LBS[i])
		manuaemps_4 <- rbind(manuaemps_4,add_ambo, add_elong, add_rubrio)
	    }								#  head(manuaemps_4)
 
	  # drop dummy row 1
	  manuaemps_4 <- manuaemps_4[-1,]

	  # CHECK
	  #sum(manuaemps_4$EST_LBS)		#2078.121
	  update_interview_pks <- unique(manuaemps_4$INTERVIEW_PK)

	# update bbs_3C with these new records
		rownames(manuaemps_4) <- NULL
	
	bbs_3C_keep1 <- subset(bbs_3C, !(CATCH_PK %in% manuaemps_4$CATCH_PK))	
		#str(bbs_3C_keep1)	#48740 records

	# don't forget, we had to drop a CATCH_PK for rare interviews with multiple lethrinus / lethrinidae were recorded
	#	because we summed that catch under just 1 CATCH_PK per interview. eliminate those catch_pk that we dropped now
	#	to avoid double counting catch
	bbs_3C_keep2 <- subset(bbs_3C_keep1, !(CATCH_PK %in% drop_catch_pk$CATCH_PK))		#str(bbs_3C_keep2)  #48733 
		
	bbs_3C_update1 <- subset(bbs_3C, (CATCH_PK %in% manuaemps_4$CATCH_PK))	#str(bbs_3C_update1)	#171 records
	# View(head(bbs_3C_update1))	

	# keep only the first instance of each CATCH_PK (because some catch_pk had lengths)
	bbs_3C_update2 <- bbs_3C_update1[with(bbs_3C_update1, order(CATCH_PK)), ]
		
	# keep only the first CATCH_PK for each INTERVIEW_PK
	bbs_3C_update3 <- bbs_3C_update2[match(unique(bbs_3C_update2$CATCH_PK), bbs_3C_update2$CATCH_PK),]	
		#str(bbs_3C_update3)	#143 records

	# merge on the updated CATCH_PKs
	string <- "SELECT bbs_3C_update3.*, manuaemps_4.NEW_CATCH_PK, manuaemps_4.SPECIES_FK as NEW_SPECIES_FK,
				manuaemps_4.SCIENTIFIC_NAME as NEW_SCIENTIFIC_NAME, manuaemps_4.EST_LBS as NEW_EST_LBS
					FROM bbs_3C_update3 LEFT JOIN manuaemps_4
						ON bbs_3C_update3.CATCH_PK = manuaemps_4.CATCH_PK"
		bbs_3C_update4 <- sqldf(string, stringsAsFactors=FALSE)		
			#View(bbs_3C_update4)		#sum(bbs_3C_update4$NEW_EST_LBS)			#2078.121		#names(bbs_3C_update4)

	# use NEW_ columns in place of the original (retain same column order as bbs_3C)		#names(bbs_3C_update4)
	bbs_3C_update4$CATCH_PK <- bbs_3C_update4$NEW_CATCH_PK
	bbs_3C_update4$SPECIES_FK  <- bbs_3C_update4$NEW_SPECIES_FK
	bbs_3C_update4$SCIENTIFIC_NAME  <- bbs_3C_update4$NEW_SCIENTIFIC_NAME
	bbs_3C_update4$EST_LBS  <- bbs_3C_update4$NEW_EST_LBS
	# drop columns 98 to 101
	bbs_3C_update5 <- bbs_3C_update4[,1:97]   #sum(bbs_3C_update5$EST_LBS)	#2078.121

	# put back together with the keep records
	bbs_3C_new <- rbind(bbs_3C_keep2, bbs_3C_update5)

	# repeat the check: all manua lethrinus / lethrinidae, 1986-2020
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C_new
		  WHERE SPECIES_FK in ('262','261','267','260') AND AREA_B = 'Manua'
		  "
		manuaemps_check_again <- sqldf(string, stringsAsFactors=FALSE)	
		sum(manuaemps_check_again$EST_LBS)				# 2078.1321 lbs

	# also check that bbs_3C still contains 3068 interviews and total lbs surveyed is the same
	length(unique(bbs_3C$INTERVIEW_PK))
	#nrow(bbs_3C_new)  	#we expect lost rows because we dropped lengths and some CATCH_PK
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C_new
		  "
		tot_catch_check <- sqldf(string, stringsAsFactors=FALSE)
		

	sum(tot_catch_check$EST_LBS, na.rm=TRUE)					# 442824.1

	# update bbs_3C			
	bbs_3C <- bbs_3C_new

  # clean up workspace
  	all_objs <- ls()
  	save_objs <- c("aint_bbs_all_gears","aint_bbs_filtered","bbs_3C","root_dir","bbs_3C_before_ID_correct",
 					"p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
  					"p_amboinensis","p_rubrio")
  	remove_objs <- setdiff(all_objs, save_objs)
  
  if (1==2) {
      rm(list=remove_objs)
  	rm(save_objs)
  	rm(remove_objs)
  	rm(all_objs)
	}

  # save in the output folder.
  # 	save.image(paste(root_dir, "/output/01_BBS_data_prep.RData", sep=""))
  # save.image(paste(root_dir, "/Outputs/01_BBS_data_prep.RData", sep=""))
	
  #	load(paste(root_dir, "/output/01_BBS_data_prep.RData", sep=""))


  # take a quick look at 2021 interviews
    if (1==2) {
		string <- " SELECT DISTINCT SAMPLE_DATE, INTERVIEW_PK, VESSEL_REGIST_NO, FISHING_METHOD 
				FROM bbs_3C
		  		WHERE year = 2021"
		check2021 <- sqldf(string, stringsAsFactors=FALSE)	
		View(check2021)
	}




