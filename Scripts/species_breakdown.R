##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#	Erin Bohaboy erin.bohaboy@noaa.gov
#	American Samoa BMUS assessments 
# 	
#	MAKE SPECIES PROPTABLES
#
#
#	This script replaces Calc_sp_prop_groups_8Nov.R

##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------

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

#	We must break down each of the groups into individual species (previously done by BMU vs. not-BMU)
#		LUCKILY
#	  several of these groups are synonyms. For example, all Trevally species and also Jacks,
#		all Deep snappers are also inshore snapper
#		all groupers and also inshore groupers

#	Some groups are NESTED WITHIN other groups
#		For example, all Prist/Etelis are also Bottomfishes and all Bottomfishes are also unknown fishes

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

#  -----------------------------------------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
	library(ggplot2)
	library(magrittr)
	library(gridExtra)			
	library(grid)		
	library(cowplot)		
	library(lattice)		
	library(ggplotify)	


# ---------------

# Load the pre-processed boat-based creel survey data from workspace. See see 'BBS_data_prep_Oct7_2021.R'
	
	load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")
	ls()

#  ---------------

# Read in the BBS-SBS group key to tell us which species are in which groups
#	Brian and John made this table for the 2019 bottomfish assessment. It lists every species in BBS
#	and according to a set of rules tell us if the species could (1) or could not (0) be a member of
#	of each of the unknown species groups Trevally 109, Jacks 110, Bottomfishes 200, etc.
#	see page 29 of the 2019 assessment. In general, species were assigned by families, with a few exceptions.
#	For example, for Carangidae, scads (genera Decapterus, Selar, and Selaroides) were not considered possible BMUS, 
#		but other carangids were.

  	group_key <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE/AmSam_BBS-SBS_GroupKey_final.csv",
		header=T, stringsAsFactors=FALSE) 
	# View(group_key)


#  -----------------------------------------------------------------------------------------------------------------------------------------------
# I. Species proptable, pooled over gear and area


# ---------------
# STEP 1:  Reduce bbs_3C back down to a simple "catch" table. i.e. sum by species and year. 
#		Reminder: when multiple fish of a species are measured per interview, EST_LBS will repeat
#		so use CATCH_PK as the distinct field by
# Erin - don't get confused. Here I sum EST_LBS and call it TOT_LBS
#	this is not the same as the interview TOT_LBS from the flatview
#	tail(bbs_3C)

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, year_num, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE SPECIES_FK IS NOT '0' AND SPECIES_FK IS NOT 'NULL') 
		  GROUP BY year_num, SPECIES_FK, SCIENTIFIC_NAME
			ORDER BY SPECIES_FK"
	by_species <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species)		# 2070 rows		# View(by_species)

# ---------------
# STEP 2: merge aggregated catch to the BBS-SBS group key 

  string <- "SELECT by_species.*, group_key.*
		FROM by_species
		LEFT JOIN group_key
			ON by_species.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#2070
	# View(catch_year_codes)
	names(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	


# ---------------
# STEP 4: Break up each group. Yes, step 3 is not here, I didn't feel like renumbering.
#	there's probably a more elegant way to do this
#	code heavily commented for only some groups
#	note it is often wise to check the number of records and make sure we are getting the number we expect

#  ---- 4a. PRISTOPOMOIDES / ETELIS (240)

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Prist_Etelis_240 = 1 and SPECIES_FK != 240
			ORDER BY year_num, SPECIES_FK"
	
	PE_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step1)		# PE_step1 is all year x species (sum area and gear) catch that could be Prist. / Etelis.

 	 string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM PE_step1
			GROUP BY year_num"
	PE_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step2)		# PE_step2 is all catch, by year, (sum sp, area, gear) that could be Prist. / Etelis.

  	string <- "SELECT PE_step1.*, PE_step2.group_tot
		FROM PE_step1 LEFT JOIN PE_step2
			ON PE_step1.year_num = PE_step2.year_num"

	PE_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step3)		# merge step1 and step2 back together

	PE_breakdown <- mutate(PE_step3, sp_prop = TOT_LBS/group_tot)
	# View(PE_breakdown)	# add column for proportions

  	PE_catch <- subset(by_species, SPECIES_FK == 240)
	# View(PE_catch)	# 10 records: catch by year for the group we are breaking down.

 # break-down all Prist/etelis catch records into presumed species 

 	string <- "SELECT PE_catch.*, PE_breakdown.SPECIES_FK, PE_breakdown.SCIENTIFIC_NAME_PK,  PE_breakdown.sp_prop
		FROM PE_catch LEFT JOIN PE_breakdown
			ON PE_catch.year_num = PE_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	PE_step4 <- sqldf(string, stringsAsFactors=FALSE)
	names(PE_step4)[5] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names

  	PE_step5 <- mutate(PE_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(PE_step5)		#58 records

 # update by_species by replacing SPECIES_FK = 240 with PE_step5.BREAKDOWN_SPECIES_FK

 	PE_addin <- data.frame(year_num = PE_step5$year_num,
					SPECIES_FK = PE_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = PE_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = PE_step5$BREAKDOWN_TOT_LBS)
	# View(PE_addin)	# str(PE_addin)	# 58 records
	by_species_update1 <- subset(by_species, SPECIES_FK != 240)  
		# str(by_species_update1) 	# check # records: 2060 records = 2070 originally in by_species - 10 that were PE
	by_species_update2 <- rbind(by_species_update1, PE_addin)	
		#str(by_species_update2)	# add back in the 58 records that we just produced via. breakdown = 2118 records

 # sum over year x species

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE <- sqldf(string, stringsAsFactors=FALSE)		
	str(by_species_update_PE)		# should be same as last by_species minus group records, e.g. 2070 - 10 = 2060
		#View(by_species_update_PE)


#  ------- 4b. INSHORE SNAPPERS AND DEEP SNAPPERS


 	string <- "SELECT by_species_update_PE.*, group_key.*
		FROM by_species_update_PE
		LEFT JOIN group_key
			ON by_species_update_PE.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#2060
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all deep_snappers are inshore snappers, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Deep_snappers_230 = 1 and SPECIES_FK not in (230, 390)
			ORDER BY year_num, SPECIES_FK"
	
	snaps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step1)	#str(snaps_step1)

  	string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM snaps_step1
			GROUP BY year_num"
	snaps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step2)	#str(snaps_step2)

 # merge back
  	string <- "SELECT snaps_step1.*, snaps_step2.group_tot
		FROM snaps_step1 LEFT JOIN snaps_step2
			ON snaps_step1.year_num = snaps_step2.year_num"

	snaps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step3)

	snaps_breakdown <- mutate(snaps_step3, sp_prop = TOT_LBS/group_tot)
	# View(snaps_breakdown)

  snaps_catch <- subset(by_species_update_PE, SPECIES_FK == 230 | SPECIES_FK == 390)
	# View(snaps_catch)		#str(snaps_catch) # 24 records

 # break-down all snappers catch records into presumed species 
  	head(snaps_catch)
	head(snaps_breakdown)

 	string <- "SELECT snaps_catch.*, snaps_breakdown.SPECIES_FK, snaps_breakdown.SCIENTIFIC_NAME_PK,  snaps_breakdown.sp_prop
		FROM snaps_catch LEFT JOIN snaps_breakdown
			ON snaps_catch.year_num = snaps_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	snaps_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step4)
	names(snaps_step4)[5] <- "BREAKDOWN_SPECIES_FK"

  	snaps_step5 <- mutate(snaps_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(snaps_step5)

 # update by_species_update by replacing SPECIES_FK = 230 and 390 with snaps_step5.BREAKDOWN_SPECIES_FK

 	snaps_addin <- data.frame(year_num = snaps_step5$year_num,
					SPECIES_FK = snaps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = snaps_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = snaps_step5$BREAKDOWN_TOT_LBS)
	# View(snaps_addin)	# str(snaps_addin)	# 391 records
	by_species_update1 <- subset(by_species_update_PE, SPECIES_FK != 230 & SPECIES_FK != 390)  # str(by_species_update1) 	# 2036 records
	by_species_update2 <- rbind(by_species_update1, snaps_addin)	#str(by_species_update2)	#2427 records

 # sum over year x species

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps <- sqldf(string, stringsAsFactors=FALSE)		
	str(by_species_update_PE_snaps)		# 2060 - 24 = 2036


#  ------- 4c. GROUPERS 210 AND INSHORE GROUPERS 380 


 string <- "SELECT by_species_update_PE_snaps.*, group_key.*
		FROM by_species_update_PE_snaps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 2036 	View(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all groupers are inshore groupers, we only need to pull species once from the relational table
string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Groupers_210 = 1 and SPECIES_FK not in (210, 380)
			ORDER BY year_num, SPECIES_FK"
	
	grps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step1)

  string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM grps_step1
			GROUP BY year_num"
	grps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step2)

 # merge back

  string <- "SELECT grps_step1.*, grps_step2.group_tot
		FROM grps_step1 LEFT JOIN grps_step2
			ON grps_step1.year_num = grps_step2.year_num"

	grps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step3)

	grps_breakdown <- mutate(grps_step3, sp_prop = TOT_LBS/group_tot)
	# View(grps_breakdown)

  grps_catch <- subset(by_species_update_PE_snaps, SPECIES_FK == 210 | SPECIES_FK == 380)
	# View(grps_catch)	#str(grps_catch)		#40

 # break-down all groupers catch records into presumed species 
  	head(grps_catch)
	head(grps_breakdown)

 	string <- "SELECT grps_catch.*, grps_breakdown.SPECIES_FK, grps_breakdown.SCIENTIFIC_NAME_PK,  grps_breakdown.sp_prop
		FROM grps_catch LEFT JOIN grps_breakdown
			ON grps_catch.year_num = grps_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	grps_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(grps_step4)
	names(grps_step4)[5] <- "BREAKDOWN_SPECIES_FK"

  	grps_step5 <- mutate(grps_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(grps_step5)

 # update by_species_update by replacing SPECIES_FK = 210 and 380 with grps_step5.BREAKDOWN_SPECIES_FK

 	grps_addin <- data.frame(year_num = grps_step5$year_num,
					SPECIES_FK = grps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = grps_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = grps_step5$BREAKDOWN_TOT_LBS)
	# View(grps_addin)	# str(grps_addin)	# 289 records
	by_species_update1 <- subset(by_species_update_PE_snaps, SPECIES_FK != 210 & SPECIES_FK != 380)  # str(by_species_update1) 	# 1996 records
	by_species_update2 <- rbind(by_species_update1, grps_addin)	#  str(by_species_update2)	#2285 records

 # sum over year x species

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps_grps <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps)		# 2036 - 40 = 1996


#  ------- 4d. TREVALLY 109 AND JACKS 110

 	string <- "SELECT by_species_update_PE_snaps_grps.*, group_key.*
		FROM by_species_update_PE_snaps_grps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#1996 	View(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all trevallies are jacks, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Jacks_110 = 1 and SPECIES_FK not in (109, 110)
			ORDER BY year_num, SPECIES_FK"
	
	jacks_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step1)

  	string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM jacks_step1
			GROUP BY year_num"
	jacks_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step2)

 # merge back

  string <- "SELECT jacks_step1.*, jacks_step2.group_tot
		FROM jacks_step1 LEFT JOIN jacks_step2
			ON jacks_step1.year_num = jacks_step2.year_num"

	jacks_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step3)

	jacks_breakdown <- mutate(jacks_step3, sp_prop = TOT_LBS/group_tot)
	# View(jacks_breakdown)

  jacks_catch <- subset(by_species_update_PE_snaps_grps, SPECIES_FK == 109 | SPECIES_FK == 110)
	View(jacks_catch)		#39

 # break-down all snappers catch records into presumed species 
  #	head(jacks_catch)
  #	head(jacks_breakdown)

 	string <- "SELECT jacks_catch.*, jacks_breakdown.SPECIES_FK, jacks_breakdown.SCIENTIFIC_NAME_PK,  jacks_breakdown.sp_prop
		FROM jacks_catch LEFT JOIN jacks_breakdown
			ON jacks_catch.year_num = jacks_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	jacks_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(jacks_step4)
	names(jacks_step4)[5] <- "BREAKDOWN_SPECIES_FK"

  	jacks_step5 <- mutate(jacks_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(jacks_step5)

 # update by_species_update by replacing SPECIES_FK = 109 and 110 with jacks_step5.BREAKDOWN_SPECIES_FK

 	jacks_addin <- data.frame(year_num = jacks_step5$year_num,
					SPECIES_FK = jacks_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = jacks_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = jacks_step5$BREAKDOWN_TOT_LBS)
	# View(jacks_addin)	# str(jacks_addin)	# 201 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps, SPECIES_FK != 109 & SPECIES_FK != 110)  # str(by_species_update1) 	# 1957 records
	by_species_update2 <- rbind(by_species_update1, jacks_addin)	#  str(by_species_update2)	#2158 records

 # sum over year x species

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks)		# 1996 - 39 = 1957


#  -------4e. EMPORERS 260

 string <- "SELECT by_species_update_PE_snaps_grps_jacks.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 1957
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	

string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Emporers_260 = 1 and SPECIES_FK != 260
			ORDER BY year_num, SPECIES_FK"
	
	emps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(emps_step1)

  string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM emps_step1
			GROUP BY year_num"
	emps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(emps_step2)

 # merge back

  string <- "SELECT emps_step1.*, emps_step2.group_tot
		FROM emps_step1 LEFT JOIN emps_step2
			ON emps_step1.year_num = emps_step2.year_num"

	emps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(emps_step3)

	emps_breakdown <- mutate(emps_step3, sp_prop = TOT_LBS/group_tot)
	# View(emps_breakdown)

  emps_catch <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK == 260)
	str(emps_catch)	#View(emps_catch)		#30

 # break-down all un-id records into presumed species 
  	head(emps_catch)
	head(emps_breakdown)

 	string <- "SELECT emps_catch.*, emps_breakdown.SPECIES_FK, emps_breakdown.SCIENTIFIC_NAME_PK,  emps_breakdown.sp_prop
		FROM emps_catch LEFT JOIN emps_breakdown
			ON emps_catch.year_num = emps_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	emps_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(emps_step4)
	names(emps_step4)[5] <- "BREAKDOWN_SPECIES_FK"

	  # ----------------- FOR EMPORERS ----------
		# In 1986 there were no emporers identified to species, just 118.5 lbs of unidentified emporers
		# So, assume props in 1986 were total 1987, 1988, 1989. modify emps_step4 

		string <- "SELECT *
				FROM emps_step4
				WHERE year_num in (1987, 1988, 1989)"
		emp_80s_1 <- sqldf(string, stringsAsFactors=FALSE)

		emp_80s_2 <- mutate(emp_80s_1, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)	

		string <- "SELECT BREAKDOWN_SPECIES_FK, SCIENTIFIC_NAME_PK, sum(BREAKDOWN_TOT_LBS) as sp_lbs_80s
				FROM emp_80s_2
				GROUP BY BREAKDOWN_SPECIES_FK"
		emp_80s_3 <- sqldf(string, stringsAsFactors=FALSE)

	 	# Erin lazy, total lbs of ID'd emporers 1987-1989 = 16.0 + 196.0 + 677.5 = 889.5
		emp_80s_newprops <- mutate(emp_80s_3, sp_prop_80s = sp_lbs_80s/889.5)

		# append emps_step4
		emp_80s_append <- data.frame(year_num = 1986, SPECIES_FK = 260, SCIENTIFIC_NAME = "Multi-genera Multi-species",
							TOT_LBS = 118.5, BREAKDOWN_SPECIES_FK = emp_80s_newprops$BREAKDOWN_SPECIES_FK,
							SCIENTIFIC_NAME_PK = emp_80s_newprops$SCIENTIFIC_NAME_PK , sp_prop = emp_80s_newprops$sp_prop_80s)

		emps_step4A <- rbind(emps_step4, emp_80s_append)
		# View(emps_step4A)
		
		string <- "SELECT *
				FROM emps_step4A
				WHERE BREAKDOWN_SPECIES_FK != 'NA'"
		emps_step4B <- sqldf(string, stringsAsFactors=FALSE)
		# View(emps_step4B)	

  	emps_step5 <- mutate(emps_step4B, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(emps_step5)

 # update by_species_update by replacing SPECIES_FK = 260 with emps_step5.BREAKDOWN_SPECIES_FK

 	emps_addin <- data.frame(year_num = emps_step5$year_num,
					SPECIES_FK = emps_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = emps_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = emps_step5$BREAKDOWN_TOT_LBS)
	# View(emps_addin)	# str(emps_addin)		# 133 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK != 260)  # str(by_species_update1) 	# 1927 records
	by_species_update2 <- rbind(by_species_update1, emps_addin)	#  str(by_species_update2)	# 2060 records

 # sum over year x species

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks_emps <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps)		# 1866  without adding 1933 records, we would expect 1927
										# but because we added 6 species that weren't identified in 1986 that means
										# total records = previous steps (1957) - unid emps (30) + 6 new = 1933

#  ------- 4f. BOTTOMFISH 200

 	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks_emps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks_emps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#1933	View(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[8] <- "SCIENTIFIC_NAME_FK"	

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Bottomfishes_200 = 1 and SPECIES_FK != 200
			ORDER BY year_num, SPECIES_FK"
	
	bfish_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step1)

  string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM bfish_step1
			GROUP BY year_num"
	bfish_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step2)

 # merge back

  string <- "SELECT bfish_step1.*, bfish_step2.group_tot
		FROM bfish_step1 LEFT JOIN bfish_step2
			ON bfish_step1.year_num = bfish_step2.year_num"

	bfish_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step3)

	bfish_breakdown <- mutate(bfish_step3, sp_prop = TOT_LBS/group_tot)
	# View(bfish_breakdown)

  bfish_catch <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK == 200)
	str(bfish_catch)		#View(bfish_catch)		#22

 # break-down all un-id records into presumed species 
  	head(bfish_catch)
	head(bfish_breakdown)

 	string <- "SELECT bfish_catch.*, bfish_breakdown.SPECIES_FK, bfish_breakdown.SCIENTIFIC_NAME_PK,  bfish_breakdown.sp_prop
		FROM bfish_catch LEFT JOIN bfish_breakdown
			ON bfish_catch.year_num = bfish_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	bfish_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step4)
	names(bfish_step4)[5] <- "BREAKDOWN_SPECIES_FK"

  	bfish_step5 <- mutate(bfish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(bfish_step5)

 # update by_species_update by replacing SPECIES_FK = 200 with bfish_step5.BREAKDOWN_SPECIES_FK

 	bfish_addin <- data.frame(year_num = bfish_step5$year_num,
					SPECIES_FK = bfish_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = bfish_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = bfish_step5$BREAKDOWN_TOT_LBS)
	# View(bfish_addin)	# str(bfish_addin)		# 669 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK != 200)  # 
			str(by_species_update1) 	# 1911 records
	by_species_update2 <- rbind(by_species_update1, bfish_addin)	#  str(by_species_update2)	#2564 records

 # sum over year x species

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks_emps_bfish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish)		# 1933-22 = 1911


#  ------------------------------ final step: fishes, unknown

	string <- "SELECT *
			FROM by_species_update_PE_snaps_grps_jacks_emps_bfish
			WHERE SPECIES_FK = 100"

	FishNoID <- sqldf(string, stringsAsFactors=FALSE)
	# View(FishNoID)
	# not much non-ID fish, but I'll break it down anyway, just for completeness.

  	string <- "SELECT *
			FROM by_species_update_PE_snaps_grps_jacks_emps_bfish
			WHERE SPECIES_FK != 100
			ORDER BY year_num, SPECIES_FK"

	fish_step1 <- sqldf(string, stringsAsFactors=FALSE)

	# important to rename duplicate column names
	names(fish_step1)[3] <- "SCIENTIFIC_NAME_PK"	

  	string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM fish_step1
			GROUP BY year_num"
	fish_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(fish_step2)

 # merge back

  	string <- "SELECT fish_step1.*, fish_step2.group_tot
		FROM fish_step1 LEFT JOIN fish_step2
			ON fish_step1.year_num = fish_step2.year_num"

	fish_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(fish_step3)

	fish_breakdown <- mutate(fish_step3, sp_prop = TOT_LBS/group_tot)
	# View(fish_breakdown)

  fish_catch <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK == 100)
	# View(fish_catch)		#12

 # break-down all un-id records into presumed species 
  	head(fish_catch)
	head(fish_breakdown)

 	string <- "SELECT fish_catch.*, fish_breakdown.SPECIES_FK, fish_breakdown.SCIENTIFIC_NAME_PK,  fish_breakdown.sp_prop
		FROM fish_catch LEFT JOIN fish_breakdown
			ON fish_catch.year_num = fish_breakdown.year_num 
		ORDER BY year_num, SPECIES_FK"
	fish_step4 <- sqldf(string, stringsAsFactors=FALSE)
	# View(fish_step4)
	names(fish_step4)[5] <- "BREAKDOWN_SPECIES_FK"

  	fish_step5 <- mutate(fish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(fish_step5)

	# NOTE: at this point, we are breaking down "fish" into a few other non-specific groups, including
	#	SPECIES_FK			COMMON_NAME
	#	150				Sharks
	#	160				Rays
	#	300				Unk_reef_fishes
	#	360				Wrasses
	#	383				Triggerfishes
	#	450				Tunas
	#  That is OK, none of these groups are considered to be members of "bottomfish" we won't be dealing with them on the species level anyway

 # update by_species_update by replacing SPECIES_FK = 100 with fish_step5.BREAKDOWN_SPECIES_FK

 	fish_addin <- data.frame(year_num = fish_step5$year_num,
					SPECIES_FK = fish_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = fish_step5$SCIENTIFIC_NAME_PK,
					TOT_LBS = fish_step5$BREAKDOWN_TOT_LBS)
	# View(fish_addin)	# str(fish_addin)		# 524 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps_bfish, SPECIES_FK != 100)  # str(by_species_update1) 	# 1899 records #View(by_species_update1)
	by_species_update2 <- rbind(by_species_update1, fish_addin)	#  str(by_species_update2)	#2423 records

 # sum over year x species

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks_emps_bfish_fish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)		# 1911 - 12 = 1899
	

#  View(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)


#  ---------- end step 4.
#	now we have a table of total catch (lbs) for every year x every species. groups are gone and all have been assigned to species.
#	we can double check that we didn't create or lose any catch during step 4.

	string <- "SELECT year_num, sum(TOT_LBS) as TOT_LBS
			FROM by_species
			GROUP BY year_num"
	before_4 <- sqldf(string, stringsAsFactors=FALSE)			# View(before_4)

	string <- "SELECT year_num, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update_PE_snaps_grps_jacks_emps_bfish_fish
			GROUP BY year_num"
	after_4 <- sqldf(string, stringsAsFactors=FALSE)			# View(after_4)

#	i.e. these 2 tables should be identical


# ---------------
# STEP 5: turn this total break-down catch table into a proportions key that we can use later (i.e. by applying it to expanded landings)

	# "fish" wasn't in John and Brian's original key, add a column for it now.
	group_key_fish <- mutate(group_key, Fish_100 = 1)

	# join break-down catch (step 4) back in with the group_key, so we know which groups each species could belong to.
	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps_bfish_fish.*, group_key_fish.*
		FROM by_species_update_PE_snaps_grps_jacks_emps_bfish_fish
		LEFT JOIN group_key_fish
			ON by_species_update_PE_snaps_grps_jacks_emps_bfish_fish.SPECIES_FK = group_key_fish.SPECIES_PK"

	by_species_w_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_w_codes)		#1899
	
	# important to rename duplicate column names
	names(by_species_w_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(by_species_w_codes)[8] <- "SCIENTIFIC_NAME_FK"	

	# build group sums by year
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
	str(step2)

# any groups that weren't in the group_key table, i.e. sharks, rays, triggerfishes, will have NA in this table. 
#		We don't care about those groups, so just replace NA with 0s now

	step2[is.na(step2)] <- 0
	# View(step2)

# sum groups by year
  string <- "SELECT year_num, sum(Trevally_109_catch) as sum_trevally_109,				
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
		GROUP BY year_num"

	year_sums <- sqldf(string, stringsAsFactors=FALSE)
	str(year_sums)
	# View(year_sums)

  string <- "SELECT step2.year_num, step2.SPECIES_FK, step2.SCIENTIFIC_NAME_PK, 
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
				ON step2.year_num = year_sums.year_num"

	species_proptable <- sqldf(string, stringsAsFactors=FALSE)
	View(species_proptable)
	str(species_proptable)

#  I. Species proptable, pooled over gear and area, is complete. Rename it,
#	clean up workspace, save.

	species_proptable_by_year <- species_proptable				 #  View(species_proptable_by_year)

# rm(list=ls()[1:87]) 
# rm(list=ls()[2:5]) 

#  save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Dec6_Species_PropTables.RData")
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Nov8_Species_PropTable.RData")


#  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------


#  -----------------------------------------------------------------------------------------------------------------------------------------------
#  II. Species proptable BY GEAR AND AREA
#		this is going to be a lot more difficult because there will be missing strata (a lot of them)
#		but I can't imagine the WPSAR review not bringing this up (has already been suggested in workshops).
# 


# ---------------

# Load the pre-processed boat-based creel survey data from workspace. See see 'BBS_data_prep_Oct7_2021.R'
	
	load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")
	ls()

#  ---------------

# Read in the BBS-SBS group key to tell us which species are in which groups

  	group_key <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE/AmSam_BBS-SBS_GroupKey_final.csv",
		header=T, stringsAsFactors=FALSE) 
	# View(group_key)			#str(group_key)

#  For expanded landings, Tutuila includes the banks because 169 of 174 banks trips 1986-2020 land in Tutuila (see extra table).
#	Manu'a landings are not expanded and are assumed to be a census.
#  so, when doing "area" for the species proptable, we want to group Bank_E, Bank_S, Tutuila together. 
#	23 of 25 area 'Unk' interviews were landed in Tutila
#	 1 area NA trip was landed in Tutila. 

# create the 'zone' variable that matches with landings expansion (Tutu or Manu, based on port landed.)
	bbs_4C <- mutate(bbs_3C, zone = AREA_B)
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
# Erin - don't get confused. Here I sum EST_LBS and call it TOT_LBS
#	this is not the same as the interview TOT_LBS from the flatview
#	tail(bbs_3C)

#  also, use only 1986 to 2020 (not 2021)

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT CATCH_PK, year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, EST_LBS
			FROM bbs_4C
			WHERE SPECIES_FK IS NOT '0' AND SPECIES_FK IS NOT 'NULL' AND year_num < 2021) 
		  GROUP BY year_num, SPECIES_FK, FISHING_METHOD, zone, SCIENTIFIC_NAME
			ORDER BY year_num, SPECIES_FK"
	by_species <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species)		# 3,595 rows = species (including groups) x year x gear x zone strata		# View(by_species)

# ---------------
# STEP 2: merge this aggregated catch table to the BBS-SBS group key, this simply adds the group info, left join ensures 
#			nrow(by_species) == nrow(catch_year_codes)

  string <- "SELECT by_species.*, group_key.*
		FROM by_species
		LEFT JOIN group_key
			ON by_species.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3595 rows
	# View(catch_year_codes)
	names(catch_year_codes)
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	


# ---------------
# STEP 4: Break up each group. Yes, step 3 is not here, I didn't feel like renumbering.
#	there's probably a more elegant way to do this
#	code heavily commented for only some groups
#	note it is often wise to check the number of records and make sure we are getting the number we expect

#  ---- 4a. PRISTOPOMOIDES / ETELIS (240)

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Prist_Etelis_240 = 1 and SPECIES_FK != 240
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	PE_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(PE_step1)		# PE_step1 is all year x identified species x gear x area catch that could be Prist. / Etelis.
					#	that is 437 rows = 437 strata

 	 string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM PE_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	PE_step2 <- sqldf(string, stringsAsFactors=FALSE)			#str(PE_step2)
	# View(PE_step2)		# PE_step2 is sum identified Prist/etelis, by year x area x gear = 108 strata

	# join year x identified species x gear x area (PE_step1) to year x gear x area (PE_step2) expect 437 rows
  	string <- "SELECT PE_step1.*, PE_step2.group_tot
		FROM PE_step1 LEFT JOIN PE_step2
			ON PE_step1.year_num = PE_step2.year_num
					AND
				PE_step1.FISHING_METHOD = PE_step2.FISHING_METHOD
					AND
				PE_step1.zone = PE_step2.zone
			"

	PE_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step3)		#str(PE_step3)		#437

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
			# expect_rows <- nrow(PE_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 82

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
		# expect_rows
		# nrow(PE_step4)
		
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
	# View(PE_addin)	# str(PE_addin)	# 82 records
	by_species_update1 <- subset(by_species, SPECIES_FK != 240)  
		# str(by_species_update1) 	# check # records: 3,575 records = 3,595 originally in by_species - 20 that were PE
	by_species_update2 <- rbind(by_species_update1, PE_addin)			
		#str(by_species_update2)	# add back in the 82 records that we just produced via. breakdown = 3575 + 82 = 3,657 records

 # sum over year x species x gear x zone  (because strata that had both ID'd prist/etelis and unid prist/etelis will have some
 #	duplicate species columns.

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE <- sqldf(string, stringsAsFactors=FALSE)		
	str(by_species_update_PE)		# exact number of records to expect is difficult to tell
							# minimum = previous by_species (3,595) - group records (20) = 3,575
							# max would be if we created gear(2) x zone(2) x species(nrow(global_sp_prop)=9) x group_records(20)
							# i.e. (3595-20)+(2*2*9*20) = 4,295
	# nrow(by_species_update_PE)		
	#		# UPDATED NUMBER OF RECORDS = 3,593
	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species$TOT_LBS)
	# after_4a <- sum(by_species_update_PE$TOT_LBS)


#  ------- 4b. INSHORE SNAPPERS AND DEEP SNAPPERS

	#
 	string <- "SELECT by_species_update_PE.*, group_key.*
		FROM by_species_update_PE
		LEFT JOIN group_key
			ON by_species_update_PE.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3593
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

#  NOTE HERE that since all deep_snappers are inshore snappers, we only need to pull species once from the relational table
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Deep_snappers_230 = 1 and SPECIES_FK not in (230, 390)
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	snaps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(snaps_step1)	#str(snaps_step1)		#1168

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
	# View(snaps_step3)			#str(snaps_step3)		#1168

	snaps_breakdown <- mutate(snaps_step3, sp_prop = TOT_LBS/group_tot)
	# View(snaps_breakdown)

  	snaps_catch <- subset(by_species_update_PE, SPECIES_FK == 230 | SPECIES_FK == 390)
	# View(snaps_catch)		#str(snaps_catch) # 24 records

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
	
	# str(snaps_step4)			# 404
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
			# expect_rows <- nrow(snaps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 430

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
		# expect_rows
		# nrow(snaps_step4)
	
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
	# View(snaps_addin)	# str(snaps_addin)	# 430 records
	by_species_update1 <- subset(by_species_update_PE, SPECIES_FK != 230 & SPECIES_FK != 390)  # str(by_species_update1) 	# 3562 records
	by_species_update2 <- rbind(by_species_update1, snaps_addin)	#str(by_species_update2)	#3992 records

 # sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps <- sqldf(string, stringsAsFactors=FALSE)		
	str(by_species_update_PE_snaps)		# 3589

	# make sure catch was neither lost nor generated during the breakdown
	# before_4b <- sum(by_species_update_PE$TOT_LBS)
	# after_4b <- sum(by_species_update_PE_snaps$TOT_LBS)


#  ------- 4c. GROUPERS 210 AND INSHORE GROUPERS 380 


 string <- "SELECT by_species_update_PE_snaps.*, group_key.*
		FROM by_species_update_PE_snaps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 3589 	View(catch_year_codes)
	
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
	# View(grps_step3)			#str(grps_step3)		#494

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
		
	# str(grps_step4)			# 392
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
			# expect_rows <- nrow(grps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 454

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
		# expect_rows
		# nrow(grps_step4)
	
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
	# View(grps_addin)	# str(grps_addin)	# 289 records
	by_species_update1 <- subset(by_species_update_PE_snaps, SPECIES_FK != 210 & SPECIES_FK != 380)  # str(by_species_update1) 	# 1996 records
	by_species_update2 <- rbind(by_species_update1, grps_addin)	#  str(by_species_update2)	#2285 records

 # sum over year x species x gear x zone

  string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps)		# 3564

	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species$TOT_LBS)
	# after_4c <- sum(by_species_update_PE_snaps_grps$TOT_LBS)


#  ------- 4d. TREVALLY 109 AND JACKS 110

 	string <- "SELECT by_species_update_PE_snaps_grps.*, group_key.*
		FROM by_species_update_PE_snaps_grps
		LEFT JOIN group_key
		  ON by_species_update_PE_snaps_grps.SPECIES_FK = group_key.SPECIES_PK"
	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	# str(catch_year_codes)		#3564 	View(catch_year_codes)

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
			# na_strata <- sum(is.na(jacks_step4$sp_prop))			#8 empty / missing strata
			# expect_rows <- nrow(jacks_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 390

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
		# expect_rows
		# nrow(jacks_step4)
	
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
	by_species_update1 <- subset(by_species_update_PE_snaps_grps, SPECIES_FK != 109 & SPECIES_FK != 110)  # str(by_species_update1) 	# 3479 records
	by_species_update2 <- rbind(by_species_update1, jacks_addin)	#  str(by_species_update2)	#3869 records

 	# sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks)		# 3607

	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species_update_PE$TOT_LBS)
	# after_4d <- sum(by_species_update_PE_snaps_grps_jacks$TOT_LBS)

#  -------4e. EMPORERS 260

 	string <- "SELECT by_species_update_PE_snaps_grps_jacks.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		# 3607
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Emporers_260 = 1 and SPECIES_FK != 260
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	emps_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step1)			# 255

  	string <- "SELECT year_num, FISHING_METHOD, zone, sum(TOT_LBS) as group_tot
			FROM emps_step1
			GROUP BY year_num, FISHING_METHOD, zone"
	emps_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step2)			# 70

	# merge back
	string <- "SELECT emps_step1.*, emps_step2.group_tot
		FROM emps_step1 LEFT JOIN emps_step2
			ON emps_step1.year_num = emps_step2.year_num
				  AND
				emps_step1.FISHING_METHOD = emps_step2.FISHING_METHOD
				  AND
				emps_step1.zone = emps_step2.zone"
	emps_step3 <- sqldf(string, stringsAsFactors=FALSE)
	# str(emps_step3)			# 255

	emps_breakdown <- mutate(emps_step3, sp_prop = TOT_LBS/group_tot)
	# View(emps_breakdown)

  	emps_catch <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK == 260)
	# str(emps_catch)	#View(emps_catch)		#84

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
	# str(emps_step4)				# 215		# View(emps_step4)
	
	names(emps_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(emps_step4)[9] <- "FISHING_METHOD_FK"
	names(emps_step4)[10] <- "zone_FK"


	# ---  DEAL WITH MISSING STRATA: SEE NOTES IN PRIST / ETELIS ABOVE

		# Calculate the global average sp_prop (i.e. for year + gear + zone)	
		string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME_PK, sum(sp_prop) as global_sp_prop
				FROM emps_breakdown
				GROUP BY SPECIES_FK"
		global_sp_prop <- sqldf(string, stringsAsFactors=FALSE)		#View(global_sp_prop)

		n_strata <- sum(as.numeric(global_sp_prop$global_sp_prop))		#70 strata
		global_sp_prop <- mutate(global_sp_prop, sp_prop = global_sp_prop / n_strata)		# scale back to 1

			# what we expect is about to happen:
			# na_strata <- sum(is.na(emps_step4$sp_prop))			#31 empty / missing strata
			# expect_rows <- nrow(emps_step4) - na_strata + (na_strata*nrow(global_sp_prop))		#expect 587

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
		# expect_rows
		# nrow(emps_step4)
	
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
	# View(emps_addin)	# str(emps_addin)		# 587 records
	
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks, SPECIES_FK != 260)  # str(by_species_update1) 	# 3523 records
	by_species_update2 <- rbind(by_species_update1, emps_addin)	#  str(by_species_update2)	# 4110 records

 	# sum over year x species x gear x zone
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	by_species_update_PE_snaps_grps_jacks_emps <- sqldf(string, stringsAsFactors=FALSE)

	str(by_species_update_PE_snaps_grps_jacks_emps)		# 3926

	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species$TOT_LBS)
	# after_4e <- sum(by_species_update_PE_snaps_grps_jacks_emps$TOT_LBS)

#  ------- 4f. BOTTOMFISH 200

 	string <- "SELECT by_species_update_PE_snaps_grps_jacks_emps.*, group_key.*
		FROM by_species_update_PE_snaps_grps_jacks_emps
		LEFT JOIN group_key
			ON by_species_update_PE_snaps_grps_jacks_emps.SPECIES_FK = group_key.SPECIES_PK"

	catch_year_codes <- sqldf(string, stringsAsFactors=FALSE)
	str(catch_year_codes)		#3926
	
	# important to rename duplicate column names
	names(catch_year_codes)[3] <- "SCIENTIFIC_NAME_PK"
	names(catch_year_codes)[10] <- "SCIENTIFIC_NAME_FK"	

	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, TOT_LBS
			FROM catch_year_codes
			WHERE Bottomfishes_200 = 1 and SPECIES_FK != 200
			ORDER BY year_num, SPECIES_FK, FISHING_METHOD, zone"
	
	bfish_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(bfish_step1)		# str(bfish_step1)		#2905

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
	# View(bfish_step3)		# str(bfish_step3)		#2905

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
	
	# str(bfish_step4)			# 931
	names(bfish_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(bfish_step4)[9] <- "FISHING_METHOD_FK"
	names(bfish_step4)[10] <- "zone_FK"

	# ---  THERE ARE NO MISSING BOTTOMFISH STRATA

	# na_strata <- sum(is.na(bfish_step4$sp_prop))			#0 empty / missing strata
	#	no need to modify bfish_step4
	
  	bfish_step5 <- mutate(bfish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)		#View(bfish_step5)
	# str(bfish_step5)			# 931	

	# update by_species_update by replacing SPECIES_FK = 200 with bfish_step5.BREAKDOWN_SPECIES_FK

 	bfish_addin <- data.frame(year_num = bfish_step5$year_num,
					SPECIES_FK = bfish_step5$BREAKDOWN_SPECIES_FK,
					SCIENTIFIC_NAME = bfish_step5$SCIENTIFIC_NAME_PK,
					FISHING_METHOD = bfish_step5$FISHING_METHOD,
					zone = bfish_step5$zone,
					TOT_LBS = bfish_step5$BREAKDOWN_TOT_LBS)
	# View(bfish_addin)	# str(bfish_addin)		# 931 records
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps, SPECIES_FK != 200)  # 
			str(by_species_update1) 	# 3887 records
	by_species_update2 <- rbind(by_species_update1, bfish_addin)	#  str(by_species_update2)	#4818 records

 	# sum over year x species x gear x zone
	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	
	by_species_update_PE_snaps_grps_jacks_emps_bfish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish)		# 3887

	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species$TOT_LBS)
	# after_4f <- sum(by_species_update_PE_snaps_grps_jacks_emps_bfish$TOT_LBS)



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
	# str(catch_year_codes)		#3887 	View(catch_year_codes)

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
	# View(fish_step3)		# str(fish_step3)		# 3867

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

	# str(fish_step4)			# 567
	names(fish_step4)[7] <- "BREAKDOWN_SPECIES_FK"			#again, avoid duplicate column names
	names(fish_step4)[9] <- "FISHING_METHOD_FK"
	names(fish_step4)[10] <- "zone_FK"

		# ---  THERE ARE NO MISSING FISH STRATA

		# na_strata <- sum(is.na(fish_step4$sp_prop))			#0 empty / missing strata
		#	no need to modify fish_step4
	
  	fish_step5 <- mutate(fish_step4, BREAKDOWN_TOT_LBS = TOT_LBS * sp_prop)
	# View(fish_step5)			#str(fish_step5)			# 567

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
	# View(fish_addin)	# str(fish_addin)		# 567 records this is a big number because every time unidentified fish showed up in a strata, we
									# added a tiny amount of many new species
	by_species_update1 <- subset(by_species_update_PE_snaps_grps_jacks_emps_bfish, SPECIES_FK != 100)  # str(by_species_update1) 	# 3870 records #View(by_species_update1)
	by_species_update2 <- rbind(by_species_update1, fish_addin)	#  str(by_species_update2)	#4437 records

 	# sum over year x species x gear x zone

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME, FISHING_METHOD, zone, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update2
			GROUP BY year_num, FISHING_METHOD, zone, SPECIES_FK"
	by_species_update_PE_snaps_grps_jacks_emps_bfish_fish <- sqldf(string, stringsAsFactors=FALSE)
	str(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)		# 3870  # View(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish)
	

	# make sure catch was neither lost nor generated during the breakdown
	# before_4 <- sum(by_species$TOT_LBS)
	# final <- sum(by_species_update_PE_snaps_grps_jacks_emps_bfish_fish$TOT_LBS)

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
	str(by_species_w_codes)		#3870				# View(by_species_w_codes)
	
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
	str(step2)			#View(step2)			# 3870


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
	View(species_proptable)
	str(species_proptable)

#  II. Species proptable, by year x gear x zone, is complete. Rename it,
#	clean up workspace, save.

	species_proptable_by_year_gear_zone <- species_proptable				 #  View(species_proptable_by_year)

# rm(list=ls()[1:84]) 
# rm(list=ls()[2:5]) 

#  save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Dec9_Species_PropTables.RData")
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Dec9_Species_PropTables.RData")


# make a .csv to check out in excel
#	write.csv(species_proptable_by_year_gear_zone, "species_proptable_by_year_gear_zone.csv")


# I looked at this carefully in Excel (see species_proptable_by_year_gear_zone_scratchwork.xls)
#	within each strata (gear x year x area) and group (trevallies, bottomfishes, fish, etc.)
#		 all species props will sum to 1 (as is expected) or to zero (if the gear x year x area x group and all
#			member species of that group were absent from the data).
# So, simply replace these weird NAs with 0s.

proptable2 <- species_proptable_by_year_gear_zone
proptable2[is.na(proptable2)] <- 0 					# View(proptable2)			#str(proptable2)		#

	# simplify: select BMUS only and eliminate duplicate group columns

		string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, FISHING_METHOD, zone, prop_prist_et_240, 
					prop_deep_snappers_230, prop_groupers_210, prop_trevally_109, prop_emporers_260,
					prop_bfishes_200,prop_fish_100
			FROM proptable2 
			WHERE SPECIES_FK in ('247','239','111','248','249','267','231','241','242','245','229')
			ORDER BY SPECIES_FK, year_num
			"
		proptable_bmus <- sqldf(string, stringsAsFactors=FALSE)			#str(proptable_bmus)		#View(proptable_bmus)


	# how many strata did we have in BBS? (year x area x species)
			string <- "SELECT DISTINCT year_num, FISHING_METHOD, zone		
					FROM proptable2 
			"
		n_strata <- sqldf(string, stringsAsFactors=FALSE)		#str(n_strata)		
				#if we had BBS for all strata, we would have 35*2*2 = 140


#  make sure we have zeros for all bmus x method x zone x year (so far we only have 957 rows)

		species_year <- data.frame(year_num = rep(seq(1986, 2020, 1),11), 
			
			SCIENTIFIC_NAME_PK = c(rep('Aphareus rutilans',35),rep('Aprion virescens',35),
			rep('Caranx lugubris',35),rep('Etelis coruscans',35),rep('Etelis carbunculus',35),
			rep('Lethrinus rubrioperculatus',35),rep('Lutjanus kasmira',35),rep('Pristipomoides flavipinnis',35),
			rep('Pristipomoides filamentosus',35),rep('Pristipomoides zonatus',35),rep('Variola louti',35)),
			
			SPECIES_FK = c(rep('247',35),rep('239',35),
			rep('111',35),rep('248',35),rep('249',35),
			rep('267',35),rep('231',35),rep('241',35),
			rep('242',35),rep('245',35),rep('229',35)))

		species_year2a <- mutate(species_year, FISHING_METHOD = 'BOTTOMFISHING', zone = 'Tutuila')
		species_year2b <- mutate(species_year, FISHING_METHOD = 'BOTTOMFISHING', zone = 'Manua')
		species_year2c <- mutate(species_year, FISHING_METHOD = 'BTM/TRL MIX', zone = 'Tutuila')
		species_year2d <- mutate(species_year, FISHING_METHOD = 'BTM/TRL MIX', zone = 'Manua')

		species_year2 <- rbind(species_year2a,species_year2b,species_year2c,species_year2d)
		str(species_year2)			#  35 years x 11 species x 2 areas x 2 gears = 1540 

		temp5 <- merge(x = species_year2, y = proptable_bmus, by = c('year_num','SPECIES_FK','SCIENTIFIC_NAME_PK','FISHING_METHOD','zone') , all.x = TRUE)
		str(temp5)			#View(temp5)
		temp5[is.na(temp5)] <- 0 
		proptable_bmus <- temp5


	# test: sum props to make sure we don't overwrite any data with NAs in next step
	test_pre <- sum(proptable_bmus[,c(6:12)])

	#  the only way to make this look pretty is to replace 0 with NA in groups where species are never members
	#	just hardcode because faster

	# lugubris 111 cannot be 
	proptable_bmus$prop_groupers_210[proptable_bmus$SPECIES_FK == 111] <- NA
	proptable_bmus$prop_prist_et_240[proptable_bmus$SPECIES_FK == 111] <- NA
	proptable_bmus$prop_deep_snappers_230[proptable_bmus$SPECIES_FK == 111] <- NA
	proptable_bmus$prop_emporers_260[proptable_bmus$SPECIES_FK == 111] <- NA

	# louti 229 cannot be
	proptable_bmus$prop_prist_et_240[proptable_bmus$SPECIES_FK == 229] <- NA
	proptable_bmus$prop_deep_snappers_230[proptable_bmus$SPECIES_FK == 229] <- NA
	proptable_bmus$prop_trevally_109[proptable_bmus$SPECIES_FK == 229] <- NA
	proptable_bmus$prop_emporers_260[proptable_bmus$SPECIES_FK == 229] <- NA

	# kasmira 231, virescens 239, rutilans 247 cannot be
	proptable_bmus$prop_prist_et_240[proptable_bmus$SPECIES_FK == 231 | proptable_bmus$SPECIES_FK == 239 | proptable_bmus$SPECIES_FK == 247] <- NA
	proptable_bmus$prop_groupers_210[proptable_bmus$SPECIES_FK == 231 | proptable_bmus$SPECIES_FK == 239 | proptable_bmus$SPECIES_FK == 247] <- NA
	proptable_bmus$prop_trevally_109[proptable_bmus$SPECIES_FK == 231 | proptable_bmus$SPECIES_FK == 239 | proptable_bmus$SPECIES_FK == 247] <- NA
	proptable_bmus$prop_emporers_260[proptable_bmus$SPECIES_FK == 231 | proptable_bmus$SPECIES_FK == 239 | proptable_bmus$SPECIES_FK == 247] <- NA

	# carbunculus 249, flavipinnis 241, filamentosus 242, zonatus 245, coruscans 248
	proptable_bmus$prop_groupers_210[proptable_bmus$SPECIES_FK == 249 | proptable_bmus$SPECIES_FK == 241 | 
						proptable_bmus$SPECIES_FK == 242 | proptable_bmus$SPECIES_FK == 245 |
						proptable_bmus$SPECIES_FK == 248] <- NA
	proptable_bmus$prop_trevally_109[proptable_bmus$SPECIES_FK == 249 | proptable_bmus$SPECIES_FK == 241 | 
						proptable_bmus$SPECIES_FK == 242 | proptable_bmus$SPECIES_FK == 245 |
						proptable_bmus$SPECIES_FK == 248] <- NA
	proptable_bmus$prop_emporers_260[proptable_bmus$SPECIES_FK == 249 | proptable_bmus$SPECIES_FK == 241 | 
						proptable_bmus$SPECIES_FK == 242 | proptable_bmus$SPECIES_FK == 245 |
						proptable_bmus$SPECIES_FK == 248] <- NA

	# rubrioperculatus 267
	proptable_bmus$prop_groupers_210[proptable_bmus$SPECIES_FK == 267] <- NA
	proptable_bmus$prop_prist_et_240[proptable_bmus$SPECIES_FK == 267] <- NA
	proptable_bmus$prop_deep_snappers_230[proptable_bmus$SPECIES_FK == 267] <- NA
	proptable_bmus$prop_trevally_109[proptable_bmus$SPECIES_FK == 267] <- NA

	test_post <- sum(proptable_bmus[,c(6:12)], na.rm=TRUE)
	test_pre == test_post

	# save this
	proptable_bmus_final <- proptable_bmus


	#View(proptable_bmus_final)


	# -----------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------
	#  Make some figures to show raw props

	source('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/LOAD_theme.R')

	# install.packages('ggrepel')
	library(ggrepel)

	# ticks and tick_height always same
	ticks <- seq(1985,2020,5)
	tick_height <- 1/40

	# make a plot index to go through all groups
	breakdown_groups <- c('prop_prist_et_240', 'prop_deep_snappers_230', 'prop_groupers_210',
				'prop_trevally_109','prop_emporers_260','prop_bfishes_200','prop_fish_100')
	names(breakdown_groups) <- c('Pristipomoides / Etelis', 'Snappers', 'Groupers',
				'Jacks / Trevallies','Emporers','Bottomfishes','Fishes')
	


	# define zone and gear we are using
	plot_zone <- 'Tutuila'
	plot_gear <- 'BOTTOMFISHING'

	for (i in 1: length(breakdown_groups)) {
		plot_me <- subset(proptable_bmus, zone == plot_zone & FISHING_METHOD == plot_gear)			#str(plot_me)
		plot_me_simple <- data.frame(year = plot_me$year_num, species = plot_me$SCIENTIFIC_NAME_PK, 
			group = plot_me[,breakdown_groups[i]]  )				# head(plot_me_simple)

		plot_me_simple <- mutate(plot_me_simple, label = if_else(year == max(year), as.character(species), NA_character_))
			# View(plot_me_simple)

		assign(paste("p_",i,sep=""),
			ggplot(data=plot_me_simple, aes(color=species,linetype=species, x=year,y=group)) +
			# geom_point(stat="identity", size=1, shape = 19) +
			geom_line(stat="identity") +
			scale_color_manual(values=species.colors) +
			scale_linetype_manual(values=species.linetypes) +
			geom_text_repel(aes(label = label),nudge_x = 1, na.rm = TRUE, force = 5) +
			theme_datareport_size_comp() +
			# theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top") +
			geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
			# geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
			# geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
			scale_x_continuous(breaks=ticks) +
			# geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
			# geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
			# geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
			# geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 			geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 			geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 		theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 		theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
				labs(y="", x="", caption="", title = names(breakdown_groups)[i])
	   		)
		}

	grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
	grob_ylab <- textGrob("Prop Identified Catch", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)
#	grob_title <- textGrob("Tutuila, Bottomfishing", gp=gpar(fontsize=12), 
#		hjust = "centre", vjust = "top")

	setwd('C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE')


 	png(file="raw_props_tutu_bottom_1_4.png",width=6.5, height=10, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3),p_4+expand_pretty_y(p_4),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()

 	png(file="raw_props_tutu_bottom_5_7.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6), p_7+expand_pretty_y(p_7),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


	# define zone and gear we are using
	plot_zone <- 'Manua'
	plot_gear <- 'BOTTOMFISHING'

	for (i in 1: length(breakdown_groups)) {
		plot_me <- subset(proptable_bmus, zone == plot_zone & FISHING_METHOD == plot_gear)			#str(plot_me)
		plot_me_simple <- data.frame(year = plot_me$year_num, species = plot_me$SCIENTIFIC_NAME_PK, 
			group = plot_me[,breakdown_groups[i]]  )				# head(plot_me_simple)

		plot_me_simple <- mutate(plot_me_simple, label = if_else(year == max(year), as.character(species), NA_character_))
			# View(plot_me_simple)

		assign(paste("p_",i,sep=""),
			ggplot(data=plot_me_simple, aes(color=species,linetype=species, x=year,y=group)) +
			geom_line(stat="identity") +
			scale_color_manual(values=species.colors) +
			scale_linetype_manual(values=species.linetypes) +
			geom_text_repel(aes(label = label),nudge_x = 1, na.rm = TRUE, force = 5) +
			theme_datareport_size_comp() +
			geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
			scale_x_continuous(breaks=ticks) +
 			geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 			geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 		theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 		theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
				labs(y="", x="", caption="", title = names(breakdown_groups)[i])
	   		)
		}

	grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
	grob_ylab <- textGrob("Prop Identified Catch", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)


 	png(file="raw_props_manu_bottom_1_4.png",width=6.5, height=10, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3),p_4+expand_pretty_y(p_4),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()

 	png(file="raw_props_manu_bottom_5_7.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6), p_7+expand_pretty_y(p_7),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()




	# define zone and gear we are using
	plot_zone <- 'Manua'
	plot_gear <- 'BTM/TRL MIX'

	for (i in 1: length(breakdown_groups)) {
		plot_me <- subset(proptable_bmus, zone == plot_zone & FISHING_METHOD == plot_gear)			#str(plot_me)
		plot_me_simple <- data.frame(year = plot_me$year_num, species = plot_me$SCIENTIFIC_NAME_PK, 
			group = plot_me[,breakdown_groups[i]]  )				# head(plot_me_simple)

		plot_me_simple <- mutate(plot_me_simple, label = if_else(year == max(year), as.character(species), NA_character_))
			# View(plot_me_simple)

		assign(paste("p_",i,sep=""),
			ggplot(data=plot_me_simple, aes(color=species,linetype=species, x=year,y=group)) +
			geom_line(stat="identity") +
			scale_color_manual(values=species.colors) +
			scale_linetype_manual(values=species.linetypes) +
			geom_text_repel(aes(label = label),nudge_x = 1, na.rm = TRUE, force = 5) +
			theme_datareport_size_comp() +
			geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
			scale_x_continuous(breaks=ticks) +
 			geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 			geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 		theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 		theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
				labs(y="", x="", caption="", title = names(breakdown_groups)[i])
	   		)
		}

	grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
	grob_ylab <- textGrob("Prop Identified Catch", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)


 	png(file="raw_props_manu_mix_1_4.png",width=6.5, height=10, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3),p_4+expand_pretty_y(p_4),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()

 	png(file="raw_props_manu_mix_5_7.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6), p_7+expand_pretty_y(p_7),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()



	# define zone and gear we are using
	plot_zone <- 'Tutuila'
	plot_gear <- 'BTM/TRL MIX'

	for (i in 1: length(breakdown_groups)) {
		plot_me <- subset(proptable_bmus, zone == plot_zone & FISHING_METHOD == plot_gear)			#str(plot_me)
		plot_me_simple <- data.frame(year = plot_me$year_num, species = plot_me$SCIENTIFIC_NAME_PK, 
			group = plot_me[,breakdown_groups[i]]  )				# head(plot_me_simple)

		plot_me_simple <- mutate(plot_me_simple, label = if_else(year == max(year), as.character(species), NA_character_))
			# View(plot_me_simple)

		assign(paste("p_",i,sep=""),
			ggplot(data=plot_me_simple, aes(color=species,linetype=species, x=year,y=group)) +
			geom_line(stat="identity") +
			scale_color_manual(values=species.colors) +
			scale_linetype_manual(values=species.linetypes) +
			geom_text_repel(aes(label = label),nudge_x = 1, na.rm = TRUE, force = 5) +
			theme_datareport_size_comp() +
			geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
			scale_x_continuous(breaks=ticks) +
 			geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 			geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
			geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 		theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 		theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
				labs(y="", x="", caption="", title = names(breakdown_groups)[i])
	   		)
		}

	grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
	grob_ylab <- textGrob("Prop Identified Catch", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)


 	png(file="raw_props_tutu_mix_1_4.png",width=6.5, height=10, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3),p_4+expand_pretty_y(p_4),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()

 	png(file="raw_props_tutu_mix_5_7.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6), p_7+expand_pretty_y(p_7),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()




#  make a smoothed bmus proptable
#  moving average, plus 2 years and minus 2 years


View(proptable_bmus)

try1 <- subset(proptable_bmus, zone == 'Tutuila' & FISHING_METHOD == 'BOTTOMFISHING' & SPECIES_FK == 111)
View(try1)

x <- 1:10

ma <- function(x, n = 5){filter(x, rep(1 / n, n), sides = 2)}


x2 <- filter(x, rep(1, 5), size=2, method = "convolution")

x2 <- stats::filter(x, rep(1/5, 5))














p2 <-	 ggplot(data=plot_me, aes(color=SCIENTIFIC_NAME_PK, x=year_num,y=prop_groupers_210)) +
		geom_point(stat="identity", size=1, shape = 19) +
		scale_color_manual(values=species.colors) +
		geom_line(stat="identity") +
		scale_linetype_manual(values=species.linetypes) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
		geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
		scale_x_continuous(breaks=ticks) +
		geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = "Groupers")
	  



p3 <-	 ggplot(data=plot_me, aes(color=SCIENTIFIC_NAME_PK, x=year_num,y=prop_deep_snappers_230)) +
		geom_point(stat="identity", size=1, shape = 19) +
		scale_color_manual(values=species.colors) +
		geom_line(stat="identity") +
		scale_linetype_manual(values=species.linetypes) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
		geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
		scale_x_continuous(breaks=ticks) +
		scale_y_continuous(limits = c(0,1)) +
		geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = "Snappers")
	  

prop_bfishes_200


p4 <-	 ggplot(data=plot_me, aes(color=SCIENTIFIC_NAME_PK, x=year_num,y=prop_bfishes_200)) +
		geom_point(stat="identity", size=1, shape = 19) +
		scale_color_manual(values=species.colors) +
		geom_line(stat="identity") +
		scale_linetype_manual(values=species.linetypes) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
		geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
		scale_x_continuous(breaks=ticks) +
		scale_y_continuous(limits = c(0,1)) +
		geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = "Bottomfishes")
	  
p5 <-	 ggplot(data=plot_me, aes(color=SCIENTIFIC_NAME_PK, x=year_num,y=prop_prist_et_240)) +
		geom_point(stat="identity", size=1, shape = 19) +
		scale_color_manual(values=species.colors) +
		geom_line(stat="identity") +
		scale_linetype_manual(values=species.linetypes) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
		geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
		scale_x_continuous(breaks=ticks) +
		scale_y_continuous(limits = c(0,1)) +
		geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = "Pristipomoides / Etelis spp.")

  
p6 <-	 ggplot(data=plot_me, aes(color=SCIENTIFIC_NAME_PK, x=year_num,y=prop_fish_100)) +
		geom_point(stat="identity", size=1, shape = 19) +
		scale_color_manual(values=species.colors) +
		geom_line(stat="identity") +
		scale_linetype_manual(values=species.linetypes) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color = "black") +
		geom_segment(y=0,yend=1,x=1985,xend=1985, color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
		scale_x_continuous(breaks=ticks) +
		scale_y_continuous(limits = c(0,1)) +
		geom_segment(y=0.25,yend=0.25,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.5,yend=0.5,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=0.75,yend=0.75,x=1984.5,xend=1985, color = "black") +
		geom_segment(y=1,yend=1,x=1984.5,xend=1985, color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1], color = "black") +
 		geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7], color = "black") +
		geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8], color = "black") +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = "Fish")






























#  ------------------------------------------------------------------------------------------------------
#  --------- extra questions:
#	how many species are identified by year??



  string <- "SELECT year_num, count(SPECIES_FK) as num_species
			FROM 
			( SELECT DISTINCT year_num, SPECIES_FK
				FROM bbs_3C 
				WHERE SCIENTIFIC_NAME not in ('Multi-genera Multi-species'))
			GROUP BY year_num"
	
	sp_per_year <- sqldf(string, stringsAsFactors=FALSE)




























#  -----------------------------------------------------------------------------------------------------------------------------------------------
















































##  -----------------------------------------------------------------------------------------------------------------------------------------------
