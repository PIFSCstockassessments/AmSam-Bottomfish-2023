#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISHES
#	CPUE: make violin plots of lbs/hour vs. num_gear and various other combos of effort
#	use sum catch for bottomfishing gear, btm/trl, both.

#  --------------------------------------------------------------------------------------------------------------


#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
	library(vioplot)	

# initial boat-based survey data prep includes filtering weird records, removing incomplete interviews,
#		filtering for gear types, etc. as well as addition of possible CPUE covariates was done in 'BBS_data_prep_Oct29.R'
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")


setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE")

nrow(bbs_3C)		# 49209 records
				#  colnames(bbs_3C)


# total lbs per interview, all species
	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as tot_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C)
			GROUP BY INTERVIEW_PK
			"
	int_tot_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(int_tot_catch)		#3066 interviews


# list bottomfishing interviews with total pounds per interview, num_gear, hours_fished for 1988-2020
#	eliminate anomalous records by excluding number of gears 10 and greater

	string <- "SELECT INTERVIEW_PK, year_num, HOURS_FISHED, NUM_GEAR, sum(EST_LBS) as tot_lbs
			FROM
			  (SELECT DISTINCT INTERVIEW_PK, year_num, CATCH_PK, HOURS_FISHED, NUM_GEAR, EST_LBS
				FROM bbs_3C
				WHERE year_num > 1987 AND year_num < 2021 AND FISHING_METHOD = 'BOTTOMFISHING' AND NUM_GEAR < 10)
			GROUP BY INTERVIEW_PK"
	ints_lbs <- sqldf(string, stringsAsFactors=FALSE)		# str(ints_lbs)	#2,122 interviews	

# drop any records with NAs now for simplicity
ints_lbs <- na.omit(ints_lbs)							#2,108 interviews	#summary(ints_lbs)

# how many zero catches?
nrow(subset(ints_lbs, tot_lbs == 0))					# 1 zero catch trip. eliminate.
ints_lbs <- subset(ints_lbs, tot_lbs > 0)					

ints_lbs <- mutate(ints_lbs, lbs_hour = tot_lbs / HOURS_FISHED, lbs_gear = tot_lbs/NUM_GEAR, 
				lbs_gear_hour = tot_lbs/(HOURS_FISHED*NUM_GEAR))		# summary(ints_lbs)
ints_lbs <- mutate(ints_lbs, NUM_GEAR_fac = as.factor(NUM_GEAR))		#summary(ints_lbs$lbs_hour)
summary(ints_lbs$NUM_GEAR_fac)		# there was only 1 interview for each num_gear = 8 and 9. So, drop those.
ints_lbs <- subset(ints_lbs, NUM_GEAR < 8)				# str(ints_lbs)	#2,105 interviews		


# repeat to investigate HOURS_FISHED
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_fac = as.factor(HOURS_FISHED))
summary(ints_lbs$HOURS_FISHED_fac)						# 15 interviews with length over 24 hours. eliminate.
ints_lbs <- subset(ints_lbs, HOURS_FISHED < 26)				# str(ints_lbs)	#2,090 interviews		

ints_lbs <- droplevels(ints_lbs)

ints_lbs <- mutate(ints_lbs, gear_hour = NUM_GEAR*HOURS_FISHED)

#  --------------------------------------------------------------------------------------
#  make some violin plots, do some linear models


pdf(file="BBS_bottomfishing_effort_figs_30Nov_2.pdf")
par(mfrow=c(2,2))
par(omi=c(0.2,0.2,0.1,0.1)) #set outer margins
par(mai=c(0.7,0.7, 0.3, 0.1)) #set inner margins

#  A. lbs/hour ~ num_gear ------------

calc_meds <- tapply(ints_lbs$lbs_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_hour' = as.numeric(calc_meds))

vioplot(lbs_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,60), xlab= "Number of gears", ylab = "total lbs per hour")
# add linear regressions
# abline(lm(lbs_hour ~ NUM_GEAR, data = calc_meds_2), col='blue', lty=2)			# estimate intercept on medians
 abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means

# B. lbs per hour per gear vs. number of gears

calc_meds <- tapply(ints_lbs$lbs_gear_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_gear_hour' = as.numeric(calc_meds))

vioplot(lbs_gear_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,15), xlab= "Number of gears", ylab = "total lbs per hour per gear")


#  C. lbs/trip ~ num_gear ------------

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'tot_lbs' = as.numeric(calc_meds))

vioplot(tot_lbs ~ NUM_GEAR_fac, data = ints_lbs, ylim = c(0,600), xlab= "Number of gears", ylab = "total lbs per trip")
# add linear regressions
 abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means


#  D. lbs/trip ~ hours ------------

# for ease of illustration, round to whole hours
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded = ceiling(HOURS_FISHED))
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded_fac = as.factor(HOURS_FISHED_rounded))		# summary(ints_lbs$HOURS_FISHED_rounded_fac)

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$HOURS_FISHED_rounded_fac, median)
calc_meds_2 <- data.frame('HOURS_FISHED' = seq(1,24,1), 'tot_lbs' = as.numeric(calc_meds))

vioplot(tot_lbs ~ HOURS_FISHED_rounded_fac, data = ints_lbs, ylim=c(0,800), xlab= "Hours Fished", ylab = "total lbs per trip")
# add linear regressions
abline(lm(tot_lbs ~ 0 + HOURS_FISHED, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians


mtext("BBS 1988-2020, bottomfishing gear only, 2,090 interviews",side=3, outer=TRUE, line = -1.5)

dev.off()




#  ---------------------------------------------------------------------------------------------
#  repeat using just the btm / trl mix

# total lbs per interview, all species
	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as tot_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C)
			GROUP BY INTERVIEW_PK
			"
	int_tot_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(int_tot_catch)		#3066 interviews


# list bottomfishing interviews with total pounds per interview, num_gear, hours_fished for 1988-2020
#	eliminate anomalous records by excluding number of gears 10 and greater

	string <- "SELECT INTERVIEW_PK, year_num, HOURS_FISHED, NUM_GEAR, sum(EST_LBS) as tot_lbs
			FROM
			  (SELECT DISTINCT INTERVIEW_PK, year_num, CATCH_PK, HOURS_FISHED, NUM_GEAR, EST_LBS
				FROM bbs_3C
				WHERE year_num > 1987 AND year_num < 2021 AND FISHING_METHOD = 'BTM/TRL MIX' AND NUM_GEAR < 10)
			GROUP BY INTERVIEW_PK"
	ints_lbs <- sqldf(string, stringsAsFactors=FALSE)		# str(ints_lbs)	#594 interviews	

# drop any records with NAs now for simplicity
ints_lbs <- na.omit(ints_lbs)							#591 interviews	#summary(ints_lbs)

# how many zero catches?
nrow(subset(ints_lbs, tot_lbs == 0))					# 1 zero catch trip. eliminate.
ints_lbs <- subset(ints_lbs, tot_lbs > 0)					

ints_lbs <- mutate(ints_lbs, lbs_hour = tot_lbs / HOURS_FISHED, lbs_gear = tot_lbs/NUM_GEAR, 
				lbs_gear_hour = tot_lbs/(HOURS_FISHED*NUM_GEAR))		# summary(ints_lbs)
ints_lbs <- mutate(ints_lbs, NUM_GEAR_fac = as.factor(NUM_GEAR))		#summary(ints_lbs$lbs_hour)
summary(ints_lbs$NUM_GEAR_fac)		# again, there was only 1 interview for each num_gear = 8 and 9. So, drop those.
ints_lbs <- subset(ints_lbs, NUM_GEAR < 8)				# str(ints_lbs)	#589 interviews		


# repeat to investigate HOURS_FISHED
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_fac = as.factor(HOURS_FISHED))
summary(ints_lbs$HOURS_FISHED_fac)						# 15 interviews with length over 24 hours. eliminate.
ints_lbs <- subset(ints_lbs, HOURS_FISHED < 25)				# str(ints_lbs)	#574 interviews		

ints_lbs <- droplevels(ints_lbs)

ints_lbs <- mutate(ints_lbs, gear_hour = NUM_GEAR*HOURS_FISHED)

#  --------------------------------------------------------------------------------------
#  make some violin plots, do some linear models


pdf(file="BBS_btm_trl_mix_effort_figs_2Dec.pdf")
par(mfrow=c(2,2))
par(omi=c(0.2,0.2,0.1,0.1)) #set outer margins
par(mai=c(0.7,0.7, 0.3, 0.1)) #set inner margins

#  A. lbs/hour ~ num_gear ------------

calc_meds <- tapply(ints_lbs$lbs_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_hour' = as.numeric(calc_meds))

vioplot(lbs_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,60), xlab= "Number of gears", ylab = "total lbs per hour")
# add linear regressions
# abline(lm(lbs_hour ~ NUM_GEAR, data = calc_meds_2), col='blue', lty=2)			# estimate intercept on medians
 abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means

# B. lbs per hour per gear vs. number of gears

calc_meds <- tapply(ints_lbs$lbs_gear_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_gear_hour' = as.numeric(calc_meds))

vioplot(lbs_gear_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,15), xlab= "Number of gears", ylab = "total lbs per hour per gear")


#  C. lbs/trip ~ num_gear ------------

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'tot_lbs' = as.numeric(calc_meds))

vioplot(tot_lbs ~ NUM_GEAR_fac, data = ints_lbs, ylim = c(0,600), xlab= "Number of gears", ylab = "total lbs per trip")
# add linear regressions
 abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means


#  D. lbs/trip ~ hours ------------

# for ease of illustration, round to whole hours
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded = ceiling(HOURS_FISHED))
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded_fac = as.factor(HOURS_FISHED_rounded))		# summary(ints_lbs$HOURS_FISHED_rounded_fac)

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$HOURS_FISHED_rounded_fac, median)
calc_meds_2 <- data.frame('HOURS_FISHED' = seq(1,22,1), 'tot_lbs' = as.numeric(calc_meds)[1:22])
calc_meds_2[23,1] = 23
calc_meds_2[24,1] = 24
calc_meds_2[24,2] = as.numeric(calc_meds[23])


vioplot(tot_lbs ~ HOURS_FISHED_rounded_fac, data = ints_lbs, ylim=c(0,800), xlab= "Hours Fished", ylab = "total lbs per trip")
# add linear regressions
abline(lm(tot_lbs ~ 0 + HOURS_FISHED, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians


mtext("BBS 1988-2020, bottom / trl mix gear only, 574 interviews",side=3, outer=TRUE, line = -1.5)

dev.off()



#  ---------------------------------------------------------------------------------------------
#  repeat BOTH GEARS

# total lbs per interview, all species
	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as tot_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C)
			GROUP BY INTERVIEW_PK
			"
	int_tot_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(int_tot_catch)		#3066 interviews


# list bottomfishing + btm/trl mix interviews with total pounds per interview, num_gear, hours_fished for 1988-2020
#	eliminate anomalous records by excluding number of gears 10 and greater

	string <- "SELECT INTERVIEW_PK, year_num, HOURS_FISHED, NUM_GEAR, sum(EST_LBS) as tot_lbs
			FROM
			  (SELECT DISTINCT INTERVIEW_PK, year_num, CATCH_PK, HOURS_FISHED, NUM_GEAR, EST_LBS
				FROM bbs_3C
				WHERE year_num > 1987 AND year_num < 2021 AND FISHING_METHOD in ('BOTTOMFISHING','BTM/TRL MIX') 
					AND NUM_GEAR < 10)
			GROUP BY INTERVIEW_PK"
	ints_lbs <- sqldf(string, stringsAsFactors=FALSE)		# str(ints_lbs)	#2716 interviews	

# drop any records with NAs now for simplicity
ints_lbs <- na.omit(ints_lbs)							#2699 interviews	#summary(ints_lbs)

# how many zero catches?
nrow(subset(ints_lbs, tot_lbs == 0))					# 2 zero catch trip. eliminate.
ints_lbs <- subset(ints_lbs, tot_lbs > 0)					

ints_lbs <- mutate(ints_lbs, lbs_hour = tot_lbs / HOURS_FISHED, lbs_gear = tot_lbs/NUM_GEAR, 
				lbs_gear_hour = tot_lbs/(HOURS_FISHED*NUM_GEAR))		# summary(ints_lbs)
ints_lbs <- mutate(ints_lbs, NUM_GEAR_fac = as.factor(NUM_GEAR))		#summary(ints_lbs$lbs_hour)
summary(ints_lbs$NUM_GEAR_fac)		# there was only 2 interview for each num_gear = 8 and 9. So, drop those.
ints_lbs <- subset(ints_lbs, NUM_GEAR < 8)				# str(ints_lbs)	#2,693 interviews		


# repeat to investigate HOURS_FISHED
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_fac = as.factor(HOURS_FISHED))
summary(ints_lbs$HOURS_FISHED_fac)						# 30 interviews with length over 24 hours. eliminate.
ints_lbs <- subset(ints_lbs, HOURS_FISHED < 25)				# str(ints_lbs)	#2,663 interviews		

ints_lbs <- droplevels(ints_lbs)

ints_lbs <- mutate(ints_lbs, gear_hour = NUM_GEAR*HOURS_FISHED)

#  --------------------------------------------------------------------------------------
#  make some violin plots, do some linear models


pdf(file="BBS_bottom_btmtrl_mix_effort_figs_1Dec.pdf")
par(mfrow=c(2,2))
par(omi=c(0.2,0.2,0.1,0.1)) #set outer margins
par(mai=c(0.7,0.7, 0.3, 0.1)) #set inner margins

#  A. lbs/hour ~ num_gear ------------

calc_meds <- tapply(ints_lbs$lbs_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_hour' = as.numeric(calc_meds))

vioplot(lbs_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,60), xlab= "Number of gears", ylab = "total lbs per hour")
# add linear regressions
# abline(lm(lbs_hour ~ NUM_GEAR, data = calc_meds_2), col='blue', lty=2)			# estimate intercept on medians
 abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(lbs_hour ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means

# B. lbs per hour per gear vs. number of gears

calc_meds <- tapply(ints_lbs$lbs_gear_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'lbs_gear_hour' = as.numeric(calc_meds))

vioplot(lbs_gear_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,15), xlab= "Number of gears", ylab = "total lbs per hour per gear")


#  C. lbs/trip ~ num_gear ------------

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,7,1), 'tot_lbs' = as.numeric(calc_meds))

vioplot(tot_lbs ~ NUM_GEAR_fac, data = ints_lbs, ylim = c(0,600), xlab= "Number of gears", ylab = "total lbs per trip")
# add linear regressions
 abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians
# abline(lm(tot_lbs ~ 0 + NUM_GEAR, data = ints_lbs), col='light blue', lty=2)		# intercept = 0 with means


#  D. lbs/trip ~ hours ------------

# for ease of illustration, round to whole hours
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded = ceiling(HOURS_FISHED))
ints_lbs <- mutate(ints_lbs, HOURS_FISHED_rounded_fac = as.factor(HOURS_FISHED_rounded))		# summary(ints_lbs$HOURS_FISHED_rounded_fac)

calc_meds <- tapply(ints_lbs$tot_lbs, ints_lbs$HOURS_FISHED_rounded_fac, median)
calc_meds_2 <- data.frame('HOURS_FISHED' = seq(1,24,1), 'tot_lbs' = as.numeric(calc_meds))

vioplot(tot_lbs ~ HOURS_FISHED_rounded_fac, data = ints_lbs, ylim=c(0,800), xlab= "Hours Fished", ylab = "total lbs per trip")
# add linear regressions
abline(lm(tot_lbs ~ 0 + HOURS_FISHED, data = calc_meds_2), col='blue', lty=1)		# intercept = 0 with medians


mtext("BBS 1988-2020, bottomfishing and btm/trl mix, 2,663 interviews",side=3, outer=TRUE, line = -1.5)

dev.off()


































#  --------------------------------------------------------------------------------------------------------------