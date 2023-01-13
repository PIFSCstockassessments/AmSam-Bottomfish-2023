#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Jan 10 12:39:46 2023
#_expected_values
#C data file for APRU
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
#_catch:_columns_are_year,season,fleet,catch,catch_se
#_Catch data: yr, seas, fleet, catch, catch_se
-999 1 1 0 0.01
1967 1 1 0.0172399 0.5
1968 1 1 0.0603298 0.5
1969 1 1 0.0185999 0.5
1970 1 1 0.00679998 0.5
1971 1 1 0.000999997 0.5
1972 1 1 0.176899 0.5
1973 1 1 0.247209 0.5
1974 1 1 0.170999 0.5
1975 1 1 0.226339 0.5
1976 1 1 0.185069 0.5
1977 1 1 0.0816497 0.5
1978 1 1 0.0326599 0.5
1979 1 1 0.0276699 0.5
1980 1 1 0.661338 0.5
1981 1 1 1.2569 0.5
1982 1 1 1.61206 0.5
1983 1 1 3.25315 0.5
1984 1 1 2.4131 0.5
1985 1 1 2.57866 0.5
1986 1 1 1.56579 0.5
1987 1 1 0.465838 0.5
1988 1 1 1.15303 0.5
1989 1 1 0.585588 0.32586
1990 1 1 0.0648597 0.5
1991 1 1 0.12156 0.480854
1992 1 1 0.324319 0.5
1993 1 1 0.181889 0.5
1994 1 1 0.688547 0.363779
1995 1 1 0.433628 0.5
1996 1 1 1.31451 0.5
1997 1 1 1.29138 0.260358
1998 1 1 0.174629 0.5
1999 1 1 0.400979 0.5
2000 1 1 0.522538 0.5
2001 1 1 0.553378 0.348732
2002 1 1 2.20581 0.5
2003 1 1 0.248109 0.310752
2004 1 1 0.439078 0.5
2005 1 1 0.472188 0.5
2006 1 1 0.198669 0.5
2007 1 1 1.25373 0.5
2008 1 1 1.63836 0.5
2009 1 1 3.2527 0.2
2010 1 1 0.677667 0.273691
2011 1 1 1.18886 0.5
2012 1 1 0.531159 0.5
2013 1 1 1.33809 0.5
2014 1 1 1.63111 0.5
2015 1 1 1.8452 0.277979
2016 1 1 1.42835 0.218319
2017 1 1 1.56488 0.2
2018 1 1 0.902186 0.312542
2019 1 1 1.24374 0.34192
2020 1 1 0.239039 0.394157
2021 1 1 0.0335699 0.452443
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
2016 7 1 3.35624 0.329584 #_orig_obs: 2.28554 FISHERY
2017 7 1 3.3192 0.26785 #_orig_obs: 4.49428 FISHERY
2018 7 1 3.30978 0.33701 #_orig_obs: 3.66234 FISHERY
2019 7 1 3.3182 0.318631 #_orig_obs: 2.76398 FISHERY
2020 7 1 3.35695 0.487403 #_orig_obs: 2.54184 FISHERY
2021 7 1 3.45108 0.645362 #_orig_obs: 6.16292 FISHERY
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
 2007 1 1 0 0 137  0.469598 1.51639 3.85605 9.76386 16.3368 18.9594 18.714 17.214 15.1978 12.8758 10.0852 6.78018 3.50575 1.2965 0.42857
 2008 1 1 0 0 113  0.392351 1.27058 3.22831 8.1429 13.5039 15.5558 15.3589 14.1868 12.5527 10.6106 8.30337 5.5823 2.88773 1.06956 0.354221
 2009 1 1 0 0 106  0.377849 1.23391 3.12661 7.83662 12.852 14.5918 14.268 13.1785 11.702 9.89261 7.72878 5.19426 2.68839 0.997295 0.33131
 2010 1 1 0 0 39  0.140949 0.463156 1.18199 2.96955 4.84712 5.42631 5.21553 4.77295 4.24165 3.59349 2.80502 1.88361 0.975296 0.362458 0.120929
 2011 1 1 0 0 58  0.207953 0.684311 1.75005 4.42665 7.30216 8.20819 7.8143 7.04856 6.22828 5.28519 4.12807 2.76976 1.43411 0.533726 0.178692
 2012 1 1 0 0 88  0.313763 1.02532 2.63504 6.68752 11.1082 12.6152 12.0346 10.728 9.36027 7.92136 6.19411 4.15512 2.15092 0.801408 0.269219
 2013 1 1 0 0 52  0.184907 0.603807 1.5397 3.91271 6.52991 7.47973 7.21115 6.42308 5.53131 4.63935 3.62508 2.43263 1.25906 0.469435 0.158127
 2014 1 1 0 0 73  0.261749 0.855018 2.17959 5.50066 9.12779 10.4702 10.1677 9.12413 7.81203 6.47182 5.0323 3.37666 1.74793 0.652138 0.220297
 2015 1 1 0 0 96  0.348081 1.14222 2.90575 7.31795 12.0525 13.71 13.3241 12.046 10.3437 8.48761 6.54084 4.3798 2.26762 0.846766 0.286955
 2016 1 1 0 0 76  0.277542 0.913495 2.33104 5.867 9.63538 10.8756 10.4869 9.49936 8.20815 6.7155 5.12412 3.41412 1.76669 0.660423 0.224618
 2017 1 1 0 0 107  0.391956 1.2918 3.30054 8.32401 13.6867 15.4137 14.7541 13.2911 11.525 9.45095 7.16005 4.73653 2.44588 0.915154 0.312455
 2018 1 1 0 0 52  0.190168 0.626046 1.60274 4.05291 6.68832 7.54796 7.20418 6.44207 5.5714 4.58267 3.4616 2.27308 1.16927 0.437596 0.149992
 2019 -1 1 0 0 81  0.292736 0.959453 2.45629 6.22968 10.3551 11.8177 11.3795 10.1554 8.68966 7.11981 5.3746 3.49625 1.78061 0.664308 0.228945
 2020 -1 -1 0 0 19  0.0686666 0.225057 0.576168 1.46128 2.42898 2.77205 2.66927 2.38212 2.03832 1.67008 1.26071 0.820109 0.417673 0.155825 0.0537032
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

