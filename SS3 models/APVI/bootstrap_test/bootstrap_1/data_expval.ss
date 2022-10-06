#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Fri Aug 26 11:23:41 2022
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
1967 1 1 0.0340927 0.5
1968 1 1 0.374842 0.5
1969 1 1 0.0558071 0.5
1970 1 1 0.0311119 0.5
1971 1 1 0.000322022 0.5
1972 1 1 0.853629 0.5
1973 1 1 0.376345 0.5
1974 1 1 0.684049 0.5
1975 1 1 3.73648 0.5
1976 1 1 0.836683 0.5
1977 1 1 0.361361 0.5
1978 1 1 0.0598507 0.5
1979 1 1 0.16365 0.5
1980 1 1 0.826922 0.5
1981 1 1 0.507296 0.5
1982 1 1 6.45841 0.5
1983 1 1 5.78067 0.5
1984 1 1 1.94041 0.5
1985 1 1 2.67749 0.5
1986 1 1 15.9009 0.958972
1987 1 1 0.40345 1.27453
1988 1 1 3.61587 1.0556
1989 1 1 0.679094 0.250473
1990 1 1 0.352639 0.435616
1991 1 1 0.869742 0.234849
1992 1 1 0.650766 0.357252
1993 1 1 0.33314 0.333495
1994 1 1 2.60324 0.202063
1995 1 1 0.646821 0.336023
1996 1 1 5.07112 0.387366
1997 1 1 1.11692 0.214793
1998 1 1 0.137337 0.412477
1999 1 1 0.534488 0.65065
2000 1 1 0.872695 0.462061
2001 1 1 1.27559 0.326622
2002 1 1 1.23501 0.328972
2003 1 1 0.499486 0.168046
2004 1 1 2.11978 0.875579
2005 1 1 0.706914 1.15885
2006 1 1 0.225684 1.1507
2007 1 1 1.17709 0.758785
2008 1 1 1.58282 0.426328
2009 1 1 4.436 0.144623
2010 1 1 0.78572 0.313912
2011 1 1 2.56517 0.647973
2012 1 1 0.0308843 1.31425
2013 1 1 0.930725 0.825895
2014 1 1 1.04933 0.39786
2015 1 1 1.31238 0.27296
2016 1 1 3.20325 0.161684
2017 1 1 2.07709 0.171379
2018 1 1 1.13948 0.160734
2019 1 1 1.19383 0.162174
2020 1 1 1.08 0.152501
2021 1 1 0.0987367 0.293454
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
2016 7 1 7.65408 0.2 #_orig_obs: 5.8794 FISHERY
2017 7 1 6.63798 0.2 #_orig_obs: 7.47907 FISHERY
2018 7 1 6.86169 0.2 #_orig_obs: 9.24545 FISHERY
2019 7 1 7.73224 0.2 #_orig_obs: 7.47686 FISHERY
2020 7 1 8.64583 0.2 #_orig_obs: 7.87036 FISHERY
2021 7 1 10.1367 0.348863 #_orig_obs: 9.36184 FISHERY
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
0 1e-07 0 0 0 0 1 #_fleet:1_FISHERY
# sex codes:  0=combined; 1=use female only; 2=use male only; 3=use both as joint sexxlength distribution
# partition codes:  (0=combined; 1=discard; 2=retained
15 #_N_LengthBins
 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
#_yr month fleet sex part Nsamp datavector(female-male)
 2004 1 1 0 0 69  0 0 0 3.75607 5.73677 10.5861 15.5259 13.5863 9.45534 5.7258 4.62772 0 0 0 0
 2007 1 1 0 0 125  0 0 0 5.11959 8.09357 16.1835 25.3442 25.2269 20.7168 13.7191 6.99146 2.6759 0.929006 0 0
 2008 1 1 0 0 136  0 0 0 0 14.597 16.1859 25.7127 26.7623 23.1519 16.2569 8.70381 4.62954 0 0 0
 2009 1 1 0 0 152  0 0 0 8.55098 12.0594 19.3025 28.1606 27.3256 23.7695 17.4673 9.85861 4.04018 1.46546 0 0
 2011 1 1 0 0 60  0 0.327761 0.317187 3.04645 5.58647 9.70011 13.5982 11.1417 7.49934 4.66409 4.1187 0 0 0 0
 2013 1 1 0 0 47  0 0 0 2.01869 3.15462 6.14606 10.0553 10.1389 7.6481 4.54062 3.29772 0 0 0 0
 2014 1 1 0 0 165  0 0 0 6.31156 9.9556 20.0966 32.1713 33.7836 29.1432 19.2592 9.50033 4.77864 0 0 0
 2015 1 1 0 0 125  0 0 0 5.13087 7.6943 13.98 22.5569 24.3161 22.0696 16.0911 8.6551 4.50596 0 0 0
 2016 1 1 0 0 162  0 0 0 7.33189 10.9155 19.3019 29.1065 29.3306 26.7369 20.5899 11.97 6.71687 0 0 0
 2017 1 1 0 0 83  0 0 0 4.29804 6.42458 11.146 15.9733 14.5817 12.2257 9.30216 5.63962 2.46781 0.941201 0 0
 2018 1 1 0 0 51  0 0 0 0 6.48484 7.18778 10.4435 9.33842 7.27659 5.18667 3.11349 1.96867 0 0 0
 2019 1 1 0 0 80  0 0 0 3.43506 5.46753 10.7811 16.4745 15.5872 12.2114 8.28667 4.75234 3.00416 0 0 0
 2020 1 1 0 0 89  0 0 0 0 8.9901 10.8924 17.3876 17.7437 14.7669 10.1291 5.63748 2.44642 1.00636 0 0
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
# 0 0 -1958543293 67 0 0 0 #_fleet:1_FISHERY
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

