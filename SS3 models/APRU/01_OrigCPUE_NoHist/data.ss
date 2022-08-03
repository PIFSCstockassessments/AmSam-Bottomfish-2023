#V3.30
#C data file for APRU
#
1986 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
30 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	 1.5658	     0.5	#_1         
 1986	1	1	 1.5658	     0.5	#_2         
 1987	1	1	0.46584	     0.5	#_3         
 1988	1	1	1.15303	     0.5	#_4         
 1989	1	1	0.58559	 0.32586	#_5         
 1990	1	1	0.06486	     0.5	#_6         
 1991	1	1	0.12156	0.480854	#_7         
 1992	1	1	0.32432	     0.5	#_8         
 1993	1	1	0.18189	     0.5	#_9         
 1994	1	1	0.68855	0.363779	#_10        
 1995	1	1	0.43363	     0.5	#_11        
 1996	1	1	1.31451	     0.5	#_12        
 1997	1	1	1.29138	0.260358	#_13        
 1998	1	1	0.17463	     0.5	#_14        
 1999	1	1	0.40098	     0.5	#_15        
 2000	1	1	0.52254	     0.5	#_16        
 2001	1	1	0.55338	0.348732	#_17        
 2002	1	1	2.20582	     0.5	#_18        
 2003	1	1	0.24811	0.310752	#_19        
 2004	1	1	0.43908	     0.5	#_20        
 2005	1	1	0.47219	     0.5	#_21        
 2006	1	1	0.19867	     0.5	#_22        
 2007	1	1	1.25373	     0.5	#_23        
 2008	1	1	1.63837	     0.5	#_24        
 2009	1	1	3.25271	     0.2	#_25        
 2010	1	1	0.67767	0.273691	#_26        
 2011	1	1	1.18886	     0.5	#_27        
 2012	1	1	0.34791	     0.5	#_28        
 2013	1	1	 1.3381	     0.5	#_29        
 2014	1	1	1.63112	     0.5	#_30        
 2015	1	1	1.84521	0.277979	#_31        
 2016	1	1	1.24012	0.218319	#_32        
 2017	1	1	1.56489	     0.2	#_33        
 2018	1	1	0.90219	0.312542	#_34        
 2019	1	1	1.24375	 0.34192	#_35        
 2020	1	1	0.23904	0.394157	#_36        
 2021	1	1	0.03357	0.452443	#_37        
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
 2016	7	1	6.09063	0.642807	#_1         
 2017	7	1	12.2572	0.548697	#_2         
 2018	7	1	8.56797	0.562991	#_3         
 2019	7	1	7.42021	0.623754	#_4         
 2020	7	1	 6.6249	0.746608	#_5         
 2021	7	1	18.0042	0.804106	#_6         
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
100 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	0.0000001	0	0	0	0	1	#_1
15 #_N_lbins
#_lbin_vector
20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85	l90
 2007	1	1	0	0	 93.44	0	0	 3	 6	37	35	23	27	19	12	 8	5	1	0	0	#_1         
 2008	1	1	0	0	 80.72	0	2	 4	11	12	10	14	15	 9	 5	10	7	4	2	0	#_2         
 2009	1	1	0	0	 110.2	0	0	 0	12	14	16	18	17	15	14	12	5	4	5	0	#_3         
 2010	1	1	0	0	 41.16	0	0	 0	 7	 4	 7	 8	 5	 3	 8	 2	3	2	0	0	#_4         
 2011	1	1	0	0	 61.32	1	7	 1	 7	12	11	 4	 9	 3	 6	 3	1	7	1	0	#_5         
 2012	1	1	0	0	 86.52	0	1	11	 6	19	20	14	15	 3	 7	 4	2	0	1	0	#_6         
 2013	1	1	0	0	 50.04	0	2	 1	 2	 8	14	 7	 8	 5	 5	 6	4	0	0	0	#_7         
 2014	1	1	0	0	 71.72	0	0	 0	 0	 5	15	14	13	12	12	 5	8	1	1	1	#_8         
 2015	1	1	0	0	 99.28	3	0	 6	 9	11	17	19	15	15	 9	 7	3	1	4	0	#_9         
 2016	1	1	0	0	 80.64	0	1	 1	 5	25	12	 8	 6	11	11	 7	5	2	2	0	#_10        
 2017	1	1	0	0	104.16	1	2	 4	 6	29	20	13	12	11	 9	 9	4	2	1	1	#_11        
 2018	1	1	0	0	 38.64	0	0	 2	 7	 4	11	 7	 2	 2	 4	 4	1	2	0	0	#_12        
 2019	1	1	0	0	 65.52	0	0	 4	 2	 2	12	13	 9	19	 6	 8	2	1	0	0	#_13        
-9999	0	0	0	0	     0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
