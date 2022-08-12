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
 -999	1	1	1.19068	     0.5	#_1         
 1986	1	1	1.19068	     0.5	#_2         
 1987	1	1	0.32659	     0.5	#_3         
 1988	1	1	0.66678	     0.5	#_4         
 1989	1	1	0.13835	0.323813	#_5         
 1990	1	1	0.01542	     0.5	#_6         
 1991	1	1	0.27578	0.419592	#_7         
 1992	1	1	0.09208	     0.5	#_8         
 1993	1	1	0.20502	     0.5	#_9         
 1994	1	1	0.48081	     0.5	#_10        
 1995	1	1	0.45042	     0.5	#_11        
 1996	1	1	0.34382	     0.5	#_12        
 1997	1	1	0.98883	     0.5	#_13        
 1998	1	1	0.25356	0.429071	#_14        
 1999	1	1	 0.3597	     0.5	#_15        
 2000	1	1	0.09299	 0.21265	#_16        
 2001	1	1	 1.2433	0.460996	#_17        
 2002	1	1	0.73527	     0.5	#_18        
 2003	1	1	0.16874	     0.5	#_19        
 2004	1	1	0.25809	     0.5	#_20        
 2005	1	1	 0.3792	     0.5	#_21        
 2006	1	1	0.07802	     0.5	#_22        
 2007	1	1	 0.1955	     0.5	#_23        
 2008	1	1	0.53705	     0.5	#_24        
 2009	1	1	1.24148	 0.26664	#_25        
 2010	1	1	0.16284	0.356797	#_26        
 2011	1	1	0.35516	     0.5	#_27        
 2012	1	1	0.21682	     0.5	#_28        
 2013	1	1	0.27533	     0.5	#_29        
 2014	1	1	0.29166	     0.5	#_30        
 2015	1	1	0.55429	0.479778	#_31        
 2016	1	1	0.33248	 0.28581	#_32        
 2017	1	1	0.09253	0.336114	#_33        
 2018	1	1	0.16057	0.310018	#_34        
 2019	1	1	0.11476	0.378188	#_35        
 2020	1	1	 0.0753	0.407456	#_36        
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
 1988	7	1	 2.32185	0.518765	#_1         
 1989	7	1	 1.99028	0.737103	#_2         
 1990	7	1	0.514917	 0.82307	#_3         
 1991	7	1	 2.69535	0.650994	#_4         
 1992	7	1	0.542135	0.845009	#_5         
 1993	7	1	 1.39088	0.529988	#_6         
 1994	7	1	 1.77708	0.679215	#_7         
 1995	7	1	0.668367	0.432515	#_8         
 1996	7	1	0.671282	0.498036	#_9         
 1997	7	1	 2.84975	0.445061	#_10        
 1998	7	1	 2.04735	0.448445	#_11        
 1999	7	1	 1.95237	 0.34357	#_12        
 2000	7	1	 4.59548	0.340005	#_13        
 2001	7	1	 2.36907	 0.28013	#_14        
 2002	7	1	 1.69535	  0.3345	#_15        
 2003	7	1	 1.65258	0.512771	#_16        
 2004	7	1	 1.66405	0.267548	#_17        
 2005	7	1	  4.2001	0.311397	#_18        
 2006	7	1	 0.97873	0.481793	#_19        
 2007	7	1	 1.56254	0.293259	#_20        
 2008	7	1	 1.27737	0.356155	#_21        
 2009	7	1	 6.43285	0.346689	#_22        
 2010	7	1	 1.69147	0.479454	#_23        
 2011	7	1	 2.30704	0.446697	#_24        
 2012	7	1	 1.18451	0.655786	#_25        
 2013	7	1	   1.745	0.445554	#_26        
 2014	7	1	0.662164	0.425215	#_27        
 2015	7	1	 1.56003	0.321972	#_28        
 2016	7	1	 1.41813	0.549957	#_29        
 2017	7	1	0.541518	0.521959	#_30        
 2018	7	1	 1.14521	0.412435	#_31        
 2019	7	1	0.608778	0.548217	#_32        
 2020	7	1	0.706548	 0.64005	#_33        
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
0	1e-07	0	0	0	0	1	#_1
10 #_N_lbins
#_lbin_vector
21 24 27 30 33 36 39 42 45 48 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48
 2012	1	1	0	0	83.16	3	8	12	21	16	13	13	9	2	2	#_1         
 2013	1	1	0	0	87.36	2	7	 9	24	18	22	10	9	3	0	#_2         
 2015	1	1	0	0	   42	0	1	 5	 8	13	 9	 6	6	1	1	#_3         
-9999	0	0	0	0	    0	0	0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
