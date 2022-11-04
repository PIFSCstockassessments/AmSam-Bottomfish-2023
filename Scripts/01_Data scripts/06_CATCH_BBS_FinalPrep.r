require(tidyverse); require(this.path); require(data.table); require(openxlsx)

root_dir <- this.path::here(.. = 2)
options(scipen = 999)

D <- fread(paste0(root_dir, "/Data/AS_BBS_SPC_correctLog2.csv"), stringsAsFactors=FALSE) 

# Add more species info
S                 <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="ALLSPECIES")   )
S                 <- select(S,SPECIES_PK,SCIENTIFIC_NAME,FAMILY)
S$SPECIES_PK      <- paste0("S",S$SPECIES_PK) 
D$SPECIES_FK      <- paste0("S",D$SPECIES_FK) 
D                 <- merge(D,S,by.x="SPECIES_FK",by.y="SPECIES_PK")


# follow Toby's instructions to break the unique key SPC_PK into the interview details we need
D <- mutate(D,YEAR = as.numeric(substr(SPC_PK,2,5)), METHOD = substr(SPC_PK,11,11), 
                   ZONE = substr(SPC_PK,14,14), TYPE = substr(SPC_PK,20,21), 
                   CHARTER = substr(SPC_PK,22,22), PROCESS = substr(SPC_PK,23,23))

D[is.na(VAR_LBS_CAUGHT)]$VAR_LBS_CAUGHT <- 0 # IS this necessary? Does it have an impact?

D[ZONE=='1']$ZONE<-'Tutuila'			# note banks trips are included in Tutuila expansion
D[ZONE=='2']$ZONE<-'Manua'


D[SPECIES_FK=="S109"]$SPECIES_FK <- "S110" # Merge Trevallies and Jacks
D[SPECIES_FK=="S380"]$SPECIES_FK <- "S210" # Merge Inshore groupers and groupers

#  Note:
#		Method	4 = bottomfishing, 5 = btm/trl mix
#		Zone	1 = Tutuila, 2 = Manua
#		Type	WD = weekday, WE = weekend
#		Charter	C = yes, N = no
#		Process	G = Tutuila, M = Manua

# ---- per Hongguang / Toby:
#	LBS_CAUGHT is the expanded landings, in lbs, and VAR_LBS_CAUGHT is the estimated variance of expanded landings (sigma^2).
#	Because the different expansion strata (year x method x zone x type x charter x species) are independent,
#	when summing across strata, you simply sum the variances and sample sizes.
#		for sample size, use NUM_INTERVIEW_POOLED (this includes all interviews in the strata, including 0s).
#	Although it might not be entirely statistically sound, Hongguang says to sum the P. rutilans with P. flavi for now.
#		so just replace SPECIES_FK = 243 with 241 now

D[SPECIES_FK=="S243"]$SPECIES_FK<-"S241"

# retain all gear types that catch identified BMUS: '4','5','6','8','61' (bfishing, btm/trl mix, spear no tanks, atule-mixed, spear tanks)
#		note that catch of identified BMUS with gears other than bfishing and btm/trl mix are rare, but we retain those gears for landings
#		just to be complete.

D <- D[METHOD=="4"|METHOD=="5"|METHOD=="6"|METHOD=="8"|METHOD=="61"]

# Select only necessary columns
#summing the lbs caught and variance of the lbs caught by year-area-fishing method-species combination
D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)]

#==================Fix Variola louti (229) and V. albimarginata (220) issue (species IDed together from 1986 to 2015)======================
D[YEAR<=2015&(SPECIES_FK=="S229"|SPECIES_FK=="S220")]$SPECIES_FK <- "S99999" # Assign all records to a dummy species code (for now)

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)] # Sum records together

# Re-assign 1986-2015 "S99999" to both V. louti and V. albi, based on the 2016-2021 occurrence ratio obtained in 01_BBS_data_prep.r
# These ratios are: V. louti 0.236 and V.albimarginata 0.764

Prop.Louti <- 0.236; Prop.Albi <- 1-Prop.Louti

# For the catch
#spreading out the lbs caught by species for each year-area-fishing method (any missing values were 0s)
D.LBS                  <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="LBS_CAUGHT",fill=0)
D.LBS[YEAR<=2015]$S220 <- D.LBS[YEAR<=2015]$S99999*Prop.Albi  # Assign Prop.louti proportion to Variola catch
D.LBS[YEAR<=2015]$S229 <- D.LBS[YEAR<=2015]$S99999*Prop.Louti # Assign Prop.louti proportion to Variola catch
D.LBS                  <- select(D.LBS,-S99999) # Get rid of Variolas column
D.LBS                  <- melt.data.table(D.LBS,id.vars=1:3,variable.name="SPECIES_FK",value.name="LBS_CAUGHT")

# For the variance
D.VAR                  <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="VAR_LBS_CAUGHT",fill=0)
D.VAR[YEAR<=2015]$S220 <- D.VAR[YEAR<=2015]$S99999*Prop.Albi  # Assign Prop.louti proportion to Variola catch
D.VAR[YEAR<=2015]$S229 <- D.VAR[YEAR<=2015]$S99999*Prop.Louti # Assign Prop.louti proportion to Variola catch
D.VAR                  <- select(D.VAR,-S99999) # Get rid of Variolas column
D.VAR                  <- melt.data.table(D.VAR,id.vars=1:3,variable.name="SPECIES_FK",value.name="VAR_LBS_CAUGHT")

# Merge back catch and variance
D <- merge(D.LBS,D.VAR,by=c("YEAR","ZONE","METHOD","SPECIES_FK"))
D$SPECIES_FK <- as.character(D$SPECIES_FK)

#==================Fix Pristipomoides flavipinnis (241) and P. filamentosus (242) issue (species IDed together from 2010 to 2015)======================
D[(YEAR>=2010&YEAR<=2015)&(SPECIES_FK=="S241"|SPECIES_FK=="S242")]$SPECIES_FK <- "S99999" # Assign all records to a dummy species code (for now)

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)] # Sum records together by year-area-fishing method-species combination

# Re-assign 2010-2015 "S99999" to both P. flavi and P. filamen, based on the 2016-2021 occurrence ratio obtained in 01_BBS_data_prep.r
# These ratios are: P. flavi 0.934 and P. filamentosus 0.

Prop.Flavi <- 0.934; Prop.Filam <- 1-Prop.Flavi

# For the catch
D.LBS                             <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="LBS_CAUGHT",fill=0)
D.LBS[YEAR>=2010&YEAR<=2015]$S241 <- D.LBS[YEAR>=2010&YEAR<=2015]$S99999*Prop.Flavi  # Assign Prop.louti proportion to Variola catch
D.LBS[YEAR>=2010&YEAR<=2015]$S242 <- D.LBS[YEAR>=2010&YEAR<=2015]$S99999*Prop.Filam # Assign Prop.louti proportion to Variola catch
D.LBS                             <- select(D.LBS,-S99999) # Get rid of Variolas column
D.LBS                             <- melt.data.table(D.LBS,id.vars=1:3,variable.name="SPECIES_FK",value.name="LBS_CAUGHT")

# For the variance
D.VAR                             <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="VAR_LBS_CAUGHT",fill=0)
D.VAR[YEAR>=2010&YEAR<=2015]$S241 <- D.VAR[YEAR>=2010&YEAR<=2015]$S99999*Prop.Flavi  # Assign Prop.louti proportion to Variola catch
D.VAR[YEAR>=2010&YEAR<=2015]$S242 <- D.VAR[YEAR>=2010&YEAR<=2015]$S99999*Prop.Filam # Assign Prop.louti proportion to Variola catch
D.VAR                             <- select(D.VAR,-S99999) # Get rid of Variolas column
D.VAR                             <- melt.data.table(D.VAR,id.vars=1:3,variable.name="SPECIES_FK",value.name="VAR_LBS_CAUGHT")

# Merge back catch and variance
D <- merge(D.LBS,D.VAR,by=c("YEAR","ZONE","METHOD","SPECIES_FK"))
D$SPECIES_FK <- as.character(D$SPECIES_FK)

# Remove the zero catch strata
D <- D[LBS_CAUGHT>0]

#===============Fix L. rubrioperculatus (267) in the Manuas I. issue (fisher say it's common, barely recorded, lots of unidentified emperors)===============
D <- merge(D,S,by.x="SPECIES_FK",by.y="SPECIES_PK") # Add family info so we can select all Emperors quickly

D[ZONE=="Manua"&FAMILY=="Lethrinidae"]$SPECIES_FK <- "S99999" # Assign all emperor records to a dummy species code (for now)

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)] # Sum records together

# Re-assign Manuas "S99999" to L. rubrioperculatus, based on the 1986-2010 occurrence ratio obtained in 01_BBS_data_prep.r
# This ratio is: 0.32

Prop.Rubrio <- 0.32; Prop.OtherEmps <- 1-Prop.Rubrio

# For the catch
D.LBS                             <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="LBS_CAUGHT",fill=0)
D.LBS[ZONE=="Manua"]$S267 <- D.LBS[ZONE=="Manua"]$S99999*Prop.Rubrio    # Assign Prop.Rubrio proportion to LERU catch
D.LBS[ZONE=="Manua"]$S260 <- D.LBS[ZONE=="Manua"]$S99999*Prop.OtherEmps # Assign Prop.OtherEmps proportion to other emperor catch
D.LBS                             <- select(D.LBS,-S99999) # Get rid of Variolas column
D.LBS                             <- melt.data.table(D.LBS,id.vars=1:3,variable.name="SPECIES_FK",value.name="LBS_CAUGHT")

# For the variance
D.VAR                             <- dcast(D,YEAR+ZONE+METHOD~SPECIES_FK,value.var="VAR_LBS_CAUGHT",fill=0)
D.VAR[ZONE=="Manua"]$S267 <- D.VAR[ZONE=="Manua"]$S99999*Prop.Rubrio    # Assign Prop.Rubrio proportion to LERU catch
D.VAR[ZONE=="Manua"]$S260 <- D.VAR[ZONE=="Manua"]$S99999*Prop.OtherEmps # Assign Prop.OtherEmps proportion to other emperor catch
D.VAR                             <- select(D.VAR,-S99999) # Get rid of Variolas column
D.VAR                             <- melt.data.table(D.VAR,id.vars=1:3,variable.name="SPECIES_FK",value.name="VAR_LBS_CAUGHT")

# Merge back catch and variance
D <- merge(D.LBS,D.VAR,by=c("YEAR","ZONE","METHOD","SPECIES_FK"))

# Remove the zero catch strata
D <- D[LBS_CAUGHT>0]
D$SPECIES_FK <- as.character(D$SPECIES_FK)

#======================Break down taxonomic groups into species components using proportion table from 03_BBS_proptables.R===============================

PT            <- readRDS(paste0(root_dir, "/Outputs/BBS_Prop_Table.rds"))  # Species composition of groups, by group x period x region
PT$GROUP_FK   <- paste0("S",PT$GROUP_FK)
PT$SPECIES_FK <- paste0("S",PT$SPECIES_FK)

D$PERIOD <- 999 # Add time period that matches the one used for prop table (PT)
D[YEAR>1985&YEAR<=1995]$PERIOD  <- 1995
D[YEAR>1995&YEAR<=2005]$PERIOD  <- 2005
D[YEAR>2005&YEAR<=2015]$PERIOD  <- 2015
D[YEAR>2015&YEAR<=2025]$PERIOD  <- 2025

X            <- D[SPECIES_FK=="S109"|SPECIES_FK=="S110"|SPECIES_FK=="S200"|SPECIES_FK=="S210"|SPECIES_FK=="S230"|SPECIES_FK=="S240"|SPECIES_FK=="S260"|SPECIES_FK=="S380"|SPECIES_FK=="S390"]

ggplot(data=X[ZONE=="Tutuila"],aes(x=YEAR,y=LBS_CAUGHT))+
  geom_bar(stat="identity")+
  facet_wrap(~SPECIES_FK,scales="free_y")
ggsave(last_plot(),file=paste0(root_dir, "/Outputs/Summary/CATCH_GROUPED.png"),width=8,height=4)

X            <- merge(X,PT,by.x=c("SPECIES_FK","PERIOD","ZONE"),by.y=c("GROUP_FK","PERIOD","AREA_C"),allow.cartesian=T)
X$SPECIES_FK <- X$SPECIES_FK.y
X$LBS_CAUGHT <- X$LBS_CAUGHT*X$Prop
X            <- select(X,-SPECIES_FK.y,-Prop,-PERIOD)
X$SOURCE     <- "Group-level"

Y        <- select(D,-PERIOD )
Y        <- Y[SPECIES_FK!="S109"|SPECIES_FK!="S110"|SPECIES_FK!="S200"|SPECIES_FK!="S210"|SPECIES_FK!="S230"|SPECIES_FK!="S240"|SPECIES_FK!="S260"|SPECIES_FK!="S380"|SPECIES_FK!="S390"]
Y$SOURCE <- "Species-level"

Z <- rbind(X,Y)

# Add a BMUS classification to simplify further summary code
Z$BMUS <- "F"
Z[SPECIES_FK=="S247"|SPECIES_FK=="S239"|SPECIES_FK=="S111"|SPECIES_FK=="S249"|
    SPECIES_FK=="S248"|SPECIES_FK=="S267"|SPECIES_FK=="S231"|SPECIES_FK=="S242"|
    SPECIES_FK=="S241"|SPECIES_FK=="S245"|SPECIES_FK=="S229"]$BMUS <- "T"

D$BMUS <- "F"
D[SPECIES_FK=="S247"|SPECIES_FK=="S239"|SPECIES_FK=="S111"|SPECIES_FK=="S249"|
    SPECIES_FK=="S248"|SPECIES_FK=="S267"|SPECIES_FK=="S231"|SPECIES_FK=="S242"|
    SPECIES_FK=="S241"|SPECIES_FK=="S245"|SPECIES_FK=="S229"]$BMUS <- "T"

T0 <- Z[BMUS=="T",list(LBS_CAUGHT=sum(LBS_CAUGHT)),by=list(YEAR,SPECIES_FK)]
ggplot(data=T0)+geom_bar(aes(x=YEAR,y=LBS_CAUGHT,fill=SPECIES_FK),size=1,position="stack",stat="identity")+theme_bw()

# Check group-derived vs species-derived BMUS catch
T1 <- Z[BMUS=="T",list(LBS_CAUGHT=sum(LBS_CAUGHT)),by=list(YEAR,SOURCE)]
ggplot()+geom_bar(data=T1,aes(x=YEAR,y=LBS_CAUGHT,fill=SOURCE),size=1,position="stack",stat="identity")+theme_bw()

# Other tests
T2 <- Z[BMUS=="T",list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(SPECIES_FK,YEAR)]
T2$SD <- sqrt(T2$VAR_LBS_CAUGHT)

test  <- D[BMUS=="T",list(LBS_RAW=sum(LBS_CAUGHT)),by=list(YEAR,SPECIES_FK)]
test2 <- select(T2,-VAR_LBS_CAUGHT,-SD)
test3 <- merge(test,test2,by=c("YEAR","SPECIES_FK"))
ggplot(data=test3[SPECIES_FK=="S229"])+geom_line(aes(x=YEAR,y=LBS_CAUGHT),col="blue")+geom_line(aes(x=YEAR,y=LBS_RAW),col="red")


# Save catch record by ZONE, for Manua catch reconstruction
G <- Z[BMUS=="T",list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(SPECIES_FK,ZONE,YEAR)]
G <- G[order(SPECIES_FK,ZONE,YEAR)]


# =============== Reconstruct Manua 2009-2021 based on regression with Tutuila data=====================================

# Years to consider:
# Latest: Although the total number of Manu'a interviews dropped in 2008 (about half of 2007), interviewer 19 did continue a few
#	interviews per most months until December. So, include 2008. Interviewer 08 really petered out in 2007
#	but was most active 93-96 and 2000.
# Earliest: In 1986 and 1987, the majority of bottomfishing and btm/trl mix interviewed landings were identified
#	only to group level, hence for many species, broken down catch from the group categories makes up a lot of the
#	catch. In addition, when I looked at scatterplots of manua vs. tutu catches, 1986 and 1987 were frequent outliers, 
#   with high Tutuila catches and low Manu'a catches. There were also only 2 Manu'a interviews in 1987.
#   so, do not include 1986-1987 in information used to reconstruct recent catches.

# Estimate 2009-2021 Manu'a Islands catch, by species following this approach:
#	a. "slope": Manu'a catch and variance is a proportion of Tutuila catch based on 1988-2008
#		only if p-value of regression indicates slope is not zero


Tt <- G[ZONE=="Manua",list(LBS=sum(LBS_CAUGHT)),by=list(YEAR)]
ggplot(data=Tt)+geom_bar(aes(x=YEAR,y=LBS),stat="identity")

E <- dcast(G,SPECIES_FK+YEAR~ZONE,value.var="LBS_CAUGHT")

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
G <- G[!(ZONE=="Manua"&YEAR>=2009)] # Remove old Manua catch
G <- rbind(G,E)  

# Save final boat-based catch file

G$SOURCE <- "BBS"
G$SD.LBS <- sqrt(G$VAR_LBS_CAUGHT)
G        <- select(G,SOURCE,SPECIES_FK,YEAR,AREA_C=ZONE,LBS=LBS_CAUGHT,SD.LBS)
saveRDS(G,file=paste0(root_dir, "/Outputs/CATCH_BBS_A.rds"))



