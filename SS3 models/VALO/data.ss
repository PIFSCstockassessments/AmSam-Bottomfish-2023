#V3.30
#C data file for VALO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
14 #_Nages
1 #_N_areas
2 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
3	 1	2	0	SURVEY 	#_2
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.0000000	0.01	#_1         
 1967	1	1	0.0444444	0.05	#_2         
 1968	1	1	0.1328798	0.05	#_3         
 1969	1	1	0.0585034	0.05	#_4         
 1970	1	1	0.0167800	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	0.4281179	0.05	#_7         
 1973	1	1	0.6956916	0.05	#_8         
 1974	1	1	0.6240363	0.05	#_9         
 1975	1	1	0.8589569	0.05	#_10        
 1976	1	1	0.6240363	0.05	#_11        
 1977	1	1	0.3505669	0.05	#_12        
 1978	1	1	0.1505669	0.05	#_13        
 1979	1	1	0.0684807	0.05	#_14        
 1980	1	1	0.1714286	0.05	#_15        
 1981	1	1	0.3256236	0.05	#_16        
 1982	1	1	0.4176871	0.05	#_17        
 1983	1	1	0.8077098	0.05	#_18        
 1984	1	1	0.5990930	0.05	#_19        
 1985	1	1	0.6399093	0.05	#_20        
 1986	1	1	0.5891156	0.05	#_21        
 1987	1	1	0.1927438	0.05	#_22        
 1988	1	1	0.5097506	0.05	#_23        
 1989	1	1	0.4371882	0.05	#_24        
 1990	1	1	0.1229025	0.05	#_25        
 1991	1	1	0.2158730	0.05	#_26        
 1992	1	1	0.1215420	0.05	#_27        
 1993	1	1	0.1315193	0.05	#_28        
 1994	1	1	0.3528345	0.05	#_29        
 1995	1	1	0.3378685	0.05	#_30        
 1996	1	1	0.3469388	0.05	#_31        
 1997	1	1	0.7795918	0.05	#_32        
 1998	1	1	0.0752834	0.05	#_33        
 1999	1	1	0.2616780	0.05	#_34        
 2000	1	1	0.2353741	0.05	#_35        
 2001	1	1	0.3002268	0.05	#_36        
 2002	1	1	0.6068027	0.05	#_37        
 2003	1	1	0.7442177	0.05	#_38        
 2004	1	1	0.3079365	0.05	#_39        
 2005	1	1	0.1523810	0.05	#_40        
 2006	1	1	0.1188209	0.05	#_41        
 2007	1	1	0.2820862	0.05	#_42        
 2008	1	1	0.3995465	0.05	#_43        
 2009	1	1	0.5501134	0.05	#_44        
 2010	1	1	0.1691610	0.05	#_45        
 2011	1	1	0.2716553	0.05	#_46        
 2012	1	1	0.0793651	0.05	#_47        
 2013	1	1	0.3487528	0.05	#_48        
 2014	1	1	0.2907029	0.05	#_49        
 2015	1	1	0.1605442	0.05	#_50        
 2016	1	1	0.0630385	0.05	#_51        
 2017	1	1	0.0553288	0.05	#_52        
 2018	1	1	0.0643991	0.05	#_53        
 2019	1	1	0.1854875	0.05	#_54        
 2020	1	1	0.1115646	0.05	#_55        
 2021	1	1	0.0140590	0.05	#_56        
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
0	0.0000001	0	0	0	0	1	#_2
11 #_N_lbins
#_lbin_vector
0 5 10 15 20 25 30 35 40 45 50 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l0	l5	l10	l15	l20	l25	l30	l35	l40	l45	l50
 2011	1	1	0	0	62.16	0	0	0	 1	23	40	 5	 1	3	1	0	#_1         
 2012	1	1	0	0	72.24	0	0	0	 0	 6	17	31	22	8	2	0	#_2         
 2013	1	1	0	0	66.36	0	0	0	 0	 4	20	26	22	4	1	2	#_3         
 2014	1	1	0	0	49.56	0	0	0	 1	11	21	16	 8	1	1	0	#_4         
 2015	1	1	0	0	84.00	0	0	0	 1	14	35	22	18	8	2	0	#_5         
 2015	1	2	0	0	36.12	1	2	2	11	14	 3	 4	 3	3	0	0	#_6         
-9999	0	0	0	0	 0.00	0	0	0	 0	 0	 0	 0	 0	0	0	0	#_terminator
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
