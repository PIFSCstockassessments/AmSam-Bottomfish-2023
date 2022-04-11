
#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA Boat-Based catches: Reconstruct Manu'a catches for 2009-2021
#	Erin Bohaboy erin.bohaboy@noaa.gov
#
#		
#  --------------------------------------------------------------------------------------------------------------

  #  PRELIMINARIES
  # rm(list=ls())
  Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf

  # load all the libraries. There are lots, some not used.
  library(sqldf)
  library(dplyr)
  library(this.path)
  library(ggplot2)
  library(magrittr)
  library(gridExtra)
  library(grid)
  library(cowplot)
  library(lattice)
  library(ggplotify)


  # establish directories using this.path
  root_dir <- this.path::here(.. = 1)

  # read in the finished BBS Landings (breakdown, species ID corrected, tutuila ports assigned to area.
  load(paste(root_dir, "/output/04_BBS_Landings_bdown_area.RData", sep=""))
  #load(paste(root_dir, "/Outputs/04_BBS_Landings_bdown_area.RData", sep=""))
  
  
  # read in ggplot space which has sp_names for indexing
  source(paste(root_dir, "/Scripts/LOAD_theme.R", sep=""))

  # Years to consider:
  # Latest: Although the total number of Manu'a interviews dropped in 2008 (about half of 2007), interviewer 19 did continue a few
  #	interviews per most months until December. So, include 2008. Interviewer 08 really petered out in 2007
  #	but was most active 93-96 and 2000.
  # Earliest: In 1986 and 1987, the majority of bottomfishing and btm/trl mix interviewed landings were identified
  #	only to species level, hence for many species, broken down catch from the group categories makes up a lot of the
  #	catch. In addition, when I looked at scatterplots of manua vs. tutu catches, 1986 and 1987 were frequent outliers, 
  #   with high Tutuila catches and low Manu'a catches. There were also only 2 Manu'a interviews in 1987.
  #   so, do not include 1986-1987 in information used to reconstruct recent catches.


  # Estimate 2009-2021 Manu'a Islands catch, by species following 2 different approaches
  #	a. "slope": Manu'a catch and variance is a proportion of Tutuila catch based on 1988-2008
  #		only if p-value of regression indicates slope is not zero
  #	b. "constant": Manu'a catch is the average of 1987-2008 Manu'a catch. Variance is the variance
  #		of annual estimates 1987-2008


  # 	1. prepare the dataset
  	manu_tutu <- merge(x = tutu_catch, y = manu_catch_total, 					#View(manu_tutu)		#str(manu_tutu)
				by = c('SCIENTIFIC_NAME_PK','year'), all.x = FALSE)

  	colnames(manu_tutu)[5:6] <- c("tot_manu_lbs","tot_manu_var")

  # 	2. do the linear regressions and estimates both ways, save the results
	save_coeffs <- data.frame(species=rep('species',11), m=rep(777,11), p=rep(777,11), adj_r2=rep(777,11))
	pred_save <- list()

	for (i in 1:11) {
	  plot_me <- subset(manu_tutu, SCIENTIFIC_NAME_PK == names(sp_names)[i] & year > 1987)
	  fit_me <- subset(plot_me, year < 2009)
	  pred_me <- subset(plot_me, year > 2008)

	  mod <- lm(data=fit_me, tot_manu_lbs ~ tutu_lbs + 0)
	  m <- round(summary(mod)$coefficients[1],3)
	  p <- round(summary(mod)$coefficients[4],3)
	  r2 <- round(summary(mod)$adj.r.squared,2)

  	  save_coeffs$m[i] <- m
  	  save_coeffs$p[i] <- p
  	  save_coeffs$adj_r2[i] <- r2
	  save_coeffs$species[i] <- names(sp_names)[i]

    # predict constant (approach b above)
	  pred_constant <- data.frame(year = pred_me$year, SCIENTIFIC_NAME_PK = names(sp_names)[i],  tot_lbs = mean(fit_me$tot_manu_lbs),
						tot_var = var(fit_me$tot_manu_lbs), type = 'constant')
    # predict slope (approach a above)
	  pred_slope <- data.frame( year = pred_me$year, SCIENTIFIC_NAME_PK = names(sp_names)[i], tot_lbs = pred_me$tutu_lbs*m, 
					tot_var = pred_me$tutu_var*m, type = 'slope')

     	  predict_manu_both <- rbind(pred_constant, pred_slope)

        pred_save[[i]] <- predict_manu_both
  	}


    # 	--------------------->   2b. make some figures
		
		pdf(paste(root_dir, "/output/", "tutu_v_manu_88_08.pdf", sep=""))
		#pdf(paste(root_dir, "/Outputs/", "tutu_v_manu_88_08.pdf", sep=""))
		
		for (i in 1:11) {
			plot_me <- subset(manu_tutu, SCIENTIFIC_NAME_PK == names(sp_names)[i] & year > 1987 & year < 2009)

			mod <- lm(data=plot_me, tot_manu_lbs ~ tutu_lbs + 0)
			m <- round(summary(mod)$coefficients[1],3)
			p <- round(summary(mod)$coefficients[4],3)
			r2 <- round(summary(mod)$adj.r.squared,2)
  
			use_plot_title <- paste(as.character(sp_names[i]),", slope = ",m,", p = ",p,", adj r2 = ",r2, sep="")
  
			# make, print ggplot object
			this_plot <- ggplot(plot_me, aes(x=tutu_lbs, y=tot_manu_lbs)) +
				geom_point() +
				geom_text(label=plot_me$year, hjust=-0.1, vjust=-0.5) +
				geom_smooth(method=lm,formula = y ~ x + 0, se=FALSE) +
				theme_datareport_bar() +
				labs(y="Manu'a Catch, lbs", x="Tutuila Catch, lbs", caption="", title = use_plot_title)
	 
		print(this_plot)

		  }

  		dev.off()

  # examine the p-values in save_coeffs
  #   slope was not different from zero for zonatus ([10])
  #	so erase the slope estimate from pred_save
	pred_save[[10]]$tot_lbs[pred_save[[10]]$type=='slope']<-NA
	pred_save[[10]]$tot_var[pred_save[[10]]$type=='slope']<-NA

  # Add these estimates back together with the expanded landings estimates for Manu'a
    manu_catch_all <- mutate(manu_catch_total, type = 'bbs_expansion')		#str(manu_catch_all)

    for (i in 1:11) {
	manu_catch_all <- rbind(manu_catch_all,pred_save[[i]])
	}	
												
    manu_catch_all <- mutate(manu_catch_all, sd = sqrt(tot_var))
    manu_catch_all$type <- as.factor(manu_catch_all$type)

    # 	--------------------->  make some figures

		type.colors2 <-c("bbs_expansion" = "#00467F", "constant" = "#008998", "slope"="#4C9C2E")

 		for (i in 1:11) {
		  plot_me <- subset(manu_catch_all, SCIENTIFIC_NAME_PK == names(sp_names)[i])		#str(plot_me)
		  plot_me$type <- with(plot_me, reorder(type,tot_lbs,function(tot_lbs) -1* sum(tot_lbs)))
		  ticks <- seq(1985,2022,5)
		  ymax <- max(plot_me$tot_lbs + 1.96*plot_me$sd, na.rm = TRUE)
		  tick_height <- ymax/40

    		#--- create the ggplot objects
     		  assign(paste("p_",i,sep=""),
		    ggplot(data=plot_me, aes(fill=type,x=year,y=tot_lbs,scales="free",drop=TRUE)) +
		    geom_bar(position=position_dodge(),stat="identity") +
		    scale_fill_manual(values=type.colors2) +
		#  scale_fill_manual(values=type.colors2, labels=c("Tutuila", "Manu'a")) +
		    geom_segment(y=0,yend=0,x=0,xend=3000) +
		    scale_x_continuous(breaks=ticks, limits = c(1985,2022)) +
		    geom_errorbar(aes(x=year, ymin = pmax(0, tot_lbs - 1.96*sd), ymax = tot_lbs + 1.96*sd, width = 0), size=0.1, col = "#646464", position=position_dodge(.9)) +
		    theme_datareport_bar() +	
		    geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		    geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
		    theme(plot.title = element_text(face = "italic")) +
	 	    theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 	    theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		    labs(y="", x="", caption="", title = sp_names[i])
		  )
		}

		grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
		grob_ylab <- textGrob("Landings, lbs", gp=gpar(fontsize=10), 
			x = unit(0.6, "npc"), y = unit(0.5, "npc"),
			just = "centre", hjust = NULL, vjust = NULL, rot = 90)

		pdf(paste(root_dir, "/output/", "Manua_landings_reconstruct_compare_update.pdf", sep=""))
		#pdf(paste(root_dir, "/Outputs/", "Manua_landings_reconstruct_compare.pdf", sep=""))
		
		grid.arrange(p_1 + theme(legend.position = c(.1,1), legend.title = element_blank(), legend.justification = "top") + expand_pretty_y(p_1),
			p_2 + expand_pretty_y(p_2),
			p_3 + expand_pretty_y(p_3), ncol=1, left = grob_ylab, bottom = grob_xlab)

		grid.arrange(p_4 + theme(legend.position = c(.1,1), legend.title = element_blank(), legend.justification = "top") + expand_pretty_y(p_4),
			p_5 + expand_pretty_y(p_5),
			p_6 + expand_pretty_y(p_6), ncol=1, left = grob_ylab, bottom = grob_xlab)

		grid.arrange(p_7 + theme(legend.position = c(.1,1), legend.title = element_blank(), legend.justification = "top") + expand_pretty_y(p_7),
			p_8 + expand_pretty_y(p_8),
			p_9 + expand_pretty_y(p_9), ncol=1, left = grob_ylab, bottom = grob_xlab)

		grid.arrange(p_10 + theme(legend.position = c(.1,1), legend.title = element_blank(), legend.justification = "top") + expand_pretty_y(p_10),
			p_11 + expand_pretty_y(p_11), ncol=1, left = grob_ylab, bottom = grob_xlab)

		dev.off()


# -----------------------------------------------------------------------------------------------------------------------------

 # clean up workspace
 	all_objs <- ls()
 	save_objs <- c("tutu_catch","root_dir", "banks_catch", "manu_catch_all", "breakdown_bmus_smooth",
 					"species_proptable_by_year_gear_zone",
 					"p_louti", "p_albimarginata","p_flavi","p_fila","p_elongatus",
 					"p_amboinensis","p_rubrio", "sp_data3_basic")
 	remove_objs <- setdiff(all_objs, save_objs)
 #   rm(list=remove_objs)
 #	rm(save_objs)
 #	rm(remove_objs)
 #	rm(all_objs)

 # save.image(paste(root_dir, "/output/05_BBS_Landings_Manua_09_21.RData", sep=""))
	#  save.image(paste(root_dir, "/Outputs/05_BBS_Landings_Manua_09_20.RData", sep=""))
	
 # load(paste(root_dir, "/output/05_BBS_Landings_Manua_09_21.RData", sep=""))
 # to get the catch estimates out for stock assessment, either manipulate tutu_catch, banks_catch, manu_catch_all in R
 #	or, output as .csv files and handle in excel, etc.
 # View(manu_catch_all)
 # View(tutu_catch)
 # View(banks_catch)



# -----------------------------------------------------------------------------------------------------------------------------


