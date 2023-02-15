#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 15:38:40 2023
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
1973 1 1 0.230416 0.5
1974 1 1 0.159207 0.5
1975 1 1 0.210466 0.5
1976 1 1 0.172357 0.5
1977 1 1 0.0757485 0.5
1978 1 1 0.0303894 0.5
1979 1 1 0.0253995 0.5
1980 1 1 0.376473 0.5
1981 1 1 0.715756 0.5
1982 1 1 0.917601 0.5
1983 1 1 1.85198 0.5
1984 1 1 1.37389 0.5
1985 1 1 1.46823 0.5
1986 1 1 0.669022 0.5
1987 1 1 0.136074 0.5
1988 1 1 0.356966 0.5
1989 1 1 0.214542 0.46734
1990 1 1 0.158294 0.5
1991 1 1 0.0444485 0.2
1992 1 1 0.126096 0.5
1993 1 1 0.0943471 0.5
1994 1 1 0.297551 0.2
1995 1 1 0.175534 0.5
1996 1 1 0.190954 0.5
1997 1 1 0.319769 0.5
1998 1 1 0.170994 0.5
1999 1 1 0.114756 0.5
2000 1 1 0.0594178 0.2
2001 1 1 0.0771072 0.5
2002 1 1 0.0576079 0.5
2003 1 1 0.057148 0.5
2004 1 1 0.0857271 0.5
2005 1 1 0.165555 0.5
2006 1 1 0.0612282 0.5
2007 1 1 0.130626 0.5
2008 1 1 0.255823 0.5
2009 1 1 0.0943473 0.329973
2010 1 1 0.0857275 0.318367
2011 1 1 0.0757478 0.5
2012 1 1 0.0317461 0.5
2013 1 1 0.073478 0.5
2014 1 1 0.127007 0.5
2015 1 1 0.109767 0.5
2016 1 1 0.259446 0.2
2017 1 1 0.244934 0.2
2018 1 1 0.126547 0.218618
2019 1 1 0.0716683 0.273842
2020 1 1 0.0503488 0.418
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
1988 7 2 0.473891 0.532433 #_orig_obs: 0.718043 SURVEY2
1989 7 2 0.506491 1.55851 #_orig_obs: 0.040459 SURVEY2
1990 7 2 0.545117 0.378722 #_orig_obs: 1.0312 SURVEY2
1991 7 2 0.584783 0.491903 #_orig_obs: 0.48602 SURVEY2
1992 7 2 0.614628 0.354886 #_orig_obs: 1.61627 SURVEY2
1993 7 2 0.628745 0.359025 #_orig_obs: 1.35723 SURVEY2
1994 7 2 0.620795 0.267463 #_orig_obs: 0.873832 SURVEY2
1995 7 2 0.601735 0.345639 #_orig_obs: 0.403526 SURVEY2
1996 7 2 0.586854 0.259826 #_orig_obs: 0.479578 SURVEY2
1997 7 2 0.562175 0.369656 #_orig_obs: 0.315515 SURVEY2
1998 7 2 0.540644 0.323622 #_orig_obs: 0.505689 SURVEY2
1999 7 2 0.532894 0.280695 #_orig_obs: 0.477694 SURVEY2
2000 7 2 0.531987 0.349006 #_orig_obs: 1.00128 SURVEY2
2001 7 2 0.533228 0.327011 #_orig_obs: 0.267711 SURVEY2
2002 7 2 0.536997 0.382145 #_orig_obs: 0.242338 SURVEY2
2003 7 2 0.54876 1.07876 #_orig_obs: 0.462395 SURVEY2
2004 7 2 0.573591 0.735447 #_orig_obs: 0.311426 SURVEY2
2005 7 2 0.615995 1.24971 #_orig_obs: 2.82213 SURVEY2
2006 7 2 0.658528 1.27572 #_orig_obs: 0.931512 SURVEY2
2007 7 2 0.679238 0.959618 #_orig_obs: 0.740543 SURVEY2
2008 7 2 0.675773 1.07231 #_orig_obs: 0.478926 SURVEY2
2009 7 2 0.668782 1.11706 #_orig_obs: 0.700709 SURVEY2
2010 7 2 0.661755 1.1921 #_orig_obs: 0.659603 SURVEY2
2011 7 2 0.655006 1.15347 #_orig_obs: 0.474267 SURVEY2
2012 7 2 0.670097 1.83793 #_orig_obs: 0.430804 SURVEY2
2013 7 2 0.698375 1.1852 #_orig_obs: 0.65323 SURVEY2
2014 7 2 0.73671 1.10087 #_orig_obs: 0.218502 SURVEY2
2015 7 2 0.773268 1.09468 #_orig_obs: 0.488005 SURVEY2
2016 7 3 0.545882 0.257633 #_orig_obs: 0.864366 SURVEY3
2017 7 3 0.555063 0.28097 #_orig_obs: 0.765316 SURVEY3
2018 7 3 0.561242 0.303678 #_orig_obs: 0.49539 SURVEY3
2019 7 3 0.569226 0.541214 #_orig_obs: 0.195021 SURVEY3
2020 7 3 0.575568 0.585558 #_orig_obs: 0.241016 SURVEY3
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
 2007 1 1 0 0 57  0.271587 0.376132 1.50652 3.86966 5.67915 8.35129 9.08294 8.30877 7.16878 5.79801 3.86774 1.94228 0.777135 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38  0.219267 0.301183 1.1137 2.63431 2.99267 3.88676 4.51379 5.44236 5.98705 5.26304 3.44057 1.60801 0.597286 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 16  0.0923228 0.126814 0.468926 1.10918 1.26007 1.63653 1.90054 2.29152 2.52086 2.21602 1.44866 0.677058 0.251489 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13  0.0750123 0.103036 0.381002 0.901211 1.02381 1.32968 1.54419 1.86186 2.0482 1.80051 1.17704 0.550109 0.204335 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 62  0.428242 0.61797 2.75885 6.55022 6.98921 7.55571 6.7017 6.90794 7.63619 7.19974 5.11013 2.5634 0.980711 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16  0.110514 0.159476 0.711962 1.69038 1.80367 1.94986 1.72947 1.78269 1.97063 1.858 1.31874 0.661523 0.253087 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 6  0.0414427 0.0598036 0.266986 0.633892 0.676375 0.731198 0.648551 0.66851 0.738986 0.696749 0.494528 0.248071 0.0949076 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 68  0.303699 0.491613 3.19607 7.18252 6.70354 8.64049 9.34848 8.99224 8.22972 6.89243 4.6698 2.38731 0.962095 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 32  0.142917 0.231347 1.50403 3.38001 3.15461 4.06611 4.39928 4.23164 3.87281 3.2435 2.19755 1.12344 0.452751 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 61  0.304452 0.42994 1.86436 4.94757 7.00412 8.17241 8.0727 8.45946 8.02508 6.50607 4.24881 2.11697 0.848057 0 0 0 0 0 0 0 0 0 0 0 0 0
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

