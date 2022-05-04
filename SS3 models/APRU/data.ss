#V3.30
#C data file for APRU
#
1967 #_styr
2021 #_endyr
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
 1967	1	1	0.1292517	0.05	#_2         
 1968	1	1	0.3882086	0.05	#_3         
 1969	1	1	0.1714286	0.05	#_4         
 1970	1	1	0.0498866	0.05	#_5         
 1971	1	1	0.0000000	0.05	#_6         
 1972	1	1	1.2507937	0.05	#_7         
 1973	1	1	1.7904762	0.05	#_8         
 1974	1	1	1.2589569	0.05	#_9         
 1975	1	1	1.8643991	0.05	#_10        
 1976	1	1	1.3396825	0.05	#_11        
 1977	1	1	0.7827664	0.05	#_12        
 1978	1	1	0.3596372	0.05	#_13        
 1979	1	1	0.1913832	0.05	#_14        
 1980	1	1	0.4784580	0.05	#_15        
 1981	1	1	0.9088435	0.05	#_16        
 1982	1	1	1.1655329	0.05	#_17        
 1983	1	1	2.2299320	0.05	#_18        
 1984	1	1	1.6539683	0.05	#_19        
 1985	1	1	1.7673469	0.05	#_20        
 1986	1	1	1.4063492	0.05	#_21        
 1987	1	1	0.4099773	0.05	#_22        
 1988	1	1	1.1124717	0.05	#_23        
 1989	1	1	0.5854875	0.05	#_24        
 1990	1	1	0.0634921	0.05	#_25        
 1991	1	1	0.1215420	0.05	#_26        
 1992	1	1	0.3233560	0.05	#_27        
 1993	1	1	0.1809524	0.05	#_28        
 1994	1	1	0.6884354	0.05	#_29        
 1995	1	1	0.4312925	0.05	#_30        
 1996	1	1	1.3210884	0.05	#_31        
 1997	1	1	1.2925170	0.05	#_32        
 1998	1	1	0.1759637	0.05	#_33        
 1999	1	1	0.4027211	0.05	#_34        
 2000	1	1	0.5224490	0.05	#_35        
 2001	1	1	0.5532880	0.05	#_36        
 2002	1	1	2.2068027	0.05	#_37        
 2003	1	1	0.2480726	0.05	#_38        
 2004	1	1	0.4571429	0.05	#_39        
 2005	1	1	0.4875283	0.05	#_40        
 2006	1	1	0.1990930	0.05	#_41        
 2007	1	1	1.2566893	0.05	#_42        
 2008	1	1	1.6399093	0.05	#_43        
 2009	1	1	3.2548753	0.05	#_44        
 2010	1	1	0.6780045	0.05	#_45        
 2011	1	1	1.1922902	0.05	#_46        
 2012	1	1	0.3505669	0.05	#_47        
 2013	1	1	1.3469388	0.05	#_48        
 2014	1	1	1.6331066	0.05	#_49        
 2015	1	1	1.8467120	0.05	#_50        
 2016	1	1	1.2412698	0.05	#_51        
 2017	1	1	1.5659864	0.05	#_52        
 2018	1	1	0.9024943	0.05	#_53        
 2019	1	1	1.2444444	0.05	#_54        
 2020	1	1	0.2390023	0.05	#_55        
 2021	1	1	0.0335601	0.05	#_56        
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
2 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
5 # binwidth for population size comp
5 # minimum size in the population (lower edge of first bin and size at age 0.00)
85 # maximum size in the population (lower edge of last bin)
0 #_use_lencomp
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
