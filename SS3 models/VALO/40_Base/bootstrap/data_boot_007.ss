#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Oct 11 12:37:22 2022
#_bootdata:_9
#C data file for VALO
#_bootstrap file: 7  irand_seed: 123 first rand#: -0.215166
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
#_catch_biomass(mtons):_columns_are_fisheries,year,season
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0 0.01
1967 1 1 0.00535432 0.5
1968 1 1 0.0337078 0.5
1969 1 1 0.00801832 0.5
1970 1 1 0.00126177 0.5
1971 1 1 0.000406882 0.5
1972 1 1 0.0623374 0.5
1973 1 1 0.320914 0.5
1974 1 1 0.109719 0.5
1975 1 1 0.0756248 0.5
1976 1 1 0.0808167 0.5
1977 1 1 0.132237 0.5
1978 1 1 0.00700052 0.5
1979 1 1 0.0245582 0.5
1980 1 1 0.0480174 0.5
1981 1 1 0.260394 0.5
1982 1 1 0.400813 0.5
1983 1 1 0.869264 0.5
1984 1 1 1.64001 0.5
1985 1 1 0.13951 0.5
1986 1 1 0.0497353 1.89066
1987 1 1 0.00384539 2.13046
1988 1 1 0.0369067 1.61281
1989 1 1 0.326316 0.485919
1990 1 1 0.00236328 1.16375
1991 1 1 0.175643 0.308736
1992 1 1 0.00887983 1.17621
1993 1 1 0.00543773 1.08471
1994 1 1 30.4855 0.777986
1995 1 1 0.695045 0.860831
1996 1 1 0.00730415 1.36575
1997 1 1 0.98389 0.800719
1998 1 1 0.0145501 1.11671
1999 1 1 0.133739 1.21675
2000 1 1 0.12865 0.819357
2001 1 1 0.0373032 0.673833
2002 1 1 0.272734 0.59292
2003 1 1 0.788666 0.297211
2004 1 1 0.043201 1.73802
2005 1 1 5.65801e-06 2.10174
2006 1 1 0.000274331 1.86632
2007 1 1 0.0100159 1.70221
2008 1 1 0.037987 1.38037
2009 1 1 0.454098 0.263973
2010 1 1 0.0960006 0.524839
2011 1 1 0.00143072 1.68139
2012 1 1 0.0120874 2.25571
2013 1 1 0.00300091 1.84286
2014 1 1 0.0162475 1.01224
2015 1 1 0.563344 0.673679
2016 1 1 0.110128 0.309637
2017 1 1 0.0478528 0.350369
2018 1 1 0.0712447 0.183459
2019 1 1 0.165284 0.112564
2020 1 1 0.191448 0.246135
2021 1 1 0.00389261 0.470573
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 0.040289 0.650131 #_orig_obs: 0.0553378 FISHERY
2017 7 1 0.0326398 0.795754 #_orig_obs: 0.0754762 FISHERY
2018 7 1 0.165818 1.01432 #_orig_obs: 0.0373757 FISHERY
2019 7 1 0.256359 0.549405 #_orig_obs: 0.187959 FISHERY
2020 7 1 0.12703 0.618714 #_orig_obs: 0.189128 FISHERY
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
13 #_N_LengthBins
 15 18 21 24 27 30 33 36 39 42 45 48 51
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 44  0 0 8 4 6 14 7 1 2 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 51  0 0 5 10 8 11 9 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 47  0 2 4 10 12 8 4 4 2 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 35  0 1 3 6 6 7 7 2 1 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 59  0 1 4 10 11 11 7 12 2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 1 0 0 24  0 1 1 5 8 3 1 1 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 -1 0 0 3  0 0 0 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 1 -1 0 0 2  0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 6  0 0 0 0 1 1 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 6  0 1 1 1 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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

