#V3.30
#C data file for CALU
#
1986 #_styr
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
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	 2.3115	     0.5	#_1         
 1986	1	1	 2.3115	     0.5	#_2         
 1987	1	1	0.68583	     0.5	#_3         
 1988	1	1	1.50729	     0.5	#_4         
 1989	1	1	1.24375	0.219248	#_5         
 1990	1	1	0.52843	0.436343	#_6         
 1991	1	1	0.59965	     0.2	#_7         
 1992	1	1	0.34836	     0.5	#_8         
 1993	1	1	0.38646	     0.5	#_9         
 1994	1	1	0.77292	0.243462	#_10        
 1995	1	1	1.29727	0.353295	#_11        
 1996	1	1	1.07728	     0.5	#_12        
 1997	1	1	1.74179	0.233877	#_13        
 1998	1	1	 0.3792	 0.35507	#_14        
 1999	1	1	0.76521	     0.5	#_15        
 2000	1	1	0.43862	0.355524	#_16        
 2001	1	1	0.60418	0.260347	#_17        
 2002	1	1	0.41957	     0.5	#_18        
 2003	1	1	0.50893	0.273804	#_19        
 2004	1	1	0.58196	     0.5	#_20        
 2005	1	1	0.42683	     0.5	#_21        
 2006	1	1	0.16738	     0.5	#_22        
 2007	1	1	0.51709	     0.5	#_23        
 2008	1	1	0.42003	     0.5	#_24        
 2009	1	1	1.66514	0.341151	#_25        
 2010	1	1	0.55474	0.296226	#_26        
 2011	1	1	0.37966	     0.5	#_27        
 2012	1	1	 0.2268	     0.5	#_28        
 2013	1	1	0.43998	     0.5	#_29        
 2014	1	1	0.27442	     0.2	#_30        
 2015	1	1	0.56518	     0.2	#_31        
 2016	1	1	0.70125	     0.2	#_32        
 2017	1	1	 0.6754	     0.2	#_33        
 2018	1	1	0.63276	     0.2	#_34        
 2019	1	1	0.57697	     0.2	#_35        
 2020	1	1	0.33838	0.336051	#_36        
 2021	1	1	0.03674	0.486827	#_37        
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
0	0.0000001	0	0	0	0	1	#_1
11 #_N_lbins
#_lbin_vector
15 20 25 30 35 40 45 50 55 60 65 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65
 2007	1	1	0	0	54.64	1	0	 6	13	14	28	25	17	5	3	0	#_1         
 2008	1	1	0	0	21.16	0	0	 1	 2	 8	14	10	 5	2	1	0	#_2         
 2009	1	1	0	0	50.88	0	0	 1	 0	 0	 9	20	20	6	7	0	#_3         
 2012	1	1	0	0	72.24	1	5	12	15	 7	 9	20	11	6	0	0	#_4         
 2013	1	1	0	0	36.12	0	0	 8	 3	 3	 6	12	 7	4	0	0	#_5         
 2014	1	1	0	0	37.12	1	2	 1	 5	 8	10	 7	 7	3	0	1	#_6         
 2015	1	1	0	0	59.64	0	1	 9	 4	 6	 9	21	14	6	0	1	#_7         
 2017	1	1	0	0	 33.6	0	0	 2	 3	 7	 9	 8	 5	4	2	0	#_8         
-9999	0	0	0	0	    0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
