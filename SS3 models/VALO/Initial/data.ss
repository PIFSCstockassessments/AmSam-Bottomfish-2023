#V3.30
#C data file for VALO
#
2015 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
numeric(0) #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	      0	    0.01	#_1         
 2015	1	1	0.15966	0.673679	#_2         
 2016	1	1	0.06305	0.309637	#_3         
 2017	1	1	0.05534	0.350369	#_4         
 2018	1	1	0.06486	0.183459	#_5         
 2019	1	1	0.18597	0.112564	#_6         
 2020	1	1	0.11204	0.246135	#_7         
 2021	1	1	0.01406	0.470573	#_8         
-9999	0	0	      0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_1
#
#_CPUE_data
#_year	seas	index	obs	se_log
 2016	7	1	 0.072204	0.563563	#_1         
 2017	7	1	0.0884493	0.775966	#_2         
 2018	7	1	0.0366748	 1.03962	#_3         
 2019	7	1	 0.208641	 0.48911	#_4         
 2020	7	1	 0.196922	0.607434	#_5         
-9999	0	0	        0	       0	#_terminator
0 #_N_discard_fleets
#_discard_units (1=same_as_catchunits(bio/num); 2=fraction; 3=numbers)
#_discard_errtype:  >0 for DF of T-dist(read CV below); 0 for normal with CV; -1 for normal with se; -2 for lognormal
#
#_discard_fleet_info
#
#_discard_data
#
#_meanbodywt
0 #_use_meanbodywt
 #_DF_for_meanbodywt_T-distribution_like
#
#_population_length_bins
2 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
1 # binwidth for population size comp
1 # minimum size in the population (lower edge of first bin and size at age 0.00)
58 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	1e-07	0	0	0	0	1	#_1
16 #_N_lbins
#_lbin_vector
3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l3	l6	l9	l12	l15	l18	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48
 2015	1	1	0	0	   84	0	0	0	0	0	4	 8	19	19	13	12	15	4	4	1	1	#_1         
 2015	1	2	0	0	36.12	1	2	0	2	5	6	12	 3	 2	 3	 1	 0	3	3	0	0	#_2         
-9999	0	0	0	0	    0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
0 #_N_agebins
#
#_MeanSize_at_Age_obs
0 #_use_MeanSize_at_Age_obs
0 #_N_environ_variables
0 #_N_sizefreq_methods
0 #_do_tags
0 #_morphcomp_data
0 #_use_selectivity_priors
#
999
