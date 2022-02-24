#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - ADDITIONAL COVARIATES FOR CPUE 02_BBS_covariates.R
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  #	library(tidyr)
  #	library(ggplot2)
	library(this.path)
	library(lunar)
  	options(scipen=999)		# this option just forces R to never use scientific notation

  # establish directories using this.path
	root_dir <- this.path::here(.. = 1)

  # read in 01_BBS_data_prep.RData
  #  note this will replace root_dir, that's OK because we intend everyone to be using the standard directory structure
  #		matching the git repo. if not, just redefine root_dir after load workspace
  load(paste(root_dir, "/NO_GITHUB_data_outputs/01_BBS_data_prep.RData", sep=""))
  

#  --------------------------------------------------------------------------------------------------------------
#  add some posix CT variables and moon phase, use library lunar
#  American Samoa is UTC - 11

   bbs_3C <- mutate(bbs_3C, INTERVIEW_TIME_LOCAL = as.POSIXct(INTERVIEW_TIME, tz='UTC'))
   bbs_3C <- mutate(bbs_3C, INTERVIEW_TIME_UTC = INTERVIEW_TIME_LOCAL + 11*60*60)
   bbs_3C <- mutate(bbs_3C, Moon_radians = lunar.phase(as.Date(SAMPLE_DATE), shift = 11))

  #  2pi radians = 29.53 days, so...
   bbs_3C <- mutate(bbs_3C, Moon_days = round(Moon_radians* (29.53/(2*pi)) ,digits=0) )


#  --------------------------------------------------------------------------------------------------------------
#  ENVIRONMENTAL DATA: WINDS
#    do this working with interview only
#    Note: Pago Pago is 14.28 deg S, 170.7 deg W (-14.28, -170.7).

   string <- "SELECT DISTINCT INTERVIEW_PK, year_num, INTERVIEW_TIME_LOCAL, INTERVIEW_TIME_UTC, AREA_WIND
		FROM bbs_3C"
   list_ints <- sqldf(string, stringsAsFactors=FALSE)		# View(list_ints)
	# str(list_ints)

  # load 6 hour wind_data. Created in Get_Wind.R script.
   load(paste(root_dir, "/data/01_Get_Wind.RData", sep=""))
   
  # -- Do "nearest neighbor" merge on INTERVIEW_TIME_UTC:   I don't know of a simpler way to do this.

  # MANU'A ISLANDS
  #	note: they didn't routinely record the interview time in the Manua's until 2003
  #		so, interview time appears to always be set to midnight local time, 11 am UTC.	

   ints_manu <- subset(list_ints, AREA_WIND == 'manu')		
   ints_manu <- ints_manu[order(ints_manu$INTERVIEW_TIME_UTC),] 		# str(ints_manu)	# 849 interviews
   wind_manu <- subset(wind_6h, location == 'manu')
   wind_manu <- wind_manu[order(wind_manu$dt),]			#View(wind_manu[1:100,])

  #  remove 1986 and 1987 from the interview list because we don't have wind data before 1988
   ints_manu <- subset(ints_manu, year_num > 1987)

  # findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
   index_mat <- findInterval(ints_manu$INTERVIEW_TIME_UTC,wind_manu$dt)
   	# str(index_mat)

   ints_manu <- mutate(ints_manu, 'wind_index' = index_mat)
  
  # make columns for the previous and next windtimes (with dummy datetime)
   ints_manu <- mutate(ints_manu, 'previous_windtime' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))
   ints_manu <- mutate(ints_manu, 'next_windtime' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))

  # fetch the previous (index_mat above) and next windtimes (index_mat + 1).
   for (i in 1:nrow(ints_manu)) {
		lookup_i <- ints_manu$wind_index[i]
		ints_manu$previous_windtime[i] <- wind_manu[lookup_i,1]
		ints_manu$next_windtime[i] <- wind_manu[(lookup_i+1),1]	
		}

  # calculate hours since last, hours till next windtime. 
   int_manu_2 <- mutate(ints_manu, 'm_since_previous' = (as.numeric(INTERVIEW_TIME_UTC - previous_windtime)/60),
				'm_to_next' = (as.numeric(next_windtime - INTERVIEW_TIME_UTC)))
	# View(int_manu_2)

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
	# View(int_winds_manu)
 
   for (i in 1:nrow(int_winds_manu)) {
		wind_i <- int_winds_manu$use_windtime_index[i]
		int_winds_manu$wspd[i] <- wind_manu$wspd[wind_i]
		int_winds_manu$wdir[i] <- wind_manu$wdir[wind_i]
		int_winds_manu$uwind[i] <- wind_manu$uwind[wind_i]
		int_winds_manu$vwind[i] <- wind_manu$vwind[wind_i]
		}


  # TUTUILA

   ints_tutu <- subset(list_ints, AREA_WIND == 'tutu')		
   ints_tutu <- ints_tutu[order(ints_tutu$INTERVIEW_TIME_UTC),] 
   wind_tutu <- subset(wind_6h, location == 'tutu')
   wind_tutu <- wind_tutu[order(wind_tutu$dt),]			#View(wind_tutu[1:100,])
   ints_tutu <- subset(ints_tutu, year_num > 1987)

  # findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
   rm(index_mat)
   index_mat <- findInterval(ints_tutu$INTERVIEW_TIME_UTC,wind_tutu$dt)
   ints_tutu <- mutate(ints_tutu, 'wind_index' = index_mat)
	# View(ints_tutu)		#str(ints_tutu)

  # make columns for the previous and next windtimes
   ints_tutu <- mutate(ints_tutu, 'previous_windtime' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))
   ints_tutu <- mutate(ints_tutu, 'next_windtime' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))

 # fetch the previous (index_mat above) and next windtimes (index_mat + 1).
   for (i in 1:nrow(ints_tutu)) {
		lookup_i <- ints_tutu$wind_index[i]
		ints_tutu$previous_windtime[i] <- wind_tutu[lookup_i,1]
		ints_tutu$next_windtime[i] <- wind_tutu[(lookup_i+1),1]	
		}

  # calculate hours since last, hours till next windtime. 
   int_tutu_2 <- mutate(ints_tutu, 'm_since_previous' = (as.numeric(INTERVIEW_TIME_UTC - previous_windtime)/60),
				'm_to_next' = (as.numeric(next_windtime - INTERVIEW_TIME_UTC)))
		# View(int_tutu_2)

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

# -- merge tutuila and manu'a interviews w/ winds back into the bbs_3C dataset

	# head(int_winds_tutu)
	# head(int_winds_manu)
	# head(int_winds)
   int_winds <- rbind(int_winds_tutu, int_winds_manu)
	# names(bbs_3C)		#nrow(bbs_3C_2)		#str(int_winds)

   string <- "SELECT bbs_3C.*, int_winds.wspd, int_winds.wdir, int_winds.uwind, int_winds.vwind
		FROM bbs_3C
		LEFT JOIN int_winds 
			ON bbs_3C.INTERVIEW_PK = int_winds.INTERVIEW_PK
		"

  bbs_3C_2 <- sqldf(string, stringsAsFactors=FALSE)
	# names(bbs_3C_2)

  bbs_3C <- bbs_3C_2
	# str(bbs_3C)


#  --------------------------------------------------------------------------------------------------------------
#  ENVIRONMENTAL DATA: LARGE SCALE INDICES

  # load largescale indices
   ENSO <- read.csv(paste(root_dir, "/data/ENSO.csv", sep=""), header=TRUE, stringsAsFactors=FALSE)
   ONI <- read.csv(paste(root_dir, "/data/ONI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)
   SOI <- read.csv(paste(root_dir, "/data/SOI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)

  # do the merge in 3 steps
   string <- "SELECT bbs_3C.*, ENSO.ENSO
		FROM bbs_3C 
		LEFT JOIN ENSO 
			ON bbs_3C.year_num = ENSO.Year
				AND bbs_3C.month = ENSO.month_num
		"
   bbs_ENSO <- sqldf(string, stringsAsFactors=FALSE)
	# str(bbs_ENSO)

   string <- "SELECT bbs_ENSO.*, SOI.SOI
		FROM bbs_ENSO 
		LEFT JOIN SOI 
			ON bbs_ENSO.year_num = SOI.Year
				AND bbs_ENSO.month = SOI.month_num
		"
   bbs_ENSO_SOI <- sqldf(string, stringsAsFactors=FALSE)
	# str(bbs_ENSO_SOI)
 
   string <- "SELECT bbs_ENSO_SOI.*, ONI.ONI
		FROM bbs_ENSO_SOI
		LEFT JOIN ONI 
			ON bbs_ENSO_SOI.year_num = ONI.Year
				AND bbs_ENSO_SOI.month = ONI.month_num
		"
   bbs_ENSO_SOI_ONI <- sqldf(string, stringsAsFactors=FALSE)
		# str(bbs_ENSO_SOI_ONI)  # names(bbs_ENSO_SOI_ONI)
   rm(bbs_3C)				#str(bbs_3C)
   bbs_3C <- bbs_ENSO_SOI_ONI


#  Final effort step
# --- add effort as num_gear x hours_fished
	bbs_3C <- mutate(bbs_3C, effort = HOURS_FISHED*NUM_GEAR)			#nrow(bbs_3C)

   length(unique(bbs_3C$INTERVIEW_PK))		# 3066 interviews (1986-2021 are still in here)

  # clean up workspace
	all_objs <- ls()
	save_objs <- c("aint_bbs_all_gears","aint_bbs_filtered","bbs_3C","root_dir","bbs_3C_before_ID_correct",
					"p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
					"p_amboinensis","p_rubrio")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/NO_GITHUB_data_outputs/02_BBS_covariates.RData", sep=""))
  





































#  --------------------------------------------------------------------------------------------------------------
