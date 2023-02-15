#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 12:23:07 2023
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
1967 1 1 0.0625997 0.5
1968 1 1 0.221349 0.5
1969 1 1 0.0684896 0.5
1970 1 1 0.0240399 0.5
1971 1 1 0.000999995 0.5
1972 1 1 0.646817 0.5
1973 1 1 0.904455 0.5
1974 1 1 0.624597 0.5
1975 1 1 0.827345 0.5
1976 1 1 0.675846 0.5
1977 1 1 0.298458 0.5
1978 1 1 0.119289 0.5
1979 1 1 0.100699 0.5
1980 1 1 0.375568 0.5
1981 1 1 0.713946 0.5
1982 1 1 0.915345 0.5
1983 1 1 1.84792 0.5
1984 1 1 1.37075 0.5
1985 1 1 1.46464 0.5
1986 1 1 2.31149 0.5
1987 1 1 0.685826 0.5
1988 1 1 1.50728 0.5
1989 1 1 1.24374 0.219248
1990 1 1 0.528427 0.436343
1991 1 1 0.599646 0.2
1992 1 1 0.348358 0.5
1993 1 1 0.386458 0.5
1994 1 1 0.772916 0.243462
1995 1 1 1.29726 0.353295
1996 1 1 1.07727 0.5
1997 1 1 1.74178 0.233877
1998 1 1 0.379198 0.35507
1999 1 1 0.765206 0.5
2000 1 1 0.438617 0.355524
2001 1 1 0.604177 0.260347
2002 1 1 0.419568 0.5
2003 1 1 0.508927 0.273804
2004 1 1 0.581957 0.5
2005 1 1 0.426828 0.5
2006 1 1 0.167379 0.5
2007 1 1 0.517087 0.5
2008 1 1 0.420028 0.5
2009 1 1 1.66513 0.341151
2010 1 1 0.554737 0.296226
2011 1 1 0.379658 0.5
2012 1 1 0.254922 0.5
2013 1 1 0.439978 0.5
2014 1 1 0.274418 0.2
2015 1 1 0.565177 0.2
2016 1 1 0.760213 0.2
2017 1 1 0.675396 0.2
2018 1 1 0.632756 0.2
2019 1 1 0.576967 0.2
2020 1 1 0.338378 0.336051
2021 1 1 0.0367398 0.486827
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
1988 7 2 2.64417 0.219982 #_orig_obs: 8.55709 SURVEY2
1989 7 2 2.63413 0.309681 #_orig_obs: 7.31531 SURVEY2
1990 7 2 2.67268 0.310555 #_orig_obs: 5.8933 SURVEY2
1991 7 2 2.73395 0.295841 #_orig_obs: 3.61599 SURVEY2
1992 7 2 2.79326 0.378132 #_orig_obs: 3.91749 SURVEY2
1993 7 2 2.84935 0.281301 #_orig_obs: 2.0328 SURVEY2
1994 7 2 2.87189 0.262236 #_orig_obs: 2.49763 SURVEY2
1995 7 2 2.84365 0.276169 #_orig_obs: 3.59534 SURVEY2
1996 7 2 2.80642 0.2 #_orig_obs: 4.15641 SURVEY2
1997 7 2 2.7523 0.213125 #_orig_obs: 7.37004 SURVEY2
1998 7 2 2.74862 0.331346 #_orig_obs: 2.40069 SURVEY2
1999 7 2 2.78957 0.212166 #_orig_obs: 2.53347 SURVEY2
2000 7 2 2.8237 0.332089 #_orig_obs: 3.23964 SURVEY2
2001 7 2 2.85673 0.285356 #_orig_obs: 2.6008 SURVEY2
2002 7 2 2.88426 0.256526 #_orig_obs: 1.14384 SURVEY2
2003 7 2 2.90924 0.251118 #_orig_obs: 4.91162 SURVEY2
2004 7 2 2.92084 0.216813 #_orig_obs: 3.00794 SURVEY2
2005 7 2 2.93369 0.442247 #_orig_obs: 7.197 SURVEY2
2006 7 2 2.96369 0.262582 #_orig_obs: 1.16222 SURVEY2
2007 7 2 2.98207 0.207801 #_orig_obs: 2.67183 SURVEY2
2008 7 2 2.98503 0.278136 #_orig_obs: 1.23278 SURVEY2
2009 7 2 2.92721 0.238574 #_orig_obs: 3.8308 SURVEY2
2010 7 2 2.88012 0.349767 #_orig_obs: 3.221 SURVEY2
2011 7 2 2.9015 0.341419 #_orig_obs: 1.74111 SURVEY2
2012 7 2 2.93619 0.31142 #_orig_obs: 1.34684 SURVEY2
2013 7 2 2.96096 0.299183 #_orig_obs: 1.20323 SURVEY2
2014 7 2 2.97986 0.233046 #_orig_obs: 1.22977 SURVEY2
2015 7 2 2.98685 0.224989 #_orig_obs: 2.0681 SURVEY2
2016 7 3 2.15344 0.277243 #_orig_obs: 2.10257 SURVEY3
2017 7 3 2.13883 0.265305 #_orig_obs: 1.68606 SURVEY3
2018 7 3 2.13153 0.279247 #_orig_obs: 1.73276 SURVEY3
2019 7 3 2.12968 0.216961 #_orig_obs: 3.19324 SURVEY3
2020 7 3 2.13919 0.662544 #_orig_obs: 1.08219 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
11 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 71  0.986046 0.720432 4.40012 5.0436 10.6501 12.991 12.5712 10.4472 7.28271 4.04093 1.86665
 2009 -1 1 0 0 113  1.59647 1.16815 7.14643 8.19498 17.2606 20.8299 19.8668 16.3094 11.3356 6.32686 2.9647
 2010 1 -1 0 0 22  0.310818 0.227428 1.39134 1.59548 3.36048 4.05539 3.86788 3.17528 2.20693 1.23178 0.577199
 2011 -1 -1 0 0 38  0.536868 0.39283 2.40322 2.75583 5.80446 7.00476 6.68089 5.48457 3.81198 2.12762 0.99698
 2012 1 1 0 0 76  1.06294 0.77677 4.74769 5.44557 11.5078 14.0431 13.4977 11.0714 7.62458 4.23417 1.9884
 2013 1 1 0 0 47  0.654742 0.478372 2.92256 3.34877 7.07063 8.62578 8.35843 6.91506 4.76445 2.62938 1.23182
 2014 1 1 0 0 45  0.62496 0.457072 2.79204 3.19948 6.75371 8.22756 7.97032 6.64171 4.61018 2.53924 1.18372
 2015 1 1 0 0 57  0.791446 0.578485 3.53315 4.0487 8.54373 10.4024 10.0676 8.39954 5.8753 3.25022 1.50945
 2016 -1 1 0 0 80  1.12006 0.819458 5.00868 5.73237 12.078 14.6266 14.0684 11.6705 8.17406 4.57064 2.13122
 2017 -1 -1 0 0 46  0.644034 0.471188 2.87999 3.29611 6.94486 8.4103 8.08933 6.71053 4.70009 2.62812 1.22545
 2018 -1 1 0 0 70  0.980471 0.717009 4.38281 5.02181 10.5915 12.8576 12.3581 10.1964 7.08317 3.95285 1.85832
 2019 1 -1 0 0 30  0.420202 0.307289 1.87835 2.1522 4.53922 5.5104 5.29631 4.36987 3.03565 1.69408 0.796425
 2020 -1 -1 0 0 12  0.168081 0.122916 0.75134 0.860882 1.81569 2.20416 2.11853 1.74795 1.21426 0.677631 0.31857
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

