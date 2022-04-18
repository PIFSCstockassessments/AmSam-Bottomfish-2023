
#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	trying out Bentley et al. 2011 influence metrics and plots (as suggested by Nicholas)
#		see https://github.com/trophia/influ
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------



# ----- PRELIMINARIES
#  rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf


 library(sqldf)
  library(dplyr)
  library(this.path)
  library(ggfortify)		#  install.packages('ggfortify')
  library(data.table)		#  install.packages('data.table')
  library(nFactors)		#  install.packages('nFactors')
  library(fitdistrplus)
  library(mgcv)
  library(formula.tools)


 # establish directories using this.path::
  root_dir <- this.path::here(.. = 1)

 # read in the best fit models that we chose in 09_CPUE_Fit_MODELS.R
  load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))

 # load the influ functions that I saved in an R script (couldn't get package to load)
  source(paste(root_dir, "/Scripts/influ.R", sep=""))

 # this won't work from the GAM model object, so try doing a glm object (note s(yday) is missing)

 myData <- LUKA$tutu$pos$sp_data_pos			#head(myData)
 myModel <- glm(log(catch_cpue)~year_fac+PC2 + PC1 + ENSO + prop_unid + tod_quarter,data=myData)
 
 myInfl = Influence$new(myModel)
 myInfl$calc()

myInfl$summary
myInfl$stanPlot()
myInfl$stepPlot()
myInfl$influPlot()
myInfl$cdiPlot('month')
myInfl$cdiPlotAll()


pdf('example_influence_18Apr.pdf')
myInfl$cdiPlot('PC2')
myInfl$cdiPlot('PC1')
myInfl$cdiPlot('ENSO')
myInfl$cdiPlot('prop_unid')
myInfl$cdiPlot('tod_quarter')
dev.off()


pdf('example_influence_18Apr.pdf')
myInfl$cdiPlot('PC2')
myInfl$cdiPlot('PC1')
myInfl$cdiPlot('ENSO')
myInfl$cdiPlot('prop_unid')
myInfl$cdiPlot('tod_quarter')
dev.off()








ln_catch_cpue ~ year_fac + PC2 + PC1 + ENSO + prop_unid + tod_quarter + 
    s(yday, bs = "cc")


 myModel <- LUKA$tutu$pos$model
 summary(myModel)



 myInfl = Influence$new(myModel, data = myData)
 str(myInfl)

 # IT DID SOMETHING, however, is missing $calc (not sure what t




myInfl$calc()




























#  --------------------------------------------------------------------------------------------------------------



