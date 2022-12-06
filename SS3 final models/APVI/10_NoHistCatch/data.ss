#V3.30
#C data file for APVI
#
1986 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
32 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	      0	    0.01	#_1         
 1986	1	1	 3.0436	     0.5	#_2         
 1987	1	1	0.99019	     0.5	#_3         
 1988	1	1	1.32086	     0.5	#_4         
 1989	1	1	1.05324	0.250473	#_5         
 1990	1	1	0.55565	0.435616	#_6         
 1991	1	1	1.13806	0.234849	#_7         
 1992	1	1	0.76702	0.357252	#_8         
 1993	1	1	0.96797	0.333495	#_9         
 1994	1	1	1.58712	0.202063	#_10        
 1995	1	1	1.35942	0.336023	#_11        
 1996	1	1	1.97086	0.387366	#_12        
 1997	1	1	 1.5785	0.214793	#_13        
 1998	1	1	 0.2531	0.412477	#_14        
 1999	1	1	0.48761	     0.5	#_15        
 2000	1	1	1.78126	0.462061	#_16        
 2001	1	1	0.99246	0.326622	#_17        
 2002	1	1	1.54403	0.328972	#_18        
 2003	1	1	0.44316	     0.2	#_19        
 2004	1	1	1.14759	     0.5	#_20        
 2005	1	1	0.72756	     0.5	#_21        
 2006	1	1	0.39916	     0.5	#_22        
 2007	1	1	1.30453	     0.5	#_23        
 2008	1	1	2.35187	0.426328	#_24        
 2009	1	1	4.39531	     0.2	#_25        
 2010	1	1	0.77065	0.313912	#_26        
 2011	1	1	1.51454	     0.5	#_27        
 2012	1	1	0.46312	     0.5	#_28        
 2013	1	1	1.88785	     0.5	#_29        
 2014	1	1	2.19493	 0.39786	#_30        
 2015	1	1	2.55282	 0.27296	#_31        
 2016	1	1	 2.9928	     0.2	#_32        
 2017	1	1	1.91144	     0.2	#_33        
 2018	1	1	0.94574	     0.2	#_34        
 2019	1	1	1.24965	     0.2	#_35        
 2020	1	1	1.32993	     0.2	#_36        
 2021	1	1	0.12338	0.293454	#_37        
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
 2016	7	1	9.82017	     0.2	#_1         
 2017	7	1	7.16483	     0.2	#_2         
 2018	7	1	6.45644	     0.2	#_3         
 2019	7	1	 8.3545	     0.2	#_4         
 2020	7	1	9.42847	     0.2	#_5         
 2021	7	1	8.88049	0.348927	#_6         
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
94 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_1
15 #_N_lbins
#_lbin_vector
15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85
 2004	-1	 1	0	0	127.52	0	0	0	4	18	29	33	26	20	12	 5	 3	1	0	1	#_1         
 2005	 1	-1	0	0	 28.71	0	0	0	2	 2	 6	 8	 6	 6	 3	 0	 0	0	0	0	#_2         
 2006	-1	-1	0	0	 30.45	0	0	0	0	 1	 5	 7	 5	 5	 6	 3	 2	0	0	1	#_3         
 2007	 1	 1	0	0	169.79	0	0	2	2	11	30	44	38	27	12	10	 4	1	1	1	#_4         
 2008	 1	 1	0	0	160.41	0	0	0	0	 4	17	32	45	39	18	10	12	1	1	0	#_5         
 2009	 1	 1	0	0	142.99	0	0	0	2	 8	24	46	42	28	11	 7	 7	3	1	2	#_6         
 2010	-1	 1	0	0	102.54	0	1	0	2	22	23	24	26	12	 9	 3	 1	2	1	0	#_7         
 2011	 1	-1	0	0	 58.67	0	1	0	2	17	13	12	12	10	 4	 1	 0	1	0	0	#_8         
 2012	-1	-1	0	0	 14.43	0	0	0	0	 3	 5	 5	 2	 1	 0	 1	 0	0	0	0	#_9         
 2013	 1	 1	0	0	 47.82	0	0	0	2	 4	10	13	11	 9	 6	 2	 0	1	0	0	#_10        
 2014	 1	 1	0	0	165.58	1	2	2	5	20	43	45	35	19	18	 7	 3	2	0	0	#_11        
 2015	 1	 1	0	0	145.55	2	6	2	4	 5	14	36	39	24	20	 6	 6	0	1	0	#_12        
 2016	 1	 1	0	0	167.58	1	2	1	1	 4	22	38	44	36	28	15	 8	2	0	0	#_13        
 2017	 1	 1	0	0	109.96	0	2	0	0	 3	17	31	23	20	23	 8	 5	3	2	0	#_14        
 2018	 1	 1	0	0	 59.16	0	0	0	1	 3	 1	14	17	13	12	 2	 3	0	2	0	#_15        
 2019	 1	 1	0	0	 84.79	0	0	5	4	 2	10	21	20	23	10	 2	 3	1	0	0	#_16        
 2020	 1	 1	0	0	 85.53	0	0	1	2	 6	10	30	24	14	12	 3	 4	1	0	0	#_17        
-9999	 0	 0	0	0	     0	0	0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
