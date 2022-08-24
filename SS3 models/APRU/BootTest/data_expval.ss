#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Aug 24 09:11:04 2022
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
1967 1 1 0.0172399 0.5
1968 1 1 0.0603298 0.5
1969 1 1 0.0185999 0.5
1970 1 1 0.00679997 0.5
1971 1 1 0.000999996 0.5
1972 1 1 0.176899 0.5
1973 1 1 0.247209 0.5
1974 1 1 0.170999 0.5
1975 1 1 0.226339 0.5
1976 1 1 0.185069 0.5
1977 1 1 0.0816497 0.5
1978 1 1 0.0326599 0.5
1979 1 1 0.0276699 0.5
1980 1 1 0.661337 0.5
1981 1 1 1.25689 0.5
1982 1 1 1.61206 0.5
1983 1 1 3.25315 0.5
1984 1 1 2.4131 0.5
1985 1 1 2.57866 0.5
1986 1 1 1.56579 0.5
1987 1 1 0.465837 0.5
1988 1 1 1.15302 0.5
1989 1 1 0.585587 0.32586
1990 1 1 0.0648596 0.5
1991 1 1 0.121559 0.480854
1992 1 1 0.324318 0.5
1993 1 1 0.181889 0.5
1994 1 1 0.688546 0.363779
1995 1 1 0.433628 0.5
1996 1 1 1.3145 0.5
1997 1 1 1.29137 0.260358
1998 1 1 0.174629 0.5
1999 1 1 0.400978 0.5
2000 1 1 0.522537 0.5
2001 1 1 0.553377 0.348732
2002 1 1 2.20581 0.5
2003 1 1 0.248109 0.310752
2004 1 1 0.439078 0.5
2005 1 1 0.472188 0.5
2006 1 1 0.198669 0.5
2007 1 1 1.25372 0.5
2008 1 1 1.63836 0.5
2009 1 1 3.25269 0.2
2010 1 1 0.677666 0.273691
2011 1 1 1.18885 0.5
2012 1 1 0.347908 0.5
2013 1 1 1.33809 0.5
2014 1 1 1.63111 0.5
2015 1 1 1.8452 0.277979
2016 1 1 1.24011 0.218319
2017 1 1 1.56488 0.2
2018 1 1 0.902184 0.312542
2019 1 1 1.24374 0.34192
2020 1 1 0.239039 0.394157
2021 1 1 0.0335698 0.452443
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
2016 7 1 3.35952 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 3.3141 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 3.29508 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 3.30143 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 3.35143 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 3.48151 0.645341 #_orig_obs: 6.1639 FISHERY
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
 2007 1 1 0 0 93.44  0 0 4.54629 6.59552 10.8608 12.938 12.9861 11.9417 10.4275 8.69629 6.69941 4.44729 3.30117 0 0
 2008 1 1 0 0 80.72  0 1.47511 2.53768 5.78339 9.41214 11.1049 11.1469 10.298 9.01585 7.49929 5.77048 3.82994 1.96413 0.882185 0
 2009 1 1 0 0 110.2  0 0 0 13.9235 13.1144 15.1724 15.0248 13.864 12.1828 10.1346 7.78224 5.16182 2.64781 1.19177 0
 2010 1 1 0 0 41.16  0 0 0 5.40186 5.06399 5.75386 5.5682 5.06927 4.45293 3.71239 2.84748 1.88628 1.40375 0 0
 2011 1 1 0 0 61.32  0.290563 0.911669 2.0851 4.75783 7.67337 8.7606 8.3826 7.4898 6.52297 5.44453 4.1787 2.7649 1.41753 0.639848 0
 2012 1 1 0 0 93.24  0 1.79213 3.13063 7.18633 11.7114 13.549 13.0002 11.4504 9.80446 8.14408 6.2562 4.13784 2.11989 0.957517 0
 2013 1 1 0 0 50.04  0 0.954499 1.64799 3.79478 6.23307 7.3036 7.10815 6.25981 5.27323 4.32507 3.31587 3.82392 0 0 0
 2014 1 1 0 0 71.72  0 0 0 0 18.0997 10.4242 10.2442 9.10969 7.62226 6.15012 4.67898 3.0926 1.58317 0.563332 0.151717
 2015 1 1 0 0 99.28  0.479704 1.49071 3.37784 7.66534 12.3512 14.337 14.105 12.6648 10.6414 8.48323 6.37206 4.19552 2.14683 0.969366 0
 2016 1 1 0 0 80.64  0 1.62177 2.79569 6.33495 10.1663 11.6742 11.3611 10.2266 8.66482 6.88579 5.10332 3.33387 1.70294 0.768659 0
 2017 1 1 0 0 104.16  0.511136 1.59332 3.63406 8.26227 13.2829 15.2084 14.6592 13.0975 11.1494 8.8928 6.53107 4.22175 2.1476 0.763106 0.205411
 2019 -1 1 0 0 84.84  0 1.67408 2.90037 6.64053 10.8228 12.6008 12.2305 10.7888 9.01934 7.18549 5.26058 3.32472 2.39207 0 0
 2020 -1 -1 0 0 19.32  0 0.381227 0.66048 1.5122 2.46459 2.86948 2.78517 2.45685 2.05391 1.6363 2.49979 0 0 0 0
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

