#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA DATA REPORT - INITIAL DATA HANDLING
#	Data preparation for BOAT BASED creel survey: 
#	*** updated Oct 6, 2021 with data received from Penlong JIRA ticket 113156
#	    should be ALL interviews, all gears, all years, all species, etc.
#	Erin Bohaboy erin.bohaboy@noaa.gov
#		includes some code written by John Syslo for the 2019 assessment
#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  	library(tidyr)
	library(ggplot2)
  	options(scipen=999)		# this option just forces R to never use scientific notation

#  STEP 1: read in 4 "flatview" datafiles


   aint_bbs1 <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/a_bbs_int_flat1.csv",
					header=T, stringsAsFactors=FALSE) 			#  str(aint_bbs1)
   aint_bbs2 <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/a_bbs_int_flat2.csv",
					header=T, stringsAsFactors=FALSE) 			#  str(aint_bbs2)
   aint_bbs3 <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/a_bbs_int_flat3.csv",
					header=T, stringsAsFactors=FALSE) 			#  str(aint_bbs3)
   aint_bbs4 <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/a_bbs_int_flat4.csv",
					header=T, stringsAsFactors=FALSE) 			#  str(aint_bbs4)
   aint_bbs <- rbind(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4)
	str(aint_bbs)		# 141,659 records, 82 variables

#	head(aint_bbs)	# str(aint_bbs)
# all interviews received from Michael Quach June 2020
# 51274 records. Includes 60 interviews where catch = 0. careful how we treat these, but for this purpose they can be ignored

 # Need to replace SPECIES_FK 243 (Pristipomoides rutilans) with 247 (Aphareus rutilans)
   aint_bbs$SCIENTIFIC_NAME[aint_bbs$SPECIES_FK==243]<-"Aphareus rutilans"
   aint_bbs$SPECIES_FK[aint_bbs$SPECIES_FK==243]<-247

   aint_bbs <- mutate(aint_bbs, SAMPLE_DATE_CH = as.character(SAMPLE_DATE))
   aint_bbs <- mutate(aint_bbs, SAMPLE_YEAR = substr(SAMPLE_DATE_CH,1,4))
   aint_bbs$year <- as.factor(aint_bbs$SAMPLE_YEAR)
   aint_bbs <- mutate(aint_bbs, year_num = as.numeric(SAMPLE_YEAR))
   aint_bbs$EST_LBS <- as.numeric(aint_bbs$EST_LBS)
   aint_bbs$TOT_EST_LBS <- as.numeric(aint_bbs$TOT_EST_LBS)
  #	str(aint_bbs)		#for some reason R assumes just about everything is character

		length(unique(aint_bbs$INTERVIEW_PK))		# 15081 interviews
		length(unique(aint_bbs$CATCH_PK))			# 55548 catch records

	#  drop 1985 and 1111 now
	aint_bbs <- subset(aint_bbs, year_num != 1985)
	aint_bbs <- subset(aint_bbs, year_num != 1111)

	nrow(aint_bbs)		# 141219
		length(unique(aint_bbs$INTERVIEW_PK))		# 14858 interviews
		length(unique(aint_bbs$CATCH_PK))			# 55112 catch records

#  STEP 2: find and deal with all weird records while dealing with zeros
#	NOTE: don't worry too much about gear types that aren't BOTTOMFISHING or BTM/TRL MIX

   # 7 records where COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0. In all instances, there were other species caught and recorded
		# within these interviews
		# so just trash these particular records but keep the interviews and other catches. Find them and then remove by CATCH_PK
		# weird interviews: '41013100004',  '80218153004',  '90506125704', '121010060005', '121011050005', '131202050005', '140526054505'	

		# string3 <- "SELECT INTERVIEW_PK, TOT_EST_LBS, SPECIES_FK, NUM_KEPT, EST_LBS, SCIENTIFIC_NAME, COMMON_NAME   
		#	FROM aint_bbs WHERE INTERVIEW_PK in
		#	('41013100004',  '80218153004',  '90506125704', '121010060005', '121011050005', '131202050005', '140526054505')"
		#	TRY3 <- sqldf(string3 , stringsAsFactors=FALSE)
		#	View(TRY3)

	STRING <- "SELECT * FROM aint_bbs WHERE COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0"
	try <- sqldf(STRING, stringsAsFactors=FALSE)
	# View(try)
	trash_catch_recs <- try$CATCH_PK		#try$INTERVIEW_PK

	nrow(aint_bbs)

	string3 <- "SELECT * FROM aint_bbs WHERE CATCH_PK NOT in
		('2004004889', '2008007210', '2009002628', '2012004605', '2012004622', '2013005789', '2014002489')"
	aint_bbs_new <- sqldf(string3 , stringsAsFactors=FALSE)
	nrow(aint_bbs_new)

	aint_bbs_new -> aint_bbs		# 141212 records

	rm(aint_bbs_new)
	
		length(unique(aint_bbs$INTERVIEW_PK))		# 14858 interviews
		length(unique(aint_bbs$CATCH_PK))			# 55105 catch records (removed 7 catch records)

   # 146 records where EST_LBS = 0 but TOT_EST_LBS > 0
   	# identify these by the CATCH_PK
	#  I know this is goofy, don't laugh at me

	STRING <- "SELECT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, COMMON_NAME, EST_LBS, TOT_EST_LBS
			 FROM aint_bbs WHERE EST_LBS = 0 AND TOT_EST_LBS > 0"
	try <- sqldf(STRING, stringsAsFactors=FALSE)
	View(try)
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
	nrow(aint_bbs_new)	# 141212 - 146 = 141066 

	aint_bbs_new -> aint_bbs
	rm(aint_bbs_new)
	nrow(aint_bbs)

		length(unique(aint_bbs$INTERVIEW_PK))		# 14858 interviews
		length(unique(aint_bbs$CATCH_PK))			# 54964 catch records

  # 11 interviews where TOT_EST_LBS > 0 but most other fields, including SPECIES_FK and CATCH_PK are NULL
	# trash these

	STRING <- "SELECT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, COMMON_NAME, EST_LBS, TOT_EST_LBS
			 FROM aint_bbs WHERE TOT_EST_LBS > 0 AND SPECIES_FK = 'NULL'"
	try <- sqldf(STRING, stringsAsFactors=FALSE)
	View(try)
	try$INTERVIEW_PK

	STRING7 <- "SELECT *
			 FROM aint_bbs WHERE INTERVIEW_PK NOT IN (930928880202, 970201990102, 981107990205, 990715213516, 
						120113063006, 120117063006, 120119053006, 120124062506, 
						120210180702, 120210181902, 120217143302)"
	aint_bbs_new <- sqldf(STRING7 , stringsAsFactors=FALSE)
	nrow(aint_bbs_new)	# 141055

	aint_bbs_new -> aint_bbs
	rm(aint_bbs_new)
	nrow(aint_bbs)
	
		length(unique(aint_bbs$INTERVIEW_PK))		# 14847 interviews
		length(unique(aint_bbs$CATCH_PK))			# 54964 catch records

  # interviews flagged as incomplete
 	string <- "SELECT *
			FROM aint_bbs
			WHERE INCOMPLETE_F is FALSE"
	
	aint_bbs <- sqldf(string, stringsAsFactors=FALSE)	
		
		length(unique(aint_bbs$INTERVIEW_PK))		# 14748 interviews
		length(unique(aint_bbs$CATCH_PK))			# 54150 catch records

#  eliminate strange gear types:
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
	nrow(aint_bbs_new)	# 138448
	
		length(unique(aint_bbs_new$INTERVIEW_PK))		# 14734 interviews
		length(unique(aint_bbs_new$CATCH_PK))		# 54135 catch records


  # eliminate interviews missing a metric for effort. note: data dictionary is ambiguous, but previously, 
  #   HOURS_FISHED x NUM_GEAR was effort. I checked, for all remaining geartypes this makes sense.
	# discard any zero effort (note 38 BTM/TRL and BOTTOMFISHING interviews had 0 catch and 0 effort, these were probably canceled trips)
	string <- "SELECT *
			FROM aint_bbs_new
			WHERE HOURS_FISHED is not 0"
	
	aint_bbs <- sqldf(string, stringsAsFactors=FALSE)

	string <- "SELECT *
			FROM aint_bbs
			WHERE NUM_GEAR is not 0"
	
	aint_bbs <- sqldf(string, stringsAsFactors=FALSE)

		
		length(unique(aint_bbs$INTERVIEW_PK))		# 14192 interviews
		length(unique(aint_bbs$CATCH_PK))			# 52059 catch records

	aint_bbs <- droplevels(aint_bbs)		#aint_bbs$FISHING_METHOD <- as.factor(aint_bbs$FISHING_METHOD)
	summary(aint_bbs$FISHING_METHOD)

  #  ------------------------------------------------------------------------------------------------
  #  ------------------------  SAVE THIS AS THE "ALL GEARS" DATASET  --------------------------------
  #  -------  use the all_gears dataset for figures in the data report

	aint_bbs_all_gears <- aint_bbs			# str(aint_bbs_all_gears)
	rm(aint_bbs)

  #  ------------------------------------------------------------------------------------------------
  #  ------------------------  CONTINUE PROCESSING JUST BFISH GEARS  --------------------------------


	string <- "SELECT *
			FROM aint_bbs_all_gears
			WHERE FISHING_METHOD in ('BOTTOMFISHING','BTM/TRL MIX')"
	
	aint_bbs <- sqldf(string, stringsAsFactors=FALSE)	
		length(unique(aint_bbs$INTERVIEW_PK))		# 3066 interviews
		length(unique(aint_bbs$CATCH_PK))			# 21929 catch records
	
  # WATCH OUT- there were 779 interviews, 3105 catch records, that included NUM_KEPT = 0 but catch weight was recorded
	# skimming through, it is obvious that the number of fish that must have been included in these weights was greater than 1.
	# SO- ALWAYS USE CAUTION when talking about numbers: NUM_KEPT IS NOT a dependable record of number of fish caught.
	#		hence, there is no record of number of fish caught.
	#  for weight-based CPUE, these interviews can be used.
	# For anything numbers or weight per fish based, exclude these interviews.

  # save this as filtered
	aint_bbs_filtered <- aint_bbs

  #  -------------------------   finished dealing with weird records

#  -------------------------  
#  -------------------------  
#   ----------- add variables for CPUE standardization

  #  convert AREA_FK (which includes specific villages) to John's slightly larger PRIMARY_AREA_FK, see map
	# note: PRIMARY_AREA_FK = 30 is basically the trash can / unknown area (surprisingly common).
	key <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/A_area.csv",header=T)
	nrow(key)	#125

  	string <- "SELECT aint_bbs_filtered.*, key.PRIMARY_AREA_FK			
		FROM aint_bbs_filtered LEFT JOIN key
				ON aint_bbs_filtered.AREA_FK = key.AREA_PK"
	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)
	nrow(bbs_2)	#49209	 	#nrow(aint_bbs_filtered)

    bbs_2$PRIMARY_AREA_FK <- as.factor(bbs_2$PRIMARY_AREA_FK)
    bbs_2$VESSEL_REGIST_NO <- as.factor(bbs_2$VESSEL_REGIST_NO)
    bbs_2$FISHING_METHOD <- as.factor(bbs_2$FISHING_METHOD)
    bbs_2$INTERVIEWER1_FK <- as.factor(bbs_2$INTERVIEWER1_FK)

#	add a more course Area designations since the resolution used in 2019 aggregate assessment 
#	will probably be too fine (i.e., many year x areas will have zero data).
#	also, try some other designations including attaching the 2 wind areas.

	B_area <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/BB_Creel_Data_5Oct2021/METADATA_areas_Feb10.csv",header=T,stringsAsFactors=FALSE)
	B_area_BBS <- subset(B_area, DATASET == "BBS")
	B_area_BBS$AREA_RAW <- as.integer(B_area_BBS$AREA_RAW)	# View(B_area_BBS)	#head(B_area_BBS)


string <- "SELECT bbs_2.*, B_area_BBS.AREA as AREA_B, B_area_BBS.AREA_2BANKS as AREA_2banks, B_area_BBS.AREA_WIND as AREA_WIND
		FROM bbs_2
		LEFT JOIN B_area_BBS
			ON bbs_2.AREA_FK = B_area_BBS.AREA_RAW"
	bbs_3 <- sqldf(string, stringsAsFactors=FALSE)
	bbs_3$AREA_B <- as.factor(bbs_3$AREA_B)
	bbs_3$AREA_2banks <- as.factor(bbs_3$AREA_2banks)	# summary(bbs_3$AREA_2banks)
	nrow(bbs_3)	#45659	 	#nrow(aint_bbs_filtered)	#str(bbs_3)
	summary(bbs_3$AREA_B)
	summary(bbs_3$AREA_2banks)

	summary(bbs_3$FISHING_METHOD)

	# make a new area 
	bbs_3B <- mutate(bbs_3, AREA_B2 = as.character(AREA_2banks))
	bbs_3B$AREA_B2[bbs_3B$AREA_B2 == "Tut_North"] <- "Tutuila"
	bbs_3B$AREA_B2[bbs_3B$AREA_B2 == "Tut_South"] <- "Tutuila"
	bbs_3B$AREA_B2 <- as.factor(bbs_3B$AREA_B2)
	summary(bbs_3B$AREA_B2)		# nrow(bbs_3B)
	length(unique(bbs_3B$INTERVIEW_PK))		# 2942 interviews


# make a new copy
bbs_3C <- bbs_3B

# add a month variable

bbs_3C <- mutate(bbs_3C, month = as.numeric(substr(INTERVIEW_TIME, 6, 7)))
str(bbs_3C)
bbs_3C$month <- as.factor(bbs_3C$month)
summary(bbs_3C$month)

# add a season variable  12-1-2 = summer, 3-4-5 = fall, 6-7-8 = winter, 9-10-11 = spring
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
summary(bbs_3C$season)



# add time of day variable
# "morning shift" is 0500-1330, evening shift is 1400-2230
#  or try 6-hour blocks

bbs_3C <- mutate(bbs_3C, hour = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
str(bbs_3C)

bbs_3C <- mutate(bbs_3C, shift = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
str(bbs_3C)

bbs_3C$shift[bbs_3C$shift >= 5 & bbs_3C$shift < 14] <- 'am' 
bbs_3C$shift[bbs_3C$shift >= 14 & bbs_3C$shift < 23] <- 'pm' 
bbs_3C$shift[bbs_3C$shift == '23'] <- 'other' 
bbs_3C$shift[bbs_3C$shift < 5] <- 'other' 

bbs_3C$shift <- as.factor(bbs_3C$shift)
summary(bbs_3C$shift)

# bbs_3C_backup
#	bbs_3C <- bbs_3C_backup

bbs_3C <- mutate(bbs_3C, tod_quarter = as.numeric(substr(INTERVIEW_TIME, 12, 13)))
str(bbs_3C)

bbs_3C$tod_quarter[bbs_3C$hour >= 0 & bbs_3C$hour < 6] <- '0000-0600' 
bbs_3C$tod_quarter[bbs_3C$hour  >= 6 & bbs_3C$hour  < 12] <- '0600-1200' 
bbs_3C$tod_quarter[bbs_3C$hour  >= 12 & bbs_3C$hour  < 18] <- '1200-1800' 
bbs_3C$tod_quarter[bbs_3C$hour  >= 18 & bbs_3C$hour  < 24] <- '1800-2400' 

bbs_3C$tod_quarter<- as.factor(bbs_3C$tod_quarter)
summary(bbs_3C$tod_quarter)

bbs_3C$TYPE_OF_DAY <- as.factor(bbs_3C$TYPE_OF_DAY)


# reclassify the non-main ports= ASILI, GENERAL TUTUILA PORT, LEONE, VATIA

  bbs_3C$PORT_NAME <- as.factor(bbs_3C$PORT_NAME)
  summary(bbs_3C$PORT_NAME)

  bbs_3C <- mutate(bbs_3C, port_simple = as.character(PORT_NAME))
  bbs_3C$port_simple[bbs_3C$PORT_NAME == 'ASILI'] <- 'Tutuila_Other'
  bbs_3C$port_simple[bbs_3C$PORT_NAME == 'GENERAL TUTUILA PORT'] <- 'Tutuila_Other'
  bbs_3C$port_simple[bbs_3C$PORT_NAME == 'LEONE'] <- 'Tutuila_Other'
  bbs_3C$port_simple[bbs_3C$PORT_NAME == 'VATIA'] <- 'Tutuila_Other'
  bbs_3C$port_simple <- as.factor(bbs_3C$port_simple)
  summary(bbs_3C$port_simple)


#  add some posix CT variables and moon phase, use library lunar
#	American Samoa is UTC - 11
	library(lunar)

head(bbs_3C)
str(bbs_3C)

bbs_3C <- mutate(bbs_3C, INTERVIEW_TIME_LOCAL = as.POSIXct(INTERVIEW_TIME, tz='UTC'))
bbs_3C <- mutate(bbs_3C, INTERVIEW_TIME_UTC = INTERVIEW_TIME_LOCAL + 11*60*60)
bbs_3C <- mutate(bbs_3C, Moon_radians = lunar.phase(as.Date(SAMPLE_DATE), shift = 11))

#  2pi radians = 29.53 days, so...
bbs_3C <- mutate(bbs_3C, Moon_days = round(Moon_radians* (29.53/(2*pi)) ,digits=0) )


#	ENVIRONMENTAL DATA   #######################
#  -----------------------------------  attach environmental data
#	do this working with interview only
# note to Erin: Pago Pago is 14.28 deg S, 170.7 deg W (-14.28, -170.7).

string <- "SELECT DISTINCT INTERVIEW_PK, year_num, INTERVIEW_TIME_LOCAL, INTERVIEW_TIME_UTC, AREA_WIND
		FROM bbs_3C"
	list_ints <- sqldf(string, stringsAsFactors=FALSE)		# View(list_ints)
	str(list_ints)

# load 6 hour wind_data. Created in Get_ERDDAP_29Oct.R script.
load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\Updated_Wind_29Oct.RData")

# Do "nearest neighbor" merge on INTERVIEW_TIME_UTC:   I don't know of a simpler way to do this.
#	note: they didn't routinely record the interview time in the Manua's until 2003
#		so, interview time is assumed to occur at midnight local time, 11 am UTC.
#	

ints_manu <- subset(list_ints, AREA_WIND == 'manu')		
ints_manu <- ints_manu[order(ints_manu$INTERVIEW_TIME_UTC),] 		# str(ints_manu)
wind_manu <- subset(wind_6h, location == 'manu')
wind_manu <- wind_manu[order(wind_manu$dt),]			#View(wind_manu[1:100,])

#  toss 1986 and 1987 now since there is no wind data
#	ints_manu <- subset(ints_manu, year_num > 1987)
# findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
index_mat <- findInterval(ints_manu$INTERVIEW_TIME_UTC,wind_manu$dt)
str(index_mat)

ints_manu <- mutate(ints_manu, 'wind_index' = index_mat)
View(ints_manu)

# make columns for the previous and next windtimes
ints_manu <- mutate(ints_manu, 'previous_windtime' = as.POSIXct("1982-07-25 07:00:00", tz = 'UTC'))
ints_manu <- mutate(ints_manu, 'next_windtime' = as.POSIXct("1982-07-25 07:00:00", tz = 'UTC'))

# fetch the previous (index_mat above) and next windtimes (index_mat + 1).
for (i in 1:nrow(ints_manu)) {
		lookup_i <- ints_manu$wind_index[i]
		ints_manu$previous_windtime[i] <- wind_manu[lookup_i,1]
		ints_manu$next_windtime[i] <- wind_manu[(lookup_i+1),1]	
		}

# calculate hours since last, hours till next windtime. 
int_manu_2 <- mutate(ints_manu, 'm_since_previous' = (as.numeric(INTERVIEW_TIME_UTC - previous_windtime)/60),
				'm_to_next' = (as.numeric(next_windtime - INTERVIEW_TIME_UTC)))
View(int_manu_2)


# add empty column to note the index to use
int_manu_3 <- mutate(int_manu_2, 'use_windtime_index' = -999)
#  View(int_manu_3)

for (i in 1:nrow(int_manu_3)) {
		ifelse(int_manu_3$m_since_previous[i] < int_manu_3$m_to_next[i],
			int_manu_3$use_windtime_index[i] <- int_manu_3$wind_index[i],
			int_manu_3$use_windtime_index[i] <- int_manu_3$wind_index[i]+1)
	}


# now we have the index of winds to use, pull in the data.
int_winds_manu <- mutate(int_manu_3, wspd = 999, wdir = 999, uwind = 999, vwind = 999)
View(int_winds_manu)
 
for (i in 1:nrow(int_winds_manu)) {
		wind_i <- int_winds_manu$use_windtime_index[i]
		int_winds_manu$wspd[i] <- wind_manu$wspd[wind_i]
		int_winds_manu$wdir[i] <- wind_manu$wdir[wind_i]
		int_winds_manu$uwind[i] <- wind_manu$uwind[wind_i]
		int_winds_manu$vwind[i] <- wind_manu$vwind[wind_i]
		}

# repeat for tutuila

ints_tutu <- subset(list_ints, AREA_WIND == 'tutu')		
ints_tutu <- ints_tutu[order(ints_tutu$INTERVIEW_TIME_UTC),] 
wind_tutu <- subset(wind_6h, location == 'tutu')
wind_tutu <- wind_tutu[order(wind_tutu$dt),]			#View(wind_tutu[1:100,])

#  toss 1986 and 1987 now since there is no wind data
	ints_tutu <- subset(ints_tutu, year_num > 1987)
# findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
rm(index_mat)
index_mat <- findInterval(ints_tutu$INTERVIEW_TIME_UTC,wind_tutu$dt)
str(index_mat)

ints_tutu <- mutate(ints_tutu, 'wind_index' = index_mat)
View(ints_tutu)

# make columns for the previous and next windtimes
ints_tutu <- mutate(ints_tutu, 'previous_windtime' = as.POSIXct("1982-07-25 07:00:00", tz = 'UTC'))
ints_tutu <- mutate(ints_tutu, 'next_windtime' = as.POSIXct("1982-07-25 07:00:00", tz = 'UTC'))

# fetch the previous (index_mat above) and next windtimes (index_mat + 1).
for (i in 1:nrow(ints_tutu)) {
		lookup_i <- ints_tutu$wind_index[i]
		ints_tutu$previous_windtime[i] <- wind_tutu[lookup_i,1]
		ints_tutu$next_windtime[i] <- wind_tutu[(lookup_i+1),1]	
		}

# calculate hours since last, hours till next windtime. 
int_tutu_2 <- mutate(ints_tutu, 'm_since_previous' = (as.numeric(INTERVIEW_TIME_UTC - previous_windtime)/60),
				'm_to_next' = (as.numeric(next_windtime - INTERVIEW_TIME_UTC)))
View(int_tutu_2)


# add empty column to note the index to use
int_tutu_3 <- mutate(int_tutu_2, 'use_windtime_index' = -999)
#  View(int_tutu_3)

for (i in 1:nrow(int_tutu_3)) {
		ifelse(int_tutu_3$m_since_previous[i] < int_tutu_3$m_to_next[i],
			int_tutu_3$use_windtime_index[i] <- int_tutu_3$wind_index[i],
			int_tutu_3$use_windtime_index[i] <- int_tutu_3$wind_index[i]+1)
	}


# now we have the index of winds to use, pull in the data.
int_winds_tutu <- mutate(int_tutu_3, wspd = 999, wdir = 999, uwind = 999, vwind = 999)
# View(int_winds_tutu)
 
for (i in 1:nrow(int_winds_tutu)) {
		wind_i <- int_winds_tutu$use_windtime_index[i]
		int_winds_tutu$wspd[i] <- wind_tutu$wspd[wind_i]
		int_winds_tutu$wdir[i] <- wind_tutu$wdir[wind_i]
		int_winds_tutu$uwind[i] <- wind_tutu$uwind[wind_i]
		int_winds_tutu$vwind[i] <- wind_tutu$vwind[wind_i]
		}

# remerge back into bbs_3C

head(int_winds_tutu)
head(int_winds_manu)
head(int_winds)
int_winds <- rbind(int_winds_tutu, int_winds_manu)

names(bbs_3C)		#nrow(bbs_3C_2)

string <- "SELECT bbs_3C.*, int_winds.wspd, int_winds.wdir, int_winds.uwind, int_winds.vwind
		FROM bbs_3C
		LEFT JOIN int_winds 
			ON bbs_3C.INTERVIEW_PK = int_winds.INTERVIEW_PK
		"

bbs_3C_2 <- sqldf(string, stringsAsFactors=FALSE)

names(bbs_3C_2)

bbs_3C <- bbs_3C_2


#  Load largescale indices
#   head(bbs_3C)		names(bbs_3C)		names(ENSO)

ENSO <- read.csv("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\ENSO.csv",header=TRUE, stringsAsFactors=FALSE)
ONI <- read.csv("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\ONI.csv",header=TRUE, stringsAsFactors=FALSE)
SOI <- read.csv("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\SOI.csv",header=TRUE, stringsAsFactors=FALSE)

string <- "SELECT bbs_3C.*, ENSO.ENSO
		FROM bbs_3C 
		LEFT JOIN ENSO 
			ON bbs_3C.year_num = ENSO.Year
				AND bbs_3C.month = ENSO.month_num
		"

bbs_ENSO <- sqldf(string, stringsAsFactors=FALSE)
str(bbs_ENSO)


string <- "SELECT bbs_ENSO.*, SOI.SOI
		FROM bbs_ENSO 
		LEFT JOIN SOI 
			ON bbs_ENSO.year_num = SOI.Year
				AND bbs_ENSO.month = SOI.month_num
		"

bbs_ENSO_SOI <- sqldf(string, stringsAsFactors=FALSE)
str(bbs_ENSO_SOI)


string <- "SELECT bbs_ENSO_SOI.*, ONI.ONI
		FROM bbs_ENSO_SOI
		LEFT JOIN ONI 
			ON bbs_ENSO_SOI.year_num = ONI.Year
				AND bbs_ENSO_SOI.month = ONI.month_num
		"

bbs_ENSO_SOI_ONI <- sqldf(string, stringsAsFactors=FALSE)
str(bbs_ENSO_SOI_ONI)
names(bbs_ENSO_SOI_ONI)

rm(bbs_3C)				#str(bbs_3C)
bbs_3C <- bbs_ENSO_SOI_ONI

#  clean up a little
# rm(list=ls()[8:10])

length(unique(bbs_3C$INTERVIEW_PK))		# 3066 interviews (1986-2021 are still in here)

names(bbs_3C)


# add effort as num_gear x hours_fished
	bbs_3C <- mutate(bbs_3C, effort = HOURS_FISHED*NUM_GEAR)

ls()


# save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")














