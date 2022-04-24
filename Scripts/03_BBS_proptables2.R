require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx);  require(dplyr);require(stringr)

options(scipen = 999)

Z <- readRDS("Outputs\\CPUE_processed.rds")
Z <- select(Z,YEAR,AREA_C,SPECIES_FK,INTERVIEW_PK,CATCH_FK,SCIENTIFIC_NAME,METHOD_FK,EST_LBS)
Z <- Z[,list(EST_LBS=max(EST_LBS)),by=list(INTERVIEW_PK,CATCH_FK,YEAR,AREA_C,SPECIES_FK,SCIENTIFIC_NAME,METHOD_FK)]
Z$SPECIES_FK <- as.numeric(Z$SPECIES_FK)

# Append species group association table
SKEY            <- fread(file="Data\\AmSam_BBS-SBS_GroupKey2.csv")
#SKEY$SPECIES_PK <- as.character(SKEY$SPECIES_PK)
SKEY            <- SKEY[,-(2:6)]
Z               <- merge(Z,SKEY,by.x="SPECIES_FK",by.y="SPECIES_PK")

Z[SPECIES_FK==109]$SPECIES_FK <- 110 # Merge Trevallies and Jacks

# Define the time PERIOD used to calculate species proportions
Z$PERIOD <- 999
Z[YEAR>1985&YEAR<=1995]$PERIOD <- 1995
Z[YEAR>1995&YEAR<=2005]$PERIOD  <- 2005
Z[YEAR>2005&YEAR<=2015]$PERIOD  <- 2015
Z[YEAR>2015&YEAR<=2025]$PERIOD  <- 2025


# Establish list of taxonomic groups (groups that are only composed of species)
Group.listA <- c("Jacks_110","Prist_Etelis_240","Emperors_260","Inshore_groupers_380","Inshore_snappers_390")

# 2nd tier list (groups that are composed of species and one of the subgroups in listA)
Group.listB <- c("Groupers_210","Deep_snappers_230")

# 3rd tier list (group that is composed of species and all of the subgroups above)
Group.listC <- c("Bottomfishes_200")


# Calculate species proportion for all groups that only contain species
ResultsA <- list()
for(i in 1:length(Group.listA)){

   aGroup      <- Group.listA[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
    
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group

   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   ResultsA[[i]] <- Prop
}

# Put prop dataset together
FinalA <- rbindlist(ResultsA)

# Calculate species proportion for groups that contain 1 subgroup
ResultsB <- list()
for(i in 1:length(Group.listB)){
   
   aGroup      <- Group.listB[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   Prop        <- select(Prop,-EST_LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalA,by.x=c("SPECIES_FK","PERIOD","AREA_C"),by.y=c("GROUP_FK","PERIOD","AREA_C"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK <- Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(SPECIES_FK,PERIOD,AREA_C)]
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   Prop          <- Prop[order(PERIOD,AREA_C,SPECIES_FK)]
   ResultsB[[i]] <- Prop
}

# Put prop dataset together
FinalB <- rbindlist(ResultsB)
FinalB <- rbind(FinalA, FinalB)

# Calculate species proportion for final group that contains all subgroups (bottomfish)
ResultsC <- list()
for(i in 1:length(Group.listC)){
   
   aGroup      <- Group.listC[i];   aSPECIES_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(EST_LBS=sum(EST_LBS)),by=list(SPECIES_FK,PERIOD,AREA_C)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&SPECIES_FK!=aSPECIES_FK,list(TOTAL=sum(EST_LBS)),by=list(PERIOD,AREA_C)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by PERIOD
   Prop        <- merge(Total.Sp,Total.Overall,by=c("PERIOD","AREA_C"))
   Prop$Prop   <- Prop$EST_LBS/Prop$TOTAL 
   Prop        <- select(Prop,-EST_LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalB,by.x=c("SPECIES_FK","PERIOD","AREA_C"),by.y=c("GROUP_FK","PERIOD","AREA_C"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK <- Prop[!is.na(SPECIES_FK.y)]$SPECIES_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(SPECIES_FK,PERIOD,AREA_C)]
   
   Prop$GROUP_FK <- aSPECIES_FK
   Prop          <- select(Prop,GROUP_FK,PERIOD,AREA_C,SPECIES_FK,Prop)
   Prop          <- Prop[order(PERIOD,AREA_C,SPECIES_FK)]
   ResultsC[[i]] <- Prop
}

# Put prop dataset together
FinalC <- rbindlist(ResultsC)
Final  <- rbind(FinalB,FinalC)


Final <- Final[,list(Prop=sum(Prop)),by=list(GROUP_FK,PERIOD,AREA_C,SPECIES_FK)]

#write.xlsx(Final,file="prop_table_test.xlsx")

# Some graphical exploration of species proportion evolution

Test <- Final[SPECIES_FK==111|SPECIES_FK==229|SPECIES_FK==231|SPECIES_FK==239|SPECIES_FK==241|SPECIES_FK==242|SPECIES_FK==245|
                 SPECIES_FK==247|SPECIES_FK==248|SPECIES_FK==267]
ggplot(data=Test[GROUP_FK==200&AREA_C=="Tutuila"])+geom_line(aes(x=PERIOD,y=Prop,col=as.character(SPECIES_FK)))
ggplot(data=Test[GROUP_FK==230&AREA_C=="Tutuila"])+geom_line(aes(x=PERIOD,y=Prop,col=as.character(SPECIES_FK)))








# Use the species proportion information calculated above to split group catch into species components
Z <- select(Z,SPECIES_FK,Year,PERIOD,EST_LBS)

X <- Z[SPECIES_FK==109|SPECIES_FK==110|SPECIES_FK==200|SPECIES_FK==210|SPECIES_FK==230|SPECIES_FK==240|SPECIES_FK==260|SPECIES_FK==380|SPECIES_FK==390]

X <- merge(X,Final,by.x=c("SPECIES_FK","PERIOD"),by.y=c("GROUP_FK","PERIOD"),allow.cartesian=T)
X$SPECIES_FK <- X$SPECIES_FK.y
X$EST_LBS        <- X$EST_LBS*X$Prop
X <- select(X,SPECIES_FK,Year,EST_LBS)
X$Source <- "Group-level"

Y <- select(Z,-PERIOD )
Y <- Y[SPECIES_FK!=109&SPECIES_FK!=110&SPECIES_FK!=200&SPECIES_FK!=210&SPECIES_FK!=230&SPECIES_FK!=240&SPECIES_FK!=260&SPECIES_FK!=380&SPECIES_FK!=390]
Y$Source <- "Species-level"

X <- rbind(X,Y)

# Select species and plot
#T <- S[SCIENTIFIC_NAME2=="Aprion virescens"]

# Check for all BMUS
T <- X[SPECIES_FK==247|SPECIES_FK==239|SPECIES_FK==111|SPECIES_FK==249|
         SPECIES_FK==248|SPECIES_FK==267|SPECIES_FK==231|SPECIES_FK==242|
         SPECIES_FK==241|SPECIES_FK==245|SPECIES_FK==229,
       list(EST_LBS=sum(EST_LBS)),by=list(Year,Source)]

ggplot()+geom_area(data=T,aes(x=Year,y=EST_LBS,fill=Source),size=1)+theme_bw()

ggplot()+geom_line(data=T,aes(x=Year,y=EST_LBS,col=Source),size=1)+ylab("Catch (lb)")+theme_bw()

T[,list(EST_LBS=sum(EST_LBS)),by=list(Source)]

279324/(279324+64658)


# Load expanded BBS catch for comparison

D        <- data.table(  read.csv(file="DATA/BBS expanded catch.csv",stringsAsFactors=FALSE) )
#B        <- D[Zone=="Tutuila",list(EST_LBS=sum(Landings)),by=list(Year)]
B        <- D[,list(EST_LBS=sum(Landings)),by=list(Year)]
B$Source <- "BBS"

F <- rbind(T,B)

A <- T[,list(EST_LBS=sum(EST_LBS)),by=list(Year)]
A$Source <- "Group+Species-level"

A <- rbind(A,B)


ggplot()+geom_line(data=F,aes(x=Year,y=EST_LBS,col=Source),size=2)+theme_bw()
ggplot()+geom_line(data=A,aes(x=Year,y=EST_LBS,col=Source),size=1)+ylab("Catch (lb)")+xlim(c(1990,2019))+
   scale_color_hue(labels = c("Total catch (BBS)", "Commercial catch (DRS)"))+theme_bw()


A[Year>=1990&Year<=2020,list(EST_LBS=mean(EST_LBS)),by=list(Source)]

14367/15392

11096/14823



# Species specific comparisons (BBS)

H <- data.table(  read.csv(file="DATA/bbs_landings_breakdown_sp.csv",stringsAsFactors=FALSE) )
H <- H[zone=="Tutuila"&type=="sm_break",list(EST_LBS=sum(EST_LBS_CAUGHT)),by=list(year,SPECIES_FK)]

# Fill implied zeroes
H <- dcast(H,year~SPECIES_FK,fill=0)
H <- melt(H,measure.vars = 2:12,variable.name = "SPECIES_FK",value.name="EST_LBS")
H$SPECIES_FK = as.numeric(as.character(H$SPECIES_FK))
H$Source <- "BBS"

# Species specific comparisons (DRS)
Y <- X[Source=="Species-level"&(SPECIES_FK==247|SPECIES_FK==239|SPECIES_FK==111|SPECIES_FK==249|
                                   SPECIES_FK==248|SPECIES_FK==267|SPECIES_FK==231|SPECIES_FK==242|
                                   SPECIES_FK==241|SPECIES_FK==245|SPECIES_FK==229)]
Y <- select(Y,year=Year, SPECIES_FK=SPECIES_FK,EST_LBS)
Y <- dcast(Y,year~SPECIES_FK,fill=0)
Y <- melt(Y,measure.vars = 2:12,variable.name = "SPECIES_FK",value.name="EST_LBS")
Y$SPECIES_FK = as.numeric(as.character(Y$SPECIES_FK))
Y$Source <- "DRS"

# Merge
K <- rbind(H,Y)
Meta <- read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")
Meta <- select(Meta,SPECIES_FK,TaxonName)
K <- merge(K,Meta,by.x="SPECIES_FK",by.y="SPECIES_FK")
K <- select(K,-SPECIES_FK)

# Graph
ggplot()+geom_line(data=K,aes(x=year,y=EST_LBS,col=Source),size=1)+facet_wrap(~TaxonName,scales="free_y")

# Load the biosampling catch to compare it

M <- read.xlsx("1_OUTPUTS/Biosampling fishery description.xlsx")
M$Source <- "BIOS"
M <- select(M,TaxonName=SciName,year=Year,EST_LBS=Catch_lb, Source)


M <- rbind(K,M)


# Graph
ggplot()+geom_line(data=M,aes(x=year,y=EST_LBS,col=Source),size=1)+facet_wrap(~TaxonName,scales="free_y")













