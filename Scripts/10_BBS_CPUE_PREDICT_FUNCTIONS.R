#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Functions to do the predictions based on GAM model objects and data sets stored in each output from 09_
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------

# ----- PRELIMINARIES
#  rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf

  # load all the libraries.
#  library(sqldf)
  library(dplyr)
  library(this.path)
#  library(ggfortify)		#  install.packages('ggfortify')
  library(data.table)		#  install.packages('data.table')
#  library(nFactors)		#  install.packages('nFactors')
#  library(fitdistrplus)
  library(mgcv)
#  library(formula.tools)	
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

 # make a relational table to tell us which covariate names are factors and which are continuous
  cov_types <- data.frame(cov_name = c('year_fac', 'hours_std', 'num_gear_fac', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', 'Moon_days', 'wdir', 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2','yday','month'), cov_type = c('fact', 'cont','fact','fact','cont',
			'fact','cont','fact','cont','cont','cont','cont','cont','fact','cont','cont','cont','cont','fact'))


 # models and data are stored in LUKA$ tutu $ pa $ pos $sp_data_all $sp_data_pos

# str(LUKA)
#	$ tutu [1]
#		$ pa  [1][1]
#			$model	  [1][1][1]
#			$sp_data_all  [1][1][2]
#		$ pos [1][2]
#			$model	  [1][2][1]
#			$sp_data_pos  [1][2][2]




# ----------------------  nominal CPUE function

  predict_nominal <- function(species, area) {

	this_species <- get(species)			# str(this_species)
	index_area <- match(area, names(this_species))

	sp_data_all <- this_species[[index_area]][[1]][[2]] 			#names(sp_data_all)

	agg_catch <- aggregate(sp_data_all$catch_lbs,
				 by=list(Group=sp_data_all$year_fac), FUN=sum)
	names(agg_catch)[] <- c("year_fac", "catch")

	agg_effort <- aggregate(sp_data_all$HOURS_FISHED,
				 by=list(Group=sp_data_all$year_fac), FUN=sum)
	names(agg_effort)[] <- c("year_fac","effort")

	count_ints <- data.frame(year_fac = names(summary(sp_data_all$year_fac)),
				n_ints = summary(sp_data_all$year_fac))

	agg_cpue_var <- aggregate(sp_data_all$catch_cpue,
				 by=list(Group=sp_data_all$year_fac), FUN=var)
	names(agg_cpue_var)[] <- c("year_fac","var_cpue")


	nom_cpue1 <- merge(x = agg_catch, y = agg_effort, by = "year_fac")
	nom_cpue2 <- merge(x = nom_cpue1, y = count_ints, by = "year_fac")
	nom_cpue3 <- merge(x = nom_cpue2, y = agg_cpue_var, by = "year_fac")

	nom_cpue <- mutate(nom_cpue3, cpue = catch/effort, stdev = sqrt(var_cpue), se = sqrt(var_cpue)/(n_ints-1))
	nom_cpue$species <- species
	nom_cpue$area <- area
	nom_cpue$type <- 'nominal'
	nom_cpue$year <- as.numeric(as.character(nom_cpue$year_fac))


	return(nom_cpue)

  }


# END NOMINAL CPUE FUNCTION   -----------------------------




# ---------------------- Use mode values for categorical variables to 
#	do predictions for the delta distribution GAM objects

  predict_delta_modes <- function(species, area) {

   # preliminaries
   this_species <- get(species)			# str(this_species)		#str(sp_data_all)		#str(sp_data_pos)
   index_area <- match(area, names(this_species))					#summary(pa_model)
   sp_data_all <- this_species[[index_area]][[1]][[2]] 				#names(pa_model)		#names(pos_model)
   pa_model <- this_species[[index_area]][[1]][[1]] 
   sp_data_pos <- this_species[[index_area]][[2]][[2]] 
   pos_model <- this_species[[index_area]][[2]][[1]] 
   first_year <- min(sp_data_all$year_num)
   last_year <- max(sp_data_all$year_num)
   pos_error <- summary(pos_model)$family$family


   # build the prediction datasets

   pa_pred_grid <- data.frame(year_fac = as.factor(seq(first_year, last_year, 1)))

   for(i in 2:length(pa_model$var.summary)) {
 	    this_var_name <- names(pa_model$var.summary)[i]
	      
		# for factor variables
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'fact') {
		add_me <- data.frame(new_col = rep(pa_model$var.summary[[i]][1],nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}

		# for continuous variables
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pa_model$var.summary[[i]][2],nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}

	  }


   pos_pred_grid <- data.frame(year_fac = as.factor(seq(first_year, last_year, 1)))

   for(i in 2:length(pos_model$var.summary)) {
 	    this_var_name <- names(pos_model$var.summary)[i]
	      
		# for factor variables
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'fact') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][1],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

		# for continuous variables
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][2],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

	  }


   # do the predictions 
   
   pred_pa = predict.gam(pa_model, newdata = pa_pred_grid, type = "response", se.fit = TRUE)
   pred_pos = predict.gam(pos_model, newdata = pos_pred_grid, type = "response", se.fit = TRUE)

   pred_delta <- data.frame(year = seq(first_year, last_year, 1), pa_raw = pred_pa$fit, pa_se = pred_pa$se.fit,
					pos_raw = pred_pos$fit, pos_se = pred_pos$se.fit)

   # correct for lognormal error if positive process was LnN
	if (pos_error == "gaussian") {
		MSE = summary(pos_model)$dispersion
	#	pred_delta$pos_correct = exp(pred_delta$pos_raw+(MSE/2))
		pred_delta$pos_correct = exp(pred_delta$pos_raw)
		pred_delta$pos_se_correct = exp(pred_delta$pos_raw)*(pred_delta$pos_se)
		}

	if (pos_error == "gamma") {
		pred_delta$pos_correct = pred_delta$pos_raw
		pred_delta$pos_se_correct = pred_delta$pos_se
		}
		

	# combine the 2 distributions
	pred_delta$delta_fit = pred_delta$pos_correct*pred_delta$pa_raw
		
	# Goodman 1960 golden rule:
	#	for 2 independent random variables X and Y:
	#	var(XY) = var(X)var(Y) + var(X)E(Y)^2 + Var(Y)E(X)^2
		
	pred_delta$delta_var = pred_delta$pa_se*pred_delta$pos_se_correct +
			pred_delta$pa_se*pred_delta$pos_correct^2 +
			pred_delta$pos_se_correct*pred_delta$pa_raw^2

	# sd = sqrt(var)
	pred_delta$delta_sd <- (pred_delta$delta_var)^(1/2)
	pred_delta$species <- species
	pred_delta$area <- area
	pred_delta$type <- 'delta_modes'

	return(pred_delta)
  }


# END Delta 2-distribution using categorical modes  -----------------------------


# example using these 2 functions: Luka tutuila
  	
	species = 'LUKA'
	area = 'tutu'
  	nom_luka <- predict_nominal(species, area)
	delta_luka_modes <- predict_delta_modes(species, area)



  str(nom_cpue_example)
  plot(as.numeric(as.character(nom_cpue_example$year_fac)), nom_cpue_example$cpue, pch = 1)












summary(pa_model)
str(pa_model)





# ---------------------- Use Walter's Large Table (WLT, marginal means) to 
#	do predictions for the delta distribution GAM objects

  predict_delta_WLT <- function(species, area) {

   # preliminaries
   this_species <- get(species)			# str(this_species)		#str(sp_data_all)		#str(sp_data_pos)
   index_area <- match(area, names(this_species))
   sp_data_all <- this_species[[index_area]][[1]][[2]] 				#names(pa_model)		#names(pos_model)
   pa_model <- this_species[[index_area]][[1]][[1]] 
   sp_data_pos <- this_species[[index_area]][[2]][[2]] 
   pos_model <- this_species[[index_area]][[2]][[1]] 

   # build the presence/absence prediction grid

  	# categorical covariables
	  pa_pred_grid <- expand.grid(pa_model$xlevels)			#head(pa_pred_grid)		#str(pa_pred_grid)
 	  pa_pred_grid_name = data.frame(grid_name = apply(pa_pred_grid[,1:length(pa_model$xlevels)],1,paste0,collapse="_"))

  	# add on median values for continous variables
   	  for(i in 1:length(pa_model$var.summary)) {
 	    this_var_name <- names(pa_model$var.summary)[i]
	      if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pa_model$var.summary[[i]][2],nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}
	  }


   # build the positive process prediction grid

  	# categorical covariables
	  pos_pred_grid <- expand.grid(pos_model$xlevels)			#head(pos_pred_grid)		#str(pos_pred_grid)
 	  pos_pred_grid_name = data.frame(grid_name = apply(pos_pred_grid[,1:length(pos_model$xlevels)],1,paste0,collapse="_"))

  	# add on median values for continous variables
   	  for(i in 1:length(pos_model$var.summary)) {
 	    this_var_name <- names(pos_model$var.summary)[i]
	      if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][2],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}
	  }


### predict for each grid (and mean continuous variables)

pred_pa = predict.gam(fitobject$tutu$pa$model, newdata = pa_pred_grid, type = "response", se.fit = TRUE)		#str(pred_pa)



#  -------------- positive process

### build the prediction grid

  # categorical covariables
	pos_pred_grid <- expand.grid(fitobject$tutu$pos$model$xlevels)			#head(pos_pred_grid)		#View(pos_pred_grid)
	# pred_grid_name = data.frame(grid_name = apply(pa_pred_grid[,1:length(fitobject$tutu$pa$model$xlevels)],1,paste0,collapse="_"))

  # add on median values for continous variables
   for(i in 1:length(fitobject$tutu$pos$model$var.summary)) {
 	this_var_name <- names(fitobject$tutu$pos$model$var.summary)[i]
	if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(fitobject$tutu$pos$model$var.summary[[i]][2],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(fitobject$tutu$pos$model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}
	}


### predict for each grid (and mean continuous variables)

pred_pos = predict.gam(fitobject$tutu$pos$model, newdata = pos_pred_grid, type = "response", se.fit = TRUE)		#str(pred_pos)










 #	pa_pred_grid <- cbind(pa_pred_grid, pred_grid_name)


























  # assign a weight for each prediction grid cell based on number of interviews
	pa_fac_vars <- names(fitobject$tutu$pa$model$xlevels)
	index_fac <- match(pa_fac_vars, names(fitobject$tutu$pa$sp_data_all))
	u_strata = data.frame(grid_name = apply(fitobject$tutu$pa$sp_data_all[,index_fac],1,paste0,collapse="_"))		
			# head(u_strata)		#str(u_strata)		#str(fitobject$tutu$pa$sp_data_all)
	count_grid <- cbind(fitobject$tutu$pa$sp_data_all, u_strata)			#head(count_grid)		#str(count_grid)
	
	obs_per_strata <- data.frame(grid_name = names(table(count_grid$grid_name)),
				n_obs = table(count_grid$grid_name))					# head(obs_per_strata)		#View(obs_per_strata)
	obs_per_strata <- obs_per_strata[,c(-2)]
	names(obs_per_strata)[2] <- 'n_obs'

	pa_pred_grid_2 <- merge(x=pa_pred_grid, y=obs_per_strata, by='grid_name', all.x = TRUE)			#View(pa_pred_grid_2)

	pa_pred_grid_weights <- mutate(pa_pred_grid_2, weight = (nrow(fitobject$tutu$pa$sp_data_all)/nrow(pa_pred_grid))*(1/n_obs))
	# View(pa_pred_grid_weights)




see_2021 <- subset(fitobject$tutu$pa$sp_data_all, year_fac == '2021')
View(see_2021)
write.csv(see_2021, "see_2021.csv")




	#  put the strata weights back onto the prediction grid   # Equation 13a from Campbell 2015	
	sim.cpue.df$strata.weight = rep(NA,nrow(sim.cpue.df))
		for(w in 1:nrow(sim.cpue.df))
		{
			sim.cpue.df$strata.weight[w] = (nrow(sim.cpue.df)/nrow(obs.per.strata)) * (1/obs.per.strata$N[which(obs.per.strata$strata == sim.cpue.df$u.strata[w])]) 
		}







	obs.per.strata = as.data.frame(cbind(names(table(fitobject$tutu$pa$sp_data_all$grid_name)),		#head(obs.per.strata)
				table(fitobject$tutu$pa$sp_data_all$grid_name)))	


str(u.strata)
str(fitobject$tutu$pa$sp_data_all)

paste(fitobject$tutu$pa$sp_data_all[,index_fac], sep="_")

	
str(u.strata)


fitobject$tutu$pa$sp_data_all


str(fitobject$tutu$pa$model)




for (i in 1:7) {
print(is.factor(is.factor(fitobject$tutu$pa$model$var.summary[i]) == FALSE)
}


is.numeric(str(this_model$var.summary))
pa_pred_grid <- mutate(pa_pred_grid, NEW_VAR =  5) }


# extract what we want to know from the fitted model object

pa_fac_vars <- names(fitobject$tutu$pa$model$xlevels)
pa_fac_vars_levels <- fitobject$tutu$pa$model$xlevels

pa_fac_vars <- list()
pa_con_vars <- list()

for i in 1:length(this_model$var.summary) {

	if(is.factor(this_model$var.summary[i])) {
		pa_

pred_grid <- expand.grid(year_fac = as.character(levels(this_model$var.summary[1])), season = as.character(this_model$var.summary[1]))[,c(2,1)]
View(pred_grid)

month.index = expand.grid(Month = as.numeric(as.character(unique(sim.cpue.df$Month))),Year = as.numeric(as.character(unique(sim.cpue.df$Year))))[,c(2,1)]
		month.index$nom.cpue = NA
	

new.data3 = expand.grid(year_fac = as.numeric(pa_fac_vars_levels[1]), season = pa_fac_vars_levels[4], TYPE_OF_DAY = pa_fac_vars_levels[3])
View(new.data3)
	


pa_fac_vars_levels[1]

pa_summary_fitobject <- summary(fitobject$tutu$pa$model)
pa_terms <- (names(pa_summary_fitobject$pTerms.pv))



pos_summary_fitobject <- summary(fitobject$tutu$pos$model)
pos_terms <- (names(pos_summary_fitobject$pTerms.pv))





pa_formula <- summary(fitobject$tutu$pa$model)


pos_formula <- 

str(this_model$var.summary)
levels(this_model$var.summary[1])
str(attributes(this_model$var.summary[1]))

this_model$var.summary[[7]][2]

 
this_model <- LUKA$tutu$pa$model
str(this_model)
this_model$xlevels[1]

these_data <- LUKA$tutu$pa$sp_data_all
head(these_data)

$SOI
[1] -4.4  0.1  4.8

summary(these_data$SOI)


names(LUKA$tutu$pa)
attr(this_model$var.summary)


length(names(this_model$xlevels))
length(names(this_model$xlevels))

try1 <- expand.grid(year = unique(this_model$xlevels[1]), season = unique(this_model$xlevels[4]))

try2 <- expand.grid(this_model$xlevels)

[1]
cov_types <- data.frame(cov_name = c('year_fac', 'hours_std', 'num_gear_fac', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', 'Moon_days', 'wdir', 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2'), cov_type = c('fact', 'cont','fact','fact','cont',
			'fact','cont','fact','cont','cont','cont','cont','cont','fact','cont','cont','cont'))



model_vars <- names(this_model$model)
model_vars[1]

# build the prediction grid for the categorical variables.
length(this_model$xlevels)

# for continuous variables, lists mean, median, max.
this_model$var.summary


new.data1 = expand.grid(Year = as.factor(this_model$xlevels[1]), V2 = data.frame(this_model$xlevels[2]), 
				V3=data.frame(this_model$xlevels[3]))		#View(new.data1)

		new.data1$Gear = rep(Mode(sim.cpue.df$Gear),nrow(new.data1))
		new.data1$Depth = rep(Mode(sim.cpue.df$Depth),nrow(new.data1))
		new.data1$Technology = rep(Mode(sim.cpue.df$Technology),nrow(new.data1))     
		




str(cpue_datasets)

ls()




















































#  --------------------------------------------------------------------------------------------------------------
































