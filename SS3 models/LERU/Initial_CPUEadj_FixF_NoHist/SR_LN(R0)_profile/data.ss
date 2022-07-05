#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jul 01 13:24:02 2022
#_echo_input_data
#C data file for LERU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1986 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
16 #_Nages=accumulator age, first age is always age 0
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
2016 1 1 0.87453 0.176986
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
1988 7 1 27.6322 0.390515 #_ FISHERY
1989 7 1 39.1132 0.313763 #_ FISHERY
1990 7 1 25.1098 0.359462 #_ FISHERY
1991 7 1 14.7612 0.371581 #_ FISHERY
1992 7 1 32.6826 0.382105 #_ FISHERY
1993 7 1 10.0896 0.388572 #_ FISHERY
1994 7 1 8.94624 0.36748 #_ FISHERY
1995 7 1 12.286 0.409776 #_ FISHERY
1996 7 1 22.4513 0.309482 #_ FISHERY
1997 7 1 15.441 0.279171 #_ FISHERY
1998 7 1 6.66691 0.539466 #_ FISHERY
1999 7 1 12.0456 0.491653 #_ FISHERY
2000 7 1 16.7277 0.597773 #_ FISHERY
2001 7 1 16.9042 0.370761 #_ FISHERY
2002 7 1 10.1843 0.267917 #_ FISHERY
2003 7 1 14.731 0.291309 #_ FISHERY
2004 7 1 5.73362 0.308052 #_ FISHERY
2005 7 1 11.8484 0.530535 #_ FISHERY
2006 7 1 9.47408 0.350284 #_ FISHERY
2007 7 1 14.6871 0.256345 #_ FISHERY
2008 7 1 27.8831 0.262258 #_ FISHERY
2009 7 1 26.6057 0.239282 #_ FISHERY
2010 7 1 16.958 0.293808 #_ FISHERY
2011 7 1 24.4498 0.273001 #_ FISHERY
2012 7 1 26.8048 0.433107 #_ FISHERY
2013 7 1 11.272 0.338764 #_ FISHERY
2014 7 1 4.09978 1 #_ FISHERY
2015 7 1 9.01719 1 #_ FISHERY
2016 7 1 2.3772 1 #_ FISHERY
2017 7 1 3.28226 1 #_ FISHERY
2018 7 1 2.83726 1 #_ FISHERY
2019 7 1 3.71795 1 #_ FISHERY
2020 7 1 2.99948 1 #_ FISHERY
2021 7 1 7.91032 1 #_ FISHERY
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
50 # maximum size in the population (lower edge of last bin) 
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
 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 148.68 0 0 0 1 2 4 9 16 42 61 19 10 2 5 5 1
 2005 1 1 0 0 125.16 0 0 0 0 0 3 13 33 30 19 7 12 9 9 14 0
 2006 1 1 0 0 105 0 0 0 0 0 1 9 26 20 24 6 6 9 7 10 7
 2007 1 1 0 0 82.32 0 0 0 0 0 4 9 17 21 12 9 4 4 6 11 1
 2008 1 1 0 0 250.32 0 0 0 0 0 2 12 56 67 83 48 12 2 6 10 0
 2009 1 1 0 0 332.64 0 0 0 0 2 12 35 85 72 94 42 22 9 10 12 1
 2010 1 1 0 0 104.16 0 0 0 0 0 0 8 40 36 32 6 1 0 0 1 0
 2011 1 1 0 0 782.04 0 0 0 0 1 18 131 188 223 218 113 26 5 4 4 0
 2012 1 1 0 0 1333.08 0 0 0 1 15 88 194 301 378 311 152 46 8 32 57 4
 2013 1 1 0 0 1564.92 0 0 0 9 40 57 252 403 509 352 193 30 3 9 6 0
 2014 1 1 0 0 190.68 0 0 0 0 5 13 19 37 60 50 33 6 3 1 0 0
 2015 1 1 0 0 542.64 0 0 0 0 6 40 82 109 174 129 59 19 9 8 11 0
 2016 1 1 0 0 252.84 5 0 0 0 1 11 34 40 87 70 27 9 1 5 9 2
 2017 1 1 0 0 110.88 0 0 0 0 1 3 11 18 38 28 21 5 2 4 1 0
 2018 1 1 0 0 143.64 0 0 0 0 3 5 14 24 47 36 18 9 5 5 5 0
 2019 1 1 0 0 191.52 0 0 0 0 1 7 12 36 61 59 30 11 1 2 6 2
 2020 1 1 0 0 153.72 0 0 0 0 1 5 26 29 59 37 16 5 0 3 2 0
 2021 1 1 0 0 79.8 0 0 0 0 0 4 10 24 20 17 12 3 1 1 3 0
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
# 0 0 417792067 67 0 0 0 #_fleet:1_FISHERY
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

