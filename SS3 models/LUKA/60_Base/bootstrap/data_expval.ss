#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jan 05 21:15:59 2023
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
-999 1 1 0.87668 0.5
1967 1 1 0.878597 0.5
1968 1 1 3.09889 0.5
1969 1 1 0.957974 0.5
1970 1 1 0.337465 0.5
1971 1 1 0.000999985 0.5
1972 1 1 9.0643 0.5
1973 1 1 10.1531 0.5
1974 1 1 7.44504 0.5
1975 1 1 7.05505 0.5
1976 1 1 6.93109 0.5
1977 1 1 4.17934 0.5
1978 1 1 1.67189 0.5
1979 1 1 1.40837 0.5
1980 1 1 1.41019 0.5
1981 1 1 2.67932 0.5
1982 1 1 3.43635 0.5
1983 1 1 6.93623 0.5
1984 1 1 5.14434 0.5
1985 1 1 5.49771 0.5
1986 1 1 5.0091 0.5
1987 1 1 1.67689 0.5
1988 1 1 3.91714 0.467268
1989 1 1 2.77184 0.2
1990 1 1 1.39703 0.245355
1991 1 1 1.13759 0.221413
1992 1 1 0.56335 0.430176
1993 1 1 0.940284 0.324167
1994 1 1 1.84065 0.2
1995 1 1 2.07379 0.252915
1996 1 1 1.41655 0.498858
1997 1 1 2.58634 0.2
1998 1 1 0.427733 0.342705
1999 1 1 0.539311 0.5
2000 1 1 2.05202 0.27585
2001 1 1 2.88933 0.26062
2002 1 1 3.51573 0.207101
2003 1 1 1.14666 0.233131
2004 1 1 1.48322 0.5
2005 1 1 0.58331 0.5
2006 1 1 0.270336 0.5
2007 1 1 0.866347 0.5
2008 1 1 1.25643 0.5
2009 1 1 4.05505 0.2
2010 1 1 1.13532 0.2
2011 1 1 2.00122 0.5
2012 1 1 0.530241 0.5
2013 1 1 1.64878 0.5
2014 1 1 1.80617 0.442494
2015 1 1 1.84881 0.2
2016 1 1 0.564255 0.2
2017 1 1 0.361964 0.2
2018 1 1 0.236316 0.2
2019 1 1 0.342455 0.2
2020 1 1 0.263536 0.2
2021 1 1 0.171458 0.483547
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
2016 7 1 1.31554 0.2 #_orig_obs: 1.78809 FISHERY
2017 7 1 1.39704 0.208958 #_orig_obs: 1.14939 FISHERY
2018 7 1 1.46368 0.2 #_orig_obs: 1.38325 FISHERY
2019 7 1 1.50447 0.2 #_orig_obs: 1.83588 FISHERY
2020 7 1 1.52707 0.2 #_orig_obs: 1.12559 FISHERY
2021 7 1 1.54768 0.408432 #_orig_obs: 1.78588 FISHERY
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
 2004 1 1 0 0 235  0.72272 4.85037 21.3745 84.4834 99.2011 22.8579 1.26991 0.240115
 2005 1 1 0 0 147  0.43796 2.87879 12.7202 51.2424 63.2704 15.4457 0.854063 0.150448
 2006 1 1 0 0 147  0.422586 2.74187 12.0237 49.261 64.3249 17.0852 0.989366 0.151446
 2007 1 1 0 0 292  0.828135 5.33281 23.3692 95.3683 128.016 36.5178 2.26376 0.303652
 2008 1 1 0 0 346  0.990175 6.40298 27.9734 113.067 150.262 44.0583 2.88372 0.362254
 2009 1 1 0 0 456  1.3902 9.24389 39.993 154.942 192.384 53.9848 3.58524 0.476454
 2010 1 1 0 0 144  0.451609 3.04467 13.3326 51.4283 59.6035 15.0307 0.959516 0.149066
 2011 1 1 0 0 782  2.39884 16.1334 70.6974 277.509 328.939 80.6276 4.8888 0.806049
 2012 1 1 0 0 1255  3.75855 24.7931 109.899 439.299 535.695 132.535 7.73047 1.29055
 2013 1 1 0 0 2416  7.1179 46.731 204.331 824.231 1044.02 271.165 15.9115 2.48969
 2014 1 1 0 0 1062  3.17394 20.8936 91.4149 362.643 455.104 120.421 7.25234 1.09689
 2015 1 1 0 0 1023  3.09407 20.5481 89.6034 353.169 434.472 114.051 7.00496 1.05781
 2016 1 1 0 0 369  1.09681 7.23894 31.8416 127.025 157.622 41.2514 2.54208 0.381898
 2017 1 1 0 0 204  0.58546 3.80458 16.7627 68.3389 88.662 24.1365 1.49805 0.211861
 2018 1 1 0 0 170  0.476598 3.05391 13.4434 55.3729 74.6523 21.4592 1.36431 0.177465
 2019 1 1 0 0 212  0.587218 3.74365 16.4029 67.6849 93.2993 28.189 1.87009 0.222898
 2020 1 1 0 0 155  0.426685 2.71442 11.8958 48.991 68.0806 21.256 1.47143 0.164134
 2021 1 1 0 0 87  0.23794 1.51033 6.62478 27.3301 38.1756 12.1602 0.86833 0.0926526
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

