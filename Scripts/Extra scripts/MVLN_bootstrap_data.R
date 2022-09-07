### Messing around with Delta_MVLN
library(ss3diags)
library(data.table)
library(r4ss)
library(ggsidekick)
library(tidyverse)

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

mv5 <- rbindlist(mvlns)

SSplotEnsemble(mv5, print_plot = T, use_png = T, 
               plotdir = file.path(root_dir, "SS3 Models", species, file_dir, "bootstrap_figs"))

SSplotEnsemble(mv, subplots = "Catch", add = T)

mv5 %>% 
  select(c(year, stock, harvest, SSB, F, Recr, Catch)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  #filter(variable == "stock" | variable == "harvest") %>% 
  ggplot(aes(x = year, y = med)) +
  geom_line() +
  geom_ribbon(aes(ymin = l95, ymax = u95), alpha = .25) +
  facet_wrap(~variable, scales = "free") +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "mvln_fig.png"))
# ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "harvest_stock_fig.png"))

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
  select(c(year, version, med, u95, l95)) %>% 
  mutate(run = "original")


mv5ssb %>% 
  filter(variable == "SSB") %>% 
  mutate(version = "mvln") %>% 
  select(year, version, med, u95, l95) %>% 
  bind_rows(orig.ssb) %>% 
  ggplot() +
  geom_ribbon(aes(x = year, ymin = l95, ymax = u95, fill = version), alpha = .25) +
  geom_line(aes(x = year, y = med, color = version), size = 1.1) +
  labs(title = "SSB", x = "Year", y = "SSB") +
  scale_x_continuous(breaks = seq(1967, 2021, by = 3)) +
  scale_y_continuous(breaks = seq(0,40,by = 5)) +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "ssb_comparison.png"))  


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
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "bootstrap_catch.png"))

## CPUE 
mods %>% 
  purrr::map("cpue") %>% 
  purrr::map(~ select(., Yr, Obs)) %>% 
  purrr::map2(., run, ~cbind(.x, Run = .y)) %>% 
  rbindlist() %>% 
  ggplot() +
  geom_line(data = . %>% filter(Run == "original"), aes(x = Yr, y = Obs), color = "grey80", size = 3) +
  geom_point(data = . %>% filter(Run != "original"),
            aes(x = Yr, y = Obs, color = Run), size = 2, alpha = .65) + 
  geom_line(data = . %>% filter(Run != "original"),
            aes(x = Yr, y = Obs, color = Run), size = 1.1, alpha = .65) + 
  labs(x = "Year", y = "CPUE") +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "bootstrap_cpue.png"))


## Length comps
original.lencomp <- mods %>% 
  purrr::map("lendbase") %>% 
  purrr::map(~ select(., Yr, Obs, Bin)) %>% 
  purrr::map2(., run, ~cbind(.x, Run = .y)) %>% 
  rbindlist() %>% 
  filter(Run == "original") %>% 
  mutate(Run = NULL)


mods %>% 
  purrr::map("lendbase") %>% 
  purrr::map(~ select(., Yr, Obs, Bin)) %>% 
  purrr::map2(., run, ~cbind(.x, Run = .y)) %>% 
  rbindlist() %>% 
  filter(Run != "original") %>% 
  ggplot() +
  geom_col(aes(x = Bin, y = Obs, fill = Run)) +
  facet_wrap(~Run) +
  geom_col(data = original.lencomp,aes(x = Bin, y = Obs),fill="grey15", alpha = .5) +
  labs(x = "Length Bin", y = "") +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "bootstrap_lencomp.png"))

mods %>% 
  purrr::map("catch") %>% 
  purrr::map(~ select(., Yr, Obs)) %>% 
  purrr::map2(., run, ~cbind(.x, Run = .y)) %>% 
  rbindlist() %>% 
  filter(Obs <= .001) %>% 
  group_by(Run) %>% 
  summarise(n())
  

mv1ssb <- mv1 %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  filter(variable == "SSB") %>% 
  mutate(run = 1)

mv2ssb <- mv2 %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  filter(variable == "SSB") %>% 
  mutate(run = 2)

mv3ssb <- mv3 %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  filter(variable == "SSB") %>% 
  mutate(run = 3)

mv4ssb <- mv4 %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  filter(variable == "SSB") %>% 
  mutate(run = 4)

mv5ssb <- mv5 %>% 
  filter(run != "original") %>% 
  select(c(year, SSB, stock)) %>% 
  pivot_longer(cols = -year, names_to = "variable") %>% 
  group_by(year, variable) %>% 
  summarise(
    med = quantile(value, probs = 0.5),
    u95 = quantile(value, probs = .95),
    l95 = quantile(value, probs = .05)
  ) %>% 
  filter(variable == "SSB") %>% 
  mutate(run = 5)

mv1ssb %>% 
  bind_rows(mv2ssb) %>% 
  bind_rows(mv3ssb) %>% 
  bind_rows(mv4ssb) %>% 
  bind_rows(mv5ssb) %>% 
  mutate(run = as.factor(run)) %>% 
  ggplot(aes(x = year, y = med, group = run, color = run, fill = run)) +
  geom_line() +
  #geom_ribbon(aes(x = year, ymin = l95, ymax = u95), alpha = .25) +
  geom_line(data = orig.ssb, aes(x = year, y = med)) + 
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "ssb_no_uncertainty.png"))

mods %>% 
  map("timeseries") %>% 
  map(~ select(., c(Yr, SpawnBio))) %>% 
  rbindlist(idcol = "run") %>% 
 # filter(run != "original") %>% 
  ggplot(aes(x = Yr, y = SpawnBio, group = run, color = run)) +
  geom_line() + 
  labs(x = "Year", y = "SSB") +
  theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap", "bootstrap_ssb.png"))  
  

mv5.sum <- mv5 %>% 
  filter(run != "original") %>% 
  group_by(run, year) %>% 
summarise(
  med = quantile(SSB, probs = 0.5),
  u95 = quantile(SSB, probs = .95),
  l95 = quantile(SSB, probs = .05)
)

mv5 %>% 
  filter(run == "boot10") %>% 
  ggplot(aes(x = year, y = SSB)) +
  geom_line(aes(group = iter, color = iter),show.legend = F) + 
  geom_line(data = mv5.sum, aes(x = year, y = med), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = u95), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = l95), color = "red") 

mv5 %>% 
  filter(run == "boot10") %>% 
  ggplot(aes(x = year, y = SSB)) +
  geom_violin(aes(group = year)) +
  geom_line(data = mv5.sum, aes(x = year, y = med), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = u95), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = l95), color = "red") 

mv5 %>% 
  filter(run != "original") %>% 
  ggplot(aes(x = year, y = SSB)) +
  geom_line(aes(group = iter, color = iter), show.legend = F) +
  geom_line(data = mv5.sum, aes(x = year, y = med), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = u95), color = "red") +
  geom_line(data = mv5.sum, aes(x = year, y = l95), color = "red") +
  facet_wrap(~run) +
  theme_classic()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "mc_ssb.png"))  

mv5 %>% 
  filter(run != "original") %>% 
  ggplot(aes(x = year, y = SSB)) +
  geom_violin(aes(group = year)) +
  geom_line(data = mv5 %>% 
              filter(run != "original") %>% 
              group_by(year) %>% 
              summarise(
                med = quantile(SSB, probs = 0.5),
                u95 = quantile(SSB, probs = .95),
                l95 = quantile(SSB, probs = .05)
              ), 
            aes(x = year, y = med), color = "red") +
  geom_line(data = mv5 %>% 
              filter(run != "original") %>% 
              group_by(year) %>% 
              summarise(
                med = quantile(SSB, probs = 0.5),
                u95 = quantile(SSB, probs = .95),
                l95 = quantile(SSB, probs = .05)
              ), 
            aes(x = year, y = u95), color = "red") +
  geom_line(data = mv5 %>% 
              filter(run != "original") %>% 
              group_by(year) %>% 
              summarise(
                med = quantile(SSB, probs = 0.5),
                u95 = quantile(SSB, probs = .95),
                l95 = quantile(SSB, probs = .05)
              ), 
            aes(x = year, y = l95), color = "red") +
  scale_y_continuous(breaks = seq(0,80,by=5)) +
  theme_classic()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "violin_ssb_all.png"))

mv5ssb %>% 
  filter(variable == "SSB") %>% 
  mutate(version = "mvln") %>% 
  select(year, version, med, u95, l95) %>% 
  bind_rows(orig.ssb) %>% 
  ggplot() +
  geom_ribbon(aes(x = year, ymin = l95, ymax = u95, fill = version), alpha = .25) +
  geom_line(aes(x = year, y = med, color = version), size = 1.1) +
  labs(title = "SSB", x = "Year", y = "SSB") +
  scale_x_continuous(breaks = seq(1967, 2021, by = 3)) +
  scale_y_continuous(breaks = seq(0,40,by = 5)) +
  ggsidekick::theme_sleek()
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "ssb_comparison.png"))  

## management quants plot
b.plot <- mods$original$derived_quants %>% 
  filter(str_detect(Label, "Bratio")) %>% 
  separate(Label, into = c("bratio", "year")) %>% 
  mutate(upper = Value + 1.96*StdDev,
         lower = Value - 1.96*StdDev,
         year = as.numeric(year)) %>% 
  ggplot() +
  geom_line(aes(x = year, y = Value), color = 2) +
  geom_ribbon(aes(x = year, ymin = lower, ymax = upper), fill = 2, alpha = .25) +
  geom_line(data = mv5 %>% filter(run != "original") %>% 
              group_by(year) %>% 
              summarise(med = quantile(stock, probs = 0.5)),
            aes(x = year, y = med), color = 3) +
  geom_ribbon(data = mv5 %>% filter(run != "original") %>% 
                group_by(year) %>% 
                summarise(u95 = quantile(stock, probs = .95),
                          l95 = quantile(stock, probs = .05)),
              aes(x = year, ymin = l95, ymax = u95), fill = 3, alpha = .5) +
  theme_sleek() +
  labs(x = "Year", y = "Bratio")
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "bratio_comparison.png"))  

f.plot <- mods$original$derived_quants %>% 
  filter(str_detect(Label, "F")) %>% 
  separate(Label, into = c("f", "year"), sep = "_") %>% 
  slice(1:(n() - 5)) %>% 
  mutate(upper = Value + 1.96*StdDev,
         lower = Value - 1.96*StdDev,
         year = as.numeric(year)) %>% 
  ggplot() +
  geom_line(aes(x = year, y = Value), color = 2) +
  geom_ribbon(aes(x = year, ymin = lower, ymax = upper), fill = 2, alpha = .25) +
  geom_line(data = mv5 %>% filter(run != "original") %>% 
              group_by(year) %>% 
              summarise(med = quantile(harvest, probs = 0.5)),
            aes(x = year, y = med), color = 3) +
  geom_ribbon(data = mv5 %>% filter(run != "original") %>% 
                group_by(year) %>% 
                summarise(u95 = quantile(harvest, probs = .95),
                          l95 = quantile(harvest, probs = .05)),
              aes(x = year, ymin = l95, ymax = u95), fill = 3, alpha = .5) +
  theme_sleek() +
  labs(x = "Year", y = "Fratio")
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "fratio_comparison.png"))  

p <- grid.arrange(b.plot, f.plot, nrow = 1,
             bottom = textGrob(
               "Red line and shaded area are the single model estimate and uncertainty. Green line and shaded area are the bootstrap ensemble estimate and uncertainty.",
               gp = gpar(fontface = 3, fontsize = 9),
               hjust = 1,
               x = 1
             ))
ggsave(filename = file.path(root_dir, "SS3 models", species, file_dir, "bootstrap_figs", "management_quants.png"), p)  
