#  -----------------------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA LANDINGS (boat-based): 
#	Correct for the variola, filamentosus/flavipinis, rubrio ID errors
#	Breakdown species groups
#	Assign catch to area (e.g., landed in Tutuila, but caught on banks or Manu'as)
#	For the super-basic script to simply ingest the .csvs, use "Alternate_04_Landings_basic.R"
#   ----------------------------------------------------------------------------------------------------------------------------
#   Expanded boat-based landings data received from Hongguang Dec 14, 2021 (corrected for number of weekend days, includes 2020)
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
  # Read in the updated 14Dec expanded landings data
 
  sp_data <- read.csv(paste(root_dir, "/data/SPC_BBS_AS3added2020.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  #sp_data <- read.csv(paste(root_dir, "/Data/SPC_BBS_AS3added2020.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  
  # str(sp_data)

  # follow Toby's instructions to break the unique key SPC_PK into the interview details we need
  sp_data2 <- mutate(sp_data, year = substr(SPC_PK,2,5), method = substr(SPC_PK,11,11), 
					zone = substr(SPC_PK,14,14), type = substr(SPC_PK,20,21), 
					charter = substr(SPC_PK,22,22), process = substr(SPC_PK,23,23))
  head(sp_data2)
  str(sp_data2)			# updated 2020: 10,095 records

  #  Note:
  #		Method	4 = bottomfishing, 5 = btm/trl mix
  #		Zone	1 = Tutuila, 2 = Manua
  #		Type	WD = weekday, WE = weekend
  #		Charter	C = yes, N = no
  #		Process	G = Tutuila, M = Manua

  # ---- per Hongguang / Toby:
  #	LBS_CAUGHT is the expanded landings, in lbs, and VAR_LBS_CAUGHT is the estimated variance of expanded landings (sigma^2).
  #	Because the different expansion strata (year x method x zone x type x charter x species) are independent,
  #	when summing across strata, you simply sum the variances and sample sizes.
  #		for sample size, use NUM_INTERVIEW_POOLED (this includes all interviews in the strata, including 0s).
  #	Although it might not be entirely statistically sound, Hongguang says to sum the P. rutilans with P. flavi for now.
  #		so just replace SPECIES_FK = 243 with 241 now

  sp_data2$SPECIES_FK[sp_data2$SPECIES_FK==243]<-241

  sp_data2$zone[sp_data2$zone=='1']<-'Tutuila'			# note banks trips are included in Tutuila expansion
  sp_data2$zone[sp_data2$zone=='2']<-'Manua'

  # retain all gear types that catch identified BMUS: '4','5','6','8','61' (bfishing, btm/trl mix, spear no tanks, atule-mixed, spear tanks)
  #		note that catch of identified BMUS with gears other than bfishing and btm/trl mix are rare, but we retain those gears for landings
  #		just to be complete.

  string <- "SELECT *
			FROM sp_data2
			WHERE method in ('4','5','6','8','61')
			"
  sp_data3 <- sqldf(string, stringsAsFactors=FALSE)		# str(sp_data3)		#  8,707 records

  #  spear and atule (landings, variance, and sample size) can be grouped to "other" and summed. We will not be breaking down
  #	groups from those gears. Use standard BBS names for the other gears

  sp_data3$method[sp_data3$method =='4']<-'BOTTOMFISHING'
  sp_data3$method[sp_data3$method=='5']<-'BTM/TRL MIX'
  sp_data3$method[sp_data3$method=='6']<-'other'
  sp_data3$method[sp_data3$method=='8']<-'other'
  sp_data3$method[sp_data3$method=='61']<-'other'

  sp_data3$year <- as.numeric(sp_data3$year)				# str(sp_data3)  # 8707 records

  # rename duplicate group SPECIES_FK in cases of complete union:
	# Jacks (110) and Trevally (109)
	# Groupers (210) and Inshore groupers (380)
	# Deep snappers (230) and Inshore snappers (390)
	sp_data3$SPECIES_FK[sp_data3$SPECIES_FK == 109] <- 110
	sp_data3$SPECIES_FK[sp_data3$SPECIES_FK == 380] <- 210
	sp_data3$SPECIES_FK[sp_data3$SPECIES_FK == 390] <- 230

  		# make a copy of this dataset to save it as the pre-ID fix, pre-break-down, pre-area
		# add species scientific names to this basic dataset
  		names_key <- read.csv(paste(root_dir, "/data/all_species_names.csv", sep=""), header=T, stringsAsFactors=FALSE) 
  		# View(names_key)

  		string <- "SELECT sp_data3.*, names_key.SCIENTIFIC_NAME, names_key.COMMON_NAME
			FROM sp_data3
			LEFT JOIN names_key ON
			sp_data3.SPECIES_FK = names_key.SPECIES_FK
		"
  		sp_data3_basicA <- sqldf(string, stringsAsFactors=FALSE)		# str(sp_data3_basicA)		#  8,707 records
				
		# simplify data to only the columns and strata we need (year x zone x gear)
		# sum over year, zone, method, species_fk will combine the redefined gear types, species (groups), and daytype / charter
		string <- "SELECT year, zone, method, SPECIES_FK,SCIENTIFIC_NAME, sum(LBS_CAUGHT) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) AS VAR_LBS_CAUGHT
				FROM  sp_data3_basicA 
				GROUP BY year, zone, method, SCIENTIFIC_NAME"
		sp_data3_basic <- sqldf(string, stringsAsFactors=FALSE)			# str(sp_data3_basic)		#5315 records
  		# Check to make sure we do not gain / lose lbs or variance in this step
  		sum(sp_data3_basic$LBS_CAUGHT, na.rm = TRUE)

  # -----------------------------------------------------------------------------------
  # STEP 1: make the species identification corrections within these landings data. 
  #	See 01_BBS_data_prep.R for detailed justifications for all corrections.

   # Read in 03_BBS_species_proptables.RData
   load(paste(root_dir, "/output/03_BBS_species_proptables.RData", sep=""))
   #load(paste(root_dir, "/Outputs/03_BBS_species_proptables.RData", sep=""))
  		
  		
  	#load(paste(root_dir, "/Outputs/03_BBS_species_proptables.RData", sep=""))
  		
  		
  # ------------
  #  Prepare expanded landings data

    # simplify data to only the columns and strata we need (year x zone x gear)
	# sum over year, zone, method, species_fk will combine the redefined gear types, species and daytype / charter
	string <- "SELECT year, zone, method, SPECIES_FK, sum(LBS_CAUGHT) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) AS VAR_LBS_CAUGHT
				FROM  sp_data3 
				GROUP BY year, zone, method, SPECIES_FK"

	sp_data4 <- sqldf(string, stringsAsFactors=FALSE)			# str(sp_data4)		#5618 records (some species have multiple SPECIES_FK)
	# sum(sp_data4$LBS_CAUGHT, na.rm = TRUE)			# MAGIC_NUMBER <- sum(sp_data4$LBS_CAUGHT, na.rm = TRUE)	
										# MAGIC_NUMBER2 <- sum(sp_data4$VAR_LBS_CAUGHT, na.rm = TRUE)

  # ------------------
  #	1a. Variola: for 1986-2015, sum albimarginata, louti, partitian back to species

    # remove Variola (needing correction) landings
   	string <- "SELECT *
				FROM  sp_data4 
				WHERE SPECIES_FK in (220, 229) AND year < 2016"
	correct_me <- sqldf(string, stringsAsFactors=FALSE)				#str(correct_me)			#134 records
	correct_me[is.na(correct_me)] <- 0

    # use delete query to remove these records from sp_data4	
      sp_data4B <- sqldf(c("DELETE FROM sp_data4 WHERE SPECIES_FK in (220, 229) AND year < 2016", "SELECT * FROM sp_data4"))
	# note, running a DELETE query in sqldf will always throw a warning. ignore.
	# str(sp_data4B)			# 5484 records		
	# TEST	# sum(sp_data4B$LBS_CAUGHT, na.rm = TRUE)+sum(correct_me$LBS_CAUGHT) == MAGIC_NUMBER

   # for "correct_me", sum louti and albimarginata lbs and variance by strata (year, zone, method)
	string <- "SELECT year, zone, method, sum(LBS_CAUGHT) as sum_lbs, sum(VAR_LBS_CAUGHT) as sum_var
				FROM correct_me
				GROUP BY year, zone, method"
	correct_me2 <- sqldf(string, stringsAsFactors=FALSE)			#str(correct_me2)

   # make new columns of lbs and variance for each species
	correct_me3 <- mutate(correct_me2, LOUTI_LBS = round(sum_lbs*p_louti,3), LOUTI_VAR = round(sum_var*p_louti,3),
				ALBIMARGINATA_LBS = round(sum_lbs*p_albimarginata,3), ALBIMARGINATA_VAR = round(sum_var*p_albimarginata,3))	  
	#View(correct_me3)			#nrow(correct_me3)			#str(correct_me3)
	
   # turn to long-form with seperate records for each species, match columns with sp_data4
 	correct_albi <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 220, 
			LBS_CAUGHT = correct_me3$ALBIMARGINATA_LBS,VAR_LBS_CAUGHT = correct_me3$ALBIMARGINATA_VAR)		#str(correct_albi)
 	correct_louti <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 229, 
			LBS_CAUGHT = correct_me3$LOUTI_LBS,VAR_LBS_CAUGHT = correct_me3$LOUTI_VAR)		#str(correct_louti)

   # rbind back to unchanged records in sp_data4B, test
	sp_data4C <- rbind(sp_data4B, correct_albi, correct_louti)

   	# now true/false won't work because of rounding, just make sure same.
		sum(sp_data4C$LBS_CAUGHT)
		MAGIC_NUMBER
		sum(sp_data4C$VAR_LBS_CAUGHT, na.rm=TRUE)
		MAGIC_NUMBER2

	rm(sp_data4)
	sp_data4 <- sp_data4C

# ------------------
  #	1b. P. filamentosus and P. flavipinnis: for 2010-2015, sum fila, flavi, partitian back to species

    # remove fila/flavi (needing correction) landings
   	string <- "SELECT *
				FROM  sp_data4 
				WHERE SPECIES_FK in ('242','241') AND year < 2016 AND year > 2009"
	correct_me <- sqldf(string, stringsAsFactors=FALSE)				#str(correct_me)			#14 records
	correct_me[is.na(correct_me)] <- 0

    # use delete query to remove these records from sp_data4	
      sp_data4B <- sqldf(c("DELETE FROM sp_data4 WHERE SPECIES_FK in ('242','241') AND year < 2016 AND year > 2009", "SELECT * FROM sp_data4"))
	# note, running a DELETE query in sqldf will always throw a warning. ignore.
	# str(sp_data4B)			# 	
	# TEST	# sum(sp_data4B$LBS_CAUGHT, na.rm = TRUE)+sum(correct_me$LBS_CAUGHT)		# MAGIC_NUMBER

   # for "correct_me", sum the two species lbs and variance by strata (year, zone, method)
	string <- "SELECT year, zone, method, sum(LBS_CAUGHT) as sum_lbs, sum(VAR_LBS_CAUGHT) as sum_var
				FROM correct_me
				GROUP BY year, zone, method"
	correct_me2 <- sqldf(string, stringsAsFactors=FALSE)			#str(correct_me2)

   # make new columns of lbs and variance for each species
	correct_me3 <- mutate(correct_me2, FILA_LBS = round(sum_lbs*p_fila,3), FILA_VAR = round(sum_var*p_fila,3),
				FLAVI_LBS = round(sum_lbs*p_flavi,3), FLAVI_VAR = round(sum_var*p_flavi,3))	  
	#View(correct_me3)			#nrow(correct_me3)			#str(correct_me3)
	
   # turn to long-form with seperate records for each species, match columns with sp_data4
 	correct_fila <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 242, 
			LBS_CAUGHT = correct_me3$FILA_LBS,VAR_LBS_CAUGHT = correct_me3$FILA_VAR)		#str(correct_fila)
 	correct_flavi <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 241, 
			LBS_CAUGHT = correct_me3$FLAVI_LBS,VAR_LBS_CAUGHT = correct_me3$FLAVI_VAR)		#str(correct_flavi)

   # rbind back to unchanged records in sp_data4B, test
	sp_data4C <- rbind(sp_data4B, correct_fila, correct_flavi)

   	# now true/false won't work because of rounding, just make sure same.
		sum(sp_data4C$LBS_CAUGHT)
		MAGIC_NUMBER
		sum(sp_data4C$VAR_LBS_CAUGHT, na.rm=TRUE)
		MAGIC_NUMBER2

	rm(sp_data4)
	sp_data4 <- sp_data4C



# ------------------
  #	1c. lethrinidae in the Manu'as. combine by strata (all lethrinus) partition back to ambo, elon, and rubrio
  #		do not do unidentified emperors here, we will break that down later.
  #		WATCH OUT: when we add 2021 data, make sure there aren't "new" species of lethrinidae in Manu'a recorded
  #		(e.g. olivaceous and xanthrochirus, which the survey tech claimed they often see)

    # remove lethrinidae (needing correction) landings
   	string <- "SELECT *
				FROM  sp_data4 
				WHERE SPECIES_FK in ('262','261','267') AND zone = 'Manua'"
	correct_me <- sqldf(string, stringsAsFactors=FALSE)				#str(correct_me)			#20 records
	correct_me[is.na(correct_me)] <- 0

    # use delete query to remove these records from sp_data4	
      sp_data4B <- sqldf(c("DELETE FROM sp_data4 WHERE SPECIES_FK in ('262','261','267') AND zone = 'Manua'", "SELECT * FROM sp_data4"))
	# note, running a DELETE query in sqldf will always throw a warning. ignore.
	# str(sp_data4B)			# 5698 records		
	# TEST	# sum(sp_data4B$LBS_CAUGHT, na.rm = TRUE)+sum(correct_me$LBS_CAUGHT)		# MAGIC_NUMBER

   # for "correct_me", sum the three species lbs and variance by strata (year, zone, method)
	string <- "SELECT year, zone, method, sum(LBS_CAUGHT) as sum_lbs, sum(VAR_LBS_CAUGHT) as sum_var
				FROM correct_me
				GROUP BY year, zone, method"
	correct_me2 <- sqldf(string, stringsAsFactors=FALSE)			#str(correct_me2)

   # make new columns of lbs and variance for each species
	correct_me3 <- mutate(correct_me2, AMBO_LBS = round(sum_lbs*p_amboinensis,3), AMBO_VAR = round(sum_var*p_amboinensis,3),
				ELONG_LBS = round(sum_lbs*p_elongatus,3), ELONG_VAR = round(sum_var*p_elongatus,3),
				RUBRIO_LBS = round(sum_lbs*p_rubrio,3), RUBRIO_VAR = round(sum_var*p_rubrio,3))	  
	#View(correct_me3)			#nrow(correct_me3)			#str(correct_me3)
	
   # turn to long-form with seperate records for each species, match columns with sp_data4
 	correct_elong <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 261, 
			LBS_CAUGHT = correct_me3$ELONG_LBS,VAR_LBS_CAUGHT = correct_me3$ELONG_VAR)		#str(correct_elong)

 	correct_ambo <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 262, 
			LBS_CAUGHT = correct_me3$AMBO_LBS,VAR_LBS_CAUGHT = correct_me3$AMBO_VAR)		#str(correct_ambo)

 	correct_rubrio <- data.frame(year = correct_me3$year, zone = correct_me3$zone, method = correct_me3$method , SPECIES_FK = 267, 
			LBS_CAUGHT = correct_me3$RUBRIO_LBS,VAR_LBS_CAUGHT = correct_me3$RUBRIO_VAR)		#str(correct_rubrio)


   # rbind back to unchanged records in sp_data4B, test
	sp_data4C <- rbind(sp_data4B, correct_elong , correct_ambo , correct_rubrio )

   	# now true/false won't work because of rounding, just make sure same.
		sum(sp_data4C$LBS_CAUGHT)
		MAGIC_NUMBER
		sum(sp_data4C$VAR_LBS_CAUGHT, na.rm=TRUE)
		MAGIC_NUMBER2

	rm(sp_data4)
	sp_data4 <- sp_data4C

	sp_data3 <- sp_data4

  # -----------------------------------------------------------------------------------
  # STEP 2: partitian group-level landings (lbs and variance) to BMUS based on the observed occurence of species
  #		within the raw boat-based creel survey data.

  # Check to make sure we do not gain / lose lbs or variance in this step
  sum_lbs_init <- sum(sp_data3$LBS_CAUGHT, na.rm = TRUE)
  sum_var_init <- sum(sp_data3$VAR_LBS_CAUGHT, na.rm = TRUE)


    # divide the landings data into 3 datasets: identified bmus, groups, and all others.
	# BMUS
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT, VAR_LBS_CAUGHT
				FROM  sp_data4 
				WHERE SPECIES_FK in (247, 239, 111, 248, 249, 267, 231, 241, 242, 245, 229)"
	sp_data_bmus <- sqldf(string, stringsAsFactors=FALSE)
	sp_data_bmus[is.na(sp_data_bmus)] <- 0

	# groups
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT, VAR_LBS_CAUGHT
				FROM  sp_data4 
				WHERE SPECIES_FK in (110, 200, 210, 230, 240, 260, 100)"
	sp_data_groups <- sqldf(string, stringsAsFactors=FALSE)				#View(sp_data_groups)
	sp_data_groups[is.na(sp_data_groups)] <- 0

	# all others
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT, VAR_LBS_CAUGHT
				FROM  sp_data4 
				WHERE SPECIES_FK not in (247, 239, 111, 248, 249, 267, 231, 241, 242, 245, 229, 110, 200, 210, 230, 240, 260, 100)"
	sp_data_others <- sqldf(string, stringsAsFactors=FALSE)
	sp_data_others[is.na(sp_data_others)] <- 0

	# check
	sum(sp_data_bmus$LBS_CAUGHT, na.rm = TRUE) + sum(sp_data_groups$LBS_CAUGHT, na.rm = TRUE)+ sum(sp_data_others$LBS_CAUGHT, na.rm = TRUE)
	sum_lbs_init	


  # -----------------------
  #	Prepare Smooth_proptable 	
  #	Smooth_proptable contains zeros, which mean no catch of a species was observed within the parent group for 
  #		the gear x year x area x species
  #	NAs have two possible meanings: 1. a BMUS could not possibly be a member of a given parent group, 
  #		e.g. Variola louti cannot be unidentified jacks, and
  #		2. no species within a given parent group were identified for the given gear x area x year (i.e. 'information' is zero). 
  #	We cannot have empty species x gear x area x year in the smooth_proptable if we are going to breakdown the
  #		expanded landings. So, we will replace NA type 2 above with the timeseries average for each species x gear x area.

     	# check smooth_proptable, rename columns to match landings
     	str(smooth_proptable)		# 1540	#View(smooth_proptable)		#names(smooth_proptable)  # 11*35*2*2
     	names(smooth_proptable)[1] <- "year"
     	names(smooth_proptable)[2] <- "method"
     	names(smooth_proptable)[4] <- "SPECIES_PK"
	
     	# add columns to calculate timeseries average species proportions per group (avg_) for gear x species x area	
     	smooth_prop_no_na <- smooth_proptable
     	smooth_prop_no_na[is.na(smooth_prop_no_na)] <- 0

     	string <- "SELECT zone, method, SPECIES_PK, avg(sm_prist_et) as avg_prist_et,
				avg(sm_snaps) as avg_snaps,
				avg(sm_grps) as avg_grps,
				avg(sm_jacks) as avg_jacks,
				avg(sm_emps) as avg_emps, 
				avg(sm_bfish) as avg_bfish, 
				avg(sm_fish) as avg_fish               
			FROM smooth_prop_no_na 
			GROUP BY zone, method, SPECIES_PK"

  	avg_sm <- sqldf(string, stringsAsFactors=FALSE)			# View(avg_sm_2)		#View(oldsample_size)
  	avg_sm_2 <- merge(x = smooth_proptable, y = avg_sm, 
				by = c('SPECIES_PK','method','zone') , all.x = TRUE) # View(avg_sm_2)

     	# PLEASE USE CARE:  I am indexing columns by number, so if modifications are made to the proceeding scripts
     	#	then this code will not do what we want (sum catch checks will fail after each step).

     	# if no species were identified in a strata (NA type 2), insert timeseries average into the sm_ columns
     	for (i in 1:nrow(avg_sm_2)) {
     	if(is.na(avg_sm_2$ID_fish[i])) {
		avg_sm_2[i,20:26] <- avg_sm_2[i,27:33]
		}
     	}
	
     	smooth_prop_complete <- avg_sm_2[,1:26]			#View(smooth_prop_complete)		#str(smooth_prop_complete)
     	smooth_prop_complete[is.na(smooth_prop_complete)] <- 0 

     	# check to ensure that within each year x zone x gear, the summed proportions for each group (prist_et, sm_snaps, etc.) cannont exceed 1
     	#   note, we expect that sums will be less than 1 because non-BMUS species are not listed in this table 
     	string <- "SELECT year, zone, method, sum(sm_prist_et), sum(sm_snaps), sum(sm_grps), 
			sum(sm_jacks), sum(sm_emps), sum(sm_bfish), sum(sm_fish)
		FROM smooth_prop_complete
		GROUP BY year, zone, method"
     	sm_ptable_check_sums <- sqldf(string, stringsAsFactors=FALSE)		#View(sm_ptable_check_sums)	#str(sm_ptable_check_sums)
     	sum(sm_ptable_check_sums[,4:10] > 1)			# prist_et, 1999, Tutu, mix is summing to > 1.0000000
										#	so, if we create a very small amount of catch when we breakdown
										# 	prist_et, this is why, but it should be negligeable.

    	# ------------------------------------------------------------
    	# must add gear 'other' x zone x year x species (all values = 0)		View(year_gear_zone)
    	#	  so, we are looking for 1*2*35*11 = 770 new rows
    	# this is necessary in order to join the proptable back onto the landings
    	n_yr <- 35
	n_zone <- 2
	n_sp <- 11
	year_gear_zone <- data.frame(year = rep(seq(1986,2020,1),n_zone),					#View(year_gear_zone)
		method = rep('other',n_zone*n_yr),
		zone = c(rep('Tutuila',n_yr),rep('Manua',n_yr)))
	year_gear_zone2 <- do.call("rbind", replicate(n_sp, year_gear_zone, simplify = FALSE))		#str(year_gear_zone2)
	bmus_list <- read.csv(paste(root_dir, "/data/AmSam_BMUs.csv", sep=""),header=T, stringsAsFactors=FALSE) 
	names(bmus_list)<- c('SPECIES_PK','SCIENTIFIC_NAME_PK')
	bmus_list$SPECIES_PK <- as.character(bmus_list$SPECIES_PK)
	species_rep <- do.call("rbind", replicate(n_yr*n_zone, bmus_list, simplify = FALSE))		
		#str(species_rep)		#View(species_rep)
	species_rep <- species_rep[order(species_rep$SCIENTIFIC_NAME_PK), ]
	year_gear_zone_species <- cbind(year_gear_zone2, species_rep)			#names(year_gear_zone_species)
	year_gear_zone_species <- year_gear_zone_species[,c(4,2,3,1,5)]			#names(smooth_prop_complete)
	add_zeros <- smooth_prop_complete[1,6:26]
	add_zeros[1, ] <- rep(0,21)
	add_zeros2 <- do.call("rbind", replicate(n_yr*n_zone*n_sp, add_zeros, simplify = FALSE))		
		#str(year_gear_zone2)
	add_zeros3 <- cbind(year_gear_zone_species, add_zeros2)
	smooth_prop_complete2 <- rbind(smooth_prop_complete, add_zeros3)			#str(smooth_prop_complete2)
		# expect 1540 + 770 = 2310			#View(smooth_prop_complete2)

	proptable <- smooth_prop_complete2
	
  # -----------------------
  #  PERFORM BREAK-DOWN
  #	Use proptable to break-down the group landings, one group at a time
  #		order of groups doesn't matter because unlike development of proptable, SPECIES_FK in landings are not nested
  #		only the first groups are heavily commented out.

  # --- A. Jacks and trevallies 110

	# select group landings to break-down 
	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 110)			#str(break_me_down)		#View(break_me_down)
	# sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)					# 18896.51 lbs jacks to assign
	# sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)				# 1693881 var within jacks to partitian

	# join to proptable
	string <- "SELECT break_me_down.*, 
				proptable.sm_jacks, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 

	# multiply out the break-down
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_jacks, var_bdown = VAR_LBS_CAUGHT*sm_jacks)
		# View(bdown_2)			#str(bdown_2)			#

	# re-order the columns, again, CAUTION, indexing
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_110 <- bdown_3

	# how much of the jacks group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"

	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	# reorder columns
	leftover_3 <- leftover_2[,-(5:8)]					
	
	# save this
	leftover_110 <- leftover_3

	# CHECK that lbs and variance are conserved over this step
	# breakdown + leftover should equal break_me_down
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
		# 3.6 e-12 is very small, so yes, breakdown + leftover = break_me_down
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)
		# 0

	# remove objects from workspace that we will use again for other groups, not necessary, but this simplifies development
	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- B. Emperors 260

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 260)			#str(break_me_down)		#View(break_me_down)

	string <- "SELECT break_me_down.*, 
				proptable.sm_emps, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_emps, var_bdown = VAR_LBS_CAUGHT*sm_emps)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_260 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"

	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_260 <- leftover_3

	# CHECK (should = 0)
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- C. BOTTOMFISHES 200

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 200)			#str(break_me_down)		#View(break_me_down)

	string <- "SELECT break_me_down.*, 
				proptable.sm_bfish, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_bfish, var_bdown = VAR_LBS_CAUGHT*sm_bfish)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_200 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"
	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_200 <- leftover_3

	# CHECK
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- D. groupers 210		

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 210)			#str(break_me_down)		#View(break_me_down)

	string <- "SELECT break_me_down.*, 
				proptable.sm_grps, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_grps, var_bdown = VAR_LBS_CAUGHT*sm_grps)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_210 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"
	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_210 <- leftover_3

	# CHECK
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- E. snappers 230	

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 230)			#str(break_me_down)		#View(break_me_down)
	
	string <- "SELECT break_me_down.*, 
				proptable.sm_snaps, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_snaps, var_bdown = VAR_LBS_CAUGHT*sm_snaps)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_230 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"

	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_230 <- leftover_3

	# CHECK
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- F. prist / et 240	

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 240)
	
	string <- "SELECT break_me_down.*, 
				proptable.sm_prist_et, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_prist_et, var_bdown = VAR_LBS_CAUGHT*sm_prist_et)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_240 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"

	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_240 <- leftover_3

	# CHECK
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')

  # --- G. fishes 100

	break_me_down <- subset(sp_data_groups, SPECIES_FK  == 100)

	string <- "SELECT break_me_down.*, 
				proptable.sm_fish, proptable.SPECIES_PK as 'bdown_species'
					FROM break_me_down LEFT JOIN proptable
						ON break_me_down.year = proptable.year
							AND
						break_me_down.method = proptable.method
							AND
						break_me_down.zone = proptable.zone"

	bdown_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(bdown_1)			#View(bdown_1)
	bdown_1[is.na(bdown_1)] <- 0 
	bdown_2 <- mutate(bdown_1, lbs_bdown = LBS_CAUGHT*sm_fish, var_bdown = VAR_LBS_CAUGHT*sm_fish)
	bdown_3 <- bdown_2[,c(1,2,3,8,9,10)]					# View(bdown_3)
	names(bdown_3)[4:6] <- c("SPECIES_FK", "LBS_CAUGHT", "VAR_LBS_CAUGHT")
	bdown_100 <- bdown_3

	# how much of the group was left over (not broken down?)
	string <- "SELECT year, zone, method, SPECIES_FK, LBS_CAUGHT as init_lbs, VAR_LBS_CAUGHT as init_var,
						sum(lbs_bdown) as lbs_bdown, sum(var_bdown) as var_bdown               
				FROM bdown_2 
				GROUP BY year, zone, method"

	leftover_1 <- sqldf(string, stringsAsFactors=FALSE)			#View(leftover_1)
	leftover_2 <- mutate(leftover_1, LBS_CAUGHT = init_lbs - lbs_bdown, VAR_LBS_CAUGHT = init_var - var_bdown)
	leftover_3 <- leftover_2[,-(5:8)]						# View(leftover_3)
	leftover_100 <- leftover_3

	# CHECK
	(sum(bdown_3$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$LBS_CAUGHT, na.rm = TRUE)
	(sum(bdown_3$VAR_LBS_CAUGHT, na.rm = TRUE) + sum(leftover_3$VAR_LBS_CAUGHT, na.rm = TRUE)) - sum(break_me_down$VAR_LBS_CAUGHT, na.rm = TRUE)

	rm('break_me_down', 'bdown_1', 'bdown_2', 'bdown_3', 'leftover_1', 'leftover_2', 'leftover_3')


  # --------------------------------------------
  # collate the leftover group catch and the broken down (plus originally identified) bmus catch

  	leftover_all_groups <- rbind(leftover_100, leftover_110, leftover_200, leftover_210, leftover_230, leftover_240, leftover_260)
	# View(leftover_all_groups)

  	breakdown_bmus1 <- rbind(sp_data_bmus, bdown_100, bdown_110, bdown_200, bdown_210, bdown_230, bdown_240, bdown_260)  
	str(breakdown_bmus1)
	# sum(breakdown_bmus1$LBS_CAUGHT, na.rm = TRUE) + sum(leftover_all_groups$LBS_CAUGHT, na.rm = TRUE)	
	# sum(sp_data_bmus$LBS_CAUGHT, na.rm = TRUE) + sum(sp_data_groups$LBS_CAUGHT, na.rm = TRUE)

  	string <- "SELECT year, zone, method, SPECIES_FK, sum(LBS_CAUGHT) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT              
			FROM  breakdown_bmus1 
			GROUP BY year, zone, method, SPECIES_FK"

  	breakdown_bmus2 <- sqldf(string, stringsAsFactors=FALSE)		# sum(breakdown_bmus2$LBS_CAUGHT, na.rm = TRUE)		

  	breakdown_bmus_smooth <- rbind(breakdown_bmus2, sp_data_others, leftover_all_groups)
		
	# final check
	sum(breakdown_bmus_smooth$LBS_CAUGHT, na.rm = TRUE)
	sum_lbs_init 

	sum(breakdown_bmus_smooth$VAR_LBS_CAUGHT, na.rm = TRUE)
	sum_var_init 

#   -----------------------------------------------------------------------------------
#   STEP 3: Partition the Landings Expansion Tutuila Ports to catch area: Tutuila, Banks, or Manu'a.
#	We are assuming that Banks catch is all landed in Tutuila (not Manua) because the BBS interviews for all years between 1986 and 2020,
#		there were 177 interviews with area_fished = Banks. Of those, only 3 had interview port = Manu'a. Most (95.5%) were
#		Fagatogo Marina Dock

#   use BMUS list to select only the BMUS from the broken-down landings
#	this way all non-BMUS and remaining group (containing non-BMUS species) catch will not be carried forward.

	str(bmus_list)
	names(bmus_list)[1] <- 'SPECIES_FK'
	landings_2B <- merge(x = breakdown_bmus_smooth, y = bmus_list, 
				by = 'SPECIES_FK', all.x = FALSE)
	str(landings_2B)	
	# View(landings_2B)				

	# check total BMUS landings and variance
	bmus_land_tot_1 <- sum(landings_2B$LBS_CAUGHT)
	bmus_var_tot_1 <- sum(landings_2B$VAR_LBS_CAUGHT)


#  BMUS landings summed by gear
	string <- "SELECT SCIENTIFIC_NAME_PK, year, zone, sum(LBS_CAUGHT) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT              
			FROM  landings_2B
			GROUP BY year, zone, SCIENTIFIC_NAME_PK"

  	landings_2C <- sqldf(string, stringsAsFactors=FALSE)	
	# View(landings_2C)
	# check total BMUS landings and variance
	bmus_land_tot_2 <- sum(landings_2C$LBS_CAUGHT)
	bmus_var_tot_2 <- sum(landings_2C$VAR_LBS_CAUGHT)

#   Manu'a Landings
	manua_landings <- subset(landings_2C, zone == 'Manua')		#str(manua_landings)

#   Tutuila Landings
	tutu_landings <- subset(landings_2C, zone == 'Tutuila')		#nrow(tutu_landings)
	# str(tutu_landings)		# summary(tutu_landings)		#tot_tutu <- sum(tutu_landings$LBS_CAUGHT)
#	sum(manua_landings$LBS_CAUGHT,tutu_landings$LBS_CAUGHT)

#   Records are correct (35 years * 11 species = 385) for Tutuila
#	But, must add zeros for Manu'a			#str(zeros_df)
		zeros_df <- data.frame(year = rep(seq(1986, 2020, 1),11), 
			SCIENTIFIC_NAME_PK = c(rep('Aphareus rutilans',35),rep('Aprion virescens',35),
			rep('Caranx lugubris',35),rep('Etelis coruscans',35),rep('Etelis carbunculus',35),
			rep('Lethrinus rubrioperculatus',35),rep('Lutjanus kasmira',35),rep('Pristipomoides flavipinnis',35),
			rep('Pristipomoides filamentosus',35),rep('Pristipomoides zonatus',35),rep('Variola louti',35)))
		temp2 <- merge(x = zeros_df, y = manua_landings, by = c('year','SCIENTIFIC_NAME_PK') , all.x = TRUE)
		temp2 <- temp2[,c(1,2,4,5)]				# drop zone
		temp2[is.na(temp2)] <- 0 				#View(temp2)
		manua_landings_zeros <- temp2				#View(manua_landings_zeros)

		tot_manu <- sum(manua_landings_zeros$LBS_CAUGHT)

#  ----------
#  We need a table telling us, for each year x species (summed over gear) how much of the catch that was landed in Tutuila
#	was caught at either the banks or the Manu'a Islands. Create this table based on identified catch in the boat-based survey
#	for BOTTOMFISHING and BTM/TRL MIX.

#  CREATE TABLE HERE
#  -------------------->

		# load boat-based survey data, processed (space contains root_dir, should be same as here)
  		load(paste(root_dir, "/output/02_BBS_covariates.RData", sep=""))
		  #load(paste(root_dir, "/Outputs/02_BBS_covariates.RData", sep=""))
		
		
  		# unfortunately, use of ' in port name will be a problem, rename now.
			bbs_3C$port_simple <- as.character(bbs_3C$port_simple)
			bbs_3C$port_simple[bbs_3C$port_simple=="AUNU'U"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="FAGA'ALU"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="FAGAITUA"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="FAGASA"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="FAGATOGO (MARINA DOCK)"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="PAGO PAGO"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="Tutuila_Other"]<-'Tutuila'
			bbs_3C$port_simple[bbs_3C$port_simple=="GENERAL MANUA PORT"]<-'Manua'
			bbs_3C$port_simple <- as.factor(bbs_3C$port_simple)
			summary(bbs_3C$port_simple)

  			# A. Landed in Tutuila, caught from the banks
 				string <- "SELECT SCIENTIFIC_NAME, year_num, SUM(EST_LBS) as TOT_LBS
		  			FROM
					  (SELECT DISTINCT CATCH_PK, SCIENTIFIC_NAME, year_num, AREA_B2, port_simple, EST_LBS
						FROM bbs_3C
						WHERE SPECIES_FK in ('247','239','111','248','249','267','231','241','242','245','229') 
						AND year_num < 2021
						AND AREA_B2 in ('Bank_E', 'Bank_S')
						AND port_simple = 'Tutuila' ) 
		  			GROUP BY SCIENTIFIC_NAME, year_num"
			      banks_in_tutu <- sqldf(string, stringsAsFactors=FALSE)
			      # View(banks_in_tutu)

  			# B. Landed in Tutuila, caught from Manu'a
 				string <- "SELECT SCIENTIFIC_NAME, year_num, SUM(EST_LBS) as TOT_LBS
		  			FROM
					  (SELECT DISTINCT CATCH_PK, SCIENTIFIC_NAME, year_num, AREA_B2, port_simple, EST_LBS
						FROM bbs_3C
						WHERE SPECIES_FK in ('247','239','111','248','249','267','231','241','242','245','229') 
						AND year_num < 2021
						AND AREA_B2 = 'Manua'
						AND port_simple = 'Tutuila' ) 
		 		      GROUP BY SCIENTIFIC_NAME, year_num"
				manu_in_tutu <- sqldf(string, stringsAsFactors=FALSE)
				# View(manu_in_tutu)				# quite rare

  			# C. Landed in Tutuila, caught from Tutuila
 				string <- "SELECT SCIENTIFIC_NAME, year_num, SUM(EST_LBS) as TOT_LBS
		  			FROM
					  (SELECT DISTINCT CATCH_PK, SCIENTIFIC_NAME, year_num, AREA_B2, port_simple, EST_LBS
						FROM bbs_3C
						WHERE SPECIES_FK in ('247','239','111','248','249','267','231','241','242','245','229') 
						AND year_num < 2021
						AND AREA_B2 = 'Tutuila'
						AND port_simple = 'Tutuila' ) 
		 	 		GROUP BY SCIENTIFIC_NAME, year_num"
				tutu_in_tutu <- sqldf(string, stringsAsFactors=FALSE)
				#  View(tutu_in_tutu)

  		# put these 3 datasets (banks_in_tutu, manu_in_tutu, tutu_in_tutu) together to form proportions
		#    WATCH OUT: we still have catch records where area fished is Unk or NA. Ignore those when calculating the
  		#    denominator for our props		# summary(as.factor(bbs_3C$AREA_B2))

			temp1 <- merge(x = tutu_in_tutu, y = banks_in_tutu, 
				by = c('SCIENTIFIC_NAME','year_num'), all.x = TRUE)		#View(temp1)	#str(temp1)			
			names(temp1)[3] <- "Tutu_Tutu_lbs"
			names(temp1)[4] <- "Banks_Tutu_lbs"

			temp2 <- merge(x = temp1, y = manu_in_tutu, 
				by = c('SCIENTIFIC_NAME','year_num'), all.x = TRUE)	#View(temp2)	#str(temp2)		
			names(temp2)[5] <- "Manu_Tutu_lbs"

			temp2[is.na(temp2)] <- 0 
			temp3 <- mutate(temp2, tot_TBM_lbs = Tutu_Tutu_lbs + Banks_Tutu_lbs + Manu_Tutu_lbs)

			tutu_landings_props <- mutate(temp3, prop_banks = Banks_Tutu_lbs/tot_TBM_lbs,
				prop_manu = Manu_Tutu_lbs/tot_TBM_lbs,
				prop_tutu = Tutu_Tutu_lbs/tot_TBM_lbs)

#  join tutu_landings_props onto Tutu landings records
	string <- "SELECT tutu_landings.*, tutu_landings_props.prop_banks,
				tutu_landings_props.prop_manu, tutu_landings_props.prop_tutu
			FROM tutu_landings 
			LEFT JOIN tutu_landings_props 
			ON tutu_landings.year = tutu_landings_props.year_num
			  AND tutu_landings.SCIENTIFIC_NAME_PK = tutu_landings_props.SCIENTIFIC_NAME"
	tutu_landings_2 <- sqldf(string, stringsAsFactors=FALSE)		#View(tutu_landings_2)	  #str(tutu_landings_2)

  # must fill in NAs to assign all landings to Tutuila catch
	tutu_landings_2["prop_banks"][is.na(tutu_landings_2["prop_banks"])] <- 0
	tutu_landings_2["prop_manu"][is.na(tutu_landings_2["prop_manu"])] <- 0
	tutu_landings_2["prop_tutu"][is.na(tutu_landings_2["prop_tutu"])] <- 1

  	tutu_landings_3 <- mutate(tutu_landings_2, tutu_lbs = LBS_CAUGHT*prop_tutu, tutu_var = VAR_LBS_CAUGHT*prop_tutu,
					manu_lbs = LBS_CAUGHT*prop_manu, manu_var = VAR_LBS_CAUGHT*prop_manu,
					banks_lbs = LBS_CAUGHT*prop_banks, banks_var = VAR_LBS_CAUGHT*prop_banks)
	# str(tutu_landings_3)			#sum(tutu_landings_3$tutu_lbs,tutu_landings_3$manu_lbs,tutu_landings_3$banks_lbs)
	# View(tutu_landings_3)		#sum(tutu_landings_3$LBS_CAUGHT)

	tutu_catch <- tutu_landings_3[,c(1,2,9,10)]		#View(tutu_catch)
	banks_catch <- tutu_landings_3[,c(1,2,13,14)]		#View(banks_catch)

	manu_catch_tutu <- tutu_landings_3[,c(1,2,11,12)]		#View(manu_catch_tutu)	#str(manu_catch_tutu)

	# str(manua_landings_zeros)
	manu_catch_1 <- merge(x = manua_landings_zeros, y = manu_catch_tutu, 
			by = c('year','SCIENTIFIC_NAME_PK') , all.x = TRUE)			#str(manu_catch_2)
	
	manu_catch_2 <- mutate(manu_catch_1, tot_lbs = LBS_CAUGHT + manu_lbs, tot_var = VAR_LBS_CAUGHT + manu_var)
	manu_catch_total <- manu_catch_2[,c(1,2,7,8)]			#str(manu_catch_total)
	

  # check it
	sum(manu_catch_total$tot_lbs, tutu_catch$tutu_lbs, banks_catch$banks_lbs)
	sum(manu_catch_total$tot_var, tutu_catch$tutu_var, banks_catch$banks_var)
	bmus_land_tot_1
	bmus_var_tot_1


# -----------------------------------------------------------------------------------------------------------------------------

 # clean up workspace
	all_objs <- ls()
	save_objs <- c("tutu_catch","root_dir", "banks_catch", "manu_catch_total", "breakdown_bmus_smooth",
					"species_proptable_by_year_gear_zone",
					"p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
					"p_amboinensis","p_rubrio", "sp_data3_basic")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/output/04_BBS_Landings_bdown_area.RData", sep=""))
	# save.image(paste(root_dir, "/Outputs/04_BBS_Landings_bdown_area.RData", sep=""))
	












































#  --------------------------------------------------------------------------------------------------------------
