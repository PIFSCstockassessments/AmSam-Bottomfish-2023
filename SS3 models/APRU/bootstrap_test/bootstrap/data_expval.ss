#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Sep 22 14:26:03 2022
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
1967 1 1 0.00620167 0.5
1968 1 1 0.0593565 0.5
1969 1 1 0.0164917 0.5
1970 1 1 0.00890141 0.5
1971 1 1 0.000883225 0.5
1972 1 1 0.134794 0.5
1973 1 1 0.135494 0.5
1974 1 1 0.167311 0.5
1975 1 1 0.480724 0.5
1976 1 1 0.246021 0.5
1977 1 1 0.0609975 0.5
1978 1 1 0.0207804 0.5
1979 1 1 0.0431963 0.5
1980 1 1 0.32706 0.5
1981 1 1 0.706318 0.5
1982 1 1 1.87945 0.5
1983 1 1 5.10708 0.5
1984 1 1 2.33975 0.5
1985 1 1 1.38806 0.5
1986 1 1 1.48726 1.37929
1987 1 1 0.13885 1.72221
1988 1 1 3.66504 1.14764
1989 1 1 0.620376 0.32586
1990 1 1 0.0259514 1.55673
1991 1 1 0.0904206 0.480854
1992 1 1 0.119558 0.631432
1993 1 1 0.0370797 0.893326
1994 1 1 1.04725 0.363779
1995 1 1 0.210908 0.739593
1996 1 1 2.90007 0.578658
1997 1 1 0.824275 0.260358
1998 1 1 0.162446 0.523243
1999 1 1 0.476835 0.715748
2000 1 1 0.233105 0.508736
2001 1 1 0.493772 0.348732
2002 1 1 1.23249 0.511776
2003 1 1 0.46365 0.310752
2004 1 1 0.160293 1.47358
2005 1 1 0.359604 1.4286
2006 1 1 0.0354182 1.57732
2007 1 1 1.28344 0.790458
2008 1 1 1.76911 0.583292
2009 1 1 3.30681 0.190708
2010 1 1 0.587638 0.273691
2011 1 1 0.179221 0.781621
2012 1 1 0.0120604 1.48954
2013 1 1 1.57382 1.04702
2014 1 1 1.12751 0.530542
2015 1 1 1.55786 0.277979
2016 1 1 1.43541 0.218319
2017 1 1 1.39437 0.168771
2018 1 1 1.15301 0.312542
2019 1 1 1.50939 0.34192
2020 1 1 0.463806 0.394157
2021 1 1 0.0377672 0.452443
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
2016 7 1 3.40855 0.329764 #_orig_obs: 2.28057 FISHERY
2017 7 1 3.34541 0.268077 #_orig_obs: 4.48607 FISHERY
2018 7 1 3.30599 0.337253 #_orig_obs: 3.65333 FISHERY
2019 7 1 3.26357 0.318745 #_orig_obs: 2.76016 FISHERY
2020 7 1 3.26914 0.48749 #_orig_obs: 2.53932 FISHERY
2021 7 1 3.37437 0.645341 #_orig_obs: 6.1639 FISHERY
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
 2007 1 1 0 0 93.44  0.346137 1.07554 2.68555 6.61649 11.1441 13.0622 12.9373 11.8862 10.4609 8.7742 6.70825 4.38347 2.23841 0.835928 0.285279
 2008 1 1 0 0 80.72  0.305744 0.954154 2.38034 5.82261 9.6765 11.2117 11.0765 10.2063 8.99753 7.55217 5.80638 3.80837 1.94585 0.727337 0.248442
 2009 1 1 0 0 110.2  0.435323 1.37548 3.41808 8.2856 13.5336 15.3295 14.9039 13.6843 12.0909 10.1617 7.84039 5.16656 2.64527 0.990247 0.339171
 2010 1 1 0 0 41.16  0.165893 0.52889 1.32902 3.23423 5.25208 5.82836 5.51831 4.98538 4.39442 3.70071 2.86306 1.89508 0.973467 0.365376 0.12572
 2011 1 1 0 0 61.32  0.240774 0.767853 1.94101 4.79362 7.94866 8.91667 8.34438 7.37454 6.42672 5.41171 4.19811 2.78975 1.43819 0.541252 0.186774
 2012 1 1 0 0 93.24  0.357169 1.12166 2.85402 7.09958 11.9808 13.7849 13.0446 11.3675 9.7105 8.12011 6.30883 4.20767 2.17704 0.821561 0.284064
 2013 1 1 0 0 50.04  0.191627 0.599256 1.50156 3.72804 6.31221 7.37348 7.14282 6.26013 5.2541 4.32547 3.35175 2.24207 1.16426 0.440606 0.152626
 2014 1 1 0 0 71.72  0.278843 0.874741 2.18507 5.36055 8.96495 10.4383 10.2345 9.13684 7.64622 6.17947 4.74353 3.17552 1.65482 0.628292 0.218291
 2015 1 1 0 0 99.28  0.390105 1.23312 3.07681 7.51942 12.439 14.2986 14.0064 12.6916 10.7517 8.59827 6.50403 4.33909 2.26713 0.863709 0.301148
 2016 1 1 0 0 80.64  0.320868 1.01635 2.55281 6.23197 10.2454 11.6164 11.2251 10.1897 8.76103 7.02338 5.24084 3.46757 1.81276 0.693038 0.242813
 2017 1 1 0 0 104.16  0.417662 1.32742 3.33248 8.16892 13.4487 15.1469 14.4299 12.96 11.2146 9.08184 6.73402 4.40771 2.2983 0.881146 0.310456
 2019 -1 1 0 0 84.84  0.340918 1.08295 2.7296 6.72074 11.1544 12.6684 12.0251 10.5266 8.85499 7.18653 5.37959 3.46917 1.77747 0.6802 0.243379
 2020 -1 -1 0 0 19.32  0.0776347 0.246612 0.621592 1.53047 2.5401 2.88488 2.7384 2.39714 2.01648 1.63654 1.22506 0.790008 0.404771 0.154897 0.055423
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

