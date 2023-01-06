#V3.30
#C data file for APRU
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
30 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	         0	    0.01	#_1         
 1967	1	1	 0.0128732	     0.5	#_2         
 1968	1	1	  0.121027	     0.5	#_3         
 1969	1	1	 0.0180742	     0.5	#_4         
 1970	1	1	0.00661509	     0.5	#_5         
 1971	1	1	0.00152616	     0.5	#_6         
 1972	1	1	  0.183705	     0.5	#_7         
 1973	1	1	  0.245956	     0.5	#_8         
 1974	1	1	  0.107669	     0.5	#_9         
 1975	1	1	  0.150271	     0.5	#_10        
 1976	1	1	  0.385208	     0.5	#_11        
 1977	1	1	  0.090177	     0.5	#_12        
 1978	1	1	 0.0351376	     0.5	#_13        
 1979	1	1	 0.0114922	     0.5	#_14        
 1980	1	1	  0.893697	     0.5	#_15        
 1981	1	1	  0.694798	     0.5	#_16        
 1982	1	1	   2.60298	     0.5	#_17        
 1983	1	1	   1.85055	     0.5	#_18        
 1984	1	1	   1.81407	     0.5	#_19        
 1985	1	1	   3.78338	     0.5	#_20        
 1986	1	1	   1.41001	     0.5	#_21        
 1987	1	1	  0.457113	     0.5	#_22        
 1988	1	1	  0.948431	     0.5	#_23        
 1989	1	1	  0.386548	 0.32586	#_24        
 1990	1	1	 0.0256532	     0.5	#_25        
 1991	1	1	  0.120339	0.480854	#_26        
 1992	1	1	  0.451222	     0.5	#_27        
 1993	1	1	  0.113027	     0.5	#_28        
 1994	1	1	  0.879986	0.363779	#_29        
 1995	1	1	  0.554151	     0.5	#_30        
 1996	1	1	   1.73145	     0.5	#_31        
 1997	1	1	   1.81756	0.260358	#_32        
 1998	1	1	  0.432353	     0.5	#_33        
 1999	1	1	  0.519146	     0.5	#_34        
 2000	1	1	  0.317003	     0.5	#_35        
 2001	1	1	   1.07532	0.348732	#_36        
 2002	1	1	   5.04762	     0.5	#_37        
 2003	1	1	  0.321495	0.310752	#_38        
 2004	1	1	  0.143113	     0.5	#_39        
 2005	1	1	  0.297216	     0.5	#_40        
 2006	1	1	  0.123156	     0.5	#_41        
 2007	1	1	   2.08165	     0.5	#_42        
 2008	1	1	   1.24813	     0.5	#_43        
 2009	1	1	     3.774	     0.2	#_44        
 2010	1	1	  0.885584	0.273691	#_45        
 2011	1	1	   1.15115	     0.5	#_46        
 2012	1	1	  0.269147	     0.5	#_47        
 2013	1	1	   1.03736	     0.5	#_48        
 2014	1	1	   1.14271	     0.5	#_49        
 2015	1	1	   1.72858	0.277979	#_50        
 2016	1	1	   1.49645	0.218319	#_51        
 2017	1	1	   1.48458	     0.2	#_52        
 2018	1	1	  0.892797	0.312542	#_53        
 2019	1	1	    1.5479	 0.34192	#_54        
 2020	1	1	  0.291663	0.394157	#_55        
 2021	1	1	  0.021503	0.452443	#_56        
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
 2016	7	1	2.28554	0.329584	#_1         
 2017	7	1	4.49428	 0.26785	#_2         
 2018	7	1	3.66234	 0.33701	#_3         
 2019	7	1	2.76398	0.318631	#_4         
 2020	7	1	2.54184	0.487403	#_5         
 2021	7	1	6.16292	0.645362	#_6         
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
100 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
15 #_N_lbins
#_lbin_vector
20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85	l90
 2007	 1	 1	0	0	137	0	0	 3	 6	38	35	24	29	19	16	12	5	4	1	0	#_1         
 2008	 1	 1	0	0	113	0	2	 4	11	12	13	15	21	 9	 6	10	7	4	2	0	#_2         
 2009	 1	 1	0	0	106	0	0	 0	12	14	16	18	17	15	14	12	5	4	5	0	#_3         
 2011	 1	 1	0	0	 58	1	7	 1	 7	12	11	 4	 9	 3	 6	 3	1	7	1	0	#_4         
 2012	 1	 1	0	0	 88	0	1	11	 8	20	21	14	16	 6	 7	 4	2	0	1	0	#_5         
 2013	 1	 1	0	0	 52	0	2	 1	 2	 8	14	 7	 8	 5	 5	 6	4	0	0	0	#_6         
 2014	 1	 1	0	0	 73	0	0	 1	 0	 5	15	14	13	12	12	 5	8	1	1	1	#_7         
 2015	 1	 1	0	0	 96	3	0	 6	 9	11	17	19	15	15	 9	 7	3	1	4	0	#_8         
 2016	 1	 1	0	0	 76	0	1	 1	 5	25	12	 8	 6	11	11	 7	5	2	2	0	#_9         
 2017	 1	 1	0	0	107	1	2	 4	 6	30	21	13	13	12	 9	 9	4	2	2	1	#_10        
 2018	 1	 1	0	0	 52	0	0	 2	 7	 4	12	 9	 3	 3	 5	 6	4	8	0	0	#_11        
 2019	-1	 1	0	0	 81	0	1	 5	 6	 6	15	14	13	20	 8	10	2	1	0	0	#_12        
 2020	-1	-1	0	0	 19	0	1	 1	 4	 4	 3	 1	 4	 1	 2	 2	0	0	0	0	#_13        
-9999	 0	 0	0	0	  0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
