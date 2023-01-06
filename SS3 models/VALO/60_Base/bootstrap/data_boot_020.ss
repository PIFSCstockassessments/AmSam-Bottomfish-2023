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
 1967	1	1	  0.0131262	     0.5	#_2         
 1968	1	1	  0.0284055	     0.5	#_3         
 1969	1	1	  0.0172814	     0.5	#_4         
 1970	1	1	 0.00239842	     0.5	#_5         
 1971	1	1	0.000416273	     0.5	#_6         
 1972	1	1	   0.203656	     0.5	#_7         
 1973	1	1	   0.206102	     0.5	#_8         
 1974	1	1	  0.0743589	     0.5	#_9         
 1975	1	1	   0.128696	     0.5	#_10        
 1976	1	1	   0.117061	     0.5	#_11        
 1977	1	1	  0.0757069	     0.5	#_12        
 1978	1	1	  0.0265966	     0.5	#_13        
 1979	1	1	  0.0213783	     0.5	#_14        
 1980	1	1	   0.429137	     0.5	#_15        
 1981	1	1	   0.229677	     0.5	#_16        
 1982	1	1	   0.341214	     0.5	#_17        
 1983	1	1	   0.514726	     0.5	#_18        
 1984	1	1	   0.487864	     0.5	#_19        
 1985	1	1	   0.476656	     0.5	#_20        
 1986	1	1	   0.405786	     0.5	#_21        
 1987	1	1	   0.174851	     0.5	#_22        
 1988	1	1	    1.68168	     0.5	#_23        
 1989	1	1	   0.420402	0.488049	#_24        
 1990	1	1	   0.143412	     0.5	#_25        
 1991	1	1	   0.162098	0.309938	#_26        
 1992	1	1	   0.130197	     0.5	#_27        
 1993	1	1	   0.145726	     0.5	#_28        
 1994	1	1	   0.490437	     0.5	#_29        
 1995	1	1	   0.254556	     0.5	#_30        
 1996	1	1	   0.372979	     0.5	#_31        
 1997	1	1	   0.644033	     0.5	#_32        
 1998	1	1	   0.062057	     0.5	#_33        
 1999	1	1	   0.152062	     0.5	#_34        
 2000	1	1	   0.251077	     0.5	#_35        
 2001	1	1	   0.267534	     0.5	#_36        
 2002	1	1	   0.797771	     0.5	#_37        
 2003	1	1	   0.608893	0.296677	#_38        
 2004	1	1	   0.102663	     0.5	#_39        
 2005	1	1	   0.086759	     0.5	#_40        
 2006	1	1	  0.0625583	     0.5	#_41        
 2007	1	1	    0.15435	     0.5	#_42        
 2008	1	1	   0.253118	     0.5	#_43        
 2009	1	1	   0.749933	0.262737	#_44        
 2010	1	1	   0.178347	     0.5	#_45        
 2011	1	1	   0.270244	     0.5	#_46        
 2012	1	1	   0.116652	     0.5	#_47        
 2013	1	1	   0.463836	     0.5	#_48        
 2014	1	1	    0.25909	     0.5	#_49        
 2015	1	1	   0.304789	     0.5	#_50        
 2016	1	1	  0.0616796	0.309637	#_51        
 2017	1	1	  0.0648212	0.347708	#_52        
 2018	1	1	  0.0667866	     0.2	#_53        
 2019	1	1	   0.279388	     0.2	#_54        
 2020	1	1	   0.144514	 0.24518	#_55        
 2021	1	1	 0.00688287	0.470573	#_56        
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
