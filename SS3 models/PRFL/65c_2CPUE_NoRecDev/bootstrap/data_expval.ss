#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 13:12:16 2023
#_expected_values
#C data file for PRFL
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
28 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0299396 0.5
1968 1 1 0.105688 0.5
1969 1 1 0.0326595 0.5
1970 1 1 0.0113398 0.5
1971 1 1 0.000999985 0.5
1972 1 1 0.308895 0.5
1973 1 1 0.432263 0.5
1974 1 1 0.298455 0.5
1975 1 1 0.395074 0.5
1976 1 1 0.322955 0.5
1977 1 1 0.142428 0.5
1978 1 1 0.057149 0.5
1979 1 1 0.0480792 0.5
1980 1 1 0.381464 0.5
1981 1 1 0.724828 0.5
1982 1 1 0.929393 0.5
1983 1 1 1.87602 0.5
1984 1 1 1.39159 0.5
1985 1 1 1.48729 0.5
1986 1 1 1.19064 0.5
1987 1 1 0.326577 0.5
1988 1 1 0.666756 0.5
1989 1 1 0.138345 0.323813
1990 1 1 0.0154195 0.5
1991 1 1 0.275772 0.419592
1992 1 1 0.0920775 0.5
1993 1 1 0.205015 0.5
1994 1 1 0.480799 0.5
1995 1 1 0.450409 0.5
1996 1 1 0.343812 0.5
1997 1 1 0.988808 0.5
1998 1 1 0.253554 0.429071
1999 1 1 0.359691 0.5
2000 1 1 0.0929878 0.21265
2001 1 1 1.24327 0.460996
2002 1 1 0.735252 0.5
2003 1 1 0.168736 0.5
2004 1 1 0.258084 0.5
2005 1 1 0.379191 0.5
2006 1 1 0.0789282 0.5
2007 1 1 0.197766 0.5
2008 1 1 0.538399 0.5
2009 1 1 1.24145 0.26664
2010 1 1 0.162836 0.356797
2011 1 1 0.356972 0.5
2012 1 1 0.288023 0.5
2013 1 1 0.280764 0.5
2014 1 1 0.292564 0.5
2015 1 1 0.554728 0.479431
2016 1 1 0.600086 0.28581
2017 1 1 0.0925279 0.336114
2018 1 1 0.160567 0.310018
2019 1 1 0.114758 0.378188
2020 1 1 0.0752985 0.407456
2021 1 1 0.011385 0.3993
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
1988 7 2 0.7148 0.535502 #_orig_obs: 1.26781 SURVEY2
1989 7 2 0.764906 0.733527 #_orig_obs: 1.31452 SURVEY2
1990 7 2 0.87426 0.84362 #_orig_obs: 0.285733 SURVEY2
1991 7 2 0.964031 0.668409 #_orig_obs: 1.55058 SURVEY2
1992 7 2 1.0395 0.887774 #_orig_obs: 0.210399 SURVEY2
1993 7 2 1.1152 0.547744 #_orig_obs: 0.910262 SURVEY2
1994 7 2 1.14658 0.679546 #_orig_obs: 1.04117 SURVEY2
1995 7 2 1.15138 0.454168 #_orig_obs: 0.333106 SURVEY2
1996 7 2 1.16765 0.509347 #_orig_obs: 0.335911 SURVEY2
1997 7 2 1.12832 0.45998 #_orig_obs: 1.5483 SURVEY2
1998 7 2 1.1062 0.485659 #_orig_obs: 1.04854 SURVEY2
1999 7 2 1.14193 0.380523 #_orig_obs: 0.951398 SURVEY2
2000 7 2 1.19087 0.36602 #_orig_obs: 2.64972 SURVEY2
2001 7 2 1.14745 0.298521 #_orig_obs: 1.65928 SURVEY2
2002 7 2 1.05506 0.355842 #_orig_obs: 1.02246 SURVEY2
2003 7 2 1.06901 0.519142 #_orig_obs: 1.03766 SURVEY2
2004 7 2 1.12623 0.292555 #_orig_obs: 1.06979 SURVEY2
2005 7 2 1.1596 0.307467 #_orig_obs: 3.75929 SURVEY2
2006 7 2 1.20729 0.494713 #_orig_obs: 0.78982 SURVEY2
2007 7 2 1.26702 0.319489 #_orig_obs: 0.953997 SURVEY2
2008 7 2 1.27702 0.385629 #_orig_obs: 0.685236 SURVEY2
2009 7 2 1.18354 0.391888 #_orig_obs: 2.8065 SURVEY2
2010 7 2 1.1419 0.520813 #_orig_obs: 0.858042 SURVEY2
2011 7 2 1.18163 0.472048 #_orig_obs: 1.24855 SURVEY2
2012 7 2 1.20785 0.507384 #_orig_obs: 4.16799 SURVEY2
2013 7 2 1.23909 0.440492 #_orig_obs: 1.74924 SURVEY2
2014 7 2 1.26689 0.408649 #_orig_obs: 0.475939 SURVEY2
2015 7 2 1.26534 0.360189 #_orig_obs: 0.895968 SURVEY2
2016 7 3 0.88505 0.432958 #_orig_obs: 1.41011 SURVEY3
2017 7 3 0.8968 0.450902 #_orig_obs: 0.490532 SURVEY3
2018 7 3 0.936369 0.320396 #_orig_obs: 1.27304 SURVEY3
2019 7 3 0.971201 0.407751 #_orig_obs: 0.697095 SURVEY3
2020 7 3 1.00818 0.45313 #_orig_obs: 0.907046 SURVEY3
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
53 # maximum size in the population (lower edge of last bin) 
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
10 #_N_LengthBins
 21 24 27 30 33 36 39 42 45 48
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 -1 1 0 0 94  2.09243 5.41527 12.065 13.2584 15.8992 18.3162 15.92 8.217 2.36943 0.447079
 2012 -1 -1 0 0 79  1.75853 4.55113 10.1397 11.1427 13.3621 15.3934 13.3796 6.90577 1.99133 0.375736
 2013 1 1 0 0 83  1.81556 4.71157 10.501 11.5277 13.9715 16.3955 14.2773 7.3086 2.09599 0.395182
 2015 1 1 0 0 40  0.865496 2.22131 4.93434 5.43557 6.65732 7.96384 7.05891 3.63175 1.03771 0.193753
 2018 -1 1 0 0 52  1.06233 2.77249 6.22039 6.96017 8.66781 10.4545 9.34262 4.85732 1.40062 0.261805
 2019 1 -1 0 0 16  0.32687 0.853073 1.91397 2.14159 2.66702 3.21676 2.87465 1.49456 0.430959 0.0805553
 2020 -1 -1 0 0 12  0.245152 0.639805 1.43547 1.60619 2.00026 2.41257 2.15599 1.12092 0.323219 0.0604165
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

