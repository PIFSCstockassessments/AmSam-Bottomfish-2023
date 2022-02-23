require(data.table); require(openxlsx); require(ggplot2); require(directlabels)

# Process Biosampling data
BIO <- data.table(read.xlsx("DATA\\BIOSAMPLING.xlsx",sheet="RAW",colNames=TRUE))
#names(BIO)[1:28] <- toupper(names(BIO)[1:28])
BIO$FishedDate   <- as.Date(BIO$FishedDate,origin="1899-12-30")
BIO$Year         <- year(BIO$FishedDate)
BIO              <- subset(BIO,select=c("Year","FishedArea","FishedMethod","ScientificName","NumPieces","Length(cm)","Weight(g)"))

AREA         <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="AREAS") )
AREA         <- AREA[Dataset=="Biosampling"]
SPECIES.CODE <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
SPECIES.CODE <- subset(SPECIES.CODE,select=c("TaxonName","Species","Method1"))
METHODS      <- data.table( read.xlsx("DATA/METADATA.xlsx",sheet="METHODS") )
METHODS      <- METHODS[Dataset=="Biosampling"]

BIO$Dataset <- "Biosampling"

BIO     <- merge(BIO,AREA, by.x=c("FishedArea","Dataset"),by.y=c("Area","Dataset"))
BIO     <- merge(BIO,SPECIES.CODE,by.x="ScientificName",by.y="TaxonName")
BIO     <- merge(BIO,METHODS, by.x=c("FishedMethod","Dataset"),by.y=c("Method","Dataset"))

setnames(BIO,c("NumPieces","ScientificName","Length(cm)","Weight(g)"),c("Count","SciName","Length_FL","Weight_G"))

# Summary of biosampling fishery
META        <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet=3)  )
S           <- BIO
S$Length_FL <- S$Length_FL*10
S$Weight    <- S$LW_A*S$Length_FL^S$LW_B

S <- S[Year>=2011&Year<=2016,list(Catch=sum(Weight_G,na.rm=T)/1000),by=list(SciName,Year)]
S <- S[,list(Catch=round(mean(Catch),0)),by=list(SciName,Year)]
S <- S[order(SciName,Year)]
#write.xlsx(S,file="1_OUTPUTS/Biosampling fishery description.xlsx")

BIO <- BIO[,c("Dataset","Area_A","Area_B","Area_C","FishedArea","Year","Method_B","Method_C","Method1","SciName","Species","Length_FL")]

BIO$Length_FL <- BIO$Length_FL*10
BIO$Count  <- 1

saveRDS(BIO,file="Outputs/readyBiosamp.rds")










