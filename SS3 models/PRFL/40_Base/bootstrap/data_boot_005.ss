#V3.30
#C data file for PRFL
#
1967 #_styr
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
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	         0	    0.01	#_1         
 1967	1	1	 0.0155403	     0.5	#_2         
 1968	1	1	 0.0517428	     0.5	#_3         
 1969	1	1	 0.0214894	     0.5	#_4         
 1970	1	1	0.00456177	     0.5	#_5         
 1971	1	1	0.00146333	     0.5	#_6         
 1972	1	1	  0.259102	     0.5	#_7         
 1973	1	1	  0.415629	     0.5	#_8         
 1974	1	1	  0.346206	     0.5	#_9         
 1975	1	1	  0.397222	     0.5	#_10        
 1976	1	1	  0.385749	     0.5	#_11        
 1977	1	1	  0.051493	     0.5	#_12        
 1978	1	1	  0.119731	     0.5	#_13        
 1979	1	1	 0.0336956	     0.5	#_14        
 1980	1	1	  0.317551	     0.5	#_15        
 1981	1	1	  0.810929	     0.5	#_16        
 1982	1	1	   1.17304	     0.5	#_17        
 1983	1	1	   1.74376	     0.5	#_18        
 1984	1	1	  0.806358	     0.5	#_19        
 1985	1	1	   3.28676	     0.5	#_20        
 1986	1	1	  0.310306	  1.5455	#_21        
 1987	1	1	   2.72061	 1.91043	#_22        
 1988	1	1	   2.29228	 1.48391	#_23        
 1989	1	1	  0.118654	0.323813	#_24        
 1990	1	1	  0.613271	 2.27603	#_25        
 1991	1	1	  0.310331	0.419592	#_26        
 1992	1	1	 0.0347721	 1.35083	#_27        
 1993	1	1	  0.327076	0.852752	#_28        
 1994	1	1	  0.174406	 0.51674	#_29        
 1995	1	1	  0.754756	0.756735	#_30        
 1996	1	1	 0.0780331	 1.31219	#_31        
 1997	1	1	   1.18936	0.502527	#_32        
 1998	1	1	  0.212831	0.429071	#_33        
 1999	1	1	  0.147721	0.777907	#_34        
 2000	1	1	 0.0923635	 0.21265	#_35        
 2001	1	1	  0.656393	0.460996	#_36        
 2002	1	1	  0.817518	0.510285	#_37        
 2003	1	1	  0.171353	 1.00799	#_38        
 2004	1	1	 0.0427303	 1.77669	#_39        
 2005	1	1	  0.131479	 1.56054	#_40        
 2006	1	1	 0.0743891	 2.06989	#_41        
 2007	1	1	  0.130462	 1.88739	#_42        
 2008	1	1	  0.284307	 1.19815	#_43        
 2009	1	1	   1.49585	 0.26664	#_44        
 2010	1	1	  0.105405	0.356797	#_45        
 2011	1	1	 0.0612436	 1.51772	#_46        
 2012	1	1	0.00235883	 1.76271	#_47        
 2013	1	1	 0.0205518	 1.95832	#_48        
 2014	1	1	 0.0092513	 1.48957	#_49        
 2015	1	1	  0.670839	0.479778	#_50        
 2016	1	1	  0.656914	 0.28581	#_51        
 2017	1	1	 0.0581976	0.336114	#_52        
 2018	1	1	  0.145071	0.310018	#_53        
 2019	1	1	  0.100684	0.378188	#_54        
 2020	1	1	 0.0874491	0.407456	#_55        
 2021	1	1	 0.0139108	  0.3993	#_56        
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
 2016	7	1	 1.41068	0.432947	#_1         
 2017	7	1	0.490555	0.450836	#_2         
 2018	7	1	 1.27344	 0.32038	#_3         
 2019	7	1	0.697701	0.407719	#_4         
 2020	7	1	0.908041	0.453066	#_5         
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
-1	0.001	0	0	1	1	0.001	#_FISHERY
10 #_N_lbins
#_lbin_vector
21 24 27 30 33 36 39 42 45 48 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48
 2011	-1	 1	0	0	98.28	5	10	16	23	19	15	15	10	2	2	#_1         
 2012	-1	-1	0	0	83.16	3	 8	12	21	16	13	13	 9	2	2	#_2         
 2013	 1	 1	0	0	87.36	2	 7	 9	24	18	22	10	 9	3	0	#_3         
 2015	 1	 1	0	0	   42	0	 1	 5	 8	13	 9	 6	 6	1	1	#_4         
 2018	-1	 1	0	0	 46.2	0	 1	 3	 3	 6	19	16	 4	3	0	#_5         
 2019	 1	-1	0	0	 16.8	0	 0	 2	 1	 4	 6	 6	 0	1	0	#_6         
 2020	-1	-1	0	0	11.76	0	 0	 1	 1	 0	 6	 3	 2	1	0	#_7         
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
