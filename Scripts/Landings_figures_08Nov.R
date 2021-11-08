#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA DATA REPORT
#	Figures for the expanded landings estimates based on boat-based creel - all in ggplot2 using a common theme.
#	Note: corrected estimates sent by Hongguang Jun22
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  --------------------------------------------------------------------------------------------------------------


#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	#  options(scipen=999)		# this option just forces R to never use scientific notation

	# load all the libraries. There are lots, some probably not used.
	library(sqldf)
  	library(dplyr)
  	library(tidyr)
	library(ggplot2)
	library(magrittr)
	library(gridExtra)
	library(grid)
	library(cowplot)
	library(lattice)
	library(ggplotify)
  	

# load Marc and Erin's common ggplot theme
source('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/LOAD_theme.R')
setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/Landings/Expanded_landings_from_Hongguang_22Jun")

sp_data <- read.csv('SPC_BBS_AS2.csv',header=T, stringsAsFactors=FALSE) 
str(sp_data)

# follow Toby's instructions to break the unique key SPC_PK into the interview details we need
sp_data2 <- mutate(sp_data, year = substr(SPC_PK,2,5), method = substr(SPC_PK,11,11), 
					zone = substr(SPC_PK,14,14), type = substr(SPC_PK,20,21), 
					charter = substr(SPC_PK,22,22), process = substr(SPC_PK,23,23))
head(sp_data2)
str(sp_data2)

#  NOte:
#		Method	4 = bottomfishing, 5 = btm/trl mix
#		Zone	1 = Tutuila, 2 = Manua
#		Type	WD = weekday, WE = weekend
#		Charter	C = yes, N = no
#		Process	G = Tutuila, M = Manua

# ---- per Hongguang / Toby:
#	LBS_CAUGHT is the expanded landings, in lbs, and VAR_LBS_CAUGHT is the estimated variance of expanded landings (sigma^2).
#	Because the different expansion strata (year x method x zone x type x charter x species) are independent
#	when summing across strata, you simply sum the variances (and sample sizes I presume).
#		for sample size, use NUM_INTERVIEW_POOLED (this includes all interviews in the strata, including 0s).
#	Although it might not be entirely statistically sound, Hongguang says to sum the A. and P. rutilans for now.
#		so just replace SPECIES_FK = 243 with 247 now

sp_data2$SPECIES_FK[sp_data2$SPECIES_FK==243]<-247

#   --- side question: how much landings of BMUS comes from charters??

	string <- "SELECT year, Charter, SPECIES_FK, sum(LBS_CAUGHT) as landings
			FROM sp_data2
			WHERE Method in ('4','5','6','8','61') AND SPECIES_FK in (247,239,111,248,249,267,231,241,242,245,229) AND
			Charter = 'C'
			GROUP BY year, SPECIES_FK
			"
	charter <- sqldf(string, stringsAsFactors=FALSE)		# 

#  --- answer: very little: e.g. 80 lbs lugubris in 2017, 40 lbs zonatus in 2019.
#		SO SUBTLE no one will ever notice, but
#		include in the landings estimates anyway for completeness.

#  --------------
#  sum over method (4,5,6,8,61), charter, and type

	string <- "SELECT year, SPECIES_FK, zone, sum(LBS_CAUGHT) as landings, sum(VAR_LBS_CAUGHT) as variance, 
				sum(NUM_INTERVIEW_POOLED) as n
			FROM sp_data2
			WHERE Method in ('4','5','6','8','61') AND SPECIES_FK in (247,239,111,248,249,267,231,241,242,245,229)			GROUP BY year, SPECIES_FK, zone
			"
	bmus_1 <- sqldf(string, stringsAsFactors=FALSE)		# 

str(bmus_1)			# we expect variance to be 'NA' for all manu'a estimates

bmus_1$zone[bmus_1$zone=='1']<-'Tutuila'
bmus_1$zone[bmus_1$zone=='2']<-'Manua'

# calculate se and sd

bmus_2 <- mutate(bmus_1, se = sqrt(variance)/sqrt(n), sd = sqrt(variance))
head(bmus_2)
str(bmus_2)

# put some scientific names on there...
bmus_names <- read.csv('AmSam_BMUs.csv',header=T, stringsAsFactors=FALSE) 

string <- "SELECT bmus_2.*, bmus_names.SCIENTIFIC_NAME
		FROM bmus_2 
		LEFT JOIN bmus_names ON
			bmus_2.SPECIES_FK = bmus_names.SPECIES_PK
		"

bmus_3 <- sqldf(string, stringsAsFactors=FALSE)
bmus_3 <- mutate(bmus_3, year_num = as.numeric(year))
bmus_3 <- mutate(bmus_3, p_se = landings + se, m_se = pmax(0,(landings - se)))

str(bmus_3)

# make a total landings per each species x year. This is silly but need for figure.
		string <- "SELECT year_num, SPECIES_FK, sum(landings) as tot_landings
				FROM bmus_3
				GROUP BY year, SPECIES_FK"
	bmus_3B <- sqldf(string, stringsAsFactors=FALSE)

bmus_3C <- merge(x = bmus_3, y = bmus_3B, by = c('year_num', 'SPECIES_FK'), all.x = TRUE)
#	head(bmus_3C)			#output table for Marc 18Aug   
				#  write.csv(bmus_3C, row.names=FALSE, file = "Landings_species_area_18Aug.csv")




# make some figures...

index_df <- data.frame('species_names' = names(sp_names), 'sp_short' = as.character(sp_names))

 for (i in 1:11) {

	plot_me <- subset(bmus_3C, SCIENTIFIC_NAME == index_df$species_names[i])
	plot_me$zone <- with(plot_me, reorder(zone,landings,function(landings) -1* sum(landings)))

	ticks <- seq(1985,2020,5)
	ymax <- max(plot_me$p_se, na.rm = TRUE)
	tick_height <- ymax/40

     #--- create the ggplot objects
     assign(paste("p_",i,sep=""),
		ggplot(data=plot_me, aes(fill=zone,x=year_num,y=landings,scales="free")) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values=area.colors) +
		geom_segment(y=0,yend=0,x=0,xend=3000) +
		scale_x_continuous(breaks=ticks, limits = c(1985,2020)) +
		geom_errorbar(aes(x=year_num,ymin = pmax(0, tot_landings - 1.96*sd), ymax = tot_landings + 1.96*sd, width = 0), size=1, col = "#646464" ,position = "identity") +
		theme_datareport_bar() +	
	# add year ticks manually if we want them
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
grob_ylab <- textGrob("Expanded Landings (lbs)", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)

	p1_legend <- p_1 + theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top")
	leg <- get_legend(p1_legend)



 	png(file="landings_Jun30_1_3.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1)+ 
				theme(legend.position = c(0.9,0.95), legend.title = element_blank()), 
			p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


 	png(file="landings_Jun30_4_6.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_4+expand_pretty_y(p_4)+ 
				theme(legend.position = c(0.9,0.95), legend.title = element_blank()), 
				p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


 	png(file="landings_Jun30_7_9.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_7+expand_pretty_y(p_7)+ 
				theme(legend.position = c(0.9,0.95), legend.title = element_blank()), 
				p_8+expand_pretty_y(p_8), p_9+expand_pretty_y(p_9),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


 	png(file="landings_Jun30_10_11.png",width=6.5, height=6, units = "in", pointsize = 8, res=300)
	grid.arrange(p_10+expand_pretty_y(p_10)+ 
				theme(legend.position = c(0.9,0.9), legend.title = element_blank()), 
				p_11+expand_pretty_y(p_11),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


#  --------------------------------------------------------------------------------------------------------------

#  check for unid species groups


#  --------------
#  sum over method (4,5,6,8,61), charter, and type		# str(sp_data2)

	string <- "SELECT year, SPECIES_FK, sum(LBS_CAUGHT) as landings, sum(VAR_LBS_CAUGHT) as variance
			FROM sp_data2
			WHERE Method in ('4','5','6','8','61') AND SPECIES_FK in (109,110,200,210,230,240,260,380,390)
			GROUP BY year, SPECIES_FK
			"
	groups_1 <- sqldf(string, stringsAsFactors=FALSE)		# 

# attach names
groups_names <- read.csv('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/BMUS_species_groups_list.csv',header=T, stringsAsFactors=FALSE) 

string <- "SELECT groups_1.*, groups_names.Sci_name_2
		FROM groups_1 
		LEFT JOIN groups_names ON
			groups_1.SPECIES_FK = groups_names.SPECIES_PK
		"

groups_3 <- sqldf(string, stringsAsFactors=FALSE)

string <- "SELECT year, Sci_name_2, sum(landings) as landings, sum(variance) as variance
			FROM groups_3
			GROUP BY year, Sci_name_2
			"
	groups_4 <- sqldf(string, stringsAsFactors=FALSE)


groups_4 <- mutate(groups_4, year_num = as.numeric(year), sd = sqrt(variance))

# make figures



index_df <- data.frame('species_names' = unique(groups_4$Sci_name_2))

 for (i in 1:nrow(index_df)) {

	plot_me <- subset(groups_4, Sci_name_2 == index_df$species_names[i])
	ticks <- seq(1985,2020,5)
	ymax <- max(plot_me$landings)
	tick_height <- ymax/40

     #--- create the ggplot objects
     assign(paste("p_",i,sep=""),
		ggplot(data=plot_me, aes(x=year_num,y=landings,scales="free")) +
		geom_bar(position="stack",stat="identity", fill="#9A9A9A") +
		geom_segment(y=0,yend=0,x=0,xend=3000) +
		scale_x_continuous(breaks=ticks, limits = c(1985,2020)) +
		geom_errorbar(aes(x=year_num,ymin = pmax(0, landings - 1.96*sd), ymax = landings + 1.96*sd, width = 0), size=0.75, col = "black" ,position = "identity") +
		theme_datareport_bar() +	
	# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = as.character(index_df$species_names[i]))
	)
	}


grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
grob_ylab <- textGrob("Expanded Landings (lbs)", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)

png(file="landings_groups_fig1_30Jun.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_2+expand_pretty_y(p_2), 
				p_6+expand_pretty_y(p_6), p_1+expand_pretty_y(p_1),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()


png(file="landings_groups_fig2_30Jun.png",width=6.5, height=8, units = "in", pointsize = 8, res=300)
	grid.arrange(p_4+expand_pretty_y(p_4), 
				p_3+expand_pretty_y(p_3), p_5+expand_pretty_y(p_5),
				ncol=1, left = grob_ylab, bottom = grob_xlab)
	dev.off()




png(file="landings_groups_30Jun_1_6.png",width=6.5, height=7, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), 
				p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3), p_4+expand_pretty_y(p_4), 
				p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6),
				ncol=2, left = grob_ylab, bottom = grob_xlab)
	dev.off()



#  --------------------------------------------------------------------------------------------------------------
#  --------------------------------------------------------------------------------------------------------------
#  --------------------------------------------------------------------------------------------------------------
#	make some figures showing expanded number of trips used in the landings calcs.



effort_data <- read.csv('EXP_BBS_AS2.csv',header=T, stringsAsFactors=FALSE) 
str(effort_data)

setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/Figures")

#  there are a lot of extra columns, just build a df with what we want


effort_df <- data.frame(year = effort_data$YEAR, type_day = effort_data$TYPE_OF_DAY, zone = effort_data$SURVEY_ZONE_FK,
				gear = effort_data$METHOD_FK, charter = effort_data$FISHERY_TYPE, n_interview = effort_data$NUM_INTERVIEW, 
				exp_trip = effort_data$EXP_TRIP,
				var_exp_trip = effort_data$VAR_EXP_TRIP)
str(effort_df)


effort_df$zone[effort_df$zone=='1']<-'Tutuila'
effort_df$zone[effort_df$zone=='2']<-'Manua'


#  ---------------------------------------------
# by gear (gears that observe BMUS), no variance

	string <- "SELECT year, gear, sum(exp_trip) as exp_trip
			FROM effort_df
			WHERE gear in (4,5,6,8,61)
			GROUP BY year, gear
			"
	gear_effort_1 <- sqldf(string, stringsAsFactors=FALSE)		# 

# by year only

	string <- "SELECT year, sum(exp_trip) as exp_trip
			FROM effort_df
			WHERE gear in (4,5,6,8,61)
			GROUP BY year
			"
	year_effort_1 <- sqldf(string, stringsAsFactors=FALSE)
	max(year_effort_1$exp_trip)

# replace gear with correct names

gear_effort_1$gear[gear_effort_1$gear==4] <- 'BOTTOMFISHING'
gear_effort_1$gear[gear_effort_1$gear==5] <- 'BTM/TRL MIX'
gear_effort_1$gear[gear_effort_1$gear==6] <- 'SPEAR (BOAT-NO TANKS)'
gear_effort_1$gear[gear_effort_1$gear==8] <- 'ATULE-MIXED'
gear_effort_1$gear[gear_effort_1$gear==61] <- 'SPEAR (BOAT-TANKS)'
gear_effort_1$gear <- as.factor(gear_effort_1$gear)

# put in decreasing order so it looks nice
 gear_effort_1$gear <- with(gear_effort_1, reorder(gear,exp_trip,function(exp_trip) -1*sum(exp_trip)))

str(gear_effort_1)


# set up ticks
ticks <- seq(1985,2020,5)
tick_height <- 1000/40 #	<- ymax/40

p <- ggplot(data=gear_effort_1, aes(fill=gear,x=year,y=exp_trip)) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values=gear.colors, labels = c("Bottomfishing", "Spear no tanks", "Btm/trl mix",
					"Spear w/ tanks", "Atule-mixed")) +
		theme_datareport_bar() + 
		 geom_segment(y=0,yend=0,x=0,xend=3000) +
		# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
		 theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top",
			legend.margin = margin(0, 0, 1, 0)) +

		labs(title="", subtitle="", 
			y="Expanded Number Trips", x="Year", caption="")

p + expand_pretty_y(p)

ggsave("Expanded_trips_by_gear_25Jun.png",last_plot(),width=6.5, height=3, units="in")


#  ---------------------------------------------
# by weekend and weekday, no variance

	string <- "SELECT year, type_day, sum(exp_trip) as exp_trip
			FROM effort_df
			WHERE gear in (4,5,6,8,61)
			GROUP BY year, type_day
			"
	day1 <- sqldf(string, stringsAsFactors=FALSE)		# 

# set up ticks
ticks <- seq(1985,2020,5)
tick_height <- 1000/40 #	<- ymax/40

p <- ggplot(data=day1, aes(fill=type_day,x=year,y=exp_trip)) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values=type_day_colors, labels = c("Weekday","Weekend")) +
		theme_datareport_bar() + 
		 geom_segment(y=0,yend=0,x=0,xend=3000) +
		# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
		 theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top",
			legend.margin = margin(0, 0, 1, 0)) +

		labs(title="", subtitle="", 
			y="Expanded Number Trips", x="Year", caption="")

p + expand_pretty_y(p)

ggsave("Expanded_trips_by_day_25Jun.png",last_plot(),width=6.5, height=3, units="in")



#  ---------------------------------------------
# by charter status, no variance

	string <- "SELECT year, charter, sum(exp_trip) as exp_trip
			FROM effort_df
			WHERE gear in (4,5,6,8,61)
			GROUP BY year, charter
			"
	charter1 <- sqldf(string, stringsAsFactors=FALSE)		# 

# put in decreasing order so it looks nice
 charter1$charter <- with(charter1, reorder(charter,exp_trip,function(exp_trip) -1*sum(exp_trip)))


# set up ticks
ticks <- seq(1985,2020,5)
tick_height <- 1000/40 #	<- ymax/40

p <- ggplot(data=charter1, aes(fill=charter,x=year,y=exp_trip)) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values=charter_colors, labels = c("Non-Charter","Charter")) +
		theme_datareport_bar() + 
		 geom_segment(y=0,yend=0,x=0,xend=3000) +
		# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
		 theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top",
			legend.margin = margin(0, 0, 1, 0)) +

		labs(title="", subtitle="", 
			y="Expanded Number Trips", x="Year", caption="")

p + expand_pretty_y(p)

ggsave("Expanded_trips_by_charter_29Jun.png",last_plot(),width=6.5, height=3, units="in")

#  ------- !  note: this will generate a warning message because there were two records of the relavent gear types:
#			EXP_PK = Y2017010005001WDCG  and   Y2009010004001WDCG 
#			for both, 'NUM_INTERVIEW' = 0 and 'POOLED_FLAG' = "No Past/Present Interviews". 
#			This does occur for gear_types = 0, 1, and 25 as well (not sure what those are)
#			Assume this is anomalous and ignore it...



#  ---------------------------------------------
# by area, variance pertains to Tutuila only


string <- "SELECT year, zone, sum(exp_trip) as exp_trip, sum(var_exp_trip) as var_exp_trip, 
				sum(n_interview) as n
			FROM effort_df
			WHERE gear in (4,5,6,8,61)
			GROUP BY year, zone
			"
	zone1 <- sqldf(string, stringsAsFactors=FALSE)		

# calculate se
zone2 <- mutate(zone1, se = sqrt(var_exp_trip)/sqrt(n))


# make a total trips per year column. This is silly but need for figure.
		string <- "SELECT year, sum(exp_trip) as tot_trips
				FROM zone2
				GROUP BY year"
	zone2b <- sqldf(string, stringsAsFactors=FALSE)

zone3 <- merge(x = zone2, y = zone2b, by = 'year', all.x = TRUE)		#str(zone3)
# put in decreasing order so it looks nice
 zone3$zone <- with(zone3, reorder(zone,exp_trip,function(exp_trip) -1*sum(exp_trip)))

zone3 <- mutate(zone3, sd_exp_trip = sqrt(var_exp_trip))

#	plot_me <- subset(bmus_3C, SCIENTIFIC_NAME == index_df$species_names[i])
#	plot_me$zone <- with(plot_me, reorder(zone,landings,function(landings) -1* sum(landings)))

	ticks <- seq(1985,2020,5)
	tick_height <- 1000/40

     #--- create the ggplot objects
	
	p <- ggplot(data=zone3, aes(fill=zone,x=year,y=exp_trip)) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values=area.colors) +
		geom_errorbar(aes(x=year,ymin = tot_trips - 1.96*sd_exp_trip, ymax = tot_trips + 1.96*sd_exp_trip, width = 0), size=1, col = "#646464" ,position = "identity") +
		geom_segment(y=0,yend=0,x=0,xend=3000) +
		theme_datareport_bar() +	
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
		 theme(legend.position = "right", legend.title = element_blank(), legend.justification = "top",
			legend.margin = margin(0, 0, 1, 0)) +

		labs(title="", subtitle="", 
			y="Expanded Number Trips", x="Year", caption="")

p + expand_pretty_y(p)

ggsave("Expanded_trips_by_area_30Jun.png",last_plot(),width=6.5, height=3, units="in")




#  -------------------------------------------------------   extra figure


#  make a "total bottomfishes" catch so we can look over the entire time series.
#	for 1986 forward, classify known species according to Brian and John's species break-down table
#	see Calc_sp_prop_groups_8Nov.R

#  make a table: all species (by species) sum by year
string <- "SELECT year, SPECIES_FK, sum(LBS_CAUGHT) as landings
			FROM sp_data2
			WHERE Method in ('4','5','6','8','61')
			GROUP BY year, SPECIES_FK
			"
	all_sp <- sqldf(string, stringsAsFactors=FALSE)		#str(all_sp)		#2980 records

# take out just the bottomfish groups
		string <- "SELECT *
			FROM all_sp
			WHERE SPECIES_FK in (109,110,200,210,230,240,260,380,390)
			"
	all_sp_groups <- sqldf(string, stringsAsFactors=FALSE)		# str(all_sp_groups)	#183 obs

			string <- "SELECT year, sum(landings) as tot_landings
			FROM all_sp
			WHERE SPECIES_FK in (109,110,200,210,230,240,260,380,390)
			GROUP BY year
			"
	all_sp_groups2 <- sqldf(string, stringsAsFactors=FALSE)		# str(all_sp_groups)	#183 obs

# for ID fish, which ones are "bottomfish?"
group_key <- read.csv("C:/Users/Erin.Bohaboy/Documents/American_Samoa/CPUE/AmSam_BBS-SBS_GroupKey_final.csv",
		header=T, stringsAsFactors=FALSE) 
	# View(group_key)		#str(group_key)

#use an inner join, that way groups are excluded (we got those already)
  string <- "SELECT all_sp.*, group_key.*
		FROM all_sp
		INNER JOIN group_key
			ON all_sp.SPECIES_FK = group_key.SPECIES_PK"

	all_sp_sp <- sqldf(string, stringsAsFactors=FALSE)
	str(all_sp_sp)		# 2716 records - somewhat expected 2980 - 183 = 2797	
					# that's ok because a few other groups were weeded out (unknown fish, puffers, sharks, etc.)
					# head(all_sp_sp)

	string <- "SELECT year, sum(landings) as tot_landings
			FROM all_sp_sp
			WHERE Bottomfishes_200 = 1
			GROUP BY year
			"
	id_bfish <- sqldf(string, stringsAsFactors=FALSE)

   	tot_bfish <- rbind(all_sp_groups2, id_bfish)	
	string <- "SELECT year, sum(tot_landings) as tot_landings
			FROM tot_bfish
			GROUP BY year
			"
	tot_bfish2 <- sqldf(string, stringsAsFactors=FALSE)



  # now read in historic data
  hist_landings <- read.csv('C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/Historic Landings/Historic_Landings_17Sep.csv',
 					header=T, stringsAsFactors=FALSE)
  #View(hist_landings)

	string <- "SELECT Year as year, Landings as tot_landings
			FROM hist_landings
			WHERE Species = 'Tot_Bottomfish'
			"
	tot_bfish_old <- sqldf(string, stringsAsFactors=FALSE)

  tot_bfish_landings <- rbind(tot_bfish_old, tot_bfish2)
	View(tot_bfish_landings)		# str(tot_bfish_landings)
	tot_bfish_landings$year <- as.numeric(tot_bfish_landings$year)

  

   # make a figure (used in presentation)
	setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/Figures")

	ticks <- seq(1965,2020,5)
	ymax <- max(tot_bfish_landings$tot_landings)
	tick_height <- ymax/40

     #--- create the ggplot objects
    p <- ggplot(data=tot_bfish_landings, aes(x=year,y=tot_landings,scales="free")) +
		geom_bar(position="stack",stat="identity", fill="#9A9A9A") +
		geom_segment(y=0,yend=0,x=0,xend=3000) +
		scale_x_continuous(breaks=ticks, limits = c(1965,2020)) +
		theme_datareport_bar() +	
	# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[5],xend=ticks[5]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[6],xend=ticks[6]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[7],xend=ticks[7]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[8],xend=ticks[8]) +
 		 geom_segment(y=0,yend=-tick_height,x=ticks[9],xend=ticks[9]) +
 		 geom_segment(y=0,yend=-tick_height,x=ticks[10],xend=ticks[10]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[11],xend=ticks[11]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[12],xend=ticks[12]) +
		labs(y="Bottomfish Landings, lbs", x="Year", caption="", title = "")
	

png(file="landings_tot_bfish_all_years_8Nov.png",width=12, height=5, units = "in", pointsize = 8, res=300)
	p + expand_pretty_y(p)
	dev.off()























# --------------------------------------------------------