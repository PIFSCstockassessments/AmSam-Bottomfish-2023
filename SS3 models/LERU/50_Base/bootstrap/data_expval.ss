#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Oct 20 10:25:57 2022
#_expected_values
#C data file for LERU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
15 #_Nages=accumulator age, first age is always age 0
1 #_Nareas
1 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
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
-999 1 1 0.349253 0.5
1967 1 1 0.343367 0.5
1968 1 1 1.21153 0.5
1969 1 1 0.374666 0.5
1970 1 1 0.131999 0.5
1971 1 1 0.000999991 0.5
1972 1 1 3.54298 0.5
1973 1 1 4.95499 0.5
1974 1 1 3.4223 0.5
1975 1 1 4.53268 0.5
1976 1 1 3.70399 0.5
1977 1 1 1.63425 0.5
1978 1 1 0.653615 0.5
1979 1 1 0.550649 0.5
1980 1 1 1.44286 0.5
1981 1 1 2.74147 0.5
1982 1 1 3.51619 0.5
1983 1 1 7.11704 0.5
1984 1 1 4.51961 0.5
1985 1 1 2.66158 0.5
1986 1 1 1.99509 0.5
1987 1 1 1.41824 0.5
1988 1 1 1.65469 0.5
1989 1 1 1.44903 0.2
1990 1 1 1.12716 0.281466
1991 1 1 0.96721 0.227721
1992 1 1 1.39372 0.456647
1993 1 1 0.626345 0.5
1994 1 1 1.52915 0.391316
1995 1 1 1.1897 0.464613
1996 1 1 2.15935 0.424734
1997 1 1 1.71045 0.30496
1998 1 1 0.232229 0.5
1999 1 1 0.290291 0.5
2000 1 1 1.43922 0.5
2001 1 1 4.28825 0.5
2002 1 1 2.88433 0.477013
2003 1 1 1.15844 0.45899
2004 1 1 1.38615 0.5
2005 1 1 0.849102 0.5
2006 1 1 0.390993 0.5
2007 1 1 1.61205 0.5
2008 1 1 3.32478 0.327572
2009 1 1 7.03832 0.2
2010 1 1 1.48637 0.2
2011 1 1 3.6633 0.31116
2012 1 1 1.13439 0.5
2013 1 1 2.21211 0.5
2014 1 1 1.06228 0.343554
2015 1 1 3.07212 0.256762
2016 1 1 0.874963 0.2
2017 1 1 0.616878 0.20531
2018 1 1 0.403233 0.2
2019 1 1 0.811918 0.2
2020 1 1 0.435444 0.2
2021 1 1 0.190958 0.406754
-9999 0 0 0 0
#
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 1.932 0.209826 #_orig_obs: 2.66545 FISHERY
2017 7 1 2.39641 0.21091 #_orig_obs: 2.37861 FISHERY
2018 7 1 2.88496 0.2 #_orig_obs: 2.56887 FISHERY
2019 7 1 3.29013 0.2 #_orig_obs: 3.64435 FISHERY
2020 7 1 3.62822 0.2 #_orig_obs: 2.52009 FISHERY
2021 7 1 4.00367 0.394811 #_orig_obs: 5.68061 FISHERY
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
43 # maximum size in the population (lower edge of last bin) 
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
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
8 #_N_LengthBins
 14 17.5 21 24.5 28 31.5 35 38.5
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 148.96  0.192872 3.99742 23.6255 61.7868 44.2133 13.3723 1.56674 0.205131 0 0 0 0 0 0 0 0
 2005 1 1 0 0 125.16  0.1582 3.04059 18.6652 49.078 38.8292 13.6284 1.58164 0.17891 0 0 0 0 0 0 0 0
 2006 1 1 0 0 99.12  0.122159 2.14284 13.3789 36.9406 32.0317 12.728 1.62081 0.155095 0 0 0 0 0 0 0 0
 2007 1 1 0 0 81.48  0.0994207 1.67238 10.2279 28.6584 26.9795 11.9999 1.69699 0.14551 0 0 0 0 0 0 0 0
 2008 1 1 0 0 250.48  0.309536 5.46275 32.635 86.9728 80.0847 38.4959 6.01831 0.501019 0 0 0 0 0 0 0 0
 2009 1 1 0 0 331.8  0.44771 10.2992 52.9753 122.535 93.6733 43.8298 7.37474 0.665211 0 0 0 0 0 0 0 0
 2010 1 1 0 0 104.16  0.140632 3.32377 22.1181 46.1939 22.7805 8.07868 1.35743 0.166928 0 0 0 0 0 0 0 0
 2011 1 1 0 0 782.04  1.08825 27.1042 140.834 343.022 205.676 55.4537 7.73289 1.12779 0 0 0 0 0 0 0 0
 2012 1 1 0 0 1329.72  1.7992 42.5663 268.107 592.339 324.479 88.6769 10.0527 1.7002 0 0 0 0 0 0 0 0
 2013 1 1 0 0 1564.92  2.09757 47.8311 266.55 673.256 439.571 120.812 12.8399 1.96207 0 0 0 0 0 0 0 0
 2014 1 1 0 0 190.68  0.24907 5.32208 32.5561 79.4444 54.2159 16.8635 1.78639 0.242541 0 0 0 0 0 0 0 0
 2015 1 1 0 0 542.64  0.713418 15.4038 86.1203 218.212 160.871 54.3575 6.23296 0.728477 0 0 0 0 0 0 0 0
 2016 1 1 0 0 246.96  0.317928 6.51334 41.2683 100.619 70.0166 24.8132 3.06559 0.345719 0 0 0 0 0 0 0 0
 2017 1 1 0 0 110.88  0.138633 2.56349 15.8089 43.4293 34.6058 12.5417 1.62417 0.168021 0 0 0 0 0 0 0 0
 2018 1 1 0 0 143.64  0.175534 2.9775 18.6132 52.2156 47.4359 19.3826 2.598 0.241623 0 0 0 0 0 0 0 0
 2019 1 1 0 0 189.84  0.228749 3.65652 22.8659 65.1708 63.6739 29.552 4.32912 0.363004 0 0 0 0 0 0 0 0
 2020 1 1 0 0 153.72  0.183132 2.78577 17.7351 50.8301 51.4319 26.1667 4.24857 0.338684 0 0 0 0 0 0 0 0
 2021 1 1 0 0 79.8  0.0940213 1.35684 8.69199 25.4707 26.8484 14.5581 2.57711 0.202859 0 0 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

