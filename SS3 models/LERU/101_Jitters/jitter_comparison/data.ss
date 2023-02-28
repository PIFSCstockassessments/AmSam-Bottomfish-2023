#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Dec 08 14:06:36 2022
#_echo_input_data
#C data file for LERU
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
#_Catch data: yr, seas, fleet, catch, catch_se
#_catch_se:  standard error of log(catch)
#_NOTE:  catch data is ignored for survey fleets
-999 1 1 0.34337 0.5
1967 1 1 0.34337 0.5
1968 1 1 1.21154 0.5
1969 1 1 0.37467 0.5
1970 1 1 0.132 0.5
1971 1 1 0.001 0.5
1972 1 1 3.54301 0.5
1973 1 1 4.95504 0.5
1974 1 1 3.42235 0.5
1975 1 1 4.53274 0.5
1976 1 1 3.70403 0.5
1977 1 1 1.63429 0.5
1978 1 1 0.65363 0.5
1979 1 1 0.55066 0.5
1980 1 1 1.44288 0.5
1981 1 1 2.74151 0.5
1982 1 1 3.51625 0.5
1983 1 1 7.0969 0.5
1984 1 1 5.26394 0.5
1985 1 1 5.62545 0.5
1986 1 1 4.18303 0.765988
1987 1 1 1.41521 1.04738
1988 1 1 2.42808 0.696621
1989 1 1 2.36004 0.181955
1990 1 1 1.12491 0.281466
1991 1 1 0.9666 0.227721
1992 1 1 1.38935 0.456647
1993 1 1 0.62641 0.58728
1994 1 1 1.52906 0.391316
1995 1 1 1.18977 0.464613
1996 1 1 2.1591 0.424734
1997 1 1 1.7105 0.30496
1998 1 1 0.23224 0.747716
1999 1 1 0.2903 0.880171
2000 1 1 1.43925 0.841994
2001 1 1 4.28826 0.539964
2002 1 1 2.88439 0.477013
2003 1 1 1.15847 0.45899
2004 1 1 1.38618 0.767216
2005 1 1 0.84912 1.06394
2006 1 1 0.391 1.1658
2007 1 1 1.61207 0.655467
2008 1 1 3.32483 0.327572
2009 1 1 7.03567 0.134277
2010 1 1 1.48642 0.189353
2011 1 1 3.66321 0.31116
2012 1 1 1.13443 0.777087
2013 1 1 2.21217 0.739423
2014 1 1 1.06231 0.343554
2015 1 1 3.07218 0.256762
2016 1 1 0.874984 0.176986
2017 1 1 0.61689 0.20531
2018 1 1 0.40324 0.140656
2019 1 1 0.81193 0.145786
2020 1 1 0.43545 0.123537
2021 1 1 0.19096 0.406754
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_yr month fleet obs stderr
2016 7 1 2.66545 0.209826 #_ FISHERY
2017 7 1 2.37861 0.21091 #_ FISHERY
2018 7 1 2.56887 0.2 #_ FISHERY
2019 7 1 3.64435 0.2 #_ FISHERY
2020 7 1 2.52009 0.2 #_ FISHERY
2021 7 1 5.68061 0.394811 #_ FISHERY
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
43 # maximum size in the population (lower edge of last bin) 
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
8 #_N_LengthBins; then enter lower edge of each length bin
 14 17.5 21 24.5 28 31.5 35 38.5
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 148.96 1 2 16 55 86 12 7 4 1 2 16 55 86 12 7 4
 2005 1 1 0 0 125.16 0 0 29 50 25 19 18 8 0 0 29 50 25 19 18 8
 2006 1 1 0 0 99.12 0 0 21 35 30 7 22 3 0 0 21 35 30 7 22 3
 2007 1 1 0 0 81.48 0 1 16 34 18 8 13 7 0 1 16 34 18 8 13 7
 2008 1 1 0 0 250.48 0 0 24 114 127 16 11 7 0 0 24 114 127 16 11 7
 2009 1 1 0 0 331.8 0 6 72 128 133 32 16 8 0 6 72 128 133 32 16 8
 2010 1 1 0 0 104.16 0 0 23 61 36 3 0 1 0 0 23 61 36 3 0 1
 2011 1 1 0 0 782.04 0 5 204 352 320 38 9 3 0 5 204 352 320 38 9 3
 2012 1 1 0 0 1329.72 0 49 306 622 445 67 51 43 0 49 306 622 445 67 51 43
 2013 1 1 0 0 1564.92 5 63 379 823 523 53 12 5 5 63 379 823 523 53 12 5
 2014 1 1 0 0 190.68 0 12 35 87 79 11 3 0 0 12 35 87 79 11 3 0
 2015 1 1 0 0 542.64 0 23 134 254 178 32 17 8 0 23 134 254 178 32 17 8
 2016 1 1 0 0 246.96 0 10 49 114 92 15 7 7 0 10 49 114 92 15 7 7
 2017 1 1 0 0 110.88 0 2 17 52 44 12 4 1 0 2 17 52 44 12 4 1
 2018 1 1 0 0 143.64 0 7 20 66 51 17 6 4 0 7 20 66 51 17 6 4
 2019 1 1 0 0 189.84 0 4 23 90 88 12 4 5 0 4 23 90 88 12 4 5
 2020 1 1 0 0 153.72 0 2 36 82 51 7 3 2 0 2 36 82 51 7 3 2
 2021 1 1 0 0 79.8 0 1 20 37 28 5 2 2 0 1 20 37 28 5 2 2
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
# 0 0 906663168 0 0 0 0 #_fleet:1_FISHERY
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

