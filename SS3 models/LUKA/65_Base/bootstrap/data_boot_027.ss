#V3.30
#C data file for LUKA
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
8 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	    1.46034	     0.5	#_1         
 1967	1	1	   0.877775	     0.5	#_2         
 1968	1	1	    4.56749	     0.5	#_3         
 1969	1	1	   0.807891	     0.5	#_4         
 1970	1	1	   0.328496	     0.5	#_5         
 1971	1	1	0.000743847	     0.5	#_6         
 1972	1	1	    4.09167	     0.5	#_7         
 1973	1	1	    15.0758	     0.5	#_8         
 1974	1	1	    1.94074	     0.5	#_9         
 1975	1	1	    3.55353	     0.5	#_10        
 1976	1	1	    7.16028	     0.5	#_11        
 1977	1	1	    1.68447	     0.5	#_12        
 1978	1	1	    1.79206	     0.5	#_13        
 1979	1	1	    1.72435	     0.5	#_14        
 1980	1	1	    1.68898	     0.5	#_15        
 1981	1	1	    2.54193	     0.5	#_16        
 1982	1	1	    4.35472	     0.5	#_17        
 1983	1	1	    8.98923	     0.5	#_18        
 1984	1	1	    9.14893	     0.5	#_19        
 1985	1	1	     5.8133	     0.5	#_20        
 1986	1	1	    6.91432	     0.5	#_21        
 1987	1	1	    1.84666	     0.5	#_22        
 1988	1	1	     1.1834	0.467268	#_23        
 1989	1	1	    1.73069	     0.2	#_24        
 1990	1	1	    1.26782	0.245355	#_25        
 1991	1	1	    0.79561	0.221413	#_26        
 1992	1	1	   0.582168	0.430176	#_27        
 1993	1	1	   0.752089	0.324167	#_28        
 1994	1	1	    1.64584	     0.2	#_29        
 1995	1	1	    1.94515	0.252915	#_30        
 1996	1	1	    2.03909	0.498858	#_31        
 1997	1	1	    1.57856	     0.2	#_32        
 1998	1	1	   0.580489	0.342705	#_33        
 1999	1	1	   0.430482	     0.5	#_34        
 2000	1	1	     1.9739	 0.27585	#_35        
 2001	1	1	     1.9759	 0.26062	#_36        
 2002	1	1	    3.22245	0.207101	#_37        
 2003	1	1	   0.950849	0.233131	#_38        
 2004	1	1	    1.22402	     0.5	#_39        
 2005	1	1	   0.343863	     0.5	#_40        
 2006	1	1	   0.183159	     0.5	#_41        
 2007	1	1	    0.77604	     0.5	#_42        
 2008	1	1	    1.08192	     0.5	#_43        
 2009	1	1	    4.36177	     0.2	#_44        
 2010	1	1	    1.23019	     0.2	#_45        
 2011	1	1	    2.81884	     0.5	#_46        
 2012	1	1	   0.224353	     0.5	#_47        
 2013	1	1	    1.20694	     0.5	#_48        
 2014	1	1	   0.778151	0.442494	#_49        
 2015	1	1	    1.94549	     0.2	#_50        
 2016	1	1	   0.592143	     0.2	#_51        
 2017	1	1	   0.515482	     0.2	#_52        
 2018	1	1	   0.259087	     0.2	#_53        
 2019	1	1	   0.245667	     0.2	#_54        
 2020	1	1	   0.287222	     0.2	#_55        
 2021	1	1	   0.138902	0.483547	#_56        
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
 2016	7	1	1.78809	     0.2	#_1         
 2017	7	1	1.14939	0.208958	#_2         
 2018	7	1	1.38325	     0.2	#_3         
 2019	7	1	1.83588	     0.2	#_4         
 2020	7	1	1.12559	     0.2	#_5         
 2021	7	1	1.78588	0.408432	#_6         
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
31 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
8 #_N_lbins
#_lbin_vector
14 16 18 20 22 24 26 28 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	l14	l16	l18	l20	l22	l24	l26	l28
 2004	1	1	0	0	 235	2	 8	 33	 99	 129	 24	 1	 0	#_1         
 2005	1	1	0	0	 147	1	 3	 23	 69	  73	 15	 1	 0	#_2         
 2006	1	1	0	0	 147	0	 3	 16	 48	  66	 33	 2	 0	#_3         
 2007	1	1	0	0	 292	1	 3	 34	107	 143	 44	 7	 6	#_4         
 2008	1	1	0	0	 346	0	 0	 28	118	 193	 42	 4	 3	#_5         
 2009	1	1	0	0	 456	0	 3	 78	166	 259	 52	 4	 5	#_6         
 2010	1	1	0	0	 144	0	 0	 21	 49	  95	 17	 0	 0	#_7         
 2011	1	1	0	0	 782	0	 2	108	285	 482	 83	12	 4	#_8         
 2012	1	1	0	0	1255	0	15	192	501	 755	122	 1	 2	#_9         
 2013	1	1	0	0	2416	3	47	443	948	1398	193	14	 8	#_10        
 2014	1	1	0	0	1062	0	18	143	374	 592	138	14	 8	#_11        
 2015	1	1	0	0	1023	1	12	119	417	 580	126	15	 4	#_12        
 2016	1	1	0	0	 369	0	 3	 34	110	 224	 52	 7	 1	#_13        
 2017	1	1	0	0	 204	0	 0	  9	 51	 135	 26	 3	10	#_14        
 2018	1	1	0	0	 170	0	 2	 16	 53	  96	 30	 0	 3	#_15        
 2019	1	1	0	0	 212	0	 2	 16	 94	 114	 28	 3	 5	#_16        
 2020	1	1	0	0	 155	0	 0	 11	 48	 116	 15	 3	 3	#_17        
 2021	1	1	0	0	  87	0	 0	  8	 36	  62	  3	 0	 0	#_18        
-9999	0	0	0	0	   0	0	 0	  0	  0	   0	  0	 0	 0	#_terminator
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
