#install_github("PIFSCstockassessments/StepwiseLH")


require(StepwiseLH); require(ggplot2)


# Get APVI estimates
# Based on L99 of Rose/Swains diver lengths of 879 mm TL
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=879, Lmax.SD=10, M_method="Then_2014")

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get APRU estimates
# Based on L99 of BBS 86.5 mm (FL)
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=(865/0.85), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)


# Get CALU estimates
# Based on L99 of 75.8 cm (FL) from BBS
Data <- Get_distributions(Family="Carangidae", Lmax.mean=(758/0.88), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.88)
Lmat <- median(Data$Lmat*0.88)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get ETCO estimates
# Based on L99 of 93.2 cm (FL) from BBS
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=(932/0.86), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.86)
Lmat <- median(Data$Lmat*0.86)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get LERU estimates
# Based on L99 of 39.4 cm (FL) from BBS
Data <- Get_distributions(Family="Lethrinidae", Lmax.mean=(394/0.91), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.91)
Lmat <- median(Data$Lmat*0.91)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get LUKA estimates
# Based on L99 of UVS 33.2 cm (TL)
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=332, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.97)
Lmat <- median(Data$Lmat*0.97)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get PRFL estimates
# Based on L99 of 52.2 cm (FL) from biosampling
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=522/0.87, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get PRZO estimates
# Based on L99 of 44.5 cm (FL) from BBS (note that biosampling is smaller)
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=445/0.87, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)


# Get VALO estimates
# Based on L99 of 45.8 cm (FL) from biosamplling (note that a larger L99 is available with UVS)
Data <- Get_distributions(Family="Serranidae", Lmax.mean=458/0.86, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)


-log(0.04)/Amax

# Plot the growth curve
Age  <- seq(0,Amax,by=0.5)
f    <- function(x) Linf*(1-exp(-K*(x-A0)))
Data <- data.frame(AGE=Age,LENGTH=f(Age)) 
ggplot(data=Data,aes(x=AGE,y=LENGTH))+geom_line()+theme_bw()


