#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Oct 07 11:53:06 2022
#_expected_values
#C data file for PRFL
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
28 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0299395 0.5
1968 1 1 0.105688 0.5
1969 1 1 0.0326594 0.5
1970 1 1 0.0113398 0.5
1971 1 1 0.000999983 0.5
1972 1 1 0.308895 0.5
1973 1 1 0.432262 0.5
1974 1 1 0.298454 0.5
1975 1 1 0.395072 0.5
1976 1 1 0.322954 0.5
1977 1 1 0.142427 0.5
1978 1 1 0.0571488 0.5
1979 1 1 0.048079 0.5
1980 1 1 0.381463 0.5
1981 1 1 0.724825 0.5
1982 1 1 0.92939 0.5
1983 1 1 1.87601 0.5
1984 1 1 1.39158 0.5
1985 1 1 1.48727 0.5
1986 1 1 1.19062 1.5455
1987 1 1 0.32657 1.91043
1988 1 1 0.666743 1.48391
1989 1 1 0.138342 0.323813
1990 1 1 0.0154193 2.27603
1991 1 1 0.275769 0.419592
1992 1 1 0.0920765 1.35083
1993 1 1 0.205013 0.852752
1994 1 1 0.480795 0.51674
1995 1 1 0.450406 0.756735
1996 1 1 0.343809 1.31219
1997 1 1 0.9888 0.502527
1998 1 1 0.253552 0.429071
1999 1 1 0.359689 0.777907
2000 1 1 0.0929871 0.21265
2001 1 1 1.24326 0.460996
2002 1 1 0.735246 0.510285
2003 1 1 0.168734 1.00799
2004 1 1 0.258082 1.77669
2005 1 1 0.379188 1.56054
2006 1 1 0.0780177 2.06989
2007 1 1 0.195495 1.88739
2008 1 1 0.537036 1.19815
2009 1 1 1.24145 0.26664
2010 1 1 0.162835 0.356797
2011 1 1 0.355149 1.51772
2012 1 1 0.286212 1.76271
2013 1 1 0.275322 1.95832
2014 1 1 0.291652 1.48957
2015 1 1 0.554275 0.479778
2016 1 1 0.600083 0.28581
2017 1 1 0.0925274 0.336114
2018 1 1 0.160566 0.310018
2019 1 1 0.114757 0.378188
2020 1 1 0.0752982 0.407456
2021 1 1 0.0113849 0.3993
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
2016 7 1 0.87166 0.432947 #_orig_obs: 1.41068 FISHERY
2017 7 1 0.885415 0.450836 #_orig_obs: 0.490555 FISHERY
2018 7 1 0.936388 0.32038 #_orig_obs: 1.27344 FISHERY
2019 7 1 0.9811 0.407719 #_orig_obs: 0.697701 FISHERY
2020 7 1 1.02869 0.453066 #_orig_obs: 0.908041 FISHERY
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
53 # maximum size in the population (lower edge of last bin) 
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
10 #_N_LengthBins
 21 24 27 30 33 36 39 42 45 48
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 -1 1 0 0 98.28  2.26254 5.7673 13.4572 14.6628 17.1105 18.8589 15.6699 7.84688 2.22285 0.421095
 2012 -1 -1 0 0 83.16  1.91445 4.88002 11.3869 12.4069 14.4781 15.9576 13.2592 6.63966 1.88087 0.356311
 2013 1 1 0 0 87.36  1.96542 5.03178 11.7456 12.7675 15.0992 17.0768 14.252 7.06165 1.98479 0.375295
 2015 1 1 0 0 42  0.931648 2.35106 5.46479 5.96829 7.15381 8.29792 7.10278 3.55037 0.994032 0.185292
 2018 -1 1 0 0 46.2  0.95121 2.45327 5.77559 6.43655 7.88684 9.25197 8.01119 4.06481 1.15329 0.215293
 2019 1 -1 0 0 16.8  0.345895 0.892097 2.10021 2.34056 2.86794 3.36435 2.91316 1.47811 0.419377 0.0782882
 2020 -1 -1 0 0 11.76  0.242126 0.624468 1.47015 1.63839 2.00756 2.35505 2.03921 1.03468 0.293564 0.0548018
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 0 768 0 0 0 #_fleet:1_FISHERY
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

