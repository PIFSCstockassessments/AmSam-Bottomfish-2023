#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jul 01 08:13:02 2022
#_echo_input_data
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
2 #_Nfleets (including surveys)
#_fleet_type: 1=catch fleet; 2=bycatch only fleet; 3=survey; 4=predator(M2) 
#_sample_timing: -1 for fishing fleet to use season-long catch-at-age for observations, or 1 to use observation month;  (always 1 for surveys)
#_fleet_area:  area the fleet/survey operates in 
#_units of catch:  1=bio; 2=num (ignored for surveys; their units read later)
#_catch_mult: 0=no; 1=yes
#_rows are fleets
#_fleet_type fishery_timing area catch_units need_catch_mult fleetname
 1 -1 1 1 0 FISHERY  # 1
 3 1 1 1 0 SURVEY2  # 2
#Bycatch_fleet_input_goes_next
#a:  fleet index
#b:  1=include dead bycatch in total dead catch for F0.1 and MSY optimizations and forecast ABC; 2=omit from total catch for these purposes (but still include the mortality)
#c:  1=Fmult scales with other fleets; 2=bycatch F constant at input value; 3=bycatch F from range of years
#d:  F or first year of range
#e:  last year of range
#f:  not used
# a   b   c   d   e   f 
#_Catch data: yr, seas, fleet, catch, catch_se
#_catch_se:  standard error of log(catch)
#_NOTE:  catch data is ignored for survey fleets
-999 1 1 0 0.01
1967 1 1 0.09389 0.8
1968 1 1 0.28123 0.8
1969 1 1 0.12428 0.8
1970 1 1 0.03583 0.8
1971 1 1 0.001 0.8
1972 1 1 0.90537 0.8
1973 1 1 1.35533 0.8
1974 1 1 1.05052 0.8
1975 1 1 1.5091 0.8
1976 1 1 1.08907 0.8
1977 1 1 0.62641 0.8
1978 1 1 0.28032 0.8
1979 1 1 0.14061 0.8
1980 1 1 0.35199 0.8
1981 1 1 0.66859 0.8
1982 1 1 0.85729 0.8
1983 1 1 1.72229 0.8
1984 1 1 1.27732 0.8
1985 1 1 1.36531 0.8
1986 1 1 1.19068 1.5455
1987 1 1 0.32659 1.91043
1988 1 1 0.66678 1.48391
1989 1 1 0.13835 0.323813
1990 1 1 0.01542 2.27603
1991 1 1 0.27578 0.419592
1992 1 1 0.09208 1.35083
1993 1 1 0.20502 0.852752
1994 1 1 0.48081 0.51674
1995 1 1 0.45042 0.756735
1996 1 1 0.34382 1.31219
1997 1 1 0.98883 0.502527
1998 1 1 0.25356 0.429071
1999 1 1 0.3597 0.777907
2000 1 1 0.09299 0.21265
2001 1 1 1.2433 0.460996
2002 1 1 0.73527 0.510285
2003 1 1 0.16874 1.00799
2004 1 1 0.25809 1.77669
2005 1 1 0.3792 1.56054
2006 1 1 0.07802 2.06989
2007 1 1 0.1955 1.88739
2008 1 1 0.53705 1.19815
2009 1 1 1.24148 0.26664
2010 1 1 0.16284 0.356797
2011 1 1 0.35516 1.51772
2012 1 1 0.21682 1.76271
2013 1 1 0.27533 1.95832
2014 1 1 0.29166 1.48957
2015 1 1 0.55429 0.479778
2016 1 1 0.33248 0.28581
2017 1 1 0.09253 0.336114
2018 1 1 0.16057 0.310018
2019 1 1 0.11476 0.378188
2020 1 1 0.0753 0.407456
2021 1 1 0 0.01
-9999 0 0 0 0
#
 #_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; 30=spawnbio; 31=recdev; 32=spawnbio*recdev; 33=recruitment; 34=depletion(&see Qsetup); 35=parm_dev(&see Qsetup)
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet Units Errtype SD_Report
1 1 0 0 # FISHERY
2 1 0 0 # SURVEY2
#_yr month fleet obs stderr
1988 7 1 1.543 0.634499 #_ FISHERY
1989 7 1 1.56486 1.08311 #_ FISHERY
1990 7 1 0.459496 1.0818 #_ FISHERY
1991 7 1 1.30975 0.800765 #_ FISHERY
1992 7 1 0.576018 1.10605 #_ FISHERY
1993 7 1 0.82287 0.823458 #_ FISHERY
1994 7 1 1.67961 0.820447 #_ FISHERY
1995 7 1 0.848656 0.61159 #_ FISHERY
1996 7 1 0.693822 0.585733 #_ FISHERY
1997 7 1 1.90131 0.523619 #_ FISHERY
1998 7 1 1.61406 0.638549 #_ FISHERY
1999 7 1 0.754126 0.616612 #_ FISHERY
2000 7 1 0.0740475 2.012 #_ FISHERY
2001 7 1 0.785226 0.507981 #_ FISHERY
2002 7 1 0.151277 0.66714 #_ FISHERY
2003 7 1 0.423467 2.05279 #_ FISHERY
2004 7 1 0.62489 0.432836 #_ FISHERY
2005 7 1 3.67673 0.832054 #_ FISHERY
2006 7 1 0.681422 0.908632 #_ FISHERY
2007 7 1 0.708053 0.442827 #_ FISHERY
2008 7 1 0.810713 0.419661 #_ FISHERY
2009 7 1 2.8227 0.423204 #_ FISHERY
2010 7 1 1.06655 0.571762 #_ FISHERY
2011 7 1 1.15496 0.515648 #_ FISHERY
2012 7 1 3.23148 0.657018 #_ FISHERY
2013 7 1 1.92739 0.518555 #_ FISHERY
2014 7 1 0.369111 0.498564 #_ FISHERY
2015 7 1 0.745509 0.398199 #_ FISHERY
2016 7 1 0.649438 0.632032 #_ FISHERY
2017 7 1 0.226266 0.596162 #_ FISHERY
2018 7 1 0.500271 0.49606 #_ FISHERY
2019 7 1 0.268819 0.632031 #_ FISHERY
2020 7 1 0.310655 0.723857 #_ FISHERY
1988 7 2 0.133196 1.57412 #_ SURVEY2
1989 7 2 2.06973 0.882697 #_ SURVEY2
1990 7 2 0.155333 1.18814 #_ SURVEY2
1991 7 2 2.87902 1.24988 #_ SURVEY2
1992 7 2 0.0133505 1.4397 #_ SURVEY2
1993 7 2 3.66788 0.5987 #_ SURVEY2
1994 7 2 0.319028 1.48624 #_ SURVEY2
1995 7 2 0.105709 0.666322 #_ SURVEY2
1996 7 2 0.00354459 1.48448 #_ SURVEY2
1998 7 2 0.201221 0.775055 #_ SURVEY2
1999 7 2 0.800918 0.49398 #_ SURVEY2
2000 7 2 3.86248 0.314445 #_ SURVEY2
2001 7 2 2.38489 0.341492 #_ SURVEY2
2002 7 2 3.50263 0.346857 #_ SURVEY2
2003 7 2 2.41307 0.414338 #_ SURVEY2
2004 7 2 2.93378 0.337159 #_ SURVEY2
2005 7 2 5.06324 0.22252 #_ SURVEY2
2006 7 2 0.70029 0.631816 #_ SURVEY2
2007 7 2 1.73535 0.432021 #_ SURVEY2
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
65 # maximum size in the population (lower edge of last bin) 
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
0 1e-07 0 0 0 0 1 #_fleet:2_SURVEY2
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
8 #_N_LengthBins; then enter lower edge of each length bin
 20 25 30 35 40 45 50 55
#_yr month fleet sex part Nsamp datavector(female-male)
 2012 1 1 0 0 84.84 4 19 33 22 17 4 2 0
 2013 1 1 0 0 89.88 3 15 38 30 15 3 1 2
 2015 1 1 0 0 42.84 1 5 16 16 10 2 1 0
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
# 0 0 67 67 0 0 0 #_fleet:1_FISHERY
# 0 0 0 0 0 0 0 #_fleet:2_SURVEY2
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
0 # do tags (0/1/2); where 2 allows entry of TG_min_recap
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

