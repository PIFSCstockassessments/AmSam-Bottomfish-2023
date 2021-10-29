#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA DATA REPORT
#	UPDATE OCTOBER 2021
#	Fetch ocean winds data from NOAA Ocean Watch Central Pacific ERDDAP server
#	originally used monthly values, but switching to daily values because the monthly product stopped in 2019
#	https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.html (1988-2018)
#	https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-1-NRT.html (2019-2020)
#	
#	When I tried to update these data, there were troubles with the ERDDAP server. See long e-mail chain w/ 
#		Melanie Abacassis and Russell Price
#	  FYI- the https is just a proxy for the ERDDAP. In Russell's words:
#		"when a request for data is issued to the Tomcat server (which runs ERDDAP), Tomcat then hands that request off to a 
#		background process that executes it. Tomcat doesn't monitor that process, and has no control over it once it is initiated. 
#		If the connection with the initiating client times out, it doesn't matter. The back-end task keeps running, using CPU and 
#		memory. [...] The more processes that are running, using up memory and CPU, the slower everything runs. Even though some 
#		of those processes would no longer be able to return results to the client (due to communications timeout), they keep 
#		running until completion. They become, for want of a better term, "zombies": shambling onwards without purpose."

#  --------------------------------------------------------------------------------------------------------------

# install.packages('ncdf4') 
# install.packages('httr')

rm(list=ls())
library(ncdf4)
library(httr)
library(dplyr)

#  originally I was downloading the .nc s through R
#	but something is wrong now. Instead, download the .ncs using the web interface, put them in the working directory,
#	then read into R.
#  
#	make sure to select ".nc" in the file type field
#	Note to Erin: Tau is about -14.25, -169.46. Pago Pago harbor is -14.28, -170.7.
#	so, in ERDDAP speak, that is longitude ranging from 180 + (180-169.46) to 180 + (180-170.7)
#	which is: Tutu'ila= 189.3, Ta'u = 190.5
#	so Tutu: -14.375, 189.375, Manu: -14.375, 190.625
#	use grid 189 to 191 deg. E, -13.5 to -15 deg. N, so we pull the .nc once and it covers both Tutu and Manu

setwd('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Environmental Data')

# -------------   accessed Oct26, 2021
#  use version 2.1 (2.0 is deprecated) for 2019+

# 	systime_i <- Sys.time()
# 	GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-1-NRT.nc?uwnd%5B(2019-01-01):1:(2021-10-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-01-01):1:(2021-10-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-01-01):1:(2021-10-25T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
# 	write_disk("winds_recent.nc", overwrite=TRUE))
# 	systime_f <- Sys.time()
# 	systime_f - systime_i
nc <- nc_open("winds_recent.nc")

uwnd <- ncvar_get(nc,nc$var[[1]])
v1 <- nc$var[[1]]
vwnd <- ncvar_get(nc,nc$var[[2]])
v2 <- nc$var[[2]]

dim(uwnd)		#remember: lon, lat, time

dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 

lon <- v1$dim[[1]]$vals 
lat <- v1$dim[[2]]$vals


# index the lon and lat that I want
#  this is goofy, but the only way I know how to do it is to look at the lon and lat objects
#		pick the index for the lon and lat closest to target
# chosen grid: Tutu: -14.375, 189.375, Manu: -14.375, 190.625
# tutu: lon[2], lat[3]
# manu: lon[7], lat[3]

# extract an array from the netcdf for each variable

tutu_uwind <- as.numeric(uwnd[2,3,])
tutu_vwind <- as.numeric(vwnd[2,3,])

# calculated windspeed by 6 hour intervals, THEN average over day
tutu1 <- data.frame('dt' = dates, 'uwind' = tutu_uwind, 'vwind' = tutu_vwind, 'location' = 'tutu')
str(tutu1)
tutu2 <- mutate(tutu1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 
head(tutu2)

#  save
tutu_19_21 <- tutu2


# ---------------- repeat for the Manu'as

manu_uwind <- as.numeric(uwnd[7,3,])
manu_vwind <- as.numeric(vwnd[7,3,])

# calculated windspeed by 6 hour intervals, THEN average over day
manu1 <- data.frame('dt' = dates, 'uwind' = manu_uwind, 'vwind' = manu_vwind, 'location' = 'manu')
manu2 <- mutate(manu1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 

#  save
manu_19_21 <- manu2


#  -----------------------
#	download the older data, which is in a separate product
#   TROUBLE DOWNLOADING
#	Even small queries were taking 30+ minutes to run, so Russel actually got some of these for me and sent them
#  ask for only the lat/lon I need

#  Tutu: -14.375, 189.375, Manu: -14.375, 190.625

#  Tutu 88-89
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1988-01-01):1:(1989-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(1988-01-01):1:(1989-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D

	rm(nc)
	nc <- nc_open("tutu_88_89.nc")
	dim(nc)
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1 <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2 <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 

	lon <- v1$dim[[1]]$vals 
	lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, vwind, location, save it
	wind_1 <- data.frame('dt' = dates, 'uwind' = uwnd, 'vwind' = vwnd, 'location' = 'tutu')
	str(wind_1)
	wind_2 <- mutate(wind_1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 

	#  save
	tutu_88_89 <- wind_2


#  Tutu 90-94
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1990-01-01):1:(1994-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(1990-01-01):1:(1994-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D

	rm(nc)
	nc <- nc_open("tutu_90_94.nc")
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1 <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2 <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	head(dates)
	tail(dates)

	lon <- v1$dim[[1]]$vals 
	lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, vwind, location, save it
	wind_1 <- data.frame('dt' = dates, 'uwind' = uwnd, 'vwind' = vwnd, 'location' = 'tutu')
	str(wind_1)
	wind_2 <- mutate(wind_1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 

	#  save
	tutu_90_94 <- wind_2


#  Tutu 95-18

	rm(nc)
	nc <- nc_open("tutu_95_18.nc")
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1 <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2 <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	head(dates)
	tail(dates)

	# lon <- v1$dim[[1]]$vals 
	# lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, vwind, location, save it
	wind_1 <- data.frame('dt' = dates, 'uwind' = uwnd, 'vwind' = vwnd, 'location' = 'tutu')
	str(wind_1)
	wind_2 <- mutate(wind_1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 

	#  save
	tutu_95_18 <- wind_2


#  save these
#  rm(list=ls()[7])

#  save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\Updated_Wind_29Oct.RData")
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\Updated_Wind_29Oct.RData")


#  Manu'as 1988-2018. Send this link to Russell
#  https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1988-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(190.625):1:(190.625)%5D,vwnd%5B(1988-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(190.625):1:(190.625)%5D
#  Melanie downloaded it for me.

	rm(nc)
	nc <- nc_open("manu_88_18.nc")
	uwnd <- ncvar_get(nc,nc$var[[1]])
	v1 <- nc$var[[1]]
	vwnd <- ncvar_get(nc,nc$var[[2]])
	v2 <- nc$var[[2]]

	dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
	head(dates)
	tail(dates)

	lon <- v1$dim[[1]]$vals 
	lat <- v1$dim[[2]]$vals

	# make a dataframe with date, uwnd, vwind, location, save it
	wind_1 <- data.frame('dt' = dates, 'uwind' = uwnd, 'vwind' = vwnd, 'location' = 'manu')
	str(wind_1)
	wind_2 <- mutate(wind_1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 

	#  save
	manu_88_18 <- wind_2


#  rbind all the datasets

head(manu_19_21)
head(manu_88_18)
head(tutu_19_21)
head(tutu_88_89)
head(tutu_90_94)
head(tutu_95_18)

wind <- rbind(manu_19_21, manu_88_18, tutu_19_21,
			tutu_88_89, tutu_90_94, tutu_95_18)
str(wind)

windsort <- wind[order(wind$location, wind$dt_char), ]
head(windsort)
tail(windsort)



#  calculate wind direction in degrees.
# x and y are rotated for math (I confirmed this with Melanie)
# zonal = e-w = u (y), meriodinal = n-s = v (x)

windsort2 <- mutate(windsort, wdir = 180 + (180/pi)*(atan2(uwind, vwind)))
head(windsort2)
View(windsort2[1:500,])

# save it
wind_6h <- windsort2
str(wind_6h)































#   -------------------  old code  --------------
# add wind

#average over day
wind_3 <- mutate(wind_2, dt_year = as.numeric(substr(dt_char, 1, 4)), dt_month = as.character(substr(dt_char, 6, 7)), 
		dt_day = as.character(substr(dt_char, 9, 10)))
head(tutu3)

uwnd_daily <- aggregate(uwind ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)
vwnd_daily <- aggregate(vwind ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)
wspd_daily <- aggregate(wspd ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)

# put back together the daily average uwnd, vwnd, and wspd, then rebuild a dataframe with a posix datetime field
tutu4A <- merge(uwnd_daily,vwnd_daily,by=c('dt_year','dt_month','dt_day'))
tutu4B <- merge(tutu4A,wspd_daily, by=c('dt_year','dt_month','dt_day'))

tutu5 <- mutate(tutu4B, dt_char = paste(dt_year, "-" , dt_month, "-", dt_day, " 12:00:00",sep=""))
tutu6 <- mutate(tutu5, dt = as.POSIXct(dt_char,tz='UTC'), 'location' = 'tutu')
head(tutu6)

#  save this
tutu_daily_recent <- tutu6








winds_old    <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1987-09-01):1:(2019-04-29T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(1987-09-01):1:(2019-04-29T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(1987-09-01):1:(2019-04-29T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
write_disk("winds_old.nc", overwrite=TRUE))


winds_1    <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(2010-01-01):1:(2017-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2010-01-01):1:(2017-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
write_disk("winds_1.nc", overwrite=TRUE))


#  NOT WORKING ---- TRY AGAIN TOMORROW

#  try it in pieces
# 1987 - 1Jan1995

winds_1    <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1987-07-10):1:(1995-01-01)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(1987-07-10):1:(1995-01-01)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(1987-07-10):1:(1995-01-01)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
write_disk("winds_1.nc", overwrite=TRUE))

systime_i <- Sys.time()
winds_tutu_2018C    <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(2018-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(2018-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D',
write_disk("winds_tutu_2018C.nc", overwrite=TRUE))
systime_f <- Sys.time()
systime_f - systime_i


systime_i <- Sys.time()
winds_tutu_2018B    <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(2010-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D,vwnd%5B(2010-01-01):1:(2018-12-31)%5D%5B(-14.375):1:(-14.375)%5D%5B(189.375):1:(189.375)%5D',
write_disk("winds_tutu_2010_2018.nc", overwrite=TRUE))
systime_f <- Sys.time()
systime_f - systime_i


rm(nc)
nc <- nc_open("winds_old.nc")


uwnd <- ncvar_get(nc,nc$var[[1]])
v1 <- nc$var[[1]]
vwnd <- ncvar_get(nc,nc$var[[2]])
v2 <- nc$var[[2]]

dim(uwnd)		#remember: lon, lat, time

dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 

lon <- v1$dim[[1]]$vals 
lat <- v1$dim[[2]]$vals










both6 <- rbind(tutu6, manu6)

#  calculate wind direction in degrees.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)

both7 <- mutate(both6, wdir = 180 + (180/pi)*(atan2(uwind, vwind)))
head(both7)

wind_daily <- data.frame('dt' = both7$dt, 'wspd' = both7$wspd, 'wdir' = both7$wdir, 'uwind' = both7$uwind, 'vwind' = both7$vwind, 
			'location' = both7$location)


# put together with the 1987-2019 monthly wind product, clean up workspace, save

wind_data_complete <- rbind(wind_data, wind_daily)

# rm(list=ls()[2:5])

save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\Wind_Data.RData")

max(wind_data_complete$wspd)

plot_me <- subset(wind_data_complete, location == 'tutu')
plot(plot_me$dt, plot_me$wspd, type="p", ylim=c(0,10))
plot_me <- subset(wind_data_complete, location == 'manu')
points(plot_me$dt, plot_me$wspd, col="red")


uwnd <- ncvar_get(nc,nc$var[[1]])
vwnd <- ncvar_get(nc,nc$var[[2]])
dim(uwnd)			#remember: lon, lat, time
dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
lon <- v1$dim[[1]]$vals 
lat <- v1$dim[[2]]$vals


# index the lon and lat that I want
#  this is goofy, but the only way I know how to do it is to look at the lon and lat objects
#		pick the index for the lon and lat closest to target
# tutu: lon[2], lat[3]
# manu: lon[7], lat[3]

# just peel out each as an array
tutu_uwind <- as.numeric(uwnd[2,3,])
tutu_vwind <- as.numeric(vwnd[2,3,])

#  calculate wind direction in degrees. draw this on a piece of paper to make sure I'm doing this right.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)
#  I checked this with Melanie and she said it was correct

tutu_wdir <- 180 + (180/pi)*(atan2(tutu_uwind, tutu_vwind))
head(tutu_wdir)

tutu_wind <- data.frame('dt' = dates, 'wspd' = tutu_wspd, 'wdir' = tutu_wdir, 'uwind' = tutu_uwind, 'vwind' = tutu_vwind, 'location' = 'tutu')
head(tutu_wind)


#  repeat for manu

manu_wspd <- as.numeric(wspd[23,3,])
manu_uwind <- as.numeric(uwnd[23,3,])
manu_vwind <- as.numeric(vwnd[23,3,])

#  calculate wind direction in degrees. draw this on a piece of paper to make sure I'm doing this right.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)

manu_wdir <- 180 + (180/pi)*(atan2(manu_uwind, manu_vwind))
head(manu_wdir)

manu_wind <- data.frame('dt' = dates, 'wspd' = manu_wspd, 'wdir' = manu_wdir, 'uwind' = manu_uwind, 'vwind' = manu_vwind, 'location' = 'manu')
head(manu_wind)


plot(tutu_wind$dt, tutu_wind$wspd, type = "l")
lines(manu_wind$dt, manu_wind$wspd, col="red")

plot(tutu_wind$dt, tutu_wind$wdir, type = "p")
points(manu_wind$dt, manu_wind$wdir, col="red")

wind_data <- rbind(tutu_wind, manu_wind)
tail(wind_data)







tutu3 <- mutate(tutu2, dt_year = as.numeric(substr(dt_char, 1, 4)), dt_month = as.character(substr(dt_char, 6, 7)), 
		dt_day = as.character(substr(dt_char, 9, 10)))
head(tutu3)

uwnd_daily <- aggregate(uwind ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)
vwnd_daily <- aggregate(vwind ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)
wspd_daily <- aggregate(wspd ~ dt_year + dt_month + dt_day, data = tutu3, FUN = mean)

# put back together the daily average uwnd, vwnd, and wspd, then rebuild a dataframe with a posix datetime field
tutu4A <- merge(uwnd_daily,vwnd_daily,by=c('dt_year','dt_month','dt_day'))
tutu4B <- merge(tutu4A,wspd_daily, by=c('dt_year','dt_month','dt_day'))

tutu5 <- mutate(tutu4B, dt_char = paste(dt_year, "-" , dt_month, "-", dt_day, " 12:00:00",sep=""))
tutu6 <- mutate(tutu5, dt = as.POSIXct(dt_char,tz='UTC'), 'location' = 'tutu')
head(tutu6)

#  save this
tutu_daily_recent <- tutu6



manu3 <- mutate(manu2, dt_year = as.numeric(substr(dt_char, 1, 4)), dt_month = as.character(substr(dt_char, 6, 7)), 
		dt_day = as.character(substr(dt_char, 9, 10)))
head(manu3)

uwnd_daily <- aggregate(uwind ~ dt_year + dt_month + dt_day, data = manu3, FUN = mean)
vwnd_daily <- aggregate(vwind ~ dt_year + dt_month + dt_day, data = manu3, FUN = mean)
wspd_daily <- aggregate(wspd ~ dt_year + dt_month + dt_day, data = manu3, FUN = mean)

# put back together the daily average uwnd, vwnd, and wspd, then rebuild a dataframe with a posix datetime field
manu4A <- merge(uwnd_daily,vwnd_daily,by=c('dt_year','dt_month','dt_day'))
manu4B <- merge(manu4A,wspd_daily, by=c('dt_year','dt_month','dt_day'))

manu5 <- mutate(manu4B, dt_char = paste(dt_year, "-" , dt_month, "-", dt_day, " 12:00:00",sep=""))
manu6 <- mutate(manu5, dt = as.POSIXct(dt_char,tz='UTC'), 'location' = 'manu')
head(manu6)












winds_daily_87_18 <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.nc?uwnd%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
write_disk("winds_daily_87_18.nc", overwrite=TRUE))

nc=nc_open('winds.nc')

winds_daily_87_18 <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0.htmlTable?uwnd%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(1987-07-10):1:(2018-12-31)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D',
write_disk("winds_daily_87_18.nc", overwrite=TRUE))



winds_daily <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0-NRT.nc?uwnd%5B(2019-04-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-4-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-4-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D', 
			write_disk("winds_daily_26Oct.nc", overwrite=TRUE))
nc <- nc_open("winds_daily_26Oct.nc")

winds_daily <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0-NRT.nc?uwnd%5B(2019-05-01T00:01:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-05-01T00:01:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-05-01T00:01:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D', 
			write_disk("winds_daily_try_again.nc", overwrite=TRUE))







# winds <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-monthly-v2-0.nc?uwnd%5B(1987-08-01T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D,vwnd%5B(1988-04-01T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D,wspd%5B(1988-04-01T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D', 
#			write_disk("winds.nc", overwrite=TRUE))

winds <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-monthly-v2-0.nc?uwnd%5B(1987-08-15T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D,vwnd%5B(1987-08-15T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D,wspd%5B(1987-08-15T09:00:00Z):1:(2019-04-15T09:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(185):1:(195)%5D', 
			write_disk("winds.nc", overwrite=TRUE))

nc=nc_open('winds.nc')

names(nc$var)			#str(v3$dim[[3]]$vals)


wspd <- ncvar_get(nc,nc$var[[3]])
# define nc$var[[3]] as v3
v3 <- nc$var[[3]]

dim(wspd)		#remember: lon, lat, time

dates <- as.POSIXlt(v3$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
dates


lon=v3$dim[[1]]$vals 
lat=v3$dim[[2]]$vals

uwnd <- ncvar_get(nc,nc$var[[1]])
vwnd <- ncvar_get(nc,nc$var[[2]])

# index the long and lat that I want
# tutu: lon[18], lat[3]
# manu: lon[23], lat[3]

# just peel out each as an array

tutu_wspd <- as.numeric(wspd[18,3,])
tutu_uwind <- as.numeric(uwnd[18,3,])
tutu_vwind <- as.numeric(vwnd[18,3,])

#  calculate wind direction in degrees. draw this on a piece of paper to make sure I'm doing this right.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)

tutu_wdir <- 180 + (180/pi)*(atan2(tutu_uwind, tutu_vwind))
head(tutu_wdir)

tutu_wind <- data.frame('dt' = dates, 'wspd' = tutu_wspd, 'wdir' = tutu_wdir, 'uwind' = tutu_uwind, 'vwind' = tutu_vwind, 'location' = 'tutu')
head(tutu_wind)


#  repeat for manu

manu_wspd <- as.numeric(wspd[23,3,])
manu_uwind <- as.numeric(uwnd[23,3,])
manu_vwind <- as.numeric(vwnd[23,3,])

#  calculate wind direction in degrees. draw this on a piece of paper to make sure I'm doing this right.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)

manu_wdir <- 180 + (180/pi)*(atan2(manu_uwind, manu_vwind))
head(manu_wdir)

manu_wind <- data.frame('dt' = dates, 'wspd' = manu_wspd, 'wdir' = manu_wdir, 'uwind' = manu_uwind, 'vwind' = manu_vwind, 'location' = 'manu')
head(manu_wind)


plot(tutu_wind$dt, tutu_wind$wspd, type = "l")
lines(manu_wind$dt, manu_wind$wspd, col="red")

plot(tutu_wind$dt, tutu_wind$wdir, type = "p")
points(manu_wind$dt, manu_wind$wdir, col="red")

wind_data <- rbind(tutu_wind, manu_wind)
tail(wind_data)



# unfortunately, CCMP monthly winds stops in April 2019. 
#  since then, it is a daily dataset. So if we want the last months of 2019 (and eventually 2020) to go with our data,
#		we have to do all that over again. But this time, we have to do the monthly averaging ourselves. *groan
#	also, I heard back from Melanie who asked Carl Mears about the discrepancies between uwind,vwind calculated windspeed
#		and the windspeeds provided in the monthly product. He said:
#			"To get the monthly averaged wind speed, the wind speed is calculated separately for each 6-hourly map, and then the 
#			speeds are averaged over the month."
#	so I will do my best to replicate that for the end of 2019

setwd('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Environmental Data')

# winds_daily <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0-NRT.nc?uwnd%5B(2019-01-05T18:00:00Z):5:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-01-05T18:00:00Z):5:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-01-05T18:00:00Z):5:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D', 
#			write_disk("winds_daily.nc", overwrite=TRUE))

# accessed Feb15, 2021
# winds_daily <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0-NRT.nc?uwnd%5B(2019-04-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(2019-4-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(2019-4-15T9:00:00Z):1:(2020-10-04T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D', 
#			write_disk("winds_daily.nc", overwrite=TRUE))

winds_daily <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/ccmp-daily-v2-0-NRT.nc?uwnd%5B(1987-07-10T00:01:00Z):1:(2021-01-01T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,vwnd%5B(1987-07-10T00:01:00Z):1:(2021-01-01T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D,nobs%5B(1987-07-10T00:01:00Z):1:(2021-01-01T18:00:00Z)%5D%5B(-15):1:(-13.5)%5D%5B(189):1:(191)%5D', 
			write_disk("winds_daily.nc", overwrite=TRUE))

1987-07-10

nc=nc_open('winds_daily.nc')
names(nc$var)

uwnd <- ncvar_get(nc,nc$var[[1]])
v1 <- nc$var[[1]]

vwnd <- ncvar_get(nc,nc$var[[2]])
v2 <- nc$var[[2]]

dim(uwnd)		#remember: lon, lat, time

dates <- as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 
dates

lon=v1$dim[[1]]$vals 
lat=v1$dim[[2]]$vals

uwnd <- ncvar_get(nc,nc$var[[1]])
vwnd <- ncvar_get(nc,nc$var[[2]])
nobs <- ncvar_get(nc,nc$var[[3]])

# index the long and lat that I want
# chosen grid: Tutu: -14.375, 189.375, Manu: -14.375, 190.625
# tutu: lon[2], lat[3]
# manu: lon[7], lat[3]

# just peal out each as an array

tutu_uwind <- as.numeric(uwnd[2,3,])
tutu_vwind <- as.numeric(vwnd[2,3,])

#  I took a look at nobs. It is often zero, even for many neighboring grid cells. I am not sure what that means. Ask Phoebe maybe.
# tutu_nobs <- as.numeric(nobs[2,3,])

#  update 15Feb
#	calculated windspeed by 6 hour intervals, THEN average over month

tutu1 <- data.frame('dt' = dates, 'uwind' = tutu_uwind, 'vwind' = tutu_vwind, 'location' = 'tutu')
str(tutu1)
tutu2 <- mutate(tutu1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 
str(tutu2)
tutu3 <- mutate(tutu2, dt_year = as.numeric(substr(dt_char, 1, 4)), dt_month = as.character(substr(dt_char, 6, 7)))
head(tutu3)

uwnd_monthly <- aggregate(uwind ~ dt_year + dt_month, data = tutu3, FUN = mean)
vwnd_monthly <- aggregate(vwind ~ dt_year + dt_month, data = tutu3, FUN = mean)
wspd_monthly <- aggregate(wspd ~ dt_year + dt_month, data = tutu3, FUN = mean)

# put back together, rebuild a posix dt
tutu4A <- merge(uwnd_monthly,vwnd_monthly,by=c('dt_year','dt_month'))
tutu4B <- merge(tutu4A,wspd_monthly, by=c('dt_year','dt_month'))

tutu5 <- mutate(tutu4B, dt_char = paste(dt_year, "-" , dt_month, "-15 12:00:00",sep=""))
tutu6 <- mutate(tutu5, dt = as.POSIXct(dt_char,tz='UTC'), 'location' = 'tutu')


#  repeat for manu

manu_uwind <- as.numeric(uwnd[7,3,])
manu_vwind <- as.numeric(vwnd[7,3,])

manu1 <- data.frame('dt' = dates, 'uwind' = manu_uwind, 'vwind' = manu_vwind, 'location' = 'manu')
str(manu1)
manu2 <- mutate(manu1, wspd = sqrt((uwind)^2 + (vwind)^2), dt_char = as.character(dt)) 
str(manu2)
manu3 <- mutate(manu2, dt_year = as.numeric(substr(dt_char, 1, 4)), dt_month = as.character(substr(dt_char, 6, 7)))
head(manu3)

uwnd_monthly <- aggregate(uwind ~ dt_year + dt_month, data = manu3, FUN = mean)
vwnd_monthly <- aggregate(vwind ~ dt_year + dt_month, data = manu3, FUN = mean)
wspd_monthly <- aggregate(wspd ~ dt_year + dt_month, data = manu3, FUN = mean)


# put back together, rebuild a posix dt
manu4A <- merge(uwnd_monthly,vwnd_monthly,by=c('dt_year','dt_month'))
manu4B <- merge(manu4A,wspd_monthly, by=c('dt_year','dt_month'))

manu5 <- mutate(manu4B, dt_char = paste(dt_year, "-" , dt_month, "-15 12:00:00",sep=""))
manu6 <- mutate(manu5, dt = as.POSIXct(dt_char,tz='UTC'), 'location' = 'manu')

both6 <- rbind(tutu6, manu6)

#  calculate wind direction in degrees.
# x and y are rotated for math
# zonal = e-w = u (y), meriodinal = n-s = v (x)

both7 <- mutate(both6, wdir = 180 + (180/pi)*(atan2(uwind, vwind)))
head(both7)

wind_daily <- data.frame('dt' = both7$dt, 'wspd' = both7$wspd, 'wdir' = both7$wdir, 'uwind' = both7$uwind, 'vwind' = both7$vwind, 
			'location' = both7$location)


# put together with the 1987-2019 monthly wind product, clean up workspace, save

wind_data_complete <- rbind(wind_data, wind_daily)

# rm(list=ls()[2:5])

save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Environmental Data\\Wind_Data.RData")

max(wind_data_complete$wspd)

plot_me <- subset(wind_data_complete, location == 'tutu')
plot(plot_me$dt, plot_me$wspd, type="p", ylim=c(0,10))
plot_me <- subset(wind_data_complete, location == 'manu')
points(plot_me$dt, plot_me$wspd, col="red")

# the important thing is that there is no clear anomaly starting May 2019 when we switch datasets 
#	(which there was before)

plot_me <- subset(wind_data_complete, location == 'tutu')
plot(plot_me$dt, plot_me$wdir, type="p")
plot_me <- subset(wind_data_complete, location == 'manu')
points(plot_me$dt, plot_me$wdir, col="red")

# export the dataset so we have a .csv

write.csv(wind_data_complete, file = "wind_data_complete_16Feb.csv")


























#  ---------------------------  OLD
#  drop jan, feb, mar, apr 2019 from this dataset so we don't have redundant data with the monthly dataset.
#	double check to make sure they are similar. 

#  wind_daily:
#                     dt     wspd      wdir      uwind      vwind location
#  1 2019-01-15 12:00:00 1.218105  29.16728 -0.5936568 -1.0636499     tutu
#  2 2019-02-15 12:00:00 2.662766  26.02341 -1.1682574 -2.3928013     tutu
#  3 2019-03-15 12:00:00 3.455329 100.70233 -3.3952249  0.6416771     tutu
#  4 2019-04-15 12:00:00 3.132433  83.19072 -3.1103376 -0.3713964     tutu
#  
#  wind_data:
#  70 2019-01-16 09:00:00 4.288715  19.392629 -0.54198468 -1.539681077     tutu
#  371 2019-02-14 21:00:00 5.712752  16.756425 -1.01369119 -3.366759062     tutu
#  372 2019-03-16 09:00:00 4.692858 105.277689 -3.60706449  0.985271633     tutu
#  373 2019-04-15 09:00:00 4.514911  85.999034 -3.00721788 -0.210336104     tutu

# they are slightly different, uwind and vwind are similar, probably slight averaging differences 

# wind_data_2 <- mutate(wind_data, calc_wspd = (uwind^2 + vwind^2)^(1/2))
# head(wind_data_2)

# BUT calculated wspd from uwind and vwind are definitely not the same as the given wspd in the monthly averaged data.
#  I e-mailed Phoebe/Melanie and hopefully they will have an idea	

# str(wind_data)
# str(wind_daily)

# drop the jan-apr 2019 data from wind_daily. Do this with indexing. CAUTION.
# drop rows 23-26, 1-4

# wind_daily_trim <- wind_daily[-c(23,24,25,26),]
# wind_daily_trim <- wind_daily_trim[-c(1,2,3,4),]



#  --------------------------------------------------------------------------------------------------------------

