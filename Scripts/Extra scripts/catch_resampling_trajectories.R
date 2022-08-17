## Creating bootstrapped catch trajectories for investigating catch uncertainty for American Samoa BMUS

library(tidyverse)
library(this.path)
set.seed(12345)

root_dir <- here(.. = 2)
if(!dir.exists(file.path(root_dir, "Outputs", "Summary", "Catch figures"))){
  dir.create(file.path(root_dir, "Outputs", "Summary", "Catch figures"))
}
catch <- read.csv(file = file.path(root_dir, "Outputs", "SS3_Inputs", "CATCH_Final.csv"))
head(catch)

catchresample <- catch %>% 
  group_by(SPECIES) %>% 
  mutate(catch1 = rlnorm(length(SPECIES), log(MT), LOGSD.MT),
         catch2 = rlnorm(length(SPECIES), log(MT), LOGSD.MT),
         catch3 = rlnorm(length(SPECIES), log(MT), LOGSD.MT),
         catch4 = rlnorm(length(SPECIES), log(MT), LOGSD.MT),
         catch5 = rlnorm(length(SPECIES), log(MT), LOGSD.MT),
         ) 

## All species catch
catchresample %>% 
  ggplot(aes(x = YEAR, y = MT, group = SPECIES)) +
  geom_line(color = "grey88", size = 5) +
  geom_line(aes(x = YEAR, y = catch1), color = 2, size = .75, alpha = .85) +
  geom_line(aes(x = YEAR, y = catch2), color = 3, size = .75, alpha = .85) +
  geom_line(aes(x = YEAR, y = catch3), color = 4, size = .75, alpha = .85) +
  geom_line(aes(x = YEAR, y = catch4), color = 5, size = .75, alpha = .85) +
  geom_line(aes(x = YEAR, y = catch5), color = 6, size = .75, alpha = .85) +
  #geom_line(aes(x = YEAR, y = MT), color = "grey30", size = 1.2) +
  theme_classic() +
  labs(y = "Catch (mt)", x = "Year") +
  facet_wrap(~SPECIES, scales = "free")
ggsave(filename = file.path(root_dir, "Outputs", "Summary", "Catch figures", "catch_resampling_all_species.png"))

## Species specific (easier to see spread in catch trajectories)
for(i in unique(catch$SPECIES)){
  
  catchresample %>% 
    filter(SPECIES == paste0(i)) %>% 
    ggplot(aes(x = YEAR, y = MT)) +
    geom_line(color = "grey88", size = 5) +
    geom_line(aes(x = YEAR, y = catch1), color = 2, size = 1, alpha = .85) +
    geom_line(aes(x = YEAR, y = catch2), color = 3, size = 1, alpha = .85) +
    geom_line(aes(x = YEAR, y = catch3), color = 4, size = 1, alpha = .85) +
    geom_line(aes(x = YEAR, y = catch4), color = 5, size = 1, alpha = .85) +
    geom_line(aes(x = YEAR, y = catch5), color = 6, size = 1, alpha = .85) +
    theme_classic() +
    scale_x_continuous(breaks = seq(1967, 2021, by = 3)) +
    labs(y = "Catch (mt)", x = "Year", subtitle = paste0(i))
  ggsave(filename = file.path(root_dir, "Outputs", "Summary", "Catch figures", paste0("catch_resampling_",i,".png")))
  
  
}


