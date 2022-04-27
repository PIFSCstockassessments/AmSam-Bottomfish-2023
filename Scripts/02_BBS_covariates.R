#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISH - ADDITIONAL COVARIATES FOR CPUE 02_BBS_covariates.R
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	require(sqldf); require(dplyr);	require(this.path);	require(lunar); require(data.table)
    options(scipen=999)		# this option just forces R to never use scientific notation

# establish directories using this.path
  	root_dir <- this.path::here(.. = 1)

  # read in 01_BBS_data_prep.RData
    B <- readRDS(paste(root_dir, "/Outputs/CPUE_processed.rds", sep=""))
   #load(paste(root_dir, "/Outputs/01_BBS_data_prep.RData", sep=""))
   
#  --------------------------------------------------------------------------------------------------------------
#  add some posix CT variables and moon phase, use require lunar
#  American Samoa is UTC - 11

    B <- mutate(B, INTERVIEW_TIME_LOCAL = as.POSIXct(INTERVIEW_TIME, tz='UTC'))
    B <- mutate(B, INTERVIEW_TIME_UTC = INTERVIEW_TIME_LOCAL + 11*60*60)
    B <- mutate(B, MOON_RADIANS = lunar.phase(as.Date(SAMPLE_DATE), shift = 11))

     #  2pi radians = 29.53 days, so...
    B <- mutate(B, MOON_DAYS = round(MOON_RADIANS* (29.53/(2*pi)) ,digits=0) )

#  --------------------------------------------------------------------------------------------------------------
#  ENVIRONMENTAL DATA: WINDS
#    do this working with interview only
#    Note: Pago Pago is 14.28 deg S, 170.7 deg W (-14.28, -170.7).

  
   INT <- B[,list(N=.N),by=list(INTERVIEW_PK,YEAR,INTERVIEW_TIME_LOCAL,INTERVIEW_TIME_UTC,AREA_WIND)]
   W   <- readRDS(paste0(root_dir, "//Outputs/CPUE_Winds.rds")) # load 6 hour wind_data (from Get_Wind.R script).
    
    # -- Do "nearest neighbor" merge on INTERVIEW_TIME_UTC:   I don't know of a simpler way to do this.

  # MANU'A ISLANDS
  #	note: they didn't routinely record the interview time in the Manua's until 2003
  #		so, interview time appears to always be set to midnight local time, 11 am UTC.	

   INT.MAN <- INT[AREA_WIND == 'manu']		
   INT.MAN <- INT.MAN[order(INTERVIEW_TIME_UTC)] 
   W.MAN   <- W[location == 'manu']
   W.MAN   <- W.MAN[order(dt)]	
   INT.MAN <- INT.MAN[YEAR > 1987]	# Remove 1986 and 1987 from the interview list because we don't have wind data before 1988

  # findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
   INDEX.MAT <- findInterval(INT.MAN$INTERVIEW_TIME_UTC,W.MAN$dt)
   INT.MAN   <- mutate(INT.MAN, 'WIND_INDEX' = INDEX.MAT)
  
  # make columns for the previous and next windtimes (with dummy datetime)
   INT.MAN <- mutate(INT.MAN, 'PREV_WINDTIME' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))
   INT.MAN <- mutate(INT.MAN, 'NEXT_WINDTIME' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))

  # fetch the previous (index_mat above) and next windtimes (index_mat + 1).
   for (i in 1:nrow(INT.MAN)) {
		lookup_i                 <- INT.MAN$WIND_INDEX[i]
		INT.MAN[i]$PREV_WINDTIME <- W.MAN[lookup_i,1]
		INT.MAN[i]$NEXT_WINDTIME <- W.MAN[(lookup_i+1),1]	
		}

  # calculate hours since last, hours till next windtime. 
   INT.MAN <- mutate(INT.MAN, 'M_SINCE_PREV' = (as.numeric(INTERVIEW_TIME_UTC - PREV_WINDTIME)/60),
				'M_TO_NEXT' = (as.numeric(NEXT_WINDTIME - INTERVIEW_TIME_UTC)))
	
  # add empty column to note the index to use
   INT.MAN <- mutate(INT.MAN, "USE_WINDTIME_INDEX"= -999)
	
   for (i in 1:nrow(INT.MAN)) {
		ifelse(INT.MAN$M_SINCE_PREV[i] < INT.MAN$M_TO_NEXT[i],
			INT.MAN$USE_WINDTIME_INDEX[i] <- INT.MAN$WIND_INDEX[i],
			INT.MAN$USE_WINDTIME_INDEX[i] <- INT.MAN$WIND_INDEX[i]+1)
	}

  # now we have the index of winds to use, pull in the data.
   INT.W.MAN <- mutate(INT.MAN, wspd = 999, wdir = 999, uwind = 999, vwind = 999)
	
   for (i in 1:nrow(INT.W.MAN)) {
		wind_i <- INT.W.MAN$USE_WINDTIME_INDEX[i]
		INT.W.MAN$wspd[i]  <- W.MAN$wspd[wind_i]
		INT.W.MAN$wdir[i]  <- W.MAN$wdir[wind_i]
		INT.W.MAN$uwind[i] <- W.MAN$uwind[wind_i]
		INT.W.MAN$vwind[i] <- W.MAN$vwind[wind_i]
		}


  # TUTUILA
   
   INT.TUT <- INT[AREA_WIND == 'tutu']		
   INT.TUT <- INT.TUT[order(INTERVIEW_TIME_UTC)] 
   W.TUT   <- W[location == 'tutu']
   W.TUT   <- W.TUT[order(dt)]	
   INT.TUT <- INT.TUT[YEAR > 1987]	# Remove 1986 and 1987 from the interview list because we don't have wind data before 1988
   
   # findInterval will return the vector of indices for the closest without being under. I.e., the most recent dt.
   INDEX.MAT <- findInterval(INT.TUT$INTERVIEW_TIME_UTC,W.TUT$dt)
   INT.TUT   <- mutate(INT.TUT, 'WIND_INDEX' = INDEX.MAT)
   
   # make columns for the previous and next windtimes (with dummy datetime)
   INT.TUT <- mutate(INT.TUT, 'PREV_WINDTIME' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))
   INT.TUT <- mutate(INT.TUT, 'NEXT_WINDTIME' = as.POSIXct("1980-01-25 07:00:00", tz = 'UTC'))
   
   # fetch the previous (index_mat above) and next windtimes (index_mat + 1).
   for (i in 1:nrow(INT.TUT)) {
     lookup_i                 <- INT.TUT$WIND_INDEX[i]
     INT.TUT[i]$PREV_WINDTIME <- W.TUT[lookup_i,1]
     INT.TUT[i]$NEXT_WINDTIME <- W.TUT[(lookup_i+1),1]	
   }
   
   # calculate hours since last, hours till next windtime. 
   INT.TUT <- mutate(INT.TUT, 'M_SINCE_PREV' = (as.numeric(INTERVIEW_TIME_UTC - PREV_WINDTIME)/60),
                     'M_TO_NEXT' = (as.numeric(NEXT_WINDTIME - INTERVIEW_TIME_UTC)))
   
   # add empty column to note the index to use
   INT.TUT <- mutate(INT.TUT, "USE_WINDTIME_INDEX"= -999)
   
   for (i in 1:nrow(INT.TUT)) {
     ifelse(INT.TUT$M_SINCE_PREV[i] < INT.TUT$M_TO_NEXT[i],
            INT.TUT$USE_WINDTIME_INDEX[i] <- INT.TUT$WIND_INDEX[i],
            INT.TUT$USE_WINDTIME_INDEX[i] <- INT.TUT$WIND_INDEX[i]+1)
   }
   
   # now we have the index of winds to use, pull in the data.
   INT.W.TUT <- mutate(INT.TUT, wspd = 999, wdir = 999, uwind = 999, vwind = 999)
   
   for (i in 1:nrow(INT.W.TUT)) {
     wind_i <- INT.W.TUT$USE_WINDTIME_INDEX[i]
     INT.W.TUT$wspd[i]  <- W.TUT$wspd[wind_i]
     INT.W.TUT$wdir[i]  <- W.TUT$wdir[wind_i]
     INT.W.TUT$uwind[i] <- W.TUT$uwind[wind_i]
     INT.W.TUT$vwind[i] <- W.TUT$vwind[wind_i]
   }
   
   # -- merge tutuila and manu'a interviews w/ winds back into the B dataset

	INT.W <- rbind(INT.W.TUT, INT.W.MAN)
	B     <- merge(B,INT.W,by="INTERVIEW_PK",all.x=T)

#  --------------------------------------------------------------------------------------------------------------
#  ENVIRONMENTAL DATA: LARGE SCALE INDICES

  # load largescale indices
   ENSO <- read.csv(paste(root_dir, "/data/ENSO.csv", sep=""), header=TRUE, stringsAsFactors=FALSE)
   ONI <- read.csv(paste(root_dir, "/data/ONI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)
   SOI <- read.csv(paste(root_dir, "/data/SOI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)

   #ENSO <- read.csv(paste(root_dir, "/Data/ENSO.csv", sep=""), header=TRUE, stringsAsFactors=FALSE)
   #ONI <- read.csv(paste(root_dir, "/Data/ONI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)
   #SOI <- read.csv(paste(root_dir, "/Data/SOI.csv", sep=""),header=TRUE, stringsAsFactors=FALSE)
   
   
  # do the merge in 3 steps
   string <- "SELECT B.*, ENSO.ENSO
		FROM B 
		LEFT JOIN ENSO 
			ON B.year_num = ENSO.Year
				AND B.month = ENSO.month_num
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
   rm(B)				#str(B)
   B <- bbs_ENSO_SOI_ONI


#  Final effort step
# --- add effort as num_gear x hours_fished
	B <- mutate(B, effort = HOURS_FISHED*NUM_GEAR)			#nrow(B)

   length(unique(B$INTERVIEW_PK))		# 3068 interviews

  # clean up workspace
  #	all_objs <- ls()
  #	save_objs <- c("aint_bbs_all_gears","aint_bbs_filtered","B","root_dir","B_before_ID_correct",
  #					"p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
  #					"p_amboinensis","p_rubrio")
  #	remove_objs <- setdiff(all_objs, save_objs)
  #  	rm(list=remove_objs)
  #	rm(save_objs)
  #	rm(remove_objs)
  #	rm(all_objs)

  # save.image(paste(root_dir, "/output/02_BBS_covariates.RData", sep=""))
	# save.image(paste(root_dir, "/Outputs/02_BBS_covariates.RData", sep=""))
	





































#  --------------------------------------------------------------------------------------------------------------
