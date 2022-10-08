#V3.30
#C data file for VALO
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
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	  0.0132208	     0.5	#_2         
 1968	1	1	  0.0255726	     0.5	#_3         
 1969	1	1	  0.0102631	     0.5	#_4         
 1970	1	1	 0.00376515	     0.5	#_5         
 1971	1	1	0.000459855	     0.5	#_6         
 1972	1	1	  0.0771224	     0.5	#_7         
 1973	1	1	   0.238419	     0.5	#_8         
 1974	1	1	   0.124324	     0.5	#_9         
 1975	1	1	   0.111219	     0.5	#_10        
 1976	1	1	   0.168842	     0.5	#_11        
 1977	1	1	   0.116435	     0.5	#_12        
 1978	1	1	  0.0109086	     0.5	#_13        
 1979	1	1	  0.0132218	     0.5	#_14        
 1980	1	1	   0.111751	     0.5	#_15        
 1981	1	1	   0.306861	     0.5	#_16        
 1982	1	1	   0.583856	     0.5	#_17        
 1983	1	1	     1.3201	     0.5	#_18        
 1984	1	1	    1.22793	     0.5	#_19        
 1985	1	1	   0.442718	     0.5	#_20        
 1986	1	1	  0.0253982	 1.89066	#_21        
 1987	1	1	  0.0165015	 2.13046	#_22        
 1988	1	1	  0.0997573	 1.61281	#_23        
 1989	1	1	   0.395872	0.485919	#_24        
 1990	1	1	  0.0351477	 1.16375	#_25        
 1991	1	1	   0.223036	0.308736	#_26        
 1992	1	1	   0.036156	 1.17621	#_27        
 1993	1	1	 0.00609285	 1.08471	#_28        
 1994	1	1	    3.09367	0.777986	#_29        
 1995	1	1	   0.392414	0.860831	#_30        
 1996	1	1	  0.0195225	 1.36575	#_31        
 1997	1	1	   0.725198	0.800719	#_32        
 1998	1	1	  0.0303533	 1.11671	#_33        
 1999	1	1	  0.0644577	 1.21675	#_34        
 2000	1	1	   0.190033	0.819357	#_35        
 2001	1	1	   0.060766	0.673833	#_36        
 2002	1	1	   0.334757	 0.59292	#_37        
 2003	1	1	   0.748846	0.297211	#_38        
 2004	1	1	   0.033338	 1.73802	#_39        
 2005	1	1	 0.00155953	 2.10174	#_40        
 2006	1	1	 0.00494611	 1.86632	#_41        
 2007	1	1	  0.0408224	 1.70221	#_42        
 2008	1	1	  0.0719741	 1.38037	#_43        
 2009	1	1	   0.445292	0.263973	#_44        
 2010	1	1	   0.130544	0.524839	#_45        
 2011	1	1	  0.0258369	 1.68139	#_46        
 2012	1	1	  0.0106298	 2.25571	#_47        
 2013	1	1	  0.0448717	 1.84286	#_48        
 2014	1	1	  0.0647123	 1.01224	#_49        
 2015	1	1	   0.133388	0.673679	#_50        
 2016	1	1	   0.103839	0.309637	#_51        
 2017	1	1	  0.0575081	0.350369	#_52        
 2018	1	1	  0.0867554	0.183459	#_53        
 2019	1	1	   0.164709	0.112564	#_54        
 2020	1	1	   0.165253	0.246135	#_55        
 2021	1	1	  0.0095534	0.470573	#_56        
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
 2016	7	1	0.0553378	0.650131	#_1         
 2017	7	1	0.0754762	0.795754	#_2         
 2018	7	1	0.0373757	 1.01432	#_3         
 2019	7	1	 0.187959	0.549405	#_4         
 2020	7	1	 0.189128	0.618714	#_5         
-9999	0	0	        0	       0	#_terminator
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
57 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
13 #_N_lbins
#_lbin_vector
15 18 21 24 27 30 33 36 39 42 45 48 51 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	f15	f18	f21	f24	f27	f30	f33	f36	f39	f42	f45	f48	f51	m15	m18	m21	m24	m27	m30	m33	m36	m39	m42	m45	m48	m51
 2011	 1	 1	0	0	62.16	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	#_1         
 2012	 1	 1	0	0	72.24	0	0	 5	 7	11	18	21	11	9	2	2	0	0	0	0	 5	 7	11	18	21	11	9	2	2	0	0	#_2         
 2013	 1	 1	0	0	66.36	0	0	 1	10	13	13	18	14	5	2	1	2	0	0	0	 1	10	13	13	18	14	5	2	1	2	0	#_3         
 2014	 1	 1	0	0	49.56	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	#_4         
 2015	 1	 1	0	0	   84	0	4	 8	19	19	13	12	15	4	4	1	1	0	0	4	 8	19	19	13	12	15	4	4	1	1	0	#_5         
 2016	-1	 1	0	0	34.44	0	0	 2	 3	 9	 8	 6	 5	1	2	2	3	0	0	0	 2	 3	 9	 8	 6	 5	1	2	2	3	0	#_6         
 2017	 1	-1	0	0	 5.04	0	0	 0	 0	 1	 2	 0	 1	1	0	0	1	0	0	0	 0	 0	 1	 2	 0	 1	1	0	0	1	0	#_7         
 2018	 1	-1	0	0	 2.52	0	0	 0	 0	 0	 0	 2	 1	0	0	0	0	0	0	0	 0	 0	 0	 0	 2	 1	0	0	0	0	0	#_8         
 2019	 1	-1	0	0	  8.4	0	0	 0	 1	 2	 2	 1	 1	0	1	1	1	0	0	0	 0	 1	 2	 2	 1	 1	0	1	1	1	0	#_9         
 2020	-1	-1	0	0	 9.24	0	0	 1	 1	 3	 1	 3	 0	0	0	1	1	0	0	0	 1	 1	 3	 1	 3	 0	0	0	1	1	0	#_10        
-9999	 0	 0	0	0	    0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	#_terminator
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
