#V3.30
#C data file for APVI
#
1967 #_styr
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
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	   0.113419	     0.5	#_2         
 1968	1	1	   0.401664	     0.5	#_3         
 1969	1	1	  0.0803937	     0.5	#_4         
 1970	1	1	  0.0660865	     0.5	#_5         
 1971	1	1	0.000956642	     0.5	#_6         
 1972	1	1	    1.37053	     0.5	#_7         
 1973	1	1	     1.2394	     0.5	#_8         
 1974	1	1	   0.636642	     0.5	#_9         
 1975	1	1	    1.94741	     0.5	#_10        
 1976	1	1	   0.766344	     0.5	#_11        
 1977	1	1	   0.329326	     0.5	#_12        
 1978	1	1	   0.146884	     0.5	#_13        
 1979	1	1	   0.425382	     0.5	#_14        
 1980	1	1	   0.538791	     0.5	#_15        
 1981	1	1	      1.574	     0.5	#_16        
 1982	1	1	    2.18676	     0.5	#_17        
 1983	1	1	    3.26508	     0.5	#_18        
 1984	1	1	    6.76473	     0.5	#_19        
 1985	1	1	    9.65597	     0.5	#_20        
 1986	1	1	    3.73774	0.958972	#_21        
 1987	1	1	   0.165902	 1.27453	#_22        
 1988	1	1	   0.192632	  1.0556	#_23        
 1989	1	1	    1.06441	0.250473	#_24        
 1990	1	1	   0.423205	0.435616	#_25        
 1991	1	1	   0.581976	0.234849	#_26        
 1992	1	1	   0.793201	0.357252	#_27        
 1993	1	1	    1.00192	0.333495	#_28        
 1994	1	1	    1.09084	0.202063	#_29        
 1995	1	1	    1.62459	0.336023	#_30        
 1996	1	1	    3.49429	0.387366	#_31        
 1997	1	1	    1.75511	0.214793	#_32        
 1998	1	1	   0.108598	0.412477	#_33        
 1999	1	1	   0.176494	 0.65065	#_34        
 2000	1	1	   0.959134	0.462061	#_35        
 2001	1	1	   0.947889	0.326622	#_36        
 2002	1	1	    1.16092	0.328972	#_37        
 2003	1	1	    0.37298	0.168046	#_38        
 2004	1	1	   0.477807	0.875579	#_39        
 2005	1	1	   0.138571	 1.15885	#_40        
 2006	1	1	   0.196941	  1.1507	#_41        
 2007	1	1	   0.834233	0.758785	#_42        
 2008	1	1	    4.32895	0.426328	#_43        
 2009	1	1	    4.71037	0.144623	#_44        
 2010	1	1	   0.968124	0.313912	#_45        
 2011	1	1	    1.29225	0.647973	#_46        
 2012	1	1	   0.137465	 1.31425	#_47        
 2013	1	1	   0.555774	0.825895	#_48        
 2014	1	1	    1.03298	 0.39786	#_49        
 2015	1	1	    1.29729	 0.27296	#_50        
 2016	1	1	    3.33394	0.161684	#_51        
 2017	1	1	    1.51592	0.171379	#_52        
 2018	1	1	    1.00474	0.160734	#_53        
 2019	1	1	    1.06793	0.162174	#_54        
 2020	1	1	    1.33515	0.152501	#_55        
 2021	1	1	   0.149863	0.293454	#_56        
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
 2016	7	1	9.81973	     0.2	#_1         
 2017	7	1	7.16519	     0.2	#_2         
 2018	7	1	6.45365	     0.2	#_3         
 2019	7	1	8.35764	     0.2	#_4         
 2020	7	1	9.43102	     0.2	#_5         
 2021	7	1	8.88932	0.348863	#_6         
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
-1	0.001	0	0	1	1	0.001	#_FISHERY
15 #_N_lbins
#_lbin_vector
15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85
 2004	-1	 1	0	0	 119.6	0	0	0	4	17	29	31	26	19	11	 3	 2	1	0	1	#_1         
 2005	 1	-1	0	0	  25.2	0	0	0	2	 1	 6	 6	 6	 6	 3	 0	 0	0	0	0	#_2         
 2006	-1	-1	0	0	  25.2	0	0	0	0	 1	 5	 7	 5	 4	 5	 1	 1	0	0	1	#_3         
 2007	 1	 1	0	0	 125.2	0	0	2	2	11	30	41	38	26	12	10	 4	1	1	1	#_4         
 2008	 1	 1	0	0	136.16	0	0	0	0	 4	16	30	45	35	17	10	12	1	1	0	#_5         
 2009	 1	 1	0	0	152.04	0	0	0	2	 8	24	46	42	28	11	 7	 7	3	1	2	#_6         
 2010	-1	 1	0	0	103.64	0	1	0	2	22	22	24	26	12	 9	 3	 1	2	1	0	#_7         
 2011	 1	-1	0	0	 60.48	0	1	0	2	17	12	12	12	10	 4	 1	 0	1	0	0	#_8         
 2012	-1	-1	0	0	  13.6	0	0	0	0	 3	 5	 5	 2	 1	 0	 1	 0	0	0	0	#_9         
 2013	 1	 1	0	0	 47.36	0	0	0	2	 4	10	13	11	 9	 6	 2	 0	1	0	0	#_10        
 2014	 1	 1	0	0	165.12	1	1	1	5	20	43	44	35	19	18	 7	 3	2	0	0	#_11        
 2015	 1	 1	0	0	125.48	2	6	2	4	 5	13	33	34	20	20	 6	 5	0	1	0	#_12        
 2016	 1	 1	0	0	162.96	1	2	1	1	 4	21	37	43	33	27	15	 7	2	0	0	#_13        
 2017	 1	 1	0	0	 83.16	0	2	0	0	 1	14	26	20	15	10	 5	 3	2	1	0	#_14        
 2018	 1	 1	0	0	 51.24	0	0	0	1	 3	 1	14	17	13	 8	 1	 1	0	2	0	#_15        
 2019	 1	 1	0	0	 80.64	0	0	5	3	 2	10	20	20	21	 9	 2	 3	1	0	0	#_16        
 2020	 1	 1	0	0	 89.04	0	0	1	2	 6	10	30	24	14	11	 3	 4	1	0	0	#_17        
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
