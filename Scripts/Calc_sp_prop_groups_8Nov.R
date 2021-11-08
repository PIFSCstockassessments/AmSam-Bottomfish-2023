##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#	Erin Bohaboy erin.bohaboy@noaa.gov
# 	this script builds off the code written by John Syslo / Brian(?) for the 2019 AmSam Bottomfish assessment


#		Erin likes to code in sql, which is goofy in R, but needs must
#			A lot of the sql-type base R code is here because that is what Brian/John use

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
#		to break-down any groups to species.
#

#  -----------------------------------------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  	library(tidyr)
 
#  Load workspace produced by initial data analysis
#	see 'BBS_data_prep_Oct7_2021.R'

load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")
ls()

#  -----------------------------------------------------------------------------------------------------------------------------------------------

# ---------------
# STEP 1: Generate bbs_3C. (see seperate script)

# ---------------
# STEP 2:  Reduce bbs_3C back down to a simple "catch" table. i.e. sum by species and year. 
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
# STEP 3: Read-in and merge the BBS-SBS group key to tell us which species are in which groups
#	Brian and John made this table for the 2019 bottomfish assessment. It lists every species in BBS
#	and according to a set of rules tell us if the species could (1) or could not (0) be a member of
#	of each of the unknown species groups Trevally 109, Jacks 110, Bottomfishes 200, etc.
#	see page 29 of the 2019 assessment. In general, species were assigned by families, with a few exceptions.
#	For example, for Carangidae, scads (genera Decapterus, Selar, and Selaroides) were not considered possible BMUS, 
#		but other carangids were.

  group_key <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE/AmSam_BBS-SBS_GroupKey_final.csv",
		header=T, stringsAsFactors=FALSE) 
	# View(group_key)

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
# STEP 4: Break up each group
#	there's probably a more elegant way to do this
#	code heavily commented for only some groups

#  ---- 4a. PRISTOPOMOIDES / ETELIS (240)

  	string <- "SELECT year_num, SPECIES_FK, SCIENTIFIC_NAME_PK, TOT_LBS
			FROM catch_year_codes
			WHERE Prist_Etelis_240 = 1 and SPECIES_FK != 240
			ORDER BY year_num, SPECIES_FK"
	
	PE_step1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step1)		# PE_step1 is all year x species catch that could be Prist. / Etelis.

 	 string <- "SELECT year_num, sum(TOT_LBS) as group_tot
			FROM PE_step1
			GROUP BY year_num"
	PE_step2 <- sqldf(string, stringsAsFactors=FALSE)
	# View(PE_step2)		# PE_step2 is all catch, by year, that could be Prist. / Etelis.

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
		View(emps_step4A)
		
		string <- "SELECT *
				FROM emps_step4A
				WHERE BREAKDOWN_SPECIES_FK != 'NA'"
		emps_step4B <- sqldf(string, stringsAsFactors=FALSE)
		View(emps_step4B)	

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
	View(fish_catch)		#12

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
	before_4 <- sqldf(string, stringsAsFactors=FALSE)

	string <- "SELECT year_num, sum(TOT_LBS) as TOT_LBS
			FROM by_species_update_PE_snaps_grps_jacks_emps_bfish_fish
			GROUP BY year_num"
	after_4 <- sqldf(string, stringsAsFactors=FALSE)

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

# --------------- FIN  
# 	species_proptable is the key that we will use to breakdown species groups
#	clean up workspace, save.

# rm(list=ls()[1:87]) 
#  save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Nov8_Calc_Species_Props_Complete_Workspace.RData")
#  save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\CPUE\\Nov8_Species_PropTable.RData")

































#  -----------------------------------------------------------------------------------------------------------------------------------------------























