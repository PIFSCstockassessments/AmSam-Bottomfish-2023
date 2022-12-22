
require(this.path); require(tidyverse);require(data.table);seed(123)

root_dir <- here(..=2)

  model_dir <- file.path(root_dir,"SS3 models","LUKA","50_Base")
  boot_dir <- file.path(model_dir,"bootstrap")
  
    # Extract MSY and SD for each bootstrap report file
  N_boot <- length(list.files(file.path(boot_dir), pattern = "data_boot", full.names = T))
  models <- SSgetoutput(keyvec = paste0("_",seq(1,N_boot)), dirvec = file.path(boot_dir), verbose = T)  
  
  Results <- list()
  for(i in 1:N_boot){
  
  aQuant <- data.table( models[[i]]$derived_quants )
  anMSY  <- data.table( aQuant[str_detect(Label,"Dead_Catch_MSY")][,2:3] )
  
  Results[[i]] <- data.table( rnorm(n=1000,mean=anMSY$Value,sd=anMSY$StdDev) )
  
  }

  MSY <- rbindlist(Results) 
  
  summary(MSY)
  hist(MSY$V1)  

  Catch.table <- quantile(MSY$V1,seq(0.1,0.5,0.01))
  Catch.table <- data.table(Percentile=names(Catch.table),MSY=Catch.table )
  
  Catch.table <- Catch.table[order(-MSY)]
 
  write.csv(Catch.table,file.path(boot_dir,"00_MSYbaseCatch.csv"),row.names=F) 
     
    
