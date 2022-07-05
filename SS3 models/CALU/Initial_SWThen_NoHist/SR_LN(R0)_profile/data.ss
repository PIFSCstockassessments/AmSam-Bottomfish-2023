#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jul 01 13:20:48 2022
#_echo_input_data
#C data file for CALU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1986 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
11 #_Nages=accumulator age, first age is always age 0
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
1986 1 1 2.3115 1.13414
1987 1 1 0.68583 1.50028
1988 1 1 1.50729 0.973998
1989 1 1 1.24375 0.219248
1990 1 1 0.52843 0.436343
1991 1 1 0.59965 0.191672
1992 1 1 0.34836 0.572612
1993 1 1 0.38646 0.512911
1994 1 1 0.77292 0.243462
1995 1 1 1.29727 0.353295
1996 1 1 1.07728 0.620314
1997 1 1 1.74179 0.233877
1998 1 1 0.3792 0.35507
1999 1 1 0.76521 0.52279
2000 1 1 0.43862 0.355524
2001 1 1 0.60418 0.260347
2002 1 1 0.41957 0.577536
2003 1 1 0.50893 0.273804
2004 1 1 0.58196 1.30132
2005 1 1 0.42683 1.48859
2006 1 1 0.16738 1.67434
2007 1 1 0.51709 1.33302
2008 1 1 0.42003 1.33108
2009 1 1 1.66514 0.341151
2010 1 1 0.55474 0.296226
2011 1 1 0.37966 1.47508
2012 1 1 0.2268 1.73491
2013 1 1 0.43998 1.71187
2014 1 1 0.27442 0.194913
2015 1 1 0.56518 0.151294
2016 1 1 0.70125 0.194925
2017 1 1 0.6754 0.166155
2018 1 1 0.63276 0.178726
2019 1 1 0.57697 0.156753
2020 1 1 0.33838 0.336051
2021 1 1 0.03674 0.486827
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
1988 7 1 7.40892 0.284811 #_ FISHERY
1989 7 1 13.0177 0.330986 #_ FISHERY
1990 7 1 6.98086 0.365014 #_ FISHERY
1991 7 1 3.09683 0.367091 #_ FISHERY
1992 7 1 4.9143 0.398859 #_ FISHERY
1993 7 1 0.516948 0.53168 #_ FISHERY
1994 7 1 2.63512 0.351883 #_ FISHERY
1995 7 1 3.43651 0.402687 #_ FISHERY
1996 7 1 2.77021 0.297551 #_ FISHERY
1997 7 1 6.68335 0.266235 #_ FISHERY
1998 7 1 1.49381 0.495289 #_ FISHERY
1999 7 1 1.4556 0.410344 #_ FISHERY
2000 7 1 2.08615 0.545778 #_ FISHERY
2001 7 1 1.72242 0.453862 #_ FISHERY
2002 7 1 0.360302 0.485051 #_ FISHERY
2003 7 1 2.87551 0.276613 #_ FISHERY
2004 7 1 1.95684 0.232615 #_ FISHERY
2005 7 1 5.52132 0.569531 #_ FISHERY
2006 7 1 1.21694 0.401631 #_ FISHERY
2007 7 1 2.49948 0.254221 #_ FISHERY
2008 7 1 1.06739 0.351659 #_ FISHERY
2009 7 1 3.09442 0.271611 #_ FISHERY
2010 7 1 2.57741 0.432084 #_ FISHERY
2011 7 1 1.32969 0.412972 #_ FISHERY
2012 7 1 1.45014 0.404264 #_ FISHERY
2013 7 1 1.17702 0.373825 #_ FISHERY
2014 7 1 1.00344 0.275091 #_ FISHERY
2015 7 1 1.57342 0.261278 #_ FISHERY
2016 7 1 1.53304 0.319963 #_ FISHERY
2017 7 1 1.65464 0.271837 #_ FISHERY
2018 7 1 1.35124 0.315892 #_ FISHERY
2019 7 1 2.41854 0.269604 #_ FISHERY
2020 7 1 0.704827 0.832995 #_ FISHERY
1988 7 2 3.34028 0.796807 #_ SURVEY2
1989 7 2 0.603984 0.984913 #_ SURVEY2
1990 7 2 0.918868 0.854936 #_ SURVEY2
1991 7 2 0.731327 1.05222 #_ SURVEY2
1992 7 2 0.495146 1.27814 #_ SURVEY2
1993 7 2 6.92632 0.412691 #_ SURVEY2
1994 7 2 0.6031 0.644238 #_ SURVEY2
1995 7 2 1.4101 0.628373 #_ SURVEY2
1996 7 2 4.38886 0.571573 #_ SURVEY2
1997 7 2 2.46027 0.635563 #_ SURVEY2
1998 7 2 1.21587 0.977143 #_ SURVEY2
1999 7 2 3.04735 0.587099 #_ SURVEY2
2000 7 2 1.69951 0.627651 #_ SURVEY2
2001 7 2 0.863646 0.809144 #_ SURVEY2
2002 7 2 1.62088 0.773262 #_ SURVEY2
2003 7 2 5.72704 0.516033 #_ SURVEY2
2004 7 2 3.06823 0.508402 #_ SURVEY2
2005 7 2 3.97194 0.434139 #_ SURVEY2
2006 7 2 0.351754 0.870154 #_ SURVEY2
2007 7 2 0.55967 0.680088 #_ SURVEY2
2008 7 2 0.124725 1.02448 #_ SURVEY2
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
95 # maximum size in the population (lower edge of last bin) 
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
18 #_N_LengthBins; then enter lower edge of each length bin
 0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 54.8 0 0 0 1 0 6 13 14 28 25 17 5 3 0 1 0 0 0
 2009 1 1 0 0 51.24 0 0 0 0 0 1 0 0 8 19 19 6 7 0 0 1 0 0
 2012 1 1 0 0 72.24 0 0 0 1 5 12 15 7 9 20 11 6 0 0 0 0 0 0
 2013 1 1 0 0 36.96 0 0 0 0 0 8 3 3 6 12 7 4 0 0 0 0 0 1
 2014 1 1 0 0 38.64 0 0 0 1 2 1 4 8 10 7 7 3 0 1 0 1 1 0
 2015 1 1 0 0 60.48 0 0 0 0 1 9 4 6 9 21 14 6 0 1 0 0 1 0
 2017 1 1 0 0 34.44 1 0 0 0 0 2 3 7 9 8 5 4 2 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

