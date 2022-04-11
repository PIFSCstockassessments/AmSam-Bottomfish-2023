#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Example predictions and figures
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------

 # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)

 # read in prepared CPUE datasets with best fit functions
  load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))


# example using these 2 functions: Luka tutuila
  	
	species = 'LUKA'
	area = 'tutu'
  	nom_luka <- predict_nominal(species, area)
	delta_luka_modes <- predict_delta_modes(species, area)

  plot(nom_luka$year, nom_luka$cpue, pch = 1, ylim=c(0,3))
  	lines(delta_luka_modes$year, delta_luka_modes$delta_fit, col="blue")
	lines(delta_luka_modes$year,delta_luka_modes$delta_fit + delta_luka_modes$delta_sd, col="blue",lty=3)
	lines(delta_luka_modes$year,delta_luka_modes$delta_fit - delta_luka_modes$delta_sd, col="blue",lty=3)


































