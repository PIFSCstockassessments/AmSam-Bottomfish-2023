## Running ASPM for APRU
library(r4ss)

Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
recdev_on <- F
likelihood.checks <- stock.status <- list()
for(i in 1:length(Species.List)){
  
  species <- Species.List[i]
  ## directory of model to use
  ## make sure that the model has been run in this folder
  orig.mod.dir <- file.path(root_dir, "SS3 models", species, "65c_2CPUE_NoRecDev")
  
  
  ## aspm directory
  # model.dir <- file.path(root_dir, "SS3 models", species, "102_ASPM")
  #dir.create(model.dir)
  # copy_SS_inputs(
  #   dir.old = orig.mod.dir,
  #   dir.new = model.dir,
  #   create.dir = T,
  #   overwrite = T,
  #   recursive = T,
  #   copy_exe = T,
  #   copy_par = T
  # 
  # )
  # 
  # ## figures folders
  # fig.dir <- file.path(model.dir, "plots")
  # dir.create(fig.dir)
  # r4ss::run(model.dir, exe = "ss_opt_win")
  # 
  # 
  # if(recdev_on){
  # ## set rec devs to 0
  # pars <- SS_readpar_3.30(file.path(model.dir, "ss.par"),
  #                         datsource = file.path(model.dir, "data_echo.ss_new"),
  #                         ctlsource = file.path(model.dir, "control.ss_new"))
  # pars$recdev_early[,2] <- 0
  # pars$recdev1[,2] <- 0
  # pars$recdev_forecast[,2] <- 0
  # SS_writepar_3.30(pars, outfile = file.path(model.dir, "ss.par"))
  # }
  # 
  # starter <- SS_readstarter(file = file.path(model.dir, "starter.ss"))
  # starter$init_values_src <- 1
  # starter$datfile <- "data_echo.ss_new"
  # starter$ctlfile <- "control.ss_new"
  # SS_writestarter(starter, dir = model.dir, overwrite = TRUE)
  # 
  # SS_changepars(dir = model.dir,
  #               newctlfile = "control.ss_new",
  #               strings = c("steep", "sigmaR"),
  #               newphs = c(-4, -5))
  # 
  # # Step 7. Change control file to fix rec devs at value read from par file (change phase to negative (recdev phase =-3, recdev_early_phase = -4))
  # 
  # control <- SS_readctl(file = file.path(model.dir, "control.ss_new"),
  #                       datlist = file.path(model.dir, "data_echo.ss_new"))
  # 
  # ## turn off the likelihoods for length comps and recruitment
  # if(recdev_on){
  # 
  #   control$lambdas <- as.data.frame(rbind(
  #     c(4,1,1,0,1),
  #     c(4,2,1,0,1),
  #     c(4,3,1,0,1)
  #   ))
  # }else{
  #   control$recdev_early_phase <- -4
  #   control$recdev_phase <- -3
  #   control$lambdas <- as.data.frame(rbind(
  #     c(4,1,1,0,1),
  #     c(4,2,1,0,1),
  #     c(4,3,1,0,1),
  #     c(10,1,1,0,1)
  #   ))
  # }
  # control$N_lambdas <- nrow(control$lambdas)
  # 
  # # Manually fix the selectivity parameters by changing the phase to a negative value
  # control$size_selex_parms$PHASE <- abs(control$size_selex_parms$PHASE) * -1
  # 
  # SS_writectl_3.30(control, outfile = file.path(model.dir, "control.ss_new"), overwrite = TRUE)
  # 
  # r4ss::run(model.dir, exe = "ss_opt_win", skipfinished = F)

  report <- SS_output(orig.mod.dir)
  
  # likelihood.checks[[i]] <- report$likelihoods_by_fleet %>% filter(str_detect(Label, "Length_like"))
  # likelihood.checks[[i]]$species <- species
  
  #SS_plots(report)
  
  ssb <- report$derived_quants %>% 
    filter(str_detect(Label, "SSB_MSY|SSB_2021|SSB_Virgin")) %>% 
    select(c("Label", "Value", "StdDev")) %>% 
    mutate(run = "NoRecDev")
  
  m <- report$parameters %>% 
    filter(str_detect(rownames(.), "NatM_uniform_Fem")) %>% 
    pull(Value)

  
  stock.status.base[[i]] <- data.frame("Species" = species, 
                     "SSB" = ssb[2,2],
                     "MSY" = ssb[3,2],
                     "m" = m,
                     "SSB0" = ssb[1,2],
                     "RecDev" = ssb$run[1],
                     "Model" = "Base") %>% 
    mutate(msst = MSY * max(.5, 1-m),
           SSB.SSBMSST = SSB/msst)
  
  
}


stock.status.base <- rbindlist(stock.status.base)

stock.status %>% 
  rbindlist() %>% 
  mutate(Model = "No Length Comp") %>% 
  bind_rows(stock.status.base) %>% 
  pivot_longer(cols = c(SSB.SSBMSST, SSB0)) %>% 
  ggplot(aes(x = Species, y = value, group = Model, fill = Model)) +
  geom_col(position = "dodge") +
  geom_hline(data = . %>% filter(name == "SSB.SSBMSST"), aes(yintercept = 1), size = 1.5) +
  facet_wrap(~name, scales = "free", nrow = 2) +
  theme_classic() + 
  labs(x = "", y = "")
ggsave("Stock_Status_ASPM.png", path = file.path(root_dir, "For presentations"))

aspms.dirs <- list.dirs(file.path(root_dir, "SS3 models", species, "102_ASPM"), recursive = F)

aspm.mods <- SSgetoutput(dirvec = c(orig.mod.dir, 
                                    aspms.dirs))
aspm.sum <- SSsummarize(aspm.mods)
SSplotComparisons(aspm.sum,
                  legendlabels = c("Reference",
                                   "ASPM_norecdev",
                                   "ASPM_recdev"),
                  print = T, plotdir = file.path(root_dir, "SS3 models", species, "102_ASPM"))


aspm.mod <- SS_output(file.path(root_dir, "SS3 models", species, "102_ASPM", "2CPUE_recdevoff"))
SS_plots(aspm.mod)

aspm.mods <- SSgetoutput(dirvec = c(orig.mod.dir, 
                                    file.path(root_dir, "SS3 models", "APRU", "103a_ghostedlencomp_RecDev")))
aspm.sum <- SSsummarize(aspm.mods)
SSplotComparisons(aspm.sum,
                  legendlabels = c("Reference",
                                   
                                   "ASPM_recdev"),
                  print = T, plotdir = file.path(root_dir, "SS3 models", species, "103a_ghostedlencomp_RecDev", "plots"))
SS_plots(aspm.mods$replist2)

aspm.mods <- SS_output(file.path(root_dir, "SS3 models", "APVI", "103a_ghostedlencomp_NoRecDev"))
SS_plots(aspm.mods)



Species.List <- c("APRU","APVI","CALU","ETCO","LERU","LUKA","PRFL","PRZO","VALO")
likelihood.checks <- list()
stock.status <- list()

for(i in 3:length(Species.List)){
  
  species <- Species.List[i]
  species.mods <- SSgetoutput(dirvec = c(
    file.path(root_dir, "SS3 models", species, "65c_2CPUE_NoRecDev"),
    file.path(root_dir, "SS3 models", species, "65c_2CPUE_RecDev"),
    file.path(root_dir, "SS3 models", species, "103a_ghostedlencomp_NoRecDev"),
    file.path(root_dir, "SS3 models", species, "103a_ghostedlencomp_RecDev")
  ))
  
  mods.sum <- SSsummarize(species.mods)
  
  likelihood.checks[[i]] <- mods.sum$likelihoods %>% filter(str_detect(Label, "Length_comp"))
  likelihood.checks[[i]]$species <- species
  
  SS_plots(species.mods$replist3)
  SS_plots(species.mods$replist4)
  
  ssb <- species.mods$replist3$derived_quants %>% 
    filter(str_detect(Label, "SSB_MSY|SSB_2021")) %>% 
    select(c("Label", "Value", "StdDev")) %>% 
    mutate(run = "NoRecDev")
  
  m <- species.mods$replist3$parameters %>% 
    filter(str_detect(rownames(.), "NatM_uniform_Fem")) %>% 
    pull(Value)
  
  fmsy <- species.mods$replist3$Kobe %>% 
    filter(Yr == 2021) %>% 
    pull(F.Fmsy)
  
  df.1 <- data.frame("Species" = species, 
                     "SSB" = ssb[1,2],
                     "MSY" = ssb[2,2],
                     "m" = m,
                     "F.FMSY" = fmsy,
                     "RecDev" = ssb$run[1])
  
  ssb2 <- species.mods$replist4$derived_quants %>% 
    filter(str_detect(Label, "SSB_MSY|SSB_2021")) %>% 
    select(c("Label", "Value", "StdDev")) %>% 
    mutate(run = "RecDev")
  
  m2 <- species.mods$replist4$parameters %>% 
    filter(str_detect(rownames(.), "NatM_uniform_Fem")) %>% 
    pull(Value)
  
  fmsy2 <- species.mods$replist4$Kobe %>% 
    filter(Yr == 2021) %>% 
    pull(F.Fmsy)
  
  df.2 <- data.frame("Species" = species, 
                     "SSB" = ssb2[1,2],
                     "MSY" = ssb2[2,2],
                     "m" = m2,
                     "F.FMSY" = fmsy2,
                     "RecDev" = ssb2$run[1])
  
  stock.status[[i]] <- df.1 %>% 
    bind_rows(df.2) %>% 
    mutate(msst = MSY * max(.5, 1-m),
           SSB.SSBMSST = SSB/msst)
  
  SSplotComparisons(mods.sum, print = T, 
                    plotdir = file.path(root_dir, "SS3 models", species, "103a_ghostedlencomp_NoRecDev"),
                    legendlabels = c("Base No Rec Dev", "Base Rec Dev", "Ghosted No Rec Dev", "Ghosted Rec Dev"))
  
}


stock.status %>% 
  rbindlist() %>% 
  pivot_longer(cols = c(SSB.SSBMSST, F.FMSY)) %>% 
  ggplot(aes(x = Species, y = value, group = RecDev, fill = RecDev)) +
  geom_col(position = "dodge") +
  geom_hline(yintercept = 1)+
  facet_wrap(~name, scales = "free") +
  theme_classic() + 
  labs(x = "", y= "Stock Status")
