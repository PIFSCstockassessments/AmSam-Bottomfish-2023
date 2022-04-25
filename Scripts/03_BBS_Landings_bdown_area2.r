require(sqldf);	require(dplyr); require(this.path); require(data.table)

# establish directories using this.path::
root_dir <- this.path::here(.. = 1)

D <- fread(paste0(root_dir, "/Data/AS_BBS_SPC_correctLog2.csv"),header=T, stringsAsFactors=FALSE) 
S <- fread(paste0(root_dir, "/Data/a_species.csv"),header=T, stringsAsFactors=FALSE)
S$SCIENTIFIC_NAME <- paste(S$GENUS,S$SCIENTIFIC_NAME)
S <- select(S,SPECIES_PK,SCIENTIFIC_NAME)

# follow Toby's instructions to break the unique key SPC_PK into the interview details we need
D <- mutate(D,YEAR = as.numeric(substr(SPC_PK,2,5)), METHOD = substr(SPC_PK,11,11), 
                   ZONE = substr(SPC_PK,14,14), TYPE = substr(SPC_PK,20,21), 
                   CHARTER = substr(SPC_PK,22,22), PROCESS = substr(SPC_PK,23,23))

D[is.na(VAR_LBS_CAUGHT)] <- 0 # IS this necessary? Does it have an impact?

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

D[SPECIES_FK==243]$SPECIES_FK<-241

D[ZONE=='1']$ZONE<-'Tutuila'			# note banks trips are included in Tutuila expansion
D[ZONE=='2']$ZONE<-'Manua'

# retain all gear types that catch identified BMUS: '4','5','6','8','61' (bfishing, btm/trl mix, spear no tanks, atule-mixed, spear tanks)
#		note that catch of identified BMUS with gears other than bfishing and btm/trl mix are rare, but we retain those gears for landings
#		just to be complete.

D <- D[METHOD=="4"|METHOD=="5"|METHOD=="6"|METHOD=="8"|METHOD=="61"]

# No distinction in our group break down between Grouper (210) and Inshore grouper (380)
# No distinction between Jacks (110) and Trevallies (109)
D[SPECIES_FK == 109]$SPECIES_FK <- 110
D[SPECIES_FK == 380]$SPECIES_FK <- 210

# Select only necessary columns

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)]

#==================Fix Variola louti (229) and V. albimarginata (220) issue (species IDed together from 1986 to 2015)======================
D[YEAR<=2015&(SPECIES_FK==229|SPECIES_FK==220)]$SPECIES_FK <- 99999 # Assign all records to a dummy species code (for now)

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK)] # Sum records together
D$SPECIES_FK <- paste0("S",D$SPECIES_FK) # Add a letter so column names can be reference in steps below

# Re-assign 1986-2015 "V. albi" to both V. louti and V. albi, based on the 2016-2021 occurence ratio obtained in 01_BBS_data_prep.r
# These ratios are: V. louti 0.236 and V.albimarginata 0.764

Prop.Louti <- 0.236; Prop.Albi <- 1-Prop.Louti

# For the catch
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


D <- D[YEAR<=2015&(SPECIES_FK==229|SPECIES_FK==220),list(),by=list()]

D <- D[order(YEAR,ZONE,METHOD,SPECIES_FK)]
Dtest <- Dtest[order(YEAR,ZONE,METHOD,SPECIES_FK)]

unique(D$SPECIES_FK)

View(D[SPECIES_FK==229])


View(D[SCIENTIFIC_NAME=="Variola louti"])





D <- merge(D,S,by.x="SPECIES_FK",by.y="SPECIES_PK")


  

