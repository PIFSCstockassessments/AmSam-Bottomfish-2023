#V3.30
#C data file for PRFL
#
1967 #_styr
2020 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
28 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.0000000	0.01	#_1         
 1967	1	1	0.0780045	0.05	#_2         
 1968	1	1	0.2335601	0.05	#_3         
 1969	1	1	0.1034014	0.05	#_4         
 1970	1	1	0.0299320	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	0.7519274	0.05	#_7         
 1973	1	1	1.0997732	0.05	#_8         
 1974	1	1	0.8117914	0.05	#_9         
 1975	1	1	1.1841270	0.05	#_10        
 1976	1	1	0.8526077	0.05	#_11        
 1977	1	1	0.4943311	0.05	#_12        
 1978	1	1	0.2240363	0.05	#_13        
 1979	1	1	0.1160998	0.05	#_14        
 1980	1	1	0.2897959	0.05	#_15        
 1981	1	1	0.5505669	0.05	#_16        
 1982	1	1	0.7061224	0.05	#_17        
 1983	1	1	1.4163265	0.05	#_18        
 1984	1	1	1.0507937	0.05	#_19        
 1985	1	1	1.1229025	0.05	#_20        
 1986	1	1	1.0848073	0.05	#_21        
 1987	1	1	0.2984127	0.05	#_22        
 1988	1	1	0.6403628	0.05	#_23        
 1989	1	1	0.1356009	0.05	#_24        
 1990	1	1	0.0145125	0.05	#_25        
 1991	1	1	0.2757370	0.05	#_26        
 1992	1	1	0.0916100	0.05	#_27        
 1993	1	1	0.2036281	0.05	#_28        
 1994	1	1	0.4807256	0.05	#_29        
 1995	1	1	0.4467120	0.05	#_30        
 1996	1	1	0.3433107	0.05	#_31        
 1997	1	1	0.9886621	0.05	#_32        
 1998	1	1	0.2530612	0.05	#_33        
 1999	1	1	0.3573696	0.05	#_34        
 2000	1	1	0.0929705	0.05	#_35        
 2001	1	1	1.2403628	0.05	#_36        
 2002	1	1	0.7346939	0.05	#_37        
 2003	1	1	0.1609977	0.05	#_38        
 2004	1	1	0.2539683	0.05	#_39        
 2005	1	1	0.3782313	0.05	#_40        
 2006	1	1	0.0780045	0.05	#_41        
 2007	1	1	0.1954649	0.05	#_42        
 2008	1	1	0.5369615	0.05	#_43        
 2009	1	1	1.2408163	0.05	#_44        
 2010	1	1	0.1628118	0.05	#_45        
 2011	1	1	0.3551020	0.05	#_46        
 2012	1	1	0.2167800	0.05	#_47        
 2013	1	1	0.2752834	0.05	#_48        
 2014	1	1	0.2911565	0.05	#_49        
 2015	1	1	0.5541950	0.05	#_50        
 2016	1	1	0.3324263	0.05	#_51        
 2017	1	1	0.0925170	0.05	#_52        
 2018	1	1	0.1605442	0.05	#_53        
 2019	1	1	0.1147392	0.05	#_54        
 2020	1	1	0.0752834	0.05	#_55        
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
8 #_N_lbins
#_lbin_vector
20 25 30 35 40 45 50 55 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l20	l25	l30	l35	l40	l45	l50	l55
 2012	1	1	0	0	84.84	4	19	33	22	17	4	2	0	#_1         
 2013	1	1	0	0	89.88	3	15	38	30	15	3	1	2	#_2         
 2015	1	1	0	0	42.84	1	 5	16	16	10	2	1	0	#_3         
-9999	0	0	0	0	 0.00	0	 0	 0	 0	 0	0	0	0	#_terminator
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
