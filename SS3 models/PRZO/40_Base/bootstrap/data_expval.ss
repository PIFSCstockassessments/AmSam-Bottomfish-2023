#V3.30.19.01;_fast(opt);_compile_date:_Apr 15 2022;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.3
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis
#_Start_time: Tue Oct 11 12:54:24 2022
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
1971 1 1 0.000999978 0.5
1972 1 1 0.164646 0.5
1973 1 1 0.230415 0.5
1974 1 1 0.159206 0.5
1975 1 1 0.210465 0.5
1976 1 1 0.172356 0.5
1977 1 1 0.075748 0.5
1978 1 1 0.0303892 0.5
1979 1 1 0.0253994 0.5
1980 1 1 0.376471 0.5
1981 1 1 0.715751 0.5
1982 1 1 0.917593 0.5
1983 1 1 1.85195 0.5
1984 1 1 1.37384 0.5
1985 1 1 1.46774 0.5
1986 1 1 0.670815 1.8647
1987 1 1 0.136022 2.31925
1988 1 1 0.356952 1.83391
1989 1 1 0.214462 0.46734
1990 1 1 0.158221 1.01654
1991 1 1 0.0444307 0.001
1992 1 1 0.126064 1.14011
1993 1 1 0.0943284 1.23881
1994 1 1 0.297507 0.001
1995 1 1 0.175509 1.26849
1996 1 1 0.190931 1.64442
1997 1 1 0.319738 0.636487
1998 1 1 0.170978 0.561009
1999 1 1 0.114747 1.44077
2000 1 1 0.0594144 0.001
2001 1 1 0.077104 0.775294
2002 1 1 0.0576061 1.5447
2003 1 1 0.0571467 1.60741
2004 1 1 0.0857256 2.307
2005 1 1 0.165552 2.00279
2006 1 1 0.0612273 2.18261
2007 1 1 0.130625 2.08633
2008 1 1 0.25582 1.63287
2009 1 1 0.0943464 0.329973
2010 1 1 0.0857269 0.318367
2011 1 1 0.0757474 2.29873
2012 1 1 0.0317459 2.80447
2013 1 1 0.0734777 2.541
2014 1 1 0.127006 1.93562
2015 1 1 0.109767 1.32974
2016 1 1 0.259444 0.170606
2017 1 1 0.244933 0.174223
2018 1 1 0.126546 0.218618
2019 1 1 0.0716679 0.273842
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
2016 7 1 0.602267 0.257651 #_orig_obs: 0.865238 FISHERY
2017 7 1 0.595396 0.281029 #_orig_obs: 0.765871 FISHERY
2018 7 1 0.596382 0.30382 #_orig_obs: 0.495486 FISHERY
2019 7 1 0.607686 0.541224 #_orig_obs: 0.195278 FISHERY
2020 7 1 0.622907 0.585509 #_orig_obs: 0.24163 FISHERY
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
 2007 1 1 0 0 48  0.310632 0.438758 2.04582 4.85985 5.43628 6.53747 6.65795 6.77718 6.22406 4.64454 2.65179 1.07606 0.339603 0 0 0 0 0 0 0 0 0 0 0 0 0
 2009 -1 1 0 0 38.64  0.233333 0.329023 1.53517 3.65123 4.10701 4.97158 5.12509 5.34289 5.15672 4.12504 2.54528 1.12947 0.388158 0 0 0 0 0 0 0 0 0 0 0 0 0
 2010 1 -1 0 0 15.96  0.0963767 0.135901 0.634093 1.50812 1.69637 2.05348 2.11688 2.20685 2.12995 1.70382 1.05131 0.466521 0.160326 0 0 0 0 0 0 0 0 0 0 0 0 0
 2011 -1 -1 0 0 13.44  0.0811593 0.114443 0.533973 1.26999 1.42853 1.72924 1.78264 1.8584 1.79364 1.4348 0.885314 0.39286 0.135012 0 0 0 0 0 0 0 0 0 0 0 0 0
 2012 -1 1 0 0 64.68  0.366451 0.515024 2.39011 5.68759 6.448 7.91762 8.37368 8.97877 8.93193 7.38783 4.71756 2.18122 0.784197 0 0 0 0 0 0 0 0 0 0 0 0 0
 2013 1 -1 0 0 16.8  0.0951822 0.133772 0.620808 1.4773 1.67481 2.05652 2.17498 2.33215 2.31998 1.91892 1.22534 0.566551 0.203688 0 0 0 0 0 0 0 0 0 0 0 0 0
 2014 -1 -1 0 0 5.88  0.0333138 0.0468204 0.217283 0.517054 0.586182 0.719784 0.761244 0.816252 0.811994 0.671621 0.428869 0.198293 0.0712906 0 0 0 0 0 0 0 0 0 0 0 0 0
 2015 -1 1 0 0 63.48  0.354182 0.496943 2.29309 5.43801 6.12373 7.48244 7.92043 8.63846 8.87374 7.60041 5.00101 2.37833 0.879219 0 0 0 0 0 0 0 0 0 0 0 0 0
 2016 -1 -1 0 0 31.08  0.173408 0.243305 1.12271 2.66247 2.9982 3.66343 3.87787 4.22941 4.34461 3.72118 2.44851 1.16444 0.430468 0 0 0 0 0 0 0 0 0 0 0 0 0
 2017 1 1 0 0 58.8  0.331275 0.465402 2.15425 5.09651 5.68008 6.89028 7.25601 7.90362 8.16445 7.06328 4.69612 2.25649 0.842235 0 0 0 0 0 0 0 0 0 0 0 0 0
 2018 -1 1 0 0 34.44  0.19036 0.26739 1.24148 2.95369 3.34183 4.07368 4.2612 4.587 4.72609 4.12864 2.7856 1.36368 0.519353 0 0 0 0 0 0 0 0 0 0 0 0 0
 2019 1 -1 0 0 7.56  0.0417864 0.0586953 0.27252 0.64837 0.733573 0.894222 0.935386 1.0069 1.03743 0.906287 0.611472 0.299345 0.114004 0 0 0 0 0 0 0 0 0 0 0 0 0
 2020 -1 -1 0 0 5.04  0.0278576 0.0391302 0.18168 0.432247 0.489048 0.596148 0.623591 0.671269 0.691623 0.604191 0.407648 0.199563 0.0760029 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 0 0 1868562432 0 0 0 0 #_fleet:1_FISHERY
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

