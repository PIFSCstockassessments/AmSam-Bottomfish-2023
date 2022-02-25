#  -----------------------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA LANDINGS (shore-based): 
#	Expanded shore-based landings estimates provided by Toby 17Feb, 2022
#   process data, correct for species ID errors as was done for boat-based survey. Use the same correction factors for boat-based
#	survey.
#   ----------------------------------------------------------------------------------------------------------------------------
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
  # Read in the expanded landings data
 
  sp_data <- read.csv(paste(root_dir, "/data/SPC_AS_SBS.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # str(sp_data)

  # follow Toby's instructions to break the unique key SPC_PK into the interview details we need
  #	watch out- this is a little different from the BBS. See "american samoa SB mysql formulas.docx":
  #		SPC_PK: The private key associated with a particular species catch expansion. 
  #		Consists of 14 characters of the form rryyCYPdmmssss, determined as:
  #			(1,2) rr: Two digits for ROUTE_FK, with leading zeros if necessary
  #			(3,4) yy: Two digits for YEAR, calculated as the number of years after 1947
  #			(5,6) CY: 
  #			(7) P: A single capital letter for the time period (AM_PM), either “D” for day or “N” for night
  #			(8) d: A single digit for TYPE_OF_DAY, either 1 for weekday or 2 for weekend/holiday
  #			(9,10) mm: Two digits for METHOD_FK, with leading zeros if necessary
  #			(11,14) ssss: Four digits for SPECIES_FK, with leading zeros if necessary

  #  note that shore-based expansion domains are route x year x day/night x WE/WD x gear

  sp_data2 <- mutate(sp_data, year_raw = as.numeric(substr(SPC_PK,3,4)), method = substr(SPC_PK,9,10), 
					route = substr(SPC_PK,1,2), type = substr(SPC_PK,8,8), 
				# SPECIES_FK = substr(SPC_PK,11,14), 
					daynight = substr(SPC_PK,7,7))
  head(sp_data2)
  sp_data2 <- mutate(sp_data2, year = year_raw + 1947)
  str(sp_data2)			# 6336 records		# View(sp_data2)

  # fix P. rutilans
  sp_data2$SPECIES_FK[sp_data2$SPECIES_FK==243]<-241

  #  just BMUS by year, gear, and route, summed by day/night, WE/WD
  string <- "SELECT year, SPECIES_FK, method, route, sum(EXP_LBS) as LBS_CAUGHT, sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT 
			FROM sp_data2
			WHERE SPECIES_FK in (247,239,111,248,249,267,231,241,242,245,229)
			GROUP BY year, SPECIES_FK, method, route"
  bmus_1 <- sqldf(string, stringsAsFactors=FALSE)
  # View(bmus_1)			#str(bmus_1)

  # put names on and simplify gears and routes
  summary(as.factor(bmus_1$method))			# 03 20 21 22 26 28 29 30 40
  summary(as.factor(bmus_1$route))			# 01 04 05 07 08 09 17 18 19 21

  bmus_1$route <- as.numeric(bmus_1$route)
  bmus_1$method <- as.numeric(bmus_1$method)

  bmus_1[is.na(bmus_1)] <- 0

  a_routes <- read.csv(paste(root_dir, "/data/sb_route_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # View(a_routes)	#str(a_routes)

  a_method <- read.csv(paste(root_dir, "/data/sb_gear_simple.csv", sep=""),header=T, stringsAsFactors=FALSE) 
  # str(a_method)

  string <- "SELECT bmus_1.*, a_method.FISHING_METHOD, a_method.gear_simple
		FROM bmus_1
		LEFT JOIN a_method
			ON bmus_1.method = a_method.method_fk"
  bmus_2 <- sqldf(string, stringsAsFactors=FALSE)
  str(bmus_2)				# View(bmus_2)


  string <- "SELECT bmus_2.*, a_routes.route_simple, a_routes.area_super_simple
		FROM bmus_2
		LEFT JOIN a_routes
			ON bmus_2.route = a_routes.route"
  bmus_3 <- sqldf(string, stringsAsFactors=FALSE)
  str(bmus_3)				# View(bmus_2)

  # add species scientific names for convenience
  names_key <- read.csv(paste(root_dir, "/data/all_species_names.csv", sep=""), header=T, stringsAsFactors=FALSE) 
  # View(names_key)

  string <- "SELECT bmus_3.*, names_key.SCIENTIFIC_NAME, names_key.COMMON_NAME
		FROM bmus_3
		LEFT JOIN names_key ON
			bmus_3.SPECIES_FK = names_key.SPECIES_FK
		"
  bmus_4 <- sqldf(string, stringsAsFactors=FALSE)		# str(bmus_4)		#  View(bmus_4)


  # sum by gear and area
  string <- "SELECT year, SCIENTIFIC_NAME, area_super_simple, sum(LBS_CAUGHT) as LBS_CAUGHT, 
			sum(VAR_LBS_CAUGHT) as VAR_LBS_CAUGHT 
		FROM bmus_4
		GROUP BY year, SCIENTIFIC_NAME, area_super_simple"

  sb_bmus_5 <- sqldf(string, stringsAsFactors=FALSE)	# str(sb_bmus_5)		# View(sb_bmus_5)

































