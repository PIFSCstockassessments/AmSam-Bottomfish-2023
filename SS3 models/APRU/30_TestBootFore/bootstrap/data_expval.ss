#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Sep 27 14:18:00 2022
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
1967 1 1 0.0172399 0.5
1968 1 1 0.0603298 0.5
1969 1 1 0.0185999 0.5
1970 1 1 0.00679997 0.5
1971 1 1 0.000999996 0.5
1972 1 1 0.176899 0.5
1973 1 1 0.247209 0.5
1974 1 1 0.170999 0.5
1975 1 1 0.226339 0.5
1976 1 1 0.185069 0.5
1977 1 1 0.0816497 0.5
1978 1 1 0.0326599 0.5
1979 1 1 0.0276699 0.5
1980 1 1 0.661337 0.5
1981 1 1 1.25689 0.5
1982 1 1 1.61206 0.5
1983 1 1 3.25315 0.5
1984 1 1 2.4131 0.5
1985 1 1 2.57866 0.5
1986 1 1 1.56579 1.37929
1987 1 1 0.465837 1.72221
1988 1 1 1.15302 1.14764
1989 1 1 0.585587 0.32586
1990 1 1 0.0648597 1.55673
1991 1 1 0.121559 0.480854
1992 1 1 0.324318 0.631432
1993 1 1 0.181889 0.893326
1994 1 1 0.688547 0.363779
1995 1 1 0.433628 0.739593
1996 1 1 1.3145 0.578658
1997 1 1 1.29137 0.260358
1998 1 1 0.174629 0.523243
1999 1 1 0.400978 0.715748
2000 1 1 0.522537 0.508736
2001 1 1 0.553377 0.348732
2002 1 1 2.20581 0.511776
2003 1 1 0.248109 0.310752
2004 1 1 0.439078 1.47358
2005 1 1 0.472188 1.4286
2006 1 1 0.198669 1.57732
2007 1 1 1.25372 0.790458
2008 1 1 1.63836 0.583292
2009 1 1 3.25269 0.190708
2010 1 1 0.677666 0.273691
2011 1 1 1.18885 0.781621
2012 1 1 0.531158 1.48954
2013 1 1 1.33809 1.04702
2014 1 1 1.63111 0.530542
2015 1 1 1.8452 0.277979
2016 1 1 1.42835 0.218319
2017 1 1 1.56488 0.168771
2018 1 1 0.902185 0.312542
2019 1 1 1.24374 0.34192
2020 1 1 0.239039 0.394157
2021 1 1 0.0335698 0.452443
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
2016 7 1 3.36216 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 3.30967 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 3.29473 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 3.30413 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 3.35488 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 3.48142 0.645341 #_orig_obs: 6.1639 FISHERY
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
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 93.44  0.348894 1.07306 2.66413 6.55721 11.1042 13.0816 12.9568 11.8503 10.3469 8.65972 6.71563 4.50772 2.36598 0.900376 0.307454
 2008 1 1 0 0 80.72  0.306644 0.94616 2.34656 5.74744 9.62216 11.2278 11.1218 10.2226 8.95195 7.47178 5.78734 3.88434 2.03954 0.777596 0.266236
 2009 1 1 0 0 110.2  0.433829 1.35211 3.34125 8.1167 13.395 15.3358 14.995 13.7736 12.113 10.1135 7.81726 5.24407 2.75484 1.05235 0.361797
 2010 1 1 0 0 41.16  0.165106 0.518583 1.2931 3.15021 5.16824 5.81186 5.55566 5.03863 4.43277 3.711 2.8656 1.92019 1.00911 0.386359 0.133573
 2011 1 1 0 0 61.32  0.243289 0.766074 1.9158 4.70794 7.8254 8.84849 8.36074 7.44131 6.49375 5.44569 4.20884 2.81735 1.48038 0.567775 0.197175
 2012 1 1 0 0 93.24  0.367098 1.14515 2.88394 7.11912 11.9392 13.6749 12.9597 11.3667 9.75374 8.14489 6.30333 4.21856 2.21582 0.851017 0.29682
 2013 1 1 0 0 50.04  0.196309 0.611857 1.52439 3.77148 6.3647 7.37013 7.07914 6.20636 5.23787 4.3204 3.33874 2.2355 1.17394 0.451241 0.157932
 2014 1 1 0 0 71.72  0.284659 0.887236 2.20965 5.41479 9.07333 10.5263 10.2008 9.02872 7.56785 6.14162 4.7126 3.15433 1.65679 0.637374 0.2239
 2015 1 1 0 0 99.28  0.400294 1.25493 3.11588 7.61431 12.6296 14.4924 14.0549 12.5535 10.565 8.47142 6.42079 4.28394 2.2505 0.866785 0.305754
 2016 1 1 0 0 80.64  0.328466 1.03378 2.5775 6.2915 10.395 11.8042 11.3284 10.1387 8.59991 6.87324 5.1417 3.40604 1.78763 0.689512 0.244386
 2017 1 1 0 0 104.16  0.426178 1.34378 3.3564 8.21523 13.5898 15.3819 14.6177 12.9836 11.0578 8.86631 6.57313 4.3112 2.25556 0.871031 0.31031
 2019 -1 1 0 0 84.84  0.340816 1.067 2.67252 6.59148 11.0644 12.7463 12.2073 10.7074 8.95197 7.16079 5.28677 3.39219 1.74059 0.669158 0.241355
 2020 -1 -1 0 0 19.32  0.0776115 0.242981 0.608593 1.50103 2.51963 2.90261 2.77988 2.43831 2.03857 1.63067 1.20392 0.772479 0.396373 0.152383 0.0549621
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
# 0 0 -1168910080 -1171075328 0 0 0 #_fleet:1_FISHERY
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

