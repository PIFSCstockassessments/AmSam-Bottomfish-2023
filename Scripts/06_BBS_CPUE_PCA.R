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

  # rename duplicate group SPECIES_FK in cases of complete union:
	# Jacks (110) and Trevally (109)
	# Groupers (210) and Inshore groupers (380)
	# Deep snappers (230) and Inshore snappers (390)
	bbs_3C$SPECIES_FK[bbs_3C$SPECIES_FK == 109] <- 110
	bbs_3C$SPECIES_FK[bbs_3C$SPECIES_FK == 380] <- 210
	bbs_3C$SPECIES_FK[bbs_3C$SPECIES_FK == 390] <- 230




#  ---   BY AREA   -------------------------------------------
#	The Tutuila/Banks and Manu'a Islands are essentially distinct fleets and we are going to standardize CPUE by area anyway.
#	Repeat the PCA analysis (including 99th percentile species selection), but do by area 

# --------- MANU'A
# ---- simplify to INTERVIEW_PK, catch by species

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0') AND AREA_B2 = 'Manua') 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 818 interviews
	length(unique(bbs_1$SPECIES_FK))		# 77 species (including groups)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	# View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)	#86 species, including all 11 BMUS
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 816 interviews
	length(unique(bbs_2$SPECIES_FK))		# 47 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:ncol(bbs_3)]/rowSums(bbs_3[,2:ncol(bbs_3)])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- first 2 PCs combined account for 22.2% of species comp.

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

	# the answer is 2		

	# SAVE
	PCA_Manua <- PCA					#PCA$rotation[,1:2]
	# output pretty figure

	PCA_manua <- autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+
			theme_bw() + theme(text=element_text(size=14))
	ggsave("PCA_manua.png",PCA_manua,width=4.15, height=4.15, units="in")

	# create INTERVIEW_PK and predicted PC values for each. Just do first 2.
	PCA_Manua$x[,1]
	int_PC_Manua <- as.data.frame(cbind(bbs_3[,1],PCA_Manua$x[,1:2]))
	head(int_PC_Manua)
	str(int_PC_Manua)


# --------- Tutuila					
# ---- simplify to INTERVIEW_PK, catch by species				# summary(as.factor(bbs_3C$AREA_B2))

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0') AND AREA_B2 = 'Tutuila') 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 1725 interviews
	length(unique(bbs_1$SPECIES_FK))		# 210 species (including groups)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	# View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)	#86 species, including all 11 BMUS
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 1722 interviews
	length(unique(bbs_2$SPECIES_FK))		# 86 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:ncol(bbs_3)]/rowSums(bbs_3[,2:ncol(bbs_3)])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- first 2 PCs combined account for 7.8% of species comp.

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

	# the answer is 13	


	# SAVE
	PCA_Tutuila <- PCA					#PCA$rotation[,1:2]
	# output pretty figure

	PCA_tutu_plot <- autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+
			theme_bw() + theme(text=element_text(size=14))
	ggsave("PCA_tutuila.png",PCA_tutu_plot,width=4.15, height=4.15, units="in")


	# create INTERVIEW_PK and predicted PC values for each. Just do first 2.
	int_PC_Tutuila <- as.data.frame(cbind(bbs_3[,1],PCA_Tutuila$x[,1:2]))
	str(int_PC_Tutuila)




# --------- Banks (south + east)					
# ---- simplify to INTERVIEW_PK, catch by species				# summary(as.factor(bbs_3C$AREA_B2))

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0') 
				AND AREA_B2 IN ('Bank_E',  'Bank_S')) 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 152 interviews
	length(unique(bbs_1$SPECIES_FK))		# 88 species (including groups)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	# View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 152 interviews
	length(unique(bbs_2$SPECIES_FK))		# 56 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:ncol(bbs_3)]/rowSums(bbs_3[,2:ncol(bbs_3)])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- first 2 PCs combined account for 7.8% of species comp.

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

	# the answer is 8	

	# SAVE
	PCA_Banks <- PCA					#PCA$rotation[,1:2]
	# output pretty figure

	PCA_banks_plot <- autoplot(PCA_Banks,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+
			theme_bw() + theme(text=element_text(size=14))
	ggsave("PCA_banks.png",PCA_banks_plot,width=4.15, height=4.15, units="in")

	# create INTERVIEW_PK and predicted PC values for each. Just do first 2.
	int_PC_Banks <- as.data.frame(cbind(bbs_3[,1],PCA_Banks$x[,1:2]))
	str(int_PC_Banks)

	#------------------- put all together
	ints_PCs <- rbind(int_PC_Tutuila,int_PC_Banks,int_PC_Manua)



 # -------------------------------------------------------------------------------------------------------------------------------
 # clean up workspace, save just the PCA stuff
	all_objs <- ls()
	save_objs <- c("PCA_Banks", "PCA_Manua", "PCA_Tutuila", "ints_PCs","root_dir")
	remove_objs <- setdiff(all_objs, save_objs)
    rm(list=remove_objs)
	rm(save_objs)
	rm(remove_objs)
	rm(all_objs)

  # save.image(paste(root_dir, "/output/06_BBS_CPUE_PCA.RData", sep=""))
	# save.image(paste(root_dir, "/Outputs/06_BBS_CPUE_PCA.RData", sep=""))
	


























#------------------------------------------------------
#  not used  ----------------------------------------

# --------- Tutuila + Banks (south + east)					
# ---- simplify to INTERVIEW_PK, catch by species				# summary(as.factor(bbs_3C$AREA_B2))

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0') 
				AND AREA_B2 IN ('Bank_E',  'Bank_S', 'Tutuila')) 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 1877 interviews
	length(unique(bbs_1$SPECIES_FK))		# 211 species (including groups)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	# View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	# View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 1874 interviews
	length(unique(bbs_2$SPECIES_FK))		# 85 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables		#

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:ncol(bbs_3)]/rowSums(bbs_3[,2:ncol(bbs_3)])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- first 2 PCs combined account for 7.8% of species comp.

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

	# the answer is 8	





#  ALL AREAS COMBINED

	string <- "SELECT INTERVIEW_PK, SPECIES_FK, SCIENTIFIC_NAME, SUM(EST_LBS) as TOT_LBS
		  FROM
			(SELECT DISTINCT INTERVIEW_PK, CATCH_PK, SPECIES_FK, SCIENTIFIC_NAME, EST_LBS
			FROM bbs_3C
			WHERE year_num < 2021 AND year_num > 1987 AND SPECIES_FK NOT IN ('NULL','0')
				AND AREA_B2 IN ('Bank_E','Bank_S','Tutuila','Manua')) 
		  GROUP BY INTERVIEW_PK, SPECIES_FK"
	bbs_1 <- sqldf(string, stringsAsFactors=FALSE)

	length(unique(bbs_1$INTERVIEW_PK))		# 2695 interviews
	length(unique(bbs_1$SPECIES_FK))		# 213 species (including group level)

# --- retain only the top species comprising 99% cumulative catch

	string <- "SELECT SPECIES_FK, SCIENTIFIC_NAME, sum(TOT_LBS) as SP_TOT
		  FROM bbs_1
		  GROUP BY SPECIES_FK
		  ORDER BY SP_TOT DESC"
	sp_1 <- sqldf(string, stringsAsFactors=FALSE)
	#  View(sp_1)

  	sp_2 <- mutate(sp_1, CUM_SP_TOT = cumsum(SP_TOT))
	sp_3 <- mutate(sp_2, CUM_PERCENT = CUM_SP_TOT/sum(SP_TOT))
	#  View(sp_3)

	keep_species <- subset(sp_3, CUM_PERCENT <= 0.99)			# View(keep_species)	#83 species, including all 11 BMUS
	# which species did we lose?
	remove_species <- subset(sp_3, CUM_PERCENT > 0.99)			# View(remove_species)

 	string <- "SELECT bbs_1.*, keep_species.CUM_PERCENT
		FROM keep_species
		LEFT JOIN bbs_1
			ON keep_species.SPECIES_FK = bbs_1.SPECIES_FK"

	bbs_2 <- sqldf(string, stringsAsFactors=FALSE)			#View(bbs_2)
	length(unique(bbs_2$INTERVIEW_PK))		# 2692 interviews:   we lost 3 interviews that only caught rare species
	length(unique(bbs_2$SPECIES_FK))		# 83 species (including groups)

# --- convert to wide form, calculate prop catch, 4th root
# 		use {data.table} dcast() for a handy way to convert long- to wide- form data tables

	bbs_3 <- dcast(as.data.table(bbs_2), INTERVIEW_PK ~ SPECIES_FK, value.var = 'TOT_LBS')
	bbs_3[is.na(bbs_3)] <- 0 

	props <- bbs_3[,2:ncol(bbs_3)]/rowSums(bbs_3[,2:ncol(bbs_3)])
	props_4 <- (props)^(1/4)

	bbs_4 <- cbind(bbs_3[,1],props_4)					#View(bbs_4)

# --- do the PCA

	PROPS <- bbs_4[,-1]
	PCA <- prcomp(PROPS,center=T,scale.=T)
	summary(PCA)
	autoplot(PCA,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+theme_bw()

# --- 83 species, so first 2 PCs combined account for only 9.7% of species comp.
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
	#	data grouped by specified gear type (fleet) a priori)		


	# SAVE
	PCA_all <- PCA					#PCA$rotation[,1:2]
	# output pretty figure

	PCA_all_plot <- autoplot(PCA_all,loadings=T,loadings.label=T,loadings.label.colour="black",loadings.colour="black", colour="lightgrey")+
			theme_bw() + theme(text=element_text(size=14))
	ggsave("PCA_all.png",PCA_all_plot,width=4.15, height=4.15, units="in")





























































#
