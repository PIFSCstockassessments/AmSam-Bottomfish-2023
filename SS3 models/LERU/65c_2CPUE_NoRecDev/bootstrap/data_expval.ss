#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 13:34:30 2023
#_expected_values
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
-999 1 1 0.345825 0.5
1967 1 1 0.343367 0.5
1968 1 1 1.21153 0.5
1969 1 1 0.374666 0.5
1970 1 1 0.131999 0.5
1971 1 1 0.000999991 0.5
1972 1 1 3.54298 0.5
1973 1 1 4.95498 0.5
1974 1 1 3.4223 0.5
1975 1 1 4.53268 0.5
1976 1 1 3.70399 0.5
1977 1 1 1.63425 0.5
1978 1 1 0.653614 0.5
1979 1 1 0.550649 0.5
1980 1 1 1.44286 0.5
1981 1 1 2.74147 0.5
1982 1 1 3.51619 0.5
1983 1 1 7.13733 0.5
1984 1 1 4.08906 0.5
1985 1 1 2.99891 0.5
1986 1 1 2.41177 0.5
1987 1 1 1.41687 0.5
1988 1 1 2.337 0.5
1989 1 1 1.70601 0.2
1990 1 1 1.12512 0.281466
1991 1 1 0.96653 0.227721
1992 1 1 1.38932 0.456647
1993 1 1 0.626372 0.5
1994 1 1 1.529 0.391316
1995 1 1 1.19154 0.463974
1996 1 1 2.15722 0.425062
1997 1 1 1.70818 0.305347
1998 1 1 0.231783 0.5
1999 1 1 0.288024 0.5
2000 1 1 1.43423 0.5
2001 1 1 4.28775 0.5
2002 1 1 2.88342 0.477148
2003 1 1 1.15482 0.460287
2004 1 1 1.38206 0.5
2005 1 1 0.848205 0.5
2006 1 1 0.391444 0.5
2007 1 1 1.61205 0.5
2008 1 1 3.32478 0.327572
2009 1 1 7.0373 0.2
2010 1 1 1.48638 0.2
2011 1 1 3.66321 0.31116
2012 1 1 1.1344 0.5
2013 1 1 2.21212 0.5
2014 1 1 1.06228 0.343554
2015 1 1 3.07212 0.256762
2016 1 1 0.874964 0.2
2017 1 1 0.616878 0.20531
2018 1 1 0.403233 0.2
2019 1 1 0.811918 0.2
2020 1 1 0.435444 0.2
2021 1 1 0.190958 0.406754
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
1988 7 2 2.2561 0.302125 #_orig_obs: 25.3195 SURVEY2
1989 7 2 1.69752 0.217708 #_orig_obs: 33.5946 SURVEY2
1990 7 2 2.9267 0.267414 #_orig_obs: 20.8808 SURVEY2
1991 7 2 4.27157 0.28055 #_orig_obs: 11.0637 SURVEY2
1992 7 2 4.9173 0.29121 #_orig_obs: 27.8109 SURVEY2
1993 7 2 6.85807 0.295363 #_orig_obs: 8.12984 SURVEY2
1994 7 2 8.97141 0.273269 #_orig_obs: 7.31431 SURVEY2
1995 7 2 10.5372 0.326689 #_orig_obs: 10.0863 SURVEY2
1996 7 2 11.5265 0.214394 #_orig_obs: 19.7609 SURVEY2
1997 7 2 12.3724 0.2 #_orig_obs: 14.4153 SURVEY2
1998 7 2 16.429 0.457876 #_orig_obs: 5.82536 SURVEY2
1999 7 2 22.3737 0.413989 #_orig_obs: 10.2438 SURVEY2
2000 7 2 25.6365 0.516348 #_orig_obs: 14.3892 SURVEY2
2001 7 2 21.8044 0.277386 #_orig_obs: 14.4596 SURVEY2
2002 7 2 17.9143 0.2 #_orig_obs: 9.10646 SURVEY2
2003 7 2 19.4941 0.2 #_orig_obs: 13.6697 SURVEY2
2004 7 2 22.7078 0.218304 #_orig_obs: 4.85345 SURVEY2
2005 7 2 25.7209 0.45313 #_orig_obs: 10.863 SURVEY2
2006 7 2 29.8317 0.261864 #_orig_obs: 8.60873 SURVEY2
2007 7 2 32.0934 0.2 #_orig_obs: 11.8947 SURVEY2
2008 7 2 29.2175 0.2 #_orig_obs: 23.4421 SURVEY2
2009 7 2 16.8382 0.2 #_orig_obs: 22.0057 SURVEY2
2010 7 2 14.0259 0.2 #_orig_obs: 13.4558 SURVEY2
2011 7 2 13.7787 0.2 #_orig_obs: 19.7665 SURVEY2
2012 7 2 14.4108 0.349484 #_orig_obs: 22.0528 SURVEY2
2013 7 2 16.4033 0.245095 #_orig_obs: 8.87054 SURVEY2
2014 7 2 18.4283 0.2 #_orig_obs: 3.36432 SURVEY2
2015 7 2 18.4925 0.2 #_orig_obs: 7.65882 SURVEY2
2016 7 3 1.96627 0.209883 #_orig_obs: 2.66496 SURVEY3
2017 7 3 2.43268 0.210971 #_orig_obs: 2.37763 SURVEY3
2018 7 3 2.90135 0.2 #_orig_obs: 2.56825 SURVEY3
2019 7 3 3.26127 0.2 #_orig_obs: 3.64489 SURVEY3
2020 7 3 3.56898 0.2 #_orig_obs: 2.51974 SURVEY3
2021 7 3 3.92672 0.394811 #_orig_obs: 5.68061 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
8 #_N_LengthBins
 14 17.5 21 24.5 28 31.5 35 38.5
#_yr month fleet sex part Nsamp datavector(female-male)
 2005 1 1 0 0 82  0.0999895 1.98386 12.1242 31.1284 25.3746 9.8219 1.32906 0.137983 0 0 0 0 0 0 0 0
 2006 1 1 0 0 87  0.104203 1.91715 12.1051 31.5317 27.4579 12.0092 1.71745 0.157238 0 0 0 0 0 0 0 0
 2007 1 1 0 0 55  0.0654863 1.16923 7.19915 19.0679 17.6253 8.44313 1.31829 0.111469 0 0 0 0 0 0 0 0
 2008 1 1 0 0 166  0.20099 3.87187 22.668 56.961 51.3422 26.1572 4.42864 0.369983 0 0 0 0 0 0 0 0
 2009 1 1 0 0 256  0.338283 8.73937 43.1436 93.2293 69.3323 34.4579 6.19948 0.559836 0 0 0 0 0 0 0 0
 2010 1 1 0 0 98  0.13269 3.85464 22.4493 42.9284 19.6114 7.50274 1.35556 0.165209 0 0 0 0 0 0 0 0
 2011 1 1 0 0 745  0.981412 24.9437 152.215 334.155 175.705 48.5511 7.35353 1.09567 0 0 0 0 0 0 0 0
 2012 1 1 0 0 1251  1.66241 44.752 252.231 553.402 305.44 82.135 9.73884 1.63871 0 0 0 0 0 0 0 0
 2013 1 1 0 0 1472  1.89321 45.0102 274.725 631.023 391.073 113.967 12.431 1.8771 0 0 0 0 0 0 0 0
 2014 1 1 0 0 218  0.278138 6.53736 38.2441 90.5953 60.5517 19.3494 2.16011 0.283827 0 0 0 0 0 0 0 0
 2015 1 1 0 0 552  0.704923 16.3935 93.991 220.941 157.094 55.4796 6.63512 0.761621 0 0 0 0 0 0 0 0
 2016 1 1 0 0 274  0.347931 8.12787 48.5633 111.403 74.2994 27.319 3.54556 0.394147 0 0 0 0 0 0 0 0
 2017 1 1 0 0 141  0.172103 3.42518 22.3449 56.0505 41.3401 15.3677 2.08175 0.217791 0 0 0 0 0 0 0 0
 2018 1 1 0 0 152  0.1823 3.36254 20.9876 56.2717 48.5 19.7075 2.72908 0.259211 0 0 0 0 0 0 0 0
 2019 1 1 0 0 181  0.21487 3.7864 23.5228 62.7389 58.8956 27.423 4.06985 0.348619 0 0 0 0 0 0 0 0
 2020 1 1 0 0 147  0.173038 2.93909 18.527 49.3516 47.3486 24.3364 4.00042 0.323882 0 0 0 0 0 0 0 0
 2021 1 1 0 0 76  0.0885092 1.4233 9.13921 24.8264 24.5574 13.3734 2.39976 0.192018 0 0 0 0 0 0 0 0
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

