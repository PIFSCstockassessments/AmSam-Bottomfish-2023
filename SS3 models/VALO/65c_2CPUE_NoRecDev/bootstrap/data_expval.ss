#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 18:40:33 2023
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
1967 1 1 0.0131497 0.5
1968 1 1 0.046719 0.5
1969 1 1 0.0145097 0.5
1970 1 1 0.00498989 0.5
1971 1 1 0.000999978 0.5
1972 1 1 0.136077 0.5
1973 1 1 0.190056 0.5
1974 1 1 0.131537 0.5
1975 1 1 0.174176 0.5
1976 1 1 0.142426 0.5
1977 1 1 0.0625984 0.5
1978 1 1 0.0249494 0.5
1979 1 1 0.0213195 0.5
1980 1 1 0.215455 0.5
1981 1 1 0.409129 0.5
1982 1 1 0.524796 0.5
1983 1 1 1.05956 0.5
1984 1 1 0.786043 0.5
1985 1 1 0.840019 0.5
1986 1 1 0.626834 0.5
1987 1 1 0.202291 0.5
1988 1 1 0.533399 0.5
1989 1 1 0.460832 0.488049
1990 1 1 0.125185 0.5
1991 1 1 0.220442 0.309938
1992 1 1 0.125636 0.5
1993 1 1 0.143335 0.5
1994 1 1 0.387358 0.5
1995 1 1 0.353339 0.5
1996 1 1 0.31388 0.5
1997 1 1 0.64544 0.5
1998 1 1 0.0644078 0.5
1999 1 1 0.217713 0.5
2000 1 1 0.207284 0.5
2001 1 1 0.274412 0.5
2002 1 1 0.554273 0.5
2003 1 1 0.725267 0.296677
2004 1 1 0.2794 0.5
2005 1 1 0.136075 0.5
2006 1 1 0.122016 0.5
2007 1 1 0.280311 0.5
2008 1 1 0.397338 0.5
2009 1 1 0.561072 0.262737
2010 1 1 0.169184 0.5
2011 1 1 0.271691 0.5
2012 1 1 0.0798275 0.5
2013 1 1 0.3488 0.5
2014 1 1 0.294371 0.5
2015 1 1 0.161475 0.5
2016 1 1 0.0630481 0.309637
2017 1 1 0.0557884 0.347708
2018 1 1 0.0648582 0.2
2019 1 1 0.185965 0.2
2020 1 1 0.112487 0.24518
2021 1 1 0.0140596 0.470573
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
1988 7 2 0.375066 0.442144 #_orig_obs: 0.725111 SURVEY2
1989 7 2 0.374913 0.447588 #_orig_obs: 1.05546 SURVEY2
1990 7 2 0.39694 0.635159 #_orig_obs: 0.598141 SURVEY2
1991 7 2 0.429031 0.727144 #_orig_obs: 0.543579 SURVEY2
1992 7 2 0.457113 0.485891 #_orig_obs: 0.454334 SURVEY2
1993 7 2 0.484847 0.355219 #_orig_obs: 0.949736 SURVEY2
1994 7 2 0.493759 0.337693 #_orig_obs: 0.555863 SURVEY2
1995 7 2 0.489718 0.340477 #_orig_obs: 0.765703 SURVEY2
1996 7 2 0.48921 0.301863 #_orig_obs: 0.523809 SURVEY2
1997 7 2 0.471907 0.293594 #_orig_obs: 0.827052 SURVEY2
1998 7 2 0.472199 0.503304 #_orig_obs: 1.0306 SURVEY2
1999 7 2 0.493601 0.454739 #_orig_obs: 0.4466 SURVEY2
2000 7 2 0.505015 0.455078 #_orig_obs: 0.76759 SURVEY2
2001 7 2 0.511321 0.438622 #_orig_obs: 0.350591 SURVEY2
2002 7 2 0.497478 0.299211 #_orig_obs: 0.465726 SURVEY2
2003 7 2 0.461554 0.373003 #_orig_obs: 2.24649 SURVEY2
2004 7 2 0.447131 0.32376 #_orig_obs: 0.251503 SURVEY2
2005 7 2 0.465078 0.820074 #_orig_obs: 0.828458 SURVEY2
2006 7 2 0.489509 0.43275 #_orig_obs: 0.614719 SURVEY2
2007 7 2 0.502828 0.372378 #_orig_obs: 0.48951 SURVEY2
2008 7 2 0.499342 0.320139 #_orig_obs: 0.668206 SURVEY2
2009 7 2 0.48081 0.331131 #_orig_obs: 0.268249 SURVEY2
2010 7 2 0.478072 0.399714 #_orig_obs: 0.29675 SURVEY2
2011 7 2 0.490032 0.35508 #_orig_obs: 0.524326 SURVEY2
2012 7 2 0.505727 0.527969 #_orig_obs: 0.166168 SURVEY2
2013 7 2 0.514313 0.431793 #_orig_obs: 0.233972 SURVEY2
2014 7 2 0.510638 0.322711 #_orig_obs: 0.153917 SURVEY2
2015 7 2 0.516996 0.334265 #_orig_obs: 0.0813002 SURVEY2
2016 7 3 0.117596 0.554733 #_orig_obs: 0.0720188 SURVEY3
2017 7 3 0.12206 0.764977 #_orig_obs: 0.0882858 SURVEY3
2018 7 3 0.125757 1.02772 #_orig_obs: 0.0365718 SURVEY3
2019 7 3 0.127218 0.48149 #_orig_obs: 0.207781 SURVEY3
2020 7 3 0.127816 0.59806 #_orig_obs: 0.196344 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
13 #_N_LengthBins
 15 18 21 24 27 30 33 36 39 42 45 48 51
#_yr month fleet sex part Nsamp datavector(female-male)
 2011 1 1 0 0 59  0.149274 1.48444 4.69595 11.628 10.2789 9.15928 7.48113 5.80491 4.13382 2.47414 1.14739 0.41157 0.151183 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 68  0.16996 1.67958 5.32248 13.1981 11.7147 10.6359 8.8466 6.81557 4.77959 2.85078 1.33044 0.480147 0.176157 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 63  0.156661 1.54092 4.83596 11.9694 10.7237 9.84247 8.32209 6.50657 4.54629 2.68638 1.25104 0.452587 0.165907 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 47  0.117936 1.1663 3.65239 8.98717 7.90476 7.21344 6.16131 4.89367 3.4552 2.03772 0.944229 0.340906 0.124966 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 79  0.196906 1.94213 6.14663 15.194 13.3554 12.0615 10.2125 8.16987 5.84793 3.47407 1.60865 0.578827 0.211597 0 0 0 0 0 0 0 0 0 0 0 0 0
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

