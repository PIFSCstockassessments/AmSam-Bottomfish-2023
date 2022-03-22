#  -----------------------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA boat-based creel survey
#	Winker et al. 2013 direct principal component analysis of species proportional catch to create a targeting covariable.
#
#   ----------------------------------------------------------------------------------------------------------------------------
#   Based on Marc's PCA targeting code used in the Uku Assessment
#
#   Erin Bohaboy erin.bohaboy@noaa.gov
#	
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


 
# ---- simplify to INTERVIEW_PK, catch by species
#	we don't have 2021 data yet, and we know 1986/1987 species IDs were incomplete, so use 1988-2020 only

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0')) 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 2741 interviews
	length(unique(bbs_1$SPECIES_FK))		# 217 species (including groups)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)	#86 species, including all 11 BMUS
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 2718 interviews:   we lost 23 interviews (0.84%)
	length(unique(bbs_2$SPECIES_FK))		# 86 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:87]/rowSums(bbs_3[,2:87])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- 86 species, so first 2 PCs combined account for only 15% of species comp.
#	this does not seem very impressive

# ---- this is Marc's uku code verbatum...

	# Implement non-graphical Scree test to select best PCs (Winker et al. 2014)
	eigenvalues <- PCA$sdev^2   # Extracts the observed eigenvalues
	nsubjects   <- nrow(PROPS)  # Extracts the number of subjects
	variables   <- length(eigenvalues) # Computes the number of variables   
	rep         <- 100 # Number of replications for PA analysis
	cent        <- 0.95 # Centile value of PA analysis

	## PARALLEL ANALYSIS (qevpea for the centile criterion, mevpea for the mean criterion)
	aparallel <- parallel(var = variables,
                      subject = nsubjects,
                      rep = rep,
                      cent = cent)$eigen$qevpea  

	## NUMBER OF FACTORS RETAINED ACCORDING TO DIFFERENT RULES
	results <- nScree(x=eigenvalues, aparallel=aparallel)
	NF      <- results$Analysis
	plotnScree(results)

	# Number of factors to keep for CPUE standardization model is the min of the Optimal Coordinate and Kaiser rule (Winker 2014)
	for(i in 1:variables) if(NF$Eigenvalues[i]>=1&(NF$Eigenvalues[i]>=NF$Pred.eig[i])){PC_KEEP<-i}else{break} 

	# the answer is 13... seems like a lot, really. Uku had 4 (but, way more data, way fewer species, 
	#	data grouped by specified gear type a priori)		



  # DISCUSS: SHOULD THIS BE DONE BY GEAR AND AREA? (because CPUE standardization will prob. be done that way). 
  #	Erin try it???














































#
