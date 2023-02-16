library(tidyverse)
library(r4ss)
library(flextable)
root_dir <- this.path::here(.. = 2)

species <- c("APRU", "APVI", "CALU", "ETCO", "LERU", "LUKA", "PRFL", "PRZO", "VALO")
final.mods <- SSgetoutput(dirvec = file.path(root_dir, "SS3 final models", species, "01_Base"))
final.sum <- SSsummarize(final.mods)
max_yr <- unique(final.sum$endyrs)
NatM <- final.sum$pars %>% filter(str_detect(Label, "NatM")) 
SSBMSY <- final.sum$quants[which(final.sum$quants$Label=="SSB_MSY"),]
NModels <- final.sum$n
Results <- setNames(data.frame(matrix(ncol = 3, nrow = NModels)), 
                    c("Species", "B_Bmsy_term", "F_Fmsy_term"))
Results$Species <- c("Aphareus rutilans", 
                     "Aprion virescens", 
                     "Caranxx lugubris", 
                     "Etelis coruscans", 
                     "Lethrinus rubrioperculatus", 
                     "Lutjanus kasmira", 
                     "Pristipomoides flavipinnis", 
                     "Pristipomoides zonatus", 
                     "Variola louti")
Results$Samoan <- c("Palu-gutusiliva APRU",
                    "Asoama APVI",
                    "Tafauli CALU",
                    "Palu-loa ETCO",
                    "Filoa-paomumu LERU",
                    "Savane LUKA",
                    "Palu-sina PRFL",
                    "Palu-ula PRZO",
                    "Velo VALO")

SSBMSST<- pmax(0.5,1-NatM[1,1:NModels]) * SSBMSY[1,1:NModels]
rnames <- final.sum$quants$Label
index_SSB_MSY = which(rnames==paste("SSB_MSY",sep=""))
index_Fstd_MSY = which(rnames==paste("annF_MSY",sep=""))
index_SSB_TermYr = which(rnames==paste("SSB_",max_yr,sep=""))
index_Fstd_TermYr = which(rnames==paste("F_",max_yr,sep=""))
Fstd_MSY_est = final.sum$quants[index_Fstd_MSY,1:NModels]
SSB_TermYr_est  = final.sum$quants[index_SSB_TermYr,1:NModels]
Fstd_TermYr_est = final.sum$quants[index_Fstd_TermYr,1:NModels]
Results$B_Bmsy_term <- reshape2::melt(SSB_TermYr_est[1,]/SSBMSST[1,])[,"value"]
Results$F_Fmsy_term <- reshape2::melt(Fstd_TermYr_est/Fstd_MSY_est)[,"value"]
Results$MSST_x = reshape::melt(1-NatM[1,1:9])[,"value"]


### Create 2-panel bar graph for SSB/SSBMSST and F/FMSY for executive summary
## Need to run lines 4 - 45 to create Results dataframe first
library(png)
library(tidyverse)
library(r4ss)
library(ggimage)
library(ggtext)
library(grid)

img.dir <- list.files(file.path(root_dir, "Images"), full.names = T)

Results <-  Results %>% 
  mutate(Family = c("Deep Snapper", 
                    "Snapper", 
                    "Jack", 
                    "Deep Snapper", 
                    "Emperor", 
                    "Snapper", 
                    "Deep Snapper", 
                    "Deep Snapper", 
                    "Grouper"),
         IMG = img.dir,
         Samoan = factor(Samoan,
                         levels = c("Palu-gutusiliva APRU",
                                    "Palu-loa ETCO",
                                    "Palu-sina PRFL",
                                    "Palu-ula PRZO",
                                    "Asoama APVI",
                                    "Savane LUKA",
                                    "Tafauli CALU",
                                    "Filoa-paomumu LERU",
                                    "Velo VALO"
                         ))) %>% 
  arrange(Samoan)

fish.logos <- paste0("<img src = '", Results$IMG, "' width='16' /><br>", 
                     sapply(Results$Samoan, 
                            function(x) gsub("\\s",  "<br>", x)))


fmsy.family <- Results %>% 
  ggplot(aes(x = Samoan, y = F_Fmsy_term)) +
  geom_col(aes(fill = Family)) +
  geom_hline(yintercept = 1, color = "grey20", linetype = "dashed") +
  ylim(0,1.5) +
  labs(x = "", 
       y = expression(atop("Overfishing",paste("("*F[2021]/F[MSY]*")")))) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        panel.border = element_rect(color="black",fill=NA,size=1),
        panel.background = element_blank(), 
        strip.background = element_blank(),
        legend.title=element_blank(),
        legend.key=element_blank(),
        legend.position="none",
        plot.margin = unit(c(0.2, 1, -0.2,1), "cm"))

fmsy.legend <- Results %>% 
  ggplot(aes(x = Samoan, y = F_Fmsy_term)) +
  geom_col(aes(fill = Family)) +
  geom_hline(yintercept = 1) +
  ylim(0,1.5) +
  labs(x = "", 
       y = expression(atop("Overfishing",paste("("*F[2021]/F[MSY]*")")))) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        panel.border = element_rect(color="black",fill=NA,size=1),
        panel.background = element_blank(), 
        strip.background = element_blank(),
        legend.title=element_blank(),
        legend.key=element_blank(),
        legend.position = "top",
        legend.margin=margin(t = 0, r = 0, b = 0, l = 0, unit='cm'))


ssb <- Results %>% 
  ggplot(aes(x = Samoan, y = B_Bmsy_term)) +
  geom_col(aes(fill = Family)) +
  geom_hline(yintercept = 1, colour = "grey30", linetype = "dashed") +
  labs(x = "", 
       y = expression(atop("Overfished",paste("("*SSB[2021]/SSB[MSST]*")")))) +
  scale_x_discrete(name = NULL, labels = fish.logos) +
  theme(axis.text.x = element_markdown(size = 6),
        panel.border = element_rect(color="black",fill=NA,size=1),
        panel.background = element_blank(), 
        strip.background = element_blank(),
        legend.title=element_blank(),
        legend.key=element_blank(),
        legend.position="none",
        plot.margin = unit(c(-0.2, 1,0.2,1), "cm")) 

# Create user-defined function, which extracts legends from ggplots
extract_legend <- function(my_ggp) {
  step1 <- ggplot_gtable(ggplot_build(my_ggp))
  step2 <- which(sapply(step1$grobs, function(x) x$name) == "guide-box")
  step3 <- step1$grobs[[step2]]
  return(step3)
}

# Apply user-defined function to extract legend
shared_legend <- extract_legend(fmsy.legend)


fmsy <- ggplotGrob(fmsy.family)
ssb <- ggplotGrob(ssb)
maxwidths <- grid::unit.pmax(fmsy$widths[2:5], ssb$widths[2:5])
maxheights <- grid::unit.pmax(fmsy$heights[2:5], ssb$heights[2:5])

fmsy$widths[2:5] <- as.list(maxwidths)
ssb$widths[2:5] <- as.list(maxwidths)

png("status_bar_plot_family_groups.png",height=12,width=20,units="cm", res = 200)
grid.arrange(arrangeGrob(shared_legend, ncol=1, nrow=1),
             arrangeGrob(fmsy, ssb, ncol=1, nrow=2, heights = c(2,3)),
             heights = c(.5,6))
dev.off()



#### Everything below here is deprecated. Code to make kobe plot table. ######################################################################


## Function to calculate what side of a line a point is on. Used to determine if a point is within the overfished but not overfishing triangle area since quadrants are based on MSST not SSB/SSBMSY = 1
## For a line segment with 2 points, x1 and y1 are the x and y coordinates for the first point, x2 and y2 are the x and y coordinates for the second point, and xp and yp are the coordinates for the point of interest (stock status)
calc.D <- function(x1, x2, y1, y2, xp, yp){
  
  d = (xp - x2) * (y1 - y2) - (x1 - x2) * (yp - y2)
  return(d)
  
}

for(i in 1:nrow(Results)){
  
  ## Not overfishing and not overfishing - green Q4
  if(Results$B_Bmsy_term[i] > Results$MSST_x[i] & 
     Results$F_Fmsy_term[i] < 1){
    Results$Color[i] <- "#A2D269"
    Results$Status[i] <- "Not Overfished and Not Overfishing"
  }
  
  ## Overfishing but not overfished - orange Q1
  if(Results$B_Bmsy_term[i] > Results$MSST_x[i] & 
     Results$F_Fmsy_term[i] > 1){
    Results$Color[i] <- "#FFAC54"
    Results$Status[i] <- "Not Overfished but Overfishing"
  }
  
  ## Overfished and maybe overfishing - red or yellow Q2 and Q3
  if(Results$B_Bmsy_term[i] < Results$MSST_x[i]){
    D.vec <- c()
    D.vec[1] <- calc.D(Results$MSST_x[i], Results$MSST_x[i], 1, 0, 
                       Results$B_Bmsy_term[i], Results$F_Fmsy_term[i])
    D.vec[2] <- calc.D(Results$MSST_x[i], 0, 0, 0, Results$MSST_x[i], Results$F_Fmsy_term[i])
    D.vec[3] <- calc.D(0, Results$MSST_x[i], 0, 1, Results$MSST_x[i], Results$F_Fmsy_term[i])
    
    ## if all d values are the same sign that means the point is within the triangle area
    if(sign(D.vec[1]) == sign(D.vec[2]) & 
       sign(D.vec[2]) == sign(D.vec[3]) & 
       sign(D.vec[1]) == sign(D.vec[3])){
      Results$Color[i] <- "khaki1"
      Results$Status[i] <- "Overfished but Not Overfishing"
    }else{
      Results$Color[i] <- "#FF827A"
      Results$Status[i] <- "Overfished and Overfishing"
    }
      
  }

  
}


Results.ft <- flextable(Results[,-5]) 

Results.ft <- compose(Results.ft, i = 1, j = 2, part = "header", 
        value = as_paragraph(as_i("SSB"), as_sub("2021"), "/", as_i("SSB"), as_sub("MSST")))
Results.ft <- compose(Results.ft, i = 1, j = 3, part = "header", 
        value = as_paragraph(as_i("F"), as_sub("2021"), "/", as_i("F"), as_sub("MSY")))
Results.ft <- compose(Results.ft, i = 1, j =4, part = "header",
                      value = as_paragraph(as_i("MSST")))
Results.ft <- colformat_double(Results.ft, 
                               j = 2:4,
                               digits = 2)
Results.ft <- italic(Results.ft, italic = T, j = 1, part = "body")
Results.ft <- bg(Results.ft, j = 5, bg = Results$Color)
Results.ft <- fontsize(Results.ft, j = 5, size = 10)

save_as_docx(Results.ft, path = file.path(root_dir, "SS3 final models", "status_table.docx"))


