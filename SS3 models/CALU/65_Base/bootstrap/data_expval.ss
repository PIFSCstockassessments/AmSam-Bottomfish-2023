#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Jan 11 17:28:18 2023
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
1967 1 1 0.0625982 0.5
1968 1 1 0.221344 0.5
1969 1 1 0.068488 0.5
1970 1 1 0.0240393 0.5
1971 1 1 0.000999971 0.5
1972 1 1 0.646801 0.5
1973 1 1 0.904431 0.5
1974 1 1 0.624578 0.5
1975 1 1 0.827319 0.5
1976 1 1 0.675823 0.5
1977 1 1 0.298447 0.5
1978 1 1 0.119285 0.5
1979 1 1 0.100696 0.5
1980 1 1 0.375557 0.5
1981 1 1 0.713925 0.5
1982 1 1 0.915315 0.5
1983 1 1 1.84787 0.5
1984 1 1 1.37069 0.5
1985 1 1 1.4646 0.5
1986 1 1 2.31368 0.5
1987 1 1 0.685742 0.5
1988 1 1 1.50798 0.5
1989 1 1 1.24724 0.219248
1990 1 1 0.528333 0.436343
1991 1 1 0.59956 0.2
1992 1 1 0.348312 0.5
1993 1 1 0.386418 0.5
1994 1 1 0.772851 0.243462
1995 1 1 1.2974 0.353295
1996 1 1 1.07733 0.5
1997 1 1 1.72559 0.233877
1998 1 1 0.379129 0.35507
1999 1 1 0.765126 0.5
2000 1 1 0.438566 0.355524
2001 1 1 0.604118 0.260347
2002 1 1 0.419531 0.5
2003 1 1 0.508889 0.273804
2004 1 1 0.581918 0.5
2005 1 1 0.426801 0.5
2006 1 1 0.16737 0.5
2007 1 1 0.517063 0.5
2008 1 1 0.420009 0.5
2009 1 1 1.66507 0.341151
2010 1 1 0.554707 0.296226
2011 1 1 0.379638 0.5
2012 1 1 0.25491 0.5
2013 1 1 0.43996 0.5
2014 1 1 0.274408 0.2
2015 1 1 0.565156 0.2
2016 1 1 0.760185 0.2
2017 1 1 0.67537 0.2
2018 1 1 0.632732 0.2
2019 1 1 0.576944 0.2
2020 1 1 0.338365 0.336051
2021 1 1 0.0367384 0.486827
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
2016 7 1 2.21951 0.277243 #_orig_obs: 2.10257 FISHERY
2017 7 1 2.13379 0.265305 #_orig_obs: 1.68606 FISHERY
2018 7 1 2.09749 0.279247 #_orig_obs: 1.73276 FISHERY
2019 7 1 2.09745 0.216961 #_orig_obs: 3.19324 FISHERY
2020 7 1 2.17458 0.662544 #_orig_obs: 1.08219 FISHERY
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
 2007 1 1 0 0 71  1.17471 0.711107 4.14061 4.53997 10.1675 14.2076 15.0582 11.8839 6.40308 2.2086 0.504708
 2009 -1 1 0 0 113  1.97443 1.22625 7.19165 8.08733 17.9154 23.7217 23.0272 16.5846 8.82442 3.44917 0.997893
 2010 1 -1 0 0 22  0.384403 0.23874 1.40015 1.57452 3.48796 4.61838 4.48317 3.22886 1.71803 0.67152 0.19428
 2011 -1 -1 0 0 38  0.663968 0.412369 2.41843 2.71963 6.02465 7.9772 7.74365 5.57712 2.9675 1.1599 0.335575
 2012 1 1 0 0 76  1.21414 0.742226 4.31403 4.78121 10.8548 15.672 16.378 12.4314 6.47497 2.42274 0.714484
 2013 1 1 0 0 47  0.7228 0.443193 2.56671 2.82719 6.34653 9.02715 10.0657 8.25601 4.5624 1.69572 0.486564
 2014 1 1 0 0 45  0.670218 0.415507 2.40204 2.65581 5.95764 8.39876 9.27087 8.02335 4.81108 1.86848 0.526251
 2015 1 1 0 0 57  0.839931 0.519115 2.99634 3.33388 7.47347 10.516 11.5202 9.99472 6.36932 2.669 0.768019
 2016 -1 1 0 0 80  1.22894 0.766394 4.44416 4.93032 10.9917 15.1357 16.0115 13.221 8.28549 3.76711 1.2177
 2017 -1 -1 0 0 46  0.70664 0.440676 2.55539 2.83494 6.32021 8.70301 9.20662 7.6021 4.76415 2.16609 0.700175
 2018 -1 1 0 0 70  1.07116 0.66536 3.85657 4.30095 9.64469 13.4986 14.3301 11.6179 6.93188 3.04055 1.04221
 2019 1 -1 0 0 30  0.459066 0.285154 1.65282 1.84326 4.13344 5.7851 6.14148 4.97912 2.97081 1.30309 0.446661
 2020 -1 -1 0 0 12  0.183627 0.114062 0.661127 0.737306 1.65338 2.31404 2.45659 1.99165 1.18832 0.521237 0.178664
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
# 0 0 32536320 32535808 0 0 0 #_fleet:1_FISHERY
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

