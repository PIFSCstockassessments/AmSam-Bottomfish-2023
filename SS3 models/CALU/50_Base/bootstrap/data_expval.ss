#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Oct 21 14:02:27 2022
#_expected_values
#C data file for CALU
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
12 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0625981 0.5
1968 1 1 0.221343 0.5
1969 1 1 0.0684879 0.5
1970 1 1 0.0240392 0.5
1971 1 1 0.00099997 0.5
1972 1 1 0.6468 0.5
1973 1 1 0.90443 0.5
1974 1 1 0.624577 0.5
1975 1 1 0.827317 0.5
1976 1 1 0.675821 0.5
1977 1 1 0.298447 0.5
1978 1 1 0.119285 0.5
1979 1 1 0.100696 0.5
1980 1 1 0.375556 0.5
1981 1 1 0.713923 0.5
1982 1 1 0.915314 0.5
1983 1 1 1.84787 0.5
1984 1 1 1.37069 0.5
1985 1 1 1.46461 0.5
1986 1 1 2.32272 0.5
1987 1 1 0.685738 0.5
1988 1 1 1.5077 0.5
1989 1 1 1.25978 0.219248
1990 1 1 0.52833 0.436343
1991 1 1 0.599558 0.2
1992 1 1 0.348312 0.5
1993 1 1 0.386418 0.5
1994 1 1 0.77285 0.243462
1995 1 1 1.29738 0.353295
1996 1 1 1.0773 0.5
1997 1 1 1.76127 0.233877
1998 1 1 0.379131 0.35507
1999 1 1 0.765122 0.5
2000 1 1 0.438567 0.355524
2001 1 1 0.60412 0.260347
2002 1 1 0.419532 0.5
2003 1 1 0.50889 0.273804
2004 1 1 0.581919 0.5
2005 1 1 0.426801 0.5
2006 1 1 0.16737 0.5
2007 1 1 0.517063 0.5
2008 1 1 0.420009 0.5
2009 1 1 1.66507 0.341151
2010 1 1 0.554706 0.296226
2011 1 1 0.379638 0.5
2012 1 1 0.254909 0.5
2013 1 1 0.439959 0.5
2014 1 1 0.274407 0.2
2015 1 1 0.565155 0.2
2016 1 1 0.760184 0.2
2017 1 1 0.675369 0.2
2018 1 1 0.63273 0.2
2019 1 1 0.576943 0.2
2020 1 1 0.338364 0.336051
2021 1 1 0.0367384 0.486827
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
2016 7 1 2.23026 0.277431 #_orig_obs: 2.10368 FISHERY
2017 7 1 2.13942 0.265214 #_orig_obs: 1.69011 FISHERY
2018 7 1 2.09941 0.279132 #_orig_obs: 1.73726 FISHERY
2019 7 1 2.09701 0.216929 #_orig_obs: 3.19905 FISHERY
2020 7 1 2.17368 0.662376 #_orig_obs: 1.08715 FISHERY
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
72 # maximum size in the population (lower edge of last bin) 
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
11 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 54.64  0.857341 0.514703 2.91027 3.77119 6.52994 11.3391 11.748 9.68672 5.31256 1.68193 0.288301
 2009 -1 1 0 0 105.48  1.77136 1.08884 6.20784 8.22356 14.0748 23.3113 21.9029 16.2778 8.71927 3.19037 0.711951
 2010 1 -1 0 0 22.68  0.380873 0.23412 1.33479 1.76821 3.02632 5.01233 4.70949 3.50001 1.87479 0.685983 0.153082
 2011 -1 -1 0 0 31.92  0.536043 0.329502 1.8786 2.48859 4.25927 7.05439 6.62818 4.92594 2.6386 0.965458 0.215448
 2012 1 1 0 0 79.8  1.22377 0.740303 4.18076 5.46321 9.58797 17.1618 17.485 13.7397 7.14273 2.49582 0.578971
 2013 1 1 0 0 48.04  0.709035 0.430139 2.4202 3.14447 5.4523 9.58895 10.4685 8.85922 4.904 1.68195 0.381198
 2015 1 1 0 0 59.64  0.844606 0.51623 2.89432 3.79696 6.57324 11.4463 12.1699 10.9532 7.10243 2.74153 0.601324
 2016 -1 1 0 0 63  0.932311 0.574516 3.23773 4.23817 7.30148 12.4829 12.7907 10.8616 6.8854 2.96745 0.727777
 2017 -1 -1 0 0 33.6  0.497232 0.306409 1.72679 2.26036 3.89412 6.65756 6.82169 5.79284 3.67221 1.58264 0.388148
 2018 -1 1 0 0 63.84  0.943131 0.578869 3.26097 4.28832 7.42903 12.8938 13.2807 11.0723 6.61873 2.7369 0.737269
 2019 1 -1 0 0 31.08  0.459156 0.281818 1.58758 2.08773 3.61676 6.27726 6.46561 5.39044 3.22228 1.33244 0.358934
 2020 -1 -1 0 0 11.76  0.173735 0.106634 0.600705 0.789953 1.3685 2.37518 2.44645 2.03963 1.21924 0.504165 0.135813
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 0 1734125568 0 0 0 #_fleet:1_FISHERY
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

