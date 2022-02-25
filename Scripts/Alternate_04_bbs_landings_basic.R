#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA LANDINGS (Boat-based)
#   This is the most basic processing script for the expanded landings, 
#		received from Hongguang Nov 21, 2021 (corrected for number of weekend days)
#   Use 04_Landings_bdown_area.R for complete landings data handling
#
#	Erin Bohaboy erin.bohaboy@noaa.gov
#		
#  --------------------------------------------------------------------------------------------------------------

  #  PRELIMINARIES
  rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf

  # load all the libraries. There are lots, some not used.
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


  # establish directories using this.path
  root_dir <- this.path::here(.. = 1)


  # ----------------------------------
  # Read in the updated 14Dec expanded landings data
 
  sp_data <- read.csv(paste(root_dir, "/data/SPC_BBS_AS3added2020.csv", sep=""),header=T, stringsAsFactors=FALSE) 
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
  #	Although it might not be entirely statistically sound, Hongguang says to sum the A. and P. rutilans for now.
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

  # add species scientific names for convenience
  names_key <- read.csv(paste(root_dir, "/data/all_species_names.csv", sep=""), header=T, stringsAsFactors=FALSE) 
  # View(names_key)

  string <- "SELECT sp_data3.*, names_key.SCIENTIFIC_NAME, names_key.COMMON_NAME
		FROM sp_data3
		LEFT JOIN names_key ON
			sp_data3.SPECIES_FK = names_key.SPECIES_FK
		"
  sp_data3B <- sqldf(string, stringsAsFactors=FALSE)		# str(sp_data3B)		#  8,707 records
  bbs_landings_basic <- sp_data3B


 # clean up workspace, save this as the basic landings data
	all_objs <- ls()
	save_objs <- c("bbs_landings_basic","root_dir")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/output/Alternate_04_BBS_landings_basic.RData", sep=""))
  




















#  --------------------------------------------------------------------------------------------------------------
