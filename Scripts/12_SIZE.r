require(data.table); require(openxlsx); require(dplyr); options(stringsAsFactors=F)

   options(scipen=999)		              # this option just forces R to never use scientific notation
   root_dir <- this.path::here(.. = 1) # establish directories using this.path

#  STEP 1: read in 4 "flatview" datafiles, followed by some basic data handling
 aint_bbs1 <- fread(paste(root_dir, "/Data/a_bbs_int_flat1.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs2 <- fread(paste(root_dir, "/Data/a_bbs_int_flat2.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs3 <- fread(paste(root_dir, "/Data/a_bbs_int_flat3.csv", sep=""), header=T, stringsAsFactors=FALSE) 			
 aint_bbs4 <- fread(paste(root_dir, "/Data/a_bbs_int_flat4.csv", sep=""), header=T, stringsAsFactors=FALSE)
 aint_bbs5 <- fread(paste(root_dir, "/Data/PICDR-113220 BB Creel Data_all_columns.csv", sep=""), header=T, stringsAsFactors=FALSE)

 aint_bbs5 <- aint_bbs5[,-62]       # drop var 62 ('COMMON_NAME') which is duplicated		

# aint_bbs4 included 2021 interviews through May. Remove these records because they are also in aint_bbs5
 aint_bbs4$YEAR        <- year(aint_bbs4$SAMPLE_DATE)
 aint_bbs4             <- aint_bbs4[YEAR < 2021]								
 aint_bbs4             <- select(aint_bbs4,-YEAR)

 BB <- rbind.data.frame(aint_bbs1, aint_bbs2, aint_bbs3, aint_bbs4, aint_bbs5) # rbind coerce variable formats in the dfs to match		

 BB$YEAR       <- year(BB$SAMPLE_DATE)
 BB            <- select(BB,YEAR,SPECIES_FK,ISLAND_NAME,AREA_FK,METHOD_FK,NUM_KEPT,LEN_MM,SIZ_LBS)
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

# Fix known species ID issues
# Assign Pristipomoides rutilans (code 243) to P. flavipinnis (code 241) (A. rutilans shares the common name "Palu-sina" with P. flavipinnis)
BB[SPECIES_FK=="243"]$SPECIES_FK <- "241"
# Change P. filamentosus (242) to P. flavipinnis (241) between 2010-2014, they both can be called "palu sina" and there is a clear absence/presence pattern for these species in these years.
BB[YEAR>=2010&YEAR<=2014&SPECIES_FK=="242"]$SPECIES_FK <- "241"
# Pre-2015, all Variola sp. identified as VAAL or VALO (code 229) in different period. Need to delete all pre-2015 size data.
BB <- BB[!(SPECIES_FK=="229"&YEAR<2015)] 

# Add metadata
BB <- merge(BB,AREAS,by="AREA_FK",all.x=T)
BB <- merge(BB,METHODS,by="METHOD_FK",all.x=T)
BB <- merge(BB,SPECIES,by="SPECIES_FK")

# Assign AREA_B N/As to islands
BB[AREA_B=="N/A"]$AREA_B <- BB[AREA_B=="N/A"]$ISLAND_NAME
BB[is.na(AREA_B)]$AREA_B <- BB[is.na(AREA_B)]$ISLAND_NAME

BB <- select(BB,YEAR,TAXONNAME,SPECIES,AREA_B,METHOD_C,COUNT=NUM_KEPT,LENGTH_FL=LEN_MM,LBS=SIZ_LBS)

BB$DATASET <- "BBS"

saveRDS(BB,file="Outputs/readyBBS_Size.rds")
