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

  	library(sqldf);	library(dplyr); library(this.path); library(data.table)
  	options(scipen=999)		              # this option just forces R to never use scientific notation
  	root_dir <- this.path::here(.. = 1) # establish directories using this.path

#  --------------------------------------------------------------------------------------------------------------
#  STEP 1: read in 4 "flatview" datafiles, followed by some basic data handling

   aint_bbs1 <- fread(paste(root_dir, "/Data/a_bbs_int_flat1.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs2 <- fread(paste(root_dir, "/Data/a_bbs_int_flat2.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs3 <- fread(paste(root_dir, "/Data/a_bbs_int_flat3.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
   aint_bbs4 <- fread(paste(root_dir, "/Data/a_bbs_int_flat4.csv", sep=""), header=T, stringsAsFactors=FALSE)
   aint_bbs5 <- fread(paste(root_dir, "/Data/PICDR-113220 BB Creel Data_all_columns.csv", sep=""), header=T, stringsAsFactors=FALSE)
	
   aint_bbs5 <- aint_bbs5[,-62]       # drop var 62 ('COMMON_NAME') which is duplicated		
	
  # aint_bbs4 included 2021 interviews through May. Remove these records because they are also in aint_bbs5
   aint_bbs4$SAMPLE_YEAR <- year(aint_bbs4$SAMPLE_DATE)
   aint_bbs4             <- aint_bbs4[SAMPLE_YEAR < 2021]								
   aint_bbs4             <- select(aint_bbs4,-SAMPLE_YEAR)
	
   aint_bbs <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		
   aint_bbs <- data.table(aint_bbs)  
   
   aint_bbs$YEAR        <- as.factor(  year(aint_bbs$SAMPLE_DATE)  )
   aint_bbs$YEAR_NUM    <- as.numeric(aint_bbs$YEAR)
   aint_bbs$EST_LBS     <- as.numeric(aint_bbs$EST_LBS)
   aint_bbs$TOT_EST_LBS <- as.numeric(aint_bbs$TOT_EST_LBS)
   
   aint_bbs <- aint_bbs[YEAR_NUM != 1985] # Incomplete year
   aint_bbs <- aint_bbs[YEAR_NUM != 1111] # Database artefact

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

	#  --------------------------------------------------------------------------------------------------------------
#  STEP 2: Basic Interview Filtering
# -- 7 CATCH_PK where COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0. In all instances, there were other species caught and recorded
# within these interviews. So, eliminate the erroneous 'no catch' CATCH_PK, but keep remainder of interview

   aint_bbs <- aint_bbs[!(COMMON_NAME=="No Catch"&TOT_EST_LBS>0)]

 # -- 146 records where EST_LBS = 0 but TOT_EST_LBS > 0
   	# identify these by the CATCH_PK
	#  I know this is goofy, don't laugh at me

   STRING <- "SELECT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, COMMON_NAME, EST_LBS, TOT_EST_LBS
		 FROM aint_bbs WHERE EST_LBS = 0 AND TOT_EST_LBS > 0"
   try <- sqldf(STRING, stringsAsFactors=FALSE)
	# View(try)
   trash_catch_recs_2 <- try$CATCH_PK

   string4 <- "SELECT * FROM aint_bbs WHERE CATCH_PK NOT in
		('1986000010', '1986000090', '1986000091', '1986000093', '1986000094',
		'1986000095', '1986000097', '1986000098', '1986000107', '1986000108',
		'1986000109', '1986000133', '1986000138', '1986000142', '1986000147',
		'1986000149', '1986000150', '1986000151', '1986000154', '1986000155',
		'1986000156', '1986000161', '1986000162', '1986000164', '1986000169',
		'1986000170', '1986000172', '1986000176', '1986001109', '1986001112',
		'1986001114', '1986001116', '1986001117', '1986001118', '1986001121',
		'1986001124', '1986001125', '1986001126', '1986001127', '1986001129',
		'1986001130', '1986001132', '1986001134', '1986001135', '1986001136',
		'1986001137', '1986001141', '1986001289', '1987000003', '1987000004',
		'1987000005', '1987000006', '1987000007', '1987000009', '1987000010',
		'1987000011', '1987000012', '1987000015', '1987000016', '1987000018',
		'1987000019', '1987000026', '1987000027', '1987000031', '1987000032',
		'1987000033', '1987000034', '1987000037', '1987000038', '1987000040',
		'1987000041', '1987000043', '1987000044', '1987000049', '1987000050',
		'1987000051', '1987000052', '1987000055', '1987000058', '1987000061',
		'1987000064', '1987000067', '1987000069', '1987000071', '1987000072',
		'1987000075', '1987000076', '1987000077', '1987000079', '1987000080',
		'1987000089', '1987000090', '1987000091', '1987000095', '1987000098',
		'1987000100', '1987000105', '1987000106', '1987000107', '1987000108',
		'1987000115', '1987000116', '1987000126', '1987000130', '1987000142',
		'1987000144', '1987000147', '1987000153', '1987000165', '1987000177',
		'1988001077', '1988001084', '1988001119', '1997002158', '1997002246',
		'1997002477', '1997002914', '1997002934', '1997003011', '1997003656',
		'1997003671', '1997005057', '1997005852', '1998007171', '1999003454',
		'1999004918', '1999005653', '2000003506', '2000003518', '2001000178',
		'2001000178', '2001002719', '2002001934', '2002002056', '2014003549',
		'2016002854', '2016004225', '2017003143', '2017003143', '2017003143',
		'2017003203', '2017003203', '2017003473', '2017003473', '2018002608', '2019003155')"

   aint_bbs_new <- sqldf(string4 , stringsAsFactors=FALSE)
   nrow(aint_bbs_new)	# 141212 - 146 = 141066   (143734 - 146 = 143588)
   aint_bbs_new -> aint_bbs
   rm(aint_bbs_new)
	length(unique(aint_bbs$INTERVIEW_PK))		# 14858 interviews			(14893)
	length(unique(aint_bbs$CATCH_PK))			# 54964 catch records			(55290)

 # -- 11 interviews where TOT_EST_LBS > 0 but most other fields, including SPECIES_FK and CATCH_PK are NULL

   STRING <- "SELECT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, COMMON_NAME, EST_LBS, TOT_EST_LBS
	 FROM aint_bbs WHERE TOT_EST_LBS > 0 AND SPECIES_FK = 'NULL'"
   try <- sqldf(STRING, stringsAsFactors=FALSE)				#View(try)

   STRING7 <- "SELECT *
		 FROM aint_bbs WHERE INTERVIEW_PK NOT IN (930928880202, 970201990102, 981107990205, 990715213516, 
			120113063006, 120117063006, 120119053006, 120124062506, 
			120210180702, 120210181902, 120217143302)"
   aint_bbs_new <- sqldf(STRING7 , stringsAsFactors=FALSE)
   nrow(aint_bbs_new)	# 141055				(143577)

   aint_bbs_new -> aint_bbs
   rm(aint_bbs_new)
   nrow(aint_bbs)	
	length(unique(aint_bbs$INTERVIEW_PK))		# 14847 interviews			(14882)
	length(unique(aint_bbs$CATCH_PK))			# 54964 catch records			(55290)

 # -- 99 interviews flagged as incomplete
   string <- "SELECT *
		FROM aint_bbs
		WHERE INCOMPLETE_F is FALSE"
	
   aint_bbs <- sqldf(string, stringsAsFactors=FALSE)
	length(unique(aint_bbs$INTERVIEW_PK))		# 14748 interviews			(14783)
	length(unique(aint_bbs$CATCH_PK))			# 54150 catch records			(54476)

 # -- strange gear types:
   #	BLANK 		1 trip with gear_type "BLANK" was zero catch, exclude this record
   #	GLEANING 		???  2 gleaning trips, both caught tunas, exclude these records 
   #	NULL    		field is actually = 'NULL'. 2 trips, one was zero catch, 1 was pelagics    
   #	PALOLO FISHING 	4 trips, most fields missing data
   #	UNKNOWN - BOAT BASED	4 trips, 1 caught pelagics, 3 are missing most data
   #	VERT. LONGLINE	1 trip, caught pelagics

   STRING7 <- "SELECT *
	 FROM aint_bbs WHERE FISHING_METHOD NOT IN ('BLANK' ,'GLEANING', 'NULL', 'PALOLO FISHING', 
					'UNKNOWN - BOAT BASED','VERT. LONGLINE')"
   aint_bbs_new <- sqldf(STRING7 , stringsAsFactors=FALSE)
   nrow(aint_bbs_new)	# 138448		(140970)
	
	length(unique(aint_bbs_new$INTERVIEW_PK))		# 14734 interviews		(14769)
	length(unique(aint_bbs_new$CATCH_PK))		# 54135 catch records		(54461)


 # -- eliminate interviews missing a metric for effort. note: data dictionary is ambiguous, but previously, 
   #  HOURS_FISHED x NUM_GEAR was effort. I checked, for all geartypes this makes sense.
   #  discard any zero effort (note 38 BTM/TRL and BOTTOMFISHING interviews had 0 catch and 0 effort, these were probably canceled trips)
	
   string <- "SELECT *
	FROM aint_bbs_new
	WHERE HOURS_FISHED is not 0"
   aint_bbs <- sqldf(string, stringsAsFactors=FALSE)

   string <- "SELECT *
	FROM aint_bbs
	WHERE NUM_GEAR is not 0"
   aint_bbs <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(aint_bbs$INTERVIEW_PK))		# 14192 interviews		# 14226
	length(unique(aint_bbs$CATCH_PK))			# 52059 catch records		# 52383

	aint_bbs <- droplevels(aint_bbs)		# summary(as.factor(aint_bbs$FISHING_METHOD))

  #  ------------------------------------------------------------------------------------------------
  #  ------------------------  SAVE THIS AS THE "ALL GEARS" DATASET  --------------------------------
  #  -------  use the all_gears dataset for some figures in the data report

   aint_bbs_all_gears <- aint_bbs			# str(aint_bbs_all_gears)
   rm(aint_bbs)

  #  ------------------------------------------------------------------------------------------------
  #  ------------------------  ADDITIONAL PROCESSING OF BFISH GEARS  --------------------------------

   string <- "SELECT *
		FROM aint_bbs_all_gears
		WHERE FISHING_METHOD in ('BOTTOMFISHING','BTM/TRL MIX')"
	
   aint_bbs <- sqldf(string, stringsAsFactors=FALSE)	
	length(unique(aint_bbs$INTERVIEW_PK))		# 3066 interviews		(3068)
	length(unique(aint_bbs$CATCH_PK))			# 21929 catch records	(21940)
	
  # WATCH OUT- there were 779 interviews, 3105 catch records, that included NUM_KEPT = 0 but catch weight was recorded
	# skimming through, it is obvious that the number of fish that must have been included in these weights was greater than 1.
	# SO- ALWAYS USE CAUTION when talking about numbers: NUM_KEPT IS NOT a dependable record of number of fish caught.
	# for weight-based CPUE, these interviews can be used.
	# For anything numbers or weight per fish based, consider using records by SIZE_PK only, and at the least, exclude these interviews.

  # save this as filtered
	aint_bbs_filtered <- aint_bbs


#  --------------------------------------------------------------------------------------------------------------
#  STEP 3: Add area variables

 # -- convert AREA_FK (which includes specific villages) to John's slightly larger PRIMARY_AREA_FK, see map
 # note: PRIMARY_AREA_FK = 30 is basically the trash can / unknown area (surprisingly common).	
   key <- read.csv(paste(root_dir, "/data/A_area.csv", sep=""), header=T)
   nrow(key)	#125

   string <- "SELECT aint_bbs_filtered.*, key.PRIMARY_AREA_FK			
	FROM aint_bbs_filtered LEFT JOIN key
			ON aint_bbs_filtered.AREA_FK = key.AREA_PK"
   bbs_2 <- sqldf(string, stringsAsFactors=FALSE)
   nrow(bbs_2)	#49242	 	#nrow(aint_bbs_filtered)

   bbs_2$PRIMARY_AREA_FK <- as.factor(bbs_2$PRIMARY_AREA_FK)
   bbs_2$VESSEL_REGIST_NO <- as.factor(bbs_2$VESSEL_REGIST_NO)
   bbs_2$FISHING_METHOD <- as.factor(bbs_2$FISHING_METHOD)
   bbs_2$INTERVIEWER1_FK <- as.factor(bbs_2$INTERVIEWER1_FK)

 # -- add more area designations from metadata file 
   B_area <- read.csv(paste(root_dir, "/data/METADATA_areas.csv", sep=""),header=T,stringsAsFactors=FALSE)
   B_area_BBS <- subset(B_area, DATASET == "BBS")
   B_area_BBS$AREA_RAW <- as.integer(B_area_BBS$AREA_RAW)	# View(B_area_BBS)	#head(B_area_BBS)

   string <- "SELECT bbs_2.*, B_area_BBS.AREA as AREA_B, B_area_BBS.AREA_2BANKS as AREA_2banks, B_area_BBS.AREA_WIND as AREA_WIND
	FROM bbs_2
	LEFT JOIN B_area_BBS
		ON bbs_2.AREA_FK = B_area_BBS.AREA_RAW"
   bbs_3 <- sqldf(string, stringsAsFactors=FALSE)
   bbs_3$AREA_B <- as.factor(bbs_3$AREA_B)
   bbs_3$AREA_2banks <- as.factor(bbs_3$AREA_2banks)	# summary(bbs_3$AREA_2banks)
	nrow(bbs_3)			# 49242	 	# nrow(aint_bbs_filtered)	#str(bbs_3)
	# summary(bbs_3$AREA_B)
	# summary(bbs_3$AREA_2banks)
	# summary(bbs_3$FISHING_METHOD)

   # use mutate to add another area w/ 1 Tutuila 
   bbs_3B <- mutate(bbs_3, AREA_B2 = as.character(AREA_2banks))
   bbs_3B$AREA_B2[bbs_3B$AREA_B2 == "Tut_North"] <- "Tutuila"
   bbs_3B$AREA_B2[bbs_3B$AREA_B2 == "Tut_South"] <- "Tutuila"
   bbs_3B$AREA_B2 <- as.factor(bbs_3B$AREA_B2)
   summary(bbs_3B$AREA_B2)		# nrow(bbs_3B)
   length(unique(bbs_3B$INTERVIEW_PK))		# 3068 interviews

   # make a new copy
   bbs_3C <- bbs_3B

 
 # -- add misc. variables

  # month
   bbs_3C <- mutate(bbs_3C, month = as.numeric(substr(INTERVIEW_TIME, 6, 7)))
   	# str(bbs_3C)
   bbs_3C$month <- as.factor(bbs_3C$month)
	# summary(bbs_3C$month)

   # season: 12-1-2 = summer, 3-4-5 = fall, 6-7-8 = winter, 9-10-11 = spring
   bbs_3C <- mutate(bbs_3C, season = as.numeric(substr(INTERVIEW_TIME, 6,7)))
   bbs_3C$season[bbs_3C$season == 3] <- 'fall'
   bbs_3C$season[bbs_3C$season == 4] <- 'fall'
   bbs_3C$season[bbs_3C$season == 5] <- 'fall'
   bbs_3C$season[bbs_3C$season == 6] <- 'winter'
   bbs_3C$season[bbs_3C$season == 7] <- 'winter'
   bbs_3C$season[bbs_3C$season == 8] <- 'winter'
   bbs_3C$season[bbs_3C$season == 9] <- 'spring'
   bbs_3C$season[bbs_3C$season == 10] <- 'spring'
   bbs_3C$season[bbs_3C$season == 11] <- 'spring'
   bbs_3C$season[bbs_3C$season == 12] <- 'summer'
   bbs_3C$season[bbs_3C$season == 1] <- 'summer'
   bbs_3C$season[bbs_3C$season == 2] <- 'summer'

   bbs_3C$season <- as.factor(bbs_3C$season)
	# summary(bbs_3C$season)

  # time of day
   # "morning shift" is 0500-1330, evening shift is 1400-2230
   #  or try 6-hour blocks

   bbs_3C <- mutate(bbs_3C, hour = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
 	# str(bbs_3C)
   bbs_3C <- mutate(bbs_3C, shift = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
	# str(bbs_3C)

   bbs_3C$shift[bbs_3C$shift >= 5 & bbs_3C$shift < 14] <- 'am' 
   bbs_3C$shift[bbs_3C$shift >= 14 & bbs_3C$shift < 23] <- 'pm' 
   bbs_3C$shift[bbs_3C$shift == '23'] <- 'other' 
   bbs_3C$shift[bbs_3C$shift < 5] <- 'other' 

   bbs_3C$shift <- as.factor(bbs_3C$shift)
	# summary(bbs_3C$shift)
 
   bbs_3C <- mutate(bbs_3C, tod_quarter = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
	# str(bbs_3C)

   bbs_3C$tod_quarter[bbs_3C$hour >= 0 & bbs_3C$hour < 6] <- '0000-0600' 
   bbs_3C$tod_quarter[bbs_3C$hour  >= 6 & bbs_3C$hour  < 12] <- '0600-1200' 
   bbs_3C$tod_quarter[bbs_3C$hour  >= 12 & bbs_3C$hour  < 18] <- '1200-1800' 
   bbs_3C$tod_quarter[bbs_3C$hour  >= 18 & bbs_3C$hour  < 24] <- '1800-2400' 

   bbs_3C$tod_quarter<- as.factor(bbs_3C$tod_quarter)
	# summary(bbs_3C$tod_quarter)

  # type of day as factor
   bbs_3C$TYPE_OF_DAY <- as.factor(bbs_3C$TYPE_OF_DAY)

 # reclassify the non-main ports= ASILI, GENERAL TUTUILA PORT, LEONE, VATIA
   bbs_3C$PORT_NAME <- as.factor(bbs_3C$PORT_NAME)
  	# summary(bbs_3C$PORT_NAME)

   bbs_3C <- mutate(bbs_3C, port_simple = as.character(PORT_NAME))
   bbs_3C$port_simple[bbs_3C$PORT_NAME == 'ASILI'] <- 'Tutuila_Other'
   bbs_3C$port_simple[bbs_3C$PORT_NAME == 'GENERAL TUTUILA PORT'] <- 'Tutuila_Other'
   bbs_3C$port_simple[bbs_3C$PORT_NAME == 'LEONE'] <- 'Tutuila_Other'
   bbs_3C$port_simple[bbs_3C$PORT_NAME == 'VATIA'] <- 'Tutuila_Other'
   bbs_3C$port_simple <- as.factor(bbs_3C$port_simple)
  	# summary(bbs_3C$port_simple)

# make a copy of bbs_3C
  bbs_3C_before_ID_correct <- bbs_3C


#  --------------------------------------------------------------------------------------------------------------
#  STEP 4: update BBS_3C to address some species identification issues.

# ----- 4a. Variola louti and Variola albimarginata have been confused between 1986-2015. Some fishermen in both workshops
#		indicated that they didn't distinguish between the white-tail and yellow-tail. In Tutuila, they call the
#		yellow tail (louti) velo, and they call the white tail (albimarginata) papa. However, it seems in Manu'a both species
#		are called velo. 'papa' is totally different (the tomato grouper, Cephalopholis sonnerati).
#		Assume 2016-2020 BBS species identifications are reliable
 		
		# Prepare a check: total lbs surveyed in bbs_3C
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C
		  "
		tot_catch_check_0 <- sqldf(string, stringsAsFactors=FALSE)
		sum(tot_catch_check_0$EST_LBS, na.rm=TRUE)					# 442824.1

		# prepare a check: all variola, 1986-2021
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C
		  WHERE SPECIES_FK in ('229','220')
		  "
		variola_check <- sqldf(string, stringsAsFactors=FALSE)	
		sum_variola <- sum(variola_check$EST_LBS)				# 14100.09 lbs

	# calculate sum(V. louti)/sum(V. louti, V. albimarginata) for 2016-2021, all areas, bottomfishing and btm/trl mix
  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE SPECIES_FK in ('229','220') AND YEAR_NUM > 2015) 
		  GROUP BY SPECIES_FK"
	variola_1 <- sqldf(string, stringsAsFactors=FALSE)
	p_louti <- variola_1$TOT_LBS[2]/(variola_1$TOT_LBS[1]+variola_1$TOT_LBS[2])
	p_albimarginata <- 1-p_louti			# will save p_louti and p_albimarginata to adjust expanded landings estimates.

	# list all interview_pk, catch_pk that included either species, 1986-2015
	string <- "SELECT DISTINCT YEAR_NUM, INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
		  	FROM bbs_3C
			WHERE SPECIES_FK in ('229','220') AND YEAR_NUM < 2016
		  	"
	variola_2 <- sqldf(string, stringsAsFactors=FALSE)	#str(variola_2)		#View(variola_2)  #sum(variola_2$EST_LBS)
	# 1249 catch records, 13817.48 lbs total
	
	# divide interviews into those which caught just 1 of the variola species, and those which caught both
		# add N_CATCH_PK column
		string <- "SELECT INTERVIEW_PK, count(CATCH_PK) as N_CATCH_PK
			FROM (SELECT DISTINCT INTERVIEW_PK, CATCH_PK
		  		FROM variola_2)
			GROUP BY INTERVIEW_PK
			ORDER BY N_CATCH_PK
			"
		both_sp_question <- sqldf(string, stringsAsFactors=FALSE)			#View(both_sp_question)	

		string <- "SELECT variola_2.*, both_sp_question.N_CATCH_PK
					FROM variola_2 LEFT JOIN both_sp_question
						ON variola_2.INTERVIEW_PK = both_sp_question.INTERVIEW_PK"
		variola_2B <- sqldf(string, stringsAsFactors=FALSE)		# sum(variola_2B$EST_LBS)		#View(variola_2B)

		just_1_sp <- subset(variola_2B, N_CATCH_PK == 1)			# View(just_1_sp)
		just_1_spB <- just_1_sp[,c(2,3,6)]						# View(just_1_spB)
			rownames(just_1_spB) <- NULL
		both_sp <- subset(variola_2B, N_CATCH_PK == 2)				# View(both_sp)		#sum(both_sp$EST_LBS)
		
		#  ----- CAREFUL!!!
		#   If we do an SQL query on 2 variables but GROUP BY only 1 variable, than only the first instance of the other variable
		#	will be retained. This can result in lost / potentially misleading data if there are multiple values for the second variable
		#   In this unusual case, we want to lose those CATCH_PK.
		#   Always make sure this is happening the way we expect.
		string <- "SELECT INTERVIEW_PK, CATCH_PK, sum(EST_LBS) as sum_variola
			FROM both_sp
			GROUP BY INTERVIEW_PK
			"
		both_sp2 <- sqldf(string, stringsAsFactors=FALSE)	#View(both_sp2)		#sum(both_sp2$sum_variola)	
		names(both_sp2)[3] <- 'EST_LBS'				#sum(both_sp2$EST_LBS)	#156.3, we expect this to be small.

		# List the CATCH_PK (eliminated in previous step) that we will drop later:
		drop_catch_pk <- subset(both_sp, !(CATCH_PK %in% both_sp2$CATCH_PK))

	variola_2C <- rbind(just_1_spB, both_sp2)						# sum(variola_2C$EST_LBS)	

	# make a column of EST_LBS for each species
	variola_3 <- mutate(variola_2C, LOUTI_LBS = round(EST_LBS*p_louti,3), 
				ALBIMARGINATA_LBS = round(EST_LBS*p_albimarginata,3))	  #str(variola_3)	#View(variola_3)
			# sum(variola_3$LOUTI_LBS)+sum(variola_3$ALBIMARGINATA_LBS)

	# loop through variola_3. For each original CATCH_PK, we must create a new CATCH_PK&L and CATCH_PK&A for each Louti and Albimarginata
	  # create dummy df to append to
	  variola_4 <- data.frame(INTERVIEW_PK = 9999, CATCH_PK = 'abc', 
				NEW_CATCH_PK = 'abc', SPECIES_FK = 'abc', SCIENTIFIC_NAME = 'abc', EST_LBS = 9999)		#str(variola_4)		
	
	  for (i in 1:nrow(variola_3)) {
		 add_louti <- data.frame(INTERVIEW_PK = variola_3$INTERVIEW_PK[i],
					CATCH_PK = variola_3$CATCH_PK[i], NEW_CATCH_PK = paste(variola_3$CATCH_PK[i],'L',sep=""), 
					SPECIES_FK = '229', SCIENTIFIC_NAME = 'Variola louti', EST_LBS = variola_3$LOUTI_LBS[i])
		 add_albimarginata <- data.frame(INTERVIEW_PK = variola_3$INTERVIEW_PK[i],
					CATCH_PK = variola_3$CATCH_PK[i], NEW_CATCH_PK = paste(variola_3$CATCH_PK[i],'A',sep=""), 
					SPECIES_FK = '220', SCIENTIFIC_NAME = 'Variola albimarginata', EST_LBS = variola_3$ALBIMARGINATA_LBS[i])
 		variola_4 <- rbind(variola_4, add_louti, add_albimarginata)
	    }
 
	  # drop dummy row 1
	  variola_4 <- variola_4[-1,]

	  # CHECK
	  #sum(variola_4$EST_LBS)		#View(variola_4)			#str(variola_4)
	  update_interview_pks <- unique(variola_4$INTERVIEW_PK)

	# update bbs_3C with these new records
		rownames(variola_4) <- NULL
	
	bbs_3C_keep1 <- subset(bbs_3C, !(CATCH_PK %in% variola_4$CATCH_PK))	
		#str(bbs_3C_keep1)	#46516 records

	# don't forget, we had to drop a CATCH_PK for interviews where both V. louti and V. albimarginata were recorded
	#	because we summed that catch under just 1 CATCH_PK per interview. eliminate those catch_pk that we dropped now
	#	to avoid double counting catch
	bbs_3C_keep2 <- subset(bbs_3C_keep1, !(CATCH_PK %in% drop_catch_pk$CATCH_PK))		#str(bbs_3C_keep2)  #46489 
		
	bbs_3C_update1 <- subset(bbs_3C, (CATCH_PK %in% variola_4$CATCH_PK))	#str(bbs_3C_update1)	#2726 records
	# View(head(bbs_3C_update1))	

	# keep only the first instance of each CATCH_PK (because some catch_pk had lengths)
	bbs_3C_update2 <- bbs_3C_update1[with(bbs_3C_update1, order(CATCH_PK)), ]
		
	# keep only the first CATCH_PK for each INTERVIEW_PK
	bbs_3C_update3 <- bbs_3C_update2[match(unique(bbs_3C_update2$CATCH_PK), bbs_3C_update2$CATCH_PK),]	
		#str(bbs_3C_update3)	#1233 records

	# merge on the updated CATCH_PKs
	string <- "SELECT bbs_3C_update3.*, variola_4.NEW_CATCH_PK, variola_4.SPECIES_FK as NEW_SPECIES_FK,
				variola_4.SCIENTIFIC_NAME as NEW_SCIENTIFIC_NAME, variola_4.EST_LBS as NEW_EST_LBS
					FROM bbs_3C_update3 LEFT JOIN variola_4
						ON bbs_3C_update3.CATCH_PK = variola_4.CATCH_PK"
		bbs_3C_update4 <- sqldf(string, stringsAsFactors=FALSE)		
			#View(bbs_3C_update4)		#sum(bbs_3C_update4$NEW_EST_LBS)			#13817.48

	# use NEW_ columns in place of the original (retain same column order as bbs_3C)		#names(bbs_3C_update4)
	bbs_3C_update4$CATCH_PK <- bbs_3C_update4$NEW_CATCH_PK
	bbs_3C_update4$SPECIES_FK  <- bbs_3C_update4$NEW_SPECIES_FK
	bbs_3C_update4$SCIENTIFIC_NAME  <- bbs_3C_update4$NEW_SCIENTIFIC_NAME
	bbs_3C_update4$EST_LBS  <- bbs_3C_update4$NEW_EST_LBS
	# drop columns 98 to 101
	bbs_3C_update5 <- bbs_3C_update4[,1:97]   #sum(bbs_3C_update5$EST_LBS)	#13817.48

	# put back together with the keep records
	bbs_3C_new <- rbind(bbs_3C_keep2, bbs_3C_update5)		#sum(bbs_3C_new

	# repeat the check: all variola, 1986-2021
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C_new
		  WHERE SPECIES_FK in ('229','220')
		  "
		variola_check_2 <- sqldf(string, stringsAsFactors=FALSE)	
		sum_variola_2 <- sum(variola_check_2$EST_LBS)				# 14100.09 lbs
		sum_variola_2
		sum_variola

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

# ----- 4b. Pristipomoides filamentosus and P. flavipinnis were confused between 2010-2015. Assume 2016-2021 species is reliable.
 		 
		# prepare a check: all flavi and fila, 1986-2020
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C
		   WHERE SPECIES_FK in ('242','241')
		  "
		flavi_fila_check <- sqldf(string, stringsAsFactors=FALSE)	
		sum_flavi_fila <- sum(flavi_fila_check$EST_LBS)		# 7577.458 lbs

	# calculate sum(P. flavi)/sum(P. flavi, P. fila) for 2016-2021, all areas, bottomfishing and btm/trl mix
  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE SPECIES_FK in ('242','241') AND YEAR_NUM > 2015) 
		  GROUP BY SPECIES_FK"
	flavi_fila_1 <- sqldf(string, stringsAsFactors=FALSE)
	p_flavi <- flavi_fila_1$TOT_LBS[1]/(flavi_fila_1$TOT_LBS[1]+flavi_fila_1$TOT_LBS[2])
	p_fila <- 1-p_flavi			#note, fishermen in workshops generally reported 1 filamentosus to 10 flavipinis.
		# in Tutuila, a fishermen said that palu-sina chases away the palu-'ena-'ena

	# list all interview_pk, catch_pk that included either species, 2010-2015
	string <- "SELECT DISTINCT YEAR_NUM, INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
		  	FROM bbs_3C
			WHERE SPECIES_FK in ('242','241') AND YEAR_NUM < 2016 AND YEAR_NUM > 2009
		  	"
	flavi_fila_2 <- sqldf(string, stringsAsFactors=FALSE)	#str(flavi_fila_2) #View(flavi_fila_2)  #sum(flavi_fila_2$EST_LBS)
	# 68 catch records, 1071.118 lbs total
	
	# divide interviews into those which caught just 1 of the species, and those which caught both (or 3)
		# add N_CATCH_PK column
		string <- "SELECT INTERVIEW_PK, count(CATCH_PK) as N_CATCH_PK
			FROM (SELECT DISTINCT INTERVIEW_PK, CATCH_PK
		  		FROM flavi_fila_2)
			GROUP BY INTERVIEW_PK
			ORDER BY N_CATCH_PK
			"
		both_sp_question <- sqldf(string, stringsAsFactors=FALSE)			#View(both_sp_question)	
		# note, there is an INTERVIEW_PK with 3 species (this is probably because it originally contained P. rutilans)

		string <- "SELECT flavi_fila_2.*, both_sp_question.N_CATCH_PK
					FROM flavi_fila_2 LEFT JOIN both_sp_question
						ON flavi_fila_2.INTERVIEW_PK = both_sp_question.INTERVIEW_PK"
		flavi_fila_2B <- sqldf(string, stringsAsFactors=FALSE)		# sum(flavi_fila_2B$EST_LBS)		#View(flavi_fila_2B)

		just_1_sp <- subset(flavi_fila_2B, N_CATCH_PK == 1)			# View(just_1_sp)
		just_1_spB <- just_1_sp[,c(2,3,6)]						# View(just_1_spB)
			rownames(just_1_spB) <- NULL
		both_sp <- subset(flavi_fila_2B, N_CATCH_PK > 1)				# View(both_sp)		#sum(both_sp$EST_LBS)
		
		#  ----- CAREFUL!!!
		#   As in step 4a. with Variola, this is an unconventional way to use an SQL GROUP BY query.
		string <- "SELECT INTERVIEW_PK, CATCH_PK, sum(EST_LBS) as sum_flavi_fila
			FROM both_sp
			GROUP BY INTERVIEW_PK
			"
		both_sp2 <- sqldf(string, stringsAsFactors=FALSE)			#View(both_sp2)	
		names(both_sp2)[3] <- 'EST_LBS'						#sum(both_sp2$EST_LBS)		#113.669 lbs

		# these are the CATCH_PK that we drop all together
		drop_catch_pk <- subset(both_sp, !(CATCH_PK %in% both_sp2$CATCH_PK))

	flavi_fila_2C <- rbind(just_1_spB, both_sp2)						# sum(variola_2C$EST_LBS)	

	# make a column of EST_LBS for each species
	flavi_fila_3 <- mutate(flavi_fila_2C, FLAVI_LBS = round(EST_LBS*p_flavi,3), 
				FILA_LBS = round(EST_LBS*p_fila,3))	  #str(flavi_fila_3)	#View(flavi_fila_3)
			# sum(flavi_fila_3$FILA_LBS)+sum(flavi_fila_3$FLAVI_LBS)

	# loop through flavi_fila_3. For each original CATCH_PK, we must create a new CATCH_PK&FL and CATCH_PK&FI
	  # create dummy df to append to
	  flavi_fila_4 <- data.frame(INTERVIEW_PK = 9999, CATCH_PK = 'abc', 
				NEW_CATCH_PK = 'abc', SPECIES_FK = 'abc', SCIENTIFIC_NAME = 'abc', EST_LBS = 9999)		#str(variola_4)		
	
	  for (i in 1:nrow(flavi_fila_3)) {
		 add_flavi <- data.frame(INTERVIEW_PK = flavi_fila_3$INTERVIEW_PK[i],
					CATCH_PK = flavi_fila_3$CATCH_PK[i], NEW_CATCH_PK = paste(flavi_fila_3$CATCH_PK[i],'FL',sep=""), 
					SPECIES_FK = '241', SCIENTIFIC_NAME = 'Pristipomoides flavipinnis', 
					EST_LBS = flavi_fila_3$FLAVI_LBS[i])
		 add_fila <- data.frame(INTERVIEW_PK = flavi_fila_3$INTERVIEW_PK[i],
					CATCH_PK = flavi_fila_3$CATCH_PK[i], NEW_CATCH_PK = paste(flavi_fila_3$CATCH_PK[i],'FI',sep=""), 
					SPECIES_FK = '242', SCIENTIFIC_NAME = 'Pristipomoides filamentosus', 
					EST_LBS = flavi_fila_3$FILA_LBS[i])
 		flavi_fila_4 <- rbind(flavi_fila_4, add_flavi, add_fila)
	    }
 


	  # drop dummy row 1
	  flavi_fila_4 <- flavi_fila_4[-1,]
	  
	  # CHECK IT
	  #sum(flavi_fila_4$EST_LBS)		# 1071.118 lbs
	  update_interview_pks <- unique(flavi_fila_4$INTERVIEW_PK)

	# update bbs_3C with these new records
		rownames(flavi_fila_4) <- NULL
	
	bbs_3C_keep1 <- subset(bbs_3C, !(CATCH_PK %in% flavi_fila_4$CATCH_PK))	
		#str(bbs_3C_keep1)	#48791 records		#str(bbs_3C)		#48791 + 164 = 48955

	# don't forget, we had to drop a CATCH_PK for interviews where both fila and flavi (and rutilans) were recorded
	#	because we summed that catch under just 1 CATCH_PK per interview. eliminate those catch_pk that we dropped now
	#	to avoid double counting catch
	bbs_3C_keep2 <- subset(bbs_3C_keep1, !(CATCH_PK %in% drop_catch_pk$CATCH_PK))		#str(bbs_3C_keep2)  #48748 
		
	bbs_3C_update1 <- subset(bbs_3C, (CATCH_PK %in% flavi_fila_4$CATCH_PK))	#str(bbs_3C_update1)	#164 records
	# View(head(bbs_3C_update1))	

	# keep only the first instance of each CATCH_PK (because some catch_pk had lengths)
	bbs_3C_update2 <- bbs_3C_update1[with(bbs_3C_update1, order(CATCH_PK)), ]
		
	# keep only the first CATCH_PK for each INTERVIEW_PK
	bbs_3C_update3 <- bbs_3C_update2[match(unique(bbs_3C_update2$CATCH_PK), bbs_3C_update2$CATCH_PK),]	
		#str(bbs_3C_update3)	#65 records

	# merge on the updated CATCH_PKs
	string <- "SELECT bbs_3C_update3.*, flavi_fila_4.NEW_CATCH_PK, flavi_fila_4.SPECIES_FK as NEW_SPECIES_FK,
				flavi_fila_4.SCIENTIFIC_NAME as NEW_SCIENTIFIC_NAME, flavi_fila_4.EST_LBS as NEW_EST_LBS
					FROM bbs_3C_update3 LEFT JOIN flavi_fila_4
						ON bbs_3C_update3.CATCH_PK = flavi_fila_4.CATCH_PK"
		bbs_3C_update4 <- sqldf(string, stringsAsFactors=FALSE)		
			#View(bbs_3C_update4)		#sum(bbs_3C_update4$NEW_EST_LBS)			#1071.118

	# use NEW_ columns in place of the original (retain same column order as bbs_3C)		#names(bbs_3C_update4)
	bbs_3C_update4$CATCH_PK <- bbs_3C_update4$NEW_CATCH_PK
	bbs_3C_update4$SPECIES_FK  <- bbs_3C_update4$NEW_SPECIES_FK
	bbs_3C_update4$SCIENTIFIC_NAME  <- bbs_3C_update4$NEW_SCIENTIFIC_NAME
	bbs_3C_update4$EST_LBS  <- bbs_3C_update4$NEW_EST_LBS
	# drop columns 98 to 101
	bbs_3C_update5 <- bbs_3C_update4[,1:97]   #sum(bbs_3C_update5$EST_LBS)	#1071.118

	# put back together with the keep records
	bbs_3C_new <- rbind(bbs_3C_keep2, bbs_3C_update5)		#sum(bbs_3C_new

	# repeat the check: all flavi and fila, 1986-2020
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C_new
		  WHERE SPECIES_FK in ('242','241')
		  "
		flavi_fila_check_2 <- sqldf(string, stringsAsFactors=FALSE)	
		sum_flavi_fila_2 <- sum(flavi_fila_check_2$EST_LBS)				# 7577.458 lbs
		sum_flavi_fila
		sum_flavi_fila_2

	# also check that bbs_3C still contains 3068 interviews, correct total catch
	length(unique(bbs_3C$INTERVIEW_PK))
	#nrow(bbs_3C_new)  	#we expect lost rows because we dropped lengths and some CATCH_PK
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM bbs_3C_new
		  "
		tot_catch_check <- sqldf(string, stringsAsFactors=FALSE)
		sum(tot_catch_check$EST_LBS, na.rm=TRUE)					# 442824.1 lbs

	# update bbs_3C			
	bbs_3C <- bbs_3C_new


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
	string <- "SELECT DISTINCT YEAR_NUM, INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
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




