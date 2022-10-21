#install_github("PIFSCstockassessments/StepwiseLH")

require(StepwiseLH); require(ggplot2)

# Get APRU estimates
# Based on L99 of BBS+Biosampling of 85.8 mm (FL)
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=(858/0.85), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)


# Get APVI estimates
# Based on L99 of Rose/Swains diver lengths of 879 mm TL
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=879, Lmax.SD=10, M_method="Then_2014")

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)


# Get CALU estimates
# Based on L99 of 75.8 cm (FL) from BBS
# Base on L99 of 60.5 cm (FL) from Rose+Swains divers (n=120)
# Based on L99 of 75.2 cm (FL) from BBS+BIOS
# Based on L99 of 66 cm (FL) from BIOS
Data <- Get_distributions(Family="Carangidae", Lmax.mean=(660/0.87), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get ETCO estimates
# Based on L99 of 93.2 cm (FL) from BBS
# Based on L99 of 88.1 cm (FL) from BBS+Biosampling
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=(881/0.86), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.86)
Lmat <- median(Data$Lmat*0.86)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get LERU estimates
# Based on L99 of 39 cm (FL) from BBS+BIOS
Data <- Get_distributions(Family="Lethrinidae", Lmax.mean=(390/0.91), Lmax.SD=1, M_method="Then_2014",n_iter=3000)

Linf <- median(Data$Linf*0.91)
Lmat <- median(Data$Lmat*0.91)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

# Get LUKA estimates
# Based on L99 of UVS 33.2 cm (TL) or L99 of 27.5cm (FL) from BBS
# Based on L99 of UVS 30.5 cm (FL) 
# Based on L99 of 26.1 cm FL from biosampling+creel
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=261/0.97, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

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
# Based on L99 of 47 cm (FL) from biosamplling (note that a larger L99 is available with UVS)
Data <- Get_distributions(Family="Serranidae", Lmax.mean=470/0.86, Lmax.SD=1, M_method="Then_2014",n_iter=3000)

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


