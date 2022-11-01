#V3.30
#C data file for CALU
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
-1 #_Nsexes
12 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	         0	    0.01	#_1         
 1967	1	1	 0.0836224	     0.5	#_2         
 1968	1	1	  0.201833	     0.5	#_3         
 1969	1	1	 0.0871626	     0.5	#_4         
 1970	1	1	 0.0188024	     0.5	#_5         
 1971	1	1	0.00111079	     0.5	#_6         
 1972	1	1	  0.714078	     0.5	#_7         
 1973	1	1	  0.666791	     0.5	#_8         
 1974	1	1	   1.00074	     0.5	#_9         
 1975	1	1	   1.06338	     0.5	#_10        
 1976	1	1	  0.575645	     0.5	#_11        
 1977	1	1	   0.39193	     0.5	#_12        
 1978	1	1	  0.132623	     0.5	#_13        
 1979	1	1	  0.150849	     0.5	#_14        
 1980	1	1	  0.323003	     0.5	#_15        
 1981	1	1	  0.530093	     0.5	#_16        
 1982	1	1	  0.509574	     0.5	#_17        
 1983	1	1	   1.71721	     0.5	#_18        
 1984	1	1	   1.20431	     0.5	#_19        
 1985	1	1	   1.23707	     0.5	#_20        
 1986	1	1	  0.690216	     0.5	#_21        
 1987	1	1	  0.409302	     0.5	#_22        
 1988	1	1	  0.954676	     0.5	#_23        
 1989	1	1	   1.41142	0.219248	#_24        
 1990	1	1	   1.04013	0.436343	#_25        
 1991	1	1	  0.608819	     0.2	#_26        
 1992	1	1	  0.246209	     0.5	#_27        
 1993	1	1	  0.186629	     0.5	#_28        
 1994	1	1	  0.759764	0.243462	#_29        
 1995	1	1	    1.8933	0.353295	#_30        
 1996	1	1	   1.11987	     0.5	#_31        
 1997	1	1	   1.57703	0.233877	#_32        
 1998	1	1	  0.855397	 0.35507	#_33        
 1999	1	1	  0.655056	     0.5	#_34        
 2000	1	1	   0.42167	0.355524	#_35        
 2001	1	1	  0.447235	0.260347	#_36        
 2002	1	1	  0.463554	     0.5	#_37        
 2003	1	1	  0.383356	0.273804	#_38        
 2004	1	1	  0.409858	     0.5	#_39        
 2005	1	1	   0.31306	     0.5	#_40        
 2006	1	1	  0.195148	     0.5	#_41        
 2007	1	1	  0.608272	     0.5	#_42        
 2008	1	1	  0.269641	     0.5	#_43        
 2009	1	1	   1.66171	0.341151	#_44        
 2010	1	1	  0.539041	0.296226	#_45        
 2011	1	1	  0.354421	     0.5	#_46        
 2012	1	1	  0.253408	     0.5	#_47        
 2013	1	1	  0.185969	     0.5	#_48        
 2014	1	1	  0.217793	     0.2	#_49        
 2015	1	1	   0.49123	     0.2	#_50        
 2016	1	1	  0.903764	     0.2	#_51        
 2017	1	1	  0.588489	     0.2	#_52        
 2018	1	1	  0.560745	     0.2	#_53        
 2019	1	1	  0.443477	     0.2	#_54        
 2020	1	1	  0.404854	0.336051	#_55        
 2021	1	1	 0.0150229	0.486827	#_56        
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
 2016	7	1	2.10368	0.277431	#_1         
 2017	7	1	1.69011	0.265214	#_2         
 2018	7	1	1.73726	0.279132	#_3         
 2019	7	1	3.19905	0.216929	#_4         
 2020	7	1	1.08715	0.662376	#_5         
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
72 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
11 #_N_lbins
#_lbin_vector
15 20 25 30 35 40 45 50 55 60 65 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65
 2007	 1	 1	0	0	 54.64	1	0	 6	13	14	28	25	17	5	3	0	#_1         
 2009	-1	 1	0	0	105.48	0	0	 2	10	12	15	37	34	9	9	0	#_2         
 2010	 1	-1	0	0	 22.68	0	0	 1	 0	 3	 3	 8	 8	2	2	0	#_3         
 2011	-1	-1	0	0	 31.92	0	0	 0	10	 9	 3	 9	 6	1	0	0	#_4         
 2012	 1	 1	0	0	  79.8	1	6	12	15	 8	12	22	13	6	0	0	#_5         
 2013	 1	 1	0	0	 48.04	2	1	 8	 4	 3	 7	16	11	5	0	1	#_6         
 2015	 1	 1	0	0	 59.64	0	1	 9	 4	 6	 9	21	14	6	0	1	#_7         
 2016	-1	 1	0	0	    63	0	0	 2	 4	 8	20	18	13	4	4	2	#_8         
 2017	-1	-1	0	0	  33.6	0	0	 2	 3	 7	 9	 8	 5	4	2	0	#_9         
 2018	-1	 1	0	0	 63.84	0	0	 3	 2	 6	19	22	13	6	0	5	#_10        
 2019	 1	-1	0	0	 31.08	0	0	 0	 1	 3	11	16	 4	2	0	0	#_11        
 2020	-1	-1	0	0	 11.76	0	0	 1	 0	 2	 3	 0	 3	1	0	4	#_12        
-9999	 0	 0	0	0	     0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
