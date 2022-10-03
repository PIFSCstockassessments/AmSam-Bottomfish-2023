#' @param model_dir directory where bootstraps are run
#' @param N_boot number of bootstrap models to run (>= 3)
#' @param N_foreyrs number of forecast years
#' @param FixedCatchSeq Sequence of catch containing start, end, and steps of the Fixed Catch values to forecast (ex. start=0, end=1.7 mt, by=0.1)

SSForecast <- function(model_dir, N_boot, N_foreyrs, FixedCatchSeq, endyr){
  
  require(data.table); require(ggplot2); require(ggpubr); require(tidyverse); require(mgcv)
  
  fore_dir <- file.path(model_dir,"forecast")
  
  FixedCatchVec <- seq(FixedCatchSeq[1],FixedCatchSeq[2],FixedCatchSeq[3])
  N_ForeCatch   <- length(FixedCatchVec)
  
  # Directory where forecasts will be run.
  if(!exists(fore_dir)){
    dir.create(fore_dir)
  }
  
  # Delete all files in that directory
  unlink(file.path(fore_dir,"*"))
  
  # Run model one time to generate the data bootrap files
  file.copy(list.files(model_dir, pattern = "data|control|starter|forecast|.exe", full.names = T),
            to = fore_dir)
  start <- r4ss::SS_readstarter(file = file.path(fore_dir, "starter.ss"))
  start$N_bootstraps <- N_boot + 2
  r4ss::SS_writestarter(start, dir = fore_dir, overwrite = T)
  r4ss::run(dir = fore_dir, 
            exe = "ss_opt_win", extras = "-nohess",  skipfinished = FALSE, show_in_console = TRUE)
  
  message(paste0("Creating forecast data files in ", fore_dir))
  
  starter <- SS_readstarter(file =  file.path(fore_dir, "starter.ss")) # read starter file
  file.copy(file.path(fore_dir, "starter.ss"), file.path(fore_dir, "starter_backup.ss")) # make backup
  dat <- SS_readdat_3.30(file = file.path(fore_dir, "data.ss"))
  
  #create the forecast data file numbers (pad with leading 0s)
  bootn <- stringr::str_pad(seq(1, N_boot, by = 1), 3, pad = "0")
  foren <- stringr::str_pad(seq(1, N_ForeCatch, by = 1), 3, pad = "0")
  
  # loop over bootstrap files
  for (iboot in 1:N_boot) {
    
    # replace only original catch data with bootstrapped catch
    dat_boot <- SS_readdat_3.30(file = file.path(fore_dir, paste0("data_boot_", bootn[iboot], ".ss")))
    dat$catch <- dat_boot$catch
    SS_writedat_3.30(dat, outfile = file.path(fore_dir, paste0("data_boot_", bootn[iboot], ".ss")), 
                     overwrite = T)
    
    # change data file name in starter file
    starter[["datfile"]] <- paste("data_boot_", bootn[iboot], ".ss", sep = "")
    starter[["N_bootstraps"]] <- 1
    
    # replace starter file with modified version
    SS_writestarter(starter, dir = fore_dir, overwrite = TRUE)
    
       for(icatch in 1:N_ForeCatch){
       
         cat("\n##### Running forecast number", icatch, " #########\n","of ","bootstrap model number", iboot, " #########\n")
         
        # Read original forecast file
        forecast.file <- SS_readforecast(file =  file.path(fore_dir, "forecast.ss")) # read forecast file
         
        # Modify the forecast to include a new Fixed Catch to use in the projections
        forecast.file$Nforecastyrs <- N_foreyrs
        forecast.file$ForeCatch <- data.frame(Year = seq(endyr+1, endyr + N_foreyrs, by = 1),
                                                                       Season = 1, 
                                                                       Fleet = 1,
                                                                       Catch = FixedCatchVec[icatch])
        
        # replace forecast file with modified version
        SS_writeforecast(forecast.file, dir = fore_dir, overwrite = TRUE)
        
        # delete any old output files
        file.remove(file.path(fore_dir, "Report.sso"))
        file.remove(file.path(fore_dir, "CompReport.sso"))
        file.remove(file.path(fore_dir, "covar.sso"))
        
        # run model
        r4ss::run(dir = fore_dir, exe = "ss_opt_win.exe", skipfinished = F)
    
        # copy output files (might be good to use "file.exists" command first to check if they exist
        file.copy(file.path(fore_dir, "Report.sso"), paste0(fore_dir, "/Report_B",iboot,"C",icatch,".sso"))
        file.copy(file.path(fore_dir, "CompReport.sso"), paste0(fore_dir, "/CompReport_B",iboot,"C",icatch,".sso"))
        file.copy(file.path(fore_dir, "covar.sso"), paste0(fore_dir, "/covar_B",iboot,"C",icatch,".sso"))
        # other .sso files could be copied as well

       }  # End of Fixed Catch loop
  } # End of Bootstrap loop
  
  # Generate model names
  boot.names  <- paste0("B",rep(1:N_boot, each=N_ForeCatch))
  catch.names <- paste0("C",rep(1:N_ForeCatch, times=N_boot))
  model.names <- paste0(boot.names,catch.names)
  
  # Read all model files and generate a list
  models <- SSgetoutput(keyvec = paste0("_",model.names), 
                      dirvec = file.path(fore_dir), verbose = F)
  
  mvlns <- list()
  for(i in 1:length(models)){
    
    print(i)
    
    #TS          <- data.table( models[[i]]$timeseries )
    #aFixedCatch <- max( TS[Era=="FORE"]$`dead(B):_1`)
    #try(
      mvlns[[i]] <- ss3diags::SSdeltaMVLN(models[[i]], mc = 1000, 
                                        weight = 1, 
                                        run = paste0("Model ",model.names[i]), 
                                        plot = F,
                                        addprj = T)$kb
      #, silent=TRUE)
  }
  
  mv            <- data.table::rbindlist(mvlns)
  
  mv_fore             <- mv[year>endyr]
  mv_fore$Fmsy        <- mv_fore$F/mv_fore$harvest
  mv_fore$SSBmsst     <- mv_fore$SSB/mv_fore$stock*0.9 
  mv_fore$SSB_SSBmsst <- mv_fore$SSB/mv_fore$SSBmsst
  
  
  mv_fore             <- select(mv_fore,-c(type,iter,Recr))
  
  # Delete all files and save final result
  # unlink(file.path(fore_dir,"*"))
  
  saveRDS(mv_fore, file = file.path(fore_dir, "mv_projections.rds"))
  
#=================Create projection table and figures
  
  mv_fore  <- readRDS(file="SS3 models/APRU/32_TestForecast/forecast/mv_projections.rds")
  fore_dir  <- file.path(root_dir,"SS3 models","APRU","32_TestForecast","forecast")
  

  hist(mv_fore$Fmsy)
  median(mv_fore$Fmsy)
  
  hist(mv_fore$SSBmsst/0.9)
  median(mv_fore$SSB/mv_fore$stock)
  
    setnames(mv_fore,"harvest","F_Fmsy") 
  
  Z  <- mv_fore[,list(F_Fmsy=median(F_Fmsy),SSB_SSBmsst=median(SSB_SSBmsst)),by=list(year,Catch)]
  
  P1 <- ggplot(data=Z,aes(x=Catch,y=SSB_SSBmsst,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="SSB/SSBmsst")+
          theme_bw()+theme(legend.position="none")+geom_smooth(col="black",se=F,size=0.5,span=1)
  
  P2 <- ggplot(data=Z,aes(x=Catch,y=F_Fmsy,linetype=as.character(year)))+geom_point(size=0.1)+labs(x="Fixed catch (mt)",y="F/Fmsy")+
          guides(linetype=guide_legend(title="Final year"))+theme_bw()+geom_smooth(col="black",se=F,size=0.5)
  
  aLegend <- get_legend(P2)
  ggarrange(P1,P2,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
  ggsave(last_plot(),file=file.path(fore_dir,"Catch_MedianStatus.png"),height=8, width=16,units="cm")
  
  
  # Calculate number of iterations by Catch and Year...
  A <- mv_fore[,list(N_tot=.N),by=list(year,Catch)]
  
  # ...That is under overfishing
  B <- mv_fore[F_Fmsy>1,list(N_overfishing=.N),by=list(year,Catch)]
  C <- merge(A,B,by=c("year","Catch"),all.x=T)
  C[is.na(C$N_overfishing)]$N_overfishing <- 0
  C$ProbOverfishing <- C$N_overfishing/C$N_tot
  
  # ...That is overfished
  D <- mv_fore[SSB_SSBmsst<1,list(N_overfished=.N),by=list(year,Catch)]
  E <- merge(A,D,by=c("year","Catch"),all.x=T)
  E[is.na(E$N_overfished)]$N_overfished <- 0
  E$ProbOverfished <- E$N_overfished/E$N_tot
  
  P3 <- ggplot(data=C[year>=2024],aes(x=Catch,y=ProbOverfishing,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. F > Fmsy")+
         theme_bw()+theme(legend.position="none")+geom_smooth(col="black",se=F,size=0.5,span=0.5)
  
  P4 <- ggplot(data=E[year>=2024],aes(x=Catch,y=ProbOverfished,linetype=as.character(year)))+geom_point(size=0.5)+labs(x="Fixed catch (mt)",y="Prob. SSB < SSBmsst")+
         guides(linetype=guide_legend(title="Final year"))+theme_bw()+geom_smooth(col="black",se=F,size=0.5,span=0.5)
  
  aLegend <- get_legend(P4)
  ggarrange(P3,P4,ncol=2,common.legend = T,legend.grob = aLegend,legend="right")
  ggsave(last_plot(),file=file.path(fore_dir,"Catch_ProbStatus.png"),height=8, width=16,units="cm")
  
  # Catch risk table 
  G           <- select(C[ProbOverfishing<1],-N_tot,-N_overfishing)
  G$ProbBins  <- round(G$ProbOverfishing,2)
  G           <- select(G,-ProbOverfishing)
  G           <- G[,list(Catch=mean(Catch)),by=list(year,ProbBins)]
  
  # Fill in missing combinations of year x prob. overfishing with NAs
  G <- data.table( spread(G,year,Catch) )
  G <- data.table( gather(G,year,Catch,2:9) )
  
 
  G$year <- factor(G$year)
  G      <- G[ProbBins>=0.10] # Filter low overfishing prob. bins for better modeling
  
  model  <- gam(data=G,Catch~year+s(ProbBins,by=year),method="REML")
  Preds  <- predict.gam(model,newdata=G)
  
  
  G      <- cbind(G,Preds)
  G[is.na(Catch)]$Catch <- G[is.na(Catch)]$Preds
  G      <- select(G,-Preds)
  
  ggplot(data=G,aes(x=Catch,y=ProbBins,col=year))+geom_point()
  
  Final.table <- data.table( spread(G,year,Catch))
  Final.Table <- Final.Table[order(-ProbBins)]
  Final.Table <- Final.Table[ProbBins<=0.5]
  
  
  
  
  write.csv(Final.Table,file=file.path(fore_dir,"Catch_Table.csv"))
    
  
}
