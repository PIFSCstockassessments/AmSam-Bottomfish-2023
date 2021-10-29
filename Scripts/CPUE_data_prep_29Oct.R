#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA DATA REPORT
#	Create single species data summary and CPUE estimates
#		'Simple' = Assume BMUS are never included in unidentified species groups
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  	library(tidyr)
	library(fitdistrplus)
	library(mgcv)
	library(formula.tools)	


# initial boat-based survey data prep includes filtering weird records, removing incomplete interviews,
#		filtering for gear types, etc. as well as addition of possible CPUE covariates was done in 'BBS_data_prep_Oct29.R'
#  load("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\BBS_data_prep_29Oct.RData")


ls()

setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/SpeciesCPUE_simple")

nrow(bbs_3C)		# 49209 records
colnames(bbs_3C)

# list interviews with prospective CPUE variables, 1988-2019
#  we are excluding 1986 and 1987 from CPUE a priori because species were largely unidentified during those first 2 years.

string <- "SELECT DISTINCT INTERVIEW_PK, year_num, AREA_2banks, AREA_B2,TYPE_OF_DAY, FISHING_METHOD, month, season, hour, shift, tod_quarter, 
			Moon_days, wspd, wdir, ENSO, SOI, ONI, effort, HOURS_FISHED, NUM_GEAR, HOOKS_PER_SET
		FROM bbs_3C
		WHERE year_num > 1987
		ORDER BY HOOKS_PER_SET DESC"
	list_ints <- sqldf(string, stringsAsFactors=FALSE)		# View(list_ints)
	str(list_ints)			#2751 interviews	
	
	list_ints$AREA_2banks <- as.factor(list_ints$AREA_2banks)
	list_ints$AREA_B2 <- as.factor(list_ints$AREA_B2)
	list_ints <- mutate(list_ints, year_fac = as.factor(year_num))

# for CPUE inclusion, we want to make sure to exclude records where the effort was obviously erroneously reported.
#	The vast majority of interviews report 5 or fewer gear (GEAR_NUM)
#	However, there are 25 interviews that report >10 num_gear (all for boats that typically fish 5 or fewer).
#		sometimes, the mistakes are understandable (like NUM_GEAR = 30 instead of 3 as most interviews)
#		others are less intuitive (like 330 or 1600).
#	I think the only reasonable way to deal with these (since extreme outliers will make it difficult to model distributions)
#		is to trash these interviews :*(

string <- "SELECT *
		FROM list_ints
		WHERE NUM_GEAR < 10"
	list_ints <- sqldf(string, stringsAsFactors=FALSE)		# 
	str(list_ints)			#2726 interviews

# total lbs per interview, all species
	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as tot_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C)
			GROUP BY INTERVIEW_PK
			"
	int_tot_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(int_tot_catch)		# 3066 interviews- note this is big number because includes all interviews, all years

# Make a "prop_pelagics" category. i.e., regardless of the gear types employed, which trips caught
#		tunas/mackerels, mahi mahi, or billfishes?
#	here, 'tunas' includes all scombrids and mahi mahi:
#	458	Euthynnus	affinis
#	455	Thunnus	alalunga
#	456	Thunnus	albacares
#	5232	Grammatorcynos	bilineatus
#	108	Rastrelliger	brachysoma
#	5178	Rastrelliger	kanagurta
#	457	Thunnus	obesus
#	452	Katsuwonus	pelamis
#	412	Acanthocybium	solandri
#	453	Thunnus	thynnus
#	454	Gymnosarda	unicolor
#	404	Coryphaena	hippurus
#	405	Xiphias	gladius

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as pelagics_lbs
			FROM 
				(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS 
				FROM bbs_3C
				WHERE SPECIES_FK in ('458','455','456','5232','108','5178',
						'457','452','412','453','454','404','405'))
			GROUP BY INTERVIEW_PK
			"
	int_pel_catch <- sqldf(string, stringsAsFactors=FALSE)
	# nrow(int_pel_catch)		# 1065 out of 3066 interviews caught pelagics

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

	int2 <- merge(x = int, y = int_unid_catch, by = 'INTERVIEW_PK' , all.x = TRUE)
	int2[is.na(int2)] <- 0 			# View(int)
	int2 <- mutate(int2, prop_unid = round((unid_lbs/tot_lbs),digits=2))
	int2[is.na(int2)] <- 0 

	# merge back w/ list_ints
		int3 <- merge(x = list_ints, y = int2, by = 'INTERVIEW_PK' , all.x = TRUE)    # nrow(int3)
	
   #  make a standardized effort var for possible inclusion in the binom model (following Cambell 2015)
	effort_mean <- mean(int3$effort)
	effort_sd <- sd(int3$effort)
	int3 <- mutate(int3, effort_std = (effort - effort_mean)/effort_sd)
	# var(int3$effort_std)
	# mean(int3$effort_std)

	# make this easier since I added a step, hence redefined int2

	rm(int2)
	int2 <- int3

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
	ruti_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(ruti_catch)	# nrow = 810

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '239')
			GROUP BY INTERVIEW_PK
			"
	vire_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(vire_catch)	#nrow = 1266

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '111')
			GROUP BY INTERVIEW_PK
			"
	lugu_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(lugu_catch)	#nrow = 854

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '248')
			GROUP BY INTERVIEW_PK
			"
	coru_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(coru_catch)	#nrow = 815

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '249')
			GROUP BY INTERVIEW_PK
			"
	carb_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(carb_catch)	#nrow = 692

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '267')
			GROUP BY INTERVIEW_PK
			"
	rubr_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(rubr_catch)	#nrow = 796

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '231')
			GROUP BY INTERVIEW_PK
			"
	kasm_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(kasm_catch)	#nrow = 1584

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '241')
			GROUP BY INTERVIEW_PK
			"
	flav_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(flav_catch)	#nrow = 266

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '242')
			GROUP BY INTERVIEW_PK
			"
	fila_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(fila_catch)	#nrow = 221

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '245')
			GROUP BY INTERVIEW_PK
			"
	zona_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(zona_catch)	#nrow = 653

	string <- "SELECT INTERVIEW_PK, sum(EST_LBS) as catch_lbs
			FROM 
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, EST_LBS
				FROM bbs_3C
				WHERE SPECIES_FK = '229')
			GROUP BY INTERVIEW_PK
			"
	lout_catch <- sqldf(string, stringsAsFactors=FALSE)
	nrow(lout_catch)	#nrow = 1097



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

	sp_data <- merge(x = int2, y = kasm_catch, by = 'INTERVIEW_PK' , all.x = TRUE) 	#nrow(sp_data)
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
	sp_data$catch_lbs[is.na(sp_data$catch_lbs)] <- 0 	
	sp_data$catch_cpue[is.na(sp_data$catch_cpue)] <- 0 
	sp_data$z <- 0
	sp_data[sp_data$catch_cpue > 0,"z"]=1		#nrow(sp_data)
    	
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

	sp_data <- merge(x = int2, y = ruti_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = vire_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = lugu_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = coru_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	# View(sp_data)		#str(sp_data)
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = carb_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = rubr_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = flav_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = fila_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = zona_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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

	sp_data <- merge(x = int2, y = lout_catch, by = 'INTERVIEW_PK' , all.x = TRUE)    
	sp_data <- mutate(sp_data, catch_cpue = round(catch_lbs/effort,digits=3))
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




# clean-up, save
   # rm(list=ls()[6:22])

   # save.image("C:\\Users\\Erin.Bohaboy\\Documents\\American_Samoa\\Data_Report\\SpeciesCPUE_simple\\CPUE_data_prep_29Oct.RData")

 



























#  --------------------------------------------------------------------------------------------------------------











