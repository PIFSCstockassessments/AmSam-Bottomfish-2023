## Requests from reviewers
## Estimating Linf for APRU and ETCO

library(r4ss)
#library(ss3diags)
library(tidyverse)

### Plotting function ##############################################################################
prof.vec <- seq(70.3,96.1,by=1)
Nprofile <- length(prof.vec)
profile.str <- "L_at_Amax"
print(profile.str)


linf_profile_plot <- function(path, prof.vec, profile.str, include.MLE=T, pathMLE = NULL, base.Linf, two.sex = F){
  # read the output files (with names like Report1.sso, Report2.sso, etc.)
  Nprofile <- length(prof.vec)
  profile.dirs <- file.path(path)
  profilemodels <- SSgetoutput(dirvec = profile.dirs,
                               keyvec = 1:Nprofile, verbose = FALSE)
  # summarize output
  profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
  
  if(include.MLE){
    # OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
    MLEmodel <- SS_output(pathMLE,
                          verbose = FALSE, printstats = FALSE)
    profilemodels[["MLE"]] <- MLEmodel
    profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
    # END OPTIONAL COMMANDS
  }
  
  # plot profile using summary created above
  
  if(two.sex){
    SSplotProfile(profilesummary, # summary object
                  profile.string = paste0(profile.str, "_Fem"), # substring of profile parameter
                  profile.label = profile.str,
                  print = T,
                  plotdir = profile.dirs
    )
    SSplotProfile(profilesummary, # summary object
                  profile.string = paste0(profile.str, "_Mal"), # substring of profile parameter
                  profile.label = profile.str,
                  print = T,
                  plotdir = profile.dirs
    )
  }
  SSplotProfile(profilesummary, # summary object
                profile.string = profile.str, # substring of profile parameter
                profile.label = profile.str,
                print = T,
                plotdir = profile.dirs
  )
  
  MSY <- profilesummary$quants %>% 
    filter(str_detect(Label, "SSB_MSY")) %>% 
    select(-c(Label, Yr)) %>% 
    pivot_longer(cols = everything(),
                 values_to = "SSB_MSY") 
  M <- profilesummary$pars %>% 
    filter(str_detect(Label, "NatM")) %>% 
    select(-c(Label, Yr, recdev)) %>% 
    pivot_longer(cols = everything(), 
                 values_to = "M") 
  Linf <- profilesummary$pars %>% 
    filter(str_detect(Label, profile.str)) %>% 
    separate(Label, into = c("l",  "at", "a", "Group", "gp", "x"), sep = c("_")) %>% 
    select(-c(Yr, recdev, l, at, a, gp, x)) %>% 
    pivot_longer(cols = -Group, 
                 values_to = "Linf")
  if(include.MLE){
    mle <- profilesummary$pars %>% 
      filter(str_detect(Label, profile.str))%>% 
      pull(MLE)
    ## MSST = SSB_MSY*(1-M)
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      left_join(Linf, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = Linf, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      geom_vline(aes(xintercept = mle, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_bratio.png", path = profile.dirs)
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      left_join(Linf, by = "name") %>% 
      ggplot(aes(x = Linf, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      geom_vline(aes(xintercept = mle, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_ssb0.png", path = profile.dirs)
    
    
  }else{
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      left_join(Linf, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = Linf, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      #geom_vline(aes(xintercept = 85.7, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_bratio.png", path = profile.dirs)
    
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      left_join(Linf, by = "name") %>% 
      ggplot(aes(x = Linf, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_ssb0.png", path = profile.dirs)
    
  }
  
  if(two.sex){
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      left_join(Linf, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = Linf, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      facet_wrap(~Group) +
      #geom_vline(aes(xintercept = 85.7, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_bratio.png", path = profile.dirs)
    
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      left_join(Linf, by = "name") %>% 
      ggplot(aes(x = Linf, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.Linf, color = "Base Case"), size = 1.5) +
      facet_wrap(~Group) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "Linf_ssb0.png", path = profile.dirs)
  }
  
}


linf_profile_plot(path = file.path(root_dir, "SS3 models", "APVI", "104_Linf_est"), 
                  prof.vec = seq(70, 90, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 76.9)

linf_profile_plot(path = file.path(root_dir, "SS3 models", "LUKA", "104_Linf_est"), 
                  prof.vec = seq(19, 27, by = 0.1),
                  profile.str = "L_at_Amax",
                  include.MLE = T,
                  pathMLE = file.path(root_dir, "SS3 models", "LUKA", "104_Linf_est", "MLE"),
                  base.Linf = 24.6)

linf_profile_plot(path = file.path(root_dir, "SS3 models", "CALU", "104_Linf_est"), 
                  prof.vec = seq(60, 85, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 68.8)

linf_profile_plot(path = file.path(root_dir, "SS3 models", "PRFL", "104_Linf_est"), 
                  prof.vec = seq(37, 55, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 41.2)

linf_profile_plot(path = file.path(root_dir, "SS3 models", "LERU", "104_Linf_est"), 
                  prof.vec = seq(28,42, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 33.9)


linf_profile_plot(path = file.path(root_dir, "SS3 models", "PRZO", "104_Linf_est"), 
                  prof.vec = seq(33,50, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 36.9)


linf_profile_plot(path = file.path(root_dir, "SS3 models", "VALO", "104_Linf_est"), 
                  prof.vec = seq(42,60, by = 1),
                  profile.str = "L_at_Amax",
                  include.MLE = F,
                  base.Linf = 46.1)

### M #
M_profile_plot <- function(path, prof.vec, profile.str, include.MLE=T, pathMLE = NULL, base.M){
  # read the output files (with names like Report1.sso, Report2.sso, etc.)
  Nprofile <- length(prof.vec)
  profile.dirs <- file.path(path)
  profilemodels <- SSgetoutput(dirvec = profile.dirs,
                               keyvec = 1:Nprofile, verbose = FALSE)
  # summarize output
  profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
  
  if(include.MLE){
    # OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
    MLEmodel <- SS_output(pathMLE,
                          verbose = FALSE, printstats = FALSE)
    profilemodels[["MLE"]] <- MLEmodel
    profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
    # END OPTIONAL COMMANDS
  }
  
  # plot profile using summary created above
  SSplotProfile(profilesummary, # summary object
                profile.string = profile.str, # substring of profile parameter
                profile.label = profile.str,
                print = T,
                plotdir = profile.dirs
  )
  
  MSY <- profilesummary$quants %>% 
    filter(str_detect(Label, "SSB_MSY")) %>% 
    select(-c(Label, Yr)) %>% 
    pivot_longer(cols = everything(),
                 values_to = "SSB_MSY") 
  M <- profilesummary$pars %>% 
    filter(str_detect(Label, profile.str)) %>% 
    separate(Label, into = c("Nat",  "unif", "Group", "gp", "x"), sep = c("_")) %>% 
    select(-c(Yr, recdev, Nat, unif, gp, x)) %>% 
    pivot_longer(cols = -Group, 
                 values_to = "M")
  
  if(include.MLE){
    mle <- profilesummary$pars %>% 
      filter(str_detect(Label, profile.str))%>% 
      pull(MLE)
    ## MSST = SSB_MSY*(1-M)
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = M, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      geom_vline(aes(xintercept = mle, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_bratio.png", path = profile.dirs)
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      ggplot(aes(x = M, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      geom_vline(aes(xintercept = mle, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_ssb0.png", path = profile.dirs)
    
    
  }else{
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = M, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_bratio.png", path = profile.dirs)
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      left_join(M, by = "name") %>% 
      ggplot(aes(x = M, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_ssb0.png", path = profile.dirs)
  }
  
  if(two.sex){
    profilesummary$SpawnBio %>% 
      filter(Yr == 2021 ) %>% 
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB") %>% 
      left_join(MSY, by = "name") %>% 
      left_join(M, by = "name") %>% 
      mutate(MSST = SSB_MSY * max(0.5, 1-M),
             SSB_SSBMSST = SSB/MSST) %>%
      ggplot(aes(x = M, y = SSB_SSBMSST)) +
      geom_col() +
      geom_hline(yintercept = 1) + 
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      facet_wrap(~Group) +
      #geom_vline(aes(xintercept = 85.7, color = "MLE"), size = 1.5) +
      theme_classic() +
      labs(y = "SSB/SSBMSST") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_bratio.png", path = profile.dirs)
    
    
    profilesummary$SpawnBio %>% 
      filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
      select(-c(Label)) %>% 
      pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
      left_join(M, by = "name") %>%
      ggplot(aes(x = M, y = SSB0)) +
      geom_col() +
      geom_vline(aes(xintercept = base.M, color = "Base Case"), size = 1.5) +
      #facet_wrap(~Group) +
      theme_classic() +
      labs(y = "SSB0") +
      theme(legend.title = element_blank())
    ggsave(filename = "M_ssb0.png", path = profile.dirs)
  }
  
  
}


M_profile_plot(path = file.path(root_dir, "SS3 models", "APVI", "105_M_est"), 
                  prof.vec = seq(0.1, 0.25, by = .01),
                  profile.str = "NatM",
                  include.MLE = F,
                  base.M = 0.169)

M_profile_plot(path = file.path(root_dir, "SS3 models", "LUKA", "105_M_est"), 
                  prof.vec = seq(0.58,0.74, by = 0.01),
                  profile.str = "NatM",
                  include.MLE = T,
                  pathMLE = file.path(root_dir, "SS3 models", "LUKA", "105_M_est", "MLE"),
                  base.M = 0.675)

M_profile_plot(path = file.path(root_dir, "SS3 models", "CALU", "105_M_est"), 
                  prof.vec = seq(0.39, 0.53, by = .01),
                  profile.str = "NatM",
                  include.MLE = F,
                  pathMLE = file.path(root_dir, "SS3 models", "CALU", "105_M_est", "MLE"),
                  base.M = 0.45)

M_profile_plot(path = file.path(root_dir, "SS3 models", "PRFL", "105_M_est"), 
                  prof.vec = seq(0.05,0.25, by = 0.01),
                  profile.str = "NatM",
                  include.MLE = F,
                  base.M = 0.193)

M_profile_plot(path = file.path(root_dir, "SS3 models", "PRZO", "105_M_est"), 
               prof.vec = seq(.1,.3, by = 0.01),
               profile.str = "NatM",
               include.MLE = F,
               base.M = 0.18)


M_profile_plot(path = file.path(root_dir, "SS3 models", "LERU", "105_M_est"), 
               prof.vec = seq(.3,.5, by = 0.01),
               profile.str = "NatM",
               include.MLE = F,
               base.M = 0.36)

M_profile_plot(path = file.path(root_dir, "SS3 models", "VALO", "105_M_est"), 
               prof.vec = seq(.3,.5, by = 0.01),
               profile.str = "NatM",
               include.MLE = F,
               base.M = 0.36)

### Linf ####################################################################################################
## APRU ####
apru.base <- SS_output(dir = file.path(root_dir, "SS3 models", "APRU", "65_Base"))
apru.linf.est <- SS_output(dir = file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf"))

SS_plots(apru.linf.est)

apru.linf.sum <- SSsummarize(list(apru.base, apru.linf.est))
SSplotComparisons(apru.linf.sum, print = TRUE, plotdir = file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf", "plots", "comparisons"), legendlabels = c("Linf fixed", "Linf estimated"))


## Profile plots
## Code to plot B0 across SR0 profile
prof.vec <- seq(0.6,2,by=.2)
Nprofile <- length(prof.vec)
profile.str <- "SR_LN(R0)"
print(profile.str)
# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "SR_LN", # substring of profile parameter
              profile.label = profile.str
)


mle.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pull(MLE)

delta.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pivot_longer(cols = -Label) %>%
  mutate(delta.like = value - mle.like) %>% 
  filter(str_detect(name, "MLE", negate = T)) %>% 
  mutate(profile.vector = prof.vec)

b0 <- profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% 
  select(-c(Yr, MLE)) %>% 
  pivot_longer(cols = -c(Label))

delta.like %>% 
  left_join(b0, by = "name") %>% 
  ggplot(aes(y = value.y,x = profile.vector)) + 
  geom_point()+ 
  labs(y = "B0") +
  theme_classic()

delta.like %>% 
  left_join(b0, by = "name") %>% 
  ggplot(aes(y = delta.like,x = value.y)) + 
  geom_point()+ 
  geom_line() +
  labs(x = "SSB0", y = "Change in Likelihood") + 
  theme_classic()
ggsave(filename = "SSB0_profile.png", path = profile.dirs)

## Plot profile across Linf values
prof.vec <- seq(70.3,96.1,by=1)
Nprofile <- length(prof.vec)
profile.str <- "L_at_Amax"
print(profile.str)

# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "APRU", "100_estimateLinf"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "L_at_Amax", # substring of profile parameter
              profile.label = profile.str,
              print = T,
              plotdir = profile.dirs
)

MSY <- profilesummary$quants %>% 
  filter(str_detect(Label, "SSB_MSY")) %>% 
  select(-c(Label, Yr)) %>% 
  pivot_longer(cols = everything(),
               values_to = "SSB_MSY") 
M <- profilesummary$pars %>% 
  filter(str_detect(Label, "NatM")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "M") 
Linf <- profilesummary$pars %>% 
  filter(str_detect(Label, "L_at_Amax")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "Linf")
## MSST = SSB_MSY*(1-M)
profilesummary$SpawnBio %>% 
  filter(Yr == 2021 ) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB") %>% 
  # group_by(name) %>% 
  # summarise(mean.ssb = mean(SSB)) %>% 
  left_join(MSY, by = "name") %>% 
  left_join(M, by = "name") %>% 
  left_join(Linf, by = "name") %>% 
  mutate(MSST = SSB_MSY * (1-M),
         SSB_SSBMSST = SSB/MSST) %>%
 # filter(SSB_SSBMSST < 1)
  #separate(col = name, into = c("rep", "Run"), sep = "(?<=[a-z])(?=[0-9])") %>% 
  #mutate(Run = as.numeric(Run)) %>% 
  ggplot(aes(x = Linf, y = SSB_SSBMSST)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 83.3, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 85.7, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB/SSBMSST") +
  theme(legend.title = element_blank())
ggsave(filename = "Linf_bratio.png", path = profile.dirs)

profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
  left_join(Linf, by = "name") %>% 
  ggplot(aes(x = Linf, y = SSB0)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 83.3, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 85.7, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB0") +
  theme(legend.title = element_blank())
ggsave(filename = "Linf_ssb0.png", path = profile.dirs)
##ETCO ####
etco.base <- SS_output(dir = file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf", "Andrews"))
etco.linf.est <- SS_output(dir = file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf"))

SS_plots(etco.linf.est)

etco.linf.sum <- SSsummarize(list(etco.base, etco.linf.est))
SSplotComparisons(etco.linf.sum, print = TRUE, plotdir = file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf", "plots", "comparisons"), legendlabels = c("Linf fixed", "Linf estimated"))


## Plot profile across Linf values
prof.vec <- seq(73,99,by=1)
Nprofile <- length(prof.vec)
profile.str <- "L_at_Amax"
print(profile.str)

# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "L_at_Amax", # substring of profile parameter
              profile.label = profile.str,
              print = T,
              plotdir = profile.dirs
)

MSY <- profilesummary$quants %>% 
  filter(str_detect(Label, "SSB_MSY")) %>% 
  select(-c(Label, Yr)) %>% 
  pivot_longer(cols = everything(),
               values_to = "SSB_MSY") 
M <- profilesummary$pars %>% 
  filter(str_detect(Label, "NatM")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "M") 
Linf <- profilesummary$pars %>% 
  filter(str_detect(Label, "L_at_Amax")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "Linf")
## MSST = SSB_MSY*(1-M)
profilesummary$SpawnBio %>% 
  filter(Yr == 2021 ) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB") %>% 
  # group_by(name) %>% 
  # summarise(mean.ssb = mean(SSB)) %>% 
  left_join(MSY, by = "name") %>% 
  left_join(M, by = "name") %>% 
  left_join(Linf, by = "name") %>% 
  mutate(MSST = SSB_MSY * (1-M),
         SSB_SSBMSST = SSB/MSST) %>%
  # filter(SSB_SSBMSST < 1)
  #separate(col = name, into = c("rep", "Run"), sep = "(?<=[a-z])(?=[0-9])") %>% 
  #mutate(Run = as.numeric(Run)) %>% 
  ggplot(aes(x = Linf, y = SSB_SSBMSST)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 86.3, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 84.4, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB/SSBMSST") +
  theme(legend.title = element_blank())
ggsave(filename = "Linf_bratio.png", path = profile.dirs)

profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
  # left_join(MSY, by = "name") %>% 
  # left_join(M, by = "name") %>% 
  left_join(Linf, by = "name") %>% 
  # mutate(MSST = SSB_MSY * (1-M),
  #        SSB_SSBMSST = SSB/MSST) %>%
  ggplot(aes(x = Linf, y = SSB0)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 86.3, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 84.4, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB0") +
  theme(legend.title = element_blank())
ggsave(filename = "Linf_ssb0.png", path = profile.dirs)

## LN_R0
prof.vec <- seq(1.0,2.5,by=.1)
Nprofile <- length(prof.vec)
profile.str <- "SR_LN(R0)"
print(profile.str)
# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "ETCO", "100_estimateLinf"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "SR_LN", # substring of profile parameter
              profile.label = profile.str
)


mle.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pull(MLE)

delta.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pivot_longer(cols = -Label) %>%
  mutate(delta.like = value - mle.like) %>% 
  filter(str_detect(name, "MLE", negate = T)) %>% 
  mutate(profile.vector = prof.vec)

b0 <- profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% 
  select(-c(Yr, MLE)) %>% 
  pivot_longer(cols = -c(Label))

delta.like %>% 
  left_join(b0, by = "name") %>% 
  ggplot(aes(y = delta.like,x = value.y)) + 
  geom_point()+ 
  geom_line() +
  labs(x = "SSB0", y = "Change in Likelihood") + 
  theme_classic()
ggsave(filename = "SSB0_profile.png", path = profile.dirs)

#### M  ##################################################################################################
## APRU ####
apru.base <- SS_output(dir = file.path(root_dir, "SS3 models", "APRU", "65_Base"))
apru.M.est <- SS_output(dir = file.path(root_dir, "SS3 models", "APRU", "101_estimateM"))

SS_plots(apru.M.est)

apru.M.sum <- SSsummarize(list(apru.base, apru.M.est))
SSplotComparisons(apru.M.sum, print = TRUE, plotdir = file.path(root_dir, "SS3 models", "APRU", "101_estimateM", "plots", "comparisons"), legendlabels = c("M fixed", "M estimated"))


## Profile plots
## Code to plot B0 across SR0 profile
prof.vec <- seq(0.5,1.6,by=.1)
Nprofile <- length(prof.vec)
profile.str <- "SR_LN(R0)"
print(profile.str)
# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "APRU", "101_estimateM", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "APRU", "101_estimateM"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "SR_LN", # substring of profile parameter
              profile.label = profile.str
)


mle.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pull(MLE)

delta.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pivot_longer(cols = -Label) %>%
  mutate(delta.like = value - mle.like) %>% 
  filter(str_detect(name, "MLE", negate = T)) %>% 
  mutate(profile.vector = prof.vec)

b0 <- profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% 
  select(-c(Yr, MLE)) %>% 
  pivot_longer(cols = -c(Label))

delta.like %>% 
  left_join(b0, by = "name") %>% 
  ggplot(aes(y = delta.like,x = value.y)) + 
  geom_point()+ 
  geom_line() +
  labs(x = "SSB0", y = "Change in Likelihood") + 
  theme_classic()
ggsave(filename = "SSB0_profile.png", path = profile.dirs)

## Plot profile across M values
prof.vec <- seq(.09,.35,by=.01)
Nprofile <- length(prof.vec)
profile.str <- "NatM"
print(profile.str)

# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "APRU", "101_estimateM", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "APRU", "101_estimateM"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "NatM", # substring of profile parameter
              profile.label = profile.str,
              print = T,
              plotdir = profile.dirs
)

MSY <- profilesummary$quants %>% 
  filter(str_detect(Label, "SSB_MSY")) %>% 
  select(-c(Label, Yr)) %>% 
  pivot_longer(cols = everything(),
               values_to = "SSB_MSY") 
M <- profilesummary$pars %>% 
  filter(str_detect(Label, "NatM")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "M") 
Linf <- profilesummary$pars %>% 
  filter(str_detect(Label, "L_at_Amax")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "Linf")
## MSST = SSB_MSY*(1-M)
profilesummary$SpawnBio %>% 
  filter(Yr == 2021 ) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB") %>% 
  # group_by(name) %>% 
  # summarise(mean.ssb = mean(SSB)) %>% 
  left_join(MSY, by = "name") %>% 
  left_join(M, by = "name") %>% 
  #left_join(Linf, by = "name") %>% 
  mutate(MSST = SSB_MSY * (1-M),
         SSB_SSBMSST = SSB/MSST) %>%
  # filter(SSB_SSBMSST < 1)
  #separate(col = name, into = c("rep", "Run"), sep = "(?<=[a-z])(?=[0-9])") %>% 
  #mutate(Run = as.numeric(Run)) %>% 
  ggplot(aes(x = M, y = SSB_SSBMSST)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 0.18, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 0.16, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB/SSBMSST") +
  theme(legend.title = element_blank())
ggsave(filename = "M_bratio.png", path = profile.dirs)

profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
  left_join(M, by = "name") %>% 
  ggplot(aes(x = M, y = SSB0)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 0.18, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 0.16, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB0") +
  theme(legend.title = element_blank())
ggsave(filename = "M_ssb0.png", path = profile.dirs)
##ETCO ####
etco.base <- SS_output(dir = file.path(root_dir, "SS3 models", "ETCO", "65_Base"))
etco.M.est <- SS_output(dir = file.path(root_dir, "SS3 models", "ETCO", "101_estimateM"))

SS_plots(etco.M.est)

etco.M.sum <- SSsummarize(list(etco.base, etco.M.est))
SSplotComparisons(etco.M.sum, print = TRUE, plotdir = file.path(root_dir, "SS3 models", "ETCO", "101_estimateM", "plots", "comparisons"), legendlabels = c("M fixed", "M estimated"))


## Plot profile across M values
prof.vec <- seq(.076,.12,by=0.002)
Nprofile <- length(prof.vec)
profile.str <- "NatM"
print(profile.str)

# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "ETCO", "101_estimateM", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "ETCO", "101_estimateM"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "NatM_uniform_Fem_GP_1", # substring of profile parameter
              profile.label = profile.str,
              print = T,
              plotdir = profile.dirs
)

MSY <- profilesummary$quants %>% 
  filter(str_detect(Label, "SSB_MSY")) %>% 
  select(-c(Label, Yr)) %>% 
  pivot_longer(cols = everything(),
               values_to = "SSB_MSY") 
M <- profilesummary$pars %>% 
  filter(str_detect(Label, "NatM_uniform_Fem")) %>% 
  select(-c(Label, Yr, recdev)) %>% 
  pivot_longer(cols = everything(), 
               values_to = "M") 

## MSST = SSB_MSY*(1-M)
profilesummary$SpawnBio %>% 
  filter(Yr == 2021 ) %>% 
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB") %>% 
  left_join(MSY, by = "name") %>% 
  left_join(M, by = "name") %>% 
  mutate(MSST = SSB_MSY * (1-M),
         SSB_SSBMSST = SSB/MSST) %>%
  ggplot(aes(x = M, y = SSB_SSBMSST)) +
  geom_col() +
  geom_hline(yintercept = 1) + 
  geom_vline(aes(xintercept = 0.098, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 0.211471, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB/SSBMSST") +
  theme(legend.title = element_blank())
ggsave(filename = "M_bratio.png", path = profile.dirs)

profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% #> 2016 & Yr < 2022
  select(-c(Label)) %>% 
  pivot_longer(cols = -Yr, values_to = "SSB0") %>% 
  left_join(M, by = "name") %>% 
  ggplot(aes(x = M, y = SSB0)) +
  geom_col() +
  geom_vline(aes(xintercept = 0.098, color = "Base Case"), size = 1.5) +
  geom_vline(aes(xintercept = 0.211471, color = "MLE"), size = 1.5) +
  theme_classic() +
  labs(y = "SSB0") +
  theme(legend.title = element_blank())
ggsave(filename = "M_ssb0.png", path = profile.dirs)

## LN_R0
prof.vec <- seq(0.2,1.6,by=.1)
Nprofile <- length(prof.vec)
profile.str <- "SR_LN(R0)"
print(profile.str)
# read the output files (with names like Report1.sso, Report2.sso, etc.)
profile.dirs <- file.path(root_dir, "SS3 models", "ETCO", "101_estimateM", paste0(profile.str, "_profile"))
profilemodels <- SSgetoutput(dirvec = profile.dirs,
                             keyvec = 1:Nprofile, verbose = FALSE)
# summarize output
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output(file.path(root_dir, "SS3 models", "ETCO", "101_estimateM"),
                      verbose = FALSE, printstats = FALSE)
profilemodels[["MLE"]] <- MLEmodel
profilesummary <- SSsummarize(profilemodels, verbose = FALSE)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary, # summary object
              profile.string = "SR_LN", # substring of profile parameter
              profile.label = profile.str
)


mle.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pull(MLE)

delta.like <- profilesummary$likelihoods %>% 
  filter(str_detect(Label, "TOTAL")) %>% 
  pivot_longer(cols = -Label) %>%
  mutate(delta.like = value - mle.like) %>% 
  filter(str_detect(name, "MLE", negate = T)) %>% 
  mutate(profile.vector = prof.vec)

b0 <- profilesummary$SpawnBio %>% 
  filter(str_detect(Label, "SSB_Virgin")) %>% 
  select(-c(Yr, MLE)) %>% 
  pivot_longer(cols = -c(Label))

delta.like %>% 
  left_join(b0, by = "name") %>% 
  ggplot(aes(y = delta.like,x = value.y)) + 
  geom_point()+ 
  geom_line() +
  labs(x = "SSB0", y = "Change in Likelihood") + 
  theme_classic()
ggsave(filename = "SSB0_profile.png", path = profile.dirs)
