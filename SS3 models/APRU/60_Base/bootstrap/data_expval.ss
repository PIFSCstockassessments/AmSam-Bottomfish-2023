#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jan 05 21:15:58 2023
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
1970 1 1 0.00679998 0.5
1971 1 1 0.000999997 0.5
1972 1 1 0.176899 0.5
1973 1 1 0.247209 0.5
1974 1 1 0.170999 0.5
1975 1 1 0.226339 0.5
1976 1 1 0.185069 0.5
1977 1 1 0.0816497 0.5
1978 1 1 0.0326599 0.5
1979 1 1 0.0276699 0.5
1980 1 1 0.661338 0.5
1981 1 1 1.2569 0.5
1982 1 1 1.61206 0.5
1983 1 1 3.25315 0.5
1984 1 1 2.4131 0.5
1985 1 1 2.57866 0.5
1986 1 1 1.56579 0.5
1987 1 1 0.465838 0.5
1988 1 1 1.15303 0.5
1989 1 1 0.585588 0.32586
1990 1 1 0.0648597 0.5
1991 1 1 0.12156 0.480854
1992 1 1 0.324319 0.5
1993 1 1 0.181889 0.5
1994 1 1 0.688547 0.363779
1995 1 1 0.433628 0.5
1996 1 1 1.31451 0.5
1997 1 1 1.29138 0.260358
1998 1 1 0.174629 0.5
1999 1 1 0.400978 0.5
2000 1 1 0.522538 0.5
2001 1 1 0.553378 0.348732
2002 1 1 2.20581 0.5
2003 1 1 0.248109 0.310752
2004 1 1 0.439078 0.5
2005 1 1 0.472188 0.5
2006 1 1 0.198669 0.5
2007 1 1 1.25373 0.5
2008 1 1 1.63836 0.5
2009 1 1 3.2527 0.2
2010 1 1 0.677667 0.273691
2011 1 1 1.18886 0.5
2012 1 1 0.531159 0.5
2013 1 1 1.33809 0.5
2014 1 1 1.63111 0.5
2015 1 1 1.8452 0.277979
2016 1 1 1.42835 0.218319
2017 1 1 1.56488 0.2
2018 1 1 0.902186 0.312542
2019 1 1 1.24374 0.34192
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
#_year month index obs err
2016 7 1 3.35698 0.329584 #_orig_obs: 2.28554 FISHERY
2017 7 1 3.31895 0.26785 #_orig_obs: 4.49428 FISHERY
2018 7 1 3.30919 0.33701 #_orig_obs: 3.66234 FISHERY
2019 7 1 3.3177 0.318631 #_orig_obs: 2.76398 FISHERY
2020 7 1 3.35727 0.487403 #_orig_obs: 2.54184 FISHERY
2021 7 1 3.45356 0.645362 #_orig_obs: 6.16292 FISHERY
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
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 137  0.494396 1.56591 3.89857 9.73708 16.2509 18.927 18.7285 17.2392 15.2159 12.8815 10.0792 6.76801 3.49533 1.29155 0.426946
 2008 1 1 0 0 113  0.413276 1.31249 3.26471 8.12214 13.4339 15.5287 15.3698 14.2066 12.5669 10.6146 8.2978 5.57181 2.87891 1.06542 0.352877
 2009 1 1 0 0 106  0.398413 1.2756 3.16381 7.82064 12.7898 14.5677 14.2764 13.1939 11.7124 9.89387 7.72162 5.18311 2.67947 0.993211 0.330006
 2011 1 1 0 0 58  0.219329 0.707726 1.77188 4.42035 7.27115 8.19858 7.82043 7.05525 6.23071 5.28287 4.12186 2.76217 1.4285 0.531258 0.177928
 2012 1 1 0 0 88  0.330866 1.06009 2.66754 6.67776 11.0621 12.6027 12.0463 10.7395 9.36322 7.91624 6.18331 4.14273 2.14198 0.797523 0.268027
 2013 1 1 0 0 52  0.194967 0.624241 1.55833 3.90634 6.50253 7.47292 7.2194 6.43117 5.53342 4.6358 3.61802 2.42484 1.25355 0.467064 0.157406
 2014 1 1 0 0 73  0.276084 0.884123 2.20631 5.49181 9.08907 10.4608 10.1801 9.13657 7.81545 6.4661 5.02116 3.3648 1.73973 0.648656 0.219247
 2015 1 1 0 0 96  0.367313 1.18157 2.94221 7.30788 12.0025 13.6973 13.3401 12.0626 10.3484 8.47924 6.52455 4.36281 2.25613 0.841946 0.285514
 2016 1 1 0 0 76  0.292967 0.945226 2.36103 5.86049 9.59715 10.8661 10.4989 9.51188 8.21153 6.70826 5.11007 3.39957 1.757 0.656405 0.223428
 2017 1 1 0 0 107  0.413801 1.33686 3.34356 8.3165 13.6351 15.4019 14.7709 13.3075 11.5289 9.43995 7.13899 4.71468 2.43143 0.909218 0.310712
 2018 1 1 0 0 52  0.200757 0.647856 1.62365 4.04948 6.66395 7.54337 7.21297 6.44985 5.57278 4.57692 3.45088 2.26193 1.1619 0.434586 0.149113
 2019 -1 1 0 0 81  0.308898 0.992517 2.48756 6.22281 10.3162 11.8116 11.3963 10.1701 8.69259 7.11073 5.35741 3.47808 1.76848 0.659345 0.227504
 2020 -1 -1 0 0 19  0.0724575 0.232813 0.583501 1.45967 2.41984 2.77062 2.6732 2.38557 2.039 1.66795 1.25668 0.815845 0.414828 0.154661 0.053365
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

