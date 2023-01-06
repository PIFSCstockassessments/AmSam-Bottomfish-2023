#V3.30
#C data file for VALO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
2 #_Nsexes
15 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	 0.00929605	     0.5	#_2         
 1968	1	1	  0.0231534	     0.5	#_3         
 1969	1	1	 0.00589719	     0.5	#_4         
 1970	1	1	 0.00486063	     0.5	#_5         
 1971	1	1	0.000968646	     0.5	#_6         
 1972	1	1	   0.154292	     0.5	#_7         
 1973	1	1	  0.0940226	     0.5	#_8         
 1974	1	1	   0.354722	     0.5	#_9         
 1975	1	1	   0.370551	     0.5	#_10        
 1976	1	1	   0.250223	     0.5	#_11        
 1977	1	1	  0.0292741	     0.5	#_12        
 1978	1	1	  0.0206961	     0.5	#_13        
 1979	1	1	  0.0438614	     0.5	#_14        
 1980	1	1	   0.255634	     0.5	#_15        
 1981	1	1	   0.158845	     0.5	#_16        
 1982	1	1	   0.497906	     0.5	#_17        
 1983	1	1	    2.93306	     0.5	#_18        
 1984	1	1	   0.708649	     0.5	#_19        
 1985	1	1	   0.537649	     0.5	#_20        
 1986	1	1	   0.420614	     0.5	#_21        
 1987	1	1	   0.139335	     0.5	#_22        
 1988	1	1	    1.19667	     0.5	#_23        
 1989	1	1	   0.325095	0.488049	#_24        
 1990	1	1	   0.357608	     0.5	#_25        
 1991	1	1	   0.317437	0.309938	#_26        
 1992	1	1	   0.110089	     0.5	#_27        
 1993	1	1	  0.0910173	     0.5	#_28        
 1994	1	1	   0.483452	     0.5	#_29        
 1995	1	1	   0.341897	     0.5	#_30        
 1996	1	1	   0.177894	     0.5	#_31        
 1997	1	1	     1.0896	     0.5	#_32        
 1998	1	1	   0.122371	     0.5	#_33        
 1999	1	1	    0.22395	     0.5	#_34        
 2000	1	1	   0.242135	     0.5	#_35        
 2001	1	1	   0.229356	     0.5	#_36        
 2002	1	1	   0.726046	     0.5	#_37        
 2003	1	1	   0.508855	0.296677	#_38        
 2004	1	1	   0.118254	     0.5	#_39        
 2005	1	1	   0.098938	     0.5	#_40        
 2006	1	1	   0.314915	     0.5	#_41        
 2007	1	1	    0.19085	     0.5	#_42        
 2008	1	1	   0.664699	     0.5	#_43        
 2009	1	1	   0.358594	0.262737	#_44        
 2010	1	1	    0.11694	     0.5	#_45        
 2011	1	1	   0.228048	     0.5	#_46        
 2012	1	1	  0.0677809	     0.5	#_47        
 2013	1	1	   0.279775	     0.5	#_48        
 2014	1	1	   0.130522	     0.5	#_49        
 2015	1	1	   0.240887	     0.5	#_50        
 2016	1	1	  0.0531991	0.309637	#_51        
 2017	1	1	  0.0791611	0.347708	#_52        
 2018	1	1	  0.0614547	     0.2	#_53        
 2019	1	1	   0.154542	     0.2	#_54        
 2020	1	1	   0.128771	 0.24518	#_55        
 2021	1	1	  0.0128288	0.470573	#_56        
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
 2016	7	1	0.0720188	0.554733	#_1         
 2017	7	1	0.0882858	0.764977	#_2         
 2018	7	1	0.0365718	 1.02772	#_3         
 2019	7	1	 0.207781	 0.48149	#_4         
 2020	7	1	 0.196344	 0.59806	#_5         
-9999	0	0	        0	       0	#_terminator
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
57 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
13 #_N_lbins
#_lbin_vector
15 18 21 24 27 30 33 36 39 42 45 48 51 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	f15	f18	f21	f24	f27	f30	f33	f36	f39	f42	f45	f48	f51	m15	m18	m21	m24	m27	m30	m33	m36	m39	m42	m45	m48	m51
 2011	1	1	0	0	59	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	1	1	13	24	25	 4	 2	 0	1	2	1	0	0	#_1         
 2012	1	1	0	0	68	0	0	 5	 7	11	18	21	11	9	2	2	0	0	0	0	 5	 7	11	18	21	11	9	2	2	0	0	#_2         
 2013	1	1	0	0	63	0	0	 1	10	13	13	18	14	5	2	1	2	0	0	0	 1	10	13	13	18	14	5	2	1	2	0	#_3         
 2014	1	1	0	0	47	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	0	1	10	13	 9	11	 6	 5	3	0	1	0	0	#_4         
 2015	1	1	0	0	79	0	4	 8	19	19	13	12	15	4	4	1	1	0	0	4	 8	19	19	13	12	15	4	4	1	1	0	#_5         
-9999	0	0	0	0	 0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	#_terminator
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
