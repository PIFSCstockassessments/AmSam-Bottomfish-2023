### Script to create input files for SS and run the model then create a report for basic diagnostics

require(r4ss)
require(tidyverse)
require(this.path)
require(openxlsx)
require(purrr)
require(googlesheets4)
require(data.table)

### Initial Inputs ####
root_dir <- this.path::here(.. = 2)
Species.List <- list.files(file.path(root_dir, "SS3 models"))[-9]
species <- Species.List[1]


### Run Stock Synthesis ####
file.copy(file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "ss_opt_win.exe"), 
          file.path(root_dir, "SS3 models", species))
run_SS_models(dirvec = file.path(root_dir, "SS3 models", species), 
              model = "ss_opt_win", extras = "-stopph 3 -nohess",  skipfinished = FALSE)

### Create Summary Report ####
rmarkdown::render("~/AmSam-Bottomfish-2023/Scripts/Creating SS Files Scripts/model_diags_report.Rmd", 
                  output_file = paste(species, scenario, "SS3_Diags_Report", sep = "_"),
                  output_dir =  file.path(root_dir, "SS3 models", species, scenario),
                  params = list(
                    species = paste0(species),
                    scenario = scenario,
                    report = "../../SS3 models"
                  ))


report. <- SS_output(file.path(root_dir, "SS3 models", species, scenario))
SSplotJABBAres(report., subplots = "cpue", add = TRUE)
report$warnings
report$parameters %>% filter(str_detect(Status, "HI|LO"))
SS_plots(report, dir = file.path(root_dir, "SS3 models", species))
## Do Retrospectives
SS_doRetro(masterdir=file.path(root_dir, "SS3 models", "TEMPLATE_FILES"), 
           oldsubdir="", newsubdir="Retrospectives", years=0:-5)


## Do Profiling
## Create directory and copy inputs
dir.profile <- file.path(root_dir, "SS3 models", "TEMPLATE_FILES", "R0_Likelihood")
copy_SS_inputs(dir.old = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
               dir.new = dir.profile,
               create.dir = TRUE,
               overwrite = TRUE,
               recursive = TRUE,
               use_ss_new = TRUE,
               copy_exe = TRUE,
               copy_par = FALSE,
               dir.exe = file.path(root_dir, "SS3 models", "TEMPLATE_FILES"),
               verbose = TRUE)

# Make changes to starter file
starter <- SS_readstarter(file.path(dir.profile, "starter.ss"))
starter[["ctlfile"]] <- "control_modified.ss"
# make sure the prior likelihood is calculated
# for non-estimated quantities
starter[["prior_like"]] <- 1
SS_writestarter(starter, dir = dir.profile, overwrite = TRUE)

# vector of values to profile over
r0.vec <- seq(8.2, 8.4, .1)
Nprofile <- length(r0.vec)

# run SS_profile command
profile <- SS_profile(
  dir = dir.profile, 
  model = "ss_opt_win",
  masterctlfile = "control.ss_new",
  newctlfile = "control_modified.ss",
  string = "SR_LN(R0)",
  profilevec = r0.vec
)


### Create Summary Report ####
rmarkdown::render("~/AmSam-Bottomfish-2023/Scripts/Creating SS Files Scripts/model_diags_report.Rmd", 
                  output_file = paste0(species, "_SS3_Diags_Report"),
                  output_dir =  file.path(root_dir, "SS3 models", species),
                  params = list(
                    species = paste0(species),
                    scenario = "Base",
                    report = "../../SS3 models"
))


build_all_ss(species = "APRU",
             scenario = "base",
             runmodels = TRUE,
             ext_args = "-stopph 3 -nohess",
             printreport = FALSE)
