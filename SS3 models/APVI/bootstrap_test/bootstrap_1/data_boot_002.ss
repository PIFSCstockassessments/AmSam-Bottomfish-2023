#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Aug 26 11:23:41 2022
#_bootdata:_4
#C data file for APVI
#_bootstrap file: 2  irand_seed: 123 first rand#: 0.714754
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
#_catch_biomass(mtons):_columns_are_fisheries,year,season
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0 0.01
1967 1 1 0.0374821 0.5
1968 1 1 0.468158 0.5
1969 1 1 0.0372171 0.5
1970 1 1 0.0223304 0.5
1971 1 1 0.000117407 0.5
1972 1 1 1.06803 0.5
1973 1 1 0.205528 0.5
1974 1 1 0.552464 0.5
1975 1 1 5.75683 0.5
1976 1 1 0.561511 0.5
1977 1 1 0.423529 0.5
1978 1 1 0.034119 0.5
1979 1 1 0.123849 0.5
1980 1 1 1.2917 0.5
1981 1 1 0.220124 0.5
1982 1 1 13.5109 0.5
1983 1 1 3.77154 0.5
1984 1 1 0.920987 0.5
1985 1 1 2.86472 0.5
1986 1 1 26.8103 0.958972
1987 1 1 0.116135 1.27453
1988 1 1 2.28047 1.0556
1989 1 1 0.411115 0.250473
1990 1 1 0.223928 0.435616
1991 1 1 0.741664 0.234849
1992 1 1 0.917884 0.357252
1993 1 1 0.188625 0.333495
1994 1 1 3.32024 0.202063
1995 1 1 0.395847 0.336023
1996 1 1 7.16816 0.387366
1997 1 1 1.146 0.214793
1998 1 1 0.0785014 0.412477
1999 1 1 0.503058 0.65065
2000 1 1 0.935178 0.462061
2001 1 1 1.6433 0.326622
2002 1 1 1.31595 0.328972
2003 1 1 0.401903 0.168046
2004 1 1 14.0269 0.875579
2005 1 1 0.525481 1.15885
2006 1 1 0.288111 1.1507
2007 1 1 1.68806 0.758785
2008 1 1 1.40583 0.426328
2009 1 1 4.56494 0.144623
2010 1 1 0.814947 0.313912
2011 1 1 2.39853 0.647973
2012 1 1 0.0106934 1.31425
2013 1 1 0.574041 0.825895
2014 1 1 1.48526 0.39786
2015 1 1 1.52615 0.27296
2016 1 1 3.74384 0.161684
2017 1 1 2.30681 0.171379
2018 1 1 1.04055 0.160734
2019 1 1 0.931901 0.162174
2020 1 1 0.670607 0.152501
2021 1 1 0.0714507 0.293454
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 5.52884 0.2 #_orig_obs: 5.8794 FISHERY
2017 7 1 7.00633 0.2 #_orig_obs: 7.47907 FISHERY
2018 7 1 8.66809 0.2 #_orig_obs: 9.24545 FISHERY
2019 7 1 7.112 0.2 #_orig_obs: 7.47686 FISHERY
2020 7 1 7.91322 0.2 #_orig_obs: 7.87036 FISHERY
2021 7 1 9.59662 0.348863 #_orig_obs: 9.36184 FISHERY
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
0 1e-07 0 0 0 0 1 #_fleet:1_FISHERY
15 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 69  0 0 0 4 5 8 12 23 9 4 4 0 0 0 0
 2007 1 1 0 0 125  0 0 0 4 5 21 26 21 27 6 12 2 1 0 0
 2008 1 1 0 0 136  0 0 0 0 13 19 35 22 17 16 12 2 0 0 0
 2009 1 1 0 0 152  0 0 0 6 12 14 31 23 26 18 13 5 4 0 0
 2011 1 1 0 0 60  0 0 1 4 3 16 11 8 7 5 5 0 0 0 0
 2013 1 1 0 0 47  0 0 0 2 3 9 13 5 10 3 2 0 0 0 0
 2014 1 1 0 0 165  0 0 0 10 11 20 33 27 23 21 9 11 0 0 0
 2015 1 1 0 0 125  0 0 0 8 7 8 21 26 20 22 9 4 0 0 0
 2016 1 1 0 0 162  0 0 0 6 10 22 26 26 25 28 13 6 0 0 0
 2017 1 1 0 0 83  0 0 0 2 5 18 15 13 16 5 5 3 1 0 0
 2018 1 1 0 0 51  0 0 0 0 2 9 11 14 5 7 2 1 0 0 0
 2019 1 1 0 0 80  0 0 0 2 6 9 19 14 12 9 7 2 0 0 0
 2020 1 1 0 0 89  0 0 0 0 13 16 18 15 10 8 6 2 1 0 0
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
# 0 0 -1958543293 67 0 0 0 #_fleet:1_FISHERY
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

