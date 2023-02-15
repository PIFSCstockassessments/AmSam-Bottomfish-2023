#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 16:59:16 2023
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
-999 1 1 0 0.01
1967 1 1 0.01724 0.5
1968 1 1 0.0603298 0.5
1969 1 1 0.0186 0.5
1970 1 1 0.00679998 0.5
1971 1 1 0.000999998 0.5
1972 1 1 0.1769 0.5
1973 1 1 0.247209 0.5
1974 1 1 0.171 0.5
1975 1 1 0.226339 0.5
1976 1 1 0.18507 0.5
1977 1 1 0.0816498 0.5
1978 1 1 0.0326599 0.5
1979 1 1 0.0276699 0.5
1980 1 1 0.661338 0.5
1981 1 1 1.2569 0.5
1982 1 1 1.61207 0.5
1983 1 1 3.25315 0.5
1984 1 1 2.4131 0.5
1985 1 1 2.57866 0.5
1986 1 1 1.5658 0.5
1987 1 1 0.465839 0.5
1988 1 1 1.15303 0.5
1989 1 1 0.585588 0.32586
1990 1 1 0.0648598 0.5
1991 1 1 0.12156 0.480854
1992 1 1 0.324319 0.5
1993 1 1 0.181889 0.5
1994 1 1 0.688548 0.363779
1995 1 1 0.433629 0.5
1996 1 1 1.31451 0.5
1997 1 1 1.29138 0.260358
1998 1 1 0.174629 0.5
1999 1 1 0.400979 0.5
2000 1 1 0.522538 0.5
2001 1 1 0.553378 0.348732
2002 1 1 2.20581 0.5
2003 1 1 0.248109 0.310752
2004 1 1 0.439079 0.5
2005 1 1 0.472189 0.5
2006 1 1 0.198669 0.5
2007 1 1 1.25373 0.5
2008 1 1 1.63837 0.5
2009 1 1 3.2527 0.2
2010 1 1 0.677668 0.273691
2011 1 1 1.18886 0.5
2012 1 1 0.531159 0.5
2013 1 1 1.3381 0.5
2014 1 1 1.63112 0.5
2015 1 1 1.8452 0.277979
2016 1 1 1.42836 0.218319
2017 1 1 1.56489 0.2
2018 1 1 0.902187 0.312542
2019 1 1 1.24375 0.34192
2020 1 1 0.239039 0.394157
2021 1 1 0.0335699 0.452443
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
1988 7 2 3.07626 0.480853 #_orig_obs: 3.31766 SURVEY2
1989 7 2 3.08009 0.655261 #_orig_obs: 4.38344 SURVEY2
1990 7 2 3.1197 0.730541 #_orig_obs: 1.01195 SURVEY2
1991 7 2 3.17395 1.14118 #_orig_obs: 0.341136 SURVEY2
1992 7 2 3.21893 0.475798 #_orig_obs: 3.8732 SURVEY2
1993 7 2 3.26012 0.605981 #_orig_obs: 1.97042 SURVEY2
1994 7 2 3.28681 0.456141 #_orig_obs: 3.10011 SURVEY2
1995 7 2 3.3027 0.455237 #_orig_obs: 0.697241 SURVEY2
1996 7 2 3.29387 0.388859 #_orig_obs: 7.55531 SURVEY2
1997 7 2 3.25309 0.324699 #_orig_obs: 8.08944 SURVEY2
1998 7 2 3.24333 0.509816 #_orig_obs: 0.90584 SURVEY2
1999 7 2 3.25429 0.716144 #_orig_obs: 2.08778 SURVEY2
2000 7 2 3.24753 0.942537 #_orig_obs: 2.87446 SURVEY2
2001 7 2 3.23292 0.327502 #_orig_obs: 0.888636 SURVEY2
2002 7 2 3.16982 0.40469 #_orig_obs: 1.54778 SURVEY2
2003 7 2 3.13562 0.645976 #_orig_obs: 1.91066 SURVEY2
2004 7 2 3.17053 0.276477 #_orig_obs: 1.63569 SURVEY2
2005 7 2 3.21053 0.521236 #_orig_obs: 6.83968 SURVEY2
2006 7 2 3.26696 0.536235 #_orig_obs: 6.02226 SURVEY2
2007 7 2 3.27966 0.492058 #_orig_obs: 13.5906 SURVEY2
2008 7 2 3.22787 0.681538 #_orig_obs: 7.11609 SURVEY2
2009 7 2 3.1195 0.790196 #_orig_obs: 17.0292 SURVEY2
2010 7 2 3.06836 0.844219 #_orig_obs: 9.98222 SURVEY2
2011 7 2 3.10142 0.790559 #_orig_obs: 6.79409 SURVEY2
2012 7 2 3.14164 0.955451 #_orig_obs: 7.45462 SURVEY2
2013 7 2 3.16139 0.838519 #_orig_obs: 7.43068 SURVEY2
2014 7 2 3.11126 0.31081 #_orig_obs: 3.26671 SURVEY2
2015 7 2 3.06103 0.32666 #_orig_obs: 4.15589 SURVEY2
2016 7 3 3.32616 0.329584 #_orig_obs: 2.28554 SURVEY3
2017 7 3 3.33647 0.26785 #_orig_obs: 4.49428 SURVEY3
2018 7 3 3.33743 0.33701 #_orig_obs: 3.66234 SURVEY3
2019 7 3 3.32826 0.318631 #_orig_obs: 2.76398 SURVEY3
2020 7 3 3.32705 0.487403 #_orig_obs: 2.54184 SURVEY3
2021 7 3 3.37316 0.645362 #_orig_obs: 6.16292 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 137  0.449377 1.5567 3.19504 8.75327 17.4692 21.2105 19.2407 16.983 14.211 11.9717 9.75073 6.81253 3.60318 1.34745 0.4455
 2008 1 1 0 0 113  0.422463 1.2704 3.48412 7.67645 11.909 16.2412 16.8572 14.6439 12.3032 10.0593 8.03251 5.61929 2.98855 1.12159 0.370872
 2009 1 1 0 0 106  0.360094 1.51744 3.33059 8.35238 12.3594 12.9869 14.7617 14.1175 11.8734 9.56867 7.44721 5.17348 2.76274 1.04215 0.346261
 2010 1 1 0 0 39  0.140157 0.432188 1.46355 3.40785 4.9408 5.06885 4.73847 4.89625 4.38386 3.52712 2.68357 1.83796 0.981849 0.372563 0.124971
 2011 1 1 0 0 58  0.149055 0.768952 1.7136 4.99241 8.29738 8.0968 7.13213 6.57311 6.29923 5.24879 3.94428 2.65346 1.411 0.537645 0.182153
 2012 1 1 0 0 88  0.245364 0.604019 2.91929 7.14328 11.7705 13.7427 11.691 9.82303 9.01374 7.90229 6.00413 3.97465 2.09475 0.798671 0.272599
 2013 1 1 0 0 52  0.234873 0.456082 0.949672 3.63837 7.12531 7.89378 7.68873 6.26002 5.2595 4.6257 3.61392 2.38104 1.24071 0.4712 0.161076
 2014 1 1 0 0 73  0.246471 1.43309 1.97442 3.89737 7.81847 11.2921 11.0275 9.72427 7.79453 6.51107 5.17388 3.43489 1.77473 0.669168 0.22799
 2015 1 1 0 0 96  0.295305 0.965227 4.83563 9.05586 8.90781 11.4888 13.8825 12.9045 10.6707 8.46409 6.63208 4.44734 2.29483 0.861192 0.294187
 2016 1 1 0 0 76  0.237069 0.778278 1.97103 7.73017 12.3547 8.41045 8.85424 9.5766 8.42822 6.63189 5.0287 3.37347 1.74547 0.654706 0.22505
 2017 1 1 0 0 107  0.291917 1.15845 2.92004 7.35956 15.844 18.5852 12.2204 11.9126 11.701 9.5675 7.0884 4.69602 2.43016 0.911575 0.313149
 2018 1 1 0 0 52  0.169291 0.427708 1.46952 3.75116 6.08338 8.46396 8.1402 5.72051 5.38753 4.74911 3.54278 2.30879 1.1883 0.445322 0.152443
 2019 -1 1 0 0 81  0.260284 0.916152 2.57372 5.5693 8.69529 11.0748 11.4877 11.5462 9.1172 7.32202 5.78466 3.78395 1.91633 0.711029 0.241346
 2020 -1 -1 0 0 19  0.0610543 0.2149 0.603712 1.30638 2.03964 2.5978 2.69465 2.70836 2.1386 1.71751 1.3569 0.887592 0.44951 0.166785 0.0566119
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

