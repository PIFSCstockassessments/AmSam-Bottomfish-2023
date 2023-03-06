#library(remotes)
#remotes::install_github("PIFSCstockassessments/StepwiseLH")

require(StepwiseLH); require(tidyverse) 

# Get APRU estimates
# Based on L99 of BBS+Biosampling of 85.2 mm (FL)
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=(852/0.85), Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)
Linf.95 <- quantile(Data$Linf*.85, c(0.05,0.95))

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))


# Get APVI estimates
# Based on L99 of Rose/Swains diver lengths of 879 mm TL
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=879, Lmax.SD=10, M_method="Hamel_Cope_2022")

Linf <- median(Data$Linf*0.85)
Lmat <- median(Data$Lmat*0.85)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get CALU estimates
# Based on L99 of 66 cm (FL) from BIOS+Creel
set.seed(123); Data <-Get_distributions(Family="Carangidae", Lmax.mean=(660/0.87), Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get ETCO estimates
# Based on L99 of 88.1 cm (FL) from BBS+Biosampling
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=(881/0.86), Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.86)
Lmat <- median(Data$Lmat*0.86)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get LERU estimates
# Based on L99 of 39 cm (FL) from BBS+BIOS
set.seed(123); Data <-Get_distributions(Family="Lethrinidae", Lmax.mean=(390/0.91), Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.91)
Lmat <- median(Data$Lmat*0.91)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get LUKA estimates
# Based on L99 of 26.4 cm FL from biosampling+creel
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=264/0.97, Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.97)
Lmat <- median(Data$Lmat*0.97)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get PRFL estimates
# Based on L99 of 47.6 cm (FL) from biosampling+BBS
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=476/0.87, Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get PRZO estimates
# Based on L99 of 41 cm (FL) from BBS+biosampling
set.seed(123); Data <-Get_distributions(Family="Lutjanidae", Lmax.mean=410/0.87, Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*0.87)
Lmat <- median(Data$Lmat*0.87)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Get VALO estimates
# Based on L99 of 49.4 cm (FL) from creel+biosamplling (note: very similar to diver survey value)
set.seed(123); Data <-Get_distributions(Family="Serranidae", Lmax.mean=494/1, Lmax.SD=1, M_method="Hamel_Cope_2022",n_iter=10000)

Linf <- median(Data$Linf*1)
Lmat <- median(Data$Lmat*1)
K    <- median(Data$K)
Amax <- median(Data$Amax)
M    <- median(Data$M)
A0   <- median(Data$A0)

sd(Data$Linf*0.85)
median(Data$M)
mean(log(Data$M))
sd(log(Data$M))
sd(Data$Amax)
quantile(Data$M,c(0.05,0.95))

# Plot the growth curve
Age  <- seq(0,Amax,by=0.5)
f    <- function(x) Linf*(1-exp(-K*(x-A0)))
set.seed(123); Data <-data.frame(AGE=Age,LENGTH=f(Age)) 
ggplot(data=Data,aes(x=AGE,y=LENGTH))+geom_line()+theme_bw()


