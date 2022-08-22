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
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.08618	     0.5	#_1         
 1967	1	1	0.08618	     0.5	#_2         
 1968	1	1	0.30481	     0.5	#_3         
 1969	1	1	0.09435	     0.5	#_4         
 1970	1	1	0.03311	     0.5	#_5         
 1971	1	1	  0.001	     0.5	#_6         
 1972	1	1	0.89131	     0.5	#_7         
 1973	1	1	1.24647	     0.5	#_8         
 1974	1	1	0.86092	     0.5	#_9         
 1975	1	1	1.14033	     0.5	#_10        
 1976	1	1	0.93168	     0.5	#_11        
 1977	1	1	0.41095	     0.5	#_12        
 1978	1	1	0.16465	     0.5	#_13        
 1979	1	1	0.13835	     0.5	#_14        
 1980	1	1	1.05143	     0.5	#_15        
 1981	1	1	1.99762	     0.5	#_16        
 1982	1	1	2.56189	     0.5	#_17        
 1983	1	1	5.17095	     0.5	#_18        
 1984	1	1	3.83557	     0.5	#_19        
 1985	1	1	4.09911	     0.5	#_20        
 1986	1	1	 3.0436	     0.5	#_21        
 1987	1	1	0.99019	     0.5	#_22        
 1988	1	1	1.32086	     0.5	#_23        
 1989	1	1	1.05324	0.250473	#_24        
 1990	1	1	0.55565	0.435616	#_25        
 1991	1	1	1.13806	0.234849	#_26        
 1992	1	1	0.76702	0.357252	#_27        
 1993	1	1	0.96797	0.333495	#_28        
 1994	1	1	1.58712	0.202063	#_29        
 1995	1	1	1.35942	0.336023	#_30        
 1996	1	1	1.97086	0.387366	#_31        
 1997	1	1	 1.5785	0.214793	#_32        
 1998	1	1	 0.2531	0.412477	#_33        
 1999	1	1	0.48761	     0.5	#_34        
 2000	1	1	1.78126	0.462061	#_35        
 2001	1	1	0.99246	0.326622	#_36        
 2002	1	1	1.54403	0.328972	#_37        
 2003	1	1	0.44316	     0.2	#_38        
 2004	1	1	1.14759	     0.5	#_39        
 2005	1	1	0.72756	     0.5	#_40        
 2006	1	1	0.39916	     0.5	#_41        
 2007	1	1	1.30453	     0.5	#_42        
 2008	1	1	2.35187	0.426328	#_43        
 2009	1	1	4.39531	     0.2	#_44        
 2010	1	1	0.77065	0.313912	#_45        
 2011	1	1	1.51454	     0.5	#_46        
 2012	1	1	0.46312	     0.5	#_47        
 2013	1	1	1.88785	     0.5	#_48        
 2014	1	1	2.19493	 0.39786	#_49        
 2015	1	1	2.55282	 0.27296	#_50        
 2016	1	1	 2.9801	     0.2	#_51        
 2017	1	1	1.91144	     0.2	#_52        
 2018	1	1	0.94574	     0.2	#_53        
 2019	1	1	1.24965	     0.2	#_54        
 2020	1	1	1.32993	     0.2	#_55        
 2021	1	1	0.12338	0.293454	#_56        
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
96 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	0.0000001	0	0	0	0	1	#_1
25 #_N_lbins
#_lbin_vector
15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l15	l18	l21	l24	l27	l30	l33	l36	l39	l42	l45	l48	l51	l54	l57	l60	l63	l66	l69	l72	l75	l78	l81	l84	l87
 2004	 1	 1	0	0	  69.2	0	0	0	0	0	1	3	10	10	11	13	 9	 8	 6	 6	 3	 1	 1	0	1	1	0	0	0	0	#_1         
 2005	-1	 1	0	0	  50.4	0	0	0	0	0	0	2	 0	 2	11	 5	 9	 5	 6	 9	 4	 5	 0	0	1	0	0	0	1	0	#_2         
 2006	-1	-1	0	0	  25.2	0	0	0	0	0	0	0	 0	 1	 5	 3	 5	 1	 3	 4	 4	 2	 0	0	1	0	0	0	1	0	#_3         
 2007	 1	 1	0	0	 125.2	0	0	0	0	2	0	4	 6	12	21	21	22	29	19	14	 6	 7	 7	3	3	1	0	1	0	1	#_4         
 2008	 1	 1	0	0	136.16	0	0	0	0	0	0	0	 1	 8	11	15	28	26	24	17	 9	 9	 8	4	9	1	0	1	0	0	#_5         
 2009	 1	 1	0	0	152.04	0	0	0	0	0	0	2	 5	11	16	23	32	25	21	15	 7	 4	 6	3	5	1	3	0	1	1	#_6         
 2011	 1	 1	0	0	 60.48	0	0	1	0	0	1	2	12	12	 4	 6	 8	 7	 6	 7	 2	 2	 1	0	0	1	0	0	0	0	#_7         
 2012	-1	 1	0	0	 60.96	0	0	0	0	0	2	1	 4	12	 5	13	 9	 7	 5	 7	 4	 3	 1	1	0	0	1	0	0	0	#_8         
 2013	-1	-1	0	0	 47.36	0	0	0	0	0	2	0	 2	 8	 4	10	 7	 6	 4	 6	 4	 2	 1	1	0	0	1	0	0	0	#_9         
 2014	 1	 1	0	0	165.12	1	1	0	0	1	3	3	14	21	27	29	23	20	15	11	16	 4	 4	3	1	1	1	0	0	0	#_10        
 2015	 1	 1	0	0	125.48	0	3	2	3	2	2	3	 2	 7	 8	16	24	24	14	 9	13	 8	 4	2	4	0	1	0	0	0	#_11        
 2016	 1	 1	0	0	162.96	1	2	0	0	1	0	2	 3	 6	15	21	22	30	19	21	15	16	10	3	5	0	2	0	0	0	#_12        
 2017	 1	 1	0	0	 83.16	0	0	2	0	0	0	0	 1	 4	10	11	19	11	11	 9	 8	 5	 2	1	2	2	0	0	1	0	#_13        
 2018	 1	 1	0	0	 51.24	0	0	0	0	0	1	0	 3	 0	 1	 4	18	 6	 9	 7	 4	 5	 0	1	0	0	1	0	1	0	#_14        
 2019	 1	 1	0	0	 80.64	0	0	0	2	3	2	1	 1	 4	 7	 9	14	13	12	13	 6	 3	 1	3	1	1	0	0	0	0	#_15        
 2020	 1	 1	0	0	 89.04	0	0	0	0	1	1	2	 3	 4	 8	17	18	17	11	 5	 7	 6	 1	2	2	1	0	0	0	0	#_16        
-9999	 0	 0	0	0	     0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	#_terminator
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
