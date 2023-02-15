#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 10:06:17 2023
#_expected_values
#C data file for LUKA
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
8 #_Nages=accumulator age, first age is always age 0
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
-999 1 1 0.878101 0.5
1967 1 1 0.8786 0.5
1968 1 1 3.0989 0.5
1969 1 1 0.957978 0.5
1970 1 1 0.337466 0.5
1971 1 1 0.000999989 0.5
1972 1 1 9.06199 0.5
1973 1 1 12.6768 0.5
1974 1 1 8.75349 0.5
1975 1 1 9.7849 0.5
1976 1 1 9.01381 0.5
1977 1 1 4.17932 0.5
1978 1 1 1.6719 0.5
1979 1 1 1.40838 0.5
1980 1 1 1.4102 0.5
1981 1 1 2.67933 0.5
1982 1 1 3.43636 0.5
1983 1 1 6.93542 0.5
1984 1 1 5.14412 0.5
1985 1 1 5.49747 0.5
1986 1 1 5.00895 0.5
1987 1 1 1.6769 0.5
1988 1 1 3.91716 0.467268
1989 1 1 2.77186 0.2
1990 1 1 1.39704 0.245355
1991 1 1 1.13759 0.221413
1992 1 1 0.563353 0.430176
1993 1 1 0.940288 0.324167
1994 1 1 1.84066 0.2
1995 1 1 2.07379 0.252915
1996 1 1 1.41655 0.498858
1997 1 1 2.58635 0.2
1998 1 1 0.427735 0.342705
1999 1 1 0.539313 0.5
2000 1 1 2.05203 0.27585
2001 1 1 2.88935 0.26062
2002 1 1 3.51575 0.207101
2003 1 1 1.14666 0.233131
2004 1 1 1.48323 0.5
2005 1 1 0.583313 0.5
2006 1 1 0.270337 0.5
2007 1 1 0.86635 0.5
2008 1 1 1.25644 0.5
2009 1 1 4.05506 0.2
2010 1 1 1.13533 0.2
2011 1 1 2.00123 0.5
2012 1 1 0.530243 0.5
2013 1 1 1.64879 0.5
2014 1 1 1.80618 0.442494
2015 1 1 1.84882 0.2
2016 1 1 0.564257 0.2
2017 1 1 0.361966 0.2
2018 1 1 0.236317 0.2
2019 1 1 0.342456 0.2
2020 1 1 0.263537 0.2
2021 1 1 0.171458 0.483547
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
1988 7 2 6.15998 0.2 #_orig_obs: 24.9987 SURVEY2
1989 7 2 6.35927 0.325279 #_orig_obs: 34.2855 SURVEY2
1990 7 2 6.91677 0.229948 #_orig_obs: 23.9745 SURVEY2
1991 7 2 7.57191 0.535642 #_orig_obs: 14.9709 SURVEY2
1992 7 2 8.18216 0.209907 #_orig_obs: 8.8606 SURVEY2
1993 7 2 8.58451 0.201402 #_orig_obs: 9.74442 SURVEY2
1994 7 2 8.5585 0.2 #_orig_obs: 8.08246 SURVEY2
1995 7 2 8.32961 0.202118 #_orig_obs: 8.75963 SURVEY2
1996 7 2 8.30681 0.2 #_orig_obs: 7.79769 SURVEY2
1997 7 2 8.15191 0.2 #_orig_obs: 14.7649 SURVEY2
1998 7 2 8.36022 0.520386 #_orig_obs: 6.70285 SURVEY2
1999 7 2 8.83996 0.368026 #_orig_obs: 9.40827 SURVEY2
2000 7 2 8.78069 0.335571 #_orig_obs: 12.8809 SURVEY2
2001 7 2 8.26751 0.217718 #_orig_obs: 11.072 SURVEY2
2002 7 2 7.65657 0.2 #_orig_obs: 9.04085 SURVEY2
2003 7 2 7.72746 0.226821 #_orig_obs: 4.42107 SURVEY2
2004 7 2 8.10969 0.2 #_orig_obs: 5.25577 SURVEY2
2005 7 2 8.51115 0.485596 #_orig_obs: 3.48025 SURVEY2
2006 7 2 8.97681 0.229839 #_orig_obs: 3.72597 SURVEY2
2007 7 2 9.17875 0.2 #_orig_obs: 3.88106 SURVEY2
2008 7 2 9.09636 0.2 #_orig_obs: 5.84498 SURVEY2
2009 7 2 8.29836 0.2 #_orig_obs: 11.4306 SURVEY2
2010 7 2 8.03583 0.219549 #_orig_obs: 8.33291 SURVEY2
2011 7 2 8.17019 0.204547 #_orig_obs: 8.05161 SURVEY2
2012 7 2 8.47044 0.326237 #_orig_obs: 5.08724 SURVEY2
2013 7 2 8.65054 0.2 #_orig_obs: 6.13803 SURVEY2
2014 7 2 8.52159 0.2 #_orig_obs: 4.24975 SURVEY2
2015 7 2 8.38837 0.2 #_orig_obs: 3.66846 SURVEY2
2016 7 3 1.34386 0.2 #_orig_obs: 1.78809 SURVEY3
2017 7 3 1.40824 0.208958 #_orig_obs: 1.14939 SURVEY3
2018 7 3 1.46027 0.2 #_orig_obs: 1.38325 SURVEY3
2019 7 3 1.49113 0.2 #_orig_obs: 1.83588 SURVEY3
2020 7 3 1.50875 0.2 #_orig_obs: 1.12559 SURVEY3
2021 7 3 1.52493 0.408432 #_orig_obs: 1.78588 SURVEY3
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
31 # maximum size in the population (lower edge of last bin) 
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
 14 16 18 20 22 24 26 28
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 235  0.706108 4.77236 21.2173 83.7158 98.6313 24.2513 1.46375 0.242058
 2005 1 1 0 0 147  0.431247 2.8683 12.7779 51.152 62.6175 16.0395 0.961957 0.151609
 2006 1 1 0 0 147  0.419673 2.76316 12.239 49.6358 63.422 17.2972 1.07074 0.152449
 2007 1 1 0 0 292  0.825109 5.40101 23.9071 96.6613 126.19 36.3458 2.36418 0.305133
 2008 1 1 0 0 346  0.984641 6.46652 28.5527 114.556 148.417 43.6982 2.96119 0.363524
 2009 1 1 0 0 456  1.36143 9.13629 40.0279 155.408 191.255 54.587 3.74659 0.478413
 2010 1 1 0 0 144  0.439295 2.98047 13.1845 50.9975 59.4915 15.7064 1.0504 0.149994
 2011 1 1 0 0 782  2.34582 15.8832 70.3036 275.799 327.116 84.311 5.43061 0.811615
 2012 1 1 0 0 1255  3.69696 24.6581 110.125 438.121 530.997 137.511 8.59128 1.29974
 2013 1 1 0 0 2416  7.02908 46.708 206.385 826.94 1032.17 276.93 17.3306 2.50613
 2014 1 1 0 0 1062  3.12384 20.8019 91.9529 363.633 450.795 122.764 7.82601 1.10363
 2015 1 1 0 0 1023  3.0364 20.3587 89.7607 353.172 431.19 116.853 7.56533 1.06417
 2016 1 1 0 0 369  1.08086 7.21201 32.0162 127.149 156.191 42.2233 2.743 0.384156
 2017 1 1 0 0 204  0.581728 3.835 17.0477 68.8655 87.5262 24.3421 1.58876 0.212975
 2018 1 1 0 0 170  0.476138 3.10488 13.7932 56.1706 73.5547 21.3085 1.41371 0.178205
 2019 1 1 0 0 212  0.588302 3.82127 16.9141 68.978 91.9132 27.6685 1.89319 0.223475
 2020 1 1 0 0 155  0.42809 2.7761 12.2898 50.0423 67.1076 20.7275 1.46431 0.16429
 2021 1 1 0 0 87  0.239073 1.54771 6.85661 27.9569 37.6418 11.8108 0.854487 0.0926195
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

