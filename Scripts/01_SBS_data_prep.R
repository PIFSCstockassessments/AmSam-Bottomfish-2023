#  -----------------------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA Shore-based Creel Survey 
#	Data provided by Paul Tao Sep10 2021, see Jira data request PICDR-113003	
#
#   The only reason to look at the raw shore-based creel survey is to calculate species ID correction factors
#	and species_proptable to use on the expanded shore-based landings.
#   The process will be similar to boat-based, but greatly simplified because we will do the break-down over
#	the entire timeseries for each species (no year x area x gear strata).
#
#   ----------------------------------------------------------------------------------------------------------------------------
#   
#   Erin Bohaboy erin.bohaboy@noaa.gov
#	
#  --------------------------------------------------------------------------------------------------------------

  #  PRELIMINARIES
  rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf

  # load all the libraries.
  library(sqldf)
  library(dplyr)
  library(this.path)
  options(scipen=999)
 # library(ggplot2)
 # library(magrittr)
 # library(gridExtra)
 # library(grid)
 # library(cowplot)
 # library(lattice)
 # library(ggplotify)

  # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)


  # ----------- STEP 1: read in the complete "flatview" datafile for AmSam Shore based survey, 
  #				do some data manipulation

  	sbs <- read.csv(paste(root_dir, "/data/AmSam_SBS_Sep10.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  	# str(sbs)			#34477 records


  # rename the important fields using all caps to match the boat-based survey. This will hopefully streamline code later.
  #	careful here, if columns are added or deleted, index will be off.

	names(sbs)[1:4] <- c("INTERVIEW_PK", "Route_Fk", "SAMPLE_DATE", "INTERVIEW_TIME") 
	names(sbs)[5:8] <- c("TYPE_OF_DAY", "Grams_F", "Non_Sched_F", "INTERVIEWER1_FK")
	names(sbs)[9:12] <- c("INTERVIEWER2_FK", "Interviewer3_Fk", "HOURS_FISHED", "AREA_FK") 
	names(sbs)[13:32] <- c("Home_F","METHOD_FK","NUM_GEAR","NUM_FISHER",
				"TOT_EST_LBS", "Percent_Sold", "Int_Load_Datetime", "Int_Load_User", 
				"CATCH_PK", "INTERVIEW_FK", "SPECIES_FK", "Disposition_Fk",
				"Len_Cm", "Act_Wt", "Num_Pieces", "Est_Whole_Lbs_Type",
				"EST_LBS", "FISHING_METHOD", "FISHING_AREA", "Route_Name") 
	names(sbs)[33:36] <- c("SCIENTIFIC_NAME", "COMMON_NAME", "Local_Name", "Disposition")

		# check data length
		length(unique(sbs$INTERVIEW_PK))		# 5399 interviews
		length(unique(sbs$CATCH_PK))			# 34338 catch records


  # Put all fields into correct format
	sbs <- mutate(sbs, SAMPLE_YEAR = substr(SAMPLE_DATE,1,4))
	sbs$year <- as.factor(sbs$SAMPLE_YEAR)					#summary(sbs$year)
	sbs <- mutate(sbs, year_num = as.numeric(SAMPLE_YEAR))	
	sbs$METHOD_FK <- as.numeric(sbs$METHOD_FK)
	sbs$SPECIES_FK <- as.numeric(sbs$SPECIES_FK)
	sbs$EST_LBS <- as.numeric(sbs$EST_LBS)
	sbs$TOT_EST_LBS <- as.numeric(sbs$TOT_EST_LBS)
	sbs$Len_Cm <- as.numeric(sbs$Len_Cm)			#summary(sbs$Len_Cm)
	sbs$Num_Pieces <- as.numeric(sbs$Num_Pieces)		#summary(sbs$Num_Pieces)
	sbs$FISHING_METHOD <- as.factor(sbs$FISHING_METHOD)	#summary(sbs$Fishing_Method)
	sbs$FISHING_AREA <- as.factor(sbs$FISHING_AREA)
	sbs$TYPE_OF_DAY <- as.factor(sbs$TYPE_OF_DAY)

  # fix P. rutilans
  	sbs$SPECIES_FK[sbs$SPECIES_FK==243]<-241
	sbs$SCIENTIFIC_NAME[sbs$SCIENTIFIC_NAME=='Pristipomoides rutilans']<-'Pristipomoides flavipinnis'

  # keep only 1990 to 2020 (to match SB expanded landings from Hongguang). 
	sbs <- subset(sbs, year_num < 2021)
	sbs <- subset(sbs, year_num > 1989)
		length(unique(sbs$INTERVIEW_PK))		# 5009 interviews: only lost 27
		length(unique(sbs$CATCH_PK))			# 33338 catch records
		nrow(sbs)						# 33476 rows (if measured, multiple fish per catch record)

  # find and deal with weird records 
  # note: when using delete querries in sqldf, it will make a Warning message, IGNORE

  # 49 records where COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0.

	STRING <- "SELECT * FROM sbs WHERE COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0"
	try <- sqldf(STRING, stringsAsFactors=FALSE)
	# View(try)
	length(unique(try$INTERVIEW_PK))	# 34
	length(unique(try$CATCH_PK))		# 49

	string <- c("DELETE FROM sbs WHERE COMMON_NAME = 'No Catch' and TOT_EST_LBS > 0",
			"SELECT * FROM sbs")
	sbs2 <- sqldf(string, stringsAsFactors=FALSE)

	nrow(sbs2)					# 33476-49 =  33427
	length(unique(sbs2$INTERVIEW_PK))	# 5009
	length(unique(sbs2$CATCH_PK))		# 33289


  # Simplify gears and routes

  a_routes <- read.csv(paste(root_dir, "/data/sb_route_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # View(a_routes)	#str(a_routes)

  a_method <- read.csv(paste(root_dir, "/data/sb_gear_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # str(a_method)

  string <- "SELECT sbs2.*, a_method.FISHING_METHOD, a_method.gear_simple
		FROM sbs2
		LEFT JOIN a_method
			ON sbs2.METHOD_FK = a_method.method_fk"
  sbs3 <- sqldf(string, stringsAsFactors=FALSE)
  str(sbs3)				# 33427  obs

  # rename duplicate FISHING_METHOD column
  names(sbs3)[40] <- 'FISHING_METHOD_FK'

  string <- "SELECT sbs3.*, a_routes.route_simple, a_routes.area_super_simple
		FROM sbs3
		LEFT JOIN a_routes
			ON sbs3.Route_Fk = a_routes.route"
  sbs4 <- sqldf(string, stringsAsFactors=FALSE)
  str(sbs4)				# 33427 obs

  sbs_basic <- sbs4

  # make an sbs species names list, we can use this later
  string <- "SELECT DISTINCT SPECIES_FK, SCIENTIFIC_NAME, COMMON_NAME, LOCAL_NAME
		  FROM sbs4
		  ORDER BY SPECIES_FK
		  "
	sbs_sp_names_all <-  sqldf(string, stringsAsFactors=FALSE)		#View(sbs_sp_names_all)
	

  # --- simplify this now.
  #  going forward, the only information we want is year, interview, species, sum_catch. For boat-based,
  #	we use interview data for CPUE, so it is much more complex.
  #  note, the same CATCH_PK will repeat multiple times (with associated EST_LBS) if fish were measured
  # 	AND a single interview might have multiple CATCH_PK for a species
  #	probably because multiple gear types were used in an interview that caught the species in question

  # Prepare a check: total lbs surveyed in sbs4
		string <- "SELECT DISTINCT CATCH_PK, EST_LBS
		  FROM sbs4
		  "
		tot_catch_check_0 <- sqldf(string, stringsAsFactors=FALSE)

  # SUM TOTAL CATCH: this is the magic number and should not change going forward
  sum(tot_catch_check_0$EST_LBS, na.rm=TRUE)					#  90261.49

  # This is a weird way to use GROUP BY, exercise caution
    string <- "SELECT year_num, INTERVIEW_PK, CATCH_PK, SPECIES_FK, sum(EST_LBS) as SUM_EST_LBS
	   	   FROM
	   		(SELECT DISTINCT year_num, INTERVIEW_PK, CATCH_PK, SPECIES_FK, EST_LBS
	   		FROM sbs4)
	   	   GROUP BY year_num, INTERVIEW_PK, SPECIES_FK
          	  "
	sbs5 <- sqldf(string, stringsAsFactors=FALSE)			# sum(sbs5$SUM_EST_LBS, na.rm=TRUE)		#str(sbs5)

	names(sbs5)[5] <- 'EST_LBS'						# sum(sbs5$EST_LBS, na.rm=TRUE)	

  # ----------- STEP 2: account for species identification issues (similar to BBS, but greatly simplified)


  # ----- 2a. Variola louti and Variola albimarginata have been confused between 1986-2015. 
  #		Assume 2016-2020 SBS species identifications are reliable

		# prepare a check: all variola, 1990-2020
		string <- "SELECT *
		  FROM sbs5
		  WHERE SPECIES_FK in ('229','220')
		  "
		variola_check <- sqldf(string, stringsAsFactors=FALSE)	# View(variola_check)
		sum_variola <- sum(variola_check$EST_LBS)				# 602.392 lbs

	# calculate sum(V. louti)/sum(V. louti, V. albimarginata) for 2016-2020, all areas, all gears
  	string <- "SELECT SPECIES_FK, SUM(EST_LBS) as TOT_LBS
		  FROM sbs5
		  WHERE SPECIES_FK in ('229','220') AND year_num < 2021 AND year_num > 2015
		  GROUP BY SPECIES_FK"
	variola_1 <- sqldf(string, stringsAsFactors=FALSE)		#yikes, small numbers (tot = 12.412)
	p_louti <- variola_1$TOT_LBS[2]/(sum(variola_1$TOT_LBS))
	p_albimarginata <- 1-p_louti			# will save p_louti and p_albimarginata to adjust expanded landings estimates.

	# list all interview_pk, catch_pk that included either species, 1990-2015
	string <- "SELECT *
		  	FROM sbs5
			WHERE SPECIES_FK in ('229','220') AND year_num < 2016
		  	"
	variola_2 <- sqldf(string, stringsAsFactors=FALSE)	#str(variola_2)		
	#View(variola_2)  #sum(variola_2$EST_LBS)
	#  589.98 lbs total   (602.392-12.412)
	
	# divide interviews into those which caught just 1 of the variola species, and those which caught both

	# add N_CATCH_PK column
		string <- "SELECT INTERVIEW_PK, count(CATCH_PK) as N_CATCH_PK
			FROM variola_2
			GROUP BY INTERVIEW_PK
			ORDER BY N_CATCH_PK
			"
		both_sp_question <- sqldf(string, stringsAsFactors=FALSE)			
			#View(both_sp_question)  # only 1 interview caught both	

		string <- "SELECT variola_2.*, both_sp_question.N_CATCH_PK
					FROM variola_2 LEFT JOIN both_sp_question
						ON variola_2.INTERVIEW_PK = both_sp_question.INTERVIEW_PK"
		variola_2B <- sqldf(string, stringsAsFactors=FALSE)		# sum(variola_2B$EST_LBS)	#View(variola_2B)

		just_1_sp <- subset(variola_2B, N_CATCH_PK == 1)			# View(just_1_sp)
		rownames(just_1_sp) <- NULL
		both_sp <- subset(variola_2B, N_CATCH_PK == 2)				# View(both_sp)		#sum(both_sp$EST_LBS)
		rownames(both_sp) <- NULL

		#  ----- CAREFUL!!!
		#   If we do an SQL query on 2 variables but GROUP BY only 1 variable, than only the first instance of the other variable
		#	will be retained. This can result in lost / potentially misleading data if there are multiple values for the second variable
		#   In this unusual case, we want to lose those CATCH_PK.
		#   Always make sure this is happening the way we expect.
		string <- "SELECT *, sum(EST_LBS) as sum_variola
			FROM both_sp
			GROUP BY INTERVIEW_PK
			"
		both_sp2 <- sqldf(string, stringsAsFactors=FALSE)	#View(both_sp2)		#sum(both_sp2$sum_variola)	
		names(both_sp2)[7] <- 'EST_LBS'				#sum(both_sp2$EST_LBS)	
		both_sp2 <- both_sp2[,c(1,2,3,4,7,6)]

		# List the CATCH_PK (eliminated in previous step) that we will drop later:
		drop_catch_pk <- subset(both_sp, !(CATCH_PK %in% both_sp2$CATCH_PK))

	variola_2C <- rbind(just_1_sp, both_sp2)						# sum(variola_2C$EST_LBS)	

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

	# update sbs5 with these new records
	
	sbs_keep1 <- subset(sbs5, !(CATCH_PK %in% variola_4$CATCH_PK))	
		#str(sbs_keep1)	#12213

	# don't forget, we had to drop a CATCH_PK for interviews where both V. louti and V. albimarginata were recorded
	#	because we summed that catch under just 1 CATCH_PK per interview. eliminate those catch_pk that we dropped now
	#	to avoid double counting catch
	
	sbs_keep2 <- subset(sbs_keep1, !(CATCH_PK %in% drop_catch_pk$CATCH_PK))
		
	sbs_update1 <- subset(sbs5, (CATCH_PK %in% variola_4$CATCH_PK))
	# View(head(sbs_update1))	

	# keep only the first instance of each CATCH_PK (because some catch_pk had lengths)
	sbs_update2 <- sbs_update1[with(sbs_update1, order(CATCH_PK)), ]
		
	# merge on the updated CATCH_PKs
	string <- "SELECT sbs_update2.*, variola_4.NEW_CATCH_PK, variola_4.SPECIES_FK as NEW_SPECIES_FK,
				variola_4.SCIENTIFIC_NAME as NEW_SCIENTIFIC_NAME, variola_4.EST_LBS as NEW_EST_LBS
					FROM sbs_update2 LEFT JOIN variola_4
						ON sbs_update2.CATCH_PK = variola_4.CATCH_PK"
		sbs_update4 <- sqldf(string, stringsAsFactors=FALSE)		
			#View(sbs_update4)		#sum(sbs_update4$NEW_EST_LBS)			#589.98

	# use NEW_ columns in place of the original (retain same column order as bbs_3C)		#names(bbs_3C_update4)
	sbs_update4$CATCH_PK <- sbs_update4$NEW_CATCH_PK
	sbs_update4$SPECIES_FK  <- sbs_update4$NEW_SPECIES_FK
	sbs_update4$EST_LBS  <- sbs_update4$NEW_EST_LBS

	# drop columns 6 and 7
	sbs_update5 <- sbs_update4[,1:5]   #sum(sbs_update5$EST_LBS)	#589.98

	# put back together with the keep records
	sbs_new <- rbind(sbs_keep2, sbs_update5)		#sum(sbs_new$EST_LBS, na.rm=TRUE)		#90261.49
		length(unique(sbs5$INTERVIEW_PK))
		length(unique(sbs_new$INTERVIEW_PK))

	# update sbs5			
	sbs5 <- sbs_new					#str(sbs5)

  #  remainder of step 2: we are doing break-down summed over years, so heavy use of "Lethrinidae" over long periods
  #	in Manu'as won't affect break-down. Also, fila / flavi mis-ID will not be pertinent (only 1 record of flavi in shore-based anyway)

  # ----------- STEP 3: create the shore-based species proptable. Because even the shallow species
  #				are relatively rare, sum by gear, area, year to get the props
  #				

  #  group key has been updated to include some shore-based species (includes inverts). Will not affect boat-based.
  group_key <- read.csv(paste(root_dir, "/data/AmSam_BBS-SBS_GroupKey.csv", sep=""), header=T, stringsAsFactors=FALSE) 
  # View(group_key)

  # reduce sbs5 to the simple catch table
	string <- "SELECT SPECIES_FK, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, SPECIES_FK, EST_LBS
			FROM sbs5
			WHERE SPECIES_FK IS NOT '0' AND SPECIES_FK IS NOT 'NULL') 
		  GROUP BY SPECIES_FK"

	by_species <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species)		# View(by_species)			# 287 'species' recorded
	# drop the first row for SPECIES_FK = NA
	by_species[is.na(by_species)] <- 0
	by_species <- subset(by_species, SPECIES_FK != 0) 
	rownames(by_species) <- NULL						#
	by_species$SPECIES_FK <- as.numeric(by_species$SPECIES_FK)

  # merge this aggregated catch table to the BBS-SBS group key, this simply adds the group info, left join ensures 
  #			nrow(by_species) == nrow(catch_year_codes)

  string <- "SELECT by_species.*, group_key.*
		FROM by_species
		LEFT JOIN group_key
			ON by_species.SPECIES_FK = group_key.SPECIES_PK
		ORDER BY SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#287 rows
	# View(catch_year_codes)
	names(catch_year_codes)
	
  by_species_init <- by_species


  # -----  STEP 4: Break down the BMUS groups into species
  #	which groups are in the shore-based data?
  #		list_species_groups <- as.numeric(by_species$SPECIES_FK)
  #
  #		  string <- "SELECT * 
  #			FROM by_species
  #			WHERE SPECIES_FK in (110, 200, 210, 230, 240, 260, 100, 109, 380, 390)"
  #  		list_bmus_groups <- sqldf(string, stringsAsFactors=FALSE)
  #  so, no need to break down BOTTOMFISHES or PRIST/ET
  #
  #  SPECIES_FK  TOT_LBS
  #        100    2.380			# fish
  #        109   83.506			# Trevallys
  #        110 4100.609			# jacks
  #        210 1812.771			# groupers
  #        230   21.499			# deep water snappers
  #        260  183.513			# emperors
  #        380    2.621			# inshore groupers
  #        390   20.840			# inshore snappers


  #  ---- 4a. GROUPERS 210 AND INSHORE GROUPERS 380 

  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, TOT_LBS
			FROM catch_year_codes
			WHERE Groupers_210 = 1 and SPECIES_FK not in (210,380)
			ORDER BY SPECIES_FK"
	
	grps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	
 	id_group_tot <- sum(grps_step1$TOT_LBS)
	grps_breakdown <- mutate(grps_step1, group_tot = id_group_tot)
	grps_breakdown <- mutate(grps_breakdown, sp_prop = TOT_LBS/group_tot)
	grps_breakdown <- grps_breakdown[,c(1,2,5)]

  	grps_catch <- sum(subset(by_species_init,  SPECIES_FK == 210 | SPECIES_FK == 380)[2])

    # break-down the grps catch (grps_catch) into presumed species using the grps_breakdown road map 
	grps_step4 <- mutate(grps_breakdown, TOT_LBS = grps_catch * sp_prop)
	grps_step5 <- data.frame(SPECIES_FK = as.numeric(grps_step4$SPECIES_FK), TOT_LBS = grps_step4$TOT_LBS)

    # update by_species by replacing SPECIES_FK = 210 or 380 with the broken down species
      by_species_new <- subset(by_species_init, SPECIES_FK != 210 & SPECIES_FK != 380)
	by_species_new <- rbind(by_species_new, grps_step5)
    # test
 	sum(by_species_new$TOT_LBS)				# 90261.49
    # sum by SPECIES_FK
	string <- "SELECT SPECIES_FK, sum(TOT_LBS) as TOT_LBS
			FROM by_species_new
			GROUP BY SPECIES_FK"
	by_species_grps <- sqldf(string, stringsAsFactors=FALSE)			#sum(by_species_grps$TOT_LBS)

 #  ---- 4b. Inshore snappers (230, 390) 

  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, TOT_LBS
			FROM catch_year_codes
			WHERE Deep_snappers_230 = 1 and SPECIES_FK not in (230, 390)
			ORDER BY SPECIES_FK"
	
	snaps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	
 	id_group_tot <- sum(snaps_step1$TOT_LBS)
	snaps_breakdown <- mutate(snaps_step1, group_tot = id_group_tot)
	snaps_breakdown <- mutate(snaps_breakdown, sp_prop = TOT_LBS/group_tot)
	snaps_breakdown <- snaps_breakdown[,c(1,2,5)]

  	snaps_catch <- sum(subset(by_species_grps,  SPECIES_FK == 230 | SPECIES_FK == 390)[2])

    # break-down the snaps catch (snaps_catch) into presumed species using the snaps_breakdown road map 
	snaps_step4 <- mutate(snaps_breakdown, TOT_LBS = snaps_catch * sp_prop)
	snaps_step5 <- data.frame(SPECIES_FK = as.numeric(snaps_step4$SPECIES_FK), TOT_LBS = snaps_step4$TOT_LBS)

    # update by_species by replacing SPECIES_FK = 230 or 390 with the broken down species
      by_species_new <- subset(by_species_grps, SPECIES_FK != 230 & SPECIES_FK != 390)
	by_species_new <- rbind(by_species_new, snaps_step5)
    # test
 	sum(by_species_new$TOT_LBS)				# 
	
    # sum by SPECIES_FK
	string <- "SELECT SPECIES_FK, sum(TOT_LBS) as TOT_LBS
			FROM by_species_new
			GROUP BY SPECIES_FK"
	by_species_grps_snaps  <- sqldf(string, stringsAsFactors=FALSE)		#sum(by_species_grps_snaps$TOT_LBS)

 #  ---- 4c. jacks, trevallies

  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, TOT_LBS
			FROM catch_year_codes
			WHERE Jacks_110 = 1 and SPECIES_FK not in (109, 110)
			ORDER BY SPECIES_FK"
	
	jacks_step1 <- sqldf(string, stringsAsFactors=FALSE)
	
 	id_group_tot <- sum(jacks_step1$TOT_LBS)
	jacks_breakdown <- mutate(jacks_step1, group_tot = id_group_tot)
	jacks_breakdown <- mutate(jacks_breakdown, sp_prop = TOT_LBS/group_tot)
	jacks_breakdown <- jacks_breakdown[,c(1,2,5)]

  	jacks_catch <- sum(subset(by_species_grps_snaps,  SPECIES_FK == 109 | SPECIES_FK == 110)[2])

    # break-down the jacks catch into presumed species using the _breakdown road map 
	jacks_step4 <- mutate(jacks_breakdown, TOT_LBS = jacks_catch * sp_prop)
	jacks_step5 <- data.frame(SPECIES_FK = as.numeric(jacks_step4$SPECIES_FK), TOT_LBS = jacks_step4$TOT_LBS)

    # update by_species by replacing SPECIES_FK = 109 or 110 with the broken down species
      by_species_new <- subset(by_species_grps_snaps, SPECIES_FK != 109 & SPECIES_FK != 110)
	by_species_new <- rbind(by_species_new, jacks_step5)
    # test
 	sum(by_species_new$TOT_LBS)				#

    # sum by SPECIES_FK
	string <- "SELECT SPECIES_FK, sum(TOT_LBS) as TOT_LBS
			FROM by_species_new
			GROUP BY SPECIES_FK"
	by_species_grps_snaps_jacks  <- sqldf(string, stringsAsFactors=FALSE)	
			#sum(by_species_grps_snaps_jacks$TOT_LBS)

 #  ---- 4d. emperors

  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, TOT_LBS
			FROM catch_year_codes
			WHERE Emporers_260 = 1 and SPECIES_FK not in (260)
			ORDER BY SPECIES_FK"
	
	emps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	
 	id_group_tot <- sum(emps_step1$TOT_LBS)
	emps_breakdown <- mutate(emps_step1, group_tot = id_group_tot)
	emps_breakdown <- mutate(emps_breakdown, sp_prop = TOT_LBS/group_tot)
	emps_breakdown <- emps_breakdown[,c(1,2,5)]

  	emps_catch <- sum(subset(by_species_grps_snaps_jacks,  SPECIES_FK == 260)[2])

    # break-down the empscatch into presumed species using the _breakdown road map 
	emps_step4 <- mutate(emps_breakdown, TOT_LBS = emps_catch * sp_prop)
	emps_step5 <- data.frame(SPECIES_FK = as.numeric(emps_step4$SPECIES_FK), TOT_LBS = emps_step4$TOT_LBS)

    # update by_species by replacing SPECIES_FK = 260 with the broken down species
      by_species_new <- subset(by_species_grps_snaps_jacks, SPECIES_FK != 260)
	by_species_new <- rbind(by_species_new, emps_step5)
    # test
 	sum(by_species_new$TOT_LBS)				#

    # sum by SPECIES_FK
	string <- "SELECT SPECIES_FK, sum(TOT_LBS) as TOT_LBS
			FROM by_species_new
			GROUP BY SPECIES_FK"
	by_species_grps_snaps_jacks_emps  <- sqldf(string, stringsAsFactors=FALSE)	
		#sum(by_species_grps_snaps_jacks_emps$TOT_LBS)

 #  ---- 4e. fish

  	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, TOT_LBS
			FROM catch_year_codes
			WHERE Fish_100 = 1 and SPECIES_FK != 100
			ORDER BY SPECIES_FK"
	
	fish_step1 <- sqldf(string, stringsAsFactors=FALSE)
	
 	id_group_tot <- sum(fish_step1$TOT_LBS)
	fish_breakdown <- mutate(fish_step1, group_tot = id_group_tot)
	fish_breakdown <- mutate(fish_breakdown, sp_prop = TOT_LBS/group_tot)
	fish_breakdown <- fish_breakdown[,c(1,2,5)]

  	fish_catch <- sum(subset(by_species_grps_snaps_jacks_emps,  SPECIES_FK == 100)[2])		#2.38 lbs.

    # break-down the fish catch into presumed species using the _breakdown road map 
	fish_step4 <- mutate(fish_breakdown, TOT_LBS = fish_catch * sp_prop)
	fish_step5 <- data.frame(SPECIES_FK = as.numeric(fish_step4$SPECIES_FK), TOT_LBS = fish_step4$TOT_LBS)

    # update by_species by replacing SPECIES_FK = 100 with the broken down species
      by_species_new <- subset(by_species_grps_snaps_jacks_emps, SPECIES_FK != 100)
	by_species_new <- rbind(by_species_new, fish_step5)

    # test
 	sum(by_species_new$TOT_LBS)				#

    # sum by SPECIES_FK
	string <- "SELECT SPECIES_FK, sum(TOT_LBS) as TOT_LBS
			FROM by_species_new
			GROUP BY SPECIES_FK"
	by_species_grps_snaps_jacks_emps_fish  <- sqldf(string, stringsAsFactors=FALSE)	

	#sum(by_species_grps_snaps_jacks_emps_fish$TOT_LBS)		#View(by_species_grps_snaps_jacks_emps_fish)
	# str(by_species_grps_snaps_jacks_emps_fish)



  #  -------- STEP 5: turn this total break-down catch table into a proportions key that we can use for expanded landings
  #	  in 05_SBS_Landings.R	

	# join break-down catch (step 4) back in with the group_key, so we know which groups each species could belong to.
	string <- "SELECT by_species_grps_snaps_jacks_emps_fish.*, group_key.*
		FROM by_species_grps_snaps_jacks_emps_fish
		LEFT JOIN group_key
			ON by_species_grps_snaps_jacks_emps_fish.SPECIES_FK = group_key.SPECIES_PK"
	by_species_w_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_w_codes)		#			# View(by_species_w_codes)

	# build group sums by year, gear, area
	step2 <- mutate(by_species_w_codes, Trevally_109_catch = Trevally_109*TOT_LBS,
							Jacks_110_catch = Jacks_110*TOT_LBS,
 							Bottomfishes_200_catch = Bottomfishes_200*TOT_LBS,
							Groupers_210_catch = Groupers_210*TOT_LBS,
 							Deep_snappers_230_catch = Deep_snappers_230*TOT_LBS,
 							Prist_Etelis_240_catch = Prist_Etelis_240*TOT_LBS,
 							Emporers_260_catch = Emporers_260*TOT_LBS,
 							Inshore_groupers_380_catch = Inshore_groupers_380*TOT_LBS,
 							Inshore_snappers_390_catch = Inshore_snappers_390*TOT_LBS,
							Fish_100_catch = Fish_100*TOT_LBS)
	# str(step2)			#View(step2)			#


	# sum groups by year, gear, zone  (sum catch per strata for each unknown group)
  	string <- "SELECT sum(Trevally_109_catch) as sum_trevally_109,				
					sum(Jacks_110_catch) as sum_jacks_110,
					sum(Bottomfishes_200_catch) as sum_bfishes_200,
					sum(Groupers_210_catch) as sum_groupers_210,
					sum(Deep_snappers_230_catch) as sum_deep_snappers_230,
					sum(Prist_Etelis_240_catch) as sum_prist_et_240,
					sum(Emporers_260_catch) as sum_emporers_260,
					sum(Inshore_groupers_380_catch) as sum_inshore_groups_380,
					sum(Inshore_snappers_390_catch) as sum_inshore_snaps_390,
					sum(Fish_100_catch) as sum_fish_100
		FROM step2
		"

	year_sums <- sqldf(string, stringsAsFactors=FALSE)
	str(year_sums)
	# View(year_sums)			# names(step2)			#View(step2)

	# make into proportions

	step3 <- mutate(step2, prop_trevally_109 = Trevally_109_catch / year_sums$sum_trevally_109,
				prop_jacks_110 = Jacks_110_catch / year_sums$sum_jacks_110,
				prop_bfishes_200 = Bottomfishes_200_catch / year_sums$sum_bfishes_200,
				prop_groupers_210 = Groupers_210_catch / year_sums$sum_groupers_210,
				prop_deep_snappers_230 = Deep_snappers_230_catch / year_sums$sum_deep_snappers_230,
				prop_prist_et_240 = Prist_Etelis_240_catch / year_sums$sum_prist_et_240,
				prop_emporers_260 = Emporers_260_catch / year_sums$sum_emporers_260,
				prop_inshore_groups_380 = Inshore_groupers_380_catch / year_sums$sum_inshore_groups_380,
				prop_inshore_snaps_390 = Inshore_snappers_390_catch / year_sums$sum_inshore_snaps_390,
				prop_fish_100 = Fish_100_catch / year_sums$sum_fish_100)

	#View(step3)

	sbs_proptable <- step3


 # clean up workspace
	all_objs <- ls()
	save_objs <- c("sbs_proptable","root_dir","p_louti", "p_albimarginata", "sbs_basic")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)






 # save.image(paste(root_dir, "/output/01_SBS_data_prep.RData", sep=""))
  









































#  --------------------------------------------------------------------------------------------------------------
