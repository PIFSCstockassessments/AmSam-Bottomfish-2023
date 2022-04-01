#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Prepare datasets (presence/absence and abundance) with all covariates for each BMUS
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------



# ----- PRELIMINARIES
  rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf

  # load all the libraries.
  library(sqldf)
  library(dplyr)
  library(this.path)
  library(ggfortify)		#  install.packages('ggfortify')
  library(data.table)		#  install.packages('data.table')
  library(nFactors)		#  install.packages('nFactors')
  library(fitdistrplus)
  library(mgcv)
  library(formula.tools)	
 # library(ggplot2)
 # library(magrittr)
 # library(gridExtra)
 # library(grid)
 # library(cowplot)
 # library(lattice)
 # library(ggplotify)

  # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)

  # read in the BBS data.
  load(paste(root_dir, "/output/02_BBS_covariates.RData", sep=""))

  # read in the PCA analysis
  load(paste(root_dir, "/output/06_BBS_CPUE_PCA.RData", sep=""))


# ---------------------- list interviews with interview-level data
# 

	string <- "SELECT DISTINCT INTERVIEW_PK, year_num, AREA_B2, FISHING_METHOD, TYPE_OF_DAY,
				season, wspd, tod_quarter,			
					ENSO, Moon_days, wdir, ONI, SOI,shift, 
					NUM_GEAR, HOURS_FISHED, effort
			FROM bbs_3C
			"
	ints_1 <- sqldf(string, stringsAsFactors=FALSE)				#str(ints_1)


# ------ Join primary components 1 and 2 to the data

	string <- "SELECT ints_1.*, ints_PCs.PC1, ints_PCs.PC2
		FROM ints_1 LEFT JOIN ints_PCs
			ON ints_1.INTERVIEW_PK = ints_PCs.INTERVIEW_PK
			"
	ints_2 <- sqldf(string, stringsAsFactors=FALSE)
		# str(ints_2)

# ------- total lbs per interview, all species
# -------	also select effort values by interview now.
	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as tot_lbs
		FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
			FROM bbs_3C)
		GROUP BY INTERVIEW_PK
			"
	int_tot_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(int_tot_catch)		# 3068 interviews 

# --------  Make a "prop_pelagics" category. i.e., regardless of the gear types employed, which trips caught
#			tunas/mackerels, mahi mahi, or billfishes?
#	This is an alternate to the PCs
#					'tunas' includes all scombrids and mahi mahi:
#					458	Euthynnus	affinis
#					455	Thunnus	alalunga
#					456	Thunnus	albacares
#					5232	Grammatorcynos	bilineatus
#					108	Rastrelliger	brachysoma
#					5178	Rastrelliger	kanagurta
#					457	Thunnus	obesus
#					452	Katsuwonus	pelamis
#					412	Acanthocybium	solandri
#					453	Thunnus	thynnus
#					454	Gymnosarda	unicolor
#					404	Coryphaena	hippurus
#					405	Xiphias	gladius

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as pelagics_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C
				WHERE SPECIES_FK in ('458','455','456','5232','108','5178',
						'457','452','412','453','454','404','405'))
			GROUP BY INTERVIEW_PK
			"
	int_pel_catch <- sqldf(string, stringsAsFactors=FALSE)
	# nrow(int_pel_catch)		# 1065 out of 3068 interviews caught pelagics

     # merge together for a "prop_pelagics" variable
		int <- merge(x = int_tot_catch, y = int_pel_catch, by = 'INTERVIEW_PK' , all.x = TRUE)
	int[is.na(int)] <- 0 			# View(int)
	int <- mutate(int, prop_pelagics = round((pelagics_lbs/tot_lbs),digits=2))
	int[is.na(int)] <- 0 

#   make an unidentified BMUS category (i.e. interviews with a lot of unidentified catch
#		could be more a function of how an interviewer implimented species ID protocols, not true abundance.
#		Hence prop_unid could be a useful covariate.

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as unid_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
					FROM bbs_3C 
					WHERE SPECIES_FK in ('109','110','200','210','230','240','260','380','390','100'))
			GROUP BY INTERVIEW_PK
			"
	int_unid_catch <- sqldf(string, stringsAsFactors=FALSE)

	int_B <- merge(x = int, y = int_unid_catch, by = 'INTERVIEW_PK' , all.x = TRUE)
	int_B[is.na(int_B)] <- 0 			# View(int)
	int_B <- mutate(int_B, prop_unid = round((unid_lbs/tot_lbs),digits=2))
	int_B[is.na(int_B)] <- 0 			#View(int_B)



	string <- "SELECT ints_2.*, int_B.prop_pelagics, int_B.prop_unid
		FROM ints_2 LEFT JOIN int_B
			ON ints_2.INTERVIEW_PK = int_B.INTERVIEW_PK
			"
	ints_3 <- sqldf(string, stringsAsFactors=FALSE)

# ----- filter out records where the effort was obviously erroneously reported.
#	The vast majority of interviews report 5 or fewer gear (GEAR_NUM)
#	However, there are 25 interviews that report >10 num_gear (all for boats that typically fish 5 or fewer).
#		sometimes, the mistakes are understandable (like NUM_GEAR = 30 instead of 3 as most interviews)
#		others are less intuitive (like 330 or 1600).
#	I think the only reasonable way to deal with these (since extreme outliers will make it difficult to model distributions)
#		is to trash these interviews :*(

	string <- "SELECT *
		FROM ints_3
		WHERE NUM_GEAR < 10"
	ints_4 <- sqldf(string, stringsAsFactors=FALSE)		# 
	str(ints_4)			#3043 interviews

#	exclude 1986, 1987, and unknown areas
	string <- "SELECT *
		FROM ints_4
		WHERE year_num > 1987 AND AREA_B2 IN ('Bank_E','Bank_S','Manua','Tutuila')"
	ints_5 <- sqldf(string, stringsAsFactors=FALSE)		# 
	str(ints_5)			#2702 interviews
	ints_5 <- mutate(ints_5, year_fac = as.factor(year_num))

#  ----- make a standardized effort var for possible inclusion in the binom model (following Cambell 2015)
#	NOTE: THIS IS COMMON OVER ALL AREAS AND INCLUDES interviews that are MISSING PCS 
#			(because they caught rare species only)
	effort_mean <- mean(ints_5$effort)
	effort_sd <- sd(ints_5$effort)
	hours_mean <- mean(ints_5$HOURS_FISHED)
	hours_sd <- sd(ints_5$HOURS_FISHED)
	ints_5 <- mutate(ints_5, effort_std = (effort - effort_mean)/effort_sd,
			hours_std = (HOURS_FISHED - hours_mean)/hours_sd)
	# var(ints_5$effort_std)
	# mean(ints_5$effort_std)
	# var(ints_5$hours_std)
	# mean(ints_5$hours_std)

#  create a categorical variable for number of gears, combine 7-9, see prelim analysis
#  summary(as.factor(ints_5$NUM_GEAR))
	ints_5 <- mutate(ints_5, num_gear_fac = as.character(NUM_GEAR))
	ints_5$num_gear_fac[ints_5$num_gear_fac == '7'] <- '789'
	ints_5$num_gear_fac[ints_5$num_gear_fac == '8'] <- '789'
	ints_5$num_gear_fac[ints_5$num_gear_fac == '9'] <- '789'
	ints_5$num_gear_fac = as.factor(ints_5$num_gear_fac)
	summary(ints_5$num_gear_fac)

#  catch data
  # ----------- pick out lbs caught for each bmus
	# there is undoubtedly a non-goofy way to do this.
	# don't forget, within a trip, a species catch can have multiple CATCH_PK if disposition varied (some were kept,
	#	some were sold), and probably other things, too (gear, area, ...)
	# also, for rutilans, if both p. rutilans and a. rutilans were used within the same interview, there would be unique CATCH_PK 

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '247')
			GROUP BY INTERVIEW_PK
			"
	APRU_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(APRU_catch)	# nrow = 709

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '239')
			GROUP BY INTERVIEW_PK
			"
	APVI_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(APVI_catch)	#nrow = 1267

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '111')
			GROUP BY INTERVIEW_PK
			"
	CALU_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(CALU_catch)	#nrow = 854

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '248')
			GROUP BY INTERVIEW_PK
			"
	ETCO_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(ETCO_catch)	#nrow = 815

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '249')
			GROUP BY INTERVIEW_PK
			"
	ETCA_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(ETCA_catch)	#nrow = 692

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '267')
			GROUP BY INTERVIEW_PK
			"
	LERU_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(LERU_catch)	#nrow = 936

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '231')
			GROUP BY INTERVIEW_PK
			"
	LUKA_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(LUKA_catch)	#nrow = 1584

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '241')
			GROUP BY INTERVIEW_PK
			"
	PRFL_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(PRFL_catch)	#nrow = 468

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '242')
			GROUP BY INTERVIEW_PK
			"
	PRFI_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(PRFI_catch)	#nrow = 235

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '245')
			GROUP BY INTERVIEW_PK
			"
	PRZO_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(PRZO_catch)	#nrow = 653

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '229')
			GROUP BY INTERVIEW_PK
			"
	VALO_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(VALO_catch)	#nrow = 1263



 # ---------- prepare datasets for each species	
 #	dataset for each species are individual lists
 #    e.g. kasmira:
 #		List of 3
 #		 $ tutu List of 2
 #			$data_all		(includes zeros)
 #			$data_pos		(just positive catches)
 #		 $ manu List of 2
 #			$data_all		(includes zeros)
 #			$data_pos		(just positive catches)
 #		 $ banks List of 2
 #			$data_all		(includes zeros)
 #			$data_pos		(just positive catches)

 # ----- KASMIRA -----

	sp_data <- merge(x = ints_5, y = LUKA_catch, by = 'INTERVIEW_PK' , all.x = TRUE) 	#nrow(sp_data)
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)			#View(sp_data)
    	
	# make a positive catches only dataset
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]
	str(sp_data_pos)		
	nrow(sp_data_pos)/nrow(sp_data)	#View(sp_data_pos)

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	kasmira <- list('tutu'=tutu,'manu'=manu,'banks'=banks)			
	str(kasmira)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)

 # ----- RUTILANS -----

	sp_data <- merge(x = ints_5, y = APRU_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	summary(sp_data$AREA_B2)
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
    	
	# make a positive catches only dataset
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]
	str(sp_data_pos)		# nrow(sp_data_pos)/nrow(sp_data)		#View(sp_data_pos)


	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)


	rutilans <- list('tutu'=tutu,'manu'=manu,'banks'=banks)			#str(rutilans)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


 # ----- VIRESCENS -----

	sp_data <- merge(x = ints_5, y = APVI_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	summary(sp_data$AREA_B2)
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
    	
	# make a positive catches only dataset
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]
	str(sp_data_pos)		# nrow(sp_data_pos)/nrow(sp_data) 		#View(sp_data_pos)


	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)

	virescens <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(virescens)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)

 # ----- LUGUBRIS -----

	sp_data <- merge(x = ints_5, y = CALU_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
    	
	# make a positive catches only dataset
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]
	nrow(sp_data_pos)/nrow(sp_data)		#View(sp_data_pos)

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)

	lugubris <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(lugubris)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)



#  ----- CORUSCANS -----

	sp_data <- merge(x = ints_5, y = ETCO_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	# View(sp_data)		#str(sp_data)
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
    	
	# make a positive catches only dataset
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]
	# str(sp_data_pos)		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	coruscans <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(coruscans)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


#  ----- CARBUNCULUS -----

	sp_data <- merge(x = ints_5, y = ETCA_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	carbunculus <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(carbunculus)
	
	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)

#  ----- RUBRIOPERCULATUS -----

	sp_data <- merge(x = ints_5, y = LERU_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	rubrioperculatus <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(rubrioperculatus)
	
	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)

#  ----- FLAVIPINNIS -----

	sp_data <- merge(x = ints_5, y = PRFL_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	flavipinnis <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(flavipinnis)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


#  ----- FILAMENTOSUS -----

	sp_data <- merge(x = ints_5, y = PRFI_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	filamentosus <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(filamentosus)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


#  ----- ZONATUS -----

	sp_data <- merge(x = ints_5, y = PRZO_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	zonatus <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(zonatus)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


#  ----- LOUTI -----

	sp_data <- merge(x = ints_5, y = VALO_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/HOURS_FISHED,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
	sp_data_pos = sp_data[sp_data$catch_cpue > 0,]		

	tutu <- list('data_all' = subset(sp_data, AREA_B2 == 'Tutuila'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Tutuila'))				#str(tutu)

	manu <- list('data_all' = subset(sp_data, AREA_B2 == 'Manua' & year_num < 2009),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Manua' & year_num < 2009))		# str(manu)
	
	banks <- list('data_all' = subset(sp_data, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'),
			'data_pos' = subset(sp_data_pos, AREA_B2 == 'Bank_E' | AREA_B2 == 'Bank_S'))	#str(banks)
					
	louti <- list('tutu'=tutu,'manu'=manu,'banks'=banks)
	str(louti)

	rm(sp_data)
	rm(sp_data_pos)
	rm(tutu)
	rm(manu)
	rm(banks)


 # assemble all species in alphabetical order

  cpue_datasets <- list('rutilans' = rutilans,
			'virescens' = virescens,
			'lugubris' = lugubris,
			'carbunculus' = carbunculus,
			'coruscans' = coruscans,
			'rubrioperculatus' = rubrioperculatus,
			'kasmira' = kasmira,
			'filamentosus' = filamentosus,
			'flavipinnis' = flavipinnis,
			'zonatus' = zonatus,
			'louti' = louti)

  #str(cpue_datasets)		names(cpue_datasets)





 # -------------------------------------------------------------------------------------------------------------------------------
 # clean up workspace, save just the PCA stuff
	all_objs <- ls()
	save_objs <- c("cpue_datasets","root_dir")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/output/07_BBS_CPUE_Data_Prep.RData", sep=""))
	# save.image(paste(root_dir, "/Outputs/07_BBS_CPUE_Data_Prep.RData", sep=""))
	


























#  --------------------------------------------------------------------------------------------------------------











