#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Mon Oct 17 11:38:46 2022
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
1971 1 1 0.000999998 0.5
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
1987 1 1 0.796956 1.40981
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
2009 1 1 3.25043 0.22864
2010 1 1 0.827346 0.338195
2011 1 1 2.45347 0.52926
2012 1 1 0.51165 1.41111
2013 1 1 1.27005 1.06936
2014 1 1 2.30787 0.375471
2015 1 1 1.92322 0.230871
2016 1 1 3.06083 0.209085
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
2016 7 1 5.43977 0.374297 #_orig_obs: 6.95448 FISHERY
2017 7 1 5.30247 0.442488 #_orig_obs: 3.38286 FISHERY
2018 7 1 5.28414 0.372519 #_orig_obs: 6.0728 FISHERY
2019 7 1 5.3351 0.490025 #_orig_obs: 3.46051 FISHERY
2020 7 1 5.45561 0.608891 #_orig_obs: 10.6902 FISHERY
2021 7 1 5.61185 1.17662 #_orig_obs: 2.91973 FISHERY
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
 2007 1 1 0 0 66.52  1.36701 0.915507 1.67988 2.37998 3.21176 4.29388 5.50164 6.65317 7.64198 8.244 8.28638 7.54354 5.40987 2.54478 0.846613 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2008 1 1 0 0 78.72  1.63531 1.09461 2.00196 2.8402 3.8277 5.08911 6.49642 7.84649 8.98462 9.73642 9.82193 8.91825 6.3939 3.02492 1.00817 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 1 1 0 0 87.84  1.86878 1.25391 2.29658 3.23574 4.35538 5.7631 7.28798 8.74934 9.95687 10.7702 10.8929 9.87161 7.06301 3.35355 1.12108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 1 1 0 0 59.64  1.27969 0.860346 1.58978 2.25733 3.03305 3.99797 5.03286 5.96502 6.71408 7.20692 7.30788 6.6384 4.7382 2.25822 0.760243 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 1 1 0 0 51.72  1.10995 0.745866 1.3705 1.96106 2.6489 3.50278 4.39957 5.20719 5.82478 6.21973 6.29685 5.73102 4.09125 1.95148 0.659068 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 1 0 0 50.88  1.08034 0.725284 1.33699 1.89768 2.58631 3.44603 4.34778 5.15016 5.75481 6.11841 6.18424 5.6408 4.03333 1.92574 0.652113 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 1 1 0 0 107.68  2.30977 1.54492 2.83303 4.03922 5.45341 7.30793 9.2661 10.9786 12.2358 12.9322 13.0047 11.8566 8.48697 4.05458 1.37612 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 1 1 0 0 63  1.36736 0.918198 1.68356 2.37895 3.22071 4.28033 5.44964 6.47432 7.19598 7.56086 7.54771 6.86165 4.91345 2.34858 0.798688 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 1 1 0 0 57.28  1.26504 0.849753 1.56395 2.20891 2.96155 3.93152 4.96957 5.91956 6.57525 6.8684 6.79901 6.14818 4.39911 2.10353 0.71666 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 85.68  1.87611 1.25761 2.31705 3.3111 4.49215 5.97844 7.53562 8.91531 9.94317 10.4168 10.1645 8.99755 6.37861 3.05106 1.04491 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 21  0.459832 0.308237 0.567904 0.811543 1.10102 1.4653 1.84697 2.18512 2.43705 2.55315 2.49129 2.20528 1.56338 0.747809 0.256105 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 12.6  0.275899 0.184942 0.340742 0.486926 0.66061 0.879182 1.10818 1.31107 1.46223 1.53189 1.49478 1.32317 0.938031 0.448685 0.153663 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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

