#V3.30
#C data file for LERU
#
1967 #_styr
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
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	   0.304526	     0.5	#_1         
 1967	1	1	    0.25331	     0.5	#_2         
 1968	1	1	   0.532604	     0.5	#_3         
 1969	1	1	    0.28502	     0.5	#_4         
 1970	1	1	  0.0700623	     0.5	#_5         
 1971	1	1	0.000861754	     0.5	#_6         
 1972	1	1	    1.64945	     0.5	#_7         
 1973	1	1	    4.20563	     0.5	#_8         
 1974	1	1	    3.73852	     0.5	#_9         
 1975	1	1	    5.65526	     0.5	#_10        
 1976	1	1	    2.26748	     0.5	#_11        
 1977	1	1	    1.46606	     0.5	#_12        
 1978	1	1	    1.66051	     0.5	#_13        
 1979	1	1	    0.47478	     0.5	#_14        
 1980	1	1	    0.69106	     0.5	#_15        
 1981	1	1	    2.21645	     0.5	#_16        
 1982	1	1	    7.17325	     0.5	#_17        
 1983	1	1	    10.5661	     0.5	#_18        
 1984	1	1	     3.4093	     0.5	#_19        
 1985	1	1	    1.59948	     0.5	#_20        
 1986	1	1	    1.56539	     0.5	#_21        
 1987	1	1	   0.520743	     0.5	#_22        
 1988	1	1	    1.81914	     0.5	#_23        
 1989	1	1	    2.00701	     0.2	#_24        
 1990	1	1	    1.05106	0.281466	#_25        
 1991	1	1	   0.781185	0.227721	#_26        
 1992	1	1	    2.51168	0.456647	#_27        
 1993	1	1	   0.844807	     0.5	#_28        
 1994	1	1	   0.826188	0.391316	#_29        
 1995	1	1	    1.56633	0.463974	#_30        
 1996	1	1	   0.819775	0.425062	#_31        
 1997	1	1	    1.12892	0.305347	#_32        
 1998	1	1	    0.16448	     0.5	#_33        
 1999	1	1	   0.393588	     0.5	#_34        
 2000	1	1	    0.80487	     0.5	#_35        
 2001	1	1	    3.50509	     0.5	#_36        
 2002	1	1	    1.27693	0.477148	#_37        
 2003	1	1	   0.811867	0.460287	#_38        
 2004	1	1	     1.5171	     0.5	#_39        
 2005	1	1	     1.0449	     0.5	#_40        
 2006	1	1	    0.34589	     0.5	#_41        
 2007	1	1	    1.01388	     0.5	#_42        
 2008	1	1	    1.98842	0.327572	#_43        
 2009	1	1	    8.23968	     0.2	#_44        
 2010	1	1	    1.67799	     0.2	#_45        
 2011	1	1	    6.25957	 0.31116	#_46        
 2012	1	1	   0.718474	     0.5	#_47        
 2013	1	1	    1.95381	     0.5	#_48        
 2014	1	1	   0.568677	0.343554	#_49        
 2015	1	1	    3.18252	0.256762	#_50        
 2016	1	1	    1.01494	     0.2	#_51        
 2017	1	1	   0.705997	 0.20531	#_52        
 2018	1	1	   0.303879	     0.2	#_53        
 2019	1	1	    1.23508	     0.2	#_54        
 2020	1	1	    0.35976	     0.2	#_55        
 2021	1	1	   0.240144	0.406754	#_56        
-9999	0	0	          0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_FISHERY
#
#_CPUE_data
#_year	seas	index	obs	se_log
 2016	7	1	2.66496	0.209883	#_1         
 2017	7	1	2.37763	0.210971	#_2         
 2018	7	1	2.56825	     0.2	#_3         
 2019	7	1	3.64489	     0.2	#_4         
 2020	7	1	2.51974	     0.2	#_5         
 2021	7	1	5.68061	0.394811	#_6         
-9999	0	0	      0	       0	#_terminator
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
43 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
8 #_N_lbins
#_lbin_vector
14 17.5 21 24.5 28 31.5 35 38.5 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	f14	f17.5	f21	f24.5	f28	f31.5	f35	f38.5	m14	m17.5	m21	m24.5	m28	m31.5	m35	m38.5
 2004	1	1	0	0	  41	1	 2	  7	 10	 16	 4	 2	 2	1	 2	  7	 10	 16	 4	 2	 2	#_1         
 2005	1	1	0	0	  82	0	 0	 21	 40	 23	 8	 7	 0	0	 0	 21	 40	 23	 8	 7	 0	#_2         
 2006	1	1	0	0	  87	0	 1	 26	 35	 27	 7	 4	 0	0	 1	 26	 35	 27	 7	 4	 0	#_3         
 2007	1	1	0	0	  55	0	 1	 16	 30	 11	 3	 4	 4	0	 1	 16	 30	 11	 3	 4	 4	#_4         
 2008	1	1	0	0	 166	0	 0	 16	 80	 86	12	 8	 5	0	 0	 16	 80	 86	12	 8	 5	#_5         
 2009	1	1	0	0	 256	0	 6	 62	107	 99	29	12	 8	0	 6	 62	107	 99	29	12	 8	#_6         
 2010	1	1	0	0	  98	0	 0	 23	 61	 36	 3	 0	 1	0	 0	 23	 61	 36	 3	 0	 1	#_7         
 2011	1	1	0	0	 745	0	 5	204	353	320	42	 9	 3	0	 5	204	353	320	42	 9	 3	#_8         
 2012	1	1	0	0	1251	0	49	306	622	445	67	51	43	0	49	306	622	445	67	51	43	#_9         
 2013	1	1	0	0	1472	5	63	379	823	523	53	12	 5	5	63	379	823	523	53	12	 5	#_10        
 2014	1	1	0	0	 218	0	12	 36	 91	 96	12	 3	 0	0	12	 36	 91	 96	12	 3	 0	#_11        
 2015	1	1	0	0	 552	0	23	134	255	195	35	18	 9	0	23	134	255	195	35	18	 9	#_12        
 2016	1	1	0	0	 274	0	10	 50	125	100	17	 8	 7	0	10	 50	125	100	17	 8	 7	#_13        
 2017	1	1	0	0	 141	0	 2	 18	 58	 60	16	 6	 1	0	 2	 18	 58	 60	16	 6	 1	#_14        
 2018	1	1	0	0	 152	0	 7	 20	 66	 54	22	 6	 5	0	 7	 20	 66	 54	22	 6	 5	#_15        
 2019	1	1	0	0	 181	0	 4	 23	 90	 88	12	 5	 5	0	 4	 23	 90	 88	12	 5	 5	#_16        
 2020	1	1	0	0	 147	0	 2	 36	 82	 52	 7	 3	 2	0	 2	 36	 82	 52	 7	 3	 2	#_17        
 2021	1	1	0	0	  76	0	 1	 20	 37	 28	 5	 2	 2	0	 1	 20	 37	 28	 5	 2	 2	#_18        
-9999	0	0	0	0	   0	0	 0	  0	  0	  0	 0	 0	 0	0	 0	  0	  0	  0	 0	 0	 0	#_terminator
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
