#V3.30
#C data file for CALU
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
1 #_Nsexes
11 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	need_catch_mult	fleetname
1	-1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.0000000	0.01	#_1         
 1967	1	1	0.0671202	0.05	#_2         
 1968	1	1	0.2009070	0.05	#_3         
 1969	1	1	0.0888889	0.05	#_4         
 1970	1	1	0.0258503	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	0.6462585	0.05	#_7         
 1973	1	1	1.2176871	0.05	#_8         
 1974	1	1	1.3337868	0.05	#_9         
 1975	1	1	1.7446712	0.05	#_10        
 1976	1	1	1.2775510	0.05	#_11        
 1977	1	1	0.6970522	0.05	#_12        
 1978	1	1	0.2829932	0.05	#_13        
 1979	1	1	0.1097506	0.05	#_14        
 1980	1	1	0.2748299	0.05	#_15        
 1981	1	1	0.5215420	0.05	#_16        
 1982	1	1	0.6689342	0.05	#_17        
 1983	1	1	1.4730159	0.05	#_18        
 1984	1	1	1.0925170	0.05	#_19        
 1985	1	1	1.1673469	0.05	#_20        
 1986	1	1	2.4979592	0.05	#_21        
 1987	1	1	0.7482993	0.05	#_22        
 1988	1	1	1.5555556	0.05	#_23        
 1989	1	1	1.2376417	0.05	#_24        
 1990	1	1	0.5283447	0.05	#_25        
 1991	1	1	0.5977324	0.05	#_26        
 1992	1	1	0.3492063	0.05	#_27        
 1993	1	1	0.3836735	0.05	#_28        
 1994	1	1	0.7659864	0.05	#_29        
 1995	1	1	1.2925170	0.05	#_30        
 1996	1	1	1.1269841	0.05	#_31        
 1997	1	1	1.7895692	0.05	#_32        
 1998	1	1	0.4013605	0.05	#_33        
 1999	1	1	0.7859410	0.05	#_34        
 2000	1	1	0.4707483	0.05	#_35        
 2001	1	1	0.6054422	0.05	#_36        
 2002	1	1	0.4408163	0.05	#_37        
 2003	1	1	0.5378685	0.05	#_38        
 2004	1	1	0.6213152	0.05	#_39        
 2005	1	1	0.4512472	0.05	#_40        
 2006	1	1	0.1682540	0.05	#_41        
 2007	1	1	0.5210884	0.05	#_42        
 2008	1	1	0.4226757	0.05	#_43        
 2009	1	1	1.6657596	0.05	#_44        
 2010	1	1	0.5523810	0.05	#_45        
 2011	1	1	0.3800454	0.05	#_46        
 2012	1	1	0.2290249	0.05	#_47        
 2013	1	1	0.4435374	0.05	#_48        
 2014	1	1	0.2743764	0.05	#_49        
 2015	1	1	0.5632653	0.05	#_50        
 2016	1	1	0.6975057	0.05	#_51        
 2017	1	1	0.6716553	0.05	#_52        
 2018	1	1	0.6303855	0.05	#_53        
 2019	1	1	0.5741497	0.05	#_54        
 2020	1	1	0.3369615	0.05	#_55        
 2021	1	1	0.0367347	0.05	#_56        
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
18 #_N_lbins
#_lbin_vector
0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l0	l5	l10	l15	l20	l25	l30	l35	l40	l45	l50	l55	l60	l65	l70	l75	l80	l85
 2007	1	1	0	0	54.80	0	0	0	1	0	 6	13	14	28	25	17	5	3	0	1	0	0	0	#_1         
 2009	1	1	0	0	51.24	0	0	0	0	0	 1	 0	 0	 8	19	19	6	7	0	0	1	0	0	#_2         
 2012	1	1	0	0	79.80	0	0	0	1	6	12	15	 8	12	22	13	6	0	0	0	0	0	0	#_3         
 2013	1	1	0	0	48.72	0	0	0	2	1	 8	 3	 3	 7	16	11	5	0	1	0	0	0	1	#_4         
 2014	1	1	0	0	38.64	0	0	0	1	2	 1	 4	 8	10	 7	 7	3	0	1	0	1	1	0	#_5         
 2015	1	1	0	0	60.48	0	0	0	0	1	 9	 4	 6	 9	21	14	6	0	1	0	0	1	0	#_6         
 2017	1	1	0	0	34.44	1	0	0	0	0	 2	 3	 7	 9	 8	 5	4	2	0	0	0	0	0	#_7         
-9999	0	0	0	0	 0.00	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	#_terminator
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
