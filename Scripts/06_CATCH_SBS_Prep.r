require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx);  require(dplyr);require(stringr)
options(scipen = 999)

# establish directories using this.path::
root_dir <- this.path::here(.. = 1)

# Read in the expanded landings data
D <- fread(file=paste0(root_dir, "/Data/SPC_AS_SBS.csv"),stringsAsFactors=FALSE) 
R <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="AREAS")   );  R <- R[DATASET=="SBS"]
R <- select(R,AREA_ID,AREA_C)
M <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="METHODS") );  M <- M[DATASET=="SBS"]
M <- select(M,METHOD_ID,METHOD_C)
S <- data.table(  read.xlsx(paste0(root_dir, "/Data/METADATA.xlsx"),sheet="ALLSPECIES")   )
S <- select(S,SPECIES_PK,SCIENTIFIC_NAME,FAMILY)
S$SPECIES_PK <- as.character(S$SPECIES_PK)
S$SPECIES_PK <- paste0("S",S$SPECIES_PK)
S            <- select(S,SPECIES_PK,FAMILY,SCIENTIFIC_NAME)

R$AREA_ID   <- as.character(R$AREA_ID)
M$METHOD_ID <- as.character((M$METHOD_ID))

# follow Toby's instructions to break the unique key SPC_PK into the interview details we need
#	watch out- this is a little different from the BBS. See "american samoa SB mysql formulas.docx":
#		SPC_PK: The private key associated with a particular species catch expansion. 
#		Consists of 14 characters of the form rryyCYPdmmssss, determined as:
#			(1,2) rr: Two digits for ROUTE_FK, with leading zeros if necessary
#			(3,4) yy: Two digits for YEAR, calculated as the number of years after 1947
#			(5,6) CY: 
#			(7) P: A single capital letter for the time period (AM_PM), either ?D? for day or ?N? for night
#			(8) d: A single digit for TYPE_OF_DAY, either 1 for weekday or 2 for weekend/holiday
#			(9,10) mm: Two digits for METHOD_FK, with leading zeros if necessary
#			(11,14) ssss: Four digits for SPECIES_FK, with leading zeros if necessary

D <- mutate(D, YEAR = as.numeric(substr(SPC_PK,3,4)), METHOD = substr(SPC_PK,9,10), 
               ROUTE = substr(SPC_PK,1,2), TYPE = substr(SPC_PK,8,8), 
               DAYNIGHT = substr(SPC_PK,7,7))

D$YEAR                           <- D$YEAR+1947
D$SPECIES_FK                     <- paste0("S",D$SPECIES_FK)
D[SPECIES_FK=="S243"]$SPECIES_FK <- "S241" # Fix P. rutilans

# Simplify gears and routes
D <- merge(D,R,by.x="ROUTE",by.y="AREA_ID")
D <- merge(D,M,by.x="METHOD",by.y="METHOD_ID")
D <- merge(D,S,by.x="SPECIES_FK",by.y="SPECIES_PK")

#setnames(D,"AREA_C","ZONE")

D[is.na(VAR_EXP_LBS)]$VAR_EXP_LBS <- 0 # Is this necessary?

# rename duplicate group SPECIES_FK in cases of complete union:
D[SPECIES_FK == "S109"]$SPECIES_FK <- "S110"  # Jacks and Trevallies
D[SPECIES_FK == "S380"]$SPECIES_FK <- "S210"  # Groupers and Inshore groupers
D[SPECIES_FK == "S390"]$SPECIES_FK <- "S230"  # Deep snappers and inshore snappers (integrate here given how little deep snappers there are)

# Select a reduced number of fields and sum catch in these
D <- D[,list(EXP_LBS=sum(EXP_LBS),VAR_EXP_LBS=sum(VAR_EXP_LBS)),by=list(SPECIES_FK,YEAR,AREA_C)]

#==================Fix Variola louti (229) and V. albimarginata (220) issue (species IDed together from 1986 to 2015)======================
D[YEAR<=2015&(SPECIES_FK=="S229"|SPECIES_FK=="S220")]$SPECIES_FK <- "S99999" # Assign all records to a dummy species code (for now)

D <- D[,list(EXP_LBS=sum(EXP_LBS),VAR_EXP_LBS=sum(VAR_EXP_LBS)),by=list(SPECIES_FK,YEAR,AREA_C)] # Sum records together

# Re-assign 1986-2015 "S99999" to both V. louti and V. albi, based on the 2016-2021 occurence ratio obtained in 01_SBS_data_prep.r
# These ratios are: V. louti 0.383 and V.albimarginata 0.617

Prop.Louti <- 0.383; Prop.Albi <- 1-Prop.Louti

# For the catch
D.LBS                  <- dcast(D,YEAR+AREA_C~SPECIES_FK,value.var="EXP_LBS",fill=0)
D.LBS[YEAR<=2015]$S220 <- D.LBS[YEAR<=2015]$S99999*Prop.Albi  # Assign Prop.louti proportion to Variola catch
D.LBS[YEAR<=2015]$S229 <- D.LBS[YEAR<=2015]$S99999*Prop.Louti # Assign Prop.louti proportion to Variola catch
D.LBS                  <- select(D.LBS,-S99999) # Get rid of Variolas column
D.LBS                  <- melt.data.table(D.LBS,id.vars=1:2,variable.name="SPECIES_FK",value.name="EXP_LBS")

# For the variance
D.VAR                  <- dcast(D,YEAR+AREA_C~SPECIES_FK,value.var="VAR_EXP_LBS",fill=0)
D.VAR[YEAR<=2015]$S220 <- D.VAR[YEAR<=2015]$S99999*Prop.Albi  # Assign Prop.louti proportion to Variola catch
D.VAR[YEAR<=2015]$S229 <- D.VAR[YEAR<=2015]$S99999*Prop.Louti # Assign Prop.louti proportion to Variola catch
D.VAR                  <- select(D.VAR,-S99999) # Get rid of Variolas column
D.VAR                  <- melt.data.table(D.VAR,id.vars=1:2,variable.name="SPECIES_FK",value.name="VAR_EXP_LBS")

# Merge back catch and variance
D            <- merge(D.LBS,D.VAR,by=c("YEAR","AREA_C","SPECIES_FK"))
D$SPECIES_FK <- as.character(D$SPECIES_FK)

#======================Break down taxonomic groups into species components using proportion table from 03_BBS_proptables.R===============================

PT            <- readRDS(paste0(root_dir, "/Outputs/SBS_Prop_Table.rds"))  # Species composition of groups, by group x period x region
PT$GROUP_FK   <- paste0("S",PT$GROUP_FK)
PT$SPECIES_FK <- paste0("S",PT$SPECIES_FK)

X            <- D[SPECIES_FK=="S109"|SPECIES_FK=="S110"|SPECIES_FK=="S200"|SPECIES_FK=="S210"|SPECIES_FK=="S230"|SPECIES_FK=="S240"|SPECIES_FK=="S260"|SPECIES_FK=="S380"|SPECIES_FK=="S390"]
X            <- merge(X,PT,by.x="SPECIES_FK",by.y="GROUP_FK",allow.cartesian=T)
X$SPECIES_FK <- X$SPECIES_FK.y
X$EXP_LBS    <- X$EXP_LBS*X$Prop
X            <- select(X,-SPECIES_FK.y,-Prop)
X$SOURCE     <- "Group-level"

Y        <- D
Y        <- Y[SPECIES_FK!="S109"|SPECIES_FK!="S110"|SPECIES_FK!="S200"|SPECIES_FK!="S210"|SPECIES_FK!="S230"|SPECIES_FK!="S240"|SPECIES_FK!="S260"|SPECIES_FK!="S380"|SPECIES_FK!="S390"]
Y$SOURCE <- "Species-level"

Z <- rbind(X,Y)

#Add a BMUS classification to simplify further summary code
Z$BMUS <- "F"
Z[SPECIES_FK=="S247"|SPECIES_FK=="S239"|SPECIES_FK=="S111"|SPECIES_FK=="S249"|
    SPECIES_FK=="S248"|SPECIES_FK=="S267"|SPECIES_FK=="S231"|SPECIES_FK=="S242"|
    SPECIES_FK=="S241"|SPECIES_FK=="S245"|SPECIES_FK=="S229"]$BMUS <- "T"

D$BMUS <- "F"
D[SPECIES_FK=="S247"|SPECIES_FK=="S239"|SPECIES_FK=="S111"|SPECIES_FK=="S249"|
    SPECIES_FK=="S248"|SPECIES_FK=="S267"|SPECIES_FK=="S231"|SPECIES_FK=="S242"|
    SPECIES_FK=="S241"|SPECIES_FK=="S245"|SPECIES_FK=="S229"]$BMUS <- "T"

# Final data, saved for export
F <- Z[BMUS=="T",list(EXP_LBS=sum(EXP_LBS),VAR_EXP_LBS=sum(VAR_EXP_LBS)),by=list(SPECIES_FK,YEAR,AREA_C)]
F$SD.LBS <- sqrt(F$VAR_EXP_LBS)

# Check group-derived vs species-derived BMUS catch
T1 <- Z[BMUS=="T",list(EXP_LBS=sum(EXP_LBS)),by=list(YEAR,SOURCE)]
ggplot()+geom_bar(data=T1,aes(x=YEAR,y=EXP_LBS,fill=SOURCE),size=1,position="stack",stat="identity")+theme_bw()

# Check total BMUS catch by year
T2 <- T1[,list(EXP_LBS=sum(EXP_LBS)),by=list(YEAR)]

# Check catch in both AREAs
T3 <- Z[BMUS=="T",list(EXP_LBS=sum(EXP_LBS)),by=list(YEAR)]
ggplot(data=T3)+geom_bar(aes(x=YEAR,y=EXP_LBS),stat="identity",position="stack")

# Further testing  
ggplot(data=F)+geom_bar(aes(x=YEAR,y=EXP_LBS),stat="identity")+facet_wrap(~SPECIES_FK)

test  <- D[BMUS=="T",list(LBS_RAW=sum(EXP_LBS)),by=list(YEAR,SPECIES_FK)]
test2 <- select(F,-VAR_EXP_LBS,-SD.LBS)
test3 <- merge(test,test2,by=c("YEAR","SPECIES_FK"))
ggplot(data=test3[SPECIES_FK=="S229"])+geom_line(aes(x=YEAR,y=EXP_LBS),col="blue")+geom_line(aes(x=YEAR,y=LBS_RAW),col="red")

# Save BMUS catch to files
F$SOURCE <- "SBS"
F        <- select(F,SOURCE,SPECIES_FK,YEAR,AREA_C,LBS=EXP_LBS,SD.LBS)

saveRDS(F,file=paste0(root_dir,"/Outputs/CATCH_SBS_A.rds"))


