#V3.30
#C data file for VALO
#
1986 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
2 #_Nsexes
15 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	      0	    0.01	#_1         
 1986	1	1	0.62686	     0.5	#_2         
 1987	1	1	 0.2023	     0.5	#_3         
 1988	1	1	0.53342	     0.5	#_4         
 1989	1	1	0.46085	0.488049	#_5         
 1990	1	1	0.12519	     0.5	#_6         
 1991	1	1	0.22045	0.309938	#_7         
 1992	1	1	0.12564	     0.5	#_8         
 1993	1	1	0.14334	     0.5	#_9         
 1994	1	1	0.38737	     0.5	#_10        
 1995	1	1	0.35335	     0.5	#_11        
 1996	1	1	0.31389	     0.5	#_12        
 1997	1	1	0.64546	     0.5	#_13        
 1998	1	1	0.06441	     0.5	#_14        
 1999	1	1	0.21772	     0.5	#_15        
 2000	1	1	0.20729	     0.5	#_16        
 2001	1	1	0.27442	     0.5	#_17        
 2002	1	1	0.55429	     0.5	#_18        
 2003	1	1	0.72529	0.296677	#_19        
 2004	1	1	0.27941	     0.5	#_20        
 2005	1	1	0.13608	     0.5	#_21        
 2006	1	1	0.12202	     0.5	#_22        
 2007	1	1	0.28032	     0.5	#_23        
 2008	1	1	0.39735	     0.5	#_24        
 2009	1	1	0.56109	0.262737	#_25        
 2010	1	1	0.16919	     0.5	#_26        
 2011	1	1	 0.2717	     0.5	#_27        
 2012	1	1	0.07983	     0.5	#_28        
 2013	1	1	0.34881	     0.5	#_29        
 2014	1	1	0.29438	     0.5	#_30        
 2015	1	1	0.16148	     0.5	#_31        
 2016	1	1	0.06305	0.309637	#_32        
 2017	1	1	0.05579	0.347708	#_33        
 2018	1	1	0.06486	     0.2	#_34        
 2019	1	1	0.18597	     0.2	#_35        
 2020	1	1	0.11249	 0.24518	#_36        
 2021	1	1	0.01406	0.470573	#_37        
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
 2016	7	1	0.0720188	0.554733	#_1         
 2017	7	1	0.0882858	0.764977	#_2         
 2018	7	1	0.0365718	 1.02772	#_3         
 2019	7	1	 0.207781	 0.48149	#_4         
 2020	7	1	 0.196344	 0.59806	#_5         
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
57 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_1
13 #_N_lbins
#_lbin_vector
15 18 21 24 27 30 33 36 39 42 45 48 51 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l15	l18	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48	l51	l15m	l18m	l21m	l24m	l27m	l30m	l33m	l36m	l39m	l42m	l45m	l48m	l51m
 2011	 1	 1	0	0	58.46	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	#_1         
 2012	 1	 1	0	0	67.94	0	0	 5	 7	11	18	21	11	9	2	2	0	0	0	0	 5	 7	11	18	21	11	9	2	2	0	0	#_2         
 2013	 1	 1	0	0	62.41	0	0	 1	10	13	13	18	14	5	2	1	2	0	0	0	 1	10	13	13	18	14	5	2	1	2	0	#_3         
 2014	 1	 1	0	0	46.61	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	#_4         
 2015	 1	 1	0	0	   79	0	4	 8	19	19	13	12	15	4	4	1	1	0	0	4	 8	19	19	13	12	15	4	4	1	1	0	#_5         
 2016	-1	 1	0	0	35.81	0	0	 2	 3	 9	 8	 7	 5	1	2	3	3	0	0	0	 2	 3	 9	 8	 7	 5	1	2	3	3	0	#_6         
 2017	 1	-1	0	0	 4.74	0	0	 0	 0	 1	 2	 0	 1	1	0	0	1	0	0	0	 0	 0	 1	 2	 0	 1	1	0	0	1	0	#_7         
 2018	 1	-1	0	0	 2.37	0	0	 0	 0	 0	 0	 2	 1	0	0	0	0	0	0	0	 0	 0	 0	 0	 2	 1	0	0	0	0	0	#_8         
 2019	 1	-1	0	0	 9.57	0	0	 0	 1	 2	 2	 1	 1	0	1	2	1	0	0	0	 0	 1	 2	 2	 1	 1	0	1	2	1	0	#_9         
 2020	-1	-1	0	0	 8.69	0	0	 1	 1	 3	 1	 3	 0	0	0	1	1	0	0	0	 1	 1	 3	 1	 3	 0	0	0	1	1	0	#_10        
-9999	 0	 0	0	0	    0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	#_terminator
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
