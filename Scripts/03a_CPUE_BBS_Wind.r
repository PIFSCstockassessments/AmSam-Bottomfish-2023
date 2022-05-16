#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISHES
#   Erin Bohaboy erin.bohaboy@noaa.gov
#	UPDATE OCTOBER 2021
#	Fetch ocean winds data from NOAA Ocean Watch Central Pacific ERDDAP server
#	originally used monthly values, but switching to daily values because the monthly product stopped in 2019
#	https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.html (1988-2018)
#	https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-1-NRT.html (2019-2020)
#	
#	When I tried to update these data, there were troubles with the ERDDAP server. See long e-mail chain w/ 
#	Melanie Abecassis and Russell Price

#  --------------------------------------------------------------------------------------------------------------
   require(ncdf4); require(httr); require(dplyr); require(this.path); require(data.table)
   root_dir <- this.path::here(.. = 1)

#  originally I was downloading the .nc s through R, but something is wrong now. Instead, download the .ncs using the web interface, put them in the working directory,
#	then read into R.  
#	make sure to select ".nc" in the file type field
#	Note to Erin: Ta'u is about -14.25, -169.46. Pago Pago harbor is -14.28, -170.7.
#	so, in ERDDAP speak, that is longitude ranging from 180 + (180-169.46) to 180 + (180-170.7)
#	which is: Tutuila= 189.3, Ta'u = 190.5
#	so Tutu: -14.375, 189.375, Manu: -14.375, 190.625
#	use grid 189 to 191 deg. E, -13.5 to -15 deg. N, so we pull the .nc once and it covers both Tutu and Manu

# -------------   accessed Oct26, 2021
#  use version 2.1 (2.0 is deprecated) for 2019+

# -------------   accessed Mar24, 2022 to include all of 2021
#  modified end date for 2019-2021 griddap request below, re-run these next # lines and everything after.

# 	systime_i <- Sys.time()
# 	GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-1-NRT.nc?uwnd%5B(2019-01-01):1:(2022-01-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-01-01):1:(2022-01-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-01-01):1:(2022-01-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
# 	write_disk("winds_recent.nc", overwrite=TRUE))
# 	systime_f <- Sys.time()
# 	systime_f - systime_i

		nc    <- nc_open(paste0(root_dir,"/Data/Winds/winds_recent.nc"))
    uwnd  <- ncvar_get(nc,nc$var[[1]])
    v1    <- nc$var[[1]]
    vwnd  <- ncvar_get(nc,nc$var[[2]])
    v2    <- nc$var[[2]]
    dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
    lon   <- v1$dim[[1]]$vals 
    lat   <- v1$dim[[2]]$vals

# index the lon and lat that I want. This is goofy, but the only way I know how to do it is to look at the lon and lat objects
#		pick the index for the lon and lat closest to target
# chosen grid: Tutu: -14.375, 189.375, Manu: -14.375, 190.625
# tutu: lon[2], lat[3]
# manu: lon[7], lat[3]

# extract an array from the netcdf for each variable

    tutu_uwind <- as.numeric(uwnd[2,3,])
    tutu_vwind <- as.numeric(vwnd[2,3,])

  # calculated windspeed by 6 hour intervals, THEN average over day
    tutu1 <- data.frame('DT' = dates, 'UWIND' = tutu_uwind, 'VWIND' = tutu_vwind, 'LOCATION' = 'Tutuila')
    tutu2 <- mutate(tutu1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 
    
  #  save
    tutu_19_21 <- tutu2

# ---------------- repeat for the Manu'as
    manu_uwind <- as.numeric(uwnd[7,3,])
    manu_vwind <- as.numeric(vwnd[7,3,])

# calculated windspeed by 6 hour intervals, THEN average over day
    manu1 <- data.frame('DT' = dates, 'UWIND' = manu_uwind, 'VWIND' = manu_vwind, 'LOCATION' = 'Manua')
    manu2 <- mutate(manu1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 

#  save
    manu_19_21 <- manu2

#  -----------------------
#	download the older data, which is in a separate product
#   TROUBLE DOWNLOADING:	Even small queries were taking 30+ minutes to run, so Russel actually got some of these for me and sent them
#  ask for only the lat/lon I need
#  Tutu: -14.375, 189.375, Manu: -14.375, 190.625
#  Tutu 88-89
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1988-01-01):1:(1989-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(1988-01-01):1:(1989-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D

	nc   <- nc_open(paste0(root_dir,"/Data/Winds/tutu_88_89.nc"))
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1   <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2   <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 

	lon <- v1$dim[[1]]$vals 
	lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, VWIND, LOCATION, save it
	wind_1 <- data.frame('DT' = dates, 'UWIND' = uwnd, 'VWIND' = vwnd, 'LOCATION' = 'Tutuila')
	wind_2 <- mutate(wind_1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 

	#  save
	tutu_88_89 <- wind_2

#  Tutu 90-94
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1990-01-01):1:(1994-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(1990-01-01):1:(1994-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D
	nc   <- nc_open(paste0(root_dir,"/Data/Winds/tutu_90_94.nc"))
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1   <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2   <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	lon   <- v1$dim[[1]]$vals 
	lat   <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, VWIND, LOCATION, save it
	wind_1 <- data.frame('DT' = dates, 'UWIND' = uwnd, 'VWIND' = vwnd, 'LOCATION' = 'Tutuila')
	wind_2 <- mutate(wind_1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 

	#  save
	tutu_90_94 <- wind_2

#  Tutu 95-18
	nc   <- nc_open(paste0(root_dir,"/Data/Winds/tutu_95_18.nc"))
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1   <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2   <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	
	# lon <- v1$dim[[1]]$vals 
	# lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, VWIND, LOCATION, save it
	wind_1 <- data.frame('DT' = dates, 'UWIND' = uwnd, 'VWIND' = vwnd, 'LOCATION' = 'Tutuila')
	wind_2 <- mutate(wind_1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 

	#  save
	tutu_95_18 <- wind_2

#  Manu'as 1988-2018. Send this link to Russell
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1988-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(190.625):1:(190.625)%5D,vwnd%5B(1988-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(190.625):1:(190.625)%5D
#  Melanie downloaded it for me.

	nc   <- nc_open(paste0(root_dir,"/Data/Winds/manu_88_18.nc"))
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1   <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2   <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	
	lon <- v1$dim[[1]]$vals 
	lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, VWIND, LOCATION, save it
	wind_1 <- data.frame('DT' = dates, 'UWIND' = uwnd, 'VWIND' = vwnd, 'LOCATION' = 'Manua')
	wind_2 <- mutate(wind_1, WSPD = sqrt((UWIND)^2 + (VWIND)^2), dt_char = as.character(DT)) 

	#  save
	manu_88_18 <- wind_2

#  rbind all the datasets
wind     <- rbind(manu_19_21, manu_88_18, tutu_19_21,tutu_88_89, tutu_90_94, tutu_95_18)
windsort <- wind[order(wind$LOCATION, wind$dt_char), ]

#  calculate wind direction in degrees.
# x and y are rotated for math (I confirmed this with Melanie)
# zonal = e-w = u (y), meriodinal = n-s = v (x)
windsort2 <- mutate(windsort, wdir = 180 + (180/pi)*(atan2(UWIND, VWIND)))

# save it
W <- as.data.table(windsort2)
#saveRDS(W,paste0(root_dir, "/Outputs/CPUE_Winds.rds"))

#======================Add this wind data to the CPUE file with other covariates==============================================
#W   <- readRDS(paste0(root_dir, "//Outputs/CPUE_Winds.rds")) # load 6 hour wind_data (from Get_Wind.R script).

#  ENVIRONMENTAL DATA: WINDS
#    do this working with interview only
#    Note: Pago Pago is 14.28 deg S, 170.7 deg W (-14.28, -170.7).
B   <- readRDS(paste0(root_dir, "/Outputs/CPUE_B.rds"))
INT <- B[,list(N=.N),by=list(INTERVIEW_PK,YEAR,INTERVIEW_TIME_LOCAL,INTERVIEW_TIME_UTC,AREA_C)]

# -- Do "nearest neighbor" merge on INTERVIEW_TIME_UTC:   I don't know of a simpler way to do this.

# MANU'A ISLANDS
#	note: they didn't routinely record the interview time in the Manua's until 2003
#		so, interview time appears to always be set to midnight local time, 11 am UTC.	

INT.MAN <- INT[AREA_C == 'Manua']		
INT.MAN <- INT.MAN[order(INTERVIEW_TIME_UTC)] 
W.MAN   <- W[LOCATION == 'Manua']
W.MAN   <- W.MAN[order(DT)]	
INT.MAN <- INT.MAN[YEAR > 1987]	# Remove 1986 and 1987 from the interview list because we don't have wind data before 1988

# findInterval will return the vector of indices for the closest without being under. I.e., the most recent DT.
INDEX.MAT <- findInterval(INT.MAN$INTERVIEW_TIME_UTC,W.MAN$DT)
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
INT.W.MAN <- mutate(INT.MAN, WSPD = 999, wdir = 999, UWIND = 999, VWIND = 999)

for (i in 1:nrow(INT.W.MAN)) {
  wind_i <- INT.W.MAN$USE_WINDTIME_INDEX[i]
  INT.W.MAN$WSPD[i]  <- W.MAN$WSPD[wind_i]
  INT.W.MAN$wdir[i]  <- W.MAN$wdir[wind_i]
  INT.W.MAN$UWIND[i] <- W.MAN$UWIND[wind_i]
  INT.W.MAN$VWIND[i] <- W.MAN$VWIND[wind_i]
}


# TUTUILA

INT.TUT <- INT[AREA_C == 'Tutuila']		
INT.TUT <- INT.TUT[order(INTERVIEW_TIME_UTC)] 
W.TUT   <- W[LOCATION == 'Tutuila']
W.TUT   <- W.TUT[order(DT)]	
INT.TUT <- INT.TUT[YEAR > 1987]	# Remove 1986 and 1987 from the interview list because we don't have wind data before 1988

# findInterval will return the vector of indices for the closest without being under. I.e., the most recent DT.
INDEX.MAT <- findInterval(INT.TUT$INTERVIEW_TIME_UTC,W.TUT$DT)
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
INT.W.TUT <- mutate(INT.TUT, WSPD = 999, wdir = 999, UWIND = 999, VWIND = 999)

for (i in 1:nrow(INT.W.TUT)) {
  wind_i <- INT.W.TUT$USE_WINDTIME_INDEX[i]
  INT.W.TUT$WSPD[i]  <- W.TUT$WSPD[wind_i]
  INT.W.TUT$wdir[i]  <- W.TUT$wdir[wind_i]
  INT.W.TUT$UWIND[i] <- W.TUT$UWIND[wind_i]
  INT.W.TUT$VWIND[i] <- W.TUT$VWIND[wind_i]
}

# -- merge tutuila and manu'a interviews w/ winds back into the B dataset

INT.W <- rbind(INT.W.TUT, INT.W.MAN)
INT.W <- select(INT.W,INTERVIEW_PK,WINDSPEED=WSPD,WINDDIR=wdir,)

length(unique(INT.W$INTERVIEW_PK)) # 2329 interviews, since seems to be missing Banks and others
saveRDS(INT.W,paste0(root_dir, "/Outputs/CPUE_WIND.rds"))

	

