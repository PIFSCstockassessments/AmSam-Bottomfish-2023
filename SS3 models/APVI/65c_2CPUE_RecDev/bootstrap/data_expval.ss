#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Feb 14 17:26:13 2023
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
1983 1 1 5.17092 0.5
1984 1 1 3.83554 0.5
1985 1 1 4.09907 0.5
1986 1 1 3.04357 0.5
1987 1 1 0.990178 0.5
1988 1 1 1.32084 0.5
1989 1 1 1.05323 0.250473
1990 1 1 0.555644 0.435616
1991 1 1 1.13805 0.234849
1992 1 1 0.767012 0.357252
1993 1 1 0.96796 0.333495
1994 1 1 1.5871 0.202063
1995 1 1 1.35941 0.336023
1996 1 1 1.97084 0.387366
1997 1 1 1.57848 0.214793
1998 1 1 0.253097 0.412477
1999 1 1 0.487604 0.5
2000 1 1 1.78124 0.462061
2001 1 1 0.992446 0.326622
2002 1 1 1.54401 0.328972
2003 1 1 0.443153 0.2
2004 1 1 1.14757 0.5
2005 1 1 0.72755 0.5
2006 1 1 0.399155 0.5
2007 1 1 1.30452 0.5
2008 1 1 2.35185 0.426328
2009 1 1 4.39526 0.2
2010 1 1 0.770639 0.313912
2011 1 1 1.51452 0.5
2012 1 1 0.463114 0.5
2013 1 1 1.88783 0.5
2014 1 1 2.1949 0.39786
2015 1 1 2.55279 0.27296
2016 1 1 2.99276 0.2
2017 1 1 1.91141 0.2
2018 1 1 0.945725 0.2
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
2 1 0 0 # SURVEY2
3 1 0 0 # SURVEY3
#_year month index obs err
1988 7 2 6.20697 0.277587 #_orig_obs: 4.75372 SURVEY2
1989 7 2 6.41867 0.2731 #_orig_obs: 8.1018 SURVEY2
1990 7 2 6.76454 0.270011 #_orig_obs: 8.05459 SURVEY2
1991 7 2 7.02541 0.219878 #_orig_obs: 10.6313 SURVEY2
1992 7 2 7.16552 0.2 #_orig_obs: 9.03863 SURVEY2
1993 7 2 7.2635 0.2 #_orig_obs: 9.44603 SURVEY2
1994 7 2 7.0961 0.2 #_orig_obs: 5.89575 SURVEY2
1995 7 2 6.78844 0.2 #_orig_obs: 6.89141 SURVEY2
1996 7 2 6.33802 0.2 #_orig_obs: 8.19623 SURVEY2
1997 7 2 5.82717 0.2 #_orig_obs: 8.90311 SURVEY2
1998 7 2 5.71178 0.278503 #_orig_obs: 4.57348 SURVEY2
1999 7 2 5.83011 0.21153 #_orig_obs: 4.80176 SURVEY2
2000 7 2 5.57494 0.281606 #_orig_obs: 4.55142 SURVEY2
2001 7 2 5.24323 0.21596 #_orig_obs: 4.36144 SURVEY2
2002 7 2 4.99522 0.2 #_orig_obs: 3.83553 SURVEY2
2003 7 2 4.98123 0.205204 #_orig_obs: 4.0304 SURVEY2
2004 7 2 5.18183 0.2 #_orig_obs: 3.55943 SURVEY2
2005 7 2 5.49171 0.243007 #_orig_obs: 7.44936 SURVEY2
2006 7 2 6.06793 0.246247 #_orig_obs: 5.28453 SURVEY2
2007 7 2 6.53667 0.2 #_orig_obs: 6.52211 SURVEY2
2008 7 2 6.4782 0.2 #_orig_obs: 8.56534 SURVEY2
2009 7 2 5.55965 0.2 #_orig_obs: 9.44756 SURVEY2
2010 7 2 5.06493 0.282948 #_orig_obs: 2.64081 SURVEY2
2011 7 2 5.24776 0.203719 #_orig_obs: 4.48328 SURVEY2
2012 7 2 5.60958 0.359707 #_orig_obs: 4.66645 SURVEY2
2013 7 2 5.99092 0.23893 #_orig_obs: 6.28684 SURVEY2
2014 7 2 5.97986 0.2 #_orig_obs: 5.48007 SURVEY2
2015 7 2 5.72977 0.2 #_orig_obs: 4.21809 SURVEY2
2016 7 3 9.05301 0.2 #_orig_obs: 9.82017 SURVEY3
2017 7 3 8.15984 0.2 #_orig_obs: 7.16483 SURVEY3
2018 7 3 7.96223 0.2 #_orig_obs: 6.45644 SURVEY3
2019 7 3 7.94893 0.2 #_orig_obs: 8.3545 SURVEY3
2020 7 3 7.84229 0.2 #_orig_obs: 9.42847 SURVEY3
2021 7 3 8.24575 0.348927 #_orig_obs: 8.88049 SURVEY3
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
-1 0.001 0 0 1 1 0.001 #_fleet:2_SURVEY2
-1 0.001 0 0 1 1 0.001 #_fleet:3_SURVEY3
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 -1 1 0 0 130  0.184737 0.458064 1.32097 1.77692 12.3752 22.3313 25.881 22.0183 16.3842 11.9575 8.24076 4.66037 1.78399 0.463554 0.163158
 2005 1 -1 0 0 30  0.0426316 0.105707 0.304838 0.410058 2.85581 5.15337 5.97253 5.08115 3.78098 2.75943 1.90171 1.07547 0.411689 0.106974 0.0376517
 2006 -1 -1 0 0 31  0.0440527 0.109231 0.315 0.423726 2.951 5.32515 6.17162 5.25052 3.90701 2.85141 1.9651 1.11132 0.425412 0.11054 0.0389068
 2007 1 1 0 0 170  0.232906 0.465897 1.24575 1.59492 11.1854 25.0138 38.3049 34.6673 23.7765 15.3296 9.84515 5.45022 2.10795 0.568888 0.210791
 2008 1 1 0 0 161  0.233637 0.474445 1.29782 1.32563 9.10104 19.8396 33.5138 36.8256 26.0633 15.5532 9.21305 4.93349 1.90422 0.522587 0.198575
 2009 1 1 0 0 143  0.271582 0.523091 1.5181 1.4145 9.10946 16.3362 26.1408 32.1846 25.9429 15.0997 8.14346 4.12448 1.57579 0.441021 0.174289
 2010 -1 1 0 0 104  0.173696 0.425475 1.27048 1.804 11.5838 15.8283 17.0666 17.3687 16.6315 11.8773 6.04764 2.60181 0.927224 0.271947 0.121614
 2011 1 -1 0 0 59  0.0985391 0.241375 0.720753 1.02342 6.57157 8.97949 9.68202 9.85339 9.43518 6.73806 3.43087 1.47603 0.526021 0.154278 0.0689928
 2012 -1 -1 0 0 15  0.0250523 0.0613666 0.183242 0.260192 1.67074 2.28292 2.46153 2.5051 2.39877 1.71307 0.872256 0.375261 0.133734 0.0392231 0.0175405
 2013 1 1 0 0 48  0.0669752 0.151002 0.422524 0.64359 4.2454 7.75339 10.7243 8.23599 6.27433 4.90714 2.85538 1.17291 0.380366 0.112093 0.054555
 2014 1 1 0 0 166  0.224189 0.503466 1.39062 1.62072 11.9344 25.8911 36.3141 34.4884 22.3632 15.6884 9.65448 4.09021 1.27948 0.370819 0.186352
 2015 1 1 0 0 147  0.193831 0.425965 1.15996 1.40712 9.53801 19.9686 31.3796 32.7292 22.935 13.7122 8.27765 3.65834 1.1311 0.319951 0.163512
 2016 1 1 0 0 168  0.248167 0.475923 1.28627 1.58649 10.7834 21.2798 33.1273 37.613 29.4653 16.8714 9.24696 4.17028 1.29946 0.360661 0.185522
 2017 1 1 0 0 110  0.154677 0.408538 1.19 1.01989 6.91659 13.7858 20.3205 23.6127 20.2292 12.2784 6.16601 2.70799 0.853739 0.235035 0.120839
 2018 1 1 0 0 60  0.0989594 0.187844 0.524557 0.725676 4.61571 7.27186 10.5446 12.0066 10.974 7.29446 3.5957 1.49555 0.469725 0.128932 0.0657672
 2019 1 1 0 0 85  0.134186 0.364527 1.09516 0.828794 5.8529 11.5821 14.4678 16.0915 14.9834 10.8494 5.57492 2.21782 0.679114 0.185081 0.0932275
 2020 1 1 0 0 86  0.137508 0.33653 0.994095 1.20029 7.49152 11.1682 15.3822 15.3563 14.0438 10.7135 5.89023 2.31767 0.68774 0.186315 0.0941698
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

