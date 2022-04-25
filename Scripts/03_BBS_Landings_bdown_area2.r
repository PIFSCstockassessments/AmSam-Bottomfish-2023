require(sqldf);	require(dplyr); require(this.path); require(data.table)

# establish directories using this.path::
root_dir <- this.path::here(.. = 1)

D <- fread(paste0(root_dir, "/Data/AS_BBS_SPC_correctLog2.csv"),header=T, stringsAsFactors=FALSE) 
S <- fread(paste0(root_dir, "/Data/a_species.csv"),header=T, stringsAsFactors=FALSE)
S$SCIENTIFIC_NAME <- paste(S$GENUS,S$SCIENTIFIC_NAME)
S <- select(S,SPECIES_PK,SCIENTIFIC_NAME)
D <- merge(D,S,by.x="SPECIES_FK",by.y="SPECIES_PK")

# follow Toby's instructions to break the unique key SPC_PK into the interview details we need
D <- mutate(D,YEAR = as.numeric(substr(SPC_PK,2,5)), METHOD = substr(SPC_PK,11,11), 
                   ZONE = substr(SPC_PK,14,14), TYPE = substr(SPC_PK,20,21), 
                   CHARTER = substr(SPC_PK,22,22), PROCESS = substr(SPC_PK,23,23))

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

D <- D[,list(LBS_CAUGHT=sum(LBS_CAUGHT),VAR_LBS_CAUGHT=sum(VAR_LBS_CAUGHT)),by=list(YEAR,ZONE,METHOD,SPECIES_FK,SCIENTIFIC_NAME)]

# Fix Variola louti (229) and V. albimarginata (220) issue (species IDed together from 1986 to 2015)

D[YEAR<=2015&(SPECIES_FK==229|SPECIES_FK==220)]$SPECIES_FK      <- "220" # Assign all records to V. albimarginata (for now)
D[YEAR<=2015&(SPECIES_FK==229|SPECIES_FK==220)]$SCIENTIFIC_NAME <- "Variola albimarginata" # Assign all records to V. albimarginata (for now)



D <- D[YEAR<=2015&(SPECIES_FK==229|SPECIES_FK==220),list(),by=list()]





View(D[SCIENTIFIC_NAME=="Variola louti"])




  

