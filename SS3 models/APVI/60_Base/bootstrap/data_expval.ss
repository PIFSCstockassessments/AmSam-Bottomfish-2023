#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jan 05 21:16:00 2023
#_expected_values
#C data file for APVI
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
-1 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
32 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0861795 0.5
1968 1 1 0.304808 0.5
1969 1 1 0.0943495 0.5
1970 1 1 0.0331098 0.5
1971 1 1 0.000999995 0.5
1972 1 1 0.891305 0.5
1973 1 1 1.24646 0.5
1974 1 1 0.860915 0.5
1975 1 1 1.14032 0.5
1976 1 1 0.931674 0.5
1977 1 1 0.410947 0.5
1978 1 1 0.164649 0.5
1979 1 1 0.138349 0.5
1980 1 1 1.05142 0.5
1981 1 1 1.99761 0.5
1982 1 1 2.56187 0.5
1983 1 1 5.17091 0.5
1984 1 1 3.83554 0.5
1985 1 1 4.09907 0.5
1986 1 1 3.04356 0.5
1987 1 1 0.990175 0.5
1988 1 1 1.32084 0.5
1989 1 1 1.05323 0.250473
1990 1 1 0.555642 0.435616
1991 1 1 1.13805 0.234849
1992 1 1 0.767011 0.357252
1993 1 1 0.967959 0.333495
1994 1 1 1.5871 0.202063
1995 1 1 1.3594 0.336023
1996 1 1 1.97084 0.387366
1997 1 1 1.57848 0.214793
1998 1 1 0.253097 0.412477
1999 1 1 0.487605 0.5
2000 1 1 1.78124 0.462061
2001 1 1 0.992449 0.326622
2002 1 1 1.54401 0.328972
2003 1 1 0.443155 0.2
2004 1 1 1.14758 0.5
2005 1 1 0.727553 0.5
2006 1 1 0.399156 0.5
2007 1 1 1.30452 0.5
2008 1 1 2.35185 0.426328
2009 1 1 4.39527 0.2
2010 1 1 0.770641 0.313912
2011 1 1 1.51452 0.5
2012 1 1 0.463115 0.5
2013 1 1 1.88783 0.5
2014 1 1 2.19491 0.39786
2015 1 1 2.55279 0.27296
2016 1 1 2.99276 0.2
2017 1 1 1.91141 0.2
2018 1 1 0.945726 0.2
2019 1 1 1.24963 0.2
2020 1 1 1.32991 0.2
2021 1 1 0.123378 0.293454
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
2016 7 1 8.54821 0.2 #_orig_obs: 9.82017 FISHERY
2017 7 1 7.78585 0.2 #_orig_obs: 7.16483 FISHERY
2018 7 1 7.82954 0.2 #_orig_obs: 6.45644 FISHERY
2019 7 1 8.16811 0.2 #_orig_obs: 8.3545 FISHERY
2020 7 1 8.37374 0.2 #_orig_obs: 9.42847 FISHERY
2021 7 1 8.98824 0.348927 #_orig_obs: 8.88049 FISHERY
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
94 # maximum size in the population (lower edge of last bin) 
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
 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 -1 1 0 0 130  0.161844 0.351108 0.982368 1.20722 8.52556 16.3634 22.8934 24.3015 21.306 16.2842 10.4095 5.02136 1.64189 0.397233 0.153378
 2005 1 -1 0 0 30  0.0373485 0.0810248 0.2267 0.278589 1.96744 3.77618 5.28309 5.60803 4.91678 3.75789 2.4022 1.15877 0.378897 0.0916692 0.0353949
 2006 -1 -1 0 0 31  0.0385935 0.0837257 0.234257 0.287875 2.03302 3.90205 5.45919 5.79496 5.08067 3.88315 2.48228 1.1974 0.391527 0.0947248 0.0365748
 2007 1 1 0 0 170  0.210512 0.450779 1.25247 1.53469 10.8085 20.7887 29.2493 31.6006 28.2412 21.7567 14.1305 6.93758 2.28612 0.54852 0.203844
 2008 1 1 0 0 161  0.200866 0.438205 1.22917 1.49651 10.5024 19.8572 27.5244 29.4933 26.5191 20.6122 13.4806 6.69431 2.22437 0.532793 0.19465
 2009 1 1 0 0 143  0.183117 0.421813 1.21605 1.47202 10.3038 18.7467 24.7814 25.5663 22.6277 17.6448 11.6124 5.82307 1.95556 0.472176 0.17305
 2010 -1 1 0 0 104  0.133678 0.308404 0.891256 1.1173 7.985 15.0228 19.5471 18.7649 15.3149 11.5449 7.65116 3.91296 1.34621 0.334072 0.125358
 2011 1 -1 0 0 59  0.0758367 0.17496 0.505616 0.633851 4.52995 8.52255 11.0892 10.6455 8.68826 6.54949 4.34056 2.21985 0.763717 0.189522 0.0711168
 2012 -1 -1 0 0 15  0.0192805 0.0444814 0.128547 0.161149 1.15168 2.16675 2.8193 2.70648 2.20888 1.66512 1.10353 0.56437 0.194165 0.0481835 0.0180805
 2013 1 1 0 0 48  0.0612268 0.138675 0.397229 0.488112 3.46352 6.62292 9.17792 9.22219 7.3264 5.19214 3.35768 1.73355 0.607182 0.153304 0.0579453
 2014 1 1 0 0 166  0.213563 0.49567 1.43514 1.74207 12.3259 22.9969 31.244 32.0303 25.8957 17.897 11.2109 5.75763 2.03448 0.520952 0.199807
 2015 1 1 0 0 147  0.191648 0.456773 1.33909 1.63941 11.5804 21.0819 27.6189 27.7934 22.8643 15.7438 9.53566 4.81916 1.71304 0.446878 0.175758
 2016 1 1 0 0 168  0.223473 0.553408 1.65025 2.01931 14.3118 25.6579 32.2499 30.9259 25.1185 17.415 10.3032 5.08043 1.80832 0.484009 0.198427
 2017 1 1 0 0 110  0.14801 0.376225 1.13391 1.40199 9.99289 17.8623 21.9654 20.0161 15.555 10.7402 6.29058 3.02275 1.07105 0.295608 0.127883
 2018 1 1 0 0 60  0.0801694 0.199519 0.596894 0.750304 5.3954 9.91483 12.4145 11.1703 8.30901 5.60279 3.26717 1.5387 0.539175 0.152316 0.068892
 2019 1 1 0 0 85  0.112628 0.273052 0.808722 1.00312 7.23326 13.7123 17.8815 16.4891 12.0354 7.8236 4.50729 2.09339 0.723029 0.20692 0.0967225
 2020 1 1 0 0 86  0.113499 0.274097 0.80985 0.987841 7.07532 13.3823 17.9701 17.2089 12.678 7.97641 4.47514 2.05105 0.698918 0.201615 0.097048
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

