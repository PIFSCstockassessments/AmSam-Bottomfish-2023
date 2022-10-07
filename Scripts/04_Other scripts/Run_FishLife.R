#require(devtools)
#devtools::install_github("james-thorson/FishLife")
#vignette("tutorial","FishLife")


require(FishLife); require(openxlsx); require(this.path); require(data.table); require(dplyr); require(stringr)
root_dir <- this.path::here(..=2)
dir.create(paste0(root_dir,"/Outputs"),recursive=T,showWarnings=F)

S <- data.table( read.xlsx(paste0(root_dir,"/Data/METADATA.xlsx"),sheet="BMUS") )
S <- select(S,SPECIES,SCIENTIFIC_NAME)
S1<- str_split(S$SCIENTIFIC_NAME," ",simplify=T)
S <- cbind(S,S1)
setnames(S,c("V1","V2"),c("GENUS","SP"))

S$STEEPNESS <- 0
S$SIGMA_R   <- 0
for(i in 1:nrow(S)){

  Predict = Plot_taxa( Search_species(Genus=S[i]$GENUS,Species=S[i]$SP)$match_taxonomy, mfrow=c(2,2) )
  
  S[i]$STEEPNESS <- Predict[[1]]$Mean_pred[13]
  S[i]$SIGMA_R   <- exp(Predict[[1]]$Mean_pred[12])

}

write.csv(S,paste0(root_dir,"/Outputs/FishLife_RecPars.csv")) 
  