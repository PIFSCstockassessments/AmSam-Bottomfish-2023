#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Jan 11 17:01:38 2023
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
1979 1 1 0.0253993 0.5
1980 1 1 0.37647 0.5
1981 1 1 0.715751 0.5
1982 1 1 0.917593 0.5
1983 1 1 1.85195 0.5
1984 1 1 1.37384 0.5
1985 1 1 1.46782 0.5
1986 1 1 0.672429 0.5
1987 1 1 0.136017 0.5
1988 1 1 0.357122 0.5
1989 1 1 0.214496 0.46734
1990 1 1 0.158212 0.5
1991 1 1 0.0444273 0.2
1992 1 1 0.126059 0.5
1993 1 1 0.0943253 0.5
1994 1 1 0.2975 0.2
1995 1 1 0.175504 0.5
1996 1 1 0.190927 0.5
1997 1 1 0.319732 0.5
1998 1 1 0.170974 0.5
1999 1 1 0.114745 0.5
2000 1 1 0.0594137 0.2
2001 1 1 0.0771033 0.5
2002 1 1 0.0576058 0.5
2003 1 1 0.0571464 0.5
2004 1 1 0.0857252 0.5
2005 1 1 0.165552 0.5
2006 1 1 0.0612271 0.5
2007 1 1 0.130624 0.5
2008 1 1 0.25582 0.5
2009 1 1 0.0943462 0.329973
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
2016 7 1 0.600876 0.257633 #_orig_obs: 0.864366 FISHERY
2017 7 1 0.594673 0.28097 #_orig_obs: 0.765316 FISHERY
2018 7 1 0.596383 0.303678 #_orig_obs: 0.49539 FISHERY
2019 7 1 0.608514 0.541214 #_orig_obs: 0.195021 FISHERY
2020 7 1 0.624561 0.585558 #_orig_obs: 0.241016 FISHERY
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
 2007 1 1 0 0 57  0.353001 0.491465 2.30898 5.68771 6.55908 7.95671 8.08143 8.15041 7.37791 5.4142 3.03661 1.20812 0.374387 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38  0.218108 0.303059 1.42394 3.5124 4.07759 4.98581 5.13931 5.32838 5.09205 4.02524 2.45428 1.07512 0.364722 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 16  0.0918349 0.127604 0.599555 1.4789 1.71688 2.09929 2.16392 2.24353 2.14402 1.69484 1.03338 0.452682 0.153567 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13  0.0746159 0.103678 0.487138 1.20161 1.39497 1.70567 1.75818 1.82287 1.74202 1.37705 0.839621 0.367804 0.124773 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 62  0.332382 0.460174 2.14857 5.3016 6.20372 7.69941 8.15746 8.7263 8.62795 7.07746 4.48114 2.05285 0.730982 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16  0.085776 0.118754 0.55447 1.36816 1.60096 1.98695 2.10515 2.25195 2.22657 1.82644 1.15642 0.529767 0.18864 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 6  0.032166 0.0445329 0.207926 0.513058 0.60036 0.745105 0.789431 0.84448 0.834963 0.684916 0.433658 0.198663 0.0707402 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 68  0.358182 0.495045 2.29824 5.65141 6.56982 8.11363 8.6043 9.36925 9.58562 8.16429 5.34099 2.52329 0.925941 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 32  0.168556 0.232963 1.08152 2.65949 3.09168 3.81818 4.04908 4.40906 4.51088 3.84202 2.51341 1.18743 0.435737 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 61  0.324231 0.448703 2.08999 5.1278 5.90178 7.23485 7.63077 8.29864 8.541 7.35256 4.86401 2.32389 0.861763 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 0 0 0 45492736 0 0 0 #_fleet:1_FISHERY
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

