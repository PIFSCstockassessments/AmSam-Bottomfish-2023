#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 11:49:31 2023
#_expected_values
#C data file for APVI
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
32 #_Nages=accumulator age, first age is always age 0
1 #_Nareas
3 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
 3 1 1 1 0 SURVEY2  # 2
 3 1 1 1 0 SURVEY3  # 3
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
1967 1 1 0.0861795 0.5
1968 1 1 0.304808 0.5
1969 1 1 0.0943495 0.5
1970 1 1 0.0331098 0.5
1971 1 1 0.000999995 0.5
1972 1 1 0.891305 0.5
1973 1 1 1.24646 0.5
1974 1 1 0.860915 0.5
1975 1 1 1.14032 0.5
1976 1 1 0.931674 0.5
1977 1 1 0.410947 0.5
1978 1 1 0.164649 0.5
1979 1 1 0.138349 0.5
1980 1 1 1.05142 0.5
1981 1 1 1.99761 0.5
1982 1 1 2.56187 0.5
1983 1 1 5.17091 0.5
1984 1 1 3.83554 0.5
1985 1 1 4.09907 0.5
1986 1 1 3.04356 0.5
1987 1 1 0.990176 0.5
1988 1 1 1.32084 0.5
1989 1 1 1.05323 0.250473
1990 1 1 0.555643 0.435616
1991 1 1 1.13805 0.234849
1992 1 1 0.767011 0.357252
1993 1 1 0.967959 0.333495
1994 1 1 1.5871 0.202063
1995 1 1 1.3594 0.336023
1996 1 1 1.97084 0.387366
1997 1 1 1.57848 0.214793
1998 1 1 0.253097 0.412477
1999 1 1 0.487605 0.5
2000 1 1 1.78124 0.462061
2001 1 1 0.99245 0.326622
2002 1 1 1.54401 0.328972
2003 1 1 0.443155 0.2
2004 1 1 1.14758 0.5
2005 1 1 0.727553 0.5
2006 1 1 0.399156 0.5
2007 1 1 1.30452 0.5
2008 1 1 2.35185 0.426328
2009 1 1 4.39527 0.2
2010 1 1 0.770641 0.313912
2011 1 1 1.51452 0.5
2012 1 1 0.463115 0.5
2013 1 1 1.88783 0.5
2014 1 1 2.19491 0.39786
2015 1 1 2.55279 0.27296
2016 1 1 2.99276 0.2
2017 1 1 1.91141 0.2
2018 1 1 0.945726 0.2
2019 1 1 1.24963 0.2
2020 1 1 1.32991 0.2
2021 1 1 0.123378 0.293454
-9999 0 0 0 0
#
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
2 1 0 0 # SURVEY2
3 1 0 0 # SURVEY3
#_year month index obs err
1988 7 2 4.53687 0.277587 #_orig_obs: 4.75372 SURVEY2
1989 7 2 4.68325 0.2731 #_orig_obs: 8.1018 SURVEY2
1990 7 2 4.99264 0.270011 #_orig_obs: 8.05459 SURVEY2
1991 7 2 5.27966 0.219878 #_orig_obs: 10.6313 SURVEY2
1992 7 2 5.51596 0.2 #_orig_obs: 9.03863 SURVEY2
1993 7 2 5.77364 0.2 #_orig_obs: 9.44603 SURVEY2
1994 7 2 5.84426 0.2 #_orig_obs: 5.89575 SURVEY2
1995 7 2 5.82662 0.2 #_orig_obs: 6.89141 SURVEY2
1996 7 2 5.71408 0.2 #_orig_obs: 8.19623 SURVEY2
1997 7 2 5.5643 0.2 #_orig_obs: 8.90311 SURVEY2
1998 7 2 5.77909 0.278503 #_orig_obs: 4.57348 SURVEY2
1999 7 2 6.22282 0.21153 #_orig_obs: 4.80176 SURVEY2
2000 7 2 6.33355 0.281606 #_orig_obs: 4.55142 SURVEY2
2001 7 2 6.33615 0.21596 #_orig_obs: 4.36144 SURVEY2
2002 7 2 6.36879 0.2 #_orig_obs: 3.83553 SURVEY2
2003 7 2 6.52145 0.205204 #_orig_obs: 4.0304 SURVEY2
2004 7 2 6.74644 0.2 #_orig_obs: 3.55943 SURVEY2
2005 7 2 6.90835 0.243007 #_orig_obs: 7.44936 SURVEY2
2006 7 2 7.21777 0.246247 #_orig_obs: 5.28453 SURVEY2
2007 7 2 7.38747 0.2 #_orig_obs: 6.52211 SURVEY2
2008 7 2 7.12072 0.2 #_orig_obs: 8.56534 SURVEY2
2009 7 2 6.16008 0.2 #_orig_obs: 9.44756 SURVEY2
2010 7 2 5.66177 0.282948 #_orig_obs: 2.64081 SURVEY2
2011 7 2 5.73442 0.203719 #_orig_obs: 4.48328 SURVEY2
2012 7 2 5.90494 0.359707 #_orig_obs: 4.66645 SURVEY2
2013 7 2 5.99289 0.23893 #_orig_obs: 6.28684 SURVEY2
2014 7 2 5.71952 0.2 #_orig_obs: 5.48007 SURVEY2
2015 7 2 5.30326 0.2 #_orig_obs: 4.21809 SURVEY2
2016 7 3 8.50184 0.2 #_orig_obs: 9.82017 SURVEY3
2017 7 3 7.78719 0.2 #_orig_obs: 7.16483 SURVEY3
2018 7 3 7.85104 0.2 #_orig_obs: 6.45644 SURVEY3
2019 7 3 8.17894 0.2 #_orig_obs: 8.3545 SURVEY3
2020 7 3 8.38055 0.2 #_orig_obs: 9.42847 SURVEY3
2021 7 3 8.99888 0.348927 #_orig_obs: 8.88049 SURVEY3
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
94 # maximum size in the population (lower edge of last bin) 
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 -1 1 0 0 130  0.160791 0.349101 0.978395 1.21165 8.58043 16.4409 22.883 24.1942 21.203 16.2496 10.4431 5.07527 1.67156 0.404759 0.154319
 2005 1 -1 0 0 30  0.0371057 0.0805618 0.225784 0.279612 1.9801 3.79405 5.28069 5.58327 4.893 3.74991 2.40994 1.17122 0.385745 0.0934058 0.0356122
 2006 -1 -1 0 0 31  0.0383426 0.0832472 0.23331 0.288933 2.0461 3.92051 5.45672 5.76938 5.0561 3.8749 2.49027 1.21026 0.398603 0.0965193 0.0367992
 2007 1 1 0 0 170  0.209194 0.448403 1.24809 1.54113 10.8843 20.8997 29.2535 31.4693 28.0979 21.6975 14.1619 7.00167 2.32378 0.558424 0.205107
 2008 1 1 0 0 161  0.199549 0.435671 1.22412 1.50199 10.5702 19.9545 27.5243 29.3777 26.3922 20.5584 13.5096 6.75383 2.2598 0.542235 0.195868
 2009 1 1 0 0 143  0.181709 0.418604 1.20844 1.47429 10.3471 18.8046 24.7565 25.4694 22.5423 17.6213 11.6517 5.88087 1.98819 0.480755 0.174154
 2010 -1 1 0 0 104  0.132629 0.306049 0.885655 1.11828 8.01144 15.0487 19.4962 18.6736 15.2688 11.5584 7.69978 3.96234 1.37146 0.340498 0.126179
 2011 1 -1 0 0 59  0.0752416 0.173624 0.502439 0.634408 4.54495 8.53726 11.0603 10.5937 8.6621 6.55716 4.36815 2.24787 0.778041 0.193167 0.0715825
 2012 -1 -1 0 0 15  0.0191292 0.0441417 0.127739 0.16129 1.1555 2.17049 2.81195 2.69331 2.20223 1.66707 1.11055 0.571491 0.197807 0.0491103 0.0181989
 2013 1 1 0 0 48  0.0607648 0.137688 0.394971 0.489084 3.47955 6.64245 9.15761 9.17204 7.29562 5.19688 3.38222 1.75743 0.619053 0.156298 0.0583284
 2014 1 1 0 0 166  0.211866 0.491684 1.42539 1.74425 12.3731 23.0547 31.1801 31.8629 25.7865 17.9134 11.302 5.8446 2.07675 0.531481 0.201147
 2015 1 1 0 0 147  0.190001 0.452592 1.32826 1.63885 11.6064 21.1112 27.5519 27.6605 22.7829 15.7672 9.62394 4.90098 1.75188 0.456398 0.176959
 2016 1 1 0 0 168  0.22132 0.547353 1.6335 2.01448 14.3128 25.6446 32.1413 30.7916 25.0682 17.4728 10.4207 5.18153 1.85486 0.495183 0.199816
 2017 1 1 0 0 110  0.146494 0.371621 1.12071 1.39628 9.97574 17.8229 21.8651 19.9316 15.5527 10.8062 6.38179 3.09414 1.10279 0.30308 0.128799
 2018 1 1 0 0 60  0.0793736 0.197243 0.590498 0.747519 5.38732 9.89075 12.3498 11.1161 8.31134 5.64696 3.32168 1.57898 0.556678 0.156395 0.0693881
 2019 1 1 0 0 85  0.111546 0.270195 0.800913 1.00091 7.23269 13.6891 17.7878 16.3952 12.028 7.88718 4.58745 2.15118 0.74774 0.212648 0.0974176
 2020 1 1 0 0 86  0.112422 0.271205 0.801912 0.986237 7.08022 13.3714 17.8813 17.1035 12.657 8.0375 4.55805 2.11032 0.723863 0.207352 0.0977428
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 0 0 0 0 0 #_fleet:1_FISHERY
# 0 0 0 0 0 0 0 #_fleet:2_SURVEY2
# 0 0 0 0 0 0 0 #_fleet:3_SURVEY3
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

