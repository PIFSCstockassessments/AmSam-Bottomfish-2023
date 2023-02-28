## About
This repository contains the code and models used for the 2023 American Samoa BMUS Stock Assessment. 

## Repository Structure
The folder structure is as follows: 

**/Data**: contains all raw data files, not available in the repository for confidentiality reasons but available in the "02_Assessment Report/Data folder image" folder on Google Drive (unzip content in /Data folder). Please contact Marc Nadon for permisions.

**/Scripts**: 
    * **/01_Data scripts**: data processing scripts, all called by 01_Run data scripts.R  
    * **/02_SS scripts**: scripts to create SS files and run bootstraps, diagnostics, forecasts, and alternate models  
    * **/03_Report scripts**: scripts to create figures and tables for the assessment report  
    * **/04_Other scripts**: scripts for extra analyses  

**/SS3 models**: contains history of model runs during development by species. Model runs include the 4 SS input files, the executable `ss_opt_win.exe` can be found in the TEMPLATE_FILES directory.

**/SS3 final models**: contains the final model runs (base and alternates) discussed in the assessment report by species. 

**/Images**: high resolution .jpg images of BMUS species used in report and presentations.



## To use this repo 
1. Clone repository onto personal laptop. 
2. Open /Scripts/01_Run data scripts.R 
3. Run script and login and give full permission to Google Drive when prompted (click bottom option to read and write to files). 
4. Open /Scripts/02_Run SS models.R and adjust settings as needed. For first run, it is recommended to set the following options:
   * runmodels = T
   * Specify DirName as the name of the folder you want to create (e.g. 01_Base)
   * printreport = F
   * Create_species_report_figs = F
   * N_boot = 0
   * N_foreyrs = 0
   * RD = F
   * Begin = 1967
   * DeleteForecastFiles = T (inside Build_All_SS function)
   * write_files = T (inside Build_All_SS function)
   * readGoogle = T (inside Build_All_SS function)
5. Create list of species and settings (Lt)
6. To run 1 species, set i to the number that species is in the list (e.g. i = 1 for APRU) and run line 20 (`lapply(list(Lt[[i]]),function(x) {...}`).
7. To run all species use line 19 to run for loop. 
8. Once model runs, to run diagnostics and print diagnostic report, set:
   * runmodels = F
   * printreport = T
   * RD = T (make sure do_retro, do_profile, and do_jitter are set to RD)
   * ProfRes = 0.1 (or however small you want the resolution of the profile)
   * profile = "SR_LN(R0)" (name of the parameter you are profiling over as recognized by r4ss::profile())
   * write_files = F (inside Build_All_SS function)
   * Njitter = 100 (inside Build_All_SS function)
   * jitterFraction = 0.1
9. Once diagnostics are run on the single model, run bootstraps by setting N_boot = 30, keeping write_files = F, runmodels = F, and setting RD = F and printreport = F.
10. To run projections, set N_boot back to 0 and N_foreyrs = 7. Projections will be run based on the specified catch range in `Lt$FixedCatchSeq`. 
11. Alternate models can be run by /Scripts/02_SS scripts/09_Run_Alt_Models.R. Note that alternate life history scenarios were changed and run manually. Figures and tables for alternate model runs can be created with /Scripts/03_Report scripts/Create_AltMods_Figs_Tables.R. 
12. Once all models and figures are created, formatted figures and tables for the report can be created with 02_Run SS models.R by turning all model runs off and only creating the species report figures:
    * runmodels = F
    * printreport = F
    * Create_species_report_figs = T
    * N_boot = 0
    * N_foreyrs = 0
    * RD = F
    * write_files = F


## Github Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
