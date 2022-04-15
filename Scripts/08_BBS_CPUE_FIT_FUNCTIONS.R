#  --------------------------------------------------------------------------------------------------------------
#   FUNCTIONS TO FIT AND SELECT GAM MODELS
#	written for American Samoa Boat-Based Survey CPUE standardization
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  These functions can be called with SOURCE command
#  --------------------------------------------------------------------------------------------------------------

# --- Load lots of libraries:
#  	rm(list=ls())
#  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	library(sqldf)
  	library(dplyr)
  	library(tidyr)
	library(fitdistrplus)
	library(mgcv)
	library(formula.tools)
 	library(this.path)
#	library(assertthat)


# --- read in the functions
#  both are set up to pull the specified species and area out of the cpue_datasets object from CPUE_data_prep.RData

# establish directories using this.path::
#  root_dir <- this.path::here(.. = 1)
# load CPUE data for development
# load(paste(root_dir, "/output/07_BBS_CPUE_Data_Prep.RData", sep=""))



# FUNCTIONS 1-3 --------------------------------------------------------------------------------------------------------------
# FORWARD SELECTION USING ABSOLUTE OR RELATIVE CHANGE IN AIC
# The following arguments apply to the binomial and positive (gamma or LnN) processes for forward model selection.

#  ARGUMENTS 		DESCRIPTIONS
#  species			just the species name, e.g., kasmira
#  area			tutu, manu, or banks
#  out_directory		give the full file path of the folder where you want to keep the outputs for each model tried within
#					the selection process. The output file will have the 
#					name binomial_species_area_dt.txt, where dt is the system time (in UTC?)
#					as MMDDhhmmss
#  var_name			list the covariate names, matching the column names in the input data, that are being considered.
#					These must include details for smooth terms in the GAM (e.g. s(wdir, bs='cc')). For circular variables,
#					knots are hard-coded in the function. Change those if more get added.
#  aic_rel_thresh		relative percent change in AIC (as a positive number) that qualifies a variable for inclusion in the model
#					for example 0.1 means a pair of models with relative AIC change of 0.1% or less are equally informative
#  aic_abs_thresh		absolute change in AIC (as a positive number) that qualifies a variable for inclusion in the model
#					for example 2 means a pair of models with absolute AIC change of 2 or less are equally informative
#  	define either relative or absolute AIC threshold, NOT BOTH: this is how function knows model acceptance criteria

# str(cpue_datasets$kasmira$tutu$data_all)

#  SAMPLE VALUES
#	species <- 'kasmira'
#	area <- 'tutu'
#	out_directory <- paste(root_dir, "/output/CPUE_fit_files", sep="")
#	var_name = c('effort_std', 'TYPE_OF_DAY', 'prop_pelagics', 'season', 'wspd', 'tod_quarter',			
#			'ENSO', "s(Moon_days, bs='cc')", "s(wdir, bs='cc')", 'ONI', 'SOI', 'shift', 'prop_unid', 'PC1','PC2')
#	aic_abs_thresh <- 2




# FUNCTION 1: --------------------------------------------------------------------------------------------------------------
# ----   PRESENCE/ABSENCE (BINOMIAL DISTRIBUTION) FORWARDS SELECTION


binomial_forwards <- function(species, area, var_name, out_directory, aic_abs_thresh = NA, aic_rel_thresh = NA) {
 
# ---- preliminaries
   nvars <- length(var_name)
   list_vars <- data.frame('var_i' = seq(1,nvars,1),'var_name' = var_name)
  #	list_vars$var_name <- as.character(list_vars$var_name)

   start_dt <- paste0(substr(Sys.time(),6,7),substr(Sys.time(),9,10),substr(Sys.time(),12,13),
				substr(Sys.time(),15,16),substr(Sys.time(),18,19))
   null_formula_text <- "z ~ year_fac"
   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_all <- droplevels(area_data$data_all)		#str(sp_data_all)
   out_file <- paste0(out_directory,"/","binomial_",species,"_",area,"_forwards",start_dt,".txt")


# ---- STEP 1: fit null model
    null_formula_formula <- as.formula(null_formula_text)

    run_gam <- gam(null_formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML',
    			na.action = na.omit)
    last_aic <- run_gam$aic

   keep_going = TRUE
   current_formula <- null_formula_text

# --- try to add 1 variable at a time

 while(keep_going) {

   info <- paste(round(last_aic,2), current_formula, sep = " | ")
	write(info, file = out_file, append=TRUE)
   
   list_vars$var_i <- seq(1,nrow(list_vars),1)			# renumber the rows
   list_vars <- mutate(list_vars, 'aic_add' = 0)

# --- STEP 2: try to add each variable, get AIC

   for (i in 1:nrow(list_vars)) {
	add_var = list_vars[i,2]
	formula_text <- paste0(current_formula," + ",add_var)
	formula_formula <- as.formula(formula_text)
	run_gam <- gam(formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), 
				wdir=c(0,360), yday=c(0,366)), method='ML',na.action = na.omit)
    	mod_aic <- run_gam$aic
	
	list_vars[i,3] <- mod_aic
	}

#  --- STEP 3: look at results, choose which to leave out
	
  # write out the results
	list_vars_rounded <- list_vars
	list_vars_rounded$aic_add <- round(list_vars_rounded$aic_add,2)

	# output list_vars		#str(list_vars)
	write_me <- colnames(list_vars)
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)

	for (k in 1:nrow(list_vars)) {
	write_me <- as.matrix(list_vars_rounded[k,])
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)
	 	 }

  # which cov lead to lowest AIC?
	lowest_aic <- min(list_vars$aic_add)
	rel_delta_aic <- ((lowest_aic - last_aic)/last_aic)*100
	abs_delta_aic <- lowest_aic - last_aic

  # did that cov meet our inclusion criteria?
	if (is.na(aic_rel_thresh)==FALSE) {
		if (rel_delta_aic > (-1*aic_rel_thresh))  {
		keep_going = FALSE
		}
	    }

	if (is.na(aic_abs_thresh)==FALSE) {
		if (abs_delta_aic > (-1*aic_abs_thresh))	{
		keep_going = FALSE
		}
	    }

  # tell us about the lowest aic cov
	# determine index, name
	index_lowest <- which.min(list_vars$aic_add)
	lowest_name <- list_vars[index_lowest,2]

	# output info
   	if (is.na(aic_rel_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_rel_thresh, round(rel_delta_aic,2),"keep going",keep_going, sep = " | ")
   	  }

	if (is.na(aic_abs_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_abs_thresh, round(abs_delta_aic,2),"keep going",keep_going, sep = " | ")
	  }

	write(info, file = out_file, append=TRUE)
	
	# update last_aic
	last_aic <- lowest_aic

  # IF that last cov satisfied our threshold for inclusion, update current formula
	if (keep_going == TRUE) {
	current_formula <- paste0(current_formula," + ",list_vars[index_lowest,2])
	# update list_vars
	list_vars <- list_vars[-index_lowest,]
     }

  #	in the unlikely event that every variable we initially considered should be included, stop here too 
  #   we'll know we got every variable if the length of current formula (total elements, including z, ~, and year)
  #		is equal to nvars + 3
	current_formula_formula <- as.formula(current_formula)
 	if (length(current_formula_formula) == nvars + 3) {
	  keep_going <- FALSE
	}

  # if that last added variable didn't make the cut or it did, but it was the last one and we updated current_formula,
  #	then define best model 
	if (keep_going == FALSE) {
	best_formula <- current_formula
     }

   }

 # now we have "best_formula"
 #	refit the GAM, return the model object and the data in a list 
	best_formula_formula <- as.formula(best_formula)
	best_gam <- gam(best_formula_formula, data = sp_data_all,  family= 'binomial', knots = list(Moon_days=c(0,30), 
			wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)

	return(list("model" = best_gam, "sp_data_all" = sp_data_all))

} 
		
# --------------------------------------  FUNCTION 1 END



# --------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------
#  FUNCTION 2: gamma-distribution positive process
#

gamma_forwards <- function(species, area, var_name, out_directory, aic_abs_thresh = NA, aic_rel_thresh = NA) {
 
# ---- preliminaries
   nvars <- length(var_name)
   list_vars <- data.frame('var_i' = seq(1,nvars,1),'var_name' = var_name)
   start_dt <- paste0(substr(Sys.time(),6,7),substr(Sys.time(),9,10),substr(Sys.time(),12,13),
				substr(Sys.time(),15,16),substr(Sys.time(),18,19))
   null_formula_text <- "catch_cpue ~ year_fac"
   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_pos <- droplevels(area_data$data_pos)		#head(sp_data_pos)
   out_file <- paste0(out_directory,"/","gamma_",species,"_",area,"_forwards",start_dt,".txt")

# ---- STEP 1: fit null model		#head(sp_data_pos)
    null_formula_formula <- as.formula(null_formula_text)

    run_gam <- gam(null_formula_formula, data = sp_data_pos,  family= 'Gamma', 
					knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)
    last_aic <- run_gam$aic

   keep_going = TRUE
   current_formula <- null_formula_text

# --- try to add 1 variable at a time

 while(keep_going) {

   info <- paste(round(last_aic,2), current_formula, sep = " | ")
	write(info, file = out_file, append=TRUE)
   
   list_vars$var_i <- seq(1,nrow(list_vars),1)			# renumber the rows
   list_vars <- mutate(list_vars, 'aic_add' = 0)

# --- STEP 2: try to add each variable, get AIC				# warning(immediate. = FALSE)

   for (i in 1:nrow(list_vars)) {
	add_var = list_vars[i,2]
	formula_text <- paste0(current_formula," + ",add_var)
	formula_formula <- as.formula(formula_text)
	run_gam <- gam(formula_formula, data = sp_data_pos,  family= 'Gamma', knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), 
			method='ML', na.action = na.omit)
    	mod_aic <- run_gam$aic
	list_vars[i,3] <- mod_aic
	# trygam <- try(gam(formula_formula, data = sp_data_pos,  family= 'Gamma', knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML'))
	# is.error(trygam)
	# print(i)
	# print(warnings())
	}

#  --- STEP 3: look at results, choose which to leave out
	
  # write out the results
	list_vars_rounded <- list_vars
	list_vars_rounded$aic_add <- round(list_vars_rounded$aic_add,2)

	# output list_vars		#str(list_vars)
	write_me <- colnames(list_vars)
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)

	for (k in 1:nrow(list_vars)) {
	write_me <- as.matrix(list_vars_rounded[k,])
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)
	 	 }

  # which cov lead to lowest AIC?
	lowest_aic <- min(list_vars$aic_add)
	rel_delta_aic <- ((lowest_aic - last_aic)/last_aic)*100
	abs_delta_aic <- lowest_aic - last_aic

  # did that cov meet our inclusion criteria?
	if (is.na(aic_rel_thresh)==FALSE) {
		if (rel_delta_aic > (-1*aic_rel_thresh))  {
		keep_going = FALSE
		}
	    }

	if (is.na(aic_abs_thresh)==FALSE) {
		if (abs_delta_aic > (-1*aic_abs_thresh))	{
		keep_going = FALSE
		}
	    }

  # tell us about the lowest aic cov
	# determine index, name
	index_lowest <- which.min(list_vars$aic_add)
	lowest_name <- list_vars[index_lowest,2]

	# output info
	if (is.na(aic_rel_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_rel_thresh, round(rel_delta_aic,2),"keep going",keep_going, sep = " | ")
   	  }

	if (is.na(aic_abs_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_abs_thresh, round(abs_delta_aic,2),"keep going",keep_going, sep = " | ")
	  }

	write(info, file = out_file, append=TRUE)
	
	# update last_aic
	last_aic <- lowest_aic

  # IF that last cov satisfied our threshold for inclusion, update current formula
	if (keep_going == TRUE) {
	current_formula <- paste0(current_formula," + ",list_vars[index_lowest,2])
	# update list_vars
	list_vars <- list_vars[-index_lowest,]
     }

  #	in the unlikely event that every variable we considered should be included, stop here too 
  #   we'll know we got every variable if the length of current formula (total elements, including catch_cpue, ~, and year)
  #		is equal to nvars + 3
	current_formula_formula <- as.formula(current_formula)
 	if (length(current_formula_formula) == nvars + 3) {
	  keep_going <- FALSE
	}

  # if that last added variable didn't make the cut or it did, but it was the last one and we updated current_formula,
  #	then define best model 
	if (keep_going == FALSE) {
	best_formula <- current_formula
     }

   }

 # now we have "best_formula"
 #	refit the GAM and return that object
	best_formula_formula <- as.formula(best_formula)
	best_gam <- gam(best_formula_formula, data = sp_data_pos,  family= 'Gamma', knots = list(Moon_days=c(0,30), 
			wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)

	return(list("model" = best_gam, "sp_data_pos" = sp_data_pos))

} 
		
# --------------------------------------  END FUNCTION 2



# --------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------
#  FUNCTION 3: LnN-distribution positive process, forwards selection


LnN_forwards <- function(species, area, list_vars, out_directory,  aic_abs_thresh = NA, aic_rel_thresh = NA) {
 
# ---- preliminaries
   start_dt <- paste0(substr(Sys.time(),6,7),substr(Sys.time(),9,10),substr(Sys.time(),12,13),
				substr(Sys.time(),15,16),substr(Sys.time(),18,19))
   nvars <- length(var_name)
   list_vars <- data.frame('var_i' = seq(1,nvars,1),'var_name' = var_name)

   null_formula_text <- "ln_catch_cpue ~ year_fac"
   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_pos <- droplevels(area_data$data_pos)		#head(sp_data_pos)
   sp_data_pos_Ln <- mutate(sp_data_pos, ln_catch_cpue = log(catch_cpue))			# head(sp_data_pos_Ln)
   out_file <- paste0(out_directory,"/","LnN_",species,"_",area,"_forwards",start_dt,".txt")

# ---- STEP 1: fit null model		#head(sp_data_pos)
    null_formula_formula <- as.formula(null_formula_text)

    run_gam <- gam(null_formula_formula, data = sp_data_pos_Ln,  family= gaussian, 
					knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)
    last_aic <- run_gam$aic

   keep_going = TRUE
   current_formula <- null_formula_text

# --- try to add 1 variable at a time

 while(keep_going) {

   info <- paste(round(last_aic,2), current_formula, sep = " | ")
	write(info, file = out_file, append=TRUE)
   
   list_vars$var_i <- seq(1,nrow(list_vars),1)			# renumber the rows
   list_vars <- mutate(list_vars, 'aic_add' = 0)

# --- STEP 2: try to add each variable, get AIC

   for (i in 1:nrow(list_vars)) {
	add_var = list_vars[i,2]
	formula_text <- paste0(current_formula," + ",add_var)
	formula_formula <- as.formula(formula_text)
	run_gam <- gam(formula_formula, data = sp_data_pos_Ln,  family= gaussian, knots = list(Moon_days=c(0,30), 
			wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)
    	mod_aic <- run_gam$aic
	
	list_vars[i,3] <- mod_aic
	}

#  --- STEP 3: look at results, choose which to leave out
	
  # write out the results
	list_vars_rounded <- list_vars
	list_vars_rounded$aic_add <- round(list_vars_rounded$aic_add,2)

	# output list_vars		#str(list_vars)
	write_me <- colnames(list_vars)
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)

	for (k in 1:nrow(list_vars)) {
	write_me <- as.matrix(list_vars_rounded[k,])
	write(write_me, file = out_file, sep="|",ncolumns=3, append=TRUE)
	 	 }

  # which cov lead to lowest AIC?
	lowest_aic <- min(list_vars$aic_add)
	rel_delta_aic <- ((lowest_aic - last_aic)/last_aic)*100
	abs_delta_aic <- lowest_aic - last_aic

  # did that cov meet our inclusion criteria?
	if (is.na(aic_rel_thresh)==FALSE) {
		if (rel_delta_aic > (-1*aic_rel_thresh))  {
		keep_going = FALSE
		}
	    }

	if (is.na(aic_abs_thresh)==FALSE) {
		if (abs_delta_aic > (-1*aic_abs_thresh))	{
		keep_going = FALSE
		}
	    }

  # tell us about the lowest aic cov
	# determine index, name
	index_lowest <- which.min(list_vars$aic_add)
	lowest_name <- list_vars[index_lowest,2]

	# output info

   	if (is.na(aic_rel_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_rel_thresh, round(rel_delta_aic,2),"keep going",keep_going, sep = " | ")
   	  }

	if (is.na(aic_abs_thresh)==FALSE) {
	info <- paste(lowest_name, round(lowest_aic,2), aic_abs_thresh, round(abs_delta_aic,2),"keep going",keep_going, sep = " | ")
	  }

	write(info, file = out_file, append=TRUE)
	
	# update last_aic
	last_aic <- lowest_aic

  # IF that last cov satisfied our threshold for inclusion, update current formula
	if (keep_going == TRUE) {
	current_formula <- paste0(current_formula," + ",list_vars[index_lowest,2])
	# update list_vars
	list_vars <- list_vars[-index_lowest,]
     }

  #	in the unlikely event that every variable we considered should be included, stop here too 
  #   we'll know we got every variable if the length of current formula (total elements, including catch_cpue, ~, and year)
  #		is equal to nvars + 3
	current_formula_formula <- as.formula(current_formula)
 	if (length(current_formula_formula) == nvars + 3) {
	  keep_going <- FALSE
	}

  # if that last added variable didn't make the cut or it did, but it was the last one and we updated current_formula,
  #	then define best model 
	if (keep_going == FALSE) {
	best_formula <- current_formula
     }

   }

 # now we have "best_formula"
 #	refit the GAM and return that object
	best_formula_formula <- as.formula(best_formula)
	best_gam <- gam(best_formula_formula, data = sp_data_pos_Ln,  family= gaussian, knots = list(Moon_days=c(0,30), 
				wdir=c(0,360), yday=c(0,366)), method='ML', na.action = na.omit)

	return(list("model" = best_gam, "sp_data_pos_Ln" = sp_data_pos_Ln))

} 
		
# --------------------------------------  END FUNCTION 3



# FUNCTIONS 4-6 --------------------------------------------------------------------------------------------------------------
# The user can specify the model formula (with no model selection).
#	the returned model object and data are in the same format as from the model selection functions

# The following arguments apply.

#  ARGUMENTS 		DESCRIPTIONS
#  species			just the species name, e.g., kasmira
#  area			tutu, manu, or banks
#  fit_type			3 options: 'intercept_only','year_only','user_input'. What it says on the tin.
#  user_vars		Default value is NULL. if fit_type == user_input, then user_vars is a list of the covariate names, 
#					matching the column names in the input data, that will be in the fitted model.
#					These must include details for smooth terms in the GAM (e.g. s(wdir, bs='cc')).
#					This is really identical to "var_name" used in functions 1-3.



#  FUNCTION 4. ---------------------------------------------------------------------------------------
#  user specified binomial GAM

binomial_user <- function(species, area, fit_type, user_vars = NULL) {
 
# ---- preliminaries

   sp_data <- cpue_datasets[[species]]		#str(sp_data)
   area_data <- sp_data[[area]]			#str(area_data)
   sp_data_all <- droplevels(area_data$data_all)		#str(sp_data_all)

# ---- build the formula

  if (fit_type == 'intercept_only') {
	current_formula <- "z ~ 1"
   	}

  if (fit_type == 'year_only') {
  	current_formula <- "z ~ year_fac"
   	}

  if (fit_type == 'user_input') {
  	current_formula <- "z ~ year_fac"
		for (i in 1:length(user_vars)) {
	  	  add_var = user_vars[i]
	  	  current_formula <- paste0(current_formula," + ",add_var)
	  	}
	}

  formula_formula <- as.formula(current_formula)

# ---- fit the model
    
   run_gam <- gam(formula_formula, data = sp_data_all,  family= 'binomial', 
			knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML',
    			na.action = na.omit)
  
   return(list("model" = run_gam, "sp_data_all" = sp_data_all))

} 

		
# --------------------------------------  END FUNCTION 4


#  FUNCTION 5. ---------------------------------------------------------------------------------------
#  user specified gamma-error GAM

gamma_user <- function(species, area, fit_type, user_vars = NULL) {
 
# ---- preliminaries

   sp_data <- cpue_datasets[[species]]				#str(sp_data)
   area_data <- sp_data[[area]]					#str(area_data)
   sp_data_pos <- droplevels(area_data$data_pos)		#head(sp_data_pos)

# ---- build the formula

  if (fit_type == 'intercept_only') {
	current_formula <- "catch_cpue ~ 1"
   	}

  if (fit_type == 'year_only') {
  	current_formula <- "catch_cpue ~ year_fac"
   	}

  if (fit_type == 'user_input') {
  	current_formula <- "catch_cpue ~ year_fac"
		for (i in 1:length(user_vars)) {
	  	  add_var = user_vars[i]
	  	  current_formula <- paste0(current_formula," + ",add_var)
	  	}
	}

  formula_formula <- as.formula(current_formula)

# ---- fit the model
    
   run_gam <- gam(formula_formula, data = sp_data_pos,  family= 'Gamma', 
			knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML',
    			na.action = na.omit)
  
   return(list("model" = run_gam, "sp_data_pos" = sp_data_pos))

} 

# -------------------------------------------------- END FUNCTION 5




#  FUNCTION 6. ---------------------------------------------------------------------------------------
#  user specified Ln gaussian-error GAM

LnN_user <- function(species, area, fit_type, user_vars = NULL) {
 
# ---- preliminaries

   sp_data <- cpue_datasets[[species]]									#str(sp_data)
   area_data <- sp_data[[area]]										#str(area_data)
   sp_data_pos <- droplevels(area_data$data_pos)							#head(sp_data_pos)
   sp_data_pos_Ln <- mutate(sp_data_pos, ln_catch_cpue = log(catch_cpue))			# head(sp_data_pos_Ln)

# ---- build the formula

  if (fit_type == 'intercept_only') {
	current_formula <- "ln_catch_cpue ~ 1"
   	}

  if (fit_type == 'year_only') {
  	current_formula <- "ln_catch_cpue ~ year_fac"
   	}

  if (fit_type == 'user_input') {
  	current_formula <- "ln_catch_cpue ~ year_fac"
		for (i in 1:length(user_vars)) {
	  	  add_var = user_vars[i]
	  	  current_formula <- paste0(current_formula," + ",add_var)
	  	}
	}

  formula_formula <- as.formula(current_formula)

# ---- fit the model
    
   run_gam <- gam(formula_formula, data = sp_data_pos_Ln,  family= gaussian, 
			knots = list(Moon_days=c(0,30), wdir=c(0,360), yday=c(0,366)), method='ML',
    			na.action = na.omit)
  
   return(list("model" = run_gam, "sp_data_pos_Ln" = sp_data_pos_Ln))

} 

# -------------------------------------------------------- END FUNCTION 6





















