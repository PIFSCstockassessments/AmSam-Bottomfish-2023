##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#	Erin Bohaboy erin.bohaboy@noaa.gov
#	American Samoa BMUS assessments 
# 	
#	MAKE SPECIES PROPTABLES
#
##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#
#	PRIMARY PURPOSE:
#	The creel surveys often identify catch only to the group levels, such as
#		name		species key
#		Trevally 		109
#		Jacks 		110
#		Bottomfishes 	200
#		Groupers 		210
#		Deep snappers 	230
#		Prist/Etelis 	240
#		Emporers 		260
#		Inshore groupers 	380
#		Inshore snappers 	390
#		unknown fishes 	100
#
#	We must break down each of the groups into individual species (previously done by BMU vs. not-BMU)
#		LUCKILY
#	  several of these groups are synonyms. For example, all Trevally species and also Jacks,
#		all Deep snappers are also inshore snapper
#		all groupers and also inshore groupers
#
#	Some groups are NESTED WITHIN other groups
#		For example, all Prist/Etelis are also Bottomfishes and all Bottomfishes are also unknown fishes
#
#		unknown fishes	<-	bottomfishes	<-	inshore snappers / deep snappers		<- 	prist / etelis
#									<-	emporers
#									<-	Trevally / Jacks
#									<-	groupers / inshore groupers
#									
#
#	so, first we break down prist/etelis (4th tier), then 3rd tier, etc.
#
#	In this script, we devise the proportions of each species in groups using aggregated catch. These can then be applied to each interview
#		to break-down any groups to species, or, they can be applied to expanded landings estimates from Hongguang
#
#
#  -----------------------------------------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
	library(this.path)

  #	library(ggplot2)
  #	library(magrittr)
  #	library(gridExtra)			
  #	library(grid)		
  #	library(cowplot)		
  #	library(lattice)		
  #	library(ggplotify)	

# establish directories using this.path
  root_dir <- this.path::here(.. = 1)

# Read in 02_BBS_covariates.RData
  #  note this will replace root_dir, that's OK because we intend everyone to be using the standard directory structure
  #		matching the git repo. if not, just redefine root_dir after load workspace
  load(paste(root_dir, "/NO_GITHUB_data_outputs/02_BBS_covariates.RData", sep=""))

#  ---------------
# Read in the BBS-SBS group key to tell us which species are in which groups
#	Brian and John made this table for the 2019 bottomfish assessment. It lists every species in BBS
#	and according to a set of rules tell us if the species could (1) or could not (0) be a member of
#	of each of the unknown species groups Trevally 109, Jacks 110, Bottomfishes 200, etc.
#	see page 29 of the 2019 assessment. In general, species were assigned by families, with a few exceptions.
#	For example, for Carangidae, scads (genera Decapterus, Selar, and Selaroides) were not considered possible BMUS, 
#		but other carangids were.
#  Erin updated this table to add a few rows for species that were missing (mostly non-BMUS groups that weren't used
#	in the 2019 assessment). Also added a column for fish 100 (weren't included in 2019 but are very rare in BBS data anyway).
#  15Feb2022: Update SPECIES_FK 243 to be consistent with P. flavipinnis (not A. rutilans). 243 shouldn't be in our BBS data
#	at this point because we replaced it with 241 in 01_BBS_data_prep, but having the corrected group key may be useful in the future.

  group_key <- read.csv(paste(root_dir, "/data/AmSam_BBS-SBS_GroupKey.csv", sep=""), header=T, stringsAsFactors=FALSE) 
  # View(group_key)



#  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#  ----------   Species proptable by GEAR x AREA x YEAR  -------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
# 

#  Hongguang's landings expansion is done based on the port where catch is interviewed
#	So, assume Tutuila includes the banks because 169 of 174 banks trips 1986-2020 land in Tutuila (see extra table).
#  When doing zone for the species proptable here, we want to group Bank_E, Bank_S, and Tutuila (area fished) to match the expansion.
#	23 of 25 area 'Unk' interviews were landed in Tutila.
#	1 area NA trip was landed in Tutila. Just put Unk and NA into Tutuila.

# create the 'zone' variable that matches with landings expansion (Tutu or Manu, based on port landed.)
	bbs_4C <- mutate(bbs_3C, zone = AREA_B)				# str(bbs_3C)	#49129 obs
	bbs_4C$zone[bbs_4C$zone == 'Bank'] <- 'Tutuila'
	bbs_4C$zone[bbs_4C$zone == 'Tut_North'] <- 'Tutuila'
	bbs_4C$zone[bbs_4C$zone == 'Tut_South'] <- 'Tutuila'
	bbs_4C$zone[bbs_4C$zone == 'Unk'] <- 'Tutuila'
	bbs_4C$zone[is.na(bbs_4C$zone)] <- 'Tutuila'
	bbs_4C$zone <- as.factor(bbs_4C$zone)
	summary(bbs_4C$zone)

# ---------------
# STEP 1:  Reduce bbs_3C back down to a simple "catch" table. i.e. sum by species, year, method, zone. 
#		Reminder: when multiple fish of a species are measured per interview, EST_LBS will repeat
#		so use CATCH_PK as the distinct field by
# Reminder: Here we sum EST_LBS and call it TOT_LBS
# this is not the same as the interview TOT_LBS from the flatview
# tail(bbs_3C)

#  also, as of Feb2022 use only 1986 to 2020 (not 2021)

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, EST_LBS
			FROM bbs_4C
			WHERE SPECIES_FK IS NOT '0' AND SPECIES_FK IS NOT 'NULL' AND year_num < 2021) 
		  GROUP BY year_num, SPECIES_FK, FISHING_METHOD, zone, SCIENTIFIC_NAME
			ORDER BY  year_num, SPECIES_FK"
	by_species <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species)		# 3,776 rows = species (including groups) x year x gear x zone strata		# View(by_species)

# ---------------
# STEP 2: merge this aggregated catch table to the BBS-SBS group key, this simply adds the group info, left join ensures 
#			nrow(by_species) == nrow(catch_year_codes)

  string <- "SELECT by_species.*, group_key.*
		FROM by_species
		LEFT JOIN group_key
			ON by_species.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3776 rows
	# View(catch_year_codes)
	names(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

# ---------------
# STEP 3:	
#	nothing happens here, was an artifact script development 


# ---------------
# STEP 4: Break up each group.
#	there's probably a more elegant way to do this
#	code heavily commented for only some groups
#	it is wise to check the number of records and make sure we are getting the number we expect

#  ---- 4a. PRISTOPOMOIDES / ETELIS (240)

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Prist_Etelis_240 = 1 and SPECIES_FK != 240
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	PE_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(PE_step1)		# PE_step1 is all year x identified species x gear x area catch that could be Prist. / Etelis.
					#	that is 479 rows = 479 strata

 	 string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM PE_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	PE_step2 <- sqldf(string, stringsAsFactors=FALSE)			#str(PE_step2)
	# str(PE_step2)		# PE_step2 is sum identified Prist/etelis, by year x area x gear = 108 strata

	# join year x identified species x gear x area (PE_step1) to year x gear x area (PE_step2) expect 439 rows
  	string <- "SELECT PE_step1.*, PE_step2.group_tot
		FROM PE_step1 LEFT JOIN PE_step2
			ON PE_step1.year_num = PE_step2.year_num
					AND
				PE_step1.FISHING_METHOD = PE_step2.FISHING_METHOD
					AND
				PE_step1.zone = PE_step2.zone
			"

	PE_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step3)		#str(PE_step3)		#479

	PE_breakdown <- mutate(PE_step3, sp_prop = TOT_LBS/group_tot)
	# View(PE_breakdown)	# add column for proportions

  	PE_catch <- subset(by_species, SPECIES_FK == 240)
	# View(PE_catch)	# str(PE_catch) # 20 records: catch by year x gear x area for the group we are breaking down.
							# take a look: the last time 'Pristipomoides Etelis spp.' was used was 2004

 # break-down all Prist/etelis catch records (PE_catch) into presumed species using the PE_breakdown road map 

 	string <- "SELECT PE_catch.*, PE_breakdown.SPECIES_FK, PE_breakdown.SCIENTIFIC_NAME_PK, PE_breakdown.FISHING_METHOD,
			PE_breakdown.zone,  PE_breakdown.sp_prop
		FROM PE_catch LEFT JOIN PE_breakdown
			ON PE_catch.year_num = PE_breakdown.year_num 
				AND
			PE_catch.FISHING_METHOD = PE_breakdown.FISHING_METHOD 
				AND
			PE_catch.zone = PE_breakdown.zone 
		ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	PE_step4 <- sqldf(string, stringsAsFactors=FALSE)		#View(PE_step4)		#names(PE_step4)
	names(PE_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(PE_step4)[9] <- "FISHING_METHOD_FK"
	names(PE_step4)[10] <- "zone_FK"

  # ---  WARNING: NOW WE MUST DEAL WITH EMPTY year x zone x gear strata
		# There were likely strata with unidentified prist/etelis (in PE_catch) that DID NOT also have identified catch
		#	in PE_break_down. These strata will appear in PE_step4 with 'NA' in columns 7:11.
		# We must borrow breakdown information.
		# The super way (similar to expansion algorithm) would be to borrow from adjacent strata
		#	HOWEVER, that would be very time-consuming and difficult to code, and extra difficult to explain here,
		#	and it probably makes little difference.
		# SO: borrow from all strata with information from PE_breakdown (the global average)

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM PE_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#i.e. there were 108 strata with identified prist / etelis
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			# na_strata <- sum(is.na(PE_step4$sp_prop))			#2 empty / missing strata
			# expect_rows <- nrow(PE_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 88

  		#  fill in the missing strata with the average sp_props

		for (i in 1:nrow(PE_step4)) {				# go through 1 row at a time
			if (is.na(PE_step4$sp_prop[i])) {		# IF we encounter an na (empty strata), then we must deal with it
			  add_me <- PE_step4[1,]			# lazy way to make an empty data frame with columns matching PE_step4
				for (j in 1:nrow(global_sp_prop)) {		# copy each row of the global average and fill in the df
						add_me[j,1:6] <- PE_step4[i,1:6]
						add_me[j,7] <- global_sp_prop[j,1]				# BREAKDOWN_SPECIES_FK
						add_me[j,8] <- global_sp_prop[j,2]				# SCIENTIFIC_NAME_PK
						add_me[j,9] <- as.character(add_me[j,4])			# FISHING_METHOD_FK
						add_me[j,10] <- as.character(add_me[j,5])			# zone_FK
						add_me[j,11] <- global_sp_prop[j,4]				# sp_prop
				}
			  PE_step4 <- rbind(PE_step4,add_me)	# now we have the global averages and correct empty strata info
										# add to end of PE_step4
			}
		} 

		# remove the NA strata that we just expanded		
		PE_step4 <- na.omit(PE_step4)

		# check rows
		 expect_rows
		 nrow(PE_step4)
		
	# carry on
  	PE_step5 <- mutate(PE_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)			# View(PE_step5)		#str(PE_step5)
	
	# drop row.names
	rownames(PE_step5) <- NULL
	# using na.omit attaches an attribute to tell us which row names were omitted. remove this attribute.
	attributes(PE_step5)$na.action <- NULL

 # update by_species by replacing SPECIES_FK = 240 with PE_step5.BREAKDOWN_SPECIES_FK

 	PE_addin <- data.frame(year_num = PE_step5$year_num,
					SPECIES_FK = PE_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = PE_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = PE_step5$FISHING_METHOD,
					zone = PE_step5$zone,
					TOT_LBS = PE_step5$BREAKDOWN_TOT_LBS)
	# View(PE_addin)	# str(PE_addin)	# 88 records
	by_species_update1 <- subset(by_species, SPECIES_FK != 240)  
		# str(by_species_update1) 	# check # records: 3,756 records = 3,776 originally in by_species - 20 that were PE
	by_species_update2 <- rbind(by_species_update1, PE_addin)			
		#str(by_species_update2)	# add back in the 88 records that we just produced via. breakdown = 3756 + 88 = 3,844 records

 # sum over year x species x gear x zone  (because strata that had both ID'd prist/etelis and unid prist/etelis will have some
 #	duplicate species columns.

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE <- sqldf(string, stringsAsFactors=FALSE)		
	# str(by_species_update_PE)		# 3774. exact number of records to expect is difficult to tell
							# minimum = previous by_species (3,776) - group records (20) = 3756
							# max would be if we created gear(2) x zone(2) x species(nrow(global_sp_prop)=9) x group_records(20)
							# i.e. (3776-20)+(2*2*9*20) = 4,476
	# nrow(by_species_update_PE)		
	#		# UPDATED NUMBER OF RECORDS = 3,774
	# make sure catch was neither lost nor generated during the breakdown
	before_4 <- sum(by_species$TOT_LBS)
	after_4a <- sum(by_species_update_PE$TOT_LBS)
	before_4
	after_4a

#  ------- 4b. INSHORE SNAPPERS AND DEEP SNAPPERS

	#
 	string <- "SELECT by_species_update_PE.*, group_key.*
		FROM by_species_update_PE
		LEFT JOIN group_key
			ON by_species_update_PE.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3774
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all deep_snappers are inshore snappers, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Deep_snappers_230 = 1 and SPECIES_FK not in (230, 390)
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	snaps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step1)	#str(snaps_step1)		#1203

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM snaps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	snaps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step2)	#str(snaps_step2)		#114

 	# merge back
  	string <- "SELECT snaps_step1.*, snaps_step2.group_tot
		FROM snaps_step1 LEFT JOIN snaps_step2
			ON snaps_step1.year_num = snaps_step2.year_num
					AND
				snaps_step1.FISHING_METHOD = snaps_step2.FISHING_METHOD
					AND
				snaps_step1.zone = snaps_step2.zone"

	snaps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step3)			#str(snaps_step3)		#1203

	snaps_breakdown <- mutate(snaps_step3, sp_prop = TOT_LBS/group_tot)
	# View(snaps_breakdown)

  	snaps_catch <- subset(by_species_update_PE, SPECIES_FK == 230 | SPECIES_FK == 390)
	# View(snaps_catch)		#str(snaps_catch) # 31 records

 	# break-down all snappers catch records into presumed species 
  	# head(snaps_catch)
	# head(snaps_breakdown)

 	string <- "SELECT snaps_catch.*, snaps_breakdown.SPECIES_FK, snaps_breakdown.SCIENTIFIC_NAME_PK, snaps_breakdown.FISHING_METHOD,
				snaps_breakdown.zone, snaps_breakdown.sp_prop
			FROM snaps_catch LEFT JOIN snaps_breakdown
				ON snaps_catch.year_num = snaps_breakdown.year_num
				AND
				snaps_catch.FISHING_METHOD = snaps_breakdown.FISHING_METHOD 
				AND
				snaps_catch.zone = snaps_breakdown.zone 
			ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	snaps_step4 <- sqldf(string, stringsAsFactors=FALSE)
	
	# str(snaps_step4)			# 414
	names(snaps_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(snaps_step4)[9] <- "FISHING_METHOD_FK"
	names(snaps_step4)[10] <- "zone_FK"

		# ---  DEAL WITH MISSING STRATA: SEE NOTES IN PRIST / ETELIS ABOVE

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM snaps_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#114 strata
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			# na_strata <- sum(is.na(snaps_step4$sp_prop))			#1 empty / missing strata
			# expect_rows <- nrow(snaps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 440

  		#  fill in the missing strata with the average sp_props

		for (i in 1:nrow(snaps_step4)) {				# go through 1 row at a time
			if (is.na(snaps_step4$sp_prop[i])) {		# IF we encounter an na (empty strata), then we must deal with it
			  add_me <- snaps_step4[1,]			# lazy way to make an empty data frame with columns matching step4
				for (j in 1:nrow(global_sp_prop)) {		# copy each row of the global average and fill in the df
						add_me[j,1:6] <- snaps_step4[i,1:6]
						add_me[j,7] <- global_sp_prop[j,1]				# BREAKDOWN_SPECIES_FK
						add_me[j,8] <- global_sp_prop[j,2]				# SCIENTIFIC_NAME_PK
						add_me[j,9] <- as.character(add_me[j,4])			# FISHING_METHOD_FK
						add_me[j,10] <- as.character(add_me[j,5])			# zone_FK
						add_me[j,11] <- global_sp_prop[j,4]				# sp_prop
				}
			  snaps_step4 <- rbind(snaps_step4,add_me)	# now we have the global averages and correct empty strata info
										# add to end of step4
			}
		} 

		# remove the NA strata that we just expanded		
		snaps_step4 <- na.omit(snaps_step4)

		# check rows
		expect_rows
		nrow(snaps_step4)
	
  	snaps_step5 <- mutate(snaps_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# drop row.names
	rownames(snaps_step5) <- NULL
	# using na.omit attaches an attribute to tell us which row names were omitted. remove this attribute.
	attributes(snaps_step5)$na.action <- NULL

 # update by_species_update by replacing SPECIES_FK = 230 and 390 with snaps_step5.BREAKDOWN_SPECIES_FK

 	snaps_addin <- data.frame(year_num = snaps_step5$year_num,
					SPECIES_FK = snaps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = snaps_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = snaps_step5$FISHING_METHOD,
					zone = snaps_step5$zone,
					TOT_LBS = snaps_step5$BREAKDOWN_TOT_LBS)
	# View(snaps_addin)	# str(snaps_addin)	# 436 records
	by_species_update1 <- subset(by_species_update_PE, SPECIES_FK != 230 & SPECIES_FK != 390)  # str(by_species_update1) 	# 3743 records
	by_species_update2 <- rbind(by_species_update1, snaps_addin)	#str(by_species_update2)	#4183 records

 # sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps <- sqldf(string, stringsAsFactors=FALSE)		
	str(by_species_update_PE_snaps)		# 3770

	# make sure catch was neither lost nor generated during the breakdown
	before_4b <- sum(by_species_update_PE$TOT_LBS)
	after_4b <- sum(by_species_update_PE_snaps$TOT_LBS)
	before_4b
	after_4b

#  ------- 4c. GROUPERS 210 AND INSHORE GROUPERS 380 


 string <- "SELECT by_species_update_PE_snaps.*, group_key.*
		FROM by_species_update_PE_snaps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 3770 	View(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	#  NOTE HERE that since all groupers are inshore groupers, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Groupers_210 = 1 and SPECIES_FK not in (210, 380)
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	grps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step1)		

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM grps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	grps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step2)		#str(grps_step2)			#106

 	# merge back
	string <- "SELECT grps_step1.*, grps_step2.group_tot
		FROM grps_step1 LEFT JOIN grps_step2
			ON grps_step1.year_num = grps_step2.year_num
					AND
				grps_step1.FISHING_METHOD = grps_step2.FISHING_METHOD
					AND
				grps_step1.zone = grps_step2.zone"

	grps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step3)			#str(grps_step3)		#577

	grps_breakdown <- mutate(grps_step3, sp_prop = TOT_LBS/group_tot)
	# View(grps_breakdown)

  	grps_catch <- subset(by_species_update_PE_snaps, SPECIES_FK == 210 | SPECIES_FK == 380)
	# View(grps_catch)	#str(grps_catch)		#89

 	# break-down all groupers catch records into presumed species 

 	string <- "SELECT grps_catch.*, grps_breakdown.SPECIES_FK, grps_breakdown.SCIENTIFIC_NAME_PK, grps_breakdown.FISHING_METHOD,
				grps_breakdown.zone, grps_breakdown.sp_prop
			FROM grps_catch LEFT JOIN grps_breakdown
				ON grps_catch.year_num = grps_breakdown.year_num
				  AND
				grps_catch.FISHING_METHOD = grps_breakdown.FISHING_METHOD 
				  AND
				grps_catch.zone = grps_breakdown.zone 
			ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	grps_step4 <- sqldf(string, stringsAsFactors=FALSE)
		
	# str(grps_step4)			# 466
	names(grps_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(grps_step4)[9] <- "FISHING_METHOD_FK"
	names(grps_step4)[10] <- "zone_FK"

	# ---  DEAL WITH MISSING STRATA: SEE NOTES IN PRIST / ETELIS ABOVE

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM grps_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#106 strata
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			# na_strata <- sum(is.na(grps_step4$sp_prop))			#2 empty / missing strata
			# expect_rows <- nrow(grps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 528

  		#  fill in the missing strata with the average sp_props

		for (i in 1:nrow(grps_step4)) {				# go through 1 row at a time
			if (is.na(grps_step4$sp_prop[i])) {		# IF we encounter an na (empty strata), then we must deal with it
			  add_me <- grps_step4[1,]			# lazy way to make an empty data frame with columns matching step4
				for (j in 1:nrow(global_sp_prop)) {		# copy each row of the global average and fill in the df
						add_me[j,1:6] <- grps_step4[i,1:6]
						add_me[j,7] <- global_sp_prop[j,1]				# BREAKDOWN_SPECIES_FK
						add_me[j,8] <- global_sp_prop[j,2]				# SCIENTIFIC_NAME_PK
						add_me[j,9] <- as.character(add_me[j,4])			# FISHING_METHOD_FK
						add_me[j,10] <- as.character(add_me[j,5])			# zone_FK
						add_me[j,11] <- global_sp_prop[j,4]				# sp_prop
				}
			  grps_step4 <- rbind(grps_step4,add_me)	# now we have the global averages and correct empty strata info
										# add to end of step4
			}
		} 

		# remove the NA strata that we just expanded		
		grps_step4 <- na.omit(grps_step4)

		# check rows
		expect_rows
		nrow(grps_step4)
	
  	grps_step5 <- mutate(grps_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# drop row.names
	rownames(grps_step5) <- NULL
	# using na.omit attaches an attribute to tell us which row names were omitted. remove this attribute.
	attributes(grps_step5)$na.action <- NULL

 # update by_species_update by replacing SPECIES_FK = 210 and 380 with grps_step5.BREAKDOWN_SPECIES_FK

 	grps_addin <- data.frame(year_num = grps_step5$year_num,
					SPECIES_FK = grps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = grps_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = grps_step5$FISHING_METHOD,
					zone = grps_step5$zone,
					TOT_LBS = grps_step5$BREAKDOWN_TOT_LBS)
	# View(grps_addin)	# str(grps_addin)	# 454 records
	by_species_update1 <- subset(by_species_update_PE_snaps, SPECIES_FK != 210 & SPECIES_FK != 380)  # str(by_species_update1) 	# 3681 records
	by_species_update2 <- rbind(by_species_update1, grps_addin)	#  str(by_species_update2)	#4209 records

 # sum over year x species x gear x zone

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps)		# 3745

	# make sure catch was neither lost nor generated during the breakdown
	before_4 <- sum(by_species$TOT_LBS)
	after_4c <- sum(by_species_update_PE_snaps_grps$TOT_LBS)
	before_4
	after_4c

#  ------- 4d. TREVALLY 109 AND JACKS 110

 	string <- "SELECT by_species_update_PE_snaps_grps.*, group_key.*
		FROM by_species_update_PE_snaps_grps
		LEFT JOIN group_key
		  ON by_species_update_PE_snaps_grps.SPECIES_FK = group_key.SPECIES_PK"
	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	# str(catch_year_codes)		#3745 	View(catch_year_codes)

	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all trevallies are jacks, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
		FROM catch_year_codes
		WHERE Jacks_110 = 1 and SPECIES_FK not in (109, 110)
		ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	jacks_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step1)		#str(jacks_step1)			#308 strata with identified jacks

	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
		FROM jacks_step1
		GROUP BY year_num, FISHING_METHOD, zone"
	jacks_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step2)		#str(jacks_step2)			#104 year x area x gear strata with id jacks

 	# merge back
	string <- "SELECT jacks_step1.*, jacks_step2.group_tot
		FROM jacks_step1 LEFT JOIN jacks_step2
			ON jacks_step1.year_num = jacks_step2.year_num
				  AND
				jacks_step1.FISHING_METHOD = jacks_step2.FISHING_METHOD
				  AND
				jacks_step1.zone = jacks_step2.zone"
	jacks_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step3)			#str(jacks_step3)			#308

	jacks_breakdown <- mutate(jacks_step3, sp_prop = TOT_LBS/group_tot)
	# View(jacks_breakdown)

  	jacks_catch <- subset(by_species_update_PE_snaps_grps, SPECIES_FK == 109 | SPECIES_FK == 110)
	# View(jacks_catch)		#85			# str(jacks_catch)

 	# break-down all jacks catch records into presumed species 
	#	head(jacks_catch)
	#	head(jacks_breakdown)

	string <- "SELECT jacks_catch.*, jacks_breakdown.SPECIES_FK, jacks_breakdown.SCIENTIFIC_NAME_PK, jacks_breakdown.FISHING_METHOD,
			jacks_breakdown.zone,  jacks_breakdown.sp_prop
		FROM jacks_catch LEFT JOIN jacks_breakdown
			ON jacks_catch.year_num = jacks_breakdown.year_num 
			 	AND
			jacks_catch.FISHING_METHOD = jacks_breakdown.FISHING_METHOD 
				AND
			jacks_catch.zone = jacks_breakdown.zone 
		ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	jacks_step4 <- sqldf(string, stringsAsFactors=FALSE)
		
	# str(jacks_step4)			# 270
	names(jacks_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(jacks_step4)[9] <- "FISHING_METHOD_FK"
	names(jacks_step4)[10] <- "zone_FK"

	# ---  DEAL WITH MISSING STRATA: SEE NOTES IN PRIST / ETELIS ABOVE

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM jacks_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#104 strata
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			na_strata <- sum(is.na(jacks_step4$sp_prop))			#8 empty / missing strata
			expect_rows <- nrow(jacks_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 390

  		#  fill in the missing strata with the average sp_props

		for (i in 1:nrow(jacks_step4)) {				# go through 1 row at a time
			if (is.na(jacks_step4$sp_prop[i])) {		# IF we encounter an na (empty strata), then we must deal with it
			  add_me <- jacks_step4[1,]			# lazy way to make an empty data frame with columns matching step4
				for (j in 1:nrow(global_sp_prop)) {		# copy each row of the global average and fill in the df
						add_me[j,1:6] <- jacks_step4[i,1:6]
						add_me[j,7] <- global_sp_prop[j,1]				# BREAKDOWN_SPECIES_FK
						add_me[j,8] <- global_sp_prop[j,2]				# SCIENTIFIC_NAME_PK
						add_me[j,9] <- as.character(add_me[j,4])			# FISHING_METHOD_FK
						add_me[j,10] <- as.character(add_me[j,5])			# zone_FK
						add_me[j,11] <- global_sp_prop[j,4]				# sp_prop
				}
			  jacks_step4 <- rbind(jacks_step4,add_me)	# now we have the global averages and correct empty strata info
										# add to end of step4
			}
		} 

		# remove the NA strata that we just expanded		
		jacks_step4 <- na.omit(jacks_step4)

		# check rows
		 expect_rows
		 nrow(jacks_step4)
	
  	jacks_step5 <- mutate(jacks_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# drop row.names
	rownames(jacks_step5) <- NULL
	# using na.omit attaches an attribute to tell us which row names were omitted. remove this attribute.
	attributes(jacks_step5)$na.action <- NULL

 	# update by_species_update by replacing SPECIES_FK = 109 and 110 with jacks_step5.BREAKDOWN_SPECIES_FK

 	jacks_addin <- data.frame(year_num = jacks_step5$year_num,
					SPECIES_FK = jacks_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = jacks_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = jacks_step5$FISHING_METHOD,
					zone = jacks_step5$zone,
					TOT_LBS = jacks_step5$BREAKDOWN_TOT_LBS)
	# View(jacks_addin)	# str(jacks_addin)	# 390 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps, SPECIES_FK != 109 & SPECIES_FK != 110)  # str(by_species_update1) 	# 3660 records
	by_species_update2 <- rbind(by_species_update1, jacks_addin)	#  str(by_species_update2)	#4050 records

 	# sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks)		# 3788

	# make sure catch was neither lost nor generated during the breakdown
	before_4 <- sum(by_species_update_PE$TOT_LBS)
	after_4d <- sum(by_species_update_PE_snaps_grps_jacks$TOT_LBS)
	before_4
	after_4d 

#  -------4e. EMPORERS 260

 	string <- "SELECT by_species_update_PE_snaps_grps_jacks.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 3788
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Emporers_260 = 1 and SPECIES_FK != 260
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	emps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step1)			# 354

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM emps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	emps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step2)			# 96

	# merge back
	string <- "SELECT emps_step1.*, emps_step2.group_tot
		FROM emps_step1 LEFT JOIN emps_step2
			ON emps_step1.year_num = emps_step2.year_num
				  AND
				emps_step1.FISHING_METHOD = emps_step2.FISHING_METHOD
				  AND
				emps_step1.zone = emps_step2.zone"
	emps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step3)			# 354

	emps_breakdown <- mutate(emps_step3, sp_prop = TOT_LBS/group_tot)
	# View(emps_breakdown)

  	emps_catch <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK == 260)
	# str(emps_catch)	#View(emps_catch)		#48

 	# break-down all un-id records into presumed species 
 	string <-  "SELECT emps_catch.*, emps_breakdown.SPECIES_FK, emps_breakdown.SCIENTIFIC_NAME_PK, emps_breakdown.FISHING_METHOD,
				emps_breakdown.zone, emps_breakdown.sp_prop
			FROM emps_catch LEFT JOIN emps_breakdown
				ON emps_catch.year_num = emps_breakdown.year_num
					AND
				emps_catch.FISHING_METHOD = emps_breakdown.FISHING_METHOD 
					AND
				emps_catch.zone = emps_breakdown.zone  
			ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	emps_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step4)				# 174		# View(emps_step4)
	
	names(emps_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(emps_step4)[9] <- "FISHING_METHOD_FK"
	names(emps_step4)[10] <- "zone_FK"


	# ---  DEAL WITH MISSING STRATA: SEE NOTES IN PRIST / ETELIS ABOVE

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM emps_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#96 strata
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			na_strata <- sum(is.na(emps_step4$sp_prop))			#5 empty / missing strata
			expect_rows <- nrow(emps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 234

  		#  fill in the missing strata with the average sp_props

		for (i in 1:nrow(emps_step4)) {				# go through 1 row at a time
			if (is.na(emps_step4$sp_prop[i])) {		# IF we encounter an na (empty strata), then we must deal with it
			  add_me <- emps_step4[1,]			# lazy way to make an empty data frame with columns matching step4
				for (j in 1:nrow(global_sp_prop)) {		# copy each row of the global average and fill in the df
						add_me[j,1:6] <- emps_step4[i,1:6]
						add_me[j,7] <- global_sp_prop[j,1]				# BREAKDOWN_SPECIES_FK
						add_me[j,8] <- global_sp_prop[j,2]				# SCIENTIFIC_NAME_PK
						add_me[j,9] <- as.character(add_me[j,4])			# FISHING_METHOD_FK
						add_me[j,10] <- as.character(add_me[j,5])			# zone_FK
						add_me[j,11] <- global_sp_prop[j,4]				# sp_prop
				}
			  emps_step4 <- rbind(emps_step4,add_me)	# now we have the global averages and correct empty strata info
										# add to end of step4
			}
		} 

		# remove the NA strata that we just expanded		
		emps_step4 <- na.omit(emps_step4)			#View(snaps_step4)

		# check rows
		expect_rows
		nrow(emps_step4)
	
  	emps_step5 <- mutate(emps_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# drop row.names
	rownames(emps_step5) <- NULL
	# using na.omit attaches an attribute to tell us which row names were omitted. remove this attribute.
	attributes(emps_step5)$na.action <- NULL


	# update by_species_update by replacing SPECIES_FK = 260 with emps_step5.BREAKDOWN_SPECIES_FK
 	emps_addin <- data.frame(year_num = emps_step5$year_num,
					SPECIES_FK = emps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = emps_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = emps_step5$FISHING_METHOD,
					zone = emps_step5$zone,
					TOT_LBS = emps_step5$BREAKDOWN_TOT_LBS)
	# View(emps_addin)	# str(emps_addin)		# 234 records
	
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK != 260)  # str(by_species_update1) 	# 3740 records
	by_species_update2 <- rbind(by_species_update1, emps_addin)	#  str(by_species_update2)	# 3974 records

 	# sum over year x species x gear x zone
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	by_species_update_PE_snaps_grps_jacks_emps <- sqldf(string, stringsAsFactors=FALSE)

	str(by_species_update_PE_snaps_grps_jacks_emps)		# 3805

	# make sure catch was neither lost nor generated during the breakdown
	 before_4 <- sum(by_species$TOT_LBS)
	 after_4e <- sum(by_species_update_PE_snaps_grps_jacks_emps$TOT_LBS)
	 before_4
 	 after_4e

#  ------- 4f. BOTTOMFISH 200

 	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks_emps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks_emps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3805
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Bottomfishes_200 = 1 and SPECIES_FK != 200
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	bfish_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step1)		# str(bfish_step1)		#2784

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM bfish_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	bfish_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step2)		# str(bfish_step2)		#119

 	# merge back
	string <- "SELECT bfish_step1.*, bfish_step2.group_tot
		FROM bfish_step1 LEFT JOIN bfish_step2
			ON bfish_step1.year_num = bfish_step2.year_num
					AND
				bfish_step1.FISHING_METHOD = bfish_step2.FISHING_METHOD
					AND
				bfish_step1.zone = bfish_step2.zone"

	bfish_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step3)		# str(bfish_step3)		#2784

	bfish_breakdown <- mutate(bfish_step3, sp_prop = TOT_LBS/group_tot)
	# View(bfish_breakdown)

  	bfish_catch <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK == 200)
	str(bfish_catch)		#View(bfish_catch)			# 39

 	# break-down all bottomfish records into presumed species 
 	string <- "SELECT bfish_catch.*, bfish_breakdown.SPECIES_FK, bfish_breakdown.SCIENTIFIC_NAME_PK, bfish_breakdown.FISHING_METHOD,
				bfish_breakdown.zone,  bfish_breakdown.sp_prop
			FROM bfish_catch LEFT JOIN bfish_breakdown
			  ON bfish_catch.year_num = bfish_breakdown.year_num
					AND
				bfish_catch.FISHING_METHOD = bfish_breakdown.FISHING_METHOD 
				  	AND
				bfish_catch.zone = bfish_breakdown.zone 
			ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	bfish_step4 <- sqldf(string, stringsAsFactors=FALSE)
	
	# str(bfish_step4)			# 891
	names(bfish_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(bfish_step4)[9] <- "FISHING_METHOD_FK"
	names(bfish_step4)[10] <- "zone_FK"

	# ---  THERE ARE NO MISSING BOTTOMFISH STRATA

	# na_strata <- sum(is.na(bfish_step4$sp_prop))			#0 empty / missing strata
	#	no need to modify bfish_step4
	
  	bfish_step5 <- mutate(bfish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)		#View(bfish_step5)
	# str(bfish_step5)			# 891	

	# update by_species_update by replacing SPECIES_FK = 200 with bfish_step5.BREAKDOWN_SPECIES_FK

 	bfish_addin <- data.frame(year_num = bfish_step5$year_num,
					SPECIES_FK = bfish_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = bfish_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = bfish_step5$FISHING_METHOD,
					zone = bfish_step5$zone,
					TOT_LBS = bfish_step5$BREAKDOWN_TOT_LBS)
	# View(bfish_addin)	# str(bfish_addin)		# 891 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK != 200)  # 
			str(by_species_update1) 	# 3766 records
	by_species_update2 <- rbind(by_species_update1, bfish_addin)	#  str(by_species_update2)	#4657 records

 	# sum over year x species x gear x zone
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks_emps_bfish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish)		# 3766

	# make sure catch was neither lost nor generated during the breakdown
	before_4 <- sum(by_species$TOT_LBS)
	after_4f <- sum(by_species_update_PE_snaps_grps_jacks_emps_bfish$TOT_LBS)
	before_4 
	after_4f

#  ------------------------------ final step: fishes, unknown

	string <- "SELECT *
			FROM by_species_update_PE_snaps_grps_jacks_emps_bfish
			WHERE SPECIES_FK = 100"

	FishNoID <- sqldf(string, stringsAsFactors=FALSE)
	# View(FishNoID)
	# not much non-ID fish, but I'll break it down anyway, just for completeness.

	# join group key
	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps_bfish.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks_emps_bfish
		LEFT JOIN group_key
		  ON by_species_update_PE_snaps_grps_jacks_emps_bfish.SPECIES_FK = group_key.SPECIES_PK
		"
	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	# str(catch_year_codes)		#3766 	View(catch_year_codes)

	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	# select out ID species that could be fish, excluding fish group
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
		FROM catch_year_codes
		WHERE Fish_100 = 1 and SPECIES_FK != 100
		ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	fish_step1 <- sqldf(string, stringsAsFactors=FALSE)				# View(fish_step1)

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM fish_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	fish_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(fish_step2)

 	# merge back
  	string <- "SELECT fish_step1.*, fish_step2.group_tot
			FROM fish_step1 LEFT JOIN fish_step2
			  	ON fish_step1.year_num = fish_step2.year_num
				  AND
				fish_step1.FISHING_METHOD = fish_step2.FISHING_METHOD
				  AND
				fish_step1.zone = fish_step2.zone"
	fish_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(fish_step3)		# str(fish_step3)		# 3746

	fish_breakdown <- mutate(fish_step3, sp_prop = TOT_LBS/group_tot)
	# View(fish_breakdown)

  	fish_catch <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK == 100)
	# View(fish_catch)		#17

 	# break-down all un-id fish records into presumed species 
 	string <- "SELECT fish_catch.*, fish_breakdown.SPECIES_FK, fish_breakdown.SCIENTIFIC_NAME_PK, fish_breakdown.FISHING_METHOD,
				fish_breakdown.zone, fish_breakdown.sp_prop
			FROM fish_catch LEFT JOIN fish_breakdown
				ON fish_catch.year_num = fish_breakdown.year_num 
					AND
				fish_catch.FISHING_METHOD = fish_breakdown.FISHING_METHOD 
				  	AND
				fish_catch.zone = fish_breakdown.zone 
			ORDER BY FISHING_METHOD, zone, year_num, SPECIES_FK"
	fish_step4 <- sqldf(string, stringsAsFactors=FALSE)

	# str(fish_step4)			# 499
	names(fish_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(fish_step4)[9] <- "FISHING_METHOD_FK"
	names(fish_step4)[10] <- "zone_FK"

		# ---  THERE ARE NO MISSING FISH STRATA

		# na_strata <- sum(is.na(fish_step4$sp_prop))			#0 empty / missing strata
		#	no need to modify fish_step4
	
  	fish_step5 <- mutate(fish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(fish_step5)			#str(fish_step5)			# 499

	# NOTE: at this point, we are breaking down "fish" into a few other non-specific groups, including
	#	SPECIES_FK			COMMON_NAME
	#	150				Sharks
	#	160				Rays
	#	300				Unk_reef_fishes
	#	360				Wrasses
	#	383				Triggerfishes
	#	450				Tunas
	#  That is OK, because these groups aren't possible bottomfish
	#	so having these groups persist in our break-down dataset isn't a problem for our analysis.

 	# update by_species_update by replacing SPECIES_FK = 100 with fish_step5.BREAKDOWN_SPECIES_FK

 	fish_addin <- data.frame(year_num = fish_step5$year_num,
					SPECIES_FK = fish_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = fish_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = fish_step5$FISHING_METHOD,
					zone = fish_step5$zone,
					TOT_LBS = fish_step5$BREAKDOWN_TOT_LBS)
	# View(fish_addin)	# str(fish_addin)		# 499 records this is a big number because every time unidentified fish showed up in a strata, we
									# added a tiny amount of many new species
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps_bfish, SPECIES_FK != 100)  # str(by_species_update1) 	# 3749 records #View(by_species_update1)
	by_species_update2 <- rbind(by_species_update1, fish_addin)	#  str(by_species_update2)	#4248 records

 	# sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	by_species_update_PE_snaps_grps_jacks_emps_bfish_fish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)		# 3749  # View(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)
	

	# make sure catch was neither lost nor generated during the breakdown
	before_4 <- sum(by_species$TOT_LBS)
	final <- sum(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish$TOT_LBS)
	before_4
	final

#  --------------------------------------------------------------------------
#  ---------- end step 4.
#	now we have a table of total catch (lbs) for every year x gear x area x species. groups are gone and all have been assigned to species.

# ---------------
# STEP 5: turn this total break-down catch table into a proportions key that we can use later (i.e. by applying it to expanded landings)

	# join break-down catch (step 4) back in with the group_key, so we know which groups each species could belong to.
	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps_bfish_fish.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks_emps_bfish_fish
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks_emps_bfish_fish.SPECIES_FK = group_key.SPECIES_PK"
	by_species_w_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_w_codes)		#3749				# View(by_species_w_codes)
	
	# important to rename duplicate column names
	names(by_species_w_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(by_species_w_codes)[10] <- "SCIENTIFIC_NAME_FK"	

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
	# str(step2)			#View(step2)			# 3749


	# sum groups by year, gear, zone  (sum catch per strata for each unknown group)
  	string <- "SELECT year_num,  FISHING_METHOD, zone, sum(Trevally_109_catch) as sum_trevally_109,				
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
		GROUP BY year_num,  FISHING_METHOD, zone"

	year_sums <- sqldf(string, stringsAsFactors=FALSE)
	str(year_sums)
	# View(year_sums)			# names(step2)

	# make into proportions
  	string <- "SELECT step2.year_num, step2.SPECIES_FK, step2.SCIENTIFIC_NAME_PK, step2.FISHING_METHOD, step2.zone,
			step2.Trevally_109_catch / year_sums.sum_trevally_109 as prop_trevally_109,
			step2.Jacks_110_catch / year_sums.sum_jacks_110  as prop_jacks_110,
			step2.Bottomfishes_200_catch / year_sums.sum_bfishes_200 as prop_bfishes_200,
			step2.Groupers_210_catch / year_sums.sum_groupers_210 as prop_groupers_210,
			step2.Deep_snappers_230_catch / year_sums.sum_deep_snappers_230 as prop_deep_snappers_230,
			step2.Prist_Etelis_240_catch / year_sums.sum_prist_et_240 as prop_prist_et_240,
			step2.Emporers_260_catch / year_sums.sum_emporers_260 as prop_emporers_260,
			step2.Inshore_groupers_380_catch / year_sums.sum_inshore_groups_380 as prop_inshore_groups_380,
			step2.Inshore_snappers_390_catch / year_sums.sum_inshore_snaps_390 as prop_inshore_snaps_390,
			step2.Fish_100_catch / year_sums.sum_fish_100 as prop_fish_100
		FROM step2 LEFT JOIN year_sums
				ON step2.year_num = year_sums.year_num
					AND
				step2.FISHING_METHOD = year_sums.FISHING_METHOD 
				  	AND
				step2.zone = year_sums.zone"

	species_proptable <- sqldf(string, stringsAsFactors=FALSE)
	# View(species_proptable)
	str(species_proptable)


 #  save this
	species_proptable_by_year_gear_zone <- species_proptable				 #  View(species_proptable_by_year)

#  make a .csv to check out in excel
#	write.csv(species_proptable_by_year_gear_zone, "species_proptable_by_year_gear_zone.csv")
# I looked at this carefully in Excel (see species_proptable_by_year_gear_zone_scratchwork.xls)
#	within each strata (gear x year x area) and group (trevallies, bottomfishes, fish, etc.)
#		 all species props will sum to 1 (as is expected) or to zero (if the gear x year x area x group and all
#			member species of that group were absent from the data).


#### SMOOTH THE SPECIES PROPS USING A MOVING AVERAGE
### THIS IS SURPRISINGLY COMPLICATED BECAUSE WE HAVE TO WEIGHT BASED ON AMOUNT OF INFORMATION IN SPECIES IDS FOR THAT YEAR
###
#
#	REMEMBER: In the landings expansion algorithm, Hongguang borrows information from other strata (no strata can have 0 catch).
#			this means that there might not be creel survey interviews (ex. btm/trl mix, Tutuila, 2001) but there will be
#			estimated landings of unidentified BMUS that we'll have to break down.
#
#	so, there will be a breakdown proptable that is specifically the BBS data (so non-sampled strata are represented appropriately.)
#		then, there will be the landings breakdown, where we continue to borrow from other strata.
#		
#
# ********* ensure 'NA's and 0s are correct!
#	this is important for smoothing the proptable
#	NAs = strata not sampled  OR species could not be in group that
#	0s =  species not observed

	proptable2 <- species_proptable_by_year_gear_zone
  	#put all NAs to 0
  	proptable2[is.na(proptable2)] <- 0 			# View(proptable2)	#str(proptable2)
  	#simplify: select BMUS only and eliminate duplicate group columns
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, prop_prist_et_240, 
					prop_deep_snappers_230, prop_groupers_210, prop_trevally_109, prop_emporers_260,
					prop_bfishes_200,prop_fish_100
			FROM proptable2 
			WHERE SPECIES_FK in ('247','239','111','248','249','267','231','241','242','245','229')
			ORDER BY SPECIES_FK, year_num
			"
	proptable_bmus <- sqldf(string, stringsAsFactors=FALSE)			#str(proptable_bmus)		#View(proptable_bmus)

#  for each year x gear x zone, how much information do we actually have on each of the species groups and which strata are NAs?
#	for example, if 1988 x Manu'a x Btm/trl mix there were zero identified pristipomoides / etelis, then we have no information
#	assume information is proportional to total surveyed catch that was id'd to species

	# start with catch_year_codes, do something similar to the beginning of step 4 in the breakdown to get sum id catch for each group.
		# make catch_year_codes if necessary
  		string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, SUM(EST_LBS) as TOT_LBS
		  	FROM
				(SELECT DISTINCT CATCH_PK, year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, EST_LBS
				FROM bbs_4C
				WHERE SPECIES_FK IS NOT '0' AND SPECIES_FK IS NOT 'NULL' AND year_num < 2021) 
		  	GROUP BY year_num, SPECIES_FK, FISHING_METHOD, zone, SCIENTIFIC_NAME
			ORDER BY year_num, SPECIES_FK"
		by_species <- sqldf(string, stringsAsFactors=FALSE)
		str(by_species)		# 3776 rows = species (including groups) x year x gear x zone strata		# View(by_species)

  		string <- "SELECT by_species.*, group_key.*
			FROM by_species
			LEFT JOIN group_key
			ON by_species.SPECIES_FK = group_key.SPECIES_PK"

		catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
		str(catch_year_codes)		#3776 rows
		names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
		names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Prist_Etelis_240 = 1 and SPECIES_FK != 240
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	PE_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(PE_step1)		# PE_step1 is all year x identified species x gear x area catch that could be Prist. / Etelis.
					#	that is 437 rows = 437 strata
 	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_prist_et
			FROM PE_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	PE_step2 <- sqldf(string, stringsAsFactors=FALSE)			#str(PE_step2)			#PE_step2

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Deep_snappers_230 = 1 and SPECIES_FK not in (230, 390)
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	snaps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step1)	#str(snaps_step1)		#1205
  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_snaps
			FROM snaps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	snaps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step2)	#str(snaps_step2)		#114

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Groupers_210 = 1 and SPECIES_FK not in (210, 380)
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	grps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step1)		

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_groups
			FROM grps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	grps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step2)		#str(grps_step2)			#106

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
		FROM catch_year_codes
		WHERE Jacks_110 = 1 and SPECIES_FK not in (109, 110)
		ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	jacks_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step1)		#str(jacks_step1)			#308 strata with identified jacks

	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_jacks
		FROM jacks_step1
		GROUP BY year_num, FISHING_METHOD, zone"
	jacks_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step2)		#str(jacks_step2)			#104

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Emporers_260 = 1 and SPECIES_FK != 260
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	emps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step1)			# 354

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_emps
			FROM emps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	emps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step2)			# 96

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Bottomfishes_200 = 1 and SPECIES_FK != 200
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	bfish_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step1)		# str(bfish_step1)		#3755

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_bfish
			FROM bfish_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	bfish_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step2)		# str(bfish_step2)		#119

	# select out ID species that could be fish, excluding fish group
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
		FROM catch_year_codes
		WHERE Fish_100 = 1 and SPECIES_FK != 100
		ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	fish_step1 <- sqldf(string, stringsAsFactors=FALSE)				# View(fish_step1)

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as ID_fish
			FROM fish_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	fish_step2 <- sqldf(string, stringsAsFactors=FALSE)		#str(fish_step2)		#121
	# View(fish_step2)

 	# make a dataframe of all possible strata= 35 years x 2 areas x 2 gears = 140
		potential_strata <- data.frame(year_num = rep(seq(1986,2020,1),4),
			FISHING_METHOD = c(rep('BOTTOMFISHING',70),rep('BTM/TRL MIX',70)),
			zone = c(rep('Tutuila',35),rep('Manua',35),rep('Tutuila',35),rep('Manua',35)))

			#str(potential_strata)		#View(species_years)

	# merge to get sum_id by group in wide format
		temp2a <- merge(x = potential_strata, y = PE_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)		#View(temp2a)
		temp2b <- merge(x = temp2a, y = snaps_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)
		temp2c <- merge(x = temp2b, y = grps_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)
		temp2d <- merge(x = temp2c, y = jacks_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)
		temp2e <- merge(x = temp2d, y = emps_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)
		temp2f <- merge(x = temp2e, y = bfish_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)
		temp2g <- merge(x = temp2f, y = fish_step2, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)		#View(temp2g)		#str(temp2g)
	  # for strata that were never sampled, ID_fish = NA
	  # make an index
		index_sampled <- (is.na(temp2g$ID_fish)==FALSE)
		index_sampled[index_sampled==TRUE] <- 1
		index_sampled[index_sampled==FALSE] <- NA
		#  index_sampled*temp2g$ID_prist_et
	
		temp2g[is.na(temp2g)] <- 0 
		temp3 <- data.frame(year_num = temp2g$year_num, FISHING_METHOD = temp2g$FISHING_METHOD, zone = temp2g$zone,
						ID_prist_et = index_sampled*temp2g$ID_prist_et,
						ID_snaps	= index_sampled*temp2g$ID_snaps,
						ID_groups	= index_sampled*temp2g$ID_groups,
						ID_jacks 	= index_sampled*temp2g$ID_jacks, 
						ID_emps 	= index_sampled*temp2g$ID_emps, 
						ID_bfish 	= index_sampled*temp2g$ID_bfish, 
						ID_fish 	= index_sampled*temp2g$ID_fish)				#View(temp3)

  # make a dataframe of all possible strata x 11 BMUS species. Expect 35 years x 2 areas x 2 gears x 11 species = 1540 rows

	# make a dataframe of all possible strata= 35 years x 2 areas x 2 gears x 11 species = 1540
		year_gear_zone <- data.frame(year_num = rep(seq(1986,2020,1),4),
			FISHING_METHOD = c(rep('BOTTOMFISHING',70),rep('BTM/TRL MIX',70)),
			zone = c(rep('Tutuila',35),rep('Manua',35),rep('Tutuila',35),rep('Manua',35)))

	year_gear_zone2 <- do.call("rbind", replicate(11, year_gear_zone, simplify = FALSE))		#str(year_gear_zone2)

	species_rep <- data.frame(
			SCIENTIFIC_NAME_PK = c(rep('Aphareus rutilans',140),rep('Aprion virescens',140),
			rep('Caranx lugubris',140),rep('Etelis coruscans',140),rep('Etelis carbunculus',140),
			rep('Lethrinus rubrioperculatus',140),rep('Lutjanus kasmira',140),rep('Pristipomoides flavipinnis',140),
			rep('Pristipomoides filamentosus',140),rep('Pristipomoides zonatus',140),rep('Variola louti',140)),
			
			SPECIES_FK = c(rep('247',140),rep('239',140),
			rep('111',140),rep('248',140),rep('249',140),
			rep('267',140),rep('231',140),rep('241',140),
			rep('242',140),rep('245',140),rep('229',140))

			)							#str(species_rep)	


	year_gear_zone_species <- cbind(year_gear_zone2, species_rep)			# str(year_gear_zone_species)		# 1540 

	proptable_bmus2 <- merge(x = year_gear_zone_species, y = proptable_bmus, 
				by = c('year_num','FISHING_METHOD','zone','SPECIES_FK','SCIENTIFIC_NAME_PK') , all.x = TRUE)		
					# str(proptable_bmus2)		#View(proptable_bmus2)
	# replace NAs with zeros
	proptable_bmus2[is.na(proptable_bmus2)] <- 0 

	# add back in the true NAs for strata x groups where no members species were identified
	
	proptable_bmus3 <- merge(x = proptable_bmus2, y = temp3, 
				by = c('year_num','FISHING_METHOD','zone') , all.x = TRUE)		
					# str(proptable_bmus3)		#View(proptable_bmus3)



#  now, we will make smoothed proptables for each expansion strata that we will break down by
#	2 zones x 2 gears = 4 tables

#  1. Manua x BTM/TRL MIX
	# select just the strata we are working with
	manua_mix <- subset(proptable_bmus3, FISHING_METHOD == 'BTM/TRL MIX' & zone == 'Manua')			#str(manua_mix)
	# add columns for the smoothed props
	manua_mix <- mutate(manua_mix, sm_prist_et = 999, sm_snaps = 999, 						#View(manua_mix)
					sm_grps = 999, sm_jacks = 999,
					 sm_emps = 999, sm_bfish = 999, sm_fish = 999)
	# put in order so it's easiest to understand
	manua_mix <- manua_mix[order(manua_mix$SPECIES_FK, manua_mix$year_num), ] 				#View(manua_mix)


#  CALCULATE THE SMOOTH (MOVING AVERAGE)
	#	remember, columns 6:12 are the prop, 13:19 are sum ID catch, 20:26 are smoothed
	# 	1986-1990 (first 5 years) average
	#	1991-2015 2 ahead, 2 behind
	#	2016-2020 (last 5) average
	# must loop for 11 species over 35 years
	
	for (s in 1:11) {
		y1 <- (s-1)*35 + 1

		for (y in 1:5) {
			we_on <- (s-1)*35 + y
			manua_mix[we_on, 20:26] <- (colSums(manua_mix[y1:(y1+4),6:12]*manua_mix[y1:(y1+4),13:19], na.rm=TRUE))/
								(colSums(manua_mix[y1:(y1+4),13:19] , na.rm=TRUE))
			}
		 for (y in 6:30) {
			we_on <- (s-1)*35 + y
			manua_mix[(we_on), 20:26] <- (colSums(manua_mix[(we_on-2):(we_on+2),6:12]*manua_mix[(we_on-2):(we_on+2),13:19], na.rm=TRUE))/
									(colSums(manua_mix[(we_on-2):(we_on+2),13:19] , na.rm=TRUE))
			}
		 for (y in 31:35) {
			we_on <- (s-1)*35 + y
			manua_mix[we_on, 20:26] <- (colSums(manua_mix[(y1+30):(y1+34),6:12]*manua_mix[(y1+30):(y1+34),13:19], na.rm=TRUE))/
									(colSums(manua_mix[(y1+30):(y1+34),13:19] , na.rm=TRUE))
			}
		}

	# write.csv(manua_mix, "manua_mix_ptable_13Dec.csv")
	# I looked at this in Excel. It checks out.			# View(manua_mix)


	# repeat for all strata


#  2. Manua x BOTTOMFISHING
	manua_btm <- subset(proptable_bmus3, FISHING_METHOD == 'BOTTOMFISHING' & zone == 'Manua')			
	manua_btm <- mutate(manua_btm , sm_prist_et = 999, sm_snaps = 999, 						
					sm_grps = 999, sm_jacks = 999,
					 sm_emps = 999, sm_bfish = 999, sm_fish = 999)
	manua_btm <- manua_btm[order(manua_btm$SPECIES_FK, manua_btm$year_num), ] 
	
	smooth_me <- manua_btm				#View(smooth_me)

	for (s in 1:11) {
		y1 <- (s-1)*35 + 1

		for (y in 1:5) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[y1:(y1+4),6:12]*smooth_me[y1:(y1+4),13:19], na.rm=TRUE))/
								(colSums(smooth_me[y1:(y1+4),13:19] , na.rm=TRUE))
			}
		 for (y in 6:30) {
			we_on <- (s-1)*35 + y
			smooth_me[(we_on), 20:26] <- (colSums(smooth_me[(we_on-2):(we_on+2),6:12]*smooth_me[(we_on-2):(we_on+2),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(we_on-2):(we_on+2),13:19] , na.rm=TRUE))
			}
		 for (y in 31:35) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[(y1+30):(y1+34),6:12]*smooth_me[(y1+30):(y1+34),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(y1+30):(y1+34),13:19] , na.rm=TRUE))
			}
		}

	manua_btm <- smooth_me


#  3. Tutuila x BOTTOMFISHING
	tutu_btm <- subset(proptable_bmus3, FISHING_METHOD == 'BOTTOMFISHING' & zone == 'Tutuila')			
	tutu_btm <- mutate(tutu_btm , sm_prist_et = 999, sm_snaps = 999, 						
					sm_grps = 999, sm_jacks = 999,
					 sm_emps = 999, sm_bfish = 999, sm_fish = 999)
	tutu_btm <- tutu_btm[order(tutu_btm$SPECIES_FK, tutu_btm$year_num), ] 
	
	smooth_me <- tutu_btm				#View(smooth_me)

	for (s in 1:11) {
		y1 <- (s-1)*35 + 1

		for (y in 1:5) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[y1:(y1+4),6:12]*smooth_me[y1:(y1+4),13:19], na.rm=TRUE))/
								(colSums(smooth_me[y1:(y1+4),13:19] , na.rm=TRUE))
			}
		 for (y in 6:30) {
			we_on <- (s-1)*35 + y
			smooth_me[(we_on), 20:26] <- (colSums(smooth_me[(we_on-2):(we_on+2),6:12]*smooth_me[(we_on-2):(we_on+2),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(we_on-2):(we_on+2),13:19] , na.rm=TRUE))
			}
		 for (y in 31:35) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[(y1+30):(y1+34),6:12]*smooth_me[(y1+30):(y1+34),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(y1+30):(y1+34),13:19] , na.rm=TRUE))
			}
		}

	tutu_btm <- smooth_me


#  4. Tutuila x mix
	tutu_mix <- subset(proptable_bmus3, FISHING_METHOD == 'BTM/TRL MIX' & zone == 'Tutuila')			
	tutu_mix <- mutate(tutu_mix, sm_prist_et = 999, sm_snaps = 999, 						
					sm_grps = 999, sm_jacks = 999,
					 sm_emps = 999, sm_bfish = 999, sm_fish = 999)
	tutu_mix <- tutu_mix[order(tutu_mix$SPECIES_FK, tutu_mix$year_num), ] 
	
	smooth_me <- tutu_mix 				#View(smooth_me)

	for (s in 1:11) {
		y1 <- (s-1)*35 + 1

		for (y in 1:5) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[y1:(y1+4),6:12]*smooth_me[y1:(y1+4),13:19], na.rm=TRUE))/
								(colSums(smooth_me[y1:(y1+4),13:19] , na.rm=TRUE))
			}
		 for (y in 6:30) {
			we_on <- (s-1)*35 + y
			smooth_me[(we_on), 20:26] <- (colSums(smooth_me[(we_on-2):(we_on+2),6:12]*smooth_me[(we_on-2):(we_on+2),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(we_on-2):(we_on+2),13:19] , na.rm=TRUE))
			}
		 for (y in 31:35) {
			we_on <- (s-1)*35 + y
			smooth_me[we_on, 20:26] <- (colSums(smooth_me[(y1+30):(y1+34),6:12]*smooth_me[(y1+30):(y1+34),13:19], na.rm=TRUE))/
									(colSums(smooth_me[(y1+30):(y1+34),13:19] , na.rm=TRUE))
			}
		}

	tutu_mix <- smooth_me

	# ---
	# rbind
	smooth_proptable <- rbind(tutu_btm, tutu_mix, manua_btm, manua_mix)		#str(smooth_proptable)		#View(smooth_proptable)

	# note that NaN is produced in rows 20 to 26 if sum of ID'd group catch is zero (hence division by zero). 
	# 	this essentially means that for the smoothing window (5 years), we don't have any information on identified catch.
	#	i.e. either that year (x zone x gear) wasn't sampled, or there were no species identified catch in that group.
	#	So, in the absence of info, we can be conservative and assume none of the group catch was the species in question
	#	do that here, make sure to be clear.
	#	so, put all NA or NaN values to 0
	#	then add back in the true NAs (not sampled or member group not  

	smooth_proptable[smooth_proptable == 'NaN'] <- 0 

	# --- unsampled strata should be NA

	index_sampled <- (is.na(smooth_proptable$ID_fish)==FALSE)
	index_sampled[index_sampled==TRUE] <- 1
	index_sampled[index_sampled==FALSE] <- NA

	smooth_proptable[,20:26] <- index_sampled*smooth_proptable[,20:26]			# View(smooth_proptable)
	smooth_proptable[,6:12] <- index_sampled*smooth_proptable[,6:12]			# names(smooth_proptable)

	# --- make it pretty by assigning NAs to species x groups that don't make sense
	# there is undoubtedly a more elegant way, but hardcoding is faster.

		# test: sum props to make sure we don't overwrite any data with NAs in next step
		sum_raw_pre <- sum(smooth_proptable[,c(6:12)], na.rm=TRUE)
		sum_sm_pre <- sum(smooth_proptable[,c(20:26)], na.rm=TRUE)

		# lugubris 111 cannot be 
		smooth_proptable$prop_groupers_210[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$prop_prist_et_240[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$prop_deep_snappers_230[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$prop_emporers_260[smooth_proptable$SPECIES_FK == 111] <- NA
		
		smooth_proptable$sm_grps[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$sm_prist_et[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$sm_snaps[smooth_proptable$SPECIES_FK == 111] <- NA
		smooth_proptable$sm_emps[smooth_proptable$SPECIES_FK == 111] <- NA

		# louti 229 cannot be
		smooth_proptable$prop_prist_et_240[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$prop_deep_snappers_230[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$prop_trevally_109[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$prop_emporers_260[smooth_proptable$SPECIES_FK == 229] <- NA

		smooth_proptable$sm_prist_et[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$sm_snaps[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$sm_jacks[smooth_proptable$SPECIES_FK == 229] <- NA
		smooth_proptable$sm_emps[smooth_proptable$SPECIES_FK == 229] <- NA

		# kasmira 231, virescens 239, rutilans 247 cannot be
		smooth_proptable$prop_prist_et_240[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$prop_groupers_210[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$prop_trevally_109[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$prop_emporers_260[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		
		smooth_proptable$sm_prist_et[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$sm_grps[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$sm_jacks[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA
		smooth_proptable$sm_emps[smooth_proptable$SPECIES_FK == 231 | smooth_proptable$SPECIES_FK == 239 | 
							smooth_proptable$SPECIES_FK == 247] <- NA

		# carbunculus 249, flavipinnis 241, filamentosus 242, zonatus 245, coruscans 248
		smooth_proptable$prop_groupers_210[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA
		smooth_proptable$prop_trevally_109[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA
		smooth_proptable$prop_emporers_260[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA

		smooth_proptable$sm_grps[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA
		smooth_proptable$sm_jacks[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA
		smooth_proptable$sm_emps[smooth_proptable$SPECIES_FK == 249 | smooth_proptable$SPECIES_FK == 241 | 
							smooth_proptable$SPECIES_FK == 242 | smooth_proptable$SPECIES_FK == 245 |
							smooth_proptable$SPECIES_FK == 248] <- NA

		# rubrioperculatus 267
		smooth_proptable$prop_groupers_210[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$prop_prist_et_240[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$prop_deep_snappers_230[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$prop_trevally_109[smooth_proptable$SPECIES_FK == 267] <- NA

		smooth_proptable$sm_grps[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$sm_prist_et[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$sm_snaps[smooth_proptable$SPECIES_FK == 267] <- NA
		smooth_proptable$sm_jacks[smooth_proptable$SPECIES_FK == 267] <- NA

		# test: sum props to make sure we don't overwrite any data with NAs in next step
		sum_raw_post <- sum(smooth_proptable[,c(6:12)], na.rm=TRUE)
		sum_sm_post <- sum(smooth_proptable[,c(20:26)], na.rm=TRUE)
		sum_raw_post == sum_raw_pre
		sum_sm_post == sum_sm_pre

		# if you get a double TRUE, then yay!


# -----------------------------------------------------------------------------------------------------------------------------


 # clean up workspace
	all_objs <- ls()
	save_objs <- c("smooth_proptable","root_dir", "species_proptable_by_year_gear_zone")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # workspace no longer contains individual BBS records, can have in Github
  # save.image(paste(root_dir, "/output/03_BBS_species_proptables.RData", sep=""))
  





























##  -----------------------------------------------------------------------------------------------------------------------------------------------
