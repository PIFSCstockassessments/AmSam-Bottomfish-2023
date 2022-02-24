##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#	Erin Bohaboy erin.bohaboy@noaa.gov
#	American Samoa BMUS assessments 
# 	
#	Separate the species ID corrections (p_) from the complete bbs data (PII)
#	put with the proptables workspace
#
##  -----------------------------------------------------------------------------------------------------------------------------------------------
#  -----------------------------------------------------------------------------------------------------------------------------------------------
#
#

#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
	library(this.path)

  #	library(ggplot2)
  #	library(magrittr)
  #	library(gridExtra)			
  #	library(grid)		
  #	library(cowplot)		
  #	library(lattice)		
  #	library(ggplotify)	

# establish directories using this.path
  root_dir <- this.path::here(.. = 1)

# Read in 02_BBS_covariates.RData
  #  note this will replace root_dir, that's OK because we intend everyone to be using the standard directory structure
  #		matching the git repo. if not, just redefine root_dir after load workspace
  load(paste(root_dir, "/NO_GITHUB_data_outputs/02_BBS_covariates.RData", sep=""))


# Read in 03_BBS_species_proptables.RData
  load(paste(root_dir, "/output/03_BBS_species_proptables.RData", sep=""))


  # clean up workspace
	all_objs <- ls()
	save_objs <- c("root_dir","p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
					"p_amboinensis","p_rubrio","smooth_proptable","species_proptable_by_year_gear_zone")
	remove_objs <- setdiff(all_objs, save_objs)
   rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # workspace no longer contains individual BBS records, can have in Github
  # save.image(paste(root_dir, "/output/03B_BBS_IDcorrections_species_proptables.RData", sep=""))
  





































#  -----------------------------------------------------------------------------------------------------------------------------------------------
#

