require(dplyr); require(this.path); require(data.table);  require(openxlsx); require(ggplot2)
options(scipen=999)		

root_dir <- this.path::here(..=1)

A <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_BBS_A.rds")) # Boat-based catch
B <- readRDS(paste0(root_dir,"\\Outputs\\CATCH_SBS_A.rds")) # Shore-based catch

S <- read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS")
S$SPECIES_PK <- paste0("S",S$SPECIES_PK)
S <- select(S,SPECIES_FK=SPECIES_PK,SPECIES,SCIENTIFIC_NAME)

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



# Save final catch file
Z <- E[,list(LBS=round(sum(LBS),0)),by=list(SPECIES,YEAR)]
Z <- Z[order(SPECIES,YEAR)]
saveRDS(Z,paste0(root_dir,"/Outputs/CATCH_Final.rds"))



# Compare this catch to Erin's original scripts
 F <- E[YEAR>=1986,list(LBS=sum(LBS)),by=list(SPECIES,YEAR)]
 F <- F[order(SPECIES,YEAR)]
 
 ER <- readRDS(paste0(root_dir,"/Outputs/ErinCatch.rds"))
 ER <- merge(ER,S,by="SCIENTIFIC_NAME")
 ER <- select(ER,SPECIES,YEAR,LBS)
 ER$SOURCE<- "Erin"
 F$SOURCE <- "Marc"
# 
 G <- data.table( rbind(ER,F) )
# 
 TOT <- G[,list(LBS=round(sum(LBS),0)),by=list(YEAR,SOURCE)]
 TOT <- dcast(TOT,YEAR~SOURCE,value.var="LBS")
# 
# 
 ggplot(data=G,aes(x=YEAR,y=LBS,col=SOURCE))+geom_line()+facet_wrap(~SPECIES,scales="free_y")
 ggplot(data=TOT,aes(x=YEAR))+geom_line(aes(y=Marc),col="blue")+geom_line(aes(y=Erin),col="red")+geom_text(aes(y=Marc,label=Marc), position=position_dodge(width=0.9), vjust=-0.25)
 ggplot(data=TOT,aes(x=YEAR,y=Marc))+geom_bar(stat="identity",col="black")+ylab("LBS")+geom_text(aes(label=Marc), position=position_dodge(width=0.9), vjust=-0.25)



