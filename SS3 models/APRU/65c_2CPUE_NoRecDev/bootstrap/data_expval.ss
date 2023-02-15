#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 11:29:36 2023
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
1990 1 1 0.0648598 0.5
1991 1 1 0.12156 0.480854
1992 1 1 0.324319 0.5
1993 1 1 0.181889 0.5
1994 1 1 0.688548 0.363779
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
2019 1 1 1.24375 0.34192
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
2 1 0 0 # SURVEY2
3 1 0 0 # SURVEY3
#_year month index obs err
1988 7 2 3.02221 0.480853 #_orig_obs: 3.31766 SURVEY2
1989 7 2 3.03218 0.655261 #_orig_obs: 4.38344 SURVEY2
1990 7 2 3.08411 0.730541 #_orig_obs: 1.01195 SURVEY2
1991 7 2 3.15167 1.14118 #_orig_obs: 0.341136 SURVEY2
1992 7 2 3.20563 0.475798 #_orig_obs: 3.8732 SURVEY2
1993 7 2 3.25326 0.605981 #_orig_obs: 1.97042 SURVEY2
1994 7 2 3.28243 0.456141 #_orig_obs: 3.10011 SURVEY2
1995 7 2 3.29905 0.455237 #_orig_obs: 0.697241 SURVEY2
1996 7 2 3.28854 0.388859 #_orig_obs: 7.55531 SURVEY2
1997 7 2 3.24523 0.324699 #_orig_obs: 8.08944 SURVEY2
1998 7 2 3.24768 0.509816 #_orig_obs: 0.90584 SURVEY2
1999 7 2 3.28381 0.716144 #_orig_obs: 2.08778 SURVEY2
2000 7 2 3.30555 0.942537 #_orig_obs: 2.87446 SURVEY2
2001 7 2 3.31996 0.327502 #_orig_obs: 0.888636 SURVEY2
2002 7 2 3.26695 0.40469 #_orig_obs: 1.54778 SURVEY2
2003 7 2 3.2306 0.645976 #_orig_obs: 1.91066 SURVEY2
2004 7 2 3.26202 0.276477 #_orig_obs: 1.63569 SURVEY2
2005 7 2 3.28489 0.521236 #_orig_obs: 6.83968 SURVEY2
2006 7 2 3.3162 0.536235 #_orig_obs: 6.02226 SURVEY2
2007 7 2 3.3148 0.492058 #_orig_obs: 13.5906 SURVEY2
2008 7 2 3.25783 0.681538 #_orig_obs: 7.11609 SURVEY2
2009 7 2 3.12465 0.790196 #_orig_obs: 17.0292 SURVEY2
2010 7 2 3.04059 0.844219 #_orig_obs: 9.98222 SURVEY2
2011 7 2 3.03853 0.790559 #_orig_obs: 6.79409 SURVEY2
2012 7 2 3.04675 0.955451 #_orig_obs: 7.45462 SURVEY2
2013 7 2 3.0499 0.838519 #_orig_obs: 7.43068 SURVEY2
2014 7 2 3.01179 0.31081 #_orig_obs: 3.26671 SURVEY2
2015 7 2 2.956 0.32666 #_orig_obs: 4.15589 SURVEY2
2016 7 3 3.35446 0.329584 #_orig_obs: 2.28554 SURVEY3
2017 7 3 3.31915 0.26785 #_orig_obs: 4.49428 SURVEY3
2018 7 3 3.3114 0.33701 #_orig_obs: 3.66234 SURVEY3
2019 7 3 3.31905 0.318631 #_orig_obs: 2.76398 SURVEY3
2020 7 3 3.35756 0.487403 #_orig_obs: 2.54184 SURVEY3
2021 7 3 3.44755 0.645362 #_orig_obs: 6.16292 SURVEY3
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
 2007 1 1 0 0 137  0.467499 1.51747 3.87134 9.80004 16.3424 18.9132 18.6545 17.17 15.1802 12.8835 10.1124 6.81486 3.53195 1.30829 0.432321
 2008 1 1 0 0 113  0.390374 1.27063 3.239 8.16887 13.5065 15.5207 15.3133 14.1516 12.5378 10.6173 8.32643 5.61134 2.90955 1.07931 0.357301
 2009 1 1 0 0 106  0.375491 1.23206 3.13247 7.85228 12.8452 14.5577 14.2313 13.1519 11.6922 9.90204 7.75322 5.22339 2.70975 1.00672 0.334249
 2010 1 1 0 0 39  0.13998 0.46205 1.18281 2.97169 4.8391 5.41062 5.20328 4.7667 4.24123 3.5993 2.81581 1.89553 0.983742 0.36611 0.122051
 2011 1 1 0 0 58  0.206605 0.682869 1.75161 4.42956 7.28667 8.1787 7.79296 7.04113 6.23126 5.29664 4.14609 2.78881 1.44732 0.539367 0.180406
 2012 1 1 0 0 88  0.311808 1.02378 2.63831 6.69326 11.0838 12.5639 11.9941 10.7146 9.3685 7.9432 6.2246 4.18603 2.17197 0.810293 0.271894
 2013 1 1 0 0 52  0.183776 0.602981 1.54242 3.91783 6.51712 7.44856 7.18305 6.41132 5.53588 4.654 3.64466 2.45185 1.27197 0.474844 0.159745
 2014 1 1 0 0 73  0.260038 0.853494 2.18253 5.50736 9.11139 10.4278 10.1267 9.1033 7.81633 6.49404 5.06228 3.4053 1.76685 0.659998 0.222632
 2015 1 1 0 0 96  0.345609 1.1393 2.90773 7.3226 12.028 13.6566 13.2727 12.0175 10.3469 8.5179 6.58358 4.42007 2.29377 0.857523 0.290128
 2016 1 1 0 0 76  0.275469 0.910691 2.33108 5.86709 9.61113 10.8319 10.4492 9.47914 8.21069 6.74003 5.16031 3.44823 1.78855 0.669322 0.227224
 2017 1 1 0 0 107  0.388962 1.28753 3.29959 8.32083 13.6464 15.3468 14.7013 13.267 11.5312 9.48659 7.21354 4.78747 2.4783 0.928241 0.316261
 2018 1 1 0 0 52  0.188728 0.624054 1.60233 4.05097 6.6668 7.51253 7.1768 6.43123 5.57613 4.60093 3.48856 2.29903 1.18578 0.444223 0.151907
 2019 -1 1 0 0 81  0.290681 0.95712 2.45754 6.23068 10.325 11.7596 11.3289 10.1324 8.69655 7.14982 5.418 3.53858 1.80785 0.675247 0.232087
 2020 -1 -1 0 0 19  0.0681845 0.22451 0.57646 1.46152 2.42191 2.75842 2.6574 2.37673 2.03993 1.67712 1.27089 0.830038 0.424063 0.158391 0.0544402
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

