#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 18:33:09 2023
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
1991 1 1 0.313889 0.5
1992 1 1 0.0136099 0.5
1993 1 1 0.836876 0.461778
1994 1 1 1.15893 0.213268
1995 1 1 1.38481 0.346758
1996 1 1 1.22606 0.5
1997 1 1 1.95225 0.31522
1998 1 1 2.26976 0.258636
1999 1 1 0.968866 0.413156
2000 1 1 0.333839 0.459847
2001 1 1 2.09695 0.35261
2002 1 1 0.673127 0.5
2003 1 1 0.471738 0.463612
2004 1 1 0.715767 0.5
2005 1 1 1.30634 0.5
2006 1 1 0.217719 0.5
2007 1 1 1.36078 0.5
2008 1 1 2.04115 0.482475
2009 1 1 3.25043 0.22864
2010 1 1 0.827347 0.338195
2011 1 1 2.45347 0.5
2012 1 1 0.51165 0.5
2013 1 1 1.27006 0.5
2014 1 1 2.30787 0.375471
2015 1 1 1.92322 0.230871
2016 1 1 3.06083 0.209085
2017 1 1 1.51408 0.207125
2018 1 1 1.51998 0.227297
2019 1 1 0.623688 0.287378
2020 1 1 0.633208 0.357784
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
2 1 0 0 # SURVEY2
3 1 0 0 # SURVEY3
#_year month index obs err
1988 7 2 2.238 0.574785 #_orig_obs: 7.81082 SURVEY2
1989 7 2 2.25661 1.81519 #_orig_obs: 1.59823 SURVEY2
1990 7 2 2.32036 0.789416 #_orig_obs: 0.618024 SURVEY2
1991 7 2 2.40046 1.21602 #_orig_obs: 1.32879 SURVEY2
1992 7 2 2.48908 2.07418 #_orig_obs: 0.140471 SURVEY2
1993 7 2 2.56487 1.00659 #_orig_obs: 1.27683 SURVEY2
1994 7 2 2.60763 0.812407 #_orig_obs: 1.75202 SURVEY2
1995 7 2 2.63605 0.373637 #_orig_obs: 1.14213 SURVEY2
1996 7 2 2.66508 0.527873 #_orig_obs: 2.48333 SURVEY2
1997 7 2 2.67744 0.612886 #_orig_obs: 2.69269 SURVEY2
1998 7 2 2.65746 0.335622 #_orig_obs: 4.4842 SURVEY2
1999 7 2 2.66944 0.38579 #_orig_obs: 1.03521 SURVEY2
2000 7 2 2.74233 1.85432 #_orig_obs: 1.93316 SURVEY2
2001 7 2 2.77937 0.296173 #_orig_obs: 0.832004 SURVEY2
2002 7 2 2.80869 0.701498 #_orig_obs: 0.274742 SURVEY2
2003 7 2 2.89274 0.843952 #_orig_obs: 3.47715 SURVEY2
2004 7 2 2.98021 0.468208 #_orig_obs: 1.6717 SURVEY2
2005 7 2 3.04529 0.584569 #_orig_obs: 10.9754 SURVEY2
2006 7 2 3.12822 1.17209 #_orig_obs: 2.56731 SURVEY2
2007 7 2 3.20724 0.306729 #_orig_obs: 6.78495 SURVEY2
2008 7 2 3.22279 0.372316 #_orig_obs: 8.02493 SURVEY2
2009 7 2 3.16985 0.344886 #_orig_obs: 5.27147 SURVEY2
2010 7 2 3.15149 0.382809 #_orig_obs: 3.90653 SURVEY2
2011 7 2 3.15099 0.370821 #_orig_obs: 4.04162 SURVEY2
2012 7 2 3.15824 0.735788 #_orig_obs: 1.76013 SURVEY2
2013 7 2 3.1982 0.355352 #_orig_obs: 6.56635 SURVEY2
2014 7 2 3.17468 0.285465 #_orig_obs: 5.30543 SURVEY2
2015 7 2 3.12442 0.311759 #_orig_obs: 3.23048 SURVEY2
2016 7 3 5.50662 0.374101 #_orig_obs: 6.97755 SURVEY3
2017 7 3 5.37132 0.442067 #_orig_obs: 3.39722 SURVEY3
2018 7 3 5.31393 0.372228 #_orig_obs: 6.09389 SURVEY3
2019 7 3 5.30329 0.48971 #_orig_obs: 3.47059 SURVEY3
2020 7 3 5.34195 0.608579 #_orig_obs: 10.7093 SURVEY3
2021 7 3 5.41045 1.1764 #_orig_obs: 2.91965 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 81  1.70324 1.10125 1.89307 2.39123 4.13888 7.22516 8.04503 8.91043 9.14086 9.34356 9.51523 8.37554 5.69135 2.62817 0.896993 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2008 1 1 0 0 89  2.12726 1.27271 2.26294 2.95667 3.59655 6.24458 9.60257 10.1864 10.5101 10.3587 10.3672 9.27291 6.33156 2.91958 0.990417 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 1 1 0 0 88  1.70199 1.46831 2.39024 3.23228 3.96533 4.92358 8.29419 10.8467 10.8999 10.5782 10.2357 9.21392 6.34133 2.92226 0.986002 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 1 1 0 0 57  1.28765 0.842151 1.07191 2.64747 3.01343 3.68458 4.18279 5.58751 7.57842 7.4745 6.83645 6.00453 4.19503 1.94285 0.650734 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 54  0.860919 0.803704 1.75784 1.43605 3.26853 3.77918 4.3015 4.81384 6.57418 7.39186 6.71803 5.76573 4.02837 1.87382 0.62644 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 53  0.807252 0.57408 1.25308 2.46862 2.07412 4.07321 4.58505 4.89275 5.77107 7.23181 6.9097 5.81091 4.03487 1.88403 0.629451 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 103  1.84604 1.08609 2.01802 3.44156 6.20492 5.95719 9.70141 10.2616 10.8081 13.2401 13.852 11.6281 7.97778 3.73027 1.24683 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 60  1.12751 0.759482 1.17504 1.69344 2.79811 4.52088 4.82526 6.51425 6.53953 7.25433 8.09448 6.99811 4.74484 2.21421 0.740538 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 1 1 0 0 58  1.01903 0.752667 1.47897 1.65326 2.2665 3.78092 5.22687 5.97221 6.78688 6.87292 7.64356 6.94282 4.69469 2.17971 0.728994 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 40  0.794847 0.491459 0.927298 1.48433 1.58649 2.15214 3.4651 4.15855 4.76263 4.85779 5.11611 4.84641 3.31484 1.5307 0.511316 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 85  2.03379 1.40471 2.41803 2.92604 3.7993 5.22732 6.02279 7.59642 9.85709 10.7418 10.8068 10.2316 7.3731 3.42406 1.13719 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 20  0.478539 0.330521 0.568947 0.688479 0.893953 1.22996 1.41713 1.78739 2.31932 2.52748 2.54278 2.40742 1.73485 0.80566 0.267574 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 12  0.287124 0.198312 0.341368 0.413088 0.536372 0.737975 0.850276 1.07244 1.39159 1.51649 1.52567 1.44445 1.04091 0.483396 0.160545 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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

