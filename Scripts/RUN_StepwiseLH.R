#install_github("PIFSCstockassessments/StepwiseLH")


require(StepwiseLH)


# Get APVI estimates
# Based on L99 of Rose/Swains diver lengths of 879 mm TL
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=879, Lmax.SD=10, M_method="Then_2014")
847*0.85

# Get APRU estimates
# Based on L99 of BBS 86.5 mm (FL)
Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=(865/0.85), Lmax.SD=1, M_method="Then_2014",n_iter=1000)
median(Data$Linf*0.85)
median(Data$Lmat*0.85)







