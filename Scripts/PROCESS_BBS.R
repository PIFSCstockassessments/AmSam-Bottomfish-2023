require(data.table); require(openxlsx); require(dplyr); options(stringsAsFactors=F)

A  <- read.csv("DATA\\a_bbs_int_flat1.csv")
B  <- read.csv("DATA\\a_bbs_int_flat2.csv")
C  <- read.csv("DATA\\a_bbs_int_flat3.csv")
D  <- read.csv("DATA\\a_bbs_int_flat4.csv")
BB <- data.table(rbind(A,B,C,D))

BB$YEAR <- year(BB$SAMPLE_DATE) 
BB      <- select(BB,YEAR,SPECIES_FK,ISLAND_NAME,AREA_FK,METHOD_FK,NUM_KEPT,LEN_MM,SIZ_LBS)
BB$AREA_FK    <- as.character((BB$AREA_FK))
BB$METHOD_FK  <- as.character((BB$METHOD_FK))
BB$LEN_MM     <- as.numeric(BB$LEN_MM)
BB$SIZ_LBS    <- as.numeric(BB$SIZ_LBS)

AREAS <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="AREAS"))
AREAS <- AREAS[Dataset=="BBS"]
AREAS <- select(AREAS,AREA_FK=Area,AREA_B=Area_B)

METHODS <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="METHODS"))
METHODS <- METHODS[Dataset=="BBS"]
METHODS <- select(METHODS,METHOD_FK=Method,METHOD_C=Method_C)

SPECIES <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="SPECIES"))
SPECIES <- select(SPECIES,SPECIES_FK=Species_FK,TAXONNAME=TaxonName,SPECIES=Species)
SPECIES$SPECIES_FK <- as.character(SPECIES$SPECIES_FK)

BB <- merge(BB,AREAS,by="AREA_FK",all.x=T)
BB <- merge(BB,METHODS,by="METHOD_FK",all.x=T)
BB <- merge(BB,SPECIES,by="SPECIES_FK")

# Assign AREA_B N/As to islands
BB[AREA_B=="N/A"]$AREA_B <- BB[AREA_B=="N/A"]$ISLAND_NAME
BB[is.na(AREA_B)]$AREA_B <- BB[is.na(AREA_B)]$ISLAND_NAME

BB <- select(BB,YEAR,TAXONNAME,SPECIES,AREA_B,METHOD_C,COUNT=NUM_KEPT,LENGTH_FL=LEN_MM,LBS=SIZ_LBS)

BB$DATASET <- "BBS"

saveRDS(BB,file="Outputs/readyBBS_Size.rds")
