#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Thu Jan 05 21:16:00 2023
#_expected_values
#C data file for PRZO
#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
1967 #_StartYr
2021 #_EndYr
1 #_Nseas
 12 #_months/season
2 #_Nsubseasons (even number, minimum is 2)
1 #_spawn_month
2 #_Ngenders: 1, 2, -1  (use -1 for 1 sex setup with SSB multiplied by female_frac parameter)
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
1967 1 1 0.0158796 0.5
1968 1 1 0.0562487 0.5
1969 1 1 0.0172396 0.5
1970 1 1 0.00634985 0.5
1971 1 1 0.000999977 0.5
1972 1 1 0.164646 0.5
1973 1 1 0.230415 0.5
1974 1 1 0.159206 0.5
1975 1 1 0.210465 0.5
1976 1 1 0.172356 0.5
1977 1 1 0.075748 0.5
1978 1 1 0.0303892 0.5
1979 1 1 0.0253993 0.5
1980 1 1 0.37647 0.5
1981 1 1 0.715751 0.5
1982 1 1 0.917593 0.5
1983 1 1 1.85195 0.5
1984 1 1 1.37384 0.5
1985 1 1 1.46781 0.5
1986 1 1 0.671481 0.5
1987 1 1 0.13602 0.5
1988 1 1 0.356996 0.5
1989 1 1 0.214467 0.46734
1990 1 1 0.158219 0.5
1991 1 1 0.04443 0.2
1992 1 1 0.126063 0.5
1993 1 1 0.0943278 0.5
1994 1 1 0.297506 0.2
1995 1 1 0.175508 0.5
1996 1 1 0.19093 0.5
1997 1 1 0.319737 0.5
1998 1 1 0.170977 0.5
1999 1 1 0.114747 0.5
2000 1 1 0.0594143 0.2
2001 1 1 0.0771039 0.5
2002 1 1 0.0576061 0.5
2003 1 1 0.0571466 0.5
2004 1 1 0.0857255 0.5
2005 1 1 0.165552 0.5
2006 1 1 0.0612273 0.5
2007 1 1 0.130625 0.5
2008 1 1 0.25582 0.5
2009 1 1 0.0943464 0.329973
2010 1 1 0.0857269 0.318367
2011 1 1 0.0757473 0.5
2012 1 1 0.0317459 0.5
2013 1 1 0.0734776 0.5
2014 1 1 0.127006 0.5
2015 1 1 0.109767 0.5
2016 1 1 0.259444 0.2
2017 1 1 0.244933 0.2
2018 1 1 0.126546 0.218618
2019 1 1 0.0716678 0.273842
2020 1 1 0.0503485 0.418
2021 1 1 0.00637732 0.453778
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
2016 7 1 0.601671 0.257633 #_orig_obs: 0.864366 FISHERY
2017 7 1 0.594854 0.28097 #_orig_obs: 0.765316 FISHERY
2018 7 1 0.595921 0.303678 #_orig_obs: 0.49539 FISHERY
2019 7 1 0.607341 0.541214 #_orig_obs: 0.195021 FISHERY
2020 7 1 0.622683 0.585558 #_orig_obs: 0.241016 FISHERY
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
44 # maximum size in the population (lower edge of last bin) 
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
13 #_N_LengthBins
 16 18 20 22 24 26 28 30 32 34 36 38 40
#_yr month fleet sex part Nsamp datavector(female-male)
 2007 1 1 0 0 57  0.368613 0.506358 2.32328 5.62194 6.43852 7.81801 7.98137 8.11975 7.44415 5.54291 3.1567 1.27695 0.401453 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38  0.229062 0.314184 1.44205 3.49371 4.0242 4.91921 5.08468 5.29999 5.10828 4.07893 2.51207 1.11234 0.381288 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 16  0.0964472 0.132288 0.607179 1.47104 1.6944 2.07125 2.14092 2.23158 2.15085 1.71744 1.05771 0.468354 0.160542 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13  0.0783633 0.107484 0.493333 1.19522 1.3767 1.68289 1.7395 1.81316 1.74757 1.39542 0.859391 0.380537 0.130441 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 62  0.35023 0.47888 2.18549 5.29684 6.14777 7.62286 8.08621 8.67619 8.62734 7.12881 4.54668 2.09925 0.753443 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16  0.090382 0.123582 0.563997 1.36693 1.58652 1.96719 2.08676 2.23902 2.22641 1.83969 1.17334 0.541743 0.194437 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 6  0.0338933 0.0463433 0.211499 0.512597 0.594946 0.737696 0.782537 0.839631 0.834903 0.689885 0.440001 0.203154 0.0729138 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 68  0.37817 0.516275 2.34317 5.6597 6.52535 8.0505 8.54493 9.32301 9.57348 8.19411 5.38722 2.5593 0.944783 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 32  0.177962 0.242953 1.10267 2.66339 3.07076 3.78847 4.02114 4.3873 4.50517 3.85605 2.53516 1.20438 0.444604 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 61  0.342534 0.468207 2.13176 5.13736 5.86413 7.18205 7.58198 8.26057 8.52946 7.37411 4.89917 2.35192 0.876754 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 38  0.209335 0.286089 1.30611 3.1651 3.66722 4.51473 4.73642 5.10031 5.25203 4.58457 3.09093 1.51194 0.575206 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 8  0.0440706 0.0602294 0.274971 0.666336 0.772046 0.95047 0.997141 1.07375 1.10569 0.965173 0.650722 0.318304 0.121096 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 5  0.0275441 0.0376434 0.171857 0.41646 0.482529 0.594044 0.623213 0.671094 0.691057 0.603233 0.406701 0.19894 0.075685 0 0 0 0 0 0 0 0 0 0 0 0 0
-9999 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
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

