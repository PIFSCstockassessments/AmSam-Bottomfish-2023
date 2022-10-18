#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Oct 11 12:44:28 2022
#_expected_values
#C data file for CALU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
12 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0625985 0.5
1968 1 1 0.221345 0.5
1969 1 1 0.0684883 0.5
1970 1 1 0.0240394 0.5
1971 1 1 0.000999976 0.5
1972 1 1 0.646805 0.5
1973 1 1 0.904437 0.5
1974 1 1 0.624583 0.5
1975 1 1 0.827327 0.5
1976 1 1 0.67583 0.5
1977 1 1 0.298451 0.5
1978 1 1 0.119287 0.5
1979 1 1 0.100697 0.5
1980 1 1 0.37556 0.5
1981 1 1 0.713931 0.5
1982 1 1 0.915324 0.5
1983 1 1 1.84788 0.5
1984 1 1 1.37071 0.5
1985 1 1 1.4646 0.5
1986 1 1 2.31144 1.13414
1987 1 1 0.685796 1.50028
1988 1 1 1.50722 0.973998
1989 1 1 1.24369 0.219248
1990 1 1 0.528404 0.436343
1991 1 1 0.599624 0.191672
1992 1 1 0.348346 0.572612
1993 1 1 0.386446 0.512911
1994 1 1 0.772894 0.243462
1995 1 1 1.29723 0.353295
1996 1 1 1.07724 0.620314
1997 1 1 1.74173 0.233877
1998 1 1 0.379184 0.35507
1999 1 1 0.765181 0.52279
2000 1 1 0.438604 0.355524
2001 1 1 0.604159 0.260347
2002 1 1 0.419556 0.577536
2003 1 1 0.508913 0.273804
2004 1 1 0.581942 1.30132
2005 1 1 0.426817 1.48859
2006 1 1 0.167375 1.67434
2007 1 1 0.517075 1.33302
2008 1 1 0.420018 1.33108
2009 1 1 1.66509 0.341151
2010 1 1 0.554722 0.296226
2011 1 1 0.379648 1.47508
2012 1 1 0.254915 1.73491
2013 1 1 0.439967 1.71187
2014 1 1 0.274412 0.194913
2015 1 1 0.565164 0.151294
2016 1 1 0.760195 0.194925
2017 1 1 0.67538 0.166155
2018 1 1 0.632741 0.178726
2019 1 1 0.576952 0.156753
2020 1 1 0.33837 0.336051
2021 1 1 0.0367389 0.486827
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
2016 7 1 2.20685 0.277431 #_orig_obs: 2.10368 FISHERY
2017 7 1 2.14463 0.265214 #_orig_obs: 1.69011 FISHERY
2018 7 1 2.11355 0.279132 #_orig_obs: 1.73726 FISHERY
2019 7 1 2.10559 0.216929 #_orig_obs: 3.19905 FISHERY
2020 7 1 2.14412 0.662376 #_orig_obs: 1.08715 FISHERY
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
72 # maximum size in the population (lower edge of last bin) 
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
11 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 54.64  0.683027 1.10082 1.85895 4.06588 6.7267 10.3607 11.9454 9.8946 5.51589 1.97467 0.513348
 2009 -1 1 0 0 105.48  1.41478 2.3038 3.9032 8.5658 13.9719 20.8375 22.7555 17.7841 9.57691 3.43652 0.930013
 2010 1 -1 0 0 22.68  0.304202 0.495356 0.839255 1.84179 3.00419 4.48041 4.89283 3.82388 2.0592 0.73891 0.199969
 2011 -1 -1 0 0 31.92  0.428136 0.697168 1.18117 2.59215 4.22813 6.30576 6.8862 5.38176 2.89813 1.03995 0.281437
 2012 1 1 0 0 79.8  1.02617 1.65639 2.79954 6.13851 10.2263 15.6755 17.6049 13.9232 7.42129 2.62233 0.705917
 2013 1 1 0 0 48.04  0.60624 0.977689 1.65052 3.60536 5.96833 9.2363 10.6302 8.6263 4.66106 1.64125 0.436739
 2015 1 1 0 0 59.64  0.739761 1.19438 2.01707 4.41063 7.27064 11.1742 12.9553 10.8973 6.16398 2.22832 0.588438
 2016 -1 1 0 0 63  0.807352 1.311 2.21527 4.83907 7.92481 11.9975 13.5464 11.1161 6.28852 2.32501 0.628985
 2017 -1 -1 0 0 33.6  0.430588 0.699202 1.18148 2.58084 4.22657 6.39868 7.22472 5.92859 3.35388 1.24001 0.335459
 2018 -1 1 0 0 63.84  0.821385 1.33111 2.25042 4.92696 8.11288 12.3322 13.8699 11.1717 6.15655 2.24935 0.617498
 2019 1 -1 0 0 31.08  0.399885 0.648039 1.0956 2.39865 3.94969 6.00385 6.75247 5.43885 2.99727 1.09508 0.300624
 2020 -1 -1 0 0 11.76  0.151308 0.245204 0.414551 0.907597 1.49448 2.27173 2.55499 2.05794 1.1341 0.414354 0.11375
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 590381056 -750223360 0 0 0 #_fleet:1_FISHERY
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

