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

 # read in prepared CPUE datasets with best fit functions
  load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))


 # models and data are stored in LUKA$ tutu $ pa $ pos $sp_data_all $sp_data_pos


# example: Luka tutuila

# extract what we want to know from the fitted model object

this_model <- LUKA$tutu$pa$model
str(this_model)
this_model$xlevels[1]
model_vars <- names(this_model$model)
model_vars[1]

# build the prediction grid for the categorical variables.
length(this_model$xlevels)


new.data1 = expand.grid(Year = as.factor(this_model$xlevels[1]), V2 = data.frame(this_model$xlevels[2]), 
				V3=data.frame(this_model$xlevels[3]))		#View(new.data1)

		new.data1$Gear = rep(Mode(sim.cpue.df$Gear),nrow(new.data1))
		new.data1$Depth = rep(Mode(sim.cpue.df$Depth),nrow(new.data1))
		new.data1$Technology = rep(Mode(sim.cpue.df$Technology),nrow(new.data1))     
		




str(cpue_datasets)

ls()




















































#  --------------------------------------------------------------------------------------------------------------
































