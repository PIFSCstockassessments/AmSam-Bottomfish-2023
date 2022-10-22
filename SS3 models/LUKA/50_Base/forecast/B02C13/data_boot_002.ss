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
 -999	1	1	  0.408965	     0.5	#_1         
 1967	1	1	   0.73707	     0.5	#_2         
 1968	1	1	   3.16169	     0.5	#_3         
 1969	1	1	  0.520822	     0.5	#_4         
 1970	1	1	  0.171704	     0.5	#_5         
 1971	1	1	0.00178546	     0.5	#_6         
 1972	1	1	   8.00803	     0.5	#_7         
 1973	1	1	   4.26621	     0.5	#_8         
 1974	1	1	    6.7251	     0.5	#_9         
 1975	1	1	   9.94837	     0.5	#_10        
 1976	1	1	   5.80667	     0.5	#_11        
 1977	1	1	   4.64297	     0.5	#_12        
 1978	1	1	   1.53335	     0.5	#_13        
 1979	1	1	    2.0622	     0.5	#_14        
 1980	1	1	   2.14888	     0.5	#_15        
 1981	1	1	   1.70191	     0.5	#_16        
 1982	1	1	   3.00916	     0.5	#_17        
 1983	1	1	   6.53747	     0.5	#_18        
 1984	1	1	   2.93113	     0.5	#_19        
 1985	1	1	   4.60356	     0.5	#_20        
 1986	1	1	   5.72527	     0.5	#_21        
 1987	1	1	   1.07341	     0.5	#_22        
 1988	1	1	   3.62249	0.467268	#_23        
 1989	1	1	   2.14225	     0.2	#_24        
 1990	1	1	   1.05786	0.245355	#_25        
 1991	1	1	   1.62155	0.221413	#_26        
 1992	1	1	  0.393961	0.430176	#_27        
 1993	1	1	  0.505157	0.324167	#_28        
 1994	1	1	   1.72801	     0.2	#_29        
 1995	1	1	   1.68507	0.252915	#_30        
 1996	1	1	   1.52442	0.498858	#_31        
 1997	1	1	    2.7176	     0.2	#_32        
 1998	1	1	  0.507039	0.342705	#_33        
 1999	1	1	  0.286628	     0.5	#_34        
 2000	1	1	   1.84276	 0.27585	#_35        
 2001	1	1	   1.60587	 0.26062	#_36        
 2002	1	1	   2.92579	0.207101	#_37        
 2003	1	1	    1.1451	0.233131	#_38        
 2004	1	1	   1.06098	     0.5	#_39        
 2005	1	1	  0.212228	     0.5	#_40        
 2006	1	1	  0.126944	     0.5	#_41        
 2007	1	1	  0.456386	     0.5	#_42        
 2008	1	1	   1.91171	     0.5	#_43        
 2009	1	1	   3.00689	     0.2	#_44        
 2010	1	1	   1.61085	     0.2	#_45        
 2011	1	1	    1.6535	     0.5	#_46        
 2012	1	1	  0.911693	     0.5	#_47        
 2013	1	1	   2.54272	     0.5	#_48        
 2014	1	1	   1.38071	0.442494	#_49        
 2015	1	1	   2.01569	     0.2	#_50        
 2016	1	1	  0.594905	     0.2	#_51        
 2017	1	1	  0.386522	     0.2	#_52        
 2018	1	1	  0.220431	     0.2	#_53        
 2019	1	1	  0.239905	     0.2	#_54        
 2020	1	1	  0.343286	     0.2	#_55        
 2021	1	1	  0.154333	0.483547	#_56        
-9999	0	0	         0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_FISHERY
#
#_CPUE_data
#_year	seas	index	obs	se_log
 2016	7	1	1.78752	     0.2	#_1         
 2017	7	1	1.14899	0.208986	#_2         
 2018	7	1	1.38275	     0.2	#_3         
 2019	7	1	1.83557	     0.2	#_4         
 2020	7	1	1.12553	     0.2	#_5         
 2021	7	1	1.78568	0.408433	#_6         
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
 2004	1	1	0	0	 247.96	2	 8	 33	 99	 129	 24	 1	0	#_1         
 2005	1	1	0	0	  155.4	1	 3	 23	 69	  73	 15	 1	0	#_2         
 2006	1	1	0	0	  121.8	0	 3	 15	 40	  59	 27	 1	0	#_3         
 2007	1	1	0	0	 276.08	1	 3	 34	106	 141	 43	 6	6	#_4         
 2008	1	1	0	0	 295.88	0	 0	 25	110	 187	 38	 4	2	#_5         
 2009	1	1	0	0	 469.56	0	 3	 78	162	 255	 52	 4	5	#_6         
 2010	1	1	0	0	 152.88	0	 0	 21	 49	  95	 17	 0	0	#_7         
 2011	1	1	0	0	 811.44	0	 2	107	284	 480	 80	 9	4	#_8         
 2012	1	1	0	0	1333.92	0	15	192	501	 755	122	 1	2	#_9         
 2013	1	1	0	0	2562.84	3	47	443	946	1397	193	14	8	#_10        
 2014	1	1	0	0	1043.28	0	18	138	362	 580	129	 9	6	#_11        
 2015	1	1	0	0	1056.72	1	12	119	414	 571	123	15	3	#_12        
 2016	1	1	0	0	 338.52	0	 3	 29	107	 214	 44	 5	1	#_13        
 2017	1	1	0	0	 164.64	0	 0	  8	 47	 111	 18	 3	9	#_14        
 2018	1	1	0	0	 157.92	0	 2	 16	 52	  93	 25	 0	0	#_15        
 2019	1	1	0	0	 215.88	0	 2	 15	 94	 113	 26	 3	4	#_16        
 2020	1	1	0	0	 164.64	0	 0	 11	 48	 116	 15	 3	3	#_17        
 2021	1	1	0	0	  91.56	0	 0	  8	 36	  62	  3	 0	0	#_18        
-9999	0	0	0	0	      0	0	 0	  0	  0	   0	  0	 0	0	#_terminator
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
