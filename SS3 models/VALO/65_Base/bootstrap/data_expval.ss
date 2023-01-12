#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Jan 10 12:39:45 2023
#_expected_values
#C data file for VALO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
15 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0131496 0.5
1968 1 1 0.0467187 0.5
1969 1 1 0.0145096 0.5
1970 1 1 0.00498985 0.5
1971 1 1 0.00099997 0.5
1972 1 1 0.136076 0.5
1973 1 1 0.190054 0.5
1974 1 1 0.131535 0.5
1975 1 1 0.174174 0.5
1976 1 1 0.142425 0.5
1977 1 1 0.0625976 0.5
1978 1 1 0.024949 0.5
1979 1 1 0.0213192 0.5
1980 1 1 0.215452 0.5
1981 1 1 0.409124 0.5
1982 1 1 0.524788 0.5
1983 1 1 1.05954 0.5
1984 1 1 0.786021 0.5
1985 1 1 0.839987 0.5
1986 1 1 0.626802 0.5
1987 1 1 0.202279 0.5
1988 1 1 0.533373 0.5
1989 1 1 0.460808 0.488049
1990 1 1 0.125178 0.5
1991 1 1 0.220433 0.309938
1992 1 1 0.125631 0.5
1993 1 1 0.143331 0.5
1994 1 1 0.387348 0.5
1995 1 1 0.35333 0.5
1996 1 1 0.313872 0.5
1997 1 1 0.645423 0.5
1998 1 1 0.0644059 0.5
1999 1 1 0.217708 0.5
2000 1 1 0.207279 0.5
2001 1 1 0.274406 0.5
2002 1 1 0.554261 0.5
2003 1 1 0.725249 0.296677
2004 1 1 0.279392 0.5
2005 1 1 0.136071 0.5
2006 1 1 0.122013 0.5
2007 1 1 0.280305 0.5
2008 1 1 0.397329 0.5
2009 1 1 0.561059 0.262737
2010 1 1 0.16918 0.5
2011 1 1 0.271685 0.5
2012 1 1 0.0798256 0.5
2013 1 1 0.348792 0.5
2014 1 1 0.294365 0.5
2015 1 1 0.161472 0.5
2016 1 1 0.0630469 0.309637
2017 1 1 0.0557874 0.347708
2018 1 1 0.0648571 0.2
2019 1 1 0.185962 0.2
2020 1 1 0.112485 0.24518
2021 1 1 0.0140594 0.470573
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
2016 7 1 0.113117 0.554733 #_orig_obs: 0.0720188 FISHERY
2017 7 1 0.120549 0.764977 #_orig_obs: 0.0882858 FISHERY
2018 7 1 0.126789 1.02772 #_orig_obs: 0.0365718 FISHERY
2019 7 1 0.129555 0.48149 #_orig_obs: 0.207781 FISHERY
2020 7 1 0.130653 0.59806 #_orig_obs: 0.196344 FISHERY
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
57 # maximum size in the population (lower edge of last bin) 
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
13 #_N_LengthBins
 15 18 21 24 27 30 33 36 39 42 45 48 51
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 59  0.165884 1.4975 4.5505 12.4066 11.2387 9.65739 7.37897 5.3205 3.53844 1.97654 0.856964 0.296797 0.115136 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 68  0.187002 1.67169 5.08583 13.9051 12.7033 11.268 8.91271 6.37679 4.12338 2.28121 0.999289 0.350253 0.135435 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 63  0.171602 1.52305 4.56447 12.4322 11.5153 10.4148 8.48749 6.25006 4.03178 2.19178 0.95354 0.334986 0.128982 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 47  0.130088 1.16396 3.4756 9.38247 8.43834 7.54215 6.24284 4.72992 3.11803 1.69421 0.729835 0.254757 0.0978071 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 79  0.215818 1.92244 5.84494 15.9047 14.3044 12.5856 10.2589 7.85533 5.30896 2.93126 1.26338 0.437659 0.166604 0 0 0 0 0 0 0 0 0 0 0 0 0
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

