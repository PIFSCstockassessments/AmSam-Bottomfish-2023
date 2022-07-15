#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Jul 13 12:35:04 2022
#_echo_input_data
#C data file for VALO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
14 #_Nages=accumulator age, first age is always age 0
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
#_Catch data: yr, seas, fleet, catch, catch_se
#_catch_se:  standard error of log(catch)
#_NOTE:  catch data is ignored for survey fleets
-999 1 1 0.06033 0.8
1967 1 1 0.06033 0.8
1968 1 1 0.18144 0.8
1969 1 1 0.08029 0.8
1970 1 1 0.02313 0.8
1971 1 1 0.001 0.8
1972 1 1 0.58468 0.8
1973 1 1 0.87815 0.8
1974 1 1 0.68538 0.8
1975 1 1 0.98203 0.8
1976 1 1 0.70896 0.8
1977 1 1 0.40733 0.8
1978 1 1 0.18189 0.8
1979 1 1 0.09117 0.8
1980 1 1 0.22725 0.8
1981 1 1 0.43182 0.8
1982 1 1 0.55384 0.8
1983 1 1 1.11357 0.8
1984 1 1 0.82599 0.8
1985 1 1 0.88269 0.8
1986 1 1 0.63458 1.89066
1987 1 1 0.20775 2.13046
1988 1 1 0.53615 1.61281
1989 1 1 0.46312 0.485919
1990 1 1 0.12564 1.16375
1991 1 1 0.22135 0.308736
1992 1 1 0.1261 1.17621
1993 1 1 0.14288 1.08471
1994 1 1 0.39145 0.777986
1995 1 1 0.34927 0.860831
1996 1 1 0.31162 1.36575
1997 1 1 0.6382 0.800719
1998 1 1 0.0635 1.11671
1999 1 1 0.21546 1.21675
2000 1 1 0.20548 0.819357
2001 1 1 0.27306 0.673833
2002 1 1 0.55157 0.59292
2003 1 1 0.72393 0.297211
2004 1 1 0.27714 1.73802
2005 1 1 0.13472 2.10174
2006 1 1 0.11748 1.86632
2007 1 1 0.27714 1.70221
2008 1 1 0.39463 1.38037
2009 1 1 0.55837 0.263973
2010 1 1 0.16692 0.524839
2011 1 1 0.26762 1.68139
2012 1 1 0.07847 2.25571
2013 1 1 0.34518 1.84286
2014 1 1 0.29257 1.01224
2015 1 1 0.15966 0.673679
2016 1 1 0.06305 0.309637
2017 1 1 0.05534 0.350369
2018 1 1 0.06486 0.183459
2019 1 1 0.18597 0.112564
2020 1 1 0.11204 0.246135
2021 1 1 0.01406 0.470573
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_yr month fleet obs stderr
1988 7 1 0.930074 0.499964 #_ FISHERY
1989 7 1 1.35506 0.522948 #_ FISHERY
1990 7 1 0.115415 1.04676 #_ FISHERY
1991 7 1 0.434803 0.492413 #_ FISHERY
1992 7 1 0.586534 0.482433 #_ FISHERY
1993 7 1 0.916928 0.392589 #_ FISHERY
1994 7 1 0.311752 0.421466 #_ FISHERY
1995 7 1 0.426315 0.473155 #_ FISHERY
1996 7 1 0.928147 0.369958 #_ FISHERY
1997 7 1 0.755967 0.327172 #_ FISHERY
1998 7 1 1.21197 0.57427 #_ FISHERY
1999 7 1 0.637893 0.576491 #_ FISHERY
2000 7 1 1.18782 0.479272 #_ FISHERY
2001 7 1 0.63754 0.529755 #_ FISHERY
2002 7 1 0.78313 0.301291 #_ FISHERY
2003 7 1 1.52633 0.426642 #_ FISHERY
2004 7 1 0.233839 0.389193 #_ FISHERY
2005 7 1 0.794056 0.971705 #_ FISHERY
2006 7 1 0.588551 0.467557 #_ FISHERY
2007 7 1 0.6252 0.213807 #_ FISHERY
2008 7 1 0.395589 0.302282 #_ FISHERY
2009 7 1 0.248598 0.271162 #_ FISHERY
2010 7 1 0.258855 0.337146 #_ FISHERY
2011 7 1 0.639174 0.261184 #_ FISHERY
2012 7 1 0.108106 0.550625 #_ FISHERY
2013 7 1 0.343492 0.395357 #_ FISHERY
2014 7 1 0.106014 0.276562 #_ FISHERY
2015 7 1 0.0927072 0.293861 #_ FISHERY
2016 7 1 0.0314149 0.72045 #_ FISHERY
2017 7 1 0.0359857 1.03692 #_ FISHERY
2018 7 1 0.0245587 1.31204 #_ FISHERY
2019 7 1 0.115337 0.619728 #_ FISHERY
2020 7 1 0.130659 0.77614 #_ FISHERY
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
48 # maximum size in the population (lower edge of last bin) 
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
16 #_N_LengthBins; then enter lower edge of each length bin
 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 62.16 0 0 0 0 1 1 13 24 25 4 2 0 1 2 1 0
 2012 1 1 0 0 72.24 0 0 0 0 0 0 5 7 11 18 21 11 9 2 2 0
 2013 1 1 0 0 66.36 0 0 0 0 0 0 1 10 13 13 18 14 5 2 1 2
 2014 1 1 0 0 49.56 0 0 0 0 0 1 10 13 9 11 6 5 3 0 1 0
 2015 1 1 0 0 84 0 0 0 0 0 4 8 19 19 13 12 15 4 4 1 1
 2015 1 2 0 0 36.12 1 2 0 2 5 6 12 3 2 3 1 0 3 3 0 0
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
# 0 0 0 351428608 0 0 0 #_fleet:1_FISHERY
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

