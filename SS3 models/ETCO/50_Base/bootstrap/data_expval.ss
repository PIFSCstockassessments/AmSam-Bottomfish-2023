#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Sun Oct 16 15:34:46 2022
#_expected_values
#C data file for ETCO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
55 #_Nages=accumulator age, first age is always age 0
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
1967 1 1 0.0775598 0.5
1968 1 1 0.273059 0.5
1969 1 1 0.0843698 0.5
1970 1 1 0.0299399 0.5
1971 1 1 0.000999997 0.5
1972 1 1 0.798318 0.5
1973 1 1 1.11674 0.5
1974 1 1 0.771558 0.5
1975 1 1 1.02149 0.5
1976 1 1 0.834608 0.5
1977 1 1 0.368319 0.5
1978 1 1 0.14742 0.5
1979 1 1 0.12428 0.5
1980 1 1 1.89192 0.5
1981 1 1 3.59471 0.5
1982 1 1 4.6103 0.5
1983 1 1 9.30496 0.5
1984 1 1 6.90183 0.5
1985 1 1 7.37583 0.5
1986 1 1 3.95938 0.80552
1987 1 1 0.796955 1.40981
1988 1 1 1.37392 1.03391
1989 1 1 0.667686 0.410435
1990 1 1 0.143339 1.09739
1991 1 1 0.313888 0.512413
1992 1 1 0.0136099 2.31941
1993 1 1 0.836876 0.461778
1994 1 1 1.15892 0.213268
1995 1 1 1.38481 0.346758
1996 1 1 1.22605 0.55085
1997 1 1 1.95225 0.31522
1998 1 1 2.26976 0.258636
1999 1 1 0.968865 0.413156
2000 1 1 0.333838 0.459847
2001 1 1 2.09695 0.35261
2002 1 1 0.673127 0.619048
2003 1 1 0.471738 0.463612
2004 1 1 0.715767 1.1729
2005 1 1 1.30633 0.827787
2006 1 1 0.217719 1.5236
2007 1 1 1.36077 0.737086
2008 1 1 2.04115 0.482475
2009 1 1 3.25042 0.22864
2010 1 1 0.827346 0.338195
2011 1 1 2.45347 0.52926
2012 1 1 0.511649 1.41111
2013 1 1 1.27005 1.06936
2014 1 1 2.30787 0.375471
2015 1 1 1.92322 0.230871
2016 1 1 3.06082 0.209085
2017 1 1 1.51408 0.207125
2018 1 1 1.51998 0.227297
2019 1 1 0.623687 0.287378
2020 1 1 0.633207 0.357784
2021 1 1 0.155579 0.627146
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
2016 7 1 5.44828 0.374297 #_orig_obs: 6.95448 FISHERY
2017 7 1 5.29902 0.442488 #_orig_obs: 3.38286 FISHERY
2018 7 1 5.27777 0.372519 #_orig_obs: 6.0728 FISHERY
2019 7 1 5.3312 0.490025 #_orig_obs: 3.46051 FISHERY
2020 7 1 5.45964 0.608891 #_orig_obs: 10.6902 FISHERY
2021 7 1 5.62674 1.17662 #_orig_obs: 2.91973 FISHERY
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
 2007 1 1 0 0 66.52  1.37827 0.932571 1.65865 2.3452 3.18432 4.26648 5.48116 6.66146 7.68693 8.31059 8.31231 7.45137 5.35932 2.61152 0.879844 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2008 1 1 0 0 78.72  1.65013 1.11584 1.97785 2.80092 3.79782 5.05879 6.4734 7.85592 9.03616 9.81171 9.85136 8.81148 6.32848 3.10202 1.04812 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 1 1 0 0 87.84  1.88858 1.28074 2.27329 3.19637 4.32869 5.73713 7.26954 8.76322 10.0143 10.8475 10.9162 9.74769 6.97979 3.43268 1.16435 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 1 1 0 0 59.64  1.29356 0.87927 1.57589 2.23408 3.02012 3.98721 5.02767 5.98061 6.75428 7.25612 7.31393 6.5489 4.67439 2.30555 0.78842 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 51.72  1.12195 0.76205 1.35775 1.94084 2.63875 3.49536 4.3978 5.22336 5.8618 6.26255 6.29971 5.65072 4.03389 1.99046 0.683015 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 50.88  1.09131 0.740517 1.32356 1.8759 2.57446 3.43802 4.34635 5.16721 5.79317 6.16274 6.18811 5.56156 3.97722 1.96402 0.675855 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 107.68  2.33534 1.57796 2.8051 3.99379 5.42834 7.29197 9.26726 11.0205 12.3211 13.0284 13.0105 11.6817 8.36219 4.13095 1.4248 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 63  1.38359 0.939104 1.66873 2.35377 3.20743 4.27278 5.45274 6.50264 7.24892 7.6178 7.54908 6.75378 4.83485 2.38915 0.825634 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 1 1 0 0 57.28  1.28159 0.870318 1.55296 2.18895 2.95291 3.92751 4.97571 5.94828 6.62573 6.91965 6.79718 6.04395 4.32073 2.13532 0.739198 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 85.68  1.89945 1.28667 2.29881 3.28162 4.48269 5.97847 7.55016 8.96443 10.0257 10.499 10.1674 8.84103 6.24703 3.08448 1.07305 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 21  0.465553 0.315361 0.563434 0.804318 1.0987 1.46531 1.85053 2.19717 2.45728 2.57329 2.492 2.16692 1.53113 0.756 0.263003 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 12.6  0.279332 0.189217 0.33806 0.482591 0.65922 0.879187 1.11032 1.3183 1.47437 1.54398 1.4952 1.30015 0.918681 0.4536 0.157802 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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
# 0 0 -640276480 657500160 0 0 0 #_fleet:1_FISHERY
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

