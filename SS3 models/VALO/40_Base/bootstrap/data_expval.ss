#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Oct 07 17:04:14 2022
#_expected_values
#C data file for VALO
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
-999 1 1 0 0.01
1967 1 1 0.0131498 0.5
1968 1 1 0.0467192 0.5
1969 1 1 0.0145098 0.5
1970 1 1 0.00498991 0.5
1971 1 1 0.000999983 0.5
1972 1 1 0.136078 0.5
1973 1 1 0.190056 0.5
1974 1 1 0.131537 0.5
1975 1 1 0.174177 0.5
1976 1 1 0.142427 0.5
1977 1 1 0.0625988 0.5
1978 1 1 0.0249495 0.5
1979 1 1 0.0213196 0.5
1980 1 1 0.215456 0.5
1981 1 1 0.409132 0.5
1982 1 1 0.524799 0.5
1983 1 1 1.05957 0.5
1984 1 1 0.786051 0.5
1985 1 1 0.840029 0.5
1986 1 1 0.634563 1.89066
1987 1 1 0.207744 2.13046
1988 1 1 0.536136 1.61281
1989 1 1 0.463108 0.485919
1990 1 1 0.125637 1.16375
1991 1 1 0.221345 0.308736
1992 1 1 0.126097 1.17621
1993 1 1 0.142877 1.08471
1994 1 1 0.391441 0.777986
1995 1 1 0.349262 0.860831
1996 1 1 0.311613 1.36575
1997 1 1 0.638186 0.800719
1998 1 1 0.0634985 1.11671
1999 1 1 0.215455 1.21675
2000 1 1 0.205475 0.819357
2001 1 1 0.273054 0.673833
2002 1 1 0.551558 0.59292
2003 1 1 0.723914 0.297211
2004 1 1 0.277133 1.73802
2005 1 1 0.134717 2.10174
2006 1 1 0.117477 1.86632
2007 1 1 0.277134 1.70221
2008 1 1 0.394621 1.38037
2009 1 1 0.558357 0.263973
2010 1 1 0.166916 0.524839
2011 1 1 0.267614 1.68139
2012 1 1 0.0784682 2.25571
2013 1 1 0.345172 1.84286
2014 1 1 0.292564 1.01224
2015 1 1 0.159656 0.673679
2016 1 1 0.0630486 0.309637
2017 1 1 0.0553388 0.350369
2018 1 1 0.0648586 0.183459
2019 1 1 0.185966 0.112564
2020 1 1 0.112038 0.246135
2021 1 1 0.0140597 0.470573
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
2016 7 1 0.105111 0.650131 #_orig_obs: 0.0553378 FISHERY
2017 7 1 0.10786 0.795754 #_orig_obs: 0.0754762 FISHERY
2018 7 1 0.110114 1.01432 #_orig_obs: 0.0373757 FISHERY
2019 7 1 0.110986 0.549405 #_orig_obs: 0.187959 FISHERY
2020 7 1 0.111235 0.618714 #_orig_obs: 0.189128 FISHERY
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
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
13 #_N_LengthBins
 15 18 21 24 27 30 33 36 39 42 45 48 51
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 62.16  0.228848 1.01532 5.76703 10.027 12.0753 10.5805 8.70212 6.53229 4.17792 2.0399 0.721733 0.208924 0.0831781 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 72.24  0.262859 1.16625 6.62557 11.5226 13.9425 12.3755 10.2622 7.65586 4.8637 2.37685 0.844461 0.244757 0.0969516 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 66.36  0.240705 1.06157 6.01651 10.4498 12.6923 11.363 9.5364 7.16055 4.53161 2.20654 0.784192 0.227323 0.0894914 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 49.56  0.180654 0.800754 4.53583 7.81956 9.42089 8.40341 7.10125 5.38528 3.42193 1.66287 0.58971 0.170811 0.0670462 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 84  0.304596 1.35036 7.66529 13.3017 16.0141 14.1891 11.953 9.12242 5.84075 2.84561 1.00791 0.291213 0.113936 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 1 0 0 34.44  0.120909 0.530793 3.00988 5.26008 6.42527 5.82519 5.00197 3.876 2.5226 1.24728 0.444928 0.127176 0.0479325 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 -1 0 0 5.04  0.017694 0.077677 0.440471 0.769767 0.940283 0.852467 0.731995 0.567219 0.369161 0.182529 0.0651114 0.0186111 0.00701451 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 1 -1 0 0 2.52  0.008847 0.0388385 0.220235 0.384884 0.470141 0.426233 0.365997 0.28361 0.184581 0.0912646 0.0325557 0.00930553 0.00350725 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 8.4  0.02949 0.129462 0.734118 1.28295 1.56714 1.42078 1.21999 0.945365 0.615269 0.304215 0.108519 0.0310184 0.0116908 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 9.24  0.032439 0.142408 0.80753 1.41124 1.72385 1.56286 1.34199 1.0399 0.676796 0.334637 0.119371 0.0341203 0.0128599 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 0 0 9472 0 0 0 0 #_fleet:1_FISHERY
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

