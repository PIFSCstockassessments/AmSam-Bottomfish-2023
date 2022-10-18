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
 -999	1	1	  0.305283	     0.3	#_1         
 1967	1	1	  0.486506	     0.3	#_2         
 1968	1	1	  0.678577	     0.3	#_3         
 1969	1	1	  0.414131	     0.3	#_4         
 1970	1	1	  0.126932	     0.3	#_5         
 1971	1	1	0.00126717	     0.3	#_6         
 1972	1	1	   5.82332	     0.3	#_7         
 1973	1	1	   4.49472	     0.3	#_8         
 1974	1	1	   5.09273	     0.3	#_9         
 1975	1	1	   5.62519	     0.3	#_10        
 1976	1	1	   1.74919	     0.3	#_11        
 1977	1	1	   3.04231	     0.3	#_12        
 1978	1	1	  0.802195	     0.3	#_13        
 1979	1	1	  0.549114	     0.3	#_14        
 1980	1	1	   1.65682	     0.3	#_15        
 1981	1	1	   2.70208	     0.3	#_16        
 1982	1	1	   3.43879	     0.3	#_17        
 1983	1	1	   8.34309	     0.3	#_18        
 1984	1	1	   3.89727	     0.3	#_19        
 1985	1	1	   2.00763	     0.3	#_20        
 1986	1	1	   1.63857	     0.5	#_21        
 1987	1	1	   2.78789	     0.5	#_22        
 1988	1	1	   1.03087	     0.5	#_23        
 1989	1	1	     1.284	     0.2	#_24        
 1990	1	1	   1.20953	0.281466	#_25        
 1991	1	1	  0.921303	0.227721	#_26        
 1992	1	1	   1.26014	0.456647	#_27        
 1993	1	1	  0.990418	     0.5	#_28        
 1994	1	1	   1.19765	0.391316	#_29        
 1995	1	1	   1.89967	0.464613	#_30        
 1996	1	1	   3.49111	0.424734	#_31        
 1997	1	1	   1.51806	 0.30496	#_32        
 1998	1	1	  0.127655	     0.5	#_33        
 1999	1	1	  0.412555	     0.5	#_34        
 2000	1	1	   1.36268	     0.5	#_35        
 2001	1	1	   5.64561	     0.5	#_36        
 2002	1	1	   3.54705	0.477013	#_37        
 2003	1	1	  0.583894	 0.45899	#_38        
 2004	1	1	   1.13742	     0.5	#_39        
 2005	1	1	  0.923608	     0.5	#_40        
 2006	1	1	  0.323762	     0.5	#_41        
 2007	1	1	   1.07536	     0.5	#_42        
 2008	1	1	   2.18155	0.327572	#_43        
 2009	1	1	   8.35617	     0.2	#_44        
 2010	1	1	   1.91471	     0.2	#_45        
 2011	1	1	   3.54009	 0.31116	#_46        
 2012	1	1	  0.435373	     0.5	#_47        
 2013	1	1	   3.30401	     0.5	#_48        
 2014	1	1	   1.06572	0.343554	#_49        
 2015	1	1	    4.0164	0.256762	#_50        
 2016	1	1	  0.838244	     0.2	#_51        
 2017	1	1	  0.892066	 0.20531	#_52        
 2018	1	1	  0.399516	     0.2	#_53        
 2019	1	1	  0.830619	     0.2	#_54        
 2020	1	1	  0.446822	     0.2	#_55        
 2021	1	1	  0.205623	0.406754	#_56        
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
 2016	7	1	2.66545	0.209826	#_1         
 2017	7	1	2.37861	 0.21091	#_2         
 2018	7	1	2.56887	     0.2	#_3         
 2019	7	1	3.64435	     0.2	#_4         
 2020	7	1	2.52009	     0.2	#_5         
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
 2004	1	1	0	0	 148.96	1	 2	 16	 55	 86	12	 7	 4	1	 2	 16	 55	 86	12	 7	 4	#_1         
 2005	1	1	0	0	 125.16	0	 0	 29	 50	 25	19	18	 8	0	 0	 29	 50	 25	19	18	 8	#_2         
 2006	1	1	0	0	  99.12	0	 0	 21	 35	 30	 7	22	 3	0	 0	 21	 35	 30	 7	22	 3	#_3         
 2007	1	1	0	0	  81.48	0	 1	 16	 34	 18	 8	13	 7	0	 1	 16	 34	 18	 8	13	 7	#_4         
 2008	1	1	0	0	 250.48	0	 0	 24	114	127	16	11	 7	0	 0	 24	114	127	16	11	 7	#_5         
 2009	1	1	0	0	  331.8	0	 6	 72	128	133	32	16	 8	0	 6	 72	128	133	32	16	 8	#_6         
 2010	1	1	0	0	 104.16	0	 0	 23	 61	 36	 3	 0	 1	0	 0	 23	 61	 36	 3	 0	 1	#_7         
 2011	1	1	0	0	 782.04	0	 5	204	352	320	38	 9	 3	0	 5	204	352	320	38	 9	 3	#_8         
 2012	1	1	0	0	1329.72	0	49	306	622	445	67	51	43	0	49	306	622	445	67	51	43	#_9         
 2013	1	1	0	0	1564.92	5	63	379	823	523	53	12	 5	5	63	379	823	523	53	12	 5	#_10        
 2014	1	1	0	0	 190.68	0	12	 35	 87	 79	11	 3	 0	0	12	 35	 87	 79	11	 3	 0	#_11        
 2015	1	1	0	0	 542.64	0	23	134	254	178	32	17	 8	0	23	134	254	178	32	17	 8	#_12        
 2016	1	1	0	0	 246.96	0	10	 49	114	 92	15	 7	 7	0	10	 49	114	 92	15	 7	 7	#_13        
 2017	1	1	0	0	 110.88	0	 2	 17	 52	 44	12	 4	 1	0	 2	 17	 52	 44	12	 4	 1	#_14        
 2018	1	1	0	0	 143.64	0	 7	 20	 66	 51	17	 6	 4	0	 7	 20	 66	 51	17	 6	 4	#_15        
 2019	1	1	0	0	 189.84	0	 4	 23	 90	 88	12	 4	 5	0	 4	 23	 90	 88	12	 4	 5	#_16        
 2020	1	1	0	0	 153.72	0	 2	 36	 82	 51	 7	 3	 2	0	 2	 36	 82	 51	 7	 3	 2	#_17        
 2021	1	1	0	0	   79.8	0	 1	 20	 37	 28	 5	 2	 2	0	 1	 20	 37	 28	 5	 2	 2	#_18        
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
