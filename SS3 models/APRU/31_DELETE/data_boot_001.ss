#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Sep 28 08:10:08 2022
#_bootdata:_3
#C data file for APRU
#_bootstrap file: 1  irand_seed: 123 first rand#: 0.869031
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
#_catch_biomass(mtons):_columns_are_fisheries,year,season
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0 0.01
1967 1 1 0.0062017 0.5
1968 1 1 0.0593568 0.5
1969 1 1 0.0164918 0.5
1970 1 1 0.00890146 0.5
1971 1 1 0.000883229 0.5
1972 1 1 0.134795 0.5
1973 1 1 0.135495 0.5
1974 1 1 0.167312 0.5
1975 1 1 0.480726 0.5
1976 1 1 0.246022 0.5
1977 1 1 0.0609978 0.5
1978 1 1 0.0207805 0.5
1979 1 1 0.0431965 0.5
1980 1 1 0.327061 0.5
1981 1 1 0.706321 0.5
1982 1 1 1.87946 0.5
1983 1 1 5.1071 0.5
1984 1 1 2.33976 0.5
1985 1 1 1.38807 0.5
1986 1 1 1.48727 1.37929
1987 1 1 0.138851 1.72221
1988 1 1 3.66506 1.14764
1989 1 1 0.62038 0.32586
1990 1 1 0.0259516 1.55673
1991 1 1 0.0904212 0.480854
1992 1 1 0.119559 0.631432
1993 1 1 0.0370799 0.893326
1994 1 1 1.04726 0.363779
1995 1 1 0.210909 0.739593
1996 1 1 2.90009 0.578658
1997 1 1 0.82428 0.260358
1998 1 1 0.162447 0.523243
1999 1 1 0.476838 0.715748
2000 1 1 0.233106 0.508736
2001 1 1 0.493775 0.348732
2002 1 1 1.2325 0.511776
2003 1 1 0.463653 0.310752
2004 1 1 0.160294 1.47358
2005 1 1 0.359606 1.4286
2006 1 1 0.0354184 1.57732
2007 1 1 1.28345 0.790458
2008 1 1 1.76912 0.583292
2009 1 1 3.30683 0.190708
2010 1 1 0.587641 0.273691
2011 1 1 0.179222 0.781621
2012 1 1 0.018413 1.48954
2013 1 1 1.57383 1.04702
2014 1 1 1.12752 0.530542
2015 1 1 1.55787 0.277979
2016 1 1 1.6533 0.218319
2017 1 1 1.39438 0.168771
2018 1 1 1.15302 0.312542
2019 1 1 1.5094 0.34192
2020 1 1 0.463809 0.394157
2021 1 1 0.0377674 0.452443
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 5.03508 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 3.865 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 2.53109 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 1.33445 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 5.66868 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 3.31491 0.645341 #_orig_obs: 6.1639 FISHERY
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
-1 0.001 0 0 1 1 0.001 #_fleet:1_FISHERY
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 73  0 0 3 4 12 11 7 6 12 8 4 5 1 0 0
 2008 1 1 0 0 63  0 0 1 3 11 9 4 6 8 10 8 1 1 0 1
 2009 1 1 0 0 86  1 0 4 8 14 10 6 11 12 13 3 3 0 1 0
 2010 1 1 0 0 32  0 2 3 2 1 5 5 2 2 4 2 1 2 1 0
 2011 1 1 0 0 48  0 0 3 3 8 2 12 5 4 2 6 1 1 0 1
 2012 1 1 0 0 73  1 1 1 6 14 7 11 5 7 10 5 2 3 0 0
 2013 1 1 0 0 39  0 0 2 2 6 7 5 4 4 5 4 0 0 0 0
 2014 1 1 0 0 56  0 0 1 5 5 8 12 7 8 8 0 0 2 0 0
 2015 1 1 0 0 78  0 2 4 5 3 14 12 9 10 5 6 2 4 2 0
 2016 1 1 0 0 63  2 2 3 4 4 6 10 7 9 6 3 5 1 1 0
 2017 1 1 0 0 82  1 3 5 7 10 10 10 14 5 5 2 3 5 2 0
 2019 -1 1 0 0 66  0 1 5 6 9 11 10 8 4 5 4 2 1 0 0
 2020 -1 -1 0 0 15  0 0 0 2 2 5 1 1 1 0 2 0 1 0 0
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

