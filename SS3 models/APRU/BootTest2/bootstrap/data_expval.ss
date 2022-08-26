#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Aug 25 15:17:02 2022
#_expected_values
#C data file for APRU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
30 #_Nages=accumulator age, first age is always age 0
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
-999 1 1 0 0.01
1967 1 1 0.010202 0.5
1968 1 1 0.116558 0.5
1969 1 1 0.0319147 0.5
1970 1 1 0.00439119 0.5
1971 1 1 0.00011107 0.5
1972 1 1 0.250368 0.5
1973 1 1 0.00827622 0.5
1974 1 1 0.113474 0.5
1975 1 1 1.05813 0.5
1976 1 1 0.96961 0.5
1977 1 1 0.0295881 0.5
1978 1 1 0.0102287 0.5
1979 1 1 0.024822 0.5
1980 1 1 0.868036 0.5
1981 1 1 0.125582 0.5
1982 1 1 1.53167 0.5
1983 1 1 0.68472 0.5
1984 1 1 0.320563 0.5
1985 1 1 2.24495 0.5
1986 1 1 1.3442 0.5
1987 1 1 0.326287 0.5
1988 1 1 1.36612 0.5
1989 1 1 0.122829 0.32586
1990 1 1 0.0237323 0.5
1991 1 1 0.0571608 0.480854
1992 1 1 0.122786 0.5
1993 1 1 0.00851185 0.5
1994 1 1 1.4383 0.363779
1995 1 1 0.0413851 0.5
1996 1 1 2.83109 0.5
1997 1 1 0.767756 0.260358
1998 1 1 0.0366605 0.5
1999 1 1 0.427863 0.5
2000 1 1 0.171667 0.5
2001 1 1 0.30285 0.348732
2002 1 1 1.01519 0.5
2003 1 1 0.99345 0.310752
2004 1 1 0.400436 0.5
2005 1 1 0.478075 0.5
2006 1 1 0.0736982 0.5
2007 1 1 3.03265 0.5
2008 1 1 1.68181 0.5
2009 1 1 4.66421 0.2
2010 1 1 0.666087 0.273691
2011 1 1 0.241034 0.5
2012 1 1 0.0391005 0.5
2013 1 1 1.00645 0.5
2014 1 1 0.505097 0.5
2015 1 1 1.08083 0.277979
2016 1 1 0.877164 0.218319
2017 1 1 1.29967 0.2
2018 1 1 0.294403 0.312542
2019 1 1 0.579792 0.34192
2020 1 1 0.102072 0.394157
2021 1 1 0.015547 0.452443
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
2016 7 1 4.89021 0.329764 #_orig_obs: 3.14585 FISHERY
2017 7 1 4.8896 0.268077 #_orig_obs: 4.94433 FISHERY
2018 7 1 4.89083 0.337253 #_orig_obs: 5.53638 FISHERY
2019 7 1 4.89435 0.318745 #_orig_obs: 5.97962 FISHERY
2020 7 1 4.8982 0.48749 #_orig_obs: 3.70572 FISHERY
2021 7 1 4.90356 0.645341 #_orig_obs: 11.181 FISHERY
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
100 # maximum size in the population (lower edge of last bin) 
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
0 1e-07 0 0 0 0 1 #_fleet:1_FISHERY
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 1  2.62398e-06 8.29662e-05 0.00133934 0.0190466 0.104682 0.151556 0.14726 0.136488 0.12392 0.108891 0.0894876 0.0641068 0.0356145 0.0136019 0.00392171
 2008 1 1 0 0 1  2.62913e-06 8.31331e-05 0.00134208 0.0190862 0.104854 0.151633 0.14721 0.136436 0.123872 0.108831 0.0894478 0.0640858 0.0356006 0.0135956 0.00391986
 2009 1 1 0 0 1  2.63571e-06 8.33658e-05 0.00134569 0.0191294 0.105038 0.151804 0.147216 0.136347 0.123787 0.108748 0.0893775 0.0640425 0.0355766 0.0135856 0.00391685
 2010 1 1 0 0 1  2.63925e-06 8.34772e-05 0.00134807 0.0191727 0.105297 0.152074 0.147296 0.136253 0.123635 0.108608 0.0892577 0.0639605 0.0355324 0.0135682 0.00391167
 2011 1 1 0 0 1  2.63503e-06 8.33541e-05 0.00134592 0.0191512 0.105291 0.152279 0.147511 0.136298 0.123545 0.108491 0.0891564 0.063889 0.0354941 0.0135536 0.00390729
 2012 1 1 0 0 1  2.63059e-06 8.31866e-05 0.00134365 0.0191187 0.105158 0.15228 0.147731 0.136482 0.123562 0.108418 0.0890786 0.0638323 0.0354637 0.0135421 0.00390391
 2013 1 1 0 0 1  2.62884e-06 8.3121e-05 0.00134194 0.0190957 0.105022 0.152136 0.147801 0.136708 0.123697 0.108415 0.0890297 0.0637917 0.0354416 0.0135339 0.00390151
 2014 1 1 0 0 1  2.62837e-06 8.31037e-05 0.00134153 0.0190841 0.104947 0.152001 0.147725 0.136832 0.123884 0.108481 0.0890084 0.0637597 0.0354231 0.013527 0.00389952
 2015 1 1 0 0 1  2.62814e-06 8.3102e-05 0.00134144 0.0190796 0.104892 0.151896 0.147621 0.136837 0.124041 0.108608 0.0890285 0.0637414 0.0354092 0.0135217 0.00389802
 2016 1 1 0 0 1  2.62846e-06 8.31109e-05 0.00134174 0.0190836 0.104897 0.151841 0.147524 0.136768 0.124103 0.108736 0.0890798 0.0637329 0.0353958 0.0135161 0.00389639
 2017 1 1 0 0 1  2.62903e-06 8.31328e-05 0.00134203 0.0190881 0.104915 0.151837 0.147461 0.136683 0.124087 0.108824 0.0891495 0.0637385 0.0353844 0.0135102 0.00389466
 2019 -1 1 0 0 1  2.62607e-06 8.30348e-05 0.00134058 0.0190712 0.104865 0.15184 0.147473 0.136608 0.12398 0.108857 0.0892944 0.0638112 0.0353836 0.0135007 0.00389096
 2020 -1 -1 0 0 1  2.62607e-06 8.30348e-05 0.00134058 0.0190712 0.104865 0.15184 0.147473 0.136608 0.12398 0.108857 0.0892944 0.0638112 0.0353836 0.0135007 0.00389096
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 0 2013265920 0 0 0 #_fleet:1_FISHERY
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

