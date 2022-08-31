### Messing around with Delta_MVLN
library(ss3diags)
library(data.table)
library(r4ss)
library(ggsidekick)

mods <- SSgetoutput(keyvec = paste0("_", seq(1,N_boot)),
                    dirvec = file.path(root_dir, "SS3 Models", species, file_dir, "bootstrap"))
mods[["original"]] <- SS_output(dir = file.path(root_dir, "SS3 Models", species, file_dir))
mvlns <- list()

for(i in 1:length(mods)){
  
  mvlns[[i]] <- SSdeltaMVLN(mods[[i]], mc = 5000, 
                            weight = 1, 
                            run = ifelse(i < length(mods), paste0("boot", i), "original"), 
                            plot = F)$kb
  
}

mv <- rbindlist(mvlns)

SSplotEnsemble(mv, print_plot = T, use_png = T, 
               plotdir = file.path(root_dir, "SS3 Models", species, file_dir, "bootstrap"))

SSplotEnsemble(mv, subplots = "Catch", add = T)

mv %>% 
  select(c(year, stock, harvest, SSB, F, Recr, Catch)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  ggplot(aes(x = year, y = med)) +
  geom_line() +
  geom_ribbon(aes(ymin = l95, ymax = u95), alpha = .25) +
  facet_wrap(~variable, scales = "free") +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap", "mvln_fig.png"))

mv.ssb <- mv %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) 

orig.ssb <- mods$original$derived_quants %>% 
  filter(str_detect(Label, "SSB_19|SSB_20")) %>% 
  separate(col = Label, into = c("variable", "Year"), sep = "_") %>% 
  mutate(
    med = Value,
    u95 = Value + (1.96*StdDev),
    l95 = Value - (1.96*StdDev),
    year = as.numeric(Year), 
    version = "original"
  ) %>% 
  select(c(year, version, med, u95, l95))

mv.ssb %>% 
  filter(variable == "SSB") %>% 
  mutate(version = "mvln") %>% 
  select(year, version, med, u95, l95) %>% 
  bind_rows(orig.ssb) %>% 
  ggplot() +
  geom_ribbon(aes(x = year, ymin = l95, ymax = u95, fill = version), alpha = .25) +
  geom_line(aes(x = year, y = med, color = version), size = 1.1) +
  labs(title = "SSB", x = "Year", y = "SSB") +
  scale_x_continuous(breaks = seq(1967, 2021, by = 3)) +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap", "ssb_comparison.png"))  


## Catch figure
run <- c(seq(1, 10, by = 1), "original")
mods %>% 
  purrr::map("catch") %>% 
  purrr::map(~ select(., Yr, Obs)) %>% 
  purrr::map2(., run, ~cbind(.x, Run = .y)) %>% 
  rbindlist() %>% 
  ggplot() +
  geom_line(data = . %>% filter(Run == "original"), aes(x = Yr, y = Obs), color = "grey80", size = 3) +
  geom_line(data = . %>% filter(Run != "original"),
            aes(x = Yr, y = Obs, color = Run), size = 1.1, alpha = .65) + 
  labs(x = "Year", y = "Catch") +
  scale_x_continuous(breaks = seq(1967, 2021, by = 4)) +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap", "bootstrap_catch.png"))
