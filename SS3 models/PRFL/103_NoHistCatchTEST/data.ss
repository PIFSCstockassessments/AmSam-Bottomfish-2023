#V3.30
#C data file for PRFL
#
1986 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
28 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	  1.19068	     0.5	#_1         
 1986	1	1	  1.19068	     0.5	#_2         
 1987	1	1	  0.32659	     0.5	#_3         
 1988	1	1	  0.66678	     0.5	#_4         
 1989	1	1	  0.13835	0.323813	#_5         
 1990	1	1	  0.01542	     0.5	#_6         
 1991	1	1	  0.27578	0.419592	#_7         
 1992	1	1	  0.09208	     0.5	#_8         
 1993	1	1	  0.20502	     0.5	#_9         
 1994	1	1	  0.48081	     0.5	#_10        
 1995	1	1	  0.45042	     0.5	#_11        
 1996	1	1	  0.34382	     0.5	#_12        
 1997	1	1	  0.98883	     0.5	#_13        
 1998	1	1	  0.25356	0.429071	#_14        
 1999	1	1	   0.3597	     0.5	#_15        
 2000	1	1	  0.09299	 0.21265	#_16        
 2001	1	1	   1.2433	0.460996	#_17        
 2002	1	1	  0.73527	     0.5	#_18        
 2003	1	1	  0.16874	     0.5	#_19        
 2004	1	1	  0.25809	     0.5	#_20        
 2005	1	1	   0.3792	     0.5	#_21        
 2006	1	1	  0.07893	     0.5	#_22        
 2007	1	1	  0.19777	     0.5	#_23        
 2008	1	1	  0.53841	     0.5	#_24        
 2009	1	1	  1.24148	 0.26664	#_25        
 2010	1	1	  0.16284	0.356797	#_26        
 2011	1	1	  0.35698	     0.5	#_27        
 2012	1	1	  0.28803	     0.5	#_28        
 2013	1	1	  0.28077	     0.5	#_29        
 2014	1	1	  0.29257	     0.5	#_30        
 2015	1	1	  0.55474	0.479431	#_31        
 2016	1	1	 0.600099	 0.28581	#_32        
 2017	1	1	  0.09253	0.336114	#_33        
 2018	1	1	  0.16057	0.310018	#_34        
 2019	1	1	  0.11476	0.378188	#_35        
 2020	1	1	   0.0753	0.407456	#_36        
 2021	1	1	0.0113852	  0.3993	#_37        
-9999	0	0	        0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_1
#
#_CPUE_data
#_year	seas	index	obs	se_log
 2016	7	1	 1.41011	0.432958	#_1         
 2017	7	1	0.490532	0.450902	#_2         
 2018	7	1	 1.27304	0.320396	#_3         
 2019	7	1	0.697095	0.407751	#_4         
 2020	7	1	0.907046	 0.45313	#_5         
-9999	0	0	       0	       0	#_terminator
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
53 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_1
10 #_N_lbins
#_lbin_vector
21 24 27 30 33 36 39 42 45 48 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48
 2011	-1	 1	0	0	92.43	5	10	16	23	19	15	15	10	2	2	#_1         
 2012	-1	-1	0	0	78.21	3	 8	12	21	16	13	13	 9	2	2	#_2         
 2013	 1	 1	0	0	82.16	2	 7	 9	24	18	22	10	 9	3	0	#_3         
 2018	-1	 1	0	0	50.42	0	 1	 3	 3	 7	20	24	 5	3	0	#_4         
 2019	 1	-1	0	0	 15.8	0	 0	 2	 1	 4	 6	 6	 0	1	0	#_5         
 2020	-1	-1	0	0	11.06	0	 0	 1	 1	 0	 6	 3	 2	1	0	#_6         
-9999	 0	 0	0	0	    0	0	 0	 0	 0	 0	 0	 0	 0	0	0	#_terminator
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
