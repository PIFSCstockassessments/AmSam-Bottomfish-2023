
#  --------------------------------------------------------------------------------------------------------------
#   This is just extra code that Erin wrote for data weighting, largely borrowed from Nicholas' stuff.
#   Maybe integrate this into the CPUE predict functions sometime in the future.
#	Erin Bohaboy erin.bohaboy@noaa.gov

#  --------------------------------------------------------------------------------------------------------------





	marg_means_pos <- 


r1<-with(dat, tapply(value, factor, mean))




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





# extra code below




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



#  --- model selection: backwards ---


binomial_backwards <- function(species, area, list_vars, out_directory, aic_abs_thresh) {
 
   # PRELIMINARIES
   start_dt <- paste0(substr(Sys.time(),6,7),substr(Sys.time(),9,10),substr(Sys.time(),12,13),
				substr(Sys.time(),15,16),substr(Sys.time(),18,19))
   full_formula_text <- "z ~ year_fac"
   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_all <- droplevels(area_data$data_all)		#str(sp_data_all)
   out_file <- paste0(out_directory,"/","binomial_",species,"_",area,"_backwards",start_dt,".txt")

   # build the model formula with all variables
   for (i in 1:nrow(list_vars)) {
	full_formula_text <- paste0(full_formula_text," + ",list_vars[i,2])
	}
   full_formula_formula <- as.formula(full_formula_text)

   # fit the full model. FOR CIRCULAR VARIABLES IN THE GAM, KNOTS MUST BE HARDCODED HERE
    run_gam <- gam(full_formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), wdir=c(0,360)), method='ML')
    last_aic <- run_gam$aic

   keep_going = TRUE
   current_formula <- full_formula_text

# --- STEP 2: leave 1 out

 while(keep_going) {

   # write out AIC and model
   info <- paste(round(last_aic,2), current_formula, sep = " | ")
	write(info, file = out_file, append=TRUE)
   
   list_vars$var_i <- seq(1,nrow(list_vars),1)
   list_vars <- mutate(list_vars, 'aic_leave_out' = 0)		# this relabels the rows

   # try dropping each variable, put the AIC in the list_vars df
   for (i in 1:nrow(list_vars)) {
	formula_text <- "z ~ year_fac"
	drop_var = list_vars[i,2]
	# rm(include_vars_index)
	include_vars_index <- seq(1,nrow(list_vars),1)
	include_vars_index <- include_vars_index[-i]
	  for (j in 1:length(include_vars_index)) {
		formula_text <- paste0(formula_text," + ",list_vars[include_vars_index[j],2])
	  }
	formula_formula <- as.formula(formula_text)
	run_gam <- gam(formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), wdir=c(0,360)), method='ML')
    	mod_aic <- run_gam$aic
	
	list_vars[i,3] <- mod_aic
	}

#  ------- step 4: look at results, choose which to leave out
	
	list_vars_rounded <- list_vars
	list_vars_rounded$aic_leave_out <- round(list_vars_rounded$aic_leave_out,2)

	# output list_vars		#str(list_vars)
	write_me <- colnames(list_vars)
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)

	for (k in 1:nrow(list_vars)) {
	write_me <- as.matrix(list_vars_rounded[k,])
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)
	  }

  	# tell us about the lowest aic cov
	# determine index, name
	index_lowest <- which.min(list_vars$aic_leave_out)
	lowest_name <- list_vars[index_lowest,2]
	lowest_aic <- min(list_vars$aic_leave_out)
#	rel_delta_aic <- ((lowest_aic - last_aic)/last_aic)*100
	abs_delta_aic <- lowest_aic - last_aic

	# did that cov meet our exclusion criteria?
	#  if the full model - the drop model is within the AIC criteria, then the 2 models are the same, drop it.
	#  if the drop model is an improvement (AIC drops more than the criteria), don't drop, stop: keep_going = FALSE.

#	if (is.na(aic_rel_thresh)==FALSE) {
#		use_criteria_value <- aic_rel_thresh
#		use_criteria_name <- "relative"
#		criteria_value <- round(rel_delta_aic,3)
#			if (rel_delta_aic > aic_rel_thresh)  {
#			keep_going = FALSE
#			}
#	    	}

#	if (is.na(aic_abs_thresh)==FALSE) {
#		use_criteria_value <-aic_abs_thresh
#		use_criteria_name <- "absolute"
#		criteria_value <- round(abs_delta_aic,3)
	   		if (abs_delta_aic > (aic_abs_thresh)) {
			keep_going = FALSE
#			}
	   	}

	# output info
#	info <- paste(lowest_name, use_criteria_name, round(use_criteria_value,2),criteria_value, "keep going",keep_going, sep = " | ")
	info <- paste(lowest_name, round(lowest_aic,2), aic_abs_thresh, round(abs_delta_aic,2),"keep going",keep_going, sep = " | ")
		
write(info, file = out_file, append=TRUE)
	
	# if keep going is true
	if (keep_going == TRUE) {
		last_aic <- lowest_aic					# update aic
		list_vars <- list_vars[-index_lowest,]		# update list vars
		current_formula <- "z ~ year_fac"			# rebuild the formula to be missing the drop var with the lowest aic
			for (q in 1:nrow(list_vars)) {
			current_formula <- paste0(current_formula," + ",list_vars[q,2])
	  		}
		}

	# if keep going is FALSE
	if (keep_going == FALSE) {
		best_formula <- current_formula		# define best_formula
 		}
	}

	#  refit the GAM and return that object
	best_formula_formula <- as.formula(best_formula)
	best_gam <- gam(best_formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), wdir=c(0,360)), method='ML')
	
      return(best_gam)
 } 
		
# --------------------------------------  END FUNCTION








# ------------ BEGIN GAM POSITIVE PROCESS (GAMMA DISTRIBUTION) BACKWARDS SELECTION FUNCTION

gamma_backwards <- function(species, area, list_vars, out_directory) {

   start_dt <- paste0(substr(Sys.time(),6,7),substr(Sys.time(),9,10),substr(Sys.time(),12,13),
				substr(Sys.time(),15,16),substr(Sys.time(),18,19))
   full_formula_text <- "catch_cpue ~ year_fac"
   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_pos <- droplevels(area_data$data_pos)		#str(sp_data_pos)
   out_file <- paste0(out_directory,"/","gamma_",species,"_",area,"_",start_dt,".txt")

   for (i in 1:nrow(list_vars)) {
	full_formula_text <- paste0(full_formula_text," + ",list_vars[i,2])
	}
   full_formula_formula <- as.formula(full_formula_text)

    run_gam <- gam(full_formula_formula, data = sp_data_pos,  family= 'Gamma', knots = list(Moon_days=c(0,30), wdir=c(0,360)), method='ML')
    last_aic <- run_gam$aic

   keep_going = TRUE
   current_formula <- full_formula_text

# --- STEP 2: leave 1 out

 while(keep_going) {

   info <- paste(round(last_aic,2), current_formula, sep = " | ")
	write(info, file = out_file, append=TRUE)
   
   list_vars$var_i <- seq(1,nrow(list_vars),1)
   list_vars <- mutate(list_vars, 'aic_leave_out' = 0)		# this relabels the rows

   for (i in 1:nrow(list_vars)) {
	formula_text <- "catch_cpue ~ year_fac"
	drop_var = list_vars[i,2]
	# rm(include_vars_index)
	include_vars_index <- seq(1,nrow(list_vars),1)
	include_vars_index <- include_vars_index[-i]
	  for (j in 1:length(include_vars_index)) {
		formula_text <- paste0(formula_text," + ",list_vars[include_vars_index[j],2])
	  }
	formula_formula <- as.formula(formula_text)
	run_gam <- gam(formula_formula, data = sp_data_pos,  family= 'Gamma', knots = list(Moon_days=c(0,30), wdir=c(0,360)), method='ML')
    	mod_aic <- run_gam$aic
	
	list_vars[i,3] <- mod_aic
	}

#  ------- step 4: look at results, choose which to leave out
	
	list_vars_rounded <- list_vars
	list_vars_rounded$aic_leave_out <- round(list_vars_rounded$aic_leave_out,2)

	# output list_vars		#str(list_vars)
	write_me <- colnames(list_vars)
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)

	for (k in 1:nrow(list_vars)) {
	write_me <- as.matrix(list_vars_rounded[k,])
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)
	  }

# what is the lowest aic? should we keep going?
	lowest_aic <- min(list_vars$aic_leave_out)
	delta_aic <- last_aic - lowest_aic

	if (delta_aic < -2)  {
		keep_going = FALSE
		}
	# what is the index of the lowest aic?
	index_lowest <- which.min(list_vars$aic_leave_out)

	#lowest_name
	lowest_name <- list_vars[index_lowest,2]

	# output info
	info <- paste(lowest_name, round(lowest_aic,2), round(delta_aic,2),"keep going",keep_going, sep = " | ")
	write(info, file = out_file, append=TRUE)
	
	# update last_aic
	last_aic <- lowest_aic

	# get current formula
	current_formula <- "catch_cpue ~ year_fac"
	for (q in 1:nrow(list_vars)) {
		current_formula <- paste0(current_formula," + ",list_vars[q,2])
	  }
	
	# update list_vars
	list_vars <- list_vars[-index_lowest,]


   }

} 		
# --------------------------------------  END FUNCTION



