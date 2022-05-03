require(dplyr); require(this.path); require(data.table);  require(openxlsx); require(ggplot2)


root_dir <- this.path::here(..=1)

A <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_BBS_A.rds")) # Boat-based catch
B <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_SBS_A.rds")) # Shore-based catch

S <- read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")
S$SPECIES_PK <- paste0("S",S$SPECIES_PK)
S <- select(S,SPECIES_FK=SPECIES_PK,SPECIES)

# Load historic data from Excel document
D <- data.table()
Species.list <- c("APRU","APVI","CALU","ETCA","ETCO","LERU","LUKA","PRFI","PRFL","PRZO","VALO")
for(i in 1:length(Species.list)){
 
   aSp <- Species.list[i]
   C <- data.table(   read.xlsx(paste0(root_dir,"/Data/Landings_Historic_1967_1985.xlsx"),sheet=aSp)  ); C <- select(C,1:4)
   C$SPECIES <- aSp
   D <- rbind(C,D)   
}

D$SOURCE     <- "Historic"
D$SD.LBS     <- 0
D            <- merge(D,S,by="SPECIES")
D            <- select(D,SOURCE,SPECIES_FK,YEAR=Year,AREA_C=Area,LBS=lbs,SD.LBS)

# Put all catches together
E <- rbind(A,B,D)
E <- merge(E,S,by="SPECIES_FK")

ggplot(data=E,aes(x=YEAR,y=LBS,fill=AREA_C))+geom_bar(stat="identity",position="stack")+facet_wrap(~SPECIES,scales="free_y")

F <- E[YEAR>=1986,list(LBS=sum(LBS)),by=list(SPECIES,YEAR)]
F <- F[order(SPECIES,YEAR)]
write.xlsx(F,"MarcCatch.xlsx")
