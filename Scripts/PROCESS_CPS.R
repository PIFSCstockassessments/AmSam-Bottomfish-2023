require(data.table); require(openxlsx); require(ggplot2); require(directlabels); require(dplyr)


# Read data (head and detail)
DETAIL <- data.table(read.csv("DATA\\a_ccl_detail.csv"))
HEAD   <- data.table(read.csv("DATA\\a_ccl_head.csv"))

Z <- merge(DETAIL,HEAD,by.x="INVOICE_FK",by.y="INVOICE_PK")

Z <- Z[RESALE_F==F & IMPORTED_F==F] # Filter resales and imported fish

Z$DATE <- as.Date(Z$INVOICE_DATE,origin="1899-12-30")
Z$YEAR <- year(Z$DATE)
Z      <- subset(Z,select=c("YEAR","SPECIES_FK","SOLD_LBS","NUM_PIECES","ISLAND_FK","AREA_FK","METHOD_FK"))
setnames(Z,1:7,c("Year","Species_FK","LBS","Num_Pieces","Island_FK","Area_FK","Method_FK"))
Z$Area_FK   <- as.character(Z$Area_FK)
Z$Method_FK <- as.character(Z$Method_FK)




codes <- read.csv("DATA\\AmSam_BBS-SBS_GroupKey_final.csv")
test <- merge(Z,codes,by.x="Species_FK",by.y="SPECIES_PK")



AREA         <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="AREAS") )
AREA         <- AREA[Dataset=="BBS"]
SPECIES.CODE <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
SPECIES.CODE <- subset(SPECIES.CODE,select=c("TaxonName","Species","Species_FK","Method1"))
METHODS      <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="METHODS") )
METHODS      <- METHODS[Dataset=="BBS"]

Z[Species_FK==243]$Species_FK <- 247 # Change Pristipomoides rutilans to Aphareus rutilans species code 

Z     <- merge(Z,AREA, by.x="Area_FK",by.y="Area",all.x=T)
Z     <- merge(Z,SPECIES.CODE,by.x="Species_FK",by.y="Species_FK")
Z     <- merge(Z,METHODS, by.x="Method_FK",by.y="Method",all.x=T)

Z <- select(Z,Year,Area_A,Area_B,Area_C,SciName=TaxonName,Species,Method_A,Method_B,Method_C,Method1,Num_Pieces,LBS)

Z$Kg <- Z$LBS*0.453592
Z$LBS <- NULL

saveRDS(Z,file="DATA/readyDRS.rds")


