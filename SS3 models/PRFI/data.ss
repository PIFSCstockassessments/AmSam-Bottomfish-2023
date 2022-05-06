#V3.30
#C data file for PRFI
#
1967 #_styr
2020 #_endyr
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
 1967	1	1	0.036281179	0.05	#_2         
 1968	1	1	0.109297052	0.05	#_3         
 1969	1	1	0.048526077	0.05	#_4         
 1970	1	1	0.014058957	0.05	#_5         
 1971	1	1	0.000000000	0.05	#_6         
 1972	1	1	0.351927438	0.05	#_7         
 1973	1	1	0.500226757	0.05	#_8         
 1974	1	1	0.345578231	0.05	#_9         
 1975	1	1	0.514739229	0.05	#_10        
 1976	1	1	0.369160998	0.05	#_11        
 1977	1	1	0.216326531	0.05	#_12        
 1978	1	1	0.099773243	0.05	#_13        
 1979	1	1	0.053514739	0.05	#_14        
 1980	1	1	0.134240363	0.05	#_15        
 1981	1	1	0.255328798	0.05	#_16        
 1982	1	1	0.326984127	0.05	#_17        
 1983	1	1	0.678004535	0.05	#_18        
 1984	1	1	0.502947846	0.05	#_19        
 1985	1	1	0.537414966	0.05	#_20        
 1986	1	1	0.274376417	0.05	#_21        
 1987	1	1	0.042630385	0.05	#_22        
 1988	1	1	0.034013605	0.05	#_23        
 1989	1	1	0.116099773	0.05	#_24        
 1990	1	1	0.056235828	0.05	#_25        
 1991	1	1	0.003174603	0.05	#_26        
 1992	1	1	0.000907029	0.05	#_27        
 1993	1	1	0.061224490	0.05	#_28        
 1995	1	1	0.023129252	0.05	#_29        
 1996	1	1	0.121088435	0.05	#_30        
 1997	1	1	0.026303855	0.05	#_31        
 1998	1	1	0.058956916	0.05	#_32        
 1999	1	1	0.185941043	0.05	#_33        
 2000	1	1	0.020408163	0.05	#_34        
 2001	1	1	0.353287982	0.05	#_35        
 2002	1	1	0.032199546	0.05	#_36        
 2003	1	1	0.020861678	0.05	#_37        
 2004	1	1	0.069387755	0.05	#_38        
 2005	1	1	0.043083900	0.05	#_39        
 2006	1	1	0.007709751	0.05	#_40        
 2007	1	1	0.021315193	0.05	#_41        
 2008	1	1	0.266666667	0.05	#_42        
 2009	1	1	0.473015873	0.05	#_43        
 2010	1	1	0.013151927	0.05	#_44        
 2011	1	1	0.041269841	0.05	#_45        
 2012	1	1	0.029931973	0.05	#_46        
 2013	1	1	0.060317460	0.05	#_47        
 2014	1	1	0.031746032	0.05	#_48        
 2015	1	1	0.047619048	0.05	#_49        
 2016	1	1	0.008616780	0.05	#_50        
 2017	1	1	0.014965986	0.05	#_51        
 2019	1	1	0.016326531	0.05	#_52        
 2020	1	1	0.017233560	0.05	#_53        
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
8 #_N_lbins
#_lbin_vector
25 30 35 40 45 50 55 60 #_lbin_vector
#
#_lencomp
#_Yr	Seas	FltSvy	Sex	Part	Nsamp	l25	l30	l35	l40	l45	l50	l55	l60
 2008	1	1	0	0	8.96	11	10	11	7	10	1	3	3	#_1         
-9999	0	0	0	0	0.00	 0	 0	 0	0	 0	0	0	0	#_terminator
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
