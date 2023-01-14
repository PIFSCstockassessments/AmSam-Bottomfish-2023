#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Jan 10 12:39:45 2023
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
-999 1 1 0.347326 0.5
1967 1 1 0.343367 0.5
1968 1 1 1.21153 0.5
1969 1 1 0.374666 0.5
1970 1 1 0.131999 0.5
1971 1 1 0.000999991 0.5
1972 1 1 3.54298 0.5
1973 1 1 4.95498 0.5
1974 1 1 3.4223 0.5
1975 1 1 4.53268 0.5
1976 1 1 3.70398 0.5
1977 1 1 1.63425 0.5
1978 1 1 0.653615 0.5
1979 1 1 0.55065 0.5
1980 1 1 1.44286 0.5
1981 1 1 2.74147 0.5
1982 1 1 3.51619 0.5
1983 1 1 7.12159 0.5
1984 1 1 4.34063 0.5
1985 1 1 3.04906 0.5
1986 1 1 2.46401 0.5
1987 1 1 1.4167 0.5
1988 1 1 2.35936 0.5
1989 1 1 1.70696 0.2
1990 1 1 1.12511 0.281466
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
2001 1 1 4.28774 0.5
2002 1 1 2.88342 0.477148
2003 1 1 1.15482 0.460287
2004 1 1 1.38206 0.5
2005 1 1 0.848205 0.5
2006 1 1 0.391444 0.5
2007 1 1 1.61205 0.5
2008 1 1 3.32478 0.327572
2009 1 1 7.0368 0.2
2010 1 1 1.48638 0.2
2011 1 1 3.66319 0.31116
2012 1 1 1.1344 0.5
2013 1 1 2.21212 0.5
2014 1 1 1.06229 0.343554
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
#_year month index obs err
2016 7 1 1.99069 0.209883 #_orig_obs: 2.66496 FISHERY
2017 7 1 2.44031 0.210971 #_orig_obs: 2.37763 FISHERY
2018 7 1 2.89106 0.2 #_orig_obs: 2.56825 FISHERY
2019 7 1 3.24269 0.2 #_orig_obs: 3.64489 FISHERY
2020 7 1 3.53479 0.2 #_orig_obs: 2.51974 FISHERY
2021 7 1 3.8761 0.394811 #_orig_obs: 5.68061 FISHERY
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
8 #_N_LengthBins
 14 17.5 21 24.5 28 31.5 35 38.5
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 41  0.0500851 1.05769 6.72377 16.5627 11.8136 4.12743 0.596938 0.0678212 0 0 0 0 0 0 0 0
 2005 1 1 0 0 82  0.0991744 2.01689 12.4373 31.0888 25.1063 9.77609 1.33671 0.138809 0 0 0 0 0 0 0 0
 2006 1 1 0 0 87  0.103442 1.95144 12.4322 31.5251 27.1731 11.9355 1.72124 0.158066 0 0 0 0 0 0 0 0
 2007 1 1 0 0 55  0.0650254 1.19042 7.39632 19.0781 17.4542 8.38612 1.3179 0.1119 0 0 0 0 0 0 0 0
 2008 1 1 0 0 166  0.199386 3.93301 23.236 56.9252 50.8912 26.0161 4.42787 0.371234 0 0 0 0 0 0 0 0
 2009 1 1 0 0 256  0.333544 8.76833 43.8171 92.7636 68.9616 34.5432 6.24865 0.563966 0 0 0 0 0 0 0 0
 2010 1 1 0 0 98  0.130606 3.84884 22.6492 42.435 19.6434 7.71744 1.40719 0.168379 0 0 0 0 0 0 0 0
 2011 1 1 0 0 745  0.966859 24.9746 153.817 331.103 175.21 50.0552 7.75312 1.12056 0 0 0 0 0 0 0 0
 2012 1 1 0 0 1251  1.63694 44.6728 254.961 547.89 305.094 84.7065 10.3619 1.67706 0 0 0 0 0 0 0 0
 2013 1 1 0 0 1472  1.8683 45.1716 278.09 625.594 389.579 116.651 13.1277 1.91822 0 0 0 0 0 0 0 0
 2014 1 1 0 0 218  0.27464 6.56016 38.8223 89.861 60.2186 19.7099 2.26355 0.289822 0 0 0 0 0 0 0 0
 2015 1 1 0 0 552  0.695802 16.4391 95.3132 219.369 156.224 56.2817 6.8994 0.777606 0 0 0 0 0 0 0 0
 2016 1 1 0 0 274  0.343599 8.14773 49.2173 110.436 73.9817 27.7863 3.68465 0.402574 0 0 0 0 0 0 0 0
 2017 1 1 0 0 141  0.170449 3.45797 22.7404 55.6751 41.0225 15.5579 2.15328 0.222419 0 0 0 0 0 0 0 0
 2018 1 1 0 0 152  0.18077 3.40355 21.4662 56.0539 48.0287 19.803 2.79946 0.264467 0 0 0 0 0 0 0 0
 2019 1 1 0 0 181  0.213216 3.83805 24.0881 62.6217 58.3347 27.414 4.13552 0.354773 0 0 0 0 0 0 0 0
 2020 1 1 0 0 147  0.17181 2.98334 18.9897 49.2909 46.9203 24.278 4.0376 0.328361 0 0 0 0 0 0 0 0
 2021 1 1 0 0 76  0.0879421 1.4474 9.38168 24.8196 24.3345 13.3234 2.41162 0.193919 0 0 0 0 0 0 0 0
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

