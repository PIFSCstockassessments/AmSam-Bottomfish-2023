#V3.30
#C data file for ETCA
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
numeric(0) #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.000000000	0.01	#_1         
 1967	1	1	0.362358277	0.05	#_2         
 1968	1	1	1.087528345	0.05	#_3         
 1969	1	1	0.480725624	0.05	#_4         
 1970	1	1	0.139229025	0.05	#_5         
 1971	1	1	0.000000000	0.05	#_6         
 1972	1	1	3.502947846	0.05	#_7         
 1973	1	1	6.039002268	0.05	#_8         
 1974	1	1	5.918820862	0.05	#_9         
 1975	1	1	7.958276644	0.05	#_10        
 1976	1	1	5.802721088	0.05	#_11        
 1977	1	1	3.217687075	0.05	#_12        
 1978	1	1	1.348752834	0.05	#_13        
 1979	1	1	0.573696145	0.05	#_14        
 1980	1	1	1.435374150	0.05	#_15        
 1981	1	1	2.726984127	0.05	#_16        
 1982	1	1	3.496598639	0.05	#_17        
 1983	1	1	6.885714286	0.05	#_18        
 1984	1	1	5.106575964	0.05	#_19        
 1985	1	1	5.458049887	0.05	#_20        
 1986	1	1	5.158730159	0.05	#_21        
 1987	1	1	1.139229025	0.05	#_22        
 1988	1	1	1.861224490	0.05	#_23        
 1989	1	1	0.549659864	0.05	#_24        
 1990	1	1	0.243083900	0.05	#_25        
 1991	1	1	0.502947846	0.05	#_26        
 1992	1	1	0.360090703	0.05	#_27        
 1993	1	1	0.540136054	0.05	#_28        
 1994	1	1	1.526530612	0.05	#_29        
 1995	1	1	1.594104308	0.05	#_30        
 1996	1	1	1.251700680	0.05	#_31        
 1997	1	1	0.920634921	0.05	#_32        
 1998	1	1	1.172335601	0.05	#_33        
 1999	1	1	2.120181406	0.05	#_34        
 2000	1	1	0.485714286	0.05	#_35        
 2001	1	1	2.004081633	0.05	#_36        
 2002	1	1	0.728798186	0.05	#_37        
 2003	1	1	0.456235828	0.05	#_38        
 2004	1	1	0.639002268	0.05	#_39        
 2005	1	1	0.745578231	0.05	#_40        
 2006	1	1	0.148299320	0.05	#_41        
 2007	1	1	0.365532880	0.05	#_42        
 2008	1	1	0.731065760	0.05	#_43        
 2009	1	1	0.726077098	0.05	#_44        
 2010	1	1	0.000453515	0.05	#_45        
 2011	1	1	0.062585034	0.05	#_46        
 2012	1	1	0.062585034	0.05	#_47        
 2013	1	1	0.255782313	0.05	#_48        
 2014	1	1	0.423582766	0.05	#_49        
 2015	1	1	1.009070295	0.05	#_50        
 2016	1	1	0.758276644	0.05	#_51        
 2017	1	1	0.571882086	0.05	#_52        
 2018	1	1	0.767800454	0.05	#_53        
 2019	1	1	0.551020408	0.05	#_54        
 2020	1	1	0.199092971	0.05	#_55        
 2021	1	1	0.029478458	0.05	#_56        
-9999	0	0	0.000000000	0.00	#_terminator
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
5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l5	l10	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85	l90	l95
 2007	1	1	0	0	 7.68	0	0	0	1	 6	 8	10	7	3	1	0	0	6	2	1	2	0	1	0	#_1         
 2008	1	1	0	0	52.92	0	0	0	1	 4	14	18	5	4	2	2	0	3	3	1	4	0	1	1	#_2         
 2012	1	1	0	0	37.80	0	0	0	4	 5	15	 7	4	0	1	0	4	3	0	0	2	0	0	0	#_3         
 2015	1	1	0	0	60.48	1	0	0	5	11	16	10	5	1	3	5	3	2	2	3	0	3	0	2	#_4         
 2016	1	1	0	0	36.12	0	0	0	2	 4	 9	 7	3	3	0	4	0	0	5	3	2	0	0	1	#_5         
 2017	1	1	0	0	35.28	0	0	0	2	 9	11	 9	6	0	0	1	1	0	1	1	1	0	0	0	#_6         
-9999	0	0	0	0	 0.00	0	0	0	0	 0	 0	 0	0	0	0	0	0	0	0	0	0	0	0	0	#_terminator
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
