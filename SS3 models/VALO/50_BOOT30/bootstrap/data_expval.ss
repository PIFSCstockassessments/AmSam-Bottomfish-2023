#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Dec 13 10:28:22 2022
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
1968 1 1 0.0467188 0.5
1969 1 1 0.0145096 0.5
1970 1 1 0.00498986 0.5
1971 1 1 0.000999973 0.5
1972 1 1 0.136076 0.5
1973 1 1 0.190054 0.5
1974 1 1 0.131536 0.5
1975 1 1 0.174175 0.5
1976 1 1 0.142425 0.5
1977 1 1 0.0625979 0.5
1978 1 1 0.0249492 0.5
1979 1 1 0.0213193 0.5
1980 1 1 0.215453 0.5
1981 1 1 0.409127 0.5
1982 1 1 0.524792 0.5
1983 1 1 1.05955 0.5
1984 1 1 0.786034 0.5
1985 1 1 0.840006 0.5
1986 1 1 0.626822 0.5
1987 1 1 0.202287 0.5
1988 1 1 0.53339 0.5
1989 1 1 0.460823 0.488049
1990 1 1 0.125183 0.5
1991 1 1 0.220439 0.309938
1992 1 1 0.125634 0.5
1993 1 1 0.143334 0.5
1994 1 1 0.387354 0.5
1995 1 1 0.353335 0.5
1996 1 1 0.313877 0.5
1997 1 1 0.645433 0.5
1998 1 1 0.064407 0.5
1999 1 1 0.217711 0.5
2000 1 1 0.207281 0.5
2001 1 1 0.274409 0.5
2002 1 1 0.554268 0.5
2003 1 1 0.725259 0.296677
2004 1 1 0.279397 0.5
2005 1 1 0.136074 0.5
2006 1 1 0.122015 0.5
2007 1 1 0.280308 0.5
2008 1 1 0.397334 0.5
2009 1 1 0.561067 0.262737
2010 1 1 0.169182 0.5
2011 1 1 0.271688 0.5
2012 1 1 0.0798267 0.5
2013 1 1 0.348796 0.5
2014 1 1 0.294368 0.5
2015 1 1 0.161473 0.5
2016 1 1 0.0630475 0.309637
2017 1 1 0.0557879 0.347708
2018 1 1 0.0648577 0.2
2019 1 1 0.185964 0.2
2020 1 1 0.112486 0.24518
2021 1 1 0.0140595 0.470573
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
2016 7 1 0.115657 0.554733 #_orig_obs: 0.0720188 FISHERY
2017 7 1 0.121409 0.764977 #_orig_obs: 0.0882858 FISHERY
2018 7 1 0.126199 1.02772 #_orig_obs: 0.0365718 FISHERY
2019 7 1 0.128239 0.48149 #_orig_obs: 0.207781 FISHERY
2020 7 1 0.128982 0.59806 #_orig_obs: 0.196344 FISHERY
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
 2011 1 1 0 0 59  0.336688 0.896971 5.16929 10.4132 11.7822 10.0458 7.68019 5.54487 3.66671 2.06795 0.92725 0.335816 0.133139 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 68  0.379412 1.0062 5.79052 11.7308 13.4287 11.7262 9.13969 6.54012 4.24173 2.38529 1.08087 0.394725 0.155703 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 63  0.348435 0.920502 5.25379 10.5977 12.1902 10.8442 8.66508 6.30784 4.06788 2.25913 1.02261 0.375155 0.147549 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 47  0.263997 0.698297 3.98049 7.95706 8.99147 7.92495 6.40771 4.7681 3.11471 1.7232 0.774535 0.283806 0.111667 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 79  0.438508 1.16352 6.69234 13.4353 15.1861 13.2361 10.6065 7.97194 5.30559 2.96156 1.32827 0.48426 0.189984 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 1 0 0 38  0.196695 0.516612 2.9624 6.02824 7.02034 6.36801 5.2918 4.08443 2.7988 1.61611 0.742917 0.271046 0.10261 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 -1 0 0 5  0.0258809 0.0679752 0.389789 0.79319 0.923729 0.837896 0.69629 0.537425 0.368263 0.212646 0.0977522 0.035664 0.0135014 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 1 -1 0 0 3  0.0155285 0.0407851 0.233873 0.475914 0.554237 0.502737 0.417774 0.322455 0.220958 0.127588 0.0586513 0.0213984 0.00810081 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 10  0.0517617 0.13595 0.779578 1.58638 1.84746 1.67579 1.39258 1.07485 0.736526 0.425292 0.195504 0.0713279 0.0270027 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 9  0.0465856 0.122355 0.70162 1.42774 1.66271 1.50821 1.25332 0.967364 0.662874 0.382763 0.175954 0.0641952 0.0243024 0 0 0 0 0 0 0 0 0 0 0 0 0
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

