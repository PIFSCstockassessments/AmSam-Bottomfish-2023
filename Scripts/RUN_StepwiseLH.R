#install_github("PIFSCstockassessments/StepwiseLH")


require(StepwiseLH)


# Get APVI estimates
# Based on L99 of Rose/Swains diver lengths of 879 mm TL

Data <- Get_distributions(Family="Lutjanidae", Lmax.mean=879, Lmax.SD=10, M_method="Then_2014")

847*0.85
