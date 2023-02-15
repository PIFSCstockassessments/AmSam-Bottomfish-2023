#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 14:22:29 2023
#_expected_values
#C data file for PRZO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
30 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0158797 0.5
1968 1 1 0.0562489 0.5
1969 1 1 0.0172397 0.5
1970 1 1 0.00634988 0.5
1971 1 1 0.000999981 0.5
1972 1 1 0.164647 0.5
1973 1 1 0.230415 0.5
1974 1 1 0.159207 0.5
1975 1 1 0.210466 0.5
1976 1 1 0.172356 0.5
1977 1 1 0.0757484 0.5
1978 1 1 0.0303894 0.5
1979 1 1 0.0253995 0.5
1980 1 1 0.376472 0.5
1981 1 1 0.715755 0.5
1982 1 1 0.917599 0.5
1983 1 1 1.85197 0.5
1984 1 1 1.37388 0.5
1985 1 1 1.4682 0.5
1986 1 1 0.669001 0.5
1987 1 1 0.136069 0.5
1988 1 1 0.356955 0.5
1989 1 1 0.214536 0.46734
1990 1 1 0.15829 0.5
1991 1 1 0.0444476 0.2
1992 1 1 0.126094 0.5
1993 1 1 0.094346 0.5
1994 1 1 0.297548 0.2
1995 1 1 0.175533 0.5
1996 1 1 0.190953 0.5
1997 1 1 0.319769 0.5
1998 1 1 0.170994 0.5
1999 1 1 0.114756 0.5
2000 1 1 0.0594182 0.2
2001 1 1 0.0771078 0.5
2002 1 1 0.0576084 0.5
2003 1 1 0.0571485 0.5
2004 1 1 0.0857278 0.5
2005 1 1 0.165556 0.5
2006 1 1 0.0612285 0.5
2007 1 1 0.130627 0.5
2008 1 1 0.255824 0.5
2009 1 1 0.0943477 0.329973
2010 1 1 0.085728 0.318367
2011 1 1 0.0757482 0.5
2012 1 1 0.0317463 0.5
2013 1 1 0.0734784 0.5
2014 1 1 0.127007 0.5
2015 1 1 0.109768 0.5
2016 1 1 0.259446 0.2
2017 1 1 0.244935 0.2
2018 1 1 0.126547 0.218618
2019 1 1 0.0716684 0.273842
2020 1 1 0.0503489 0.418
2021 1 1 0.00637736 0.453778
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
1988 7 2 0.267957 0.532433 #_orig_obs: 0.718043 SURVEY2
1989 7 2 0.290644 1.55851 #_orig_obs: 0.040459 SURVEY2
1990 7 2 0.328043 0.378722 #_orig_obs: 1.0312 SURVEY2
1991 7 2 0.377838 0.491903 #_orig_obs: 0.48602 SURVEY2
1992 7 2 0.430237 0.354886 #_orig_obs: 1.61627 SURVEY2
1993 7 2 0.477939 0.359025 #_orig_obs: 1.35723 SURVEY2
1994 7 2 0.51188 0.267463 #_orig_obs: 0.873832 SURVEY2
1995 7 2 0.538017 0.345639 #_orig_obs: 0.403526 SURVEY2
1996 7 2 0.569417 0.259826 #_orig_obs: 0.479578 SURVEY2
1997 7 2 0.588564 0.369656 #_orig_obs: 0.315515 SURVEY2
1998 7 2 0.607483 0.323622 #_orig_obs: 0.505689 SURVEY2
1999 7 2 0.638785 0.280695 #_orig_obs: 0.477694 SURVEY2
2000 7 2 0.675726 0.349006 #_orig_obs: 1.00128 SURVEY2
2001 7 2 0.712728 0.327011 #_orig_obs: 0.267711 SURVEY2
2002 7 2 0.74695 0.382145 #_orig_obs: 0.242338 SURVEY2
2003 7 2 0.779501 1.07876 #_orig_obs: 0.462395 SURVEY2
2004 7 2 0.806999 0.735447 #_orig_obs: 0.311426 SURVEY2
2005 7 2 0.824073 1.24971 #_orig_obs: 2.82213 SURVEY2
2006 7 2 0.840654 1.27572 #_orig_obs: 0.931512 SURVEY2
2007 7 2 0.85744 0.959618 #_orig_obs: 0.740543 SURVEY2
2008 7 2 0.858854 1.07231 #_orig_obs: 0.478926 SURVEY2
2009 7 2 0.862185 1.11706 #_orig_obs: 0.700709 SURVEY2
2010 7 2 0.876233 1.1921 #_orig_obs: 0.659603 SURVEY2
2011 7 2 0.890361 1.15347 #_orig_obs: 0.474267 SURVEY2
2012 7 2 0.906902 1.83793 #_orig_obs: 0.430804 SURVEY2
2013 7 2 0.922 1.1852 #_orig_obs: 0.65323 SURVEY2
2014 7 2 0.929013 1.10087 #_orig_obs: 0.218502 SURVEY2
2015 7 2 0.932541 1.09468 #_orig_obs: 0.488005 SURVEY2
2016 7 3 0.568675 0.257633 #_orig_obs: 0.864366 SURVEY3
2017 7 3 0.559201 0.28097 #_orig_obs: 0.765316 SURVEY3
2018 7 3 0.555938 0.303678 #_orig_obs: 0.49539 SURVEY3
2019 7 3 0.560209 0.541214 #_orig_obs: 0.195021 SURVEY3
2020 7 3 0.567529 0.585558 #_orig_obs: 0.241016 SURVEY3
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
44 # maximum size in the population (lower edge of last bin) 
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
13 #_N_LengthBins
 16 18 20 22 24 26 28 30 32 34 36 38 40
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 57  0.28755 0.449446 2.25157 5.13048 5.48358 6.57422 6.93561 7.59494 7.88508 6.84224 4.55636 2.191 0.817937 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38  0.189431 0.295976 1.48428 3.38274 3.61422 4.3282 4.55323 4.9812 5.22447 4.63022 3.15676 1.55995 0.599306 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 16  0.0797606 0.124621 0.624962 1.42431 1.52178 1.8224 1.91715 2.09735 2.19978 1.94957 1.32916 0.656822 0.25234 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13  0.0648055 0.101255 0.507782 1.15725 1.23645 1.4807 1.55769 1.7041 1.78732 1.58402 1.07994 0.533668 0.205026 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 62  0.301651 0.470273 2.35119 5.36024 5.75133 6.94209 7.39458 8.1657 8.61551 7.68981 5.28566 2.6419 1.03006 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16  0.0778455 0.121361 0.606758 1.38329 1.48422 1.79151 1.90828 2.10728 2.22336 1.98447 1.36404 0.681782 0.265822 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 6  0.029192 0.0455103 0.227534 0.518733 0.556581 0.671815 0.715605 0.790229 0.833759 0.744175 0.511516 0.255668 0.0996831 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 68  0.331856 0.517016 2.57481 5.85421 6.24261 7.49952 7.9757 8.87055 9.4795 8.56104 5.93422 2.98618 1.17277 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 32  0.156168 0.243302 1.21168 2.75492 2.9377 3.52919 3.75327 4.17438 4.46094 4.02872 2.79257 1.40526 0.551894 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 61  0.301076 0.469748 2.34542 5.32181 5.62559 6.72016 7.11736 7.89888 8.4541 7.66319 5.33146 2.69138 1.05981 0 0 0 0 0 0 0 0 0 0 0 0 0
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

