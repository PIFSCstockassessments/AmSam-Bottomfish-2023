#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jun 17 12:27:18 2022
#_echo_input_data
#C data file for APVI
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1988 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
32 #_Nages=accumulator age, first age is always age 0
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
-999 1 1 0 0.01
1988 1 1 1.32086 1.0556
1989 1 1 1.05324 0.250473
1990 1 1 0.55565 0.435616
1991 1 1 1.13806 0.234849
1992 1 1 0.76702 0.357252
1993 1 1 0.96797 0.333495
1994 1 1 1.58712 0.202063
1995 1 1 1.35942 0.336023
1996 1 1 1.97086 0.387366
1997 1 1 1.5785 0.214793
1998 1 1 0.2531 0.412477
1999 1 1 0.48761 0.65065
2000 1 1 1.78126 0.462061
2001 1 1 0.99246 0.326622
2002 1 1 1.54403 0.328972
2003 1 1 0.44316 0.168046
2004 1 1 1.14759 0.875579
2005 1 1 0.72756 1.15885
2006 1 1 0.39916 1.1507
2007 1 1 1.30453 0.758785
2008 1 1 2.35187 0.426328
2009 1 1 4.39531 0.144623
2010 1 1 0.77065 0.313912
2011 1 1 1.51454 0.647973
2012 1 1 0.46312 1.31425
2013 1 1 1.88785 0.825895
2014 1 1 2.19493 0.39786
2015 1 1 2.55282 0.27296
2016 1 1 2.9801 0.161684
2017 1 1 1.91144 0.171379
2018 1 1 0.94574 0.160734
2019 1 1 1.24965 0.162174
2020 1 1 1.32993 0.152501
2021 1 1 0.12338 0.293454
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_yr month fleet obs stderr
1988 7 1 6.19659 0.357548 #_ FISHERY
1989 7 1 17.0832 0.329016 #_ FISHERY
1990 7 1 11.2803 0.364203 #_ FISHERY
1991 7 1 15.035 0.253716 #_ FISHERY
1992 7 1 16.4813 0.233027 #_ FISHERY
1993 7 1 13.0983 0.240705 #_ FISHERY
1994 7 1 8.07621 0.239284 #_ FISHERY
1995 7 1 6.08033 0.324276 #_ FISHERY
1996 7 1 12.7559 0.208521 #_ FISHERY
1997 7 1 10.7356 0.238889 #_ FISHERY
1998 7 1 4.34914 0.393812 #_ FISHERY
1999 7 1 2.67641 0.407931 #_ FISHERY
2000 7 1 14.5558 0.388496 #_ FISHERY
2001 7 1 7.00468 0.297703 #_ FISHERY
2002 7 1 3.51149 0.240335 #_ FISHERY
2003 7 1 4.56367 0.277582 #_ FISHERY
2004 7 1 5.03683 0.213261 #_ FISHERY
2005 7 1 10.767 0.541405 #_ FISHERY
2006 7 1 8.29651 0.504602 #_ FISHERY
2007 7 1 10.7803 0.167081 #_ FISHERY
2008 7 1 12.4452 0.168241 #_ FISHERY
2009 7 1 13.1611 0.151812 #_ FISHERY
2010 7 1 3.65283 0.306011 #_ FISHERY
2011 7 1 6.52353 0.219451 #_ FISHERY
2012 7 1 6.92216 0.39058 #_ FISHERY
2013 7 1 9.28508 0.260285 #_ FISHERY
2014 7 1 8.00391 0.14491 #_ FISHERY
2015 7 1 6.71317 0.184609 #_ FISHERY
2016 7 1 7.84901 0.186715 #_ FISHERY
2017 7 1 6.67356 0.18845 #_ FISHERY
2018 7 1 5.13335 0.200704 #_ FISHERY
2019 7 1 7.22216 0.205433 #_ FISHERY
2020 7 1 8.32493 0.179805 #_ FISHERY
2021 7 1 9.69489 0.412446 #_ FISHERY
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
17 #_N_LengthBins; then enter lower edge of each length bin
 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 68.88 0 0 0 0 2 15 18 17 15 8 3 2 1 1 0 0 0
 2007 1 1 0 0 119.28 0 0 0 1 0 5 19 36 34 20 11 9 4 1 1 1 0
 2008 1 1 0 0 134.4 0 0 0 0 0 4 16 30 42 31 16 9 10 1 1 0 0
 2009 1 1 0 0 152.04 0 0 0 0 2 8 24 46 42 28 11 7 7 3 1 2 0
 2011 1 1 0 0 135.24 0 0 1 2 7 54 27 20 28 11 7 2 1 1 0 0 0
 2012 1 1 0 0 257.88 0 0 1 0 4 74 116 51 28 18 10 4 1 0 0 0 0
 2013 1 1 0 0 441.84 0 0 0 0 4 51 172 129 64 56 29 14 5 2 0 0 0
 2014 1 1 0 0 190.68 0 1 1 1 6 21 53 52 42 17 19 8 3 2 0 0 1
 2015 1 1 0 0 180.6 1 2 6 4 6 7 23 52 46 31 21 9 6 0 1 0 0
 2016 1 1 0 0 162.96 0 1 2 1 1 4 21 37 43 33 27 15 7 2 0 0 0
 2017 1 1 0 0 83.16 0 0 2 0 0 1 14 26 20 15 10 5 3 2 1 0 0
 2018 1 1 0 0 51.24 0 0 0 0 1 3 1 14 17 13 8 1 1 0 2 0 0
 2019 1 1 0 0 80.64 0 0 0 5 3 2 10 20 20 21 9 2 3 1 0 0 0
 2020 1 1 0 0 89.04 0 0 0 1 2 6 10 30 24 14 11 3 4 1 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 67 470024259 0 0 0 #_fleet:1_FISHERY
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

