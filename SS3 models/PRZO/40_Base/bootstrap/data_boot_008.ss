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
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	   0.014552	     0.5	#_2         
 1968	1	1	  0.0524959	     0.5	#_3         
 1969	1	1	 0.00427833	     0.5	#_4         
 1970	1	1	 0.00547685	     0.5	#_5         
 1971	1	1	0.000913894	     0.5	#_6         
 1972	1	1	   0.354541	     0.5	#_7         
 1973	1	1	   0.102967	     0.5	#_8         
 1974	1	1	   0.156502	     0.5	#_9         
 1975	1	1	  0.0757263	     0.5	#_10        
 1976	1	1	  0.0496086	     0.5	#_11        
 1977	1	1	  0.0377053	     0.5	#_12        
 1978	1	1	   0.029865	     0.5	#_13        
 1979	1	1	  0.0306592	     0.5	#_14        
 1980	1	1	   0.429986	     0.5	#_15        
 1981	1	1	   0.538055	     0.5	#_16        
 1982	1	1	   0.479575	     0.5	#_17        
 1983	1	1	    2.12415	     0.5	#_18        
 1984	1	1	    1.48842	     0.5	#_19        
 1985	1	1	   0.765443	     0.5	#_20        
 1986	1	1	    1.18757	  1.8647	#_21        
 1987	1	1	  0.0412425	 2.31925	#_22        
 1988	1	1	   0.206985	 1.83391	#_23        
 1989	1	1	  0.0947521	 0.46734	#_24        
 1990	1	1	   0.060914	 1.01654	#_25        
 1991	1	1	  0.0444232	   0.001	#_26        
 1992	1	1	   0.293181	 1.14011	#_27        
 1993	1	1	  0.0292967	 1.23881	#_28        
 1994	1	1	   0.297487	   0.001	#_29        
 1995	1	1	  0.0904207	 1.26849	#_30        
 1996	1	1	   0.132931	 1.64442	#_31        
 1997	1	1	   0.369908	0.636487	#_32        
 1998	1	1	   0.194279	0.561009	#_33        
 1999	1	1	  0.0107419	 1.44077	#_34        
 2000	1	1	  0.0594502	   0.001	#_35        
 2001	1	1	   0.242478	0.775294	#_36        
 2002	1	1	  0.0602556	  1.5447	#_37        
 2003	1	1	 0.00246042	 1.60741	#_38        
 2004	1	1	  0.0136374	   2.307	#_39        
 2005	1	1	  0.0113925	 2.00279	#_40        
 2006	1	1	 0.00866132	 2.18261	#_41        
 2007	1	1	   0.112749	 2.08633	#_42        
 2008	1	1	 0.00691038	 1.63287	#_43        
 2009	1	1	  0.0985615	0.329973	#_44        
 2010	1	1	   0.123633	0.318367	#_45        
 2011	1	1	  0.0156348	 2.29873	#_46        
 2012	1	1	0.000118741	 2.80447	#_47        
 2013	1	1	 0.00144334	   2.541	#_48        
 2014	1	1	      0.186	 1.93562	#_49        
 2015	1	1	  0.0254544	 1.32974	#_50        
 2016	1	1	    0.28063	0.170606	#_51        
 2017	1	1	   0.267514	0.174223	#_52        
 2018	1	1	   0.165369	0.218618	#_53        
 2019	1	1	  0.0599697	0.273842	#_54        
 2020	1	1	  0.0378697	   0.418	#_55        
 2021	1	1	 0.00456706	0.453778	#_56        
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
 2016	7	1	0.865238	0.257651	#_1         
 2017	7	1	0.765871	0.281029	#_2         
 2018	7	1	0.495486	 0.30382	#_3         
 2019	7	1	0.195278	0.541224	#_4         
 2020	7	1	 0.24163	0.585509	#_5         
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
 2007	 1	 1	0	0	   48	0	0	4	 5	12	26	21	30	13	8	3	5	3	0	0	4	 5	12	26	21	30	13	8	3	5	3	#_1         
 2009	-1	 1	0	0	38.64	0	0	1	 1	 0	 8	 6	10	 5	8	5	1	1	0	0	1	 1	 0	 8	 6	10	 5	8	5	1	1	#_2         
 2010	 1	-1	0	0	15.96	0	0	0	 0	 0	 3	 4	 3	 1	4	3	1	0	0	0	0	 0	 0	 3	 4	 3	 1	4	3	1	0	#_3         
 2011	-1	-1	0	0	13.44	0	0	1	 1	 0	 3	 2	 5	 2	1	1	0	0	0	0	1	 1	 0	 3	 2	 5	 2	1	1	0	0	#_4         
 2012	-1	 1	0	0	64.68	0	2	2	10	 8	13	11	 9	 9	9	1	2	1	0	2	2	10	 8	13	11	 9	 9	9	1	2	1	#_5         
 2013	 1	-1	0	0	 16.8	0	0	0	 1	 2	 7	 4	 2	 3	1	0	0	0	0	0	0	 1	 2	 7	 4	 2	 3	1	0	0	0	#_6         
 2014	-1	-1	0	0	 5.88	0	1	0	 1	 0	 0	 1	 1	 0	1	1	1	0	0	1	0	 1	 0	 0	 1	 1	 0	1	1	1	0	#_7         
 2015	-1	 1	0	0	63.48	0	0	4	11	 7	 9	15	 7	 7	7	7	3	1	0	0	4	11	 7	 9	15	 7	 7	7	7	3	1	#_8         
 2016	-1	-1	0	0	31.08	0	0	2	 3	 2	 2	13	 3	 2	4	4	2	0	0	0	2	 3	 2	 2	13	 3	 2	4	4	2	0	#_9         
 2017	 1	 1	0	0	 58.8	1	1	3	 6	 9	 9	10	13	 9	6	2	1	0	1	1	3	 6	 9	 9	10	13	 9	6	2	1	0	#_10        
 2018	-1	 1	0	0	34.44	0	0	4	 1	 3	 3	 8	 6	 4	5	3	3	1	0	0	4	 1	 3	 3	 8	 6	 4	5	3	3	1	#_11        
 2019	 1	-1	0	0	 7.56	0	0	0	 0	 0	 1	 4	 2	 0	1	0	0	1	0	0	0	 0	 0	 1	 4	 2	 0	1	0	0	1	#_12        
 2020	-1	-1	0	0	 5.04	0	0	0	 0	 1	 0	 2	 2	 1	0	0	0	0	0	0	0	 0	 1	 0	 2	 2	 1	0	0	0	0	#_13        
-9999	 0	 0	0	0	    0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
