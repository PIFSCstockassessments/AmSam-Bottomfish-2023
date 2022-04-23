require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx);  require(dplyr);require(stringr)

#require(ggpmisc);

source("LOAD_Theme.r")
aTheme <- theme_datareport_bar()+theme(panel.grid.major.y = element_blank(),
                                       axis.line = element_line(color="black"),
                                       plot.margin = margin(10, 0, 6, 0),
                                       axis.text.x= element_text(margin = margin(t = 2, r = 0, b = 0, l = 0)))

Z        <- readRDS("DATA\\readyDRS_FULL.rds")
Z$Period <- "All_Years" 
#Z$Period <- Z$Year-(Z$Year%%10) 

Z$SCIENTIFIC_NAME2 <- paste0(Z$GENUS," ",Z$SCIENTIFIC_NAME)
Z[Species_FK==109] <- 110 # Merge Trevallies and Jacks (note: Trevally code isn't even used in this dataset)


# Establish list of taxonomic groups (groups that are only composed of species)
Group.listA <- c("Jacks_110","Prist_Etelis_240","Emporers_260","Inshore_groupers_380","Inshore_snappers_390")

# 2nd tier list (groups that are composed of species and one of the subgroups in listA)
Group.listB <- c("Groupers_210","Deep_snappers_230")

# 3rd tier list (group that is composed of species and all of the subgroups above)
Group.listC <- c("Bottomfishes_200")


# Calculate species proportion for all groups that only contain species
ResultsA <- list()
for(i in 1:length(Group.listA)){

   aGroup      <- Group.listA[i];   aSpecies_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
    
   Total.Sp      <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(LBS=sum(LBS)),by=list(Species_FK,Period)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(TOTAL=sum(LBS)),by=list(Period)] # Total of identified catch in group

   # Calculate proportion of each species composing group by period
   Prop        <- merge(Total.Sp,Total.Overall,by="Period")
   Prop$Prop   <- Prop$LBS/Prop$TOTAL 
   
   Prop$Group_FK <- aSpecies_FK
   Prop          <- select(Prop,Group_FK,Period,Species_FK,Prop)
   ResultsA[[i]] <- Prop
}

# Put prop dataset together
FinalA <- ResultsA[[1]]
for(i in 2:length(Group.listA)){
   FinalA <- rbind(FinalA,ResultsA[[i]])
}

# Calculate species proportion for groups that contain 1 subgroup
ResultsB <- list()
for(i in 1:length(Group.listB)){
   
   aGroup      <- Group.listB[i];   aSpecies_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(LBS=sum(LBS)),by=list(Species_FK,Period)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(TOTAL=sum(LBS)),by=list(Period)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by period
   Prop        <- merge(Total.Sp,Total.Overall,by="Period")
   Prop$Prop   <- Prop$LBS/Prop$TOTAL 
   Prop        <- select(Prop,-LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalA,by.x=c("Species_FK","Period"),by.y=c("Group_FK","Period"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(Species_FK.y)]$Species_FK <- Prop[!is.na(Species_FK.y)]$Species_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(Species_FK,Period)]
   
   Prop$Group_FK <- aSpecies_FK
   Prop          <- select(Prop,Group_FK,Period,Species_FK,Prop)
   Prop          <- Prop[order(Period,Species_FK)]
   ResultsB[[i]] <- Prop
}

# Put prop dataset together
FinalB <- ResultsB[[1]]
for(i in 2:length(Group.listB)){
   FinalB <- rbind(FinalB,ResultsB[[i]])
}

FinalB <- rbind(FinalA, FinalB)

# Calculate species proportion for final group that contains all subgroups (bottomfish)
ResultsC <- list()
for(i in 1:length(Group.listC)){
   
   aGroup      <- Group.listC[i];   aSpecies_FK <- as.numeric(str_sub(aGroup,-3,-1)) 
   
   Total.Sp      <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(LBS=sum(LBS)),by=list(Species_FK,Period)] # Catch by species by year
   Total.Overall <- Z[get(aGroup)==1&Species_FK!=aSpecies_FK,list(TOTAL=sum(LBS)),by=list(Period)] # Total of identified catch in group
   
   # Calculate proportion of each species composing group by period
   Prop        <- merge(Total.Sp,Total.Overall,by="Period")
   Prop$Prop   <- Prop$LBS/Prop$TOTAL 
   Prop        <- select(Prop,-LBS,-TOTAL)
   
   # Breakdown subgroup into species, based on FinalA table
   Prop      <- merge(Prop,FinalB,by.x=c("Species_FK","Period"),by.y=c("Group_FK","Period"),all.x=T)
   Prop$Prop <- Prop$Prop.x*Prop$Prop.y
   
   # Clean up
   Prop[!is.na(Species_FK.y)]$Species_FK <- Prop[!is.na(Species_FK.y)]$Species_FK.y
   Prop[is.na(Prop)]$Prop                <- Prop[is.na(Prop)]$Prop.x
   Prop <- Prop[,list(Prop=sum(Prop)),by=list(Species_FK,Period)]
   
   Prop$Group_FK <- aSpecies_FK
   Prop          <- select(Prop,Group_FK,Period,Species_FK,Prop)
   Prop          <- Prop[order(Period,Species_FK)]
   ResultsC[[i]] <- Prop
}

# Put prop dataset together
Final <- rbind(FinalB,ResultsC[[1]])
Final <- Final[,list(Prop=sum(Prop)),by=list(Group_FK,Period,Species_FK)]


# Use the species proportion information calculated above to split group catch into species components
Z <- select(Z,Species_FK,Year,Period,LBS)

X <- Z[Species_FK==109|Species_FK==110|Species_FK==200|Species_FK==210|Species_FK==230|Species_FK==240|Species_FK==260|Species_FK==380|Species_FK==390]

X <- merge(X,Final,by.x=c("Species_FK","Period"),by.y=c("Group_FK","Period"),allow.cartesian=T)
X$Species_FK <- X$Species_FK.y
X$LBS        <- X$LBS*X$Prop
X <- select(X,Species_FK,Year,LBS)
X$Source <- "Group-level"

Y <- select(Z,-Period )
Y <- Y[Species_FK!=109&Species_FK!=110&Species_FK!=200&Species_FK!=210&Species_FK!=230&Species_FK!=240&Species_FK!=260&Species_FK!=380&Species_FK!=390]
Y$Source <- "Species-level"

X <- rbind(X,Y)

# Select species and plot
#T <- S[SCIENTIFIC_NAME2=="Aprion virescens"]

# Check for all BMUS
T <- X[Species_FK==247|Species_FK==239|Species_FK==111|Species_FK==249|
         Species_FK==248|Species_FK==267|Species_FK==231|Species_FK==242|
         Species_FK==241|Species_FK==245|Species_FK==229,
       list(LBS=sum(LBS)),by=list(Year,Source)]

ggplot()+geom_area(data=T,aes(x=Year,y=LBS,fill=Source),size=1)+theme_bw()

ggplot()+geom_line(data=T,aes(x=Year,y=LBS,col=Source),size=1)+ylab("Catch (lb)")+theme_bw()

T[,list(LBS=sum(LBS)),by=list(Source)]

279324/(279324+64658)


# Load expanded BBS catch for comparison

D        <- data.table(  read.csv(file="DATA/BBS expanded catch.csv",stringsAsFactors=FALSE) )
#B        <- D[Zone=="Tutuila",list(LBS=sum(Landings)),by=list(Year)]
B        <- D[,list(LBS=sum(Landings)),by=list(Year)]
B$Source <- "BBS"

F <- rbind(T,B)

A <- T[,list(LBS=sum(LBS)),by=list(Year)]
A$Source <- "Group+Species-level"

A <- rbind(A,B)


ggplot()+geom_line(data=F,aes(x=Year,y=LBS,col=Source),size=2)+theme_bw()
ggplot()+geom_line(data=A,aes(x=Year,y=LBS,col=Source),size=1)+ylab("Catch (lb)")+xlim(c(1990,2019))+
   scale_color_hue(labels = c("Total catch (BBS)", "Commercial catch (DRS)"))+theme_bw()


A[Year>=1990&Year<=2020,list(LBS=mean(LBS)),by=list(Source)]

14367/15392

11096/14823



# Species specific comparisons (BBS)

H <- data.table(  read.csv(file="DATA/bbs_landings_breakdown_sp.csv",stringsAsFactors=FALSE) )
H <- H[zone=="Tutuila"&type=="sm_break",list(LBS=sum(LBS_CAUGHT)),by=list(year,SPECIES_FK)]

# Fill implied zeroes
H <- dcast(H,year~SPECIES_FK,fill=0)
H <- melt(H,measure.vars = 2:12,variable.name = "SPECIES_FK",value.name="LBS")
H$SPECIES_FK = as.numeric(as.character(H$SPECIES_FK))
H$Source <- "BBS"

# Species specific comparisons (DRS)
Y <- X[Source=="Species-level"&(Species_FK==247|Species_FK==239|Species_FK==111|Species_FK==249|
                                   Species_FK==248|Species_FK==267|Species_FK==231|Species_FK==242|
                                   Species_FK==241|Species_FK==245|Species_FK==229)]
Y <- select(Y,year=Year, SPECIES_FK=Species_FK,LBS)
Y <- dcast(Y,year~SPECIES_FK,fill=0)
Y <- melt(Y,measure.vars = 2:12,variable.name = "SPECIES_FK",value.name="LBS")
Y$SPECIES_FK = as.numeric(as.character(Y$SPECIES_FK))
Y$Source <- "DRS"

# Merge
K <- rbind(H,Y)
Meta <- read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")
Meta <- select(Meta,Species_FK,TaxonName)
K <- merge(K,Meta,by.x="SPECIES_FK",by.y="Species_FK")
K <- select(K,-SPECIES_FK)

# Graph
ggplot()+geom_line(data=K,aes(x=year,y=LBS,col=Source),size=1)+facet_wrap(~TaxonName,scales="free_y")

# Load the biosampling catch to compare it

M <- read.xlsx("1_OUTPUTS/Biosampling fishery description.xlsx")
M$Source <- "BIOS"
M <- select(M,TaxonName=SciName,year=Year,LBS=Catch_lb, Source)


M <- rbind(K,M)


# Graph
ggplot()+geom_line(data=M,aes(x=year,y=LBS,col=Source),size=1)+facet_wrap(~TaxonName,scales="free_y")













