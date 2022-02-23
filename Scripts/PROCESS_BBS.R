require(data.table); require(openxlsx); require(dplyr); options(stringsAsFactors=F)

BB      <- data.table(read.csv("DATA\\a_BB_L-W_all_DataVer202003_20200727.csv"))
BB$Year <- year(BB$sample_date) 
BB      <- select(BB,Year,species_fk,area_fk,method_fk,num_kept,LEN_MM,LBS)
BB$area_fk   <- as.character((BB$area_fk))
BB$method_fk <- as.character((BB$method_fk))

AREAS <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="AREAS"))
AREAS <- AREAS[Dataset=="BBS"]
AREAS <- select(AREAS,area_fk=Area,Area_B)

METHODS <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="METHODS"))
METHODS <- METHODS[Dataset=="BBS"]
METHODS <- select(METHODS,method_fk=Method,Method_C)

SPECIES <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="SPECIES"))
SPECIES <- select(SPECIES,species_fk=Species_FK,TaxonName,Species)

BB <- merge(BB,AREAS,by="area_fk",all.x=T)
BB <- merge(BB,METHODS,by="method_fk",all.x=T)
BB <- merge(BB,SPECIES,by="species_fk")

BB <- select(BB,Year,TaxonName,Species,Area_B,Method_C,Count=num_kept,Length_FL=LEN_MM,LBS)

BB$Dataset <- "BBS"

saveRDS(BB,file="Outputs/readyBBS_Size.rds")

