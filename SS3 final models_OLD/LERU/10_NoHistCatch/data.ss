#V3.30
#C data file for LERU
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
 -999	1	1	 4.18665	     0.5	#_1         
 1986	1	1	 4.18665	     0.5	#_2         
 1987	1	1	 1.41566	     0.5	#_3         
 1988	1	1	 2.43171	     0.5	#_4         
 1989	1	1	 2.36684	     0.2	#_5         
 1990	1	1	 1.12491	0.281466	#_6         
 1991	1	1	  0.9666	0.227721	#_7         
 1992	1	1	 1.38935	0.456647	#_8         
 1993	1	1	 0.62641	     0.5	#_9         
 1994	1	1	 1.52906	0.391316	#_10        
 1995	1	1	 1.19159	0.463974	#_11        
 1996	1	1	 2.15728	0.425062	#_12        
 1997	1	1	 1.70823	0.305347	#_13        
 1998	1	1	 0.23179	     0.5	#_14        
 1999	1	1	 0.28803	     0.5	#_15        
 2000	1	1	 1.43426	     0.5	#_16        
 2001	1	1	 4.28781	     0.5	#_17        
 2002	1	1	 2.88348	0.477148	#_18        
 2003	1	1	 1.15485	0.460287	#_19        
 2004	1	1	 1.38209	     0.5	#_20        
 2005	1	1	 0.84822	     0.5	#_21        
 2006	1	1	 0.39145	     0.5	#_22        
 2007	1	1	 1.61207	     0.5	#_23        
 2008	1	1	 3.32483	0.327572	#_24        
 2009	1	1	 7.03567	     0.2	#_25        
 2010	1	1	 1.48642	     0.2	#_26        
 2011	1	1	 3.66321	 0.31116	#_27        
 2012	1	1	 1.13443	     0.5	#_28        
 2013	1	1	 2.21217	     0.5	#_29        
 2014	1	1	 1.06231	0.343554	#_30        
 2015	1	1	 3.07218	0.256762	#_31        
 2016	1	1	0.874984	     0.2	#_32        
 2017	1	1	 0.61689	 0.20531	#_33        
 2018	1	1	 0.40324	     0.2	#_34        
 2019	1	1	 0.81193	     0.2	#_35        
 2020	1	1	 0.43545	     0.2	#_36        
 2021	1	1	 0.19096	0.406754	#_37        
-9999	0	0	       0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_1
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
-1	0.001	0	0	1	1	0.001	#_1
8 #_N_lbins
#_lbin_vector
14 17.5 21 24.5 28 31.5 35 38.5 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l14	l17.5	l21	l24.5	l28	l31.5	l35	l38.5	l14m	l17.5m	l21m	l24.5m	l28m	l31.5m	l35m	l38.5m
 2004	1	1	0	0	 151.57	1	 2	 16	 55	 86	12	 7	 4	1	 2	 16	 55	 86	12	 7	 4	#_1         
 2005	1	1	0	0	 123.08	0	 0	 29	 50	 28	19	18	 8	0	 0	 29	 50	 28	19	18	 8	#_2         
 2006	1	1	0	0	 120.06	0	 1	 27	 41	 34	 7	25	 3	0	 1	 27	 41	 34	 7	25	 3	#_3         
 2007	1	1	0	0	  76.63	0	 1	 16	 34	 18	 8	13	 7	0	 1	 16	 34	 18	 8	13	 7	#_4         
 2008	1	1	0	0	 247.95	0	 0	 24	115	131	17	11	 7	0	 0	 24	115	131	17	11	 7	#_5         
 2009	1	1	0	0	 312.05	0	 6	 72	128	133	32	16	 8	0	 6	 72	128	133	32	16	 8	#_6         
 2010	1	1	0	0	  97.96	0	 0	 23	 61	 36	 3	 0	 1	0	 0	 23	 61	 36	 3	 0	 1	#_7         
 2011	1	1	0	0	 744.44	0	 5	204	353	320	42	 9	 3	0	 5	204	353	320	42	 9	 3	#_8         
 2012	1	1	0	0	1250.57	0	49	306	622	445	67	51	43	0	49	306	622	445	67	51	43	#_9         
 2013	1	1	0	0	1471.77	5	63	379	823	523	53	12	 5	5	63	379	823	523	53	12	 5	#_10        
 2014	1	1	0	0	  217.5	0	12	 36	 91	 96	12	 3	 0	0	12	 36	 91	 96	12	 3	 0	#_11        
 2015	1	1	0	0	 551.51	0	23	134	255	195	35	18	 9	0	23	134	255	195	35	18	 9	#_12        
 2016	1	1	0	0	 273.43	0	10	 50	125	100	17	 8	 7	0	10	 50	125	100	17	 8	 7	#_13        
 2017	1	1	0	0	 140.07	0	 2	 18	 58	 60	16	 6	 1	0	 2	 18	 58	 60	16	 6	 1	#_14        
 2018	1	1	0	0	  151.2	0	 7	 20	 66	 54	22	 6	 5	0	 7	 20	 66	 54	22	 6	 5	#_15        
 2019	1	1	0	0	 180.33	0	 4	 23	 90	 88	12	 5	 5	0	 4	 23	 90	 88	12	 5	 5	#_16        
 2020	1	1	0	0	 146.36	0	 2	 36	 82	 52	 7	 3	 2	0	 2	 36	 82	 52	 7	 3	 2	#_17        
 2021	1	1	0	0	  75.05	0	 1	 20	 37	 28	 5	 2	 2	0	 1	 20	 37	 28	 5	 2	 2	#_18        
-9999	0	0	0	0	      0	0	 0	  0	  0	  0	 0	 0	 0	0	 0	  0	  0	  0	 0	 0	 0	#_terminator
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
