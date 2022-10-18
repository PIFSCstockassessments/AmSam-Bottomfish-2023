## Understanding forecast.ss file and functionality 

require(pacman); pacman::p_load(boot,data.table,ggfortify,grid,gridExtra,directlabels,mgcv,ncdf4,
                                httr,lubridate,lunar,purrr,googledrive,googlesheets4,RColorBrewer,
                                tidyverse,this.path,viridis,r4ss,nFactors,openxlsx,gt,quarto)
library(ghibli)

species.dir <- file.path(root_dir, "SS3 models", "APRU", "forecasting")

##create forecast directory
build_all_ss(species       = "APRU",
             file_dir      = "nobootstrap_test",
             EST_option    = "Normal",
             SR_option     = "FishLife",
             M_option      = "SW_Then",
             GROWTH_option = "SW_BBS",
             LW_option     = "Kamikawa",
             MAT_option    = "SW_BBS",
             scenario      = "base",
             initF         = F,
             write_files   = T,
             startyr       = 1967,
             endyr         = 2021,
             fleets        = 1,
             runmodels     = TRUE,
             ext_args      = NA, # "-nohess",
             do_retro      = F,
             retro_years   = 0:-3,
             do_profile    = F,
             profile       = "SR_LN(R0)",
             profile.vec   = seq(0.2,1.6, .2),
             do_jitter     = F,
             Njitter       = 20,
             jitterFraction = 0.1,
             printreport   = F,
             r4ssplots     = F,
             lambdas = FALSE,includeCPUE = TRUE,
             superyear = TRUE, superyear_blocks = list(c(2019, 2020)),
             init_values = 0,parmtrace = 0,N_boot = 0,last_est_phs = 10,
             seed = 0123, F_report_basis = 2,
             benchmarks = 1, MSY = 2, SPR.target = 0.4, Btarget = 0.3,
             Bmark_years = c(0,0,0,0,0,0,0,0,0,0),
             Bmark_relF_Basis = 1, Forecast = 2, Nforeyrs = 5, Fcast_years = c(0,0,0,0,-999,0),
             ControlRule = 0, Fixed_forecatch = 0.5,
             root_dir = this.path::here(.. = 2),
             template_dir = file.path(this.path::here(.. = 2), "SS3 models", "TEMPLATE_FILES"), 
             out_dir = file.path(this.path::here(.. = 2), "SS3 models"))


fcast_methods <- SSgetoutput(dir = list.files(paste0(species.dir, "/forecasting/forecast_methods"), full.names = T))
fcast_methods_sum <- SSsummarize(fcast_methods)
SSplotComparisons(fcast_methods_sum)

fcast_methods_sum$Bratio %>% 
  rename(
    "method2_med" = "replist1",
    "method3_med" = "replist2",
    "method4_med" = "replist3",
    "method5_med" = "replist4"
         ) %>% 
  left_join(fcast_methods_sum$BratioLower, by = c("Yr", "Label")) %>% 
  rename(
    "method2_lower" = "replist1",
    "method3_lower" = "replist2",
    "method4_lower" = "replist3",
    "method5_lower" = "replist4"
  ) %>% 
  left_join(fcast_methods_sum$BratioUpper, by = c("Yr", "Label")) %>% 
  rename(
    "method2_upper" = "replist1",
    "method3_upper" = "replist2",
    "method4_upper" = "replist3",
    "method5_upper" = "replist4"
  ) %>% 
  pivot_longer(cols = c(contains("method"))) %>% 
  separate(name, into = c("method", "type"), sep = "_") %>% 
  separate(method, into = c("x", "Method"), sep = "thod") %>% 
  select(-c(x, Label)) %>% 
  pivot_wider(names_from = type, values_from = value) %>% 
  mutate(Method = recode_factor(Method, '2' = "FMSY", '3' = "Fbtarg", '4' = "Mean_F", '5' = "0.5F")) %>% 
  ggplot(aes(x = Yr, group = Method, color = Method)) +
  geom_ribbon(aes(x = Yr, ymin = lower, ymax = upper, fill = Method), alpha = .5) +
  geom_line(aes(y = med), size = 1.1) +
  theme_classic() +
  scale_color_ghibli_d("MarnieMedium1", direction = -1) +
  scale_fill_ghibli_d("MarnieMedium1", direction = -1) +
  labs(x = "Year", y = "Bratio")
ggsave(filename = file.path(species.dir, "forecasting/forecast_methods/bratio_ts.png"))
  
library(purrr)
fcast_methods %>% 
  map("timeseries") %>% 
  rbindlist(idcol = "Fmethod") %>% 
  mutate(Fmethod = recode(Fmethod, "replist1" = "FMSY",
                                   "replist2" = "Fbtarg",
                                   "replist3" =  "Mean_F",
                                   "replist4" = "0.5F")) %>%
  rename("catch" = "dead(B):_1") %>% 
  ggplot(aes(x = Yr, y = catch, group = Fmethod, color = Fmethod)) + 
  geom_line(size = 1.1) +
  scale_color_ghibli_d("MarnieMedium1", direction = -1) +
  theme_classic()
  

fcast_methods_sum$recruits %>% 
  filter(Yr > 2020) %>% 
  pivot_longer(cols = -c(Label, Yr)) %>% 
  mutate(name = recode(name, "replist1" = "FMSY",
                          "replist2" = "Fbtarg",
                          "replist3" =  "Mean_F",
                          "replist4" = "0.5F")) %>%
  ggplot(aes(x = Yr, y = value, group = name, color = name)) +
  geom_point() +
  scale_color_ghibli_d("MarnieMedium1", direction = -1) +
  theme_classic()


fore1loop <- SS_output(file.path(species.dir, "forecasting", "1loop"))
tail(fore1loop$stdtable, n = 20)
SSplotTimeseries(fore1loop, subplot = 7)

fore4 <- SS_output(dir =file.path(species.dir, "forecasting", "Forecast_4"))
SSplotTimeseries(fore4, subplot = 7)
tail(fore4$timeseries, n = 10)
SS_ForeCatch(fore4, yrs = 2022:2031)

Cscalar <- fore4$timeseries %>% 
  filter(Yr <= 2021 & Yr >= 2021-10) %>% 
  rename("catch" = 'dead(B):_1') %>% 
  summarise(f = mean(catch)) %>% 
  pull()

fore4$timeseries %>% 
  filter(Yr > 1966) %>% 
  select(Yr, Era, 'dead(B):_1') %>% 
  rename("catch" = 'dead(B):_1') %>% 
  ggplot(aes(x = Yr, y = catch)) +
  geom_segment(aes(x = 2011, xend = 2071, y = Cscalar, yend = Cscalar), 
               color = "grey85", size = 1.5) + 
  geom_line(aes(color = Era), size = 1.1) +
  geom_point(aes(color = Era), size = 2.5) +
  scale_color_ghibli_d("MarnieMedium1", direction = -1) +
  theme_classic()
ggsave(filename = file.path(species.dir, "forecasting/Forecast_4/Catch_ts.png"))


### forecasting with mcmc
library(r4ss)

mcrep <- SSgetMCMC(dir = file.path(species.dir, "forecasting", "mcmc"))
colnames(mcrep)
mcrep %>% 
  select(starts_with("SSB_")) %>% 
  pivot_longer(cols = everything()) %>% 
  separate(name, into = c("SSB", "Year"), sep = "_") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  filter(!is.na(Year)) %>% 
  group_by(Year) %>% 
  summarise(med = quantile(value, 0.5), 
            lwr = quantile(value, 0.05), 
            upr = quantile(value, 0.95)) %>% 
  ggplot(aes(x = Year, y = med)) + 
  geom_line() + 
  geom_ribbon(aes(x = Year, ymin = lwr, ymax = upr), alpha = .5) + 
  geom_vline(xintercept = 2021, color = "red") + 
  theme_classic() +
  labs(y = "SSB")

mcrep %>% 
  select(starts_with("F_")) %>% 
  pivot_longer(cols = everything()) %>% 
  separate(name, into = c("F", "Year"), sep = "_") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  #filter(!is.na(Year)) %>% 
  group_by(Year) %>% 
  summarise(med = quantile(value, 0.5), 
            lwr = quantile(value, 0.05), 
            upr = quantile(value, 0.95)) %>% 
  ggplot(aes(x = Year, y = med)) + 
  geom_line() + 
  geom_ribbon(aes(x = Year, ymin = lwr, ymax = upr), alpha = .5) + 
  geom_vline(xintercept = 2021, color = "red") + 
  theme_classic() +
  labs(y = "F")

mcrep %>% 
  select(starts_with("Bratio_")) %>% 
  pivot_longer(cols = everything()) %>% 
  separate(name, into = c("F", "Year"), sep = "_") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  group_by(Year) %>% 
  summarise(med = quantile(value, 0.5), 
            lwr = quantile(value, 0.05), 
            upr = quantile(value, 0.95)) %>% 
  ggplot(aes(x = Year, y = med)) + 
  geom_line() + 
  geom_ribbon(aes(x = Year, ymin = lwr, ymax = upr), alpha = .5) + 
  geom_vline(xintercept = 2021, color = "red") + 
  theme_classic() +
  labs(y = "F")

mcrep %>% 
  select(starts_with("Recr_")) %>% 
  pivot_longer(cols = everything()) %>% 
  separate(name, into = c("F", "Year"), sep = "_") %>% 
  mutate(Year = as.numeric(Year)) %>% 
  filter(Year > 2021) %>% 
  ggplot(aes(x = Year, y = value, group = Year)) + 
  geom_boxplot() + 
  #geom_ribbon(aes(x = Year, ymin = lwr, ymax = upr), alpha = .5) + 
  geom_vline(xintercept = 2021, color = "red") + 
  theme_classic() +
  labs(y = "Recruitment")


### adding forecast into function
rep <- SS_output(dir = file.path(root_dir, "SS3 models", species, file_dir))
tail(rep$timeseries)
