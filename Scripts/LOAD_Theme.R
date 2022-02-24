gear.colors       <- c("SPEAR"="#9A9A9A",
                       "BOTTOMFISHING"="#00467F",
                       "BTM/TRL MIX"="#008998",
                       "ATULE"="#B2292E",
			     "ATULE-MIXED"="#B2292E",
			     "LONGLINE"="#4C9C2E",
			     "Other"="#FF8300",
			     "TROLL"="#0093D0",
			     "SPEAR (BOAT-TANKS)" = "#646464",
			     "SPEAR (BOAT-NO TANKS)" = "#9A9A9A")
			     
type_day_colors       <- c("WD"="#00467F",			# Erin added 6/25
                        "WE"="#008998")
charter_colors       <- c("N"="#00467F",			# Erin added 6/29
                        "C"="#008998")
                       
species.colors   <- c("Aphareus rutilans"="#00467F" ,
				"Aprion virescens"="#008998",
				"Caranx lugubris"="#007934",
				"Etelis coruscans"="#625BC4",
                    	"Etelis carbunculus"="#D65F00",
				"Lethrinus rubrioperculatus"="#B2292E",
				"Lutjanus kasmira"="#1ECAD3",
                    	"Pristipomoides flavipinnis"="#646464",
				"Pristipomoides filamentosus"="#93D500",
                    	"Pristipomoides zonatus"="#FF8300",
				"Variola louti"="#D0D0D0")

sbs_gear_colors <- c("HookAndLine"="#00467F",
                       "OtherNet"="#646464",
                       "Gillnet"="#008998",
                       "Gleaning"="#B2292E",
			     "Scuba"="#93D500",
			     "Spear"="#4C9C2E",
			     "Other"="#9A9A9A")
sbs_route_colors <- c("Aunuu" = "#D02C2F",      
			"OfuOlosega" = "#1ECAD3", 
			"Tau" = "#7B7B7B", 
			"Tutuila_Central" = "#0055A4", 
			"Tutuila_East" = "#625BC4", 
			"Tutuila_West" = "#93D500", 
			"Unk" = "#646464")

measure_category_colors <- c("None" = "#008998",
					"All" = "#00467F",
					"Partial" = "#9A9A9A")
size_category_colors <- 	c('both' = '#00467F',
					  'length' = '#008998',
					  'weight' = '#575195')

# sp_names <- c('Your Mama',
#			'A. virescens', 'C. lugubris', 'E. coruscans', 'E. carbunculus',
#			'L. rubrioperculatus', 'L. kasmira','P. flavipinnis',
#			'P. filamentosus', 'P. zonatus', 'V. louti')

sp_names <- c('A. rutilans',
			'A. virescens', 'C. lugubris', 'E. coruscans', 'E. carbunculus',
			'L. rubrioperculatus', 'L. kasmira','P. flavipinnis',
			'P. filamentosus', 'P. zonatus', 'V. louti')

names(sp_names) <- c('Aphareus rutilans',
			'Aprion virescens', 'Caranx lugubris', 'Etelis coruscans', 'Etelis carbunculus',
			'Lethrinus rubrioperculatus', 'Lutjanus kasmira','Pristipomoides flavipinnis',
			'Pristipomoides filamentosus', 'Pristipomoides zonatus', 'Variola louti')

#species.colors    <- c("APRU"="#00467F",
#                       "APVI"="#008998",
#                       "CALU"="#007934",
#                       "ETCO"="#625BC4",
#                       "ETCA"="#D65F00",
#                       "LERU"="#B2292E",
#                       "LUKA"="#1ECAD3",
#                       "PRFL"="#646464",
#                       "PRFI"="#93D500",
#                       "PRZO"="#FF8300",
#                       "VALO"="#D0D0D0")
#species.linetypes <- c("APRU"="solid",
#                       "APVI"="solid",
#                       "CALU"="solid",
#                       "ETCO"="solid",
#                       "ETCA"="solid",
#                       "LERU"="solid",
#                       "LUKA"="dashed",
#                       "PRFL"="dashed",
#                       "PRFI"="dashed",
#                       "PRZO"="dashed",
#                       "VALO"="dashed")
species.linetypes <- c("Aphareus rutilans"="solid",
                       "Aprion virescens"="solid",
                       "Caranx lugubris"="solid",
                       "Etelis coruscans"="solid",
                       "Etelis carbunculus"="solid",
                       "Lethrinus rubrioperculatus"="solid",
                       "Lutjanus kasmira"="dashed",
                       "Pristipomoides flavipinnis"="dashed",
                       "Pristipomoides filamentosus"="dashed",
                       "Pristipomoides zonatus"="dashed",
                       "Variola louti"="dashed")

area.colors       <-c("Tutuila"="#00467F",
                      "Manua"="#008998",
                      "Bank"="#007934",
                      "N/A"="#9A9A9A",
	#		    "N/A"="#9A9A9A",
			    "Unk"="#9A9A9A",
			    "Bank_E"="#007934",
			    "Bank_S"="#93D500")

ports_simple.colors <- c("FAGATOGO (MARINA DOCK)" = "#0055A4",
				"GENERAL MANUA PORT" = "#1ECAD3",
				"AUNU'U" = "#4C9C2E",
				"PAGO PAGO" = "#7F7FFF",
				"FAGASA" = "#FF8300",
				"Tutuila_Other" = "#787878",
				"FAGA'ALU" = "#D02C2F",
				"UNK_20" = "#D0D0D0")

id.status.colors <- c("not_bmus"="#9A9A9A",
			    "id_bmus"="#008998",
			    "bmus_groups"="#646464",
				"bmu_groups"="#646464")


theme_datareport_bar <- function(){
  font <- 'sans'   #assign font family up front
  theme_minimal() %+replace%    #replace elements we want to change
    
    theme(
      
      panel.grid.major.y = element_line(colour = "#D8D8D8"), #major y gridlines in gray
      panel.grid.major.x = element_blank(),  
      panel.grid.minor = element_blank(),
      
      plot.margin = margin(0, 12, 0, 0), # margin top, right, bottom, left in pts
      
      
      #text elements
      plot.title = element_text(size=10),             # do not save space for the title
	strip.text = element_text(size=10),
	strip.text.x = element_text(margin = margin(10, 0, 1, 0)),      

      plot.subtitle = element_text(          #subtitle
        family = font,            #font family
        size = 14),               #font size
      
      plot.caption = element_text(           #caption
        family = font,            #font family
        size = 9,                 #font size
        hjust = 1),               #right align
      
      axis.title = element_text(             #axis titles
        family = font,            #font family
        size = 10),               #font size
      
      axis.title.y = element_text(angle = 90, margin = margin(l = 4), vjust = 0),
	axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=0, l=0), vjust = 0),
      
      axis.text = element_text(              #axis text
        family = font,            #axis famuly
        size = 10),                #font size
      
      # move labels (numbers) closer to axis
      axis.text.y = element_text(margin=margin(t = 0, r = 0, b = 0, l= 10, unit = "pt")),
      axis.text.x = element_text(margin=margin(t = -5, r = 0, b = 0, l= 0, unit = "pt")),
     
     legend.position = "none",
#      legend.text = element_blank()
 
#      legend.title = element_blank(), # put legend right, top
#      legend.justification = "top",
      legend.text = element_text(size = 8)
    )
}

# this is the function to use with p + expand_pretty_y(p)
#	so the y-axis limit is greater than the max y data
  expand_pretty_y = function(plot, ymin=0) {
    max.y = max(layer_data(plot)$y, na.rm=TRUE)
    max_limit = tail(pretty(1:max.y,u5.bias = 10))
  expand_limits(y=c(ymin, max_limit))
  }



theme_datareport_size_comp <- function(){
  font <- 'sans'   #assign font family up front
  theme_minimal() %+replace%    #replace elements we want to change
    
    theme(
      
      panel.grid.major.y = element_line(colour = "#D8D8D8"), #major y gridlines in gray
      panel.grid.major.x = element_blank(),  
      panel.grid.minor = element_blank(),
      
      plot.margin = margin(0, 12, 0, 0), # margin top, right, bottom, left in pts
      
	# axis.line.x = element_line(colour = "black"),
	# axis.line.y = element_line(colour = "black"),
      
      #text elements
      plot.title = element_text(size=10),             # do not save space for the title
	strip.text = element_text(size=10),
	strip.text.x = element_text(margin = margin(10, 0, 1, 0)),      

      plot.subtitle = element_text(          #subtitle
        family = font,            #font family
        size = 14),               #font size
      
      plot.caption = element_text(           #caption
        family = font,            #font family
        size = 9,                 #font size
        hjust = 1),               #right align
      
      axis.title = element_text(             #axis titles
        family = font,            #font family
        size = 10),               #font size
      
      axis.title.y = element_text(angle = 90, margin = margin(l = 4), vjust = 0),
	axis.title.x = element_text(angle = 0, margin = margin(t=5, r=0, b=0, l=0), vjust = 0),
      
      axis.text = element_text(              #axis text
        family = font,            #axis famuly
        size = 10),                #font size
      
      # move labels (numbers) closer to axis
      axis.text.y = element_text(margin=margin(t = 0, r = 0, b = 0, l= 10, unit = "pt")),
      axis.text.x = element_text(margin=margin(t = -2, r = 0, b = 0, l= 0, unit = "pt")),
     
     legend.position = "none",
#      legend.text = element_blank()
 
#      legend.title = element_blank(), # put legend right, top
#      legend.justification = "top",
      legend.text = element_text(size = 8)
    )
}




















