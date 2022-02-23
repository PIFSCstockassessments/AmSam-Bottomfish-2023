require(data.table); require(openxlsx); require(dplyr); options(stringsAsFactors=F)

BB      <- data.table(read.csv("DATA\\a_BB_L-W_all_DataVer202003_20200727.csv"))
BB$Year <- year(BB$sample_date) 
BB      <- select(BB,Year,SCIENTIFIC_NAME,area_fk,METHOD_NAME,LEN_MM,LBS)
BB$area_fk <- as.character((BB$area_fk))

AREAS <- data.table(read.xlsx("DATA//METADATA.xlsx",sheet="AREAS"))
AREAS <- AREAS[Dataset=="BBS"]
AREAS <- select(AREAS,area_fk=Area,Area_B)

BB <- merge(BB,AREAS,all.x=T)

saveRDS(BIO,file="Outputs/readyBBS_Size.rds")


