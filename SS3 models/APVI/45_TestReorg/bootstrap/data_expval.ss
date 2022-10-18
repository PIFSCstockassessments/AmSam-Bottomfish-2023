#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Sat Oct 15 11:52:23 2022
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
1984 1 1 3.83553 0.5
1985 1 1 4.09906 0.5
1986 1 1 3.04356 0.958972
1987 1 1 0.990174 1.27453
1988 1 1 1.32084 1.0556
1989 1 1 1.05322 0.250473
1990 1 1 0.555642 0.435616
1991 1 1 1.13804 0.234849
1992 1 1 0.76701 0.357252
1993 1 1 0.967958 0.333495
1994 1 1 1.5871 0.202063
1995 1 1 1.3594 0.336023
1996 1 1 1.97084 0.387366
1997 1 1 1.57848 0.214793
1998 1 1 0.253097 0.412477
1999 1 1 0.487604 0.65065
2000 1 1 1.78124 0.462061
2001 1 1 0.992449 0.326622
2002 1 1 1.54401 0.328972
2003 1 1 0.443155 0.168046
2004 1 1 1.14758 0.875579
2005 1 1 0.727552 1.15885
2006 1 1 0.399156 1.1507
2007 1 1 1.30452 0.758785
2008 1 1 2.35185 0.426328
2009 1 1 4.39526 0.144623
2010 1 1 0.77064 0.313912
2011 1 1 1.51452 0.647973
2012 1 1 0.463114 1.31425
2013 1 1 1.88783 0.825895
2014 1 1 2.1949 0.39786
2015 1 1 2.55279 0.27296
2016 1 1 2.99276 0.161684
2017 1 1 1.91141 0.171379
2018 1 1 0.945724 0.160734
2019 1 1 1.24963 0.162174
2020 1 1 1.32991 0.152501
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
2016 7 1 8.6338 0.2 #_orig_obs: 9.81973 FISHERY
2017 7 1 7.77113 0.2 #_orig_obs: 7.16519 FISHERY
2018 7 1 7.79766 0.2 #_orig_obs: 6.45365 FISHERY
2019 7 1 8.15034 0.2 #_orig_obs: 8.35764 FISHERY
2020 7 1 8.35527 0.2 #_orig_obs: 9.43102 FISHERY
2021 7 1 9.01401 0.348863 #_orig_obs: 8.88932 FISHERY
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
 2004 -1 1 0 0 119.6  0.148576 0.238501 1.10133 0.773935 7.58727 15.6013 21.6215 22.6496 19.5786 14.7474 9.27273 4.38564 1.41131 0.343771 0.138696
 2005 1 -1 0 0 25.2  0.0313054 0.0502526 0.232052 0.16307 1.59865 3.28722 4.55569 4.77231 4.12525 3.10731 1.95379 0.924064 0.297367 0.0724334 0.0292236
 2006 -1 -1 0 0 25.2  0.0313054 0.0502526 0.232052 0.16307 1.59865 3.28722 4.55569 4.77231 4.12525 3.10731 1.95379 0.924064 0.297367 0.0724334 0.0292236
 2007 1 1 0 0 125.2  0.154654 0.245784 1.12109 0.787213 7.67893 15.8378 22.0848 23.5688 20.8189 15.815 10.1075 4.87197 1.57955 0.380541 0.147463
 2008 1 1 0 0 136.16  0.169515 0.273244 1.26736 0.881516 8.58013 17.3731 23.8474 25.2399 22.4459 17.2273 11.0898 5.40935 1.76891 0.424904 0.161653
 2009 1 1 0 0 152.04  0.194573 0.32688 1.59157 1.09045 10.641 20.7083 26.9815 27.4431 24.0181 18.515 12.004 5.9152 1.95605 0.47365 0.180675
 2010 -1 1 0 0 103.64  0.133131 0.223692 1.09286 0.775671 7.76397 15.6595 20.0726 18.8266 15.0976 11.2443 7.35603 3.70224 1.25586 0.313254 0.122606
 2011 1 -1 0 0 60.48  0.0776899 0.130538 0.637747 0.452649 4.53073 9.13826 11.7135 10.9864 8.81036 6.5617 4.29267 2.16047 0.732866 0.182802 0.0715479
 2012 -1 -1 0 0 13.6  0.01747 0.0293537 0.143409 0.101786 1.01882 2.0549 2.63399 2.4705 1.98117 1.47551 0.965283 0.485821 0.164798 0.0411063 0.0160888
 2013 1 1 0 0 47.36  0.0603506 0.0999543 0.48086 0.335346 3.31792 6.78838 9.32248 9.23227 7.1782 4.98871 3.17971 1.61794 0.559578 0.142196 0.0560959
 2014 1 1 0 0 165.12  0.212375 0.35889 1.76101 1.209 11.9371 23.8194 31.9174 32.2677 25.6467 17.3446 10.6749 5.40241 1.88667 0.486816 0.195009
 2015 1 1 0 0 125.48  0.163731 0.282575 1.41822 0.977971 9.68422 18.8273 24.2259 23.9277 19.3936 13.0892 7.76482 3.86181 1.35786 0.357731 0.147204
 2016 1 1 0 0 162.96  0.21737 0.386935 2.00387 1.37314 13.6809 26.1942 32.2274 30.1443 24.0418 16.3759 9.47961 4.58985 1.61706 0.438774 0.188842
 2017 1 1 0 0 83.16  0.112325 0.204468 1.08001 0.745813 7.5014 14.2908 17.1601 15.167 11.4953 7.78987 4.46761 2.10429 0.738313 0.207746 0.0948388
 2018 1 1 0 0 51.24  0.0686803 0.122742 0.639298 0.450492 4.57404 8.9779 10.994 9.57528 6.90282 4.54642 2.59673 1.19797 0.41565 0.120331 0.0577021
 2019 1 1 0 0 80.64  0.107162 0.187237 0.957673 0.667619 6.76478 13.7414 17.6394 15.7825 11.1306 7.02257 3.95423 1.79878 0.61503 0.181021 0.0899941
 2020 1 1 0 0 89.04  0.117881 0.20561 1.04817 0.718297 7.21354 14.5829 19.3156 18.0525 12.8605 7.81282 4.26386 1.91252 0.645255 0.19202 0.0985536
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
# 0 0 0 1610612736 0 0 0 #_fleet:1_FISHERY
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

