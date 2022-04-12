#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Example predictions and figures
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------

 # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)

 # read in prepared CPUE datasets with best fit functions
  load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))


# EXAMPLES:

#	Luka tutuila  	
	species = 'LUKA'
	area = 'tutu'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

    plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,5))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)


#	Luka manu'as  	
	species = 'LUKA'
	area = 'manu'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

    plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,5))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)


#	Luka banks 			#  this does look good 	
	species = 'LUKA'
	area = 'banks'
  	nom <- predict_nominal(species, area)
	delta_modes <- predict_delta_modes(species, area)
	delta_WLT <- predict_delta_WLT(species, area)

    plot(nom$year, nom$cpue, pch = 1, ylab="lbs per hour", xlab = "year", ylim=c(0,5))
  	lines(delta_modes$year, delta_modes$delta_fit, col="blue")
	points(delta_modes$year, delta_modes$delta_fit, col="blue",pch=16)
	
	lines(delta_WLT$year, delta_WLT$delta_fit, col="red", lty=3)
	points(delta_WLT$year, delta_WLT$delta_fit, col="red",pch=1)


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

































