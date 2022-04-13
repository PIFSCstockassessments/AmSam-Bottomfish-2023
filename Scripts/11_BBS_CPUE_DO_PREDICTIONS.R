#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Example predictions and figures
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------

# ----- PRELIMINARIES
#  rm(list=ls())

 # load libraries.
 # library(sqldf)
  library(dplyr)
  library(this.path)
 # library(ggfortify)		#  install.packages('ggfortify')
  library(data.table)		#  install.packages('data.table')
 # library(nFactors)		#  install.packages('nFactors')
 # library(fitdistrplus)
  library(mgcv)
 # library(formula.tools)	
 # library(ggplot2)
 # library(magrittr)
 # library(gridExtra)
 # library(grid)
 # library(cowplot)
 # library(lattice)
 # library(ggplotify)

 # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)

 # read in the best fit models that we chose in 09_CPUE_Fit_MODELS.R
  load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))

 # redefine root directory just in case it was different in the 09 workspace
  root_dir <- this.path::here(.. = 1)

 # load the CPUE predict functions from the script
  source(paste(root_dir, "/Scripts/10_BBS_CPUE_PREDICT_FUNCTIONS.R", sep=""))



 ## Reminder:
  # We saved the models and data for each pa and pos process models for each area in list objects for each species.
  #	the structure of each list [with indexes] is: 
  #	$ tutu [1]
  #		$ pa  [1]
  #			$model	  [1]
  #			$sp_data_all  [2]
  #		$ pos [2]
  #			$model	  [1]
  #			$sp_data_pos  [2]
  #	$ manu [2]
  #		$ pa  [1]
  #			$model	  [1]
  #			$sp_data_all  [2]
  #		$ pos [2]
  #			$model	  [1]
  #			$sp_data_pos  [2]
  #	$ banks [3]
  #		$ pa  [1]
  #			$model	  [1]
  #			$sp_data_all  [2]
  #		$ pos [2]
  #			$model	  [1]
  #			$sp_data_pos  [2]

# --------------------------------------------------------------------------------------------------------------------------
# some EXAMPLES:

 	# L. kasmira, tutuila	
	species = 'LUKA'
	area = 'tutu'

	# predict the CPUE 3 ways: nominal, delta w/ modes for categorical variables, delta with marginal means (Walter's Large Table).
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

 # make some plots yourself with these objects

    plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,6))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	lines(delta_modes$year,delta_modes$delta_fit + delta_modes$delta_sd, col="blue",lty=3)
	lines(delta_modes$year,delta_modes$delta_fit - delta_modes$delta_sd, col="blue",lty=3)
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=1)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)
	lines(delta_WLT$year,delta_WLT$delta_fit + delta_WLT$delta_sd, col="pink",lty=3)
	lines(delta_WLT$year,delta_WLT$delta_fit - delta_WLT$delta_sd, col="pink",lty=3)


#	Luka manu'as  	
	species = 'LUKA'
	area = 'manu'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

#	Luka banks 			#  this does look good 	
	species = 'LUKA'
	area = 'banks'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)


#	E. coruscans tutuila  	
	species = 'ETCO'
	area = 'tutu'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

       plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,3))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)

 
#	E. coruscans manu'a islands  	
	species = 'ETCO'
	area = 'manu'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

      plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,10))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)


#	E. coruscans banks 	
	species = 'ETCO'
	area = 'banks'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

      plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,10))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)






#  use the plot_CPUE function to fit the models and make plots:

	# only define the species to match the fitted object in this workspace
	species='LUKA'
	LUKA_PLOT <- plot_CPUE(species)
	# the plot will appear in this device, is also stored in the first list item of 'LUKA_PLOT'
	#  the data are in the second list element

	# look at data, note we can see the number of interviews for each area x year in n_ints
	LUKA_PLOT[[2]]


	# output the plot to a figure
	ggsave(file = "luka_cpue.png", LUKA_PLOT[[1]])




	species='ETCO'
	ETCO_PLOT <- plot_CPUE(species)
	# the plot will appear in this device, is also stored in the first list item of 'LUKA_PLOT'
	#  the data are in the second list element

	# look at data
	ETCO_PLOT[[2]]

	# output the plot to a figure
	ggsave(file = "etco_cpue.png", ETCO_PLOT[[1]])




















#	some more code...
# example using these 2 functions: Tutuila E. coruscans
  	
	species = 'ETCO'
	area = 'tutu'
  	nom_etco <- predict_nominal(species, area)
	delta_etco_modes <- predict_delta_modes(species, area)	#delta_etco_modes_mse <- delta_etco_modes
	View(delta_etco_modes)


  plot(nom_etco$year, nom_etco$cpue, pch = 1, ylim=c(0,2))
  	lines(delta_etco_modes$year, delta_etco_modes$delta_fit, col="blue")
	lines(delta_etco_modes$year,delta_etco_modes$delta_fit + delta_etco_modes$delta_sd, col="blue",lty=3)
	lines(delta_etco_modes$year,delta_etco_modes$delta_fit - delta_etco_modes$delta_sd, col="blue",lty=3)



# example using these 2 functions: Banks E. coruscans (pos is gamma)
  	
	species = 'ETCO'
	area = 'banks'
  	nom_pred <- predict_nominal(species, area)
	delta_pred <- predict_delta_modes(species, area)	#delta_etco_modes_mse <- delta_etco_modes
	# View(delta_etco_modes)

  plot(nom_pred$year, nom_pred$cpue, pch = 1, ylab="lbs per hour", xlab = "year")
  	lines(delta_pred$year, delta_pred$delta_fit, col="blue")
	points(delta_pred$year, delta_pred$delta_fit, col="blue",pch=16)
	

	species = 'LUKA'
	area = 'banks'
  	nom_pred <- predict_nominal(species, area)
	delta_pred <- predict_delta_modes(species, area)	#delta_etco_modes_mse <- delta_etco_modes
	# View(delta_etco_modes)

  plot(nom_pred$year, nom_pred$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,20))
  	lines(delta_pred$year, delta_pred$delta_fit, col="blue")
	points(delta_pred$year, delta_pred$delta_fit, col="blue",pch=16)
	
  # what is dragging down CPUE in those last 10 years relative to nominal?
  summary(ETCO$tutu$pos$model)



predict_delta_WLT











lines(delta_pred$year,delta_etco_modes$delta_fit + delta_etco_modes$delta_sd, col="blue",lty=3)
	lines(delta_etco_modes$year,delta_etco_modes$delta_fit - delta_etco_modes$delta_sd, col="blue",lty=3)

































