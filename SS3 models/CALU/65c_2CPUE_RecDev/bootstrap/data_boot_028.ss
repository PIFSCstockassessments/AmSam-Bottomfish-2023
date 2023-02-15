#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 18:14:38 2023
#_bootdata:_30
#C data file for CALU
#_bootstrap file: 28  irand_seed: 123 first rand#: -0.405209
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
#_catch_biomass(mtons):_columns_are_fisheries,year,season
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0 0.01
1967 1 1 0.0546552 0.5
1968 1 1 0.187319 0.5
1969 1 1 0.0769838 0.5
1970 1 1 0.0251895 0.5
1971 1 1 0.00168546 0.5
1972 1 1 0.822225 0.5
1973 1 1 0.707513 0.5
1974 1 1 0.292607 0.5
1975 1 1 1.14623 0.5
1976 1 1 1.24982 0.5
1977 1 1 0.211351 0.5
1978 1 1 0.135353 0.5
1979 1 1 0.10879 0.5
1980 1 1 0.377507 0.5
1981 1 1 1.09928 0.5
1982 1 1 0.816633 0.5
1983 1 1 2.37481 0.5
1984 1 1 0.908298 0.5
1985 1 1 1.58009 0.5
1986 1 1 3.59444 0.5
1987 1 1 0.660311 0.5
1988 1 1 2.19164 0.5
1989 1 1 1.04371 0.219248
1990 1 1 0.339564 0.436343
1991 1 1 0.539702 0.2
1992 1 1 0.89136 0.5
1993 1 1 0.231101 0.5
1994 1 1 0.648977 0.243462
1995 1 1 0.668415 0.353295
1996 1 1 0.870269 0.5
1997 1 1 2.07878 0.233877
1998 1 1 0.48448 0.35507
1999 1 1 0.883614 0.5
2000 1 1 0.290399 0.355524
2001 1 1 0.812215 0.260347
2002 1 1 0.216592 0.5
2003 1 1 0.436906 0.273804
2004 1 1 1.22397 0.5
2005 1 1 0.589431 0.5
2006 1 1 0.212374 0.5
2007 1 1 0.268434 0.5
2008 1 1 0.376427 0.5
2009 1 1 0.971904 0.341151
2010 1 1 0.635427 0.296226
2011 1 1 0.302962 0.5
2012 1 1 0.214667 0.5
2013 1 1 0.268144 0.5
2014 1 1 0.242659 0.2
2015 1 1 0.688865 0.2
2016 1 1 1.00565 0.2
2017 1 1 0.838857 0.2
2018 1 1 0.754202 0.2
2019 1 1 0.705828 0.2
2020 1 1 0.165698 0.336051
2021 1 1 0.0425287 0.486827
-9999 0 0 0 0
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
1988 7 2 5.29218 0.219982 #_orig_obs: 8.55709 SURVEY2
1989 7 2 2.18633 0.309681 #_orig_obs: 7.31531 SURVEY2
1990 7 2 4.83782 0.310555 #_orig_obs: 5.8933 SURVEY2
1991 7 2 4.96345 0.295841 #_orig_obs: 3.61599 SURVEY2
1992 7 2 1.25142 0.378132 #_orig_obs: 3.91749 SURVEY2
1993 7 2 2.34621 0.281301 #_orig_obs: 2.0328 SURVEY2
1994 7 2 4.05339 0.262236 #_orig_obs: 2.49763 SURVEY2
1995 7 2 1.41065 0.276169 #_orig_obs: 3.59534 SURVEY2
1996 7 2 2.14194 0.2 #_orig_obs: 4.15641 SURVEY2
1997 7 2 1.35434 0.213125 #_orig_obs: 7.37004 SURVEY2
1998 7 2 2.31365 0.331346 #_orig_obs: 2.40069 SURVEY2
1999 7 2 1.42905 0.212166 #_orig_obs: 2.53347 SURVEY2
2000 7 2 1.73297 0.332089 #_orig_obs: 3.23964 SURVEY2
2001 7 2 5.52247 0.285356 #_orig_obs: 2.6008 SURVEY2
2002 7 2 1.35298 0.256526 #_orig_obs: 1.14384 SURVEY2
2003 7 2 3.58532 0.251118 #_orig_obs: 4.91162 SURVEY2
2004 7 2 3.8642 0.216813 #_orig_obs: 3.00794 SURVEY2
2005 7 2 0.74119 0.442247 #_orig_obs: 7.197 SURVEY2
2006 7 2 3.37559 0.262582 #_orig_obs: 1.16222 SURVEY2
2007 7 2 2.28064 0.207801 #_orig_obs: 2.67183 SURVEY2
2008 7 2 2.68142 0.278136 #_orig_obs: 1.23278 SURVEY2
2009 7 2 8.83127 0.238574 #_orig_obs: 3.8308 SURVEY2
2010 7 2 4.23172 0.349767 #_orig_obs: 3.221 SURVEY2
2011 7 2 2.43154 0.341419 #_orig_obs: 1.74111 SURVEY2
2012 7 2 0.737042 0.31142 #_orig_obs: 1.34684 SURVEY2
2013 7 2 1.69353 0.299183 #_orig_obs: 1.20323 SURVEY2
2014 7 2 2.7387 0.233046 #_orig_obs: 1.22977 SURVEY2
2015 7 2 3.79899 0.224989 #_orig_obs: 2.0681 SURVEY2
2016 7 3 3.0134 0.277243 #_orig_obs: 2.10257 SURVEY3
2017 7 3 1.60596 0.265305 #_orig_obs: 1.68606 SURVEY3
2018 7 3 2.77561 0.279247 #_orig_obs: 1.73276 SURVEY3
2019 7 3 1.66046 0.216961 #_orig_obs: 3.19324 SURVEY3
2020 7 3 1.58542 0.662544 #_orig_obs: 1.08219 SURVEY3
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
11 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 46  0 0 0 1 10 10 11 8 4 2 0
 2009 -1 1 0 0 74  1 0 3 9 6 12 18 13 11 0 1
 2010 1 -1 0 0 14  0 0 1 0 4 2 2 2 3 0 0
 2011 -1 -1 0 0 25  0 1 0 1 2 2 7 2 5 4 1
 2012 1 1 0 0 49  0 0 4 3 2 8 16 9 6 0 1
 2013 1 1 0 0 30  0 0 7 1 6 5 2 5 3 1 0
 2014 1 1 0 0 29  1 1 0 1 3 8 6 2 5 1 1
 2015 1 1 0 0 37  0 0 3 4 7 8 11 1 3 0 0
 2016 -1 1 0 0 52  1 1 4 5 5 15 1 8 9 2 1
 2017 -1 -1 0 0 30  0 0 3 3 5 6 1 5 4 2 1
 2018 -1 1 0 0 45  0 0 2 5 2 8 10 9 4 4 1
 2019 1 -1 0 0 19  0 0 3 0 1 6 5 2 2 0 0
 2020 -1 -1 0 0 8  0 0 0 0 0 1 4 1 1 1 0
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

