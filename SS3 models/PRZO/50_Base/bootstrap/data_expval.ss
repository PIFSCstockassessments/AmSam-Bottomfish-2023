#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Oct 19 12:27:53 2022
#_expected_values
#C data file for PRZO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
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
1967 1 1 0.0158796 0.5
1968 1 1 0.0562487 0.5
1969 1 1 0.0172396 0.5
1970 1 1 0.00634985 0.5
1971 1 1 0.000999977 0.5
1972 1 1 0.164646 0.5
1973 1 1 0.230415 0.5
1974 1 1 0.159206 0.5
1975 1 1 0.210465 0.5
1976 1 1 0.172356 0.5
1977 1 1 0.075748 0.5
1978 1 1 0.0303892 0.5
1979 1 1 0.0253994 0.5
1980 1 1 0.37647 0.5
1981 1 1 0.715751 0.5
1982 1 1 0.917593 0.5
1983 1 1 1.85195 0.5
1984 1 1 1.37384 0.5
1985 1 1 1.46776 0.5
1986 1 1 0.67144 0.5
1987 1 1 0.13602 0.5
1988 1 1 0.357019 0.5
1989 1 1 0.214473 0.46734
1990 1 1 0.158215 0.5
1991 1 1 0.0444287 0.2
1992 1 1 0.126061 0.5
1993 1 1 0.0943265 0.5
1994 1 1 0.297503 0.2
1995 1 1 0.175506 0.5
1996 1 1 0.190929 0.5
1997 1 1 0.319734 0.5
1998 1 1 0.170976 0.5
1999 1 1 0.114746 0.5
2000 1 1 0.059414 0.2
2001 1 1 0.0771036 0.5
2002 1 1 0.0576059 0.5
2003 1 1 0.0571465 0.5
2004 1 1 0.0857254 0.5
2005 1 1 0.165552 0.5
2006 1 1 0.0612272 0.5
2007 1 1 0.130624 0.5
2008 1 1 0.25582 0.5
2009 1 1 0.0943463 0.329973
2010 1 1 0.0857268 0.318367
2011 1 1 0.0757473 0.5
2012 1 1 0.0317459 0.5
2013 1 1 0.0734776 0.5
2014 1 1 0.127006 0.5
2015 1 1 0.109767 0.5
2016 1 1 0.259444 0.2
2017 1 1 0.244933 0.2
2018 1 1 0.126546 0.218618
2019 1 1 0.0716678 0.273842
2020 1 1 0.0503485 0.418
2021 1 1 0.00637732 0.453778
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
2016 7 1 0.601656 0.257651 #_orig_obs: 0.865238 FISHERY
2017 7 1 0.59526 0.281029 #_orig_obs: 0.765871 FISHERY
2018 7 1 0.596736 0.30382 #_orig_obs: 0.495486 FISHERY
2019 7 1 0.608583 0.541224 #_orig_obs: 0.195278 FISHERY
2020 7 1 0.624345 0.585509 #_orig_obs: 0.24163 FISHERY
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
44 # maximum size in the population (lower edge of last bin) 
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
 16 18 20 22 24 26 28 30 32 34 36 38 40
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 48  0.316292 0.441897 2.04503 4.88285 5.49685 6.61962 6.72198 6.79916 6.18404 4.5634 2.57512 1.03174 0.322016 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38.64  0.236376 0.329703 1.52697 3.6508 4.13567 5.01805 5.16723 5.36661 5.14625 4.08498 2.50125 1.10081 0.375291 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 15.96  0.0976334 0.136182 0.630703 1.50794 1.70821 2.07267 2.13429 2.21664 2.12563 1.68728 1.03313 0.454683 0.155012 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13.44  0.0822176 0.114679 0.531119 1.26984 1.43849 1.74541 1.7973 1.86665 1.79 1.42086 0.870002 0.382891 0.130536 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 64.68  0.370037 0.514441 2.36942 5.66801 6.47306 7.97087 8.42992 9.02089 8.93554 7.34961 4.66693 2.14484 0.766419 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16.8  0.0961136 0.133621 0.615434 1.47221 1.68131 2.07036 2.18959 2.34309 2.32092 1.90899 1.21219 0.557102 0.19907 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 5.88  0.0336398 0.0467674 0.215402 0.515273 0.58846 0.724625 0.766357 0.820081 0.812322 0.668146 0.424267 0.194986 0.0696745 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 63.48  0.357016 0.495493 2.26909 5.40934 6.13684 7.5203 7.96253 8.67358 8.8852 7.58163 4.96965 2.35335 0.865988 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 31.08  0.174796 0.242595 1.11095 2.64843 3.00461 3.68196 3.89848 4.24661 4.35022 3.71199 2.43316 1.15221 0.423991 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 58.8  0.333802 0.463858 2.13088 5.06782 5.69053 6.92283 7.29189 7.9337 8.17551 7.04964 4.67165 2.23649 0.831391 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 34.44  0.191615 0.26622 1.22652 2.93354 3.34453 4.08974 4.28026 4.6035 4.73363 4.12455 2.77594 1.35532 0.514631 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 7.56  0.0420619 0.0584385 0.269236 0.643949 0.734164 0.897748 0.93957 1.01052 1.03909 0.905389 0.609354 0.297508 0.112968 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 5.04  0.0280412 0.038959 0.179491 0.429299 0.489443 0.598499 0.62638 0.673683 0.692726 0.603593 0.406236 0.198339 0.0753119 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 0 0 18153728 0 0 0 0 #_fleet:1_FISHERY
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

