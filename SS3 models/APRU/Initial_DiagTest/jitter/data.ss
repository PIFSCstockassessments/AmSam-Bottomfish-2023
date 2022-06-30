#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jun 30 12:18:35 2022
#_echo_input_data
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
2 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
 3 1 1 1 0 SURVEY2  # 2
#Bycatch_fleet_input_goes_next
#a:  fleet index
#b:  1=include dead bycatch in total dead catch for F0.1 and MSY optimizations and forecast ABC; 2=omit from total catch for these purposes (but still include the mortality)
#c:  1=Fmult scales with other fleets; 2=bycatch F constant at input value; 3=bycatch F from range of years
#d:  F or first year of range
#e:  last year of range
#f:  not used
# a   b   c   d   e   f 
#_Catch data: yr, seas, fleet, catch, catch_se
#_catch_se:  standard error of log(catch)
#_NOTE:  catch data is ignored for survey fleets
-999 1 1 0 0.01
1967 1 1 0.132 0.8
1968 1 1 0.39553 0.8
1969 1 1 0.17463 0.8
1970 1 1 0.0508 0.8
1971 1 1 0.001 0.8
1972 1 1 1.27323 0.8
1973 1 1 1.9949 0.8
1974 1 1 1.68373 0.8
1975 1 1 2.35868 0.8
1976 1 1 1.70868 0.8
1977 1 1 0.96933 0.8
1978 1 1 0.42365 0.8
1979 1 1 0.20139 0.8
1980 1 1 0.50303 0.8
1981 1 1 0.95572 0.8
1982 1 1 1.22561 0.8
1983 1 1 2.47434 0.8
1984 1 1 1.83523 0.8
1985 1 1 1.96133 0.8
1986 1 1 1.5658 1.37929
1987 1 1 0.46584 1.72221
1988 1 1 1.15303 1.14764
1989 1 1 0.58559 0.32586
1990 1 1 0.06486 1.55673
1991 1 1 0.12156 0.480854
1992 1 1 0.32432 0.631432
1993 1 1 0.18189 0.893326
1994 1 1 0.68855 0.363779
1995 1 1 0.43363 0.739593
1996 1 1 1.31451 0.578658
1997 1 1 1.29138 0.260358
1998 1 1 0.17463 0.523243
1999 1 1 0.40098 0.715748
2000 1 1 0.52254 0.508736
2001 1 1 0.55338 0.348732
2002 1 1 2.20582 0.511776
2003 1 1 0.24811 0.310752
2004 1 1 0.43908 1.47358
2005 1 1 0.47219 1.4286
2006 1 1 0.19867 1.57732
2007 1 1 1.25373 0.790458
2008 1 1 1.63837 0.583292
2009 1 1 3.25271 0.190708
2010 1 1 0.67767 0.273691
2011 1 1 1.18886 0.781621
2012 1 1 0.34791 1.48954
2013 1 1 1.3381 1.04702
2014 1 1 1.63112 0.530542
2015 1 1 1.84521 0.277979
2016 1 1 1.24012 0.218319
2017 1 1 1.56489 0.168771
2018 1 1 0.90219 0.312542
2019 1 1 1.24375 0.34192
2020 1 1 0.23904 0.394157
2021 1 1 0.03357 0.452443
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
2 1 0 0 # SURVEY2
#_yr month fleet obs stderr
1988 7 1 3.70645 0.489426 #_ FISHERY
1989 7 1 5.49199 0.729676 #_ FISHERY
1990 7 1 1.10748 0.853713 #_ FISHERY
1992 7 1 5.18226 0.457716 #_ FISHERY
1993 7 1 1.00065 0.714464 #_ FISHERY
1994 7 1 1.59015 0.614323 #_ FISHERY
1995 7 1 0.528473 0.644654 #_ FISHERY
1996 7 1 4.73445 0.477921 #_ FISHERY
1997 7 1 7.06332 0.383101 #_ FISHERY
1998 7 1 0.793054 0.67616 #_ FISHERY
1999 7 1 1.65329 0.581363 #_ FISHERY
2000 7 1 3.35781 0.976185 #_ FISHERY
2001 7 1 0.707368 0.44211 #_ FISHERY
2002 7 1 0.963076 0.480387 #_ FISHERY
2003 7 1 1.88285 0.723779 #_ FISHERY
2004 7 1 1.29318 0.351139 #_ FISHERY
2005 7 1 10.7255 0.622065 #_ FISHERY
2006 7 1 2.22126 0.642173 #_ FISHERY
2007 7 1 6.90685 0.337318 #_ FISHERY
2008 7 1 5.37106 0.310248 #_ FISHERY
2009 7 1 10.4479 0.2401 #_ FISHERY
2010 7 1 6.66353 0.368996 #_ FISHERY
2011 7 1 4.14165 0.349601 #_ FISHERY
2012 7 1 4.7997 0.634417 #_ FISHERY
2013 7 1 5.20988 0.433474 #_ FISHERY
2014 7 1 2.48537 0.319764 #_ FISHERY
2015 7 1 3.12103 0.346108 #_ FISHERY
2016 7 1 1.85248 0.375137 #_ FISHERY
2017 7 1 4.29875 0.285097 #_ FISHERY
2018 7 1 2.02387 0.387311 #_ FISHERY
2019 7 1 1.70224 0.390731 #_ FISHERY
2020 7 1 1.35222 0.614453 #_ FISHERY
2021 7 1 3.57363 0.866595 #_ FISHERY
1988 7 2 2.1729 0.791518 #_ SURVEY2
1991 7 2 2.52396 1.11725 #_ SURVEY2
1992 7 2 0.0605508 1.15792 #_ SURVEY2
1993 7 2 4.58493 0.545956 #_ SURVEY2
1994 7 2 5.47428 0.2302 #_ SURVEY2
1995 7 2 2.57859 0.375167 #_ SURVEY2
1996 7 2 4.73278 0.273422 #_ SURVEY2
1997 7 2 5.36372 0.30166 #_ SURVEY2
1998 7 2 4.2321 0.368185 #_ SURVEY2
1999 7 2 4.83965 0.257547 #_ SURVEY2
2000 7 2 1.3146 0.372201 #_ SURVEY2
2001 7 2 4.40709 0.396037 #_ SURVEY2
2002 7 2 7.67602 0.364653 #_ SURVEY2
2003 7 2 2.42308 0.537862 #_ SURVEY2
2004 7 2 5.90151 0.349352 #_ SURVEY2
2005 7 2 10.2967 0.240229 #_ SURVEY2
2006 7 2 8.53658 0.276418 #_ SURVEY2
2007 7 2 12.0813 0.188333 #_ SURVEY2
2008 7 2 5.43474 0.344704 #_ SURVEY2
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
110 # maximum size in the population (lower edge of last bin) 
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
0 1e-07 0 0 0 0 1 #_fleet:2_SURVEY2
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
20 #_N_LengthBins; then enter lower edge of each length bin
 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 93.44 0 0 0 0 0 3 6 37 35 23 27 19 12 8 5 1 0 0 0 0
 2008 1 1 0 0 79.8 0 0 0 0 0 2 11 12 8 13 14 8 4 10 6 4 2 0 1 0
 2009 1 1 0 0 110.04 0 0 0 0 0 0 12 14 16 18 17 15 13 12 5 4 5 0 0 0
 2010 1 1 0 0 41.16 0 0 0 0 0 0 7 4 7 8 5 3 8 2 3 2 0 0 0 0
 2011 1 1 0 0 61.32 0 0 0 1 7 1 7 12 11 4 9 3 6 3 1 7 1 0 0 0
 2012 1 1 0 0 86.52 0 0 0 0 1 11 6 19 20 14 15 3 7 4 2 0 1 0 0 0
 2013 1 1 0 0 49.56 0 0 0 0 2 1 2 7 13 6 8 5 5 6 4 0 0 0 0 0
 2014 1 1 0 0 72.24 0 0 0 0 0 0 0 4 15 13 13 12 12 5 8 1 1 1 1 0
 2015 1 1 0 0 99.12 0 0 0 3 0 6 9 11 17 18 15 15 9 7 3 1 4 0 0 0
 2016 1 1 0 0 81.48 0 0 0 0 1 1 5 25 12 8 6 11 11 7 5 2 2 0 0 1
 2017 1 1 0 0 105 1 0 0 1 2 4 6 29 20 13 12 11 9 9 4 2 1 1 0 0
 2018 1 1 0 0 38.64 0 0 0 0 0 2 7 4 11 7 2 2 4 4 1 2 0 0 0 0
 2019 1 1 0 0 65.52 0 0 0 0 0 4 2 2 12 13 9 19 6 8 2 1 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 67 67 0 0 0 #_fleet:1_FISHERY
# 0 0 0 0 0 0 0 #_fleet:2_SURVEY2
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
0 # do tags (0/1/2); where 2 allows entry of TG_min_recap
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

