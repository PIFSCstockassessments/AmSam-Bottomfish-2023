require(dplyr); require(this.path); require(data.table)
root_dir <- this.path::here(.. = 1)

# Years to consider:
# Latest: Although the total number of Manu'a interviews dropped in 2008 (about half of 2007), interviewer 19 did continue a few
#	interviews per most months until December. So, include 2008. Interviewer 08 really petered out in 2007
#	but was most active 93-96 and 2000.
# Earliest: In 1986 and 1987, the majority of bottomfishing and btm/trl mix interviewed landings were identified
#	only to group level, hence for many species, broken down catch from the group categories makes up a lot of the
#	catch. In addition, when I looked at scatterplots of manua vs. tutu catches, 1986 and 1987 were frequent outliers, 
#   with high Tutuila catches and low Manu'a catches. There were also only 2 Manu'a interviews in 1987.
#   so, do not include 1986-1987 in information used to reconstruct recent catches.

# Estimate 2009-2021 Manu'a Islands catch, by species following 2 different approaches
#	a. "slope": Manu'a catch and variance is a proportion of Tutuila catch based on 1988-2008
#		only if p-value of regression indicates slope is not zero
#	b. "constant": Manu'a catch is the average of 1987-2008 Manu'a catch. Variance is the variance
#		of annual estimates 1987-2008

  D <- readRDS(paste0(root_dir,"/Outputs/CATCH_BBS_A.rds"))
  
  T <- D[ZONE=="Manua",list(LBS=sum(LBS_CAUGHT)),by=list(YEAR)]
  ggplot(data=T)+geom_bar(aes(x=YEAR,y=LBS),stat="identity")
  
  E <- dcast(D,SPECIES_FK+YEAR~ZONE,value.var="LBS_CAUGHT")

  ggplot(data=E[YEAR>=1987&YEAR<=2008],aes(x=Tutuila,y=Manua))+geom_point()+stat_smooth(method="lm")+facet_wrap(~SPECIES_FK,scales="free")
  ggplot(data=E[YEAR>=1987&YEAR<=2008],aes(x=Tutuila,y=Manua))+geom_point()+stat_smooth()+facet_wrap(~SPECIES_FK,scales="free")

Sp.list <- unique(E$SPECIES_FK)
Results <- data.table();aResults<-data.table()
for(i in 1:11){
  
  anLM                <- lm(data=E[SPECIES_FK==Sp.list[i]&(YEAR>=1987&YEAR<=2008)],Manua~Tutuila+0)
  aResults$SPECIES_FK <- Sp.list[i]
  aResults$PVALUE     <- round(summary(anLM)$coefficients[4],3)
  aResults$R2         <- round(summary(anLM)$r.squared,3)
  aResults$COEF       <- anLM$coefficients[1]
  Results             <- rbind(Results,aResults)
}

  Results$KEEP <- ifelse(Results$PVALUE<=0.05,1,0)

# Add 2009-2021 Manua catch based on regression results above.
  COEF <- select(Results[KEEP==1],SPECIES_FK,COEF)
  E    <- merge(E,COEF,by="SPECIES_FK")

# Calculate 2009-2021 Manua catch based on Tutuila catch
  E[YEAR>=2009]$Manua <- E[YEAR>=2009]$Tutuila*E[YEAR>=2009]$COEF
  E                   <- select(E[YEAR>=2009],YEAR,SPECIES_FK,LBS_CAUGHT=Manua,)
  E$VAR_LBS_CAUGHT    <- 0 # Set to 0 for now
  E$ZONE              <- "Manua"
    
# Put back together
  D <- D[!(ZONE=="Manua"&YEAR>=2009)] # Remove old Manua catch
  D <- rbind(D,E)  
  
  
  
  

  
  
