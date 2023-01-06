#V3.30
#C data file for PRZO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
2 #_Nsexes
30 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	         0	    0.01	#_1         
 1967	1	1	 0.0113296	     0.5	#_2         
 1968	1	1	 0.0429455	     0.5	#_3         
 1969	1	1	 0.0107506	     0.5	#_4         
 1970	1	1	0.00684345	     0.5	#_5         
 1971	1	1	0.00176895	     0.5	#_6         
 1972	1	1	   0.16521	     0.5	#_7         
 1973	1	1	  0.117242	     0.5	#_8         
 1974	1	1	  0.288946	     0.5	#_9         
 1975	1	1	  0.292045	     0.5	#_10        
 1976	1	1	  0.114033	     0.5	#_11        
 1977	1	1	 0.0615135	     0.5	#_12        
 1978	1	1	 0.0231902	     0.5	#_13        
 1979	1	1	 0.0518875	     0.5	#_14        
 1980	1	1	  0.829003	     0.5	#_15        
 1981	1	1	  0.477295	     0.5	#_16        
 1982	1	1	  0.891175	     0.5	#_17        
 1983	1	1	   1.36239	     0.5	#_18        
 1984	1	1	   1.13592	     0.5	#_19        
 1985	1	1	    1.7365	     0.5	#_20        
 1986	1	1	  0.754002	     0.5	#_21        
 1987	1	1	  0.130118	     0.5	#_22        
 1988	1	1	  0.306731	     0.5	#_23        
 1989	1	1	  0.294054	 0.46734	#_24        
 1990	1	1	  0.265771	     0.5	#_25        
 1991	1	1	 0.0424475	     0.2	#_26        
 1992	1	1	 0.0601895	     0.5	#_27        
 1993	1	1	 0.0503743	     0.5	#_28        
 1994	1	1	  0.264463	     0.2	#_29        
 1995	1	1	  0.191438	     0.5	#_30        
 1996	1	1	  0.213374	     0.5	#_31        
 1997	1	1	  0.104162	     0.5	#_32        
 1998	1	1	 0.0732598	     0.5	#_33        
 1999	1	1	  0.116011	     0.5	#_34        
 2000	1	1	 0.0604107	     0.2	#_35        
 2001	1	1	 0.0512311	     0.5	#_36        
 2002	1	1	 0.0274822	     0.5	#_37        
 2003	1	1	 0.0548991	     0.5	#_38        
 2004	1	1	 0.0289973	     0.5	#_39        
 2005	1	1	  0.181692	     0.5	#_40        
 2006	1	1	 0.0328418	     0.5	#_41        
 2007	1	1	  0.143045	     0.5	#_42        
 2008	1	1	  0.248046	     0.5	#_43        
 2009	1	1	  0.117014	0.329973	#_44        
 2010	1	1	 0.0875211	0.318367	#_45        
 2011	1	1	  0.139938	     0.5	#_46        
 2012	1	1	 0.0481511	     0.5	#_47        
 2013	1	1	 0.0762516	     0.5	#_48        
 2014	1	1	 0.0458079	     0.5	#_49        
 2015	1	1	 0.0505233	     0.5	#_50        
 2016	1	1	  0.254806	     0.2	#_51        
 2017	1	1	  0.283873	     0.2	#_52        
 2018	1	1	  0.115621	0.218618	#_53        
 2019	1	1	  0.103221	0.273842	#_54        
 2020	1	1	 0.0443673	   0.418	#_55        
 2021	1	1	0.00771753	0.453778	#_56        
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
 2016	7	1	0.864366	0.257633	#_1         
 2017	7	1	0.765316	 0.28097	#_2         
 2018	7	1	 0.49539	0.303678	#_3         
 2019	7	1	0.195021	0.541214	#_4         
 2020	7	1	0.241016	0.585558	#_5         
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
44 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
13 #_N_lbins
#_lbin_vector
16 18 20 22 24 26 28 30 32 34 36 38 40 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	f16	f18	f20	f22	f24	f26	f28	f30	f32	f34	f36	f38	f40	m16	m18	m20	m22	m24	m26	m28	m30	m32	m34	m36	m38	m40
 2007	 1	 1	0	0	57	0	0	4	 5	12	26	21	30	13	8	3	5	3	0	0	4	 5	12	26	21	30	13	8	3	5	3	#_1         
 2009	-1	 1	0	0	38	0	0	1	 1	 0	 8	 6	10	 5	8	5	1	1	0	0	1	 1	 0	 8	 6	10	 5	8	5	1	1	#_2         
 2010	 1	-1	0	0	16	0	0	0	 0	 0	 3	 4	 3	 1	4	3	1	0	0	0	0	 0	 0	 3	 4	 3	 1	4	3	1	0	#_3         
 2011	-1	-1	0	0	13	0	0	1	 1	 0	 3	 2	 5	 2	1	1	0	0	0	0	1	 1	 0	 3	 2	 5	 2	1	1	0	0	#_4         
 2012	-1	 1	0	0	62	0	2	2	10	 8	13	11	 9	 9	9	1	2	1	0	2	2	10	 8	13	11	 9	 9	9	1	2	1	#_5         
 2013	 1	-1	0	0	16	0	0	0	 1	 2	 7	 4	 2	 3	1	0	0	0	0	0	0	 1	 2	 7	 4	 2	 3	1	0	0	0	#_6         
 2014	-1	-1	0	0	 6	0	1	0	 1	 0	 0	 1	 1	 0	1	1	1	0	0	1	0	 1	 0	 0	 1	 1	 0	1	1	1	0	#_7         
 2015	-1	 1	0	0	68	0	0	4	11	 7	 9	15	 7	 8	7	7	3	1	0	0	4	11	 7	 9	15	 7	 8	7	7	3	1	#_8         
 2016	-1	-1	0	0	32	0	0	2	 3	 2	 2	13	 3	 3	4	4	2	0	0	0	2	 3	 2	 2	13	 3	 3	4	4	2	0	#_9         
 2017	 1	 1	0	0	61	1	1	3	 6	 9	 9	10	14	 9	7	2	2	0	1	1	3	 6	 9	 9	10	14	 9	7	2	2	0	#_10        
 2018	-1	 1	0	0	38	0	0	4	 1	 3	 3	 8	 6	 4	5	3	5	1	0	0	4	 1	 3	 3	 8	 6	 4	5	3	5	1	#_11        
 2019	 1	-1	0	0	 8	0	0	0	 0	 0	 1	 4	 2	 0	1	0	0	1	0	0	0	 0	 0	 1	 4	 2	 0	1	0	0	1	#_12        
 2020	-1	-1	0	0	 5	0	0	0	 0	 1	 0	 2	 2	 1	0	0	0	0	0	0	0	 0	 1	 0	 2	 2	 1	0	0	0	0	#_13        
-9999	 0	 0	0	0	 0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
