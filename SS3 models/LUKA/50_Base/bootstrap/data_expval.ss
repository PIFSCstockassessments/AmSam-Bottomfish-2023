#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Oct 19 12:25:59 2022
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
-999 1 1 0.876526 0.5
1967 1 1 0.878596 0.5
1968 1 1 3.09889 0.5
1969 1 1 0.957973 0.5
1970 1 1 0.337464 0.5
1971 1 1 0.000999984 0.5
1972 1 1 9.06465 0.5
1973 1 1 9.25329 0.5
1974 1 1 6.94608 0.5
1975 1 1 6.61241 0.5
1976 1 1 6.52677 0.5
1977 1 1 4.17935 0.5
1978 1 1 1.67189 0.5
1979 1 1 1.40836 0.5
1980 1 1 1.41019 0.5
1981 1 1 2.67932 0.5
1982 1 1 3.43634 0.5
1983 1 1 6.93634 0.5
1984 1 1 5.14437 0.5
1985 1 1 5.49774 0.5
1986 1 1 5.00912 0.5
1987 1 1 1.67688 0.5
1988 1 1 3.91714 0.467268
1989 1 1 2.77183 0.2
1990 1 1 1.39703 0.245355
1991 1 1 1.13759 0.221413
1992 1 1 0.563349 0.430176
1993 1 1 0.940284 0.324167
1994 1 1 1.84065 0.2
1995 1 1 2.07378 0.252915
1996 1 1 1.41654 0.498858
1997 1 1 2.58633 0.2
1998 1 1 0.427732 0.342705
1999 1 1 0.539311 0.5
2000 1 1 2.05202 0.27585
2001 1 1 2.88933 0.26062
2002 1 1 3.51573 0.207101
2003 1 1 1.14666 0.233131
2004 1 1 1.48322 0.5
2005 1 1 0.583309 0.5
2006 1 1 0.270335 0.5
2007 1 1 0.866346 0.5
2008 1 1 1.25643 0.5
2009 1 1 4.05505 0.2
2010 1 1 1.13532 0.2
2011 1 1 2.00121 0.5
2012 1 1 0.53024 0.5
2013 1 1 1.64878 0.5
2014 1 1 1.80617 0.442494
2015 1 1 1.84881 0.2
2016 1 1 0.564254 0.2
2017 1 1 0.361964 0.2
2018 1 1 0.236316 0.2
2019 1 1 0.342455 0.2
2020 1 1 0.263536 0.2
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
#_year month index obs err
2016 7 1 1.30685 0.2 #_orig_obs: 1.78752 FISHERY
2017 7 1 1.39352 0.208986 #_orig_obs: 1.14899 FISHERY
2018 7 1 1.4646 0.2 #_orig_obs: 1.38275 FISHERY
2019 7 1 1.50834 0.2 #_orig_obs: 1.83557 FISHERY
2020 7 1 1.53251 0.2 #_orig_obs: 1.12553 FISHERY
2021 7 1 1.554 0.408433 #_orig_obs: 1.78568 FISHERY
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
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
8 #_N_LengthBins
 14 16 18 20 22 24 26 28
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 247.96  0.761489 5.14971 22.8047 90.1377 104.295 23.2951 1.264 0.252693
 2005 1 1 0 0 155.4  0.460693 3.05536 13.57 54.7055 66.7261 15.8671 0.856609 0.158625
 2006 1 1 0 0 121.8  0.34705 2.26581 10.0168 41.1481 53.253 13.858 0.786143 0.125159
 2007 1 1 0 0 276.08  0.774416 5.01331 22.1268 90.7371 121.076 33.9925 2.07335 0.28641
 2008 1 1 0 0 295.88  0.83733 5.44267 23.9476 97.2032 128.548 37.1889 2.4032 0.309121
 2009 1 1 0 0 469.56  1.42234 9.52201 41.4504 160.738 197.721 54.628 3.58803 0.489594
 2010 1 1 0 0 152.88  0.477734 3.24616 14.3027 55.1828 63.0187 15.5163 0.977689 0.157883
 2011 1 1 0 0 811.44  2.48311 16.8024 74.0542 290.881 340.243 81.294 4.84823 0.83437
 2012 1 1 0 0 1333.92  3.97791 26.4696 117.802 471.381 567.993 137.086 7.84111 1.36828
 2013 1 1 0 0 2562.84  7.50481 49.6201 218.517 881.933 1105.39 281.063 16.1799 2.63441
 2014 1 1 0 0 1043.28  3.09802 20.5525 90.4954 359.603 446.062 115.554 6.84031 1.07486
 2015 1 1 0 0 1056.72  3.17755 21.2473 93.3106 368.298 447.732 114.922 6.94247 1.08992
 2016 1 1 0 0 338.52  0.999619 6.63946 29.3877 117.567 144.38 36.9577 2.23899 0.349472
 2017 1 1 0 0 164.64  0.46848 3.06119 13.5705 55.5213 71.5513 19.129 1.16763 0.170575
 2018 1 1 0 0 157.92  0.437989 2.82187 12.5008 51.6963 69.385 19.6798 1.23373 0.164504
 2019 1 1 0 0 215.88  0.590628 3.7819 16.6939 69.1994 95.0789 28.4418 1.8669 0.226567
 2020 1 1 0 0 164.64  0.447316 2.85599 12.6066 52.2044 72.388 22.423 1.54052 0.174093
 2021 1 1 0 0 91.56  0.247076 1.5733 6.9484 28.8276 40.2282 12.7339 0.904132 0.0974004
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
# 0 0 1744830464 0 0 0 0 #_fleet:1_FISHERY
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

