#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Oct 07 17:22:52 2022
#_expected_values
#C data file for LERU
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
-999 1 1 0.104975 0.5
1967 1 1 0.534009 0.5
1968 1 1 1.23015 0.5
1969 1 1 0.455803 0.5
1970 1 1 0.155559 0.5
1971 1 1 0.000996786 0.5
1972 1 1 3.93307 0.5
1973 1 1 5.07771 0.5
1974 1 1 4.98939 0.5
1975 1 1 5.0477 0.5
1976 1 1 5.54874 0.5
1977 1 1 1.26141 0.5
1978 1 1 0.49372 0.5
1979 1 1 0.416554 0.5
1980 1 1 0.55323 0.5
1981 1 1 1.95979 0.5
1982 1 1 3.43659 0.5
1983 1 1 5.05378 0.5
1984 1 1 2.62996 0.5
1985 1 1 2.19829 0.5
1986 1 1 0.238225 0.765988
1987 1 1 0.0881952 1.04738
1988 1 1 1.48975 0.696621
1989 1 1 1.76509 0.181955
1990 1 1 0.917494 0.281466
1991 1 1 0.723509 0.227721
1992 1 1 2.05802 0.456647
1993 1 1 0.687587 0.58728
1994 1 1 2.50779 0.391316
1995 1 1 0.947449 0.464613
1996 1 1 2.30692 0.424734
1997 1 1 1.6663 0.30496
1998 1 1 0.0966724 0.747716
1999 1 1 0.1561 0.880171
2000 1 1 1.37627 0.841994
2001 1 1 4.07275 0.539964
2002 1 1 2.22388 0.477013
2003 1 1 1.61412 0.45899
2004 1 1 0.456716 0.767216
2005 1 1 0.134964 1.06394
2006 1 1 2.82756 1.1658
2007 1 1 0.933588 0.655467
2008 1 1 4.19588 0.327572
2009 1 1 6.77739 0.134277
2010 1 1 1.56625 0.189353
2011 1 1 1.96181 0.31116
2012 1 1 0.77572 0.777087
2013 1 1 1.26519 0.739423
2014 1 1 0.920976 0.343554
2015 1 1 4.41283 0.256762
2016 1 1 0.846368 0.176986
2017 1 1 0.699868 0.20531
2018 1 1 0.328755 0.140656
2019 1 1 1.043 0.145786
2020 1 1 0.410258 0.123537
2021 1 1 0.127077 0.406754
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
2016 7 1 2.09775 0.209826 #_orig_obs: 2.66545 FISHERY
2017 7 1 2.47506 0.21091 #_orig_obs: 2.37861 FISHERY
2018 7 1 2.8785 0.2 #_orig_obs: 2.56887 FISHERY
2019 7 1 3.18566 0.2 #_orig_obs: 3.64435 FISHERY
2020 7 1 3.43107 0.2 #_orig_obs: 2.52009 FISHERY
2021 7 1 3.76036 0.394811 #_orig_obs: 5.68061 FISHERY
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
43 # maximum size in the population (lower edge of last bin) 
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
8 #_N_LengthBins
 14 17.5 21 24.5 28 31.5 35 38.5
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 148.96  0.170781 3.4518 24.8564 52.4564 42.4522 21.0556 4.12541 0.39145 0 0 0 0 0 0 0 0
 2005 1 1 0 0 125.16  0.142025 2.68918 19.3716 42.7352 37.4862 18.8646 3.54289 0.328273 0 0 0 0 0 0 0 0
 2006 1 1 0 0 99.12  0.112956 2.18359 14.8402 32.4706 30.1609 16.0808 3.00444 0.266556 0 0 0 0 0 0 0 0
 2007 1 1 0 0 81.48  0.0929349 1.81946 13.1009 27.0677 23.5467 13.1056 2.52569 0.220999 0 0 0 0 0 0 0 0
 2008 1 1 0 0 250.48  0.289628 6.088 39.9588 83.9281 72.1854 39.4902 7.84857 0.691397 0 0 0 0 0 0 0 0
 2009 1 1 0 0 331.8  0.407937 11.3274 65.0203 116.303 84.4892 44.5247 8.88841 0.83868 0 0 0 0 0 0 0 0
 2010 1 1 0 0 104.16  0.128197 3.6795 26.7922 42.7503 20.2021 8.69985 1.70847 0.199415 0 0 0 0 0 0 0 0
 2011 1 1 0 0 782.04  0.957374 26.5078 169.833 329.51 185.162 58.7899 9.96564 1.3144 0 0 0 0 0 0 0 0
 2012 1 1 0 0 1329.72  1.59649 41.0029 282.803 537.962 337.911 111.21 15.1901 2.04494 0 0 0 0 0 0 0 0
 2013 1 1 0 0 1564.92  1.85403 44.5402 298.751 609.922 431.226 155.945 20.2981 2.38401 0 0 0 0 0 0 0 0
 2014 1 1 0 0 190.68  0.223156 5.05386 35.0969 71.3983 53.8631 21.7735 2.96618 0.30501 0 0 0 0 0 0 0 0
 2015 1 1 0 0 542.64  0.647053 15.8766 98.4342 197.059 152.848 66.9339 9.90172 0.938934 0 0 0 0 0 0 0 0
 2016 1 1 0 0 246.96  0.292654 7.10179 51.6392 94.3102 61.5183 27.3055 4.35961 0.432719 0 0 0 0 0 0 0 0
 2017 1 1 0 0 110.88  0.129276 2.86917 20.0838 42.4184 30.5709 12.5589 2.04552 0.203977 0 0 0 0 0 0 0 0
 2018 1 1 0 0 143.64  0.165192 3.39791 24.1602 51.8166 42.4808 18.4317 2.90751 0.280182 0 0 0 0 0 0 0 0
 2019 1 1 0 0 189.84  0.216793 4.26418 29.9595 65.3349 57.5596 27.632 4.4731 0.399902 0 0 0 0 0 0 0 0
 2020 1 1 0 0 153.72  0.174393 3.29763 23.7595 51.4729 46.3591 24.1281 4.17327 0.355019 0 0 0 0 0 0 0 0
 2021 1 1 0 0 79.8  0.0898392 1.61329 11.7078 26.0786 24.3307 13.3136 2.46108 0.205064 0 0 0 0 0 0 0 0
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
# 0 0 123142211 0 0 0 0 #_fleet:1_FISHERY
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

