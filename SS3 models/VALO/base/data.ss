#V3.30
#C data file for VALO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
14 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	    0	    0.01	#_1         
 1967	1	1	 44.5	       0	#_2         
 1968	1	1	132.9	       0	#_3         
 1969	1	1	 58.5	       0	#_4         
 1970	1	1	 16.8	       0	#_5         
 1971	1	1	    0	       0	#_6         
 1972	1	1	428.2	       0	#_7         
 1973	1	1	695.8	       0	#_8         
 1974	1	1	624.1	       0	#_9         
 1975	1	1	859.1	       0	#_10        
 1976	1	1	624.1	       0	#_11        
 1977	1	1	350.6	       0	#_12        
 1978	1	1	150.6	       0	#_13        
 1979	1	1	 68.5	       0	#_14        
 1980	1	1	171.5	       0	#_15        
 1981	1	1	325.7	       0	#_16        
 1982	1	1	417.8	       0	#_17        
 1983	1	1	807.8	       0	#_18        
 1984	1	1	599.2	       0	#_19        
 1985	1	1	  640	       0	#_20        
 1986	1	1	634.6	 1.89063	#_21        
 1987	1	1	207.7	 2.13062	#_22        
 1988	1	1	536.1	 1.61295	#_23        
 1989	1	1	463.1	0.485213	#_24        
 1990	1	1	125.6	 1.16515	#_25        
 1991	1	1	221.4	0.309511	#_26        
 1992	1	1	126.1	 1.17562	#_27        
 1993	1	1	142.9	 1.08342	#_28        
 1994	1	1	391.4	0.778551	#_29        
 1995	1	1	349.3	0.860778	#_30        
 1996	1	1	311.6	 1.36605	#_31        
 1997	1	1	638.2	 0.80023	#_32        
 1998	1	1	 63.5	 1.11862	#_33        
 1999	1	1	215.5	 1.21711	#_34        
 2000	1	1	205.5	0.820189	#_35        
 2001	1	1	273.1	0.674015	#_36        
 2002	1	1	551.6	0.593311	#_37        
 2003	1	1	723.9	0.296835	#_38        
 2004	1	1	277.1	 1.73819	#_39        
 2005	1	1	134.7	 2.10166	#_40        
 2006	1	1	117.5	 1.86631	#_41        
 2007	1	1	277.1	 1.70219	#_42        
 2008	1	1	394.6	 1.38035	#_43        
 2009	1	1	558.4	0.264639	#_44        
 2010	1	1	166.9	0.526357	#_45        
 2011	1	1	267.6	 1.68154	#_46        
 2012	1	1	 78.5	 2.25546	#_47        
 2013	1	1	345.2	 1.84283	#_48        
 2014	1	1	292.6	 1.01282	#_49        
 2015	1	1	159.7	0.673991	#_50        
 2016	1	1	   63	0.312823	#_51        
 2017	1	1	 55.3	0.347306	#_52        
 2018	1	1	 64.9	0.183348	#_53        
 2019	1	1	  186	0.110415	#_54        
 2020	1	1	  112	0.242806	#_55        
 2021	1	1	 14.1	0.487315	#_56        
-9999	0	0	    0	       0	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_1
#
#_CPUE_data
#_year	seas	index	obs	se_log
 2016	7	1	 0.105949	  0.4972	#_1         
 2017	7	1	 0.084389	0.755215	#_2         
 2018	7	1	0.0599574	0.968307	#_3         
 2019	7	1	 0.318045	0.417446	#_4         
 2020	7	1	 0.303453	0.542412	#_5         
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
1 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	0.0000001	0	0	0	0	1	#_1
11 #_N_lbins
#_lbin_vector
0 5 10 15 20 25 30 35 40 45 50 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l0	l5	l10	l15	l20	l25	l30	l35	l40	l45	l50
 2011	1	1	0	0	62.16	0	0	0	 1	23	40	 5	 1	3	1	0	#_1         
 2012	1	1	0	0	72.24	0	0	0	 0	 6	17	31	22	8	2	0	#_2         
 2013	1	1	0	0	66.36	0	0	0	 0	 4	20	26	22	4	1	2	#_3         
 2014	1	1	0	0	49.56	0	0	0	 1	11	21	16	 8	1	1	0	#_4         
 2015	1	1	0	0	   84	0	0	0	 1	14	35	22	18	8	2	0	#_5         
 2015	1	2	0	0	36.12	1	2	2	11	14	 3	 4	 3	3	0	0	#_6         
-9999	0	0	0	0	    0	0	0	0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
