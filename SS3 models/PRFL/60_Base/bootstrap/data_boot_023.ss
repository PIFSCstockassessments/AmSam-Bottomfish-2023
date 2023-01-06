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
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	  0.0423424	     0.5	#_2         
 1968	1	1	   0.168097	     0.5	#_3         
 1969	1	1	  0.0612119	     0.5	#_4         
 1970	1	1	 0.00449845	     0.5	#_5         
 1971	1	1	0.000852661	     0.5	#_6         
 1972	1	1	   0.379081	     0.5	#_7         
 1973	1	1	   0.493159	     0.5	#_8         
 1974	1	1	   0.141188	     0.5	#_9         
 1975	1	1	   0.674632	     0.5	#_10        
 1976	1	1	   0.380578	     0.5	#_11        
 1977	1	1	   0.147712	     0.5	#_12        
 1978	1	1	   0.108123	     0.5	#_13        
 1979	1	1	  0.0746743	     0.5	#_14        
 1980	1	1	    0.62953	     0.5	#_15        
 1981	1	1	   0.796525	     0.5	#_16        
 1982	1	1	    0.69229	     0.5	#_17        
 1983	1	1	    2.18546	     0.5	#_18        
 1984	1	1	    1.66365	     0.5	#_19        
 1985	1	1	   0.560255	     0.5	#_20        
 1986	1	1	    1.00501	     0.5	#_21        
 1987	1	1	   0.238478	     0.5	#_22        
 1988	1	1	   0.257527	     0.5	#_23        
 1989	1	1	   0.168324	0.323813	#_24        
 1990	1	1	  0.0065073	     0.5	#_25        
 1991	1	1	   0.352971	0.419592	#_26        
 1992	1	1	  0.0632624	     0.5	#_27        
 1993	1	1	   0.145531	     0.5	#_28        
 1994	1	1	   0.215623	     0.5	#_29        
 1995	1	1	   0.669588	     0.5	#_30        
 1996	1	1	    0.14376	     0.5	#_31        
 1997	1	1	   0.523137	     0.5	#_32        
 1998	1	1	   0.119944	0.429071	#_33        
 1999	1	1	    0.16124	     0.5	#_34        
 2000	1	1	  0.0870644	 0.21265	#_35        
 2001	1	1	   0.980749	0.460996	#_36        
 2002	1	1	   0.575596	     0.5	#_37        
 2003	1	1	   0.181078	     0.5	#_38        
 2004	1	1	   0.499321	     0.5	#_39        
 2005	1	1	   0.177111	     0.5	#_40        
 2006	1	1	   0.191518	     0.5	#_41        
 2007	1	1	   0.109789	     0.5	#_42        
 2008	1	1	   0.150609	     0.5	#_43        
 2009	1	1	    1.62012	 0.26664	#_44        
 2010	1	1	  0.0999857	0.356797	#_45        
 2011	1	1	   0.484414	     0.5	#_46        
 2012	1	1	   0.261347	     0.5	#_47        
 2013	1	1	   0.229484	     0.5	#_48        
 2014	1	1	   0.106468	     0.5	#_49        
 2015	1	1	   0.210528	0.479431	#_50        
 2016	1	1	   0.641439	 0.28581	#_51        
 2017	1	1	  0.0518221	0.336114	#_52        
 2018	1	1	   0.138458	0.310018	#_53        
 2019	1	1	  0.0795145	0.378188	#_54        
 2020	1	1	  0.0976166	0.407456	#_55        
 2021	1	1	 0.00640617	  0.3993	#_56        
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
 2016	7	1	 1.41011	0.432958	#_1         
 2017	7	1	0.490532	0.450902	#_2         
 2018	7	1	 1.27304	0.320396	#_3         
 2019	7	1	0.697095	0.407751	#_4         
 2020	7	1	0.907046	 0.45313	#_5         
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
 2011	-1	 1	0	0	94	5	10	16	23	19	15	15	10	2	2	#_1         
 2012	-1	-1	0	0	79	3	 8	12	21	16	13	13	 9	2	2	#_2         
 2013	 1	 1	0	0	83	2	 7	 9	24	18	22	10	 9	3	0	#_3         
 2018	-1	 1	0	0	52	0	 1	 3	 3	 7	20	24	 5	3	0	#_4         
 2019	 1	-1	0	0	16	0	 0	 2	 1	 4	 6	 6	 0	1	0	#_5         
 2020	-1	-1	0	0	12	0	 0	 1	 1	 0	 6	 3	 2	1	0	#_6         
-9999	 0	 0	0	0	 0	0	 0	 0	 0	 0	 0	 0	 0	0	0	#_terminator
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
