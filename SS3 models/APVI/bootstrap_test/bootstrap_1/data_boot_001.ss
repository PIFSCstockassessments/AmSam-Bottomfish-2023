#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Aug 26 11:23:41 2022
#_bootdata:_3
#C data file for APVI
#_bootstrap file: 1  irand_seed: 123 first rand#: 0.869031
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
1967 1 1 0.0122641 0.5
1968 1 1 0.368796 0.5
1969 1 1 0.0494818 0.5
1970 1 1 0.0407268 0.5
1971 1 1 0.00028442 0.5
1972 1 1 0.650453 0.5
1973 1 1 0.206274 0.5
1974 1 1 0.669297 0.5
1975 1 1 7.93599 0.5
1976 1 1 1.11224 0.5
1977 1 1 0.269961 0.5
1978 1 1 0.0380812 0.5
1979 1 1 0.25548 0.5
1980 1 1 0.40895 0.5
1981 1 1 0.285079 0.5
1982 1 1 7.52967 0.5
1983 1 1 9.07504 0.5
1984 1 1 1.88144 0.5
1985 1 1 1.44127 0.5
1986 1 1 18.7677 0.958972
1987 1 1 0.219105 1.27453
1988 1 1 10.997 1.0556
1989 1 1 0.716634 0.250473
1990 1 1 0.348387 0.435616
1991 1 1 0.774761 0.234849
1992 1 1 0.388589 0.357252
1993 1 1 0.20199 0.333495
1994 1 1 3.34019 0.202063
1995 1 1 0.498901 0.336023
1996 1 1 8.93802 0.387366
1997 1 1 0.774986 0.214793
1998 1 1 0.132725 0.412477
1999 1 1 0.639061 0.65065
2000 1 1 0.423784 0.462061
2001 1 1 1.1506 0.326622
2002 1 1 0.875466 0.328972
2003 1 1 0.708889 0.168046
2004 1 1 1.51342 0.875579
2005 1 1 0.662665 1.15885
2006 1 1 0.0819889 1.1507
2007 1 1 1.21841 0.758785
2008 1 1 1.73115 0.426328
2009 1 1 4.50687 0.144623
2010 1 1 0.663018 0.313912
2011 1 1 0.558072 0.647973
2012 1 1 0.00178439 1.31425
2013 1 1 1.15895 0.825895
2014 1 1 0.816808 0.39786
2015 1 1 1.11217 0.27296
2016 1 1 3.58607 0.161684
2017 1 1 1.84707 0.171379
2018 1 1 1.30858 0.160734
2019 1 1 1.32785 0.162174
2020 1 1 1.42169 0.152501
2021 1 1 0.109093 0.293454
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 9.77833 0.2 #_orig_obs: 5.8794 FISHERY
2017 7 1 7.45236 0.2 #_orig_obs: 7.47907 FISHERY
2018 7 1 5.86843 0.2 #_orig_obs: 9.24545 FISHERY
2019 7 1 4.37763 0.2 #_orig_obs: 7.47686 FISHERY
2020 7 1 10.7218 0.2 #_orig_obs: 7.87036 FISHERY
2021 7 1 9.87166 0.348863 #_orig_obs: 9.36184 FISHERY
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
 2004 1 1 0 0 69  0 0 0 3 8 12 14 13 11 3 5 0 0 0 0
 2007 1 1 0 0 125  0 0 0 1 9 18 25 19 24 17 8 2 2 0 0
 2008 1 1 0 0 136  0 0 0 0 20 18 25 24 28 15 4 2 0 0 0
 2009 1 1 0 0 152  0 0 0 9 13 24 30 28 23 11 7 4 3 0 0
 2011 1 1 0 0 60  0 1 0 3 8 8 16 11 3 8 2 0 0 0 0
 2013 1 1 0 0 47  0 0 0 2 2 6 10 9 11 4 3 0 0 0 0
 2014 1 1 0 0 165  0 0 0 3 12 17 38 28 27 28 10 2 0 0 0
 2015 1 1 0 0 125  0 0 0 5 10 14 16 24 28 17 5 6 0 0 0
 2016 1 1 0 0 162  0 0 0 9 11 7 35 30 24 22 16 8 0 0 0
 2017 1 1 0 0 83  0 0 0 9 5 5 16 11 15 10 6 4 2 0 0
 2018 1 1 0 0 51  0 0 0 0 9 2 11 10 7 3 3 6 0 0 0
 2019 1 1 0 0 80  0 0 0 6 5 14 13 18 12 5 6 1 0 0 0
 2020 1 1 0 0 89  0 0 0 0 12 8 22 18 11 6 6 3 3 0 0
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

