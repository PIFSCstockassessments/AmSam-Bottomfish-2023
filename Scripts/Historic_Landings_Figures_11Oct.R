#  --------------------------------------------------------------------------------------------------------------
#   AMERICAN SAMOA DATA REPORT
#	Historic Catch Estimates for published sources - all in ggplot2 using a common theme.
#	Erin Bohaboy erin.bohaboy@noaa.gov
#  --------------------------------------------------------------------------------------------------------------


#  PRELIMINARIES
  	rm(list=ls())
  	Sys.setenv(TZ = "UTC")		# setting system time to UTC avoids bugs in sqldf
  	# options(scipen=999)		# this option just forces R to never use scientific notation

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

setwd("C:/Users/Erin.Bohaboy/Documents/American_Samoa/Data_Report/Historic Landings")

# read in the .csv of historic catch info


  landings <- read.csv('Historic_Landings_17Sep.csv',
 					header=T, stringsAsFactors=FALSE)
str(landings)
landings$Species <- as.factor(landings$Species)
landings$Reference <- as.factor(landings$Reference)

landings <- mutate(landings, land_thou = Landings/1000)

########  ------------------------------------------------------------------------------
########  -------  Fig. 7-2. total bottomfish landings
########  ------------------------------------------------------------------------------
#  ---------------  Total bottomfish for historic period

each_yr = 0.0435
nd_text77 <- grobTree(textGrob("nd", x=(13*each_yr),  y=0.08, hjust=0, gp=gpar(fontsize=10, col="black")))
nd_text78 <- grobTree(textGrob("nd", x=(14*each_yr),  y=0.08, hjust=0, gp=gpar(fontsize=10, col="black")))
nd_text79 <- grobTree(textGrob("nd", x=(15*each_yr),  y=0.08, hjust=0, gp=gpar(fontsize=10, col="black")))
nd_text80 <- grobTree(textGrob("nd", x=(16*each_yr),  y=0.08, hjust=0, gp=gpar(fontsize=10, col="black")))
nd_text81 <- grobTree(textGrob("nd", x=(17*each_yr),  y=0.08, hjust=0, gp=gpar(fontsize=10, col="black")))

plot_me <- subset(landings, Species == "Tot_Bottomfish")
#  write.csv(plot_me,"7_2_historic_tot_bfish_land_11Oct.csv",row.names=F)

ticks <- seq(1965,1985,5)
ticks_all <- seq(1965,1985,1)
	ymax <- max(plot_me$land_thou, na.rm = TRUE)
	tick_height <- ymax/40

p <- ggplot(data=plot_me, aes(x=Year,y=land_thou,scales="free")) +
		geom_bar(position="stack",stat="identity") +
		scale_fill_manual(values='gray') +
		geom_segment(y=0,yend=0,x=0,xend=3000) +
		scale_x_continuous(breaks=ticks, limits = c(1965,1985.5)) +
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
	   # all year ticks
		geom_segment(y=0,yend=-tick_height,x=ticks_all[2],xend=ticks_all[2]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[3],xend=ticks_all[3]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[4],xend=ticks_all[4]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[5],xend=ticks_all[5]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[7],xend=ticks_all[7]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[8],xend=ticks_all[8]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[9],xend=ticks_all[9]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[10],xend=ticks_all[10]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[12],xend=ticks_all[12]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[13],xend=ticks_all[13]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[14],xend=ticks_all[14]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[15],xend=ticks_all[15]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[17],xend=ticks_all[17]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[18],xend=ticks_all[18]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[19],xend=ticks_all[19]) +
		geom_segment(y=0,yend=-tick_height,x=ticks_all[20],xend=ticks_all[20]) +
		labs(y="Commercial Landings (thousand lbs)", x="Year", caption="", title = "")

png(file="historic_landings_19Sep.png",width=6.5, height=3, units = "in", pointsize = 8, res=300)

	p + annotation_custom(nd_text77)+ annotation_custom(nd_text78) + annotation_custom(nd_text79) + 
			annotation_custom(nd_text80) + annotation_custom(nd_text81)
	dev.off()



########  ------------------------------------------------------------------------------
########  -------  Fig. 7-4. multi-pane by species 1982-1985
########  ------------------------------------------------------------------------------


# pull out the data, make sure we have zeros

plot_me <- subset(landings, Year > 1981)
plot_me_all <- subset(plot_me, Species != "Tot_Bottomfish")

# add zeros
		temp2 <- data.frame(Year = rep(seq(1982, 1985, 1),11), 
			Species = c(rep('Aphareus rutilans',4),rep('Aprion virescens',4),
			rep('Caranx lugubris',4),rep('Etelis coruscans',4),rep('Etelis carbunculus',4),
			rep('Lethrinus rubrioperculatus',4),rep('Lutjanus kasmira',4),rep('Pristipomoides flavipinnis',4),
			rep('Pristipomoides filamentosus',4),rep('Pristipomoides zonatus',4),rep('Variola louti',4)))

		temp5 <- merge(x = temp2, y = plot_me_all, by = c('Year','Species') , all.x = TRUE)
		temp5$Landings[is.na(temp5$Landings)] <- 0 
		plot_me_all <- temp5[,1:3]
#  write.csv(plot_me_all,"7_4_landings_BMUS_82_85_11Oct.csv",row.names=F)


# Put sp_names in order by full scientific name
sp_names <- sort(sp_names)

# I want different y scales for each plot, so make a separate ggplot for every species

for (i in 1:11) {
	plot_me <- subset(plot_me_all, Species == names(sp_names)[i])
	ticks <- seq(1982,1985,1)
	ymax <- max(plot_me$Landings)
	tick_height <- ymax/40
	assign(paste("p_",i,sep=""),
		ggplot(data=plot_me, aes(x=Year,y=Landings,scales="free")) +
		geom_bar(position="stack",stat="identity",fill="#00467F") +
		theme_datareport_bar() + 
		# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		theme(plot.title = element_text(face = "italic")) +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = sp_names[i])
	   )
	}

grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
grob_ylab <- textGrob("Landings (lbs)", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)


 	png(file="Hamm_Quach_Landings_species.png",width=6.5, height=6, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3), 
				p_4+expand_pretty_y(p_4), p_5+expand_pretty_y(p_5), p_6+expand_pretty_y(p_6), 
				p_7+expand_pretty_y(p_7), p_8+expand_pretty_y(p_8), p_9+expand_pretty_y(p_9), 
				p_10+expand_pretty_y(p_10), p_11+expand_pretty_y(p_11), ncol=3, left = grob_ylab, bottom = grob_xlab)
	dev.off()



########  ------------------------------------------------------------------------------
########  -------  Fig. 7-3. multi-pane by unid groups 1982-1985
########  ------------------------------------------------------------------------------

plot_me <- subset(landings, Year > 1981)
plot_me_all <- subset(plot_me, Species != "Tot_Bottomfish")

temp2 <- data.frame(Year = rep(seq(1982, 1985, 1),5), 
			Species = c(rep('Bottomfish',4),rep('Emperors',4),
			rep('Groupers',4),rep('Jacks',4),rep('Snappers',4)))

		temp5 <- merge(x = temp2, y = plot_me_all, by = c('Year','Species') , all.x = TRUE)
		plot_me_all <- temp5[,1:3]
#  write.csv(plot_me_all,"7_3_landings_groups_82_85_11Oct.csv",row.names=F)


group_names <- c('Bottomfish','Emperors','Groupers','Jacks','Snappers')

for (i in 1:5) {
	plot_me <- subset(plot_me_all, Species == group_names[i])
	ticks <- seq(1982,1985,1)
	ymax <- max(plot_me$Landings)
	tick_height <- ymax/40
	assign(paste("p_",i,sep=""),
		ggplot(data=plot_me, aes(x=Year,y=Landings,scales="free")) +
		geom_bar(position="stack",stat="identity",fill="#00467F") +
		theme_datareport_bar() + 
		# add year ticks manually if we want them
		 geom_segment(y=0,yend=-tick_height,x=ticks[1],xend=ticks[1]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[2],xend=ticks[2]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[3],xend=ticks[3]) +
		 geom_segment(y=0,yend=-tick_height,x=ticks[4],xend=ticks[4]) +
		theme(plot.title = element_text(face = "italic")) +
	 theme(axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=-15, l=0), vjust = 0)) +
	 theme(axis.title.y = element_text(angle = 90, margin = margin(-20,0,-25,-15), vjust = 0)) +
		labs(y="", x="", caption="", title = group_names[i])
	   )
	}

grob_xlab <- textGrob("Year", gp=gpar(fontsize=10), y = unit(0.5, "npc"),)
grob_ylab <- textGrob("Landings (lbs)", gp=gpar(fontsize=10), 
		x = unit(0.6, "npc"), y = unit(0.5, "npc"),
		just = "centre", hjust = NULL, vjust = NULL, rot = 90)


 	png(file="Hamm_Quach_Landings_groups.png",width=6.5, height=3.5, units = "in", pointsize = 8, res=300)
	grid.arrange(p_1+expand_pretty_y(p_1), p_2+expand_pretty_y(p_2), p_3+expand_pretty_y(p_3), 
				p_4+expand_pretty_y(p_4), p_5+expand_pretty_y(p_5), ncol=3, left = grob_ylab, bottom = grob_xlab)
	dev.off()























#