#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Sep 06 12:44:05 2022
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
1990 1 1 0.0648596 1.55673
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
2012 1 1 0.347908 1.48954
2013 1 1 1.33809 1.04702
2014 1 1 1.63111 0.530542
2015 1 1 1.8452 0.277979
2016 1 1 1.24011 0.218319
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
2016 7 1 3.35729 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 3.31417 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 3.29647 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 3.30312 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 3.3516 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 3.47693 0.645341 #_orig_obs: 6.1639 FISHERY
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
 2007 1 1 0 0 93.44  0.349349 1.07453 2.66759 6.56582 11.1202 13.1007 12.9718 11.8566 10.3432 8.64783 6.69839 4.48997 2.35353 0.894853 0.305657
 2008 1 1 0 0 80.72  0.307151 0.947835 2.3505 5.75664 9.63658 11.2426 11.1333 10.2278 8.94899 7.46135 5.77221 3.86887 2.02871 0.772809 0.264688
 2009 1 1 0 0 110.2  0.43487 1.35577 3.34972 8.13523 13.4203 15.3559 15.0063 13.7765 12.1064 10.0973 7.79497 5.22188 2.73955 1.04566 0.35965
 2010 1 1 0 0 41.16  0.165568 0.520277 1.29734 3.15988 5.18135 5.82104 5.55866 5.03727 4.42824 3.70349 2.85616 1.91118 1.00305 0.383744 0.132745
 2011 1 1 0 0 61.32  0.243905 0.768444 1.92186 4.7227 7.84778 8.86625 8.36681 7.4377 6.48457 5.43269 4.19354 2.80312 1.47095 0.56375 0.195911
 2012 1 1 0 0 93.24  0.367179 1.14538 2.8864 7.13081 11.9679 13.7078 12.9785 11.3671 9.7418 8.12626 6.28122 4.19778 2.20195 0.845077 0.294952
 2013 1 1 0 0 50.04  0.195982 0.610467 1.52096 3.76632 6.36698 7.38498 7.09615 6.21539 5.23787 4.31481 3.33023 2.22664 1.16769 0.448484 0.157049
 2014 1 1 0 0 71.72  0.284519 0.885884 2.20593 5.40621 9.06598 10.5346 10.2232 9.04873 7.57505 6.13791 4.70315 3.1435 1.64883 0.633788 0.222736
 2015 1 1 0 0 99.28  0.400465 1.25524 3.11373 7.60765 12.6188 14.4878 14.0703 12.5808 10.5829 8.47258 6.41128 4.27117 2.24068 0.862262 0.304266
 2016 1 1 0 0 80.64  0.328021 1.03207 2.57396 6.28385 10.3861 11.7987 11.3315 10.1558 8.61952 6.88168 5.13906 3.39869 1.78122 0.686414 0.243337
 2017 1 1 0 0 104.16  0.424886 1.33863 3.34365 8.18953 13.5638 15.3721 14.6235 13.0045 11.09 8.89093 6.58124 4.30876 2.25083 0.86831 0.309306
 2019 -1 1 0 0 84.84  0.340614 1.06609 2.66985 6.58186 11.0459 12.727 12.1957 10.7097 8.96643 7.1817 5.30433 3.39974 1.7415 0.668589 0.240987
 2020 -1 -1 0 0 19.32  0.0775655 0.242774 0.607986 1.49884 2.51541 2.89822 2.77723 2.43885 2.04186 1.63544 1.20792 0.774198 0.396578 0.152253 0.0548781
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
# 0 0 -1029701632 0 0 0 0 #_fleet:1_FISHERY
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

