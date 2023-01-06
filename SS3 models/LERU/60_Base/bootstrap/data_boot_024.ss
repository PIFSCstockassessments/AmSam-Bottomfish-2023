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
 -999	1	1	   0.289362	     0.5	#_1         
 1967	1	1	    0.65526	     0.5	#_2         
 1968	1	1	    2.16212	     0.5	#_3         
 1969	1	1	   0.439459	     0.5	#_4         
 1970	1	1	   0.297975	     0.5	#_5         
 1971	1	1	0.000395669	     0.5	#_6         
 1972	1	1	    9.55633	     0.5	#_7         
 1973	1	1	    3.62597	     0.5	#_8         
 1974	1	1	     3.0007	     0.5	#_9         
 1975	1	1	      1.662	     0.5	#_10        
 1976	1	1	    2.08737	     0.5	#_11        
 1977	1	1	     1.1858	     0.5	#_12        
 1978	1	1	   0.429209	     0.5	#_13        
 1979	1	1	    0.62976	     0.5	#_14        
 1980	1	1	     2.1662	     0.5	#_15        
 1981	1	1	     1.8263	     0.5	#_16        
 1982	1	1	    5.26692	     0.5	#_17        
 1983	1	1	    5.54553	     0.5	#_18        
 1984	1	1	    11.0415	     0.5	#_19        
 1985	1	1	    1.94868	     0.5	#_20        
 1986	1	1	    4.39671	     0.5	#_21        
 1987	1	1	   0.854067	     0.5	#_22        
 1988	1	1	    1.12523	     0.5	#_23        
 1989	1	1	    1.66544	     0.2	#_24        
 1990	1	1	   0.903674	0.281466	#_25        
 1991	1	1	   0.943957	0.227721	#_26        
 1992	1	1	     0.5419	0.456647	#_27        
 1993	1	1	   0.440571	     0.5	#_28        
 1994	1	1	    1.51079	0.391316	#_29        
 1995	1	1	   0.907003	0.463974	#_30        
 1996	1	1	    2.38365	0.425062	#_31        
 1997	1	1	    1.41932	0.305347	#_32        
 1998	1	1	   0.225286	     0.5	#_33        
 1999	1	1	   0.268361	     0.5	#_34        
 2000	1	1	    1.80185	     0.5	#_35        
 2001	1	1	    3.28109	     0.5	#_36        
 2002	1	1	    2.26951	0.477148	#_37        
 2003	1	1	    1.09381	0.460287	#_38        
 2004	1	1	    1.50375	     0.5	#_39        
 2005	1	1	   0.918604	     0.5	#_40        
 2006	1	1	   0.155768	     0.5	#_41        
 2007	1	1	    1.44248	     0.5	#_42        
 2008	1	1	    4.28677	0.327572	#_43        
 2009	1	1	    7.52293	     0.2	#_44        
 2010	1	1	    1.41866	     0.2	#_45        
 2011	1	1	    5.27254	 0.31116	#_46        
 2012	1	1	   0.715523	     0.5	#_47        
 2013	1	1	    1.87321	     0.5	#_48        
 2014	1	1	    1.44855	0.343554	#_49        
 2015	1	1	    4.32044	0.256762	#_50        
 2016	1	1	   0.645882	     0.2	#_51        
 2017	1	1	   0.707326	 0.20531	#_52        
 2018	1	1	   0.268632	     0.2	#_53        
 2019	1	1	   0.841769	     0.2	#_54        
 2020	1	1	   0.518621	     0.2	#_55        
 2021	1	1	   0.107686	0.406754	#_56        
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
