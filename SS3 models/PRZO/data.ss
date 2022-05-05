#V3.30
#C data file for PRZO
#
1967 #_styr
2020 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
30 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.0000000	0.01	#_1         
 1967	1	1	0.0634921	0.05	#_2         
 1968	1	1	0.1904762	0.05	#_3         
 1969	1	1	0.0843537	0.05	#_4         
 1970	1	1	0.0244898	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	0.6140590	0.05	#_7         
 1973	1	1	1.0412698	0.05	#_8         
 1974	1	1	0.9954649	0.05	#_9         
 1975	1	1	1.3473923	0.05	#_10        
 1976	1	1	0.9814059	0.05	#_11        
 1977	1	1	0.5464853	0.05	#_12        
 1978	1	1	0.2303855	0.05	#_13        
 1979	1	1	0.1002268	0.05	#_14        
 1980	1	1	0.2503401	0.05	#_15        
 1981	1	1	0.4748299	0.05	#_16        
 1982	1	1	0.6090703	0.05	#_17        
 1983	1	1	1.2049887	0.05	#_18        
 1984	1	1	0.8934240	0.05	#_19        
 1985	1	1	0.9555556	0.05	#_20        
 1986	1	1	1.1700680	0.05	#_21        
 1987	1	1	0.3020408	0.05	#_22        
 1988	1	1	0.4811791	0.05	#_23        
 1989	1	1	0.2113379	0.05	#_24        
 1990	1	1	0.1623583	0.05	#_25        
 1991	1	1	0.0444444	0.05	#_26        
 1992	1	1	0.1287982	0.05	#_27        
 1993	1	1	0.0961451	0.05	#_28        
 1994	1	1	0.2975057	0.05	#_29        
 1995	1	1	0.1832200	0.05	#_30        
 1996	1	1	0.1945578	0.05	#_31        
 1997	1	1	0.3201814	0.05	#_32        
 1998	1	1	0.1718821	0.05	#_33        
 1999	1	1	0.1174603	0.05	#_34        
 2000	1	1	0.0594104	0.05	#_35        
 2001	1	1	0.0775510	0.05	#_36        
 2002	1	1	0.0585034	0.05	#_37        
 2003	1	1	0.0589569	0.05	#_38        
 2004	1	1	0.0961451	0.05	#_39        
 2005	1	1	0.1736961	0.05	#_40        
 2006	1	1	0.0612245	0.05	#_41        
 2007	1	1	0.1310658	0.05	#_42        
 2008	1	1	0.2557823	0.05	#_43        
 2009	1	1	0.0897959	0.05	#_44        
 2010	1	1	0.0816327	0.05	#_45        
 2011	1	1	0.0725624	0.05	#_46        
 2012	1	1	0.0185941	0.05	#_47        
 2013	1	1	0.0712018	0.05	#_48        
 2014	1	1	0.1210884	0.05	#_49        
 2015	1	1	0.1047619	0.05	#_50        
 2016	1	1	0.1936508	0.05	#_51        
 2017	1	1	0.2335601	0.05	#_52        
 2018	1	1	0.1206349	0.05	#_53        
 2019	1	1	0.0684807	0.05	#_54        
 2020	1	1	0.0480726	0.05	#_55        
-9999	0	0	0.0000000	0.00	#_terminator
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
10 #_N_lbins
#_lbin_vector
0 5 10 15 20 25 30 35 40 45 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l0	l5	l10	l15	l20	l25	l30	l35	l40	l45
 2007	1	1	0	0	50.68	0	0	0	0	14	54	50	9	7	0	#_1         
 2012	1	1	0	0	42.84	0	0	1	1	14	14	14	6	1	0	#_2         
 2015	1	1	0	0	33.60	0	0	0	0	12	10	10	5	3	0	#_3         
 2016	1	1	0	0	33.60	0	0	0	0	 6	16	 8	7	2	1	#_4         
 2017	1	1	0	0	59.64	1	0	0	2	13	24	27	4	0	0	#_5         
-9999	0	0	0	0	 0.00	0	0	0	0	 0	 0	 0	0	0	0	#_terminator
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
