#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Dec 14 16:44:42 2022
#_expected_values
#C data file for VALO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
15 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0131496 0.5
1968 1 1 0.0467187 0.5
1969 1 1 0.0145096 0.5
1970 1 1 0.00498984 0.5
1971 1 1 0.000999968 0.5
1972 1 1 0.136075 0.5
1973 1 1 0.190053 0.5
1974 1 1 0.131535 0.5
1975 1 1 0.174173 0.5
1976 1 1 0.142424 0.5
1977 1 1 0.0625972 0.5
1978 1 1 0.0249489 0.5
1979 1 1 0.021319 0.5
1980 1 1 0.21545 0.5
1981 1 1 0.409121 0.5
1982 1 1 0.524784 0.5
1983 1 1 1.05953 0.5
1984 1 1 0.786008 0.5
1985 1 1 0.839973 0.5
1986 1 1 0.626784 0.5
1987 1 1 0.202265 0.5
1988 1 1 0.533347 0.5
1989 1 1 0.460779 0.488049
1990 1 1 0.125169 0.5
1991 1 1 0.220422 0.309938
1992 1 1 0.125626 0.5
1993 1 1 0.143327 0.5
1994 1 1 0.387339 0.5
1995 1 1 0.353322 0.5
1996 1 1 0.313865 0.5
1997 1 1 0.64541 0.5
1998 1 1 0.0644042 0.5
1999 1 1 0.217703 0.5
2000 1 1 0.207275 0.5
2001 1 1 0.274401 0.5
2002 1 1 0.554253 0.5
2003 1 1 0.725236 0.296677
2004 1 1 0.279385 0.5
2005 1 1 0.136068 0.5
2006 1 1 0.122011 0.5
2007 1 1 0.280301 0.5
2008 1 1 0.397323 0.5
2009 1 1 0.561051 0.262737
2010 1 1 0.169177 0.5
2011 1 1 0.27168 0.5
2012 1 1 0.0798244 0.5
2013 1 1 0.348788 0.5
2014 1 1 0.294361 0.5
2015 1 1 0.161469 0.5
2016 1 1 0.0630461 0.309637
2017 1 1 0.0557868 0.347708
2018 1 1 0.0648565 0.2
2019 1 1 0.18596 0.2
2020 1 1 0.112484 0.24518
2021 1 1 0.0140593 0.470573
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
2016 7 1 0.110401 0.554733 #_orig_obs: 0.0720188 FISHERY
2017 7 1 0.119544 0.764977 #_orig_obs: 0.0882858 FISHERY
2018 7 1 0.127361 1.02772 #_orig_obs: 0.0365718 FISHERY
2019 7 1 0.131032 0.48149 #_orig_obs: 0.207781 FISHERY
2020 7 1 0.132604 0.59806 #_orig_obs: 0.196344 FISHERY
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
57 # maximum size in the population (lower edge of last bin) 
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
13 #_N_LengthBins
 15 18 21 24 27 30 33 36 39 42 45 48 51
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 59  0.269911 0.830473 6.63381 9.85565 11.3903 10.3199 7.85976 5.48413 3.43845 1.81536 0.748631 0.252546 0.101174 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 68  0.29894 0.929834 7.43567 11.0017 12.7265 11.9925 9.50449 6.63698 4.05861 2.11518 0.879318 0.300548 0.119784 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 63  0.273719 0.830122 6.59527 9.81184 11.5434 11.0249 9.02531 6.54025 4.03031 2.06814 0.851417 0.290598 0.114748 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 47  0.206557 0.636703 5.06246 7.39995 8.43025 8.00397 6.62254 4.92933 3.12368 1.61505 0.659318 0.222853 0.0873429 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 79  0.340874 1.05542 8.41697 12.4528 14.343 13.3901 10.9279 8.2133 5.34128 2.82133 1.15882 0.388333 0.149851 0 0 0 0 0 0 0 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 116736 116736 0 0 0 #_fleet:1_FISHERY
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

