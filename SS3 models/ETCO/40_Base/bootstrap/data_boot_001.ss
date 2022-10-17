#V3.30
#C data file for ETCO
#
1967 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
2 #_Nsexes
55 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	          0	    0.01	#_1         
 1967	1	1	  0.0279005	     0.5	#_2         
 1968	1	1	   0.268656	     0.5	#_3         
 1969	1	1	  0.0748071	     0.5	#_4         
 1970	1	1	  0.0391926	     0.5	#_5         
 1971	1	1	0.000883231	     0.5	#_6         
 1972	1	1	   0.608307	     0.5	#_7         
 1973	1	1	   0.612081	     0.5	#_8         
 1974	1	1	   0.754918	     0.5	#_9         
 1975	1	1	    2.16956	     0.5	#_10        
 1976	1	1	    1.10949	     0.5	#_11        
 1977	1	1	   0.275159	     0.5	#_12        
 1978	1	1	  0.0937987	     0.5	#_13        
 1979	1	1	   0.194017	     0.5	#_14        
 1980	1	1	   0.935641	     0.5	#_15        
 1981	1	1	    2.02007	     0.5	#_16        
 1982	1	1	    5.37501	     0.5	#_17        
 1983	1	1	    14.6078	     0.5	#_18        
 1984	1	1	    6.69207	     0.5	#_19        
 1985	1	1	    3.97034	     0.5	#_20        
 1986	1	1	    4.84104	 0.80552	#_21        
 1987	1	1	   0.368758	 1.40981	#_22        
 1988	1	1	    4.13016	 1.03391	#_23        
 1989	1	1	   0.705679	0.410435	#_24        
 1990	1	1	  0.0966929	 1.09739	#_25        
 1991	1	1	   0.227149	0.512413	#_26        
 1992	1	1	 4.9175e-05	 2.31941	#_27        
 1993	1	1	   0.406362	0.461778	#_28        
 1994	1	1	     1.5059	0.213268	#_29        
 1995	1	1	    1.05733	0.346758	#_30        
 1996	1	1	    2.62405	 0.55085	#_31        
 1997	1	1	    1.12387	 0.31522	#_32        
 1998	1	1	     2.2663	0.258636	#_33        
 1999	1	1	    1.13985	0.413156	#_34        
 2000	1	1	   0.162758	0.459847	#_35        
 2001	1	1	    1.86745	 0.35261	#_36        
 2002	1	1	    0.32204	0.619048	#_37        
 2003	1	1	    1.15728	0.463612	#_38        
 2004	1	1	   0.382846	  1.1729	#_39        
 2005	1	1	    1.43057	0.827787	#_40        
 2006	1	1	  0.0428819	  1.5236	#_41        
 2007	1	1	    1.41846	0.737086	#_42        
 2008	1	1	    2.22855	0.482475	#_43        
 2009	1	1	    3.30104	 0.22864	#_44        
 2010	1	1	    0.68621	0.338195	#_45        
 2011	1	1	   0.728383	 0.52926	#_46        
 2012	1	1	  0.0223762	 1.41111	#_47        
 2013	1	1	    1.48118	 1.06936	#_48        
 2014	1	1	    1.82964	0.375471	#_49        
 2015	1	1	     1.6801	0.230871	#_50        
 2016	1	1	    3.52443	0.209085	#_51        
 2017	1	1	      1.309	0.207125	#_52        
 2018	1	1	    1.83455	0.227297	#_53        
 2019	1	1	   0.739662	0.287378	#_54        
 2020	1	1	    1.16326	0.357784	#_55        
 2021	1	1	   0.173415	0.627146	#_56        
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
 2016	7	1	6.95448	0.374297	#_1         
 2017	7	1	3.38286	0.442488	#_2         
 2018	7	1	 6.0728	0.372519	#_3         
 2019	7	1	3.46051	0.490025	#_4         
 2020	7	1	10.6902	0.608891	#_5         
 2021	7	1	2.91973	 1.17662	#_6         
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
100 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
-1	0.001	0	0	1	1	0.001	#_FISHERY
15 #_N_lbins
#_lbin_vector
20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Gender	Part	Nsamp	f20	f25	f30	f35	f40	f45	f50	f55	f60	f65	f70	f75	f80	f85	f90	m20	m25	m30	m35	m40	m45	m50	m55	m60	m65	m70	m75	m80	m85	m90
 2007	 1	 1	0	0	 66.52	0	1	1	 3	10	33	29	25	24	14	18	13	10	1	0	0	1	1	 3	10	33	29	25	24	14	18	13	10	1	0	#_1         
 2008	 1	 1	0	0	 78.72	0	0	3	 6	 5	 7	10	10	13	11	10	13	11	2	0	0	0	3	 6	 5	 7	10	10	13	11	10	13	11	2	0	#_2         
 2009	 1	 1	0	0	 87.84	0	2	4	 2	 2	 5	14	10	15	10	15	16	 7	3	2	0	2	4	 2	 2	 5	14	10	15	10	15	16	 7	3	2	#_3         
 2011	 1	 1	0	0	 59.64	2	2	3	18	 3	 4	 4	 2	 5	 6	 2	10	 9	1	0	2	2	3	18	 3	 4	 4	 2	 5	 6	 2	10	 9	1	0	#_4         
 2012	 1	 1	0	0	 51.72	0	1	8	 0	 4	 2	 5	 7	 9	 5	 9	 9	 4	1	0	0	1	8	 0	 4	 2	 5	 7	 9	 5	 9	 9	 4	1	0	#_5         
 2013	 1	 1	0	0	 50.88	2	0	0	 6	 2	 9	14	 7	 3	 8	 3	 4	 1	4	0	2	0	0	 6	 2	 9	14	 7	 3	 8	 3	 4	 1	4	0	#_6         
 2014	 1	 1	0	0	107.68	3	2	5	 7	 4	 3	 5	16	16	15	17	18	 9	7	2	3	2	5	 7	 4	 3	 5	16	16	15	17	18	 9	7	2	#_7         
 2015	 1	 1	0	0	    63	1	0	0	 1	 5	 5	 2	 9	 8	 8	 9	16	 8	3	0	1	0	0	 1	 5	 5	 2	 9	 8	 8	 9	16	 8	3	0	#_8         
 2016	 1	 1	0	0	 57.28	1	2	4	 0	 0	 0	 2	 6	 8	 8	10	18	 8	1	1	1	2	4	 0	 0	 0	 2	 6	 8	 8	10	18	 8	1	1	#_9         
 2018	-1	 1	0	0	 85.68	1	6	2	 3	 3	 5	 9	10	21	 9	12	12	 8	1	0	1	6	2	 3	 3	 5	 9	10	21	 9	12	12	 8	1	0	#_10        
 2019	 1	-1	0	0	    21	0	1	0	 1	 0	 1	 5	 3	 7	 2	 1	 4	 0	0	0	0	1	0	 1	 0	 1	 5	 3	 7	 2	 1	 4	 0	0	0	#_11        
 2020	-1	-1	0	0	  12.6	0	0	0	 0	 0	 0	 1	 0	 4	 1	 2	 1	 5	1	0	0	0	0	 0	 0	 0	 1	 0	 4	 1	 2	 1	 5	1	0	#_12        
-9999	 0	 0	0	0	     0	0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	0	0	0	 0	 0	 0	 0	 0	 0	 0	 0	 0	 0	0	0	#_terminator
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
