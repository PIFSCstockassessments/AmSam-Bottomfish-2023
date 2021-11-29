#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOTTOMFISHES
#	CPUE: make violin plots of lbs/hour vs. num_gear
#	try for a single species or sum_catch

#  --------------------------------------------------------------------------------------------------------------


#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  	library(tidyr)			# install.packages('tidyr')
	library(fitdistrplus)		# install.packages('fitdistrplus')
	library(mgcv)
	library(formula.tools)	


# initial boat-based survey data prep includes filtering weird records, removing incomplete interviews,
#		filtering for gear types, etc. as well as addition of possible CPUE covariates was done in 'BBS_data_prep_Oct29.R'
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")


setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/SpeciesCPUE_simple")

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
	nrow(int_tot_catch)


# list bottomfishing interviews with total pounds per interview, num_gear, hours_fished for 1988-2020
	string <- "SELECT INTERVIEW_PK, year_num, HOURS_FISHED, NUM_GEAR, sum(EST_LBS) as tot_lbs
			FROM
			  (SELECT DISTINCT INTERVIEW_PK, year_num, CATCH_PK, HOURS_FISHED, NUM_GEAR, EST_LBS
				FROM bbs_3C
				WHERE year_num > 1987 AND year_num < 2021 AND FISHING_METHOD = 'BOTTOMFISHING' AND NUM_GEAR < 10)
			GROUP BY INTERVIEW_PK"
	ints_lbs <- sqldf(string, stringsAsFactors=FALSE)		# str(ints_lbs)	#2,108 interviews	

# drop any records with NAs now for simplicity
ints_lbs <- na.omit(ints_lbs)	

ints_lbs <- mutate(ints_lbs, lbs_hour = tot_lbs / HOURS_FISHED)		#summary(ints_lbs$lbs_hour)
ints_lbs <- mutate(ints_lbs, NUM_GEAR_fac = as.factor(NUM_GEAR))		#summary(ints_lbs$lbs_hour)
summary(ints_lbs$NUM_GEAR_fac)		# there was only 1 interview for each num_gear = 8 and 9. So, drop those.

calc_meds <- tapply(ints_lbs$lbs_hour, ints_lbs$NUM_GEAR_fac, median)		#str(calc_meds)
calc_meds_2 <- data.frame('NUM_GEAR' = seq(1,9,1), 'lbs_hour' = as.numeric(calc_meds))
calc_meds_2 <- calc_meds_2[-c(8,9),]

library(vioplot)		# install.packages('vioplot')

vioplot(lbs_hour ~ NUM_GEAR_fac, data = ints_lbs, ylim=c(0,60))
abline(lm(lbs_hour ~ NUM_GEAR, data = calc_meds_2), col='blue')	# this is the linear regression of the medians
# abline(lm(lbs_hour ~ NUM_GEAR, data = ints_lbs), col='red')	# this is the linear regression of the means

lm_numgear <- lm(lbs_hour ~ NUM_GEAR, data = calc_meds_2)
summary(lm_numgear)


#  --------------------------------------------------------------------------------------------------------------
#  CONCLUSION:
#	it's pretty close to a linear relationship, so it should matter which way we do it. I e-mailed Marc the results.
#



























#  --------------------------------------------------------------------------------------------------------------