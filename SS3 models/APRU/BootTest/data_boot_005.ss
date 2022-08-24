#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Wed Aug 24 09:11:04 2022
#_bootdata:_7
#C data file for APRU
#_bootstrap file: 5  irand_seed: 123 first rand#: -0.473061
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
30 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0190242 0.5
1968 1 1 0.0544416 0.5
1969 1 1 0.0293481 0.5
1970 1 1 0.00642155 0.5
1971 1 1 0.000624124 0.5
1972 1 1 0.214424 0.5
1973 1 1 0.178701 0.5
1974 1 1 0.21175 0.5
1975 1 1 0.118386 0.5
1976 1 1 0.523231 0.5
1977 1 1 0.0855609 0.5
1978 1 1 0.0168622 0.5
1979 1 1 0.0138645 0.5
1980 1 1 1.10045 0.5
1981 1 1 0.681423 0.5
1982 1 1 0.891699 0.5
1983 1 1 1.63748 0.5
1984 1 1 1.7987 0.5
1985 1 1 2.2413 0.5
1986 1 1 0.542884 0.5
1987 1 1 0.538483 0.5
1988 1 1 1.9654 0.5
1989 1 1 0.43119 0.32586
1990 1 1 0.0482654 0.5
1991 1 1 0.0666158 0.480854
1992 1 1 0.313733 0.5
1993 1 1 0.0789905 0.5
1994 1 1 1.08114 0.363779
1995 1 1 0.321085 0.5
1996 1 1 0.897356 0.5
1997 1 1 1.17205 0.260358
1998 1 1 0.111508 0.5
1999 1 1 0.414954 0.5
2000 1 1 0.507867 0.5
2001 1 1 0.388792 0.348732
2002 1 1 2.13509 0.5
2003 1 1 0.349232 0.310752
2004 1 1 0.615825 0.5
2005 1 1 0.32914 0.5
2006 1 1 0.177479 0.5
2007 1 1 2.25854 0.5
2008 1 1 1.56134 0.5
2009 1 1 3.89506 0.2
2010 1 1 0.590493 0.273691
2011 1 1 1.18788 0.5
2012 1 1 0.375687 0.5
2013 1 1 1.57684 0.5
2014 1 1 1.05634 0.5
2015 1 1 1.38772 0.277979
2016 1 1 0.912987 0.218319
2017 1 1 1.1049 0.2
2018 1 1 0.997871 0.312542
2019 1 1 0.885073 0.34192
2020 1 1 0.221914 0.394157
2021 1 1 0.0175671 0.452443
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
#_year month index obs err
2016 7 1 2.94518 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 4.82386 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 5.43414 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 5.66501 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 3.41496 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 9.94501 0.645341 #_orig_obs: 6.1639 FISHERY
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
100 # maximum size in the population (lower edge of last bin) 
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
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 93  0 0 4 5 6 11 14 15 12 7 7 9 3 0 0
 2008 1 1 0 0 80  0 2 4 7 6 12 11 11 5 8 7 3 3 1 0
 2009 1 1 0 0 110  0 0 0 12 14 16 14 14 10 7 11 6 3 3 0
 2010 1 1 0 0 41  0 0 0 7 6 2 4 5 5 5 5 0 2 0 0
 2011 1 1 0 0 61  0 1 1 7 7 11 8 9 5 5 3 3 0 1 0
 2012 1 1 0 0 93  0 1 1 6 11 13 12 16 12 6 6 4 3 2 0
 2013 1 1 0 0 50  0 0 0 5 4 6 13 6 5 4 4 3 0 0 0
 2014 1 1 0 0 71  0 0 0 0 16 5 9 14 9 4 6 4 2 1 1
 2015 1 1 0 0 99  0 1 10 8 15 16 12 12 11 5 7 1 1 0 0
 2016 1 1 0 0 80  0 5 1 2 8 6 13 9 14 12 5 3 1 1 0
 2017 1 1 0 0 104  1 0 3 12 12 14 19 11 14 7 5 3 2 1 0
 2019 -1 1 0 0 84  0 2 2 9 10 10 10 11 9 11 7 2 1 0 0
 2020 -1 -1 0 0 19  0 0 0 2 1 3 2 4 4 1 2 0 0 0 0
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

