#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Fit GAM models
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

 # read in prepared CPUE datasets.
  load(paste(root_dir, "/output/07_BBS_CPUE_Data_Prep.RData", sep=""))

 # read in the fit functions
  source(paste(root_dir, "/Scripts/08_BBS_CPUE_FIT_FUNCTIONS.R", sep=""))


# ---------------------------- NOTES -------------------------------------------------


#  ARGUMENTS 		DESCRIPTIONS
#  species			just the species name, e.g., kasmira
#  area			tutu, manu, or banks
#  out_directory		give the full file path of the folder where you want to keep the outputs for each model tried within
#					the selection process. The output file will have the 
#					name binomial_species_area_dt.txt, where dt is the system time (in UTC?)
#					as MMDDhhmmss
#  var_name			list the covariate names, matching the column names in the input data, that are being considered.
#					These must include details for smooth terms in the GAM (e.g. s(wdir, bs='cc')). See Examples below.
#					For circular variables, knots are hard-coded in the function. Change those if more get added.
#  ** Provide an argument for either relative or absolute AIC threshold, NOT BOTH: this is how function knows model acceptance criteria
#  aic_rel_thresh		relative percent change in AIC (as a positive number) that qualifies a variable for inclusion in the model
#					for example 0.1 means a pair of models with relative AIC change of 0.1% or less are equally informative
#  aic_abs_thresh		absolute change in AIC (as a positive number) that qualifies a variable for inclusion in the model
#					for example 2 means a pair of models with absolute AIC change of 2 or less are equally informative


#  REDUNDANT COVARIABLES:
#  * use only 1 env index: SOI, ONI, or ENSO. if best model includes multiple, look at the .txt outputs and remove the weaker
#		one(s) from list_vars
#  * use only 1 targeting covariable: the Winker PCs (PC1 and/or PC2) or prop_pelagics. Again, if both get selected for the
#		best model, eliminate the weaker one from list_vars.
#  * use only 1 time of day covariable: tod_quarter or shift. Dido above.


##################   KASMIRA example using absolute AIC threshold

## presence/absence by area, forward selection, abs AIC threshold = 2
##  --- Tutuila	
	species <- 'kasmira'
	area <- 'tutu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
	var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	aic_abs_thresh <- 2

 LUKA_tutu_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_tutu_binom$model)
	sp_data_all <- LUKA_tutu_binom$sp_data_all
  	plot(LUKA_tutu_binom$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1,
			seWithMean = TRUE, shift = coef(LUKA_tutu_binom$model)[1])
	
 gam.check(LUKA_tutu_binom$model)
  # don't forget, q-q plot here doesn't really mean anything. Mostly look at residuals histogram.

 # examine the selected model formula, ensure no redundant covariables.
 # for additional details for each step in the selection process, see the output .txt.


## positive process by area, gamma error distribution, forward selection, abs AIC threshold = 2
	# same arguments as binomial fit functions
##  --- Tutuila
	species <- 'kasmira'
	area <- 'tutu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
	# var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just PCs  Dev. exp. 37.8 %
	# var_name = c('TYPE_OF_DAY','season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just prop_pelagics	38.2%
	 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid')

	aic_abs_thresh <- 2

 	LUKA_tutu_gamma   <-	gamma_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	
	sp_data_pos <- LUKA_tutu_gamma$sp_data_pos
  	plot(LUKA_tutu_gamma$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1, pages = 1)
	plot(LUKA_tutu_gamma$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1,
			seWithMean = TRUE, shift = coef(LUKA_tutu_gamma$model)[1])



## positive process by area, LogNormal error distribution, forward selection, abs AIC threshold = 2
##  --- Tutuila
	species <- 'kasmira'
	area <- 'tutu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
	# var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just PCs  Dev. exp. 40.9%
	 var_name = c('TYPE_OF_DAY','season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just prop_pelagics	39.3%
	# var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid')

	aic_abs_thresh <- 2

  LUKA_tutu_LnN   <-	LnN_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_tutu_LnN$model)
   sp_data_pos_Ln <- LUKA_tutu_LnN$sp_data_pos_Ln
  	plot(LUKA_tutu_LnN$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1, pages = 1)
	plot(LUKA_tutu_LnN$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1,
			seWithMean = TRUE, shift = coef(LUKA_tutu_LnN$model)[1])

 # in this example, chose between gamma and LnN
 	gam.check(LUKA_tutu_gamma$model)
	gam.check(LUKA_tutu_LnN$model)			#
  #  LnN looks much better.


####
##  --- Manua	
	species <- 'kasmira'
	area <- 'manu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")	
	aic_abs_thresh <- 2


# binom
#  var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
#			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
#  LUKA_manu_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_abs_thresh)
#	summary(LUKA_manu_binom)

 # can't have PC and prop_pelagics
#  var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
#			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid')
#  LUKA_manu_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_abs_thresh)
#  summary(LUKA_manu_binom)	#30.9% dev., AIC = 793.22

  var_name = c('effort_std', 'TYPE_OF_DAY', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
  LUKA_manu_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_abs_thresh)
  summary(LUKA_manu_binom$model)	#44.9% dev., AIC = 642.63

  gam.check(LUKA_manu_binom$model)


# gamma
 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
 LUKA_manu_gamma   <-	gamma_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_manu_gamma$model)


# LnN
 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')

 LUKA_manu_LnN   <-	LnN_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_manu_LnN$model)


 # gamma or LnN?
 	gam.check(LUKA_manu_gamma)
	gam.check(LUKA_manu_LnN)
  #  LnN looks much better.



####
##  --- Banks	
	species <- 'kasmira'
	area <- 'banks'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")	
	aic_abs_thresh <- 2


# binom
  var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
  LUKA_banks_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_banks_binom$model)

  gam.check(LUKA_banks_binom$model)
  sp_data_all <- LUKA_banks_binom$sp_data_all
  	plot(LUKA_banks_binom$model, all.terms = TRUE, select = 2, rug = TRUE, residuals = TRUE, pch = 1, cex = 1)





# gamma
 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
 LUKA_banks_gamma   <-	gamma_forwards(species, area, var_name, out_directory, aic_abs_thresh)
	summary(LUKA_banks_gamma$model)




# LnN
 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')

 LUKA_banks_LnN   <-	LnN_forwards(species, area, var_name, out_directory, aic_abs_thresh)
  summary(LUKA_banks_LnN$model)

  gam.check(LUKA_banks_LnN$model)

   sp_data_pos_Ln <- LUKA_banks_LnN$sp_data_pos_Ln
  	plot(LUKA_banks_LnN$model, all.terms = TRUE, SE=TRUE , rug = TRUE, residuals = TRUE, pch = 1, cex = 1, pages = 1)




 # gamma or LnN?
 	gam.check(LUKA_banks_gamma$model)
	gam.check(LUKA_banks_LnN$model)
  # pretty close, LnN slightly better, and use for consistency with tutu and manu.




# make a list object to hold the LUKA models that we've chosen

banks <- list('pa' = LUKA_banks_binom, 'pos'= LUKA_banks_LnN)
tutu <- list('pa' = LUKA_tutu_binom, 'pos'= LUKA_tutu_LnN)
manu <- list('pa' = LUKA_manu_binom, 'pos'= LUKA_manu_LnN)

LUKA <- list('tutu' = tutu, 'manu' = manu, 'banks'= banks)


 # -------------------------------------------------------------------------------------------------------------------------------
 # keep the data and model objects, save workspace for predition

	all_objs <- ls()
	save_objs <- c("cpue_datasets","root_dir","LUKA")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))
	# save.image(paste(root_dir, "/Outputs/09_BBS_CPUE_FIT_MODELS.RData", sep=""))
	









#  extra examples using relative AIC threshold
##### presence/absence by area, forward selection, relative AIC threshold = 0.01

 #  --- Tutuila	
	species <- 'kasmira'
	area <- 'tutu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
	var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	aic_rel_thresh <- 0.01

 tutu_binom   <-	binomial_forwards(species, area, var_name, out_directory, aic_rel_thresh)
	summary(tutu_binom)

  # in this example, tod_quarter and shift were retained. tod_quarter was stronger, so exclude shift from the initial list



##### positive process by area, forward selection, rel AIC threshold = 1%
	# same arguments as binomial fit functions

 #  --- Tutuila
	species <- 'kasmira'
	area <- 'tutu'
	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
	# var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just PCs  Dev. exp. 37.8 %
	# var_name = c('TYPE_OF_DAY','season', 'wspd', 'tod_quarter',			
	#		'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
	
	# just prop_pelagics	38.2%
	 var_name = c('TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid')

	aic_rel_thresh <- 1

 tutu_gamma   <-	gamma_forwards(species, area, var_name, out_directory, aic_rel_thresh)
	summary(tutu_gamma)
      


































#