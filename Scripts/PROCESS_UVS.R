require(data.table); require(openxlsx); require(dplyr); options(stringsAsFactors=F)

#==================Load diver data============================================
load("DATA\\ALL_REA_FISH_RAW.rdata")
US <- rapply(df, as.character, classes="factor", how="replace")
US <- data.table(US)
US <- US[METHOD!="SPC"&REGION=="SAMOA"]
US <- US[METHOD!="nSPC-CCR"]
US <- US[EXCLUDE_FLAG!=-1]
US <- subset(US,select=-c(LW_A,LW_B))

US$SIZE_   <- US$SIZE_*10
US         <- subset(US,select=c("OBS_YEAR","ISLAND","DEPTH_BIN","SITE","LATITUDE","LONGITUDE","SITEVISITID","REP","METHOD","TAXONNAME","SPECIES","OBS_TYPE","COUNT","SIZE_"))                
US[DEPTH_BIN=="Shallow"]$DEPTH_BIN <- "SHALLOW"
setnames(US,1:14,c("Year","Island","Depth_bin","Site","Latitude","Longitude","SiteVisitID","Rep","Method","SciName","Species","Obs_Type","Count","Length_TL"))
US$Dataset <- "UVS"

#======Get external datasets==================================================
AREA        <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="AREAS") )
AREA        <- AREA[Dataset=="UVS"]
US          <- merge(US,AREA, by.x=c("Site","Dataset"),by.y=c("Area","Dataset"))

# Assign area and weight
US[Depth_bin=="Mid"]$Depth_bin  <- "DEEP"
US[Depth_bin=="Deep"]$Depth_bin <- "DEEP"

US$Area        <- paste(US$Area_B,"_",US$Depth_bin,sep="")
US$Area_Weight <- US$Area_Weight/2  # Divide by 2 to distribute weights equally between deep and shallow. Temporary fix. This should be improved with more accurate accounting.

# Select BMUS
US <- US[Species=="VALO"|Species=="LERU"|Species=="APVI"|Species=="LUKA"]

# Convert TL to FL using metadata file
LH <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES") )
LH <- select(LH,Species,TL_to_FL)
US <- merge(US,LH,by="Species")
US$Length_FL <- US$Length_TL*US$TL_to_FL

# Save data
US <- subset(US,select=c("Dataset","Year","Island","Area","Area_Weight","Area_A","Area_B","Area_C","Site","SiteVisitID","Rep","SciName","Species","Method","Obs_Type","Length_FL","Count"))
saveRDS(US,file="Outputs/readyUVS.rds")







