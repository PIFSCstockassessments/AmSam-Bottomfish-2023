#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jul 01 08:01:38 2022
#_echo_input_data
#C data file for ETCO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
55 #_Nages=accumulator age, first age is always age 0
1 #_Nareas
2 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
 3 1 1 1 0 SURVEY2  # 2
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
-999 1 1 0 0.01
1967 1 1 0.21863 0.8
1968 1 1 0.65589 0.8
1969 1 1 0.28985 0.8
1970 1 1 0.08391 0.8
1971 1 1 0.001 0.8
1972 1 1 2.11238 0.8
1973 1 1 3.58791 0.8
1974 1 1 3.44322 0.8
1975 1 1 4.65521 0.8
1976 1 1 3.39105 0.8
1977 1 1 1.88649 0.8
1978 1 1 0.79515 0.8
1979 1 1 0.34428 0.8
1980 1 1 0.86046 0.8
1981 1 1 1.63475 0.8
1982 1 1 2.0965 0.8
1983 1 1 4.26875 0.8
1984 1 1 3.16653 0.8
1985 1 1 3.3838 0.8
1986 1 1 3.9594 0.80552
1987 1 1 0.79696 1.40981
1988 1 1 1.37393 1.03391
1989 1 1 0.66769 0.410435
1990 1 1 0.14334 1.09739
1991 1 1 0.31389 0.512413
1992 1 1 0.01361 2.31941
1993 1 1 0.83688 0.461778
1994 1 1 1.15893 0.213268
1995 1 1 1.38482 0.346758
1996 1 1 1.22606 0.55085
1997 1 1 1.95226 0.31522
1998 1 1 2.26977 0.258636
1999 1 1 0.96887 0.413156
2000 1 1 0.33384 0.459847
2001 1 1 2.09696 0.35261
2002 1 1 0.67313 0.619048
2003 1 1 0.47174 0.463612
2004 1 1 0.71577 1.1729
2005 1 1 1.30634 0.827787
2006 1 1 0.21772 1.5236
2007 1 1 1.36078 0.737086
2008 1 1 2.04116 0.482475
2009 1 1 3.25044 0.22864
2010 1 1 0.82735 0.338195
2011 1 1 2.45348 0.52926
2012 1 1 0.39644 1.41111
2013 1 1 1.27006 1.06936
2014 1 1 2.30788 0.375471
2015 1 1 1.92323 0.230871
2016 1 1 2.40313 0.209085
2017 1 1 1.51409 0.207125
2018 1 1 1.51999 0.227297
2019 1 1 0.62369 0.287378
2020 1 1 0.63321 0.357784
2021 1 1 0.15558 0.627146
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
2 1 0 0 # SURVEY2
#_yr month fleet obs stderr
1988 7 1 1.47134 0.416735 #_ FISHERY
1989 7 1 0.889127 1.70635 #_ FISHERY
1990 7 1 0.351358 0.879164 #_ FISHERY
1991 7 1 0.164642 1.16219 #_ FISHERY
1992 7 1 0.0611734 1.73981 #_ FISHERY
1993 7 1 0.490663 0.59096 #_ FISHERY
1994 7 1 0.358927 0.701231 #_ FISHERY
1995 7 1 0.45325 0.488355 #_ FISHERY
1996 7 1 1.19173 0.470644 #_ FISHERY
1997 7 1 1.66762 0.430673 #_ FISHERY
1998 7 1 2.93136 0.372857 #_ FISHERY
1999 7 1 0.410025 0.466984 #_ FISHERY
2000 7 1 0.542551 1.70812 #_ FISHERY
2001 7 1 0.317369 0.39145 #_ FISHERY
2002 7 1 0.0266645 0.713525 #_ FISHERY
2003 7 1 0.881848 0.691406 #_ FISHERY
2004 7 1 1.02335 0.386145 #_ FISHERY
2005 7 1 8.71554 0.643569 #_ FISHERY
2006 7 1 1.64303 1.07895 #_ FISHERY
2007 7 1 3.7442 0.315884 #_ FISHERY
2008 7 1 5.05068 0.347783 #_ FISHERY
2009 7 1 3.92162 0.305632 #_ FISHERY
2010 7 1 3.11123 0.378748 #_ FISHERY
2011 7 1 2.84612 0.354221 #_ FISHERY
2012 7 1 1.3242 0.75616 #_ FISHERY
2013 7 1 5.46403 0.358011 #_ FISHERY
2014 7 1 3.48702 0.275789 #_ FISHERY
2015 7 1 2.24432 0.290251 #_ FISHERY
2016 7 1 1.94824 0.341723 #_ FISHERY
2017 7 1 1.7718 0.364093 #_ FISHERY
2018 7 1 1.74527 0.33574 #_ FISHERY
2019 7 1 0.932234 0.465662 #_ FISHERY
2020 7 1 2.71949 0.617693 #_ FISHERY
2021 7 1 0.81227 1.57684 #_ FISHERY
1988 7 2 32.8459 0.238617 #_ SURVEY2
1989 7 2 16.7751 0.271511 #_ SURVEY2
1990 7 2 5.88237 0.358134 #_ SURVEY2
1992 7 2 0.32524 1.03312 #_ SURVEY2
1993 7 2 6.61775 0.504012 #_ SURVEY2
1994 7 2 23.8216 0.09967 #_ SURVEY2
1995 7 2 16.5171 0.144747 #_ SURVEY2
1996 7 2 24.427 0.117245 #_ SURVEY2
1997 7 2 14.8011 0.179388 #_ SURVEY2
1998 7 2 16.2207 0.227322 #_ SURVEY2
1999 7 2 13.8729 0.193882 #_ SURVEY2
2000 7 2 10.7463 0.277611 #_ SURVEY2
2001 7 2 13.3839 0.19434 #_ SURVEY2
2002 7 2 14.8153 0.227496 #_ SURVEY2
2003 7 2 26.8219 0.224685 #_ SURVEY2
2004 7 2 14.9899 0.197887 #_ SURVEY2
2005 7 2 19.3992 0.151216 #_ SURVEY2
2006 7 2 10.4828 0.235811 #_ SURVEY2
2007 7 2 21.2877 0.135612 #_ SURVEY2
2008 7 2 7.16912 0.39275 #_ SURVEY2
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
120 # maximum size in the population (lower edge of last bin) 
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
0 1e-07 0 0 0 0 1 #_fleet:2_SURVEY2
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
19 #_N_LengthBins; then enter lower edge of each length bin
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 66.52 0 1 1 3 10 33 29 25 24 14 18 13 10 1 0 0 0 0 0
 2008 1 1 0 0 78.12 0 0 3 6 5 6 9 8 12 10 9 13 10 1 0 1 0 0 0
 2009 1 1 0 0 87.36 0 2 4 2 2 5 14 10 13 10 15 15 7 3 2 0 0 0 0
 2011 1 1 0 0 61.32 2 2 3 18 3 4 4 2 5 6 2 10 9 1 0 1 0 0 1
 2012 1 1 0 0 47.88 0 0 8 0 4 2 5 6 9 5 9 7 2 0 0 0 0 0 0
 2013 1 1 0 0 50.4 2 0 0 6 2 8 12 7 3 8 3 4 1 4 0 0 0 0 0
 2014 1 1 0 0 108.36 3 2 5 7 4 3 5 16 16 15 16 18 9 7 2 1 0 0 0
 2015 1 1 0 0 64.68 1 0 0 1 5 5 2 9 8 8 9 16 8 3 0 2 0 0 0
 2016 1 1 0 0 57.96 1 2 4 0 0 0 2 5 8 8 10 18 8 1 1 1 0 0 0
 2017 1 1 0 0 37.8 0 0 0 0 1 1 3 6 11 3 8 5 5 2 0 0 0 0 0
 2018 1 1 0 0 52.08 1 5 2 2 3 4 3 7 10 6 9 7 3 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 67 67 0 0 0 #_fleet:1_FISHERY
# 0 0 0 0 0 0 0 #_fleet:2_SURVEY2
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

