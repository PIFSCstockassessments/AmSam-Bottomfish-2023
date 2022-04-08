#  -----------------------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA LANDINGS (shore-based): 
#	Expanded shore-based landings estimates provided by Toby 17Feb, 2022
#     -Correct for species ID errors in Variola. 
#	-Break-down unidentified species groups (groupers, emperors, jacks, sometimes accounts for high catch)
#		species_proptable based on shore-based creel survey. See 01_SBS_data_prep.R
#   ----------------------------------------------------------------------------------------------------------------------------
#   
#   Erin Bohaboy erin.bohaboy@noaa.gov
#	
#  --------------------------------------------------------------------------------------------------------------

  #  PRELIMINARIES
 # rm(list=ls())
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

# ----------------------------------
  # Read in the expanded landings data
 
  sp_data <- read.csv(paste(root_dir, "/data/SPC_AS_SBS.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  #sp_data <- read.csv(paste(root_dir, "/Data/SPC_AS_SBS.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  
  # str(sp_data)			# 6336 obs


# ----------------------------------

  # follow Toby's instructions to break the unique key SPC_PK into the interview details we need
  #	watch out- this is a little different from the BBS. See "american samoa SB mysql formulas.docx":
  #		SPC_PK: The private key associated with a particular species catch expansion. 
  #		Consists of 14 characters of the form rryyCYPdmmssss, determined as:
  #			(1,2) rr: Two digits for ROUTE_FK, with leading zeros if necessary
  #			(3,4) yy: Two digits for YEAR, calculated as the number of years after 1947
  #			(5,6) CY: 
  #			(7) P: A single capital letter for the time period (AM_PM), either ?D? for day or ?N? for night
  #			(8) d: A single digit for TYPE_OF_DAY, either 1 for weekday or 2 for weekend/holiday
  #			(9,10) mm: Two digits for METHOD_FK, with leading zeros if necessary
  #			(11,14) ssss: Four digits for SPECIES_FK, with leading zeros if necessary

  #  note that shore-based expansion domains are route x year x day/night x WE/WD x gear

  sp_data2 <- mutate(sp_data, year_raw = as.numeric(substr(SPC_PK,3,4)), method = substr(SPC_PK,9,10), 
					route = substr(SPC_PK,1,2), type = substr(SPC_PK,8,8), 
				# SPECIES_FK = substr(SPC_PK,11,14), 
					daynight = substr(SPC_PK,7,7))
  head(sp_data2)
  sp_data2 <- mutate(sp_data2, year = year_raw + 1947)
  str(sp_data2)			# 6336 records		# View(sp_data2)		
  #sum(sp_data$EXP_LBS, na.rm=TRUE)		#1,653,081 is total exapanded landings, all species, all years, and should be conserved

  # fix P. rutilans
  sp_data2$SPECIES_FK[sp_data2$SPECIES_FK==243]<-241

  # add species names and simplify gears and routes
  sp_data2$route <- as.numeric(sp_data2$route)
  sp_data2$method <- as.numeric(sp_data2$method)
  sp_data2[is.na(sp_data2)] <- 0

  a_routes <- read.csv(paste(root_dir, "/data/sb_route_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # View(a_routes)	#str(a_routes)
  a_method <- read.csv(paste(root_dir, "/data/sb_gear_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # str(a_method)

  string <- "SELECT sp_data2.*, a_method.FISHING_METHOD, a_method.gear_simple
		FROM sp_data2
		LEFT JOIN a_method
			ON sp_data2.method = a_method.method_fk"
  sp_data3 <- sqldf(string, stringsAsFactors=FALSE)
  str(sp_data3)				# 6336 obs

  string <- "SELECT sp_data3.*, a_routes.route_simple, a_routes.area_super_simple
		FROM sp_data3
		LEFT JOIN a_routes
			ON sp_data3.route = a_routes.route"
  sp_data4 <- sqldf(string, stringsAsFactors=FALSE)
  str(sp_data4)				# 6336 obs

  names_key <- read.csv(paste(root_dir, "/data/all_species_names.csv", sep=""), header=T, stringsAsFactors=FALSE) 

  string <- "SELECT sp_data4.*, names_key.SCIENTIFIC_NAME, names_key.COMMON_NAME
		FROM sp_data4
		LEFT JOIN names_key ON
			sp_data4.SPECIES_FK = names_key.SPECIES_FK
		"
  sp_data5 <- sqldf(string, stringsAsFactors=FALSE)		# str(sp_data5)		#  View(sp_data5)		#sum(sp_data5$EXP_LBS)

  # save this
  sbs_expanded_landings_preliminary_01 <- sp_data5			

  # str(sp_data5)

# ----------------------------------
  # Correct Variola ID errors
 
# rename duplicate group SPECIES_FK in cases of complete union:
	# Jacks (110) and Trevally (109)
	# Groupers (210) and Inshore groupers (380)
	# Deep snappers (230) and Inshore snappers (390)
	sp_data5$SPECIES_FK[sp_data5$SPECIES_FK == 109] <- 110
	sp_data5$SPECIES_FK[sp_data5$SPECIES_FK == 380] <- 210
	sp_data5$SPECIES_FK[sp_data5$SPECIES_FK == 390] <- 230

  names(sp_data5)[31] <- 'zone'

  #  by year and zone, summed by day/night, WE/WD, gear
  string <- "SELECT year, SPECIES_FK, SCIENTIFIC_NAME, zone, sum(EXP_LBS) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT 
			FROM sp_data5
			GROUP BY SPECIES_FK, year, zone"
  sp_data6 <- sqldf(string, stringsAsFactors=FALSE)
  #str(sp_data6)			#2071 		#sum(sp_data6$LBS_CAUGHT)

  # save a copy	
  sbs_expanded_landings_basic_02 <- sp_data6

  # load in the species proptable and ID corrections
  load(paste(root_dir, "/output/01_SBS_data_prep.RData", sep=""))				#View(sbs_proptable)
  #load(paste(root_dir, "/Outputs/01_SBS_data_prep.RData", sep=""))				#View(sbs_proptable)
  
  
  # ------------------
  # Variola: for 1990-2015, sum albimarginata, louti, partician back to species

    # remove Variola (needing correction) landings
   	string <- "SELECT *
				FROM  sp_data6
				WHERE SPECIES_FK in (220, 229) AND year < 2016"
	correct_me <- sqldf(string, stringsAsFactors=FALSE)				#str(correct_me)			#9 records
	correct_me[is.na(correct_me)] <- 0

    # use delete query to remove these records from sp_data6	
      sp_data6B <- sqldf(c("DELETE FROM sp_data6 WHERE SPECIES_FK in (220, 229) AND year < 2016", "SELECT * FROM sp_data6"))
	# note, running a DELETE query in sqldf will always throw a warning. ignore.
	# str(sp_data6B)			# 2062 obs	
	# TEST	# sum(sp_data6B$LBS_CAUGHT, na.rm = TRUE) + sum(correct_me$LBS_CAUGHT)

   # for "correct_me", sum louti and albimarginata lbs and variance by strata (year)
	string <- "SELECT year, zone, sum(LBS_CAUGHT) as sum_lbs, sum(VAR_LBS_CAUGHT) as sum_var
				FROM correct_me
				GROUP BY year, zone"
	correct_me2 <- sqldf(string, stringsAsFactors=FALSE)			#str(correct_me2)

   # make new columns of lbs and variance for each species
	correct_me3 <- mutate(correct_me2, LOUTI_LBS = round(sum_lbs*p_louti,3), LOUTI_VAR = round(sum_var*p_louti,3),
				ALBIMARGINATA_LBS = round(sum_lbs*p_albimarginata,3), ALBIMARGINATA_VAR = round(sum_var*p_albimarginata,3))	  
	#View(correct_me3)			#nrow(correct_me3)			#str(correct_me3)
	
   # turn to long-form with seperate records for each species, match columns with sp_data6
 	
	correct_albi <- data.frame(year = correct_me3$year, SPECIES_FK = 220, SCIENTIFIC_NAME = "Variola albimarginata",
			zone = correct_me3$zone,
			LBS_CAUGHT = correct_me3$ALBIMARGINATA_LBS,VAR_LBS_CAUGHT = correct_me3$ALBIMARGINATA_VAR)		#str(correct_albi)
 	
	correct_louti <- data.frame(year = correct_me3$year, SPECIES_FK = 229, SCIENTIFIC_NAME = "Variola louti",
			zone = correct_me3$zone,
			LBS_CAUGHT = correct_me3$LOUTI_LBS,VAR_LBS_CAUGHT = correct_me3$LOUTI_VAR)		#str(correct_louti)

   # rbind back to unchanged records in sp_data6B, test		# str(sp_data6B)
	sp_data6C <- rbind(sp_data6B, correct_albi, correct_louti)

   	# check total landings and variance to ensure that none lost.
		sum(sp_data6C$LBS_CAUGHT)				#sum(sp_data5$EXP_LBS)
		sum(sp_data6C$VAR_LBS_CAUGHT, na.rm=TRUE)

	#   str(sp_data6C)			#View(sp_data6C)
	#  drop SCI_NAME for convenience
	sp_data6C <- sp_data6C[,-3]

	rm(sp_data6)
	sp_data6 <- sp_data6C
	
   # save a copy
	sbs_expanded_landings_IDcorrect_03 <- sp_data6


# -----------------------------------------------------------------------------------
  # STEP 2: partitian group-level landings (lbs and variance) to BMUS
  #	this is actually easier than boat-based because we are not smoothing the breakdown props (weighted average, entire timeseries)

  proptable <- sbs_proptable

  # Check to make sure we do not gain / lose lbs or variance in this step
  sum_lbs_init <- sum(sp_data6$LBS_CAUGHT, na.rm = TRUE)
  sum_var_init <- sum(sp_data6$VAR_LBS_CAUGHT, na.rm = TRUE)	


   # --- A. Jacks and trevallies 110

	# select group landings to break-down 
	break_me_down <- subset(sp_data6, SPECIES_FK  == 110)			 	#str(break_me_down)		#View(break_me_down)
	# sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)					# 84330.61 lbs jacks to assign
	# sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)				# 79079494 var within jacks to partitian

	# join to proptable				#str(proptable)
	string <- "SELECT break_me_down.*, 
				proptable.prop_jacks_110, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*prop_jacks_110, var_bdown = VAR_LBS_CAUGHT*prop_jacks_110)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns to match sp_data6, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,7,3,8,9)]					# View(bdown_3)		#str(bdown_3)
	names(bdown_3)[2] <- c("SPECIES_FK")
	names(bdown_3)[4:5] <- c("LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_110 <- bdown_3

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3')


  # --- B. Emperors 260

	break_me_down <- subset(sp_data6, SPECIES_FK  == 260)			#str(break_me_down)		#View(break_me_down)

  # join to proptable
	string <- "SELECT break_me_down.*, 
				proptable.prop_emporers_260, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*prop_emporers_260, var_bdown = VAR_LBS_CAUGHT*prop_emporers_260)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns to match sp_data6, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,7,3,8,9)]					# View(bdown_3)		#str(bdown_3)
	names(bdown_3)[4:5] <- c("LBS_CAUGHT", "VAR_LBS_CAUGHT")
	names(bdown_3)[2] <- c("SPECIES_FK")
	bdown_260 <- bdown_3

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3')

  # --- C. groupers 210		

	break_me_down <- subset(sp_data6, SPECIES_FK  == 210)			#str(break_me_down)		#View(break_me_down)

   # join to proptable
	string <- "SELECT break_me_down.*, 
				proptable.prop_groupers_210, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*prop_groupers_210, var_bdown = VAR_LBS_CAUGHT*prop_groupers_210)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns to match sp_data6, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,7,3,8,9)]					# View(bdown_3)		#str(bdown_3)
	names(bdown_3)[4:5] <- c("LBS_CAUGHT", "VAR_LBS_CAUGHT")
	names(bdown_3)[2] <- c("SPECIES_FK")
	bdown_210 <- bdown_3					#View(bdown_210)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3')


  # --- E. snappers 230		

	break_me_down <- subset(sp_data6, SPECIES_FK  == 230)			#str(break_me_down)		#View(break_me_down)

   # join to proptable
	string <- "SELECT break_me_down.*, 
				proptable.prop_deep_snappers_230, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*prop_deep_snappers_230, var_bdown = VAR_LBS_CAUGHT*prop_deep_snappers_230)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns to match sp_data6, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,7,3,8,9)]					# View(bdown_3)		#str(bdown_3)
	names(bdown_3)[4:5] <- c("LBS_CAUGHT", "VAR_LBS_CAUGHT")
	names(bdown_3)[2] <- c("SPECIES_FK")
	bdown_230 <- bdown_3

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3')


  # --- Fish 100	

   break_me_down <- subset(sp_data6, SPECIES_FK  == 100)			#str(break_me_down)		#View(break_me_down)

   # join to proptable
	string <- "SELECT break_me_down.*, 
				proptable.prop_fish_100, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*prop_fish_100, var_bdown = VAR_LBS_CAUGHT*prop_fish_100)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns to match sp_data6, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,7,3,8,9)]					# View(bdown_3)		#str(bdown_3)
	names(bdown_3)[4:5] <- c("LBS_CAUGHT", "VAR_LBS_CAUGHT")
	names(bdown_3)[2] <- c("SPECIES_FK")
	bdown_100 <- bdown_3

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3')

  #  double check that we don't have BOTTOMFISHES or PRIST/ET
	subset(sp_data6, SPECIES_FK  == 200)
	subset(sp_data6, SPECIES_FK  == 240)

#  ------------------
#	combine break-down with identified species in sp_data6

  string <- "SELECT * 
			FROM sp_data6
			WHERE SPECIES_FK not in (110, 200, 210, 230, 240, 260, 100, 380,390,109)
			"
  sp_data7 <- sqldf(string, stringsAsFactors=FALSE)
  #str(sp_data7)		str(bdown_110)

  sp_data7B <- rbind(sp_data7, bdown_110, bdown_260, bdown_210, bdown_230, bdown_100)

  #  sum by species
  string <- "SELECT year, SPECIES_FK, zone, sum(LBS_CAUGHT) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT
			FROM sp_data7B
			WHERE SPECIES_FK not in (0)
			GROUP BY year, SPECIES_FK, zone
			"
  sp_data8 <- sqldf(string, stringsAsFactors=FALSE)
  #str(sp_data8)		str(bdown_110)

  #test
  sum_lbs_init
  sum(sp_data8$LBS_CAUGHT, na.rm = TRUE)
  sum_var_init
  sum(sp_data8$VAR_LBS_CAUGHT, na.rm = TRUE)


  sbs_expanded_landings_breakdown_final <- sp_data8				#View(sp_data8)


 # clean up workspace
 #	all_objs <- ls()
 #	save_objs <- c("sbs_proptable","root_dir","p_louti", "p_albimarginata", "sbs_expanded_landings_preliminary_01", 
 # 				"sbs_expanded_landings_basic_02", "sbs_expanded_landings_IDcorrect_03", "sbs_expanded_landings_breakdown_final") 
 #	remove_objs <- setdiff(all_objs, save_objs)
 #   	rm(list=remove_objs)
 #	rm(save_objs)
 #	rm(remove_objs)
 #	rm(all_objs)

 # save.image(paste(root_dir, "/output/05_SBS_landings.RData", sep=""))
  



  # -----------
  # the NOAA diver surveys, which go down to 30-m, have observed 5 species: kasmira, louti, virescens, rubrio, lugubris
  #	these 5 species are also the ones that fishermen grouped together as "shallow" in both workshops. Fishermen also indicated
  #	they DO NOT catch palu from shore (in the old days, they got them from paddle canoes, but not now).
  #	So, only consider those 5 species (rutilans, flavi, carb are rare anyway (<200 lbs).




































