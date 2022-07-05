#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Jul 01 08:27:41 2022
#_echo_input_data
#C data file for PRZO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1987 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
30 #_Nages=accumulator age, first age is always age 0
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
1987 1 1 0.13608 2.31925
1988 1 1 0.35698 1.83391
1989 1 1 0.21455 0.46734
1990 1 1 0.1583 1.01654
1991 1 1 0.04445 0.001
1992 1 1 0.1261 1.14011
1993 1 1 0.09435 1.23881
1994 1 1 0.29756 0.001
1995 1 1 0.17554 1.26849
1996 1 1 0.19096 1.64442
1997 1 1 0.31978 0.636487
1998 1 1 0.171 0.561009
1999 1 1 0.11476 1.44077
2000 1 1 0.05942 0.001
2001 1 1 0.07711 0.775294
2002 1 1 0.05761 1.5447
2003 1 1 0.05715 1.60741
2004 1 1 0.08573 2.307
2005 1 1 0.16556 2.00279
2006 1 1 0.06123 2.18261
2007 1 1 0.13063 2.08633
2008 1 1 0.25583 1.63287
2009 1 1 0.09435 0.329973
2010 1 1 0.08573 0.318367
2011 1 1 0.07575 2.29873
2012 1 1 0.0195 2.80447
2013 1 1 0.07348 2.541
2014 1 1 0.12701 1.93562
2015 1 1 0.10977 1.32974
2016 1 1 0.20366 0.170606
2017 1 1 0.24494 0.174223
2018 1 1 0.12655 0.218618
2019 1 1 0.07167 0.273842
2020 1 1 0.05035 0.418
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
1988 7 1 0.135938 0.797782 #_ FISHERY
1989 7 1 3.84002 1.83823 #_ FISHERY
1990 7 1 0.052121 1.23213 #_ FISHERY
1992 7 1 0.282259 0.932228 #_ FISHERY
1993 7 1 0.148484 0.971261 #_ FISHERY
1995 7 1 0.103745 0.617666 #_ FISHERY
1996 7 1 0.034681 0.791564 #_ FISHERY
1997 7 1 0.214882 0.801747 #_ FISHERY
1998 7 1 0.161064 0.635745 #_ FISHERY
1999 7 1 0.0202346 0.674295 #_ FISHERY
2001 7 1 0.0105801 0.746935 #_ FISHERY
2002 7 1 0.0029372 0.791132 #_ FISHERY
2003 7 1 0.0990985 1.20123 #_ FISHERY
2004 7 1 0.0825488 0.449345 #_ FISHERY
2005 7 1 1.23067 0.700048 #_ FISHERY
2006 7 1 0.424581 0.881765 #_ FISHERY
2007 7 1 0.509484 0.411832 #_ FISHERY
2008 7 1 0.43852 0.415148 #_ FISHERY
2009 7 1 0.324824 0.550797 #_ FISHERY
2010 7 1 0.427907 0.590867 #_ FISHERY
2011 7 1 0.246071 0.584997 #_ FISHERY
2012 7 1 0.231889 1.73724 #_ FISHERY
2013 7 1 0.400621 0.545545 #_ FISHERY
2014 7 1 0.114666 0.532512 #_ FISHERY
2015 7 1 0.196747 0.441958 #_ FISHERY
2016 7 1 0.777736 0.39843 #_ FISHERY
2017 7 1 0.827862 0.380283 #_ FISHERY
2018 7 1 0.296721 0.417782 #_ FISHERY
2019 7 1 0.12744 0.68783 #_ FISHERY
2020 7 1 0.177841 0.786038 #_ FISHERY
1988 7 2 12.3266 0.300372 #_ SURVEY2
1989 7 2 2.62562 0.897694 #_ SURVEY2
1990 7 2 16.2175 0.17618 #_ SURVEY2
1991 7 2 14.687 0.199989 #_ SURVEY2
1992 7 2 15.6172 0.285124 #_ SURVEY2
1993 7 2 16.0102 0.156786 #_ SURVEY2
1994 7 2 13.4775 0.0874557 #_ SURVEY2
1995 7 2 6.74163 0.17701 #_ SURVEY2
1996 7 2 7.18064 0.0847356 #_ SURVEY2
1997 7 2 3.65361 0.146974 #_ SURVEY2
1998 7 2 5.33094 0.161721 #_ SURVEY2
1999 7 2 6.52311 0.103718 #_ SURVEY2
2000 7 2 3.89372 0.138918 #_ SURVEY2
2001 7 2 3.8475 0.143777 #_ SURVEY2
2002 7 2 5.05976 0.173038 #_ SURVEY2
2003 7 2 5.03924 0.168558 #_ SURVEY2
2004 7 2 4.03231 0.156551 #_ SURVEY2
2005 7 2 3.6653 0.118504 #_ SURVEY2
2006 7 2 3.02119 0.152132 #_ SURVEY2
2007 7 2 3.16853 0.232226 #_ SURVEY2
2008 7 2 0.985599 0.426861 #_ SURVEY2
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
55 # maximum size in the population (lower edge of last bin) 
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
16 #_N_LengthBins; then enter lower edge of each length bin
 0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 50.68 0 0 0 0 0 0 2 7 16 43 36 15 5 6 4 0
 2012 1 1 0 0 42.84 0 0 0 0 1 0 3 8 9 9 9 10 0 2 0 0
 2015 1 1 0 0 33.6 0 0 0 0 0 0 1 9 9 3 5 6 3 2 2 0
 2016 1 1 0 0 33.6 0 0 0 0 0 0 2 3 3 14 5 4 5 1 2 1
 2017 1 1 0 0 59.64 1 0 0 0 0 1 1 9 16 12 17 11 2 1 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

