#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jan 05 21:16:00 2023
#_expected_values
#C data file for ETCO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
55 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0775598 0.5
1968 1 1 0.273059 0.5
1969 1 1 0.0843698 0.5
1970 1 1 0.0299399 0.5
1971 1 1 0.000999998 0.5
1972 1 1 0.798318 0.5
1973 1 1 1.11674 0.5
1974 1 1 0.771558 0.5
1975 1 1 1.02149 0.5
1976 1 1 0.834608 0.5
1977 1 1 0.368319 0.5
1978 1 1 0.14742 0.5
1979 1 1 0.12428 0.5
1980 1 1 1.89193 0.5
1981 1 1 3.59471 0.5
1982 1 1 4.6103 0.5
1983 1 1 9.30496 0.5
1984 1 1 6.90184 0.5
1985 1 1 7.37583 0.5
1986 1 1 3.95938 0.5
1987 1 1 0.796956 0.5
1988 1 1 1.37392 0.5
1989 1 1 0.667687 0.410435
1990 1 1 0.143339 0.5
1991 1 1 0.313888 0.5
1992 1 1 0.0136099 0.5
1993 1 1 0.836876 0.461778
1994 1 1 1.15892 0.213268
1995 1 1 1.38481 0.346758
1996 1 1 1.22605 0.5
1997 1 1 1.95225 0.31522
1998 1 1 2.26976 0.258636
1999 1 1 0.968866 0.413156
2000 1 1 0.333839 0.459847
2001 1 1 2.09695 0.35261
2002 1 1 0.673127 0.5
2003 1 1 0.471738 0.463612
2004 1 1 0.715767 0.5
2005 1 1 1.30633 0.5
2006 1 1 0.217719 0.5
2007 1 1 1.36077 0.5
2008 1 1 2.04115 0.482475
2009 1 1 3.25043 0.22864
2010 1 1 0.827346 0.338195
2011 1 1 2.45347 0.5
2012 1 1 0.51165 0.5
2013 1 1 1.27005 0.5
2014 1 1 2.30787 0.375471
2015 1 1 1.92322 0.230871
2016 1 1 3.06083 0.209085
2017 1 1 1.51408 0.207125
2018 1 1 1.51998 0.227297
2019 1 1 0.623687 0.287378
2020 1 1 0.633207 0.357784
2021 1 1 0.155579 0.5
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
2016 7 1 5.45471 0.374101 #_orig_obs: 6.97755 FISHERY
2017 7 1 5.32032 0.442067 #_orig_obs: 3.39722 FISHERY
2018 7 1 5.30267 0.372228 #_orig_obs: 6.09389 FISHERY
2019 7 1 5.35303 0.48971 #_orig_obs: 3.47059 FISHERY
2020 7 1 5.47163 0.608579 #_orig_obs: 10.7093 FISHERY
2021 7 1 5.62526 1.1764 #_orig_obs: 2.91965 FISHERY
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
-1 0.001 0 0 1 1 0.001 #_fleet:1_FISHERY
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 81  1.59273 1.08954 2.02475 2.90371 3.95156 5.30505 6.79679 8.18992 9.352 10.0251 10.0262 9.1056 6.52997 3.07775 1.02929 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2008 1 1 0 0 89  1.76886 1.20935 2.2402 3.21686 4.37157 5.83659 7.45012 8.96643 10.2088 10.9945 11.0359 9.99678 7.1681 3.39794 1.13806 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 1 1 0 0 88  1.79065 1.22715 2.27633 3.24642 4.40571 5.85352 7.40184 8.85481 10.0221 10.7774 10.8488 9.81026 7.02177 3.34107 1.12217 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 1 1 0 0 57  1.16965 0.803181 1.50294 2.15995 2.92628 3.87288 4.87412 5.75584 6.44335 6.87819 6.9448 6.29661 4.49726 2.14845 0.726497 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 54  1.10831 0.76065 1.41561 2.04995 2.79184 3.70677 4.65467 5.48834 6.10515 6.48312 6.53665 5.93894 4.24299 2.02883 0.688184 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 53  1.0763 0.73806 1.37786 1.97963 2.72 3.63885 4.59019 5.41668 6.01777 6.36145 6.40339 5.83087 4.17258 1.99717 0.679214 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 103  2.11265 1.44342 2.68092 3.86853 5.2664 7.0851 8.98177 10.6023 11.7485 12.3455 12.3643 11.2561 8.06489 3.86292 1.31671 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 60  1.24502 0.853901 1.58581 2.2683 3.09599 4.13113 5.25803 6.22367 6.87836 7.18565 7.14482 6.48748 4.65112 2.2293 0.761417 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 1 1 0 0 58  1.22427 0.839948 1.56566 2.23836 3.02596 4.03275 5.09615 6.04774 6.6807 6.93965 6.84347 6.18274 4.4306 2.12486 0.727128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 85  1.77881 1.218 2.27285 3.28724 4.4966 6.00856 7.572 8.92406 9.89471 10.3062 10.0181 8.86276 6.29712 3.02284 1.04012 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 20  0.418544 0.286589 0.534787 0.773469 1.05802 1.41378 1.78165 2.09978 2.32817 2.42499 2.3572 2.08536 1.48167 0.711256 0.244733 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 12  0.251126 0.171953 0.320872 0.464081 0.634815 0.848268 1.06899 1.25987 1.3969 1.455 1.41432 1.25121 0.889004 0.426754 0.14684 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

