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
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.01588	     0.5	#_1         
 1967	1	1	0.01588	     0.5	#_2         
 1968	1	1	0.05625	     0.5	#_3         
 1969	1	1	0.01724	     0.5	#_4         
 1970	1	1	0.00635	     0.5	#_5         
 1971	1	1	  0.001	     0.5	#_6         
 1972	1	1	0.16465	     0.5	#_7         
 1973	1	1	0.23042	     0.5	#_8         
 1974	1	1	0.15921	     0.5	#_9         
 1975	1	1	0.21047	     0.5	#_10        
 1976	1	1	0.17236	     0.5	#_11        
 1977	1	1	0.07575	     0.5	#_12        
 1978	1	1	0.03039	     0.5	#_13        
 1979	1	1	 0.0254	     0.5	#_14        
 1980	1	1	0.37648	     0.5	#_15        
 1981	1	1	0.71577	     0.5	#_16        
 1982	1	1	0.91762	     0.5	#_17        
 1983	1	1	1.85202	     0.5	#_18        
 1984	1	1	1.37393	     0.5	#_19        
 1985	1	1	1.46828	     0.5	#_20        
 1986	1	1	0.66905	     0.5	#_21        
 1987	1	1	0.13608	     0.5	#_22        
 1988	1	1	0.35698	     0.5	#_23        
 1989	1	1	0.21455	 0.46734	#_24        
 1990	1	1	 0.1583	     0.5	#_25        
 1991	1	1	0.04445	     0.2	#_26        
 1992	1	1	 0.1261	     0.5	#_27        
 1993	1	1	0.09435	     0.5	#_28        
 1994	1	1	0.29756	     0.2	#_29        
 1995	1	1	0.17554	     0.5	#_30        
 1996	1	1	0.19096	     0.5	#_31        
 1997	1	1	0.31978	     0.5	#_32        
 1998	1	1	  0.171	     0.5	#_33        
 1999	1	1	0.11476	     0.5	#_34        
 2000	1	1	0.05942	     0.2	#_35        
 2001	1	1	0.07711	     0.5	#_36        
 2002	1	1	0.05761	     0.5	#_37        
 2003	1	1	0.05715	     0.5	#_38        
 2004	1	1	0.08573	     0.5	#_39        
 2005	1	1	0.16556	     0.5	#_40        
 2006	1	1	0.06123	     0.5	#_41        
 2007	1	1	0.13063	     0.5	#_42        
 2008	1	1	0.25583	     0.5	#_43        
 2009	1	1	0.09435	0.329973	#_44        
 2010	1	1	0.08573	0.318367	#_45        
 2011	1	1	0.07575	     0.5	#_46        
 2012	1	1	 0.0195	     0.5	#_47        
 2013	1	1	0.07348	     0.5	#_48        
 2014	1	1	0.12701	     0.5	#_49        
 2015	1	1	0.10977	     0.5	#_50        
 2016	1	1	0.20366	     0.2	#_51        
 2017	1	1	0.24494	     0.2	#_52        
 2018	1	1	0.12655	0.218618	#_53        
 2019	1	1	0.07167	0.273842	#_54        
 2020	1	1	0.05035	   0.418	#_55        
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
0	0.0000001	0	0	0	0	1	#_1
13 #_N_lbins
#_lbin_vector
16 18 20 22 24 26 28 30 32 34 36 38 40 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l16	l18	l20	l22	l24	l26	l28	l30	l32	l34	l36	l38	l40	l16m	l18m	l20m	l22m	l24m	l26m	l28m	l30m	l32m	l34m	l36m	l38m	l40m
 2007	1	1	0	0	   48	0	0	4	5	12	26	21	30	13	8	3	5	3	0	0	4	5	12	26	21	30	13	8	3	5	3	#_1         
 2008	1	1	0	0	27.12	0	0	0	0	 2	 5	12	 9	 2	3	3	2	4	0	0	0	0	 2	 5	12	 9	 2	3	3	2	4	#_2         
 2012	1	1	0	0	   42	0	1	2	8	 6	 6	 6	 6	 6	7	0	1	1	0	1	2	8	 6	 6	 6	 6	 6	7	0	1	1	#_3         
 2015	1	1	0	0	 32.4	0	0	2	8	 5	 7	 2	 4	 5	3	3	1	1	0	0	2	8	 5	 7	 2	 4	 5	3	3	1	1	#_4         
 2017	1	1	0	0	 58.8	1	1	3	6	 9	 9	10	13	 9	6	2	1	0	1	1	3	6	 9	 9	10	13	 9	6	2	1	0	#_5         
-9999	0	0	0	0	    0	0	0	0	0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
