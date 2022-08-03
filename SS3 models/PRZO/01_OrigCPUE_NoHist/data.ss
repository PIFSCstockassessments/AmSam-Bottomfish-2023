#V3.30
#C data file for PRZO
#
1986 #_styr
2021 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
1 #_spawn_month
2 #_Nsexes
30 #_Nages
1 #_N_areas
1 #_Nfleets
#_fleetinfo
#_type	surveytiming	units	area	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY	#_1
#_Catch data
#_year	season	fleet	catch	catch_se
 -999	1	1	0.66905	     0.5	#_1         
 1986	1	1	0.66905	     0.5	#_2         
 1987	1	1	0.13608	     0.5	#_3         
 1988	1	1	0.35698	     0.5	#_4         
 1989	1	1	0.21455	 0.46734	#_5         
 1990	1	1	 0.1583	     0.5	#_6         
 1991	1	1	0.04445	     0.2	#_7         
 1992	1	1	 0.1261	     0.5	#_8         
 1993	1	1	0.09435	     0.5	#_9         
 1994	1	1	0.29756	     0.2	#_10        
 1995	1	1	0.17554	     0.5	#_11        
 1996	1	1	0.19096	     0.5	#_12        
 1997	1	1	0.31978	     0.5	#_13        
 1998	1	1	  0.171	     0.5	#_14        
 1999	1	1	0.11476	     0.5	#_15        
 2000	1	1	0.05942	     0.2	#_16        
 2001	1	1	0.07711	     0.5	#_17        
 2002	1	1	0.05761	     0.5	#_18        
 2003	1	1	0.05715	     0.5	#_19        
 2004	1	1	0.08573	     0.5	#_20        
 2005	1	1	0.16556	     0.5	#_21        
 2006	1	1	0.06123	     0.5	#_22        
 2007	1	1	0.13063	     0.5	#_23        
 2008	1	1	0.25583	     0.5	#_24        
 2009	1	1	0.09435	0.329973	#_25        
 2010	1	1	0.08573	0.318367	#_26        
 2011	1	1	0.07575	     0.5	#_27        
 2012	1	1	 0.0195	     0.5	#_28        
 2013	1	1	0.07348	     0.5	#_29        
 2014	1	1	0.12701	     0.5	#_30        
 2015	1	1	0.10977	     0.5	#_31        
 2016	1	1	0.20366	     0.2	#_32        
 2017	1	1	0.24494	     0.2	#_33        
 2018	1	1	0.12655	0.218618	#_34        
 2019	1	1	0.07167	0.273842	#_35        
 2020	1	1	0.05035	   0.418	#_36        
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
 1988	7	1	  1.15293	 0.44402	#_1         
 1989	7	1	0.0694884	 2.19437	#_2         
 1990	7	1	  1.42924	0.347151	#_3         
 1991	7	1	 0.856359	0.751649	#_4         
 1992	7	1	  1.85589	0.374552	#_5         
 1993	7	1	  1.30601	0.330364	#_6         
 1994	7	1	  1.06216	0.588493	#_7         
 1995	7	1	 0.592984	0.266976	#_8         
 1996	7	1	 0.664884	0.214516	#_9         
 1997	7	1	 0.531861	0.435491	#_10        
 1998	7	1	 0.864718	0.319919	#_11        
 1999	7	1	 0.587861	0.211473	#_12        
 2000	7	1	 0.289504	0.711608	#_13        
 2001	7	1	 0.339276	0.264277	#_14        
 2002	7	1	  0.38122	0.315619	#_15        
 2003	7	1	 0.493061	0.354167	#_16        
 2004	7	1	 0.360657	 0.24166	#_17        
 2005	7	1	  1.36746	0.438589	#_18        
 2006	7	1	 0.548103	0.559766	#_19        
 2007	7	1	 0.827295	0.256917	#_20        
 2008	7	1	 0.538212	0.317907	#_21        
 2009	7	1	  1.59719	0.728578	#_22        
 2010	7	1	  1.09312	0.642389	#_23        
 2011	7	1	 0.809213	0.688655	#_24        
 2012	7	1	 0.277508	 1.43347	#_25        
 2013	7	1	 0.615196	0.618472	#_26        
 2014	7	1	 0.324868	0.725259	#_27        
 2015	7	1	 0.730041	0.630949	#_28        
 2016	7	1	  1.80102	 0.53428	#_29        
 2017	7	1	  2.18935	0.520258	#_30        
 2018	7	1	  1.09549	0.568193	#_31        
 2019	7	1	 0.772853	 0.77418	#_32        
 2020	7	1	 0.806181	0.794633	#_33        
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
44 # maximum size in the population (lower edge of last bin)
1 #_use_lencomp
#
#_len_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	0.0000001	0	0	0	0	1	#_1
13 #_N_lbins
#_lbin_vector
16 18 20 22 24 26 28 30 32 34 36 38 40 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l16	l18	l20	l22	l24	l26	l28	l30	l32	l34	l36	l38	l40	l16m	l18m	l20m	l22m	l24m	l26m	l28m	l30m	l32m	l34m	l36m	l38m	l40m
 2007	1	1	0	0	  48	0	0	4	5	12	26	21	30	13	8	3	5	3	0	0	4	5	12	26	21	30	13	8	3	5	3	#_1         
 2012	1	1	0	0	  42	0	1	2	8	 6	 6	 6	 6	 6	7	0	1	1	0	1	2	8	 6	 6	 6	 6	 6	7	0	1	1	#_2         
 2017	1	1	0	0	58.8	1	1	3	6	 9	 9	10	13	 9	6	2	1	0	1	1	3	6	 9	 9	10	13	 9	6	2	1	0	#_3         
-9999	0	0	0	0	   0	0	0	0	0	 0	 0	 0	 0	 0	0	0	0	0	0	0	0	0	 0	 0	 0	 0	 0	0	0	0	0	#_terminator
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
