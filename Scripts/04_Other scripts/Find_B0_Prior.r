require(r4ss); require(this.path); require(tidyverse); require(data.table); options(scipen=999)

# For this code to run, you need to expand a CPUE fleet for the entire time series, to get Vuln_bio for all years (with lambda set to zero)

Sp <- "PRFL"

dir <- file.path(this.path::here(.. = 2), "SS3 models",Sp,"200_Base")


MinExp <- 0.02
MaxExp <- 0.6


R0_seq <- seq(0.1,1.5,by =0.05)


profile <- r4ss::profile(
  dir = dir, 
  exe = "ss_opt_win",
  oldctlfile = "control.ss",
  newctlfile = "control_modified.ss",
  string = "SR_LN",
  extras="-nohess",
  profilevec = R0_seq )


for(i in 1:length(R0_seq)){
  
  ReportName <- paste0("Report",i,".sso")
  Compfile   <- paste0("CompReport",i,".sso")
  report <- r4ss::SS_output(dir,verbose = FALSE, printstats = FALSE,repfile=ReportName,compfile=Compfile)

  Catch <- report$catch
  Cpue  <- report$cpue
  D     <- merge(Catch,Cpue,by="Yr")    
  D     <- D %>% select(Yr,Catch=Obs.x,Vuln_bio) %>% mutate(EXP=round(Catch/Vuln_bio,4)) %>% as.data.table()
  aMaxExp <- max(D[EXP<1&Yr<=1990]$EXP)
  
  Pars     <- report$parameters
  DerQuant <- report$derived_quants
  LNR0 <- Pars[str_detect(Pars$Label,"SR_LN"),]$Value
  SSB0 <- DerQuant[str_detect(DerQuant$Label,"SSB_Virgin"),]$Value
  
  
  print(paste0("The max exploitation is: ",aMaxExp," for LnR0 of ",LNR0," and the SSB0 is ",SSB0))
  
  if(aMaxExp>=MaxExp-0.10&aMaxExp<=MaxExp+0.10){
    print(paste("The LNR0 with 50% exploitation: ",LNR0," and the SSB0 is ",SSB0))
    print(" ")
  }
  
  if(aMaxExp>=(MinExp-0.001)&aMaxExp<=(MinExp+0.001)){
    print(paste("The LNR0 with 1% exploitation: ",LNR0," and the SSB0 is ",SSB0))
    print(" ")
  }
  
}


