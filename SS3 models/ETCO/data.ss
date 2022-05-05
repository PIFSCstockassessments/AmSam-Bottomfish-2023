#V3.30
#C data file for ETCO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
55 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.0000000	0.01	#_1         
 1967	1	1	0.5052154	0.05	#_2         
 1968	1	1	1.5151927	0.05	#_3         
 1969	1	1	0.6698413	0.05	#_4         
 1970	1	1	0.1936508	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	4.8807256	0.05	#_7         
 1973	1	1	7.3206349	0.05	#_8         
 1974	1	1	5.6934240	0.05	#_9         
 1975	1	1	8.1705215	0.05	#_10        
 1976	1	1	5.8961451	0.05	#_11        
 1977	1	1	3.3891156	0.05	#_12        
 1978	1	1	1.5142857	0.05	#_13        
 1979	1	1	0.7591837	0.05	#_14        
 1980	1	1	1.8979592	0.05	#_15        
 1981	1	1	3.6058957	0.05	#_16        
 1982	1	1	4.6235828	0.05	#_17        
 1983	1	1	9.0920635	0.05	#_18        
 1984	1	1	6.7437642	0.05	#_19        
 1985	1	1	7.2068027	0.05	#_20        
 1986	1	1	4.2294785	0.05	#_21        
 1987	1	1	0.8970522	0.05	#_22        
 1988	1	1	1.4444444	0.05	#_23        
 1989	1	1	0.6657596	0.05	#_24        
 1990	1	1	0.1460317	0.05	#_25        
 1991	1	1	0.3138322	0.05	#_26        
 1992	1	1	0.0154195	0.05	#_27        
 1993	1	1	0.8376417	0.05	#_28        
 1994	1	1	1.1587302	0.05	#_29        
 1995	1	1	1.3868481	0.05	#_30        
 1996	1	1	1.2417234	0.05	#_31        
 1997	1	1	1.9551020	0.05	#_32        
 1998	1	1	2.2730159	0.05	#_33        
 1999	1	1	0.9759637	0.05	#_34        
 2000	1	1	0.3337868	0.05	#_35        
 2001	1	1	2.0952381	0.05	#_36        
 2002	1	1	0.6766440	0.05	#_37        
 2003	1	1	0.4662132	0.05	#_38        
 2004	1	1	0.7569161	0.05	#_39        
 2005	1	1	1.3424036	0.05	#_40        
 2006	1	1	0.2176871	0.05	#_41        
 2007	1	1	1.3609977	0.05	#_42        
 2008	1	1	2.0408163	0.05	#_43        
 2009	1	1	3.2435374	0.05	#_44        
 2010	1	1	0.8258503	0.05	#_45        
 2011	1	1	2.4480726	0.05	#_46        
 2012	1	1	0.3959184	0.05	#_47        
 2013	1	1	1.2684807	0.05	#_48        
 2014	1	1	2.3020408	0.05	#_49        
 2015	1	1	1.9188209	0.05	#_50        
 2016	1	1	2.3977324	0.05	#_51        
 2017	1	1	1.5111111	0.05	#_52        
 2018	1	1	1.5165533	0.05	#_53        
 2019	1	1	0.6222222	0.05	#_54        
 2020	1	1	0.6321995	0.05	#_55        
 2021	1	1	0.1551020	0.05	#_56        
-9999	0	0	0.0000000	0.00	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#
#_CPUE_data
-9999 1 1 1 1 # terminator
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
1 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	0.0000001	0	0	0	0	1	#_1
19 #_N_lbins
#_lbin_vector
20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85	l90	l95	l100	l105	l110
 2007	1	1	0	0	 66.52	0	1	1	 3	10	33	29	25	24	14	18	13	10	1	0	0	0	0	0	#_1         
 2008	1	1	0	0	 78.12	0	0	3	 6	 5	 6	 9	 8	12	10	 9	13	10	1	0	1	0	0	0	#_2         
 2009	1	1	0	0	 87.36	0	2	4	 2	 2	 5	14	10	13	10	15	15	 7	3	2	0	0	0	0	#_3         
 2011	1	1	0	0	 61.32	2	2	3	18	 3	 4	 4	 2	 5	 6	 2	10	 9	1	0	1	0	0	1	#_4         
 2012	1	1	0	0	 51.24	0	1	8	 0	 4	 2	 5	 7	 9	 5	 9	 8	 3	0	0	0	0	0	0	#_5         
 2013	1	1	0	0	 50.40	2	0	0	 6	 2	 8	12	 7	 3	 8	 3	 4	 1	4	0	0	0	0	0	#_6         
 2014	1	1	0	0	108.36	3	2	5	 7	 4	 3	 5	16	16	15	16	18	 9	7	2	1	0	0	0	#_7         
 2015	1	1	0	0	 64.68	1	0	0	 1	 5	 5	 2	 9	 8	 8	 9	16	 8	3	0	2	0	0	0	#_8         
 2016	1	1	0	0	 57.96	1	2	4	 0	 0	 0	 2	 5	 8	 8	10	18	 8	1	1	1	0	0	0	#_9         
 2017	1	1	0	0	 37.80	0	0	0	 0	 1	 1	 3	 6	11	 3	 8	 5	 5	2	0	0	0	0	0	#_10        
 2018	1	1	0	0	 52.08	1	5	2	 2	 3	 4	 3	 7	10	 6	 9	 7	 3	0	0	0	0	0	0	#_11        
-9999	0	0	0	0	  0.00	0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	#_terminator
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
