#devtools::install_github("AdrianHordyk/LBSPR")

require(LBSPR)

# General parameters
Units    <- "cm"
BinWidth <- 5
SPR      <- 0.3 # Target SPR

# LH Parameters 
Sp <- "APVI"
Name <- Sp

# Growth: Linf,K,CVLinf,M
# Mat:    L50,L95

if(Sp=="APRU"){
  Growth <- c(122.9,0.163,0.1,0.20) # Ralston 1988, M from Fry 2006 (amax=16)
  Mat    <- c(46.9,51.9)            # StepwiseLH Lmat + 5 cm for L95
}
if(Sp=="APVI"){
  Growth <- c(72.0,0.33,0.1,0.101) # O'Malley 2021, M from Hawaii assessment
  Mat    <- c(44.8,45.5)
}
if(Sp=="CALU"){
  Growth <- c(82.2,0.12,0.1,0.27) # Menezes 1968 (Brazil), M from Fry 20016 (amax=12)
  Mat    <- c(38,43)              # Garcia-Cagide 1994 (Cuba)
}
if(Sp=="ETCO"){
  Growth <- c(82.1,0.133,0.1,0.06) # Uehara 2020 (Japan), M from Amax=55
  Mat    <- c(54.7,59.7)           # Reed 2021 (Hawaii)
}
if(Sp=="LERU"){
  Growth <- c(31.5,0.80,0.1,0.40) # Trianni 2011 (Mariana), M from Amax=8 (note: 15 yr in Japan)
  Mat    <- c(22.6,25.5)          # Trianni 2011 (Mariana), average of two locations
}
if(Sp=="LUKA"){
  Growth <- c(33.0,0.29,0.1,0.40) # Morales-Nin 1990 (Hawaii), M from Amax=8
  Mat    <- c(21.3,24.3)          # StepwiseLH from Lmax = 33.2 (Divers) + 3 cm for L95
}
if(Sp=="PRFL"){
  Growth <- c(41.2,0.47,0.1,0.111) # O'Malley 2019 (Mariana), M from Amax=28
  Mat    <- c(27.0,32.0)           # Brouard 1985 (Vanuatu)
}
if(Sp=="PRZO"){
  Growth <- c(36.9,0.29,0.1,0.11) # Schemmel 2022 (Guam), M from Amax=30
  Mat    <- c(23.6,26.6)          # Schemmel 2022 (Guam)
}
if(Sp=="VALO"){
  Growth <- c(43.5,0.26,0.1,0.23) # Schemmel 2022, M from Amax=14
  Mat    <- c(25.8,28.8)          # Schemmel 2022
}

MyPars          <- new("LB_pars")
MyPars@Species  <- Name
MyPars@Linf     <- Linf
MyPars@MK       <- M / KKKKK
MyPars@L50      <- L50 
MyPars@L95      <- L95
MyPars@CVLinf   <- CVLinf
MyPars@SPR      <- SPR 
MyPars@BinWidth <- BinWidth
MyPars@L_units  <- Units

Len1a <- new("LB_lengths", LB_pars=MyPars, file="DATA/APVI_BB.csv",dataType="freq", header=TRUE)
Len1b <- new("LB_lengths", LB_pars=MyPars, file="DATA/APVI_BS.csv",dataType="freq", header=TRUE)
Len2  <- new("LB_lengths", LB_pars=MyPars, file="DATA/APVI_atoll.csv",dataType="freq", header=TRUE)
Len3  <- new("LB_lengths", LB_pars=MyPars, file="DATA/APVI_NWHI.csv",dataType="freq", header=TRUE)
#plotSize(Len1)

myFit_BB    <- LBSPRfit(MyPars, Len1a)
myFit_BS    <- LBSPRfit(MyPars, Len1b)
myFit_Atoll <- LBSPRfit(MyPars, Len2)
myFit_NWHI  <- LBSPRfit(MyPars, Len3)


#myFit1@Ests #Smoothed multiyear estimates
rawEsts <- data.frame(rawSL50=myFit_NWHI@SL50, rawSL95=myFit_NWHI@SL95, rawFM=myFit_NWHI@FM, rawSPR=myFit_NWHI@SPR) # Raw estimates
View(rawEsts)

plotSize(myFit_BB); plotEsts(myFit_BB)
plotSize(myFit_BS); plotEsts(myFit_BS)
plotSize(myFit_Atoll); plotEsts(myFit_Atoll)
plotSize(myFit_NWHI); plotEsts(myFit_NWHI)


# Compare to target size structure
Yr <- 18 # Highest data year (2013)
MyPars@SL50 <- myFit1@SL50[Yr]
MyPars@SL95 <- myFit1@SL95[Yr]
plotTarg(MyPars, Len1, yr=Yr)


