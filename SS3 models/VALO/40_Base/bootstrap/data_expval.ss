#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Oct 11 12:37:22 2022
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
1967 1 1 0.00532555 0.5
1968 1 1 0.0615818 0.5
1969 1 1 0.0113362 0.5
1970 1 1 0.00167221 0.5
1971 1 1 0.000884789 0.5
1972 1 1 0.10999 0.5
1973 1 1 0.255818 0.5
1974 1 1 0.116085 0.5
1975 1 1 0.118434 0.5
1976 1 1 0.068173 0.5
1977 1 1 0.0710944 0.5
1978 1 1 0.0160112 0.5
1979 1 1 0.0395989 0.5
1980 1 1 0.0925773 0.5
1981 1 1 0.347179 0.5
1982 1 1 0.36027 0.5
1983 1 1 0.697709 0.5
1984 1 1 1.04984 0.5
1985 1 1 0.264711 0.5
1986 1 1 1.24262 1.89066
1987 1 1 0.0484114 2.13046
1988 1 1 0.198352 1.61281
1989 1 1 0.381738 0.485919
1990 1 1 0.00844761 1.16375
1991 1 1 0.174311 0.308736
1992 1 1 0.0309691 1.17621
1993 1 1 0.127514 1.08471
1994 1 1 3.85733 0.777986
1995 1 1 0.618615 0.860831
1996 1 1 0.116587 1.36575
1997 1 1 0.865839 0.800719
1998 1 1 0.0304386 1.11671
1999 1 1 0.447032 1.21675
2000 1 1 0.139105 0.819357
2001 1 1 0.167623 0.673833
2002 1 1 0.449366 0.59292
2003 1 1 0.762408 0.297211
2004 1 1 0.359123 1.73802
2005 1 1 0.000488755 2.10174
2006 1 1 0.00651576 1.86632
2007 1 1 0.0679955 1.70221
2008 1 1 0.208276 1.38037
2009 1 1 0.569399 0.263973
2010 1 1 0.122748 0.524839
2011 1 1 0.0148192 1.68139
2012 1 1 0.089228 2.25571
2013 1 1 0.0230842 1.84286
2014 1 1 0.0734546 1.01224
2015 1 1 0.674284 0.673679
2016 1 1 0.0668673 0.309637
2017 1 1 0.0460477 0.350369
2018 1 1 0.0532628 0.183459
2019 1 1 0.186616 0.112564
2020 1 1 0.129797 0.246135
2021 1 1 0.00572874 0.470573
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
2016 7 1 0.104406 0.650131 #_orig_obs: 0.0553378 FISHERY
2017 7 1 0.107502 0.795754 #_orig_obs: 0.0754762 FISHERY
2018 7 1 0.110387 1.01432 #_orig_obs: 0.0373757 FISHERY
2019 7 1 0.111444 0.549405 #_orig_obs: 0.187959 FISHERY
2020 7 1 0.111454 0.618714 #_orig_obs: 0.189128 FISHERY
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
 2011 1 1 0 0 62.16  0.223275 1.01947 5.87057 10.208 12.1824 10.5644 8.64431 6.49551 4.10526 1.93303 0.651674 0.18414 0.077887 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 72.24  0.254796 1.15333 6.62097 11.5094 13.9776 12.4885 10.3174 7.65906 4.83327 2.31306 0.795081 0.225208 0.0923877 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 66.36  0.231106 1.04472 5.99333 10.3955 12.612 11.4023 9.65059 7.23511 4.54758 2.18482 0.760139 0.216259 0.0865835 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 49.56  0.170937 0.769739 4.41261 7.66537 9.3118 8.44249 7.23662 5.53199 3.50731 1.68777 0.589554 0.167909 0.0658989 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 84  0.298287 1.34291 7.64055 12.9745 15.6139 14.1154 12.1548 9.41893 6.06351 2.9409 1.03008 0.292907 0.113332 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 1 0 0 34.44  0.120144 0.543081 3.11268 5.38237 6.48903 5.8112 4.92818 3.77718 2.44937 1.21639 0.436919 0.125739 0.0477082 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 -1 0 0 5.04  0.017582 0.0794753 0.455515 0.787664 0.949614 0.850419 0.721197 0.552758 0.358445 0.178009 0.0639394 0.0184008 0.00698169 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 1 -1 0 0 2.52  0.008791 0.0397377 0.227757 0.393832 0.474807 0.42521 0.360598 0.276379 0.179223 0.0890044 0.0319697 0.0092004 0.00349084 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 8.4  0.0293033 0.132459 0.759191 1.31277 1.58269 1.41737 1.20199 0.921263 0.597409 0.296681 0.106566 0.030668 0.0116361 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 9.24  0.0322337 0.145705 0.83511 1.44405 1.74096 1.5591 1.32219 1.01339 0.657149 0.326349 0.117222 0.0337348 0.0127998 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 0 0 1024 1024 0 0 0 #_fleet:1_FISHERY
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

