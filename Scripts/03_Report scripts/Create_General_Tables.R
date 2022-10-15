Create_General_Tables <- function(root_dir){
  
  # Tables for all species to be inserted in the general section of the report
  
  Out_dir <- file.path(root_dir,"Outputs","Summary")
  
  dir.create(Out_dir,recursive=T,showWarnings=F)
  
  
  C.List  <- list()
  CP.List <- list() 
  for(s in 1:9){
    
    Sp <- Species.List[s]
    
    C <- Raw.C[SPECIES==Sp]  
    C <- select(C,-SPECIES)
    
    # Catch table
    
    C$MT       <- round(C$MT,3)
    C$LOGSD.MT <- round(C$LOGSD.MT,2)
    
    Ca <- C[YEAR<=1980]
    Cb <- C[YEAR>1980&YEAR<=1994]
    Cc <- C[YEAR>1994&YEAR<=2008]
    Cd <- C[YEAR>2008]
    
    C.all <- cbind(Ca,Cb,Cc,Cd) 
    C.all[14,10:12] <- NA
    C.all$SP <- Sp
    C.all <- C.all[,c(13,1:12)]
    
    C.List[[Sp]] <- C.all
    
    # CPUE table
    CP <- fread(file.path(root_dir,"Outputs","SS3_Inputs","CPUE", paste0("CPUE_",Sp,"_Tutuila.csv")))
    
    CP$SPECIES <- Sp
    CP$CPUE_TOT       <- round(CP$CPUE_TOT,3)
    CP$LOGSD.CPUE_TOT <- round(CP$LOGSD.CPUE_TOT,2)
    
    CP <- CP[,c(4,1:3)]
    
    CP.List[[Sp]] <- CP
    
  }
  
  C.Final  <- rbindlist(C.List)
  CP.Final <- rbindlist(CP.List)
  
  colnames(C.Final) <- c("Sp","Yr","MT","CV","Yr","MT","CV","Yr","MT","CV","Yr","MT","CV")
  
  # Add tables to excel worksheet
  File.Name <- file.path(root_dir,"Outputs","Summary","Catch_CPUE_Report_tables.xlsx")
  wb        <- tryCatch({loadWorkbook(File.Name)}, error=function(e){createWorkbook(File.Name)})
  Sheets    <- c("Catch","CPUE")
  
  for(i in 1:2){
    if(Sheets[i] %in% sheets(wb)) removeWorksheet(wb,Sheets[i]) # Remove sheets if there already
    addWorksheet(wb, sheetName = Sheets[i])
  }
  
  writeData(wb, sheet = Sheets[1], C.Final,colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)
  
  writeData(wb, sheet = Sheets[2], CP.Final,colNames=T)
  setColWidths(wb,widths="auto",sheet=Sheets[i],cols=1:15)
  
  saveWorkbook(wb,File.Name,overwrite = T)


}