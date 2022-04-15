#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA BOAT-BASED CREEL SURVEY CPUE
#	Functions to do the predictions based on GAM model objects and data sets stored in each output from 09_
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
  library(ggplot2)
  library(magrittr)
  library(gridExtra)
  library(grid)
  library(cowplot)
  library(lattice)
  library(ggplotify)

 # establish directories using this.path::
 # root_dir <- this.path::here(.. = 1)

 # load ggplot theme
  source(paste0(this.path::here(.. = 1), "/Scripts/LOAD_Theme.R"))

 # read in prepared CPUE datasets with best fit functions
 # load(paste(root_dir, "/output/09_BBS_CPUE_FIT_MODELS.RData", sep=""))

 # make a relational table to tell us which covariate names are factors and which are continuous
  cov_types <- data.frame(cov_name = c('year_fac', 'hours_std', 'num_gear_fac', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
			'ENSO', 'Moon_days', 'wdir', 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2','yday','month'), cov_type = c('fact', 'cont','fact','fact','cont',
			'fact','cont','fact','cont','smooth','smooth','cont','cont','fact','cont','cont','cont','smooth','fact'))


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
   pa_model <- this_species[[index_area]][[1]][[1]] 					#summary(pos_model)
   sp_data_pos <- this_species[[index_area]][[2]][[2]] 				
   pos_model <- this_species[[index_area]][[2]][[1]] 
   first_year <- min(sp_data_all$year_num)
   last_year <- max(sp_data_all$year_num)
   pos_error <- summary(pos_model)$family$family
   pa_years <- unique(sp_data_all$year_fac)
   pos_years <- unique(sp_data_pos$year_fac)

	# sp_data_pos_Ln <- sp_data_pos		#thing <- hist(sp_data_pos$yday)		#hist(sp_data_pos$PC2)
	# plot(pos_model, all.terms = TRUE)		#hist(sp_data_pos$prop_unid,breaks=40)
 	# sp_data_pos_Ln <-  sp_data_pos
  	# plot(pos_model, all.terms = TRUE, SE=TRUE , rug = TRUE)


   # build the prediction datasets

   pa_pred_grid <- data.frame(year_fac = pa_years)

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

		# for smooth variables use mode
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'smooth') {
		this_var_hist <- hist(sp_data_all[,names(sp_data_all)==this_var_name], plot = FALSE)
		this_var_mode <- this_var_hist$mids[max(this_var_hist$counts)==this_var_hist$counts]
		add_me <- data.frame(new_col = rep(this_var_mode,nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}
	  }


   pos_pred_grid <- data.frame(year_fac = pos_years)

   for(i in 2:length(pos_model$var.summary)) {
 	    this_var_name <- names(pos_model$var.summary)[i]
	      
		# for factor variables use mode
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'fact') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][1],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

		# for continuous variables use median
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][2],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

		# for smooth variables use mode
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'smooth') {
		this_var_hist <- hist(sp_data_pos[,names(sp_data_pos)==this_var_name], plot = FALSE)
		this_var_mode <- this_var_hist$mids[max(this_var_hist$counts)==this_var_hist$counts]
		add_me <- data.frame(new_col = rep(this_var_mode,nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

	  }



   # do the predictions    
   pred_pa = predict.gam(pa_model, newdata = pa_pred_grid, type = "response", se.fit = TRUE)
   pred_pos = predict.gam(pos_model, newdata = pos_pred_grid, type = "response", se.fit = TRUE)

   # put together the processes
   pred_pa_yrs <- data.frame(year = as.numeric(as.character(pa_years)), pa_raw = pred_pa$fit, pa_se = pred_pa$se.fit)
   pred_pos_yrs <- data.frame(year = as.numeric(as.character(pos_years)), pos_raw = pred_pos$fit, pos_se = pred_pos$se.fit)

   pred_pa_yrs <- pred_pa_yrs[order(pred_pa_yrs$year),]			#str(pred_pa_yrs)
   pred_pa_yrs <- pred_pa_yrs[order(pred_pa_yrs$year),]			#str(pred_pos_yrs)

   pred_delta <- merge(x = pred_pa_yrs, y = pred_pos_yrs, by='year', all.x = TRUE)


   # correct for lognormal error if positive process was LnN
	if (pos_error == "gaussian") {
		 MSE = summary(pos_model)$dispersion
		 pred_delta$pos_correct = exp(pred_delta$pos_raw+(MSE/2))
		# pred_delta$pos_correct = exp(pred_delta$pos_raw)
		pred_delta$pos_se_correct = exp(pred_delta$pos_raw)*(pred_delta$pos_se)
		}

	if (pos_error == "Gamma") {
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
 	# IF the species wasn't observed for a year, probability of occurence (pa_raw) will be very close to zero
	# 	and se of the pa process will be small. Since there were no data to fit the positive process, the 
	#     'NA' will carry through and there will be no CPUE estimate for that year.

	# sd = sqrt(var)
	pred_delta$delta_sd <- (pred_delta$delta_var)^(1/2)
	pred_delta$species <- species
	pred_delta$area <- area
	pred_delta$type <- 'delta_modes'

	return(pred_delta)
  }


# END Delta 2-distribution using categorical modes  -----------------------------



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
   first_year <- min(sp_data_all$year_num)
   last_year <- max(sp_data_all$year_num)
   pos_error <- summary(pos_model)$family$family
   pa_years <- unique(sp_data_all$year_fac)
   pos_years <- unique(sp_data_pos$year_fac) 

   # build the prediction datasets

	# presence/absence
	# for categorical variables, do large table
	pa_pred_grid <- expand.grid(pa_model$xlevels)			#head(pa_pred_grid)		#str(pa_pred_grid)
 	#  pa_pred_grid_name = data.frame(grid_name = apply(pa_pred_grid[,1:length(pa_model$xlevels)],1,paste0,collapse="_"))

	# add on median values for continous variables, mode values for smooths
	for(i in 2:length(pa_model$var.summary)) {
 	    this_var_name <- names(pa_model$var.summary)[i]
	
	# for continuous variables
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pa_model$var.summary[[i]][2],nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}

	# for smooth variables use mode
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'smooth') {
		this_var_hist <- hist(sp_data_all[,names(sp_data_all)==this_var_name], plot = FALSE)
		this_var_mode <- this_var_hist$mids[max(this_var_hist$counts)==this_var_hist$counts]
		add_me <- data.frame(new_col = rep(this_var_mode,nrow(pa_pred_grid)))
		names(add_me) <- as.character(names(pa_model$var.summary)[i]) 
		pa_pred_grid <- cbind(pa_pred_grid, add_me)
		rm(add_me)
		}
	  }

   # build the positive process prediction grid

  	# categorical covariables
	  pos_pred_grid <- expand.grid(pos_model$xlevels)			#head(pos_pred_grid)		#str(pos_pred_grid)
 	#  pos_pred_grid_name = data.frame(grid_name = apply(pos_pred_grid[,1:length(pos_model$xlevels)],1,paste0,collapse="_"))
 
	# add on median values for continous variables, mode values for smooths
	for(i in 2:length(pos_model$var.summary)) {
 	    this_var_name <- names(pos_model$var.summary)[i]

		# for continuous variables use median
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'cont') {
		add_me <- data.frame(new_col = rep(pos_model$var.summary[[i]][2],nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}

		# for smooth variables use mode
		if (cov_types$cov_type[cov_types$cov_name==this_var_name] == 'smooth') {
		this_var_hist <- hist(sp_data_pos[,names(sp_data_pos)==this_var_name], plot = FALSE)
		this_var_mode <- this_var_hist$mids[max(this_var_hist$counts)==this_var_hist$counts]
		add_me <- data.frame(new_col = rep(this_var_mode,nrow(pos_pred_grid)))
		names(add_me) <- as.character(names(pos_model$var.summary)[i]) 
		pos_pred_grid <- cbind(pos_pred_grid, add_me)
		rm(add_me)
		}
	  }


   	# do the predictions    
   	pred_pa = predict.gam(pa_model, newdata = pa_pred_grid, type = "response", se.fit = TRUE)
   	pred_pos = predict.gam(pos_model, newdata = pos_pred_grid, type = "response", se.fit = TRUE)

  	# put predictions back onto the prediction grids and take marginal means

		# presence/absence
		pred_pa_df <- data.frame(pa_raw = pred_pa$fit, pa_se = pred_pa$se.fit)
   		pred_pa_yrs <- cbind(pa_pred_grid,pred_pa_df)				# head(pred_pa_yrs)	#str(pred_pa_yrs)
		mm_pa_fit <- with(pred_pa_yrs, tapply(pa_raw, year_fac, mean))
		mm_pa_se <- with(pred_pa_yrs, tapply(pa_se, year_fac, mean))
		marg_means_pa <- data.frame(year = as.numeric(names(mm_pa_fit)), pa_raw = mm_pa_fit, pa_se = mm_pa_se)

		# positive process
		pred_pos_df <- data.frame(pos_raw = pred_pos$fit, pos_se = pred_pos$se.fit)
		pred_pos_yrs <- cbind(pos_pred_grid,pred_pos_df)			# head(pred_pos_yrs)
	
		  # correct for lognormal error if positive process was LnN
		  if (pos_error == "gaussian") {
		  MSE = summary(pos_model)$dispersion
		  pred_pos_yrs$pos_correct = exp(pred_pos_yrs$pos_raw+(MSE/2))
		  pred_pos_yrs$pos_se_correct = exp(pred_pos_yrs$pos_raw)*(pred_pos_yrs$pos_se)
		  }

		  if (pos_error == "Gamma") {
		  pred_pos_yrs$pos_correct = pred_pos_yrs$pos_raw
		  pred_pos_yrs$pos_se_correct = pred_pos_yrs$pos_se
		  }
		
		mm_pos_raw <- with(pred_pos_yrs, tapply(pos_raw, year_fac, mean))
		mm_pos_fit <- with(pred_pos_yrs, tapply(pos_correct, year_fac, mean))
		mm_pos_se_raw <- with(pred_pos_yrs, tapply(pos_se, year_fac, mean))
		mm_pos_se <- with(pred_pos_yrs, tapply(pos_se_correct, year_fac, mean))
		marg_means_pos <- data.frame(year = as.numeric(names(mm_pos_fit)), pos_raw = mm_pos_raw, pos_se = mm_pos_se_raw, 
						pos_correct = mm_pos_fit, pos_se_correct = mm_pos_se)						#str(marg_means_pos)

	# put together the processes
  	marg_means_pos <- marg_means_pos[order(marg_means_pos$year),]			#str(pred_pa_yrs)
   	marg_means_pa <- marg_means_pa[order(marg_means_pa$year),]			#str(pred_pos_yrs)
   	pred_delta <- merge(x = marg_means_pa, y = marg_means_pos, by='year', all.x = TRUE)

	# calculate delta predictions and se
	pred_delta$delta_fit = pred_delta$pos_correct*pred_delta$pa_raw
		
	# Goodman 1960 golden rule:
	#	for 2 independent random variables X and Y:
	#	var(XY) = var(X)var(Y) + var(X)E(Y)^2 + Var(Y)E(X)^2
		
	pred_delta$delta_var = pred_delta$pa_se*pred_delta$pos_se_correct +
			pred_delta$pa_se*pred_delta$pos_correct^2 +
			pred_delta$pos_se_correct*pred_delta$pa_raw^2
 	# IF the species wasn't observed for a year, probability of occurence (pa_raw) will be very close to zero
	# 	and se of the pa process will be small
	# Positive process is 'NA' and that will carry through the multiplication so CPUE for that year is simply missing.

	# sd = sqrt(var)
	pred_delta$delta_sd <- (pred_delta$delta_var)^(1/2)
	pred_delta$species <- species
	pred_delta$area <- area
	pred_delta$type <- 'delta_WLT'

	return(pred_delta)

   }



# ---------------------- END Walter's Large Table (WLT, marginal means) 


# species = 'LUKA'


# ---------------------- Plot the predicted indices
#	it would be neat to add the number of positive observations per year to each plot somehow
#		(without it getting too busy).


  plot_CPUE <- function(species) {

  area_vector <- c("tutu","manu","banks")
  area_proper_names <- c("Tutuila","Manu'a Islands","Banks")

  for (i in 1:3) {
	this_area <- area_vector[i]
  	assign(paste0('nom_',this_area),predict_nominal(species,this_area))
	assign(paste0('delta_modes_',this_area),predict_delta_modes(species,this_area))
	assign(paste0('delta_WLT_',this_area),predict_delta_WLT(species,this_area))
	}

  # put these together in a ggplot-friendly object

	nom_all <- rbind(nom_tutu, nom_manu, nom_banks)
	
      delta_all <- rbind(delta_modes_tutu, delta_modes_manu, delta_modes_banks, delta_WLT_tutu, delta_WLT_manu, delta_WLT_banks)
	delta_all_2 <- data.frame(year=delta_all$year, n_ints = NA, cpue = delta_all$delta_fit, cpue_sd = delta_all$delta_sd, 
						species = delta_all$species, area = delta_all$area, type = delta_all$type)
	nom_all_2 <- data.frame(year= nom_all$year, n_ints = nom_all$n_ints, cpue = nom_all$cpue, cpue_sd = nom_all$stdev, 
						species = nom_all$species, area = nom_all$area, type = nom_all$type)

	
	all_cpue <- rbind(nom_all_2, delta_all_2)			#str(all_cpue)
	all_cpue$species <- as.factor(all_cpue$species)
	all_cpue$area <- as.factor(all_cpue$area)
	all_cpue$type <- as.factor(all_cpue$type)


   # make ggplot objects: each area and a legend

	CPUE_type_colors <- c("nominal"="#00467F", "delta_WLT"="#4C9C2E", "delta_modes"="#FF8300")
	CPUE_type_shapes <- c("nominal"=as.numeric(19), "delta_WLT"=as.numeric(1), "delta_modes"=as.numeric(1))
	CPUE_type_lines <- c("nominal"="blank", "delta_WLT"="solid", "delta_modes"="solid")
	CPUE_type_size <- c("nominal"=as.numeric(1), "delta_WLT"=as.numeric(0), "delta_modes"=as.numeric(0))

	for (i in 1:3) {
	  this_area <- area_vector[i] 
	  plot_me <- subset(all_cpue, area == area_vector[i])  

	  max_y_axis	<- round(max(plot_me$cpue, na.rm=TRUE),0)
	  x_ticks = seq(1985,2025,5)
	  x_tick_height = max_y_axis/40
	  y_ticks = seq(0,max_y_axis,1)

	  assign(paste("p_",i,sep=""),
	    ggplot(data=plot_me, aes(x=year,y=cpue, group = type)) +
		geom_point(aes(shape=type, color=type, size=type)) +			# return point size to 1 
		scale_shape_manual(values=CPUE_type_shapes) +
		scale_color_manual(values=CPUE_type_colors) +
		scale_size_manual(values=CPUE_type_size) +
		geom_line(aes(color=type, linetype=type)) +
		scale_linetype_manual(values=CPUE_type_lines) +
		theme_datareport_size_comp() +
		geom_segment(y=0,yend=0,x=0,xend=3000, color="black") +
		geom_segment(y=0,yend=max_y_axis,x=1986,xend=1986, color="black") +
		scale_x_continuous(limits=c(1987,2022), breaks=x_ticks) +
		scale_y_continuous(limits=c(0,max_y_axis)) +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[1],xend=x_ticks[1],color="black") +
 		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[2],xend=x_ticks[2],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[3],xend=x_ticks[3],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[4],xend=x_ticks[4],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[5],xend=x_ticks[5],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[6],xend=x_ticks[6],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[7],xend=x_ticks[7],color="black") +
		geom_segment(y=0,yend=-x_tick_height,x=x_ticks[8],xend=x_ticks[8],color="black") +
		geom_segment(y=y_ticks[1],yend=y_ticks[1],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[2],yend=y_ticks[2],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[3],yend=y_ticks[3],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[4],yend=y_ticks[4],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[5],yend=y_ticks[5],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[6],yend=y_ticks[6],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[7],yend=y_ticks[7],x=1986,xend=1985,color="black") +
		geom_segment(y=y_ticks[8],yend=y_ticks[8],x=1986,xend=1985,color="black") +
	     theme(plot.title = element_text()) +
	     theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	     theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = area_proper_names[i])
	   )
	}
	
	grob_ylab <- textGrob("CPUE (lbs/hour)", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)

	grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
	grob_main <- species
	
	# make legend
	
	p1_legend <- p_1 + theme(legend.position = "right", legend.title = element_blank(), legend.justification = "center")
	leg <- get_legend(p1_legend)

	species_plot <- grid.arrange(p_1, p_2, p_3, leg, ncol=2,left = grob_ylab, bottom = grob_xlab, top = grob_main)
	
	return(list(plot = species_plot, predicted_cpue = all_cpue))

 }




















#  --------------------------------------------------------------------------------------------------------------


