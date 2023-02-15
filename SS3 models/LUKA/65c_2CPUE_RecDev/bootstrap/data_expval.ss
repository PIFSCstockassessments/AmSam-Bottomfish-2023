#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 17:33:30 2023
#_expected_values
#C data file for LUKA
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
8 #_Nages=accumulator age, first age is always age 0
1 #_Nareas
3 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
 3 1 1 1 0 SURVEY2  # 2
 3 1 1 1 0 SURVEY3  # 3
#Bycatch_fleet_input_goes_next
#a:  fleet index
#b:  1=include dead bycatch in total dead catch for F0.1 and MSY optimizations and forecast ABC; 2=omit from total catch for these purposes (but still include the mortality)
#c:  1=Fmult scales with other fleets; 2=bycatch F constant at input value; 3=bycatch F from range of years
#d:  F or first year of range
#e:  last year of range
#f:  not used
# a   b   c   d   e   f 
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0.877165 0.5
1967 1 1 0.878596 0.5
1968 1 1 3.09889 0.5
1969 1 1 0.957973 0.5
1970 1 1 0.337464 0.5
1971 1 1 0.000999984 0.5
1972 1 1 9.06364 0.5
1973 1 1 10.4616 0.5
1974 1 1 8.17005 0.5
1975 1 1 7.99538 0.5
1976 1 1 7.71896 0.5
1977 1 1 4.17933 0.5
1978 1 1 1.67189 0.5
1979 1 1 1.40837 0.5
1980 1 1 1.41019 0.5
1981 1 1 2.67932 0.5
1982 1 1 3.43635 0.5
1983 1 1 6.93587 0.5
1984 1 1 5.14414 0.5
1985 1 1 5.4975 0.5
1986 1 1 5.00894 0.5
1987 1 1 1.67691 0.5
1988 1 1 3.91718 0.467268
1989 1 1 2.77187 0.2
1990 1 1 1.39704 0.245355
1991 1 1 1.1376 0.221413
1992 1 1 0.563352 0.430176
1993 1 1 0.940286 0.324167
1994 1 1 1.84065 0.2
1995 1 1 2.07379 0.252915
1996 1 1 1.41655 0.498858
1997 1 1 2.58634 0.2
1998 1 1 0.427733 0.342705
1999 1 1 0.539312 0.5
2000 1 1 2.05202 0.27585
2001 1 1 2.88933 0.26062
2002 1 1 3.51572 0.207101
2003 1 1 1.14665 0.233131
2004 1 1 1.48321 0.5
2005 1 1 0.583304 0.5
2006 1 1 0.270333 0.5
2007 1 1 0.86634 0.5
2008 1 1 1.25642 0.5
2009 1 1 4.05504 0.2
2010 1 1 1.13531 0.2
2011 1 1 2.0012 0.5
2012 1 1 0.530237 0.5
2013 1 1 1.64878 0.5
2014 1 1 1.80616 0.442494
2015 1 1 1.8488 0.2
2016 1 1 0.564253 0.2
2017 1 1 0.361963 0.2
2018 1 1 0.236315 0.2
2019 1 1 0.342453 0.2
2020 1 1 0.263535 0.2
2021 1 1 0.171457 0.483547
-9999 0 0 0 0
#
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
2 1 0 0 # SURVEY2
3 1 0 0 # SURVEY3
#_year month index obs err
1988 7 2 15.1284 0.2 #_orig_obs: 24.9987 SURVEY2
1989 7 2 15.6956 0.325279 #_orig_obs: 34.2855 SURVEY2
1990 7 2 14.3038 0.229948 #_orig_obs: 23.9745 SURVEY2
1991 7 2 12.5353 0.535642 #_orig_obs: 14.9709 SURVEY2
1992 7 2 11.2532 0.209907 #_orig_obs: 8.8606 SURVEY2
1993 7 2 10.2882 0.201402 #_orig_obs: 9.74442 SURVEY2
1994 7 2 9.46023 0.2 #_orig_obs: 8.08246 SURVEY2
1995 7 2 8.99874 0.202118 #_orig_obs: 8.75963 SURVEY2
1996 7 2 9.2587 0.2 #_orig_obs: 7.79769 SURVEY2
1997 7 2 9.38755 0.2 #_orig_obs: 14.7649 SURVEY2
1998 7 2 9.73101 0.520386 #_orig_obs: 6.70285 SURVEY2
1999 7 2 10.2249 0.368026 #_orig_obs: 9.40827 SURVEY2
2000 7 2 9.78352 0.335571 #_orig_obs: 12.8809 SURVEY2
2001 7 2 8.37072 0.217718 #_orig_obs: 11.072 SURVEY2
2002 7 2 6.47819 0.2 #_orig_obs: 9.04085 SURVEY2
2003 7 2 5.59811 0.226821 #_orig_obs: 4.42107 SURVEY2
2004 7 2 5.38568 0.2 #_orig_obs: 5.25577 SURVEY2
2005 7 2 5.60174 0.485596 #_orig_obs: 3.48025 SURVEY2
2006 7 2 6.17728 0.229839 #_orig_obs: 3.72597 SURVEY2
2007 7 2 6.7124 0.2 #_orig_obs: 3.88106 SURVEY2
2008 7 2 6.96048 0.2 #_orig_obs: 5.84498 SURVEY2
2009 7 2 6.02034 0.2 #_orig_obs: 11.4306 SURVEY2
2010 7 2 5.73536 0.219549 #_orig_obs: 8.33291 SURVEY2
2011 7 2 5.85207 0.204547 #_orig_obs: 8.05161 SURVEY2
2012 7 2 6.39133 0.326237 #_orig_obs: 5.08724 SURVEY2
2013 7 2 7.03438 0.2 #_orig_obs: 6.13803 SURVEY2
2014 7 2 7.54323 0.2 #_orig_obs: 4.24975 SURVEY2
2015 7 2 7.76974 0.2 #_orig_obs: 3.66846 SURVEY2
2016 7 3 1.39459 0.2 #_orig_obs: 1.78809 SURVEY3
2017 7 3 1.38536 0.208958 #_orig_obs: 1.14939 SURVEY3
2018 7 3 1.38846 0.2 #_orig_obs: 1.38325 SURVEY3
2019 7 3 1.46185 0.2 #_orig_obs: 1.83588 SURVEY3
2020 7 3 1.55538 0.2 #_orig_obs: 1.12559 SURVEY3
2021 7 3 1.63385 0.408432 #_orig_obs: 1.78588 SURVEY3
-9999 1 1 1 1 # terminator for survey observations 
#
0 #_N_fleets_with_discard
#_discard_units (1=same_as_catchunits(bio/num); 2=fraction; 3=numbers)
#_discard_errtype:  >0 for DF of T-dist(read CV below); 0 for normal with CV; -1 for normal with se; -2 for lognormal; -3 for trunc normal with CV
# note: only enter units and errtype for fleets with discard 
# note: discard data is the total for an entire season, so input of month here must be to a month in that season
#_Fleet units errtype
# -9999 0 0 0.0 0.0 # terminator for discard data 
#
0 #_use meanbodysize_data (0/1)
#_COND_0 #_DF_for_meanbodysize_T-distribution_like
# note:  type=1 for mean length; type=2 for mean body weight 
#_yr month fleet part type obs stderr
#  -9999 0 0 0 0 0 0 # terminator for mean body size data 
#
# set up population length bin structure (note - irrelevant if not using size data and using empirical wtatage
2 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
1 # binwidth for population size comp 
1 # minimum size in the population (lower edge of first bin and size at age 0.00) 
31 # maximum size in the population (lower edge of last bin) 
1 # use length composition data (0/1)
#_mintailcomp: upper and lower distribution for females and males separately are accumulated until exceeding this level.
#_addtocomp:  after accumulation of tails; this value added to all bins
#_combM+F: males and females treated as combined gender below this bin number 
#_compressbins: accumulate upper tail by this number of bins; acts simultaneous with mintailcomp; set=0 for no forced accumulation
#_Comp_Error:  0=multinomial, 1=dirichlet
#_ParmSelect:  parm number for dirichlet
#_minsamplesize: minimum sample size; set to 1 to match 3.24, minimum value is 0.001
#
#_mintailcomp addtocomp combM+F CompressBins CompError ParmSelect minsamplesize
-1 0.001 0 0 1 1 0.001 #_fleet:1_FISHERY
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
8 #_N_LengthBins
 14 16 18 20 22 24 26 28
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 235  0.700614 4.52911 19.8939 77.2429 102.51 28.2251 1.65512 0.243124
 2005 1 1 0 0 147  0.499194 2.82915 12.2164 49.8499 63.7116 16.7682 0.97405 0.151534
 2006 1 1 0 0 147  0.411022 3.33712 12.099 47.9184 64.7819 17.3056 0.99537 0.15161
 2007 1 1 0 0 292  0.845297 4.54462 25.6362 97.7501 125.737 35.1219 2.06278 0.30171
 2008 1 1 0 0 346  0.871549 6.68287 24.603 115.03 154.645 41.3093 2.50049 0.358143
 2009 1 1 0 0 456  1.38997 7.29101 40.3907 152.631 198.824 51.9436 3.05922 0.470987
 2010 1 1 0 0 144  0.439251 3.29036 11.5956 51.1148 62.2669 14.3455 0.800303 0.147262
 2011 1 1 0 0 782  2.82767 15.0425 74.0744 269.625 336.167 79.288 4.17709 0.797594
 2012 1 1 0 0 1255  4.12188 31.9211 107.811 438.867 537.259 126.928 6.81119 1.28081
 2013 1 1 0 0 2416  7.33331 47.935 237.7 839.478 1017.27 250.556 13.2695 2.46239
 2014 1 1 0 0 1062  2.63354 20.4482 88.8202 382.059 453.341 107.593 6.01854 1.08614
 2015 1 1 0 0 1023  2.31394 14.1292 81.3599 351.999 458.373 108.055 5.72658 1.04426
 2016 1 1 0 0 369  0.991477 4.77597 22.7027 118.807 174.424 44.5118 2.40672 0.379484
 2017 1 1 0 0 204  0.593021 3.75364 12.743 57.258 98.5588 29.2508 1.63128 0.21149
 2018 1 1 0 0 170  0.472995 3.23734 13.6888 49.2463 75.3413 26.1446 1.68898 0.179685
 2019 1 1 0 0 212  0.591776 3.53605 16.6878 67.869 90.5467 30.369 2.17427 0.225488
 2020 1 1 0 0 155  0.43363 2.69242 11.086 48.6474 69.0124 21.3989 1.56346 0.165737
 2021 1 1 0 0 87  0.252959 1.51645 6.44378 26.3953 39.2179 12.2488 0.832497 0.0923452
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 
#
0 #_N_age_bins
# 0 #_N_ageerror_definitions
#_mintailcomp: upper and lower distribution for females and males separately are accumulated until exceeding this level.
#_addtocomp:  after accumulation of tails; this value added to all bins
#_combM+F: males and females treated as combined gender below this bin number 
#_compressbins: accumulate upper tail by this number of bins; acts simultaneous with mintailcomp; set=0 for no forced accumulation
#_Comp_Error:  0=multinomial, 1=dirichlet
#_ParmSelect:  parm number for dirichlet
#_minsamplesize: minimum sample size; set to 1 to match 3.24, minimum value is 0.001
#
#_mintailcomp addtocomp combM+F CompressBins CompError ParmSelect minsamplesize
# 0 0 0 0 0 0 0 #_fleet:1_FISHERY
# 0 0 0 0 0 0 0 #_fleet:2_SURVEY2
# 0 0 0 0 0 0 0 #_fleet:3_SURVEY3
# 0 #_Lbin_method_for_Age_Data: 1=poplenbins; 2=datalenbins; 3=lengths
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part ageerr Lbin_lo Lbin_hi Nsamp datavector(female-male)
# -9999  0 0 0 0 0 0 0 0
#
0 #_Use_MeanSize-at-Age_obs (0/1)
#
0 #_N_environ_variables
# -2 in yr will subtract mean for that env_var; -1 will subtract mean and divide by stddev (e.g. Z-score)
#Yr Variable Value
#
0 # N sizefreq methods to read 
#
0 # do tags (0/1)
#
0 #    morphcomp data(0/1) 
#  Nobs, Nmorphs, mincomp
#  yr, seas, type, partition, Nsamp, datavector_by_Nmorphs
#
0  #  Do dataread for selectivity priors(0/1)
# Yr, Seas, Fleet,  Age/Size,  Bin,  selex_prior,  prior_sd
# feature not yet implemented
#
999

