#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Mon Oct 17 08:12:45 2022
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
-999 1 1 0.352267 0.3
1967 1 1 0.343367 0.3
1968 1 1 1.21153 0.3
1969 1 1 0.374666 0.3
1970 1 1 0.131999 0.3
1971 1 1 0.000999991 0.3
1972 1 1 3.54298 0.3
1973 1 1 4.95499 0.3
1974 1 1 3.4223 0.3
1975 1 1 4.53268 0.3
1976 1 1 3.70398 0.3
1977 1 1 1.63425 0.3
1978 1 1 0.653615 0.3
1979 1 1 0.55065 0.3
1980 1 1 1.44286 0.3
1981 1 1 2.74147 0.3
1982 1 1 3.51619 0.3
1983 1 1 7.10851 0.3
1984 1 1 4.80063 0.3
1985 1 1 2.73542 0.3
1986 1 1 2.02351 0.5
1987 1 1 1.41845 0.5
1988 1 1 1.66379 0.5
1989 1 1 1.45053 0.2
1990 1 1 1.12729 0.281466
1991 1 1 0.96729 0.227721
1992 1 1 1.39389 0.456647
1993 1 1 0.626344 0.5
1994 1 1 1.52919 0.391316
1995 1 1 1.1897 0.464613
1996 1 1 2.15944 0.424734
1997 1 1 1.71046 0.30496
1998 1 1 0.232229 0.5
1999 1 1 0.290291 0.5
2000 1 1 1.43922 0.5
2001 1 1 4.28826 0.5
2002 1 1 2.88433 0.477013
2003 1 1 1.15844 0.45899
2004 1 1 1.38615 0.5
2005 1 1 0.849103 0.5
2006 1 1 0.390993 0.5
2007 1 1 1.61205 0.5
2008 1 1 3.32478 0.327572
2009 1 1 7.03772 0.2
2010 1 1 1.48638 0.2
2011 1 1 3.66325 0.31116
2012 1 1 1.1344 0.5
2013 1 1 2.21212 0.5
2014 1 1 1.06228 0.343554
2015 1 1 3.07212 0.256762
2016 1 1 0.874964 0.2
2017 1 1 0.616878 0.20531
2018 1 1 0.403233 0.2
2019 1 1 0.811919 0.2
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
2016 7 1 1.95479 0.209826 #_orig_obs: 2.66545 FISHERY
2017 7 1 2.40815 0.21091 #_orig_obs: 2.37861 FISHERY
2018 7 1 2.88309 0.2 #_orig_obs: 2.56887 FISHERY
2019 7 1 3.27525 0.2 #_orig_obs: 3.64435 FISHERY
2020 7 1 3.60133 0.2 #_orig_obs: 2.52009 FISHERY
2021 7 1 3.96287 0.394811 #_orig_obs: 5.68061 FISHERY
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
 2004 1 1 0 0 148.96  0.191619 4.0358 24.2303 62.1109 43.6184 13.0518 1.5186 0.202707 0 0 0 0 0 0 0 0
 2005 1 1 0 0 125.16  0.157202 3.06546 19.139 49.3314 38.3785 13.3694 1.54211 0.176992 0 0 0 0 0 0 0 0
 2006 1 1 0 0 99.12  0.121441 2.15861 13.7163 37.1477 31.7089 12.5254 1.58812 0.153518 0 0 0 0 0 0 0 0
 2007 1 1 0 0 81.48  0.0988415 1.68294 10.4768 28.8195 26.749 11.8397 1.66906 0.144119 0 0 0 0 0 0 0 0
 2008 1 1 0 0 250.48  0.30748 5.48355 33.345 87.3297 79.4734 38.0993 5.94441 0.49709 0 0 0 0 0 0 0 0
 2009 1 1 0 0 331.8  0.442522 10.2351 53.6876 122.527 93.1847 43.7049 7.35453 0.663763 0 0 0 0 0 0 0 0
 2010 1 1 0 0 104.16  0.138904 3.2943 22.287 45.9277 22.7408 8.21486 1.38791 0.168516 0 0 0 0 0 0 0 0
 2011 1 1 0 0 782.04  1.07185 26.7045 142.005 341.66 204.924 56.5153 8.01541 1.14399 0 0 0 0 0 0 0 0
 2012 1 1 0 0 1329.72  1.77475 41.9931 269.14 588.438 325.074 91.0166 10.5557 1.72877 0 0 0 0 0 0 0 0
 2013 1 1 0 0 1564.92  2.06912 47.142 268.695 669.792 438.29 123.479 13.4581 1.99527 0 0 0 0 0 0 0 0
 2014 1 1 0 0 190.68  0.24606 5.25502 32.7737 79.0185 54.0957 17.1779 1.86637 0.246797 0 0 0 0 0 0 0 0
 2015 1 1 0 0 542.64  0.704145 15.1708 86.7559 217.16 160.382 55.2464 6.47801 0.742024 0 0 0 0 0 0 0 0
 2016 1 1 0 0 246.96  0.314248 6.42973 41.4921 99.9713 69.9154 25.2934 3.19115 0.35268 0 0 0 0 0 0 0 0
 2017 1 1 0 0 110.88  0.137288 2.54003 15.9872 43.2357 34.4082 12.7175 1.68255 0.171548 0 0 0 0 0 0 0 0
 2018 1 1 0 0 143.64  0.174083 2.9593 18.8704 52.1095 47.1017 19.5094 2.66903 0.246605 0 0 0 0 0 0 0 0
 2019 1 1 0 0 189.84  0.227063 3.64211 23.2237 65.131 63.2241 29.6145 4.40776 0.369732 0 0 0 0 0 0 0 0
 2020 1 1 0 0 153.72  0.181914 2.78009 18.0375 50.844 51.0699 26.1643 4.29852 0.343812 0 0 0 0 0 0 0 0
 2021 1 1 0 0 79.8  0.0934591 1.35661 8.85595 25.5066 26.6553 14.5311 2.59575 0.205194 0 0 0 0 0 0 0 0
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
# 0 0 671088640 0 0 0 0 #_fleet:1_FISHERY
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

