require(data.table)

int1 = read.csv(file="Data/a_bbs_int_flat1.csv", stringsAsFactors = F)
int2 = read.csv(file="Data/a_bbs_int_flat2.csv", stringsAsFactors = F)
int3 = read.csv(file="Data/a_bbs_int_flat3.csv", stringsAsFactors = F)
int4 = read.csv(file="Data/a_bbs_int_flat4.csv", stringsAsFactors = F)

interviews <- data.table( rbind(int1,int2,int3,int4) )
interviews <- interviews[,list(N=.N),by=list(INTERVIEW_PK,VESSEL_FK,SAMPLE_DATE,METHOD_FK,NUM_DAYS_FISHED)]
interviews <- interviews[METHOD_FK==4|METHOD_FK==5]
interviews$SAMPLE_DATE = as.Date(interviews$SAMPLE_DATE)
interviews$YEAR = year(interviews$SAMPLE_DATE)

bl = data.table(  read.csv("Data/AS_bl_allyears.csv", stringsAsFactors = F) )
bl$SAMPLE_DATE = as.Date(bl$SAMPLE_DATE)
bl$YEAR <- year(bl$SAMPLE_DATE)
bl <- bl[METHOD_FK==4|METHOD_FK==5]

duplicate_bl = data.frame()
problem_int = data.frame()
multiday = interviews[interviews$NUM_DAYS_FISHED > 1,]
for(i in 1:nrow(multiday)) {
  entry = multiday[i,]
  
  v = entry$VESSEL_FK
  d = entry$SAMPLE_DATE
  l = entry$NUM_DAYS_FISHED
  
  bl_entries = bl[bl$VESSEL_FK == v & (d - bl$SAMPLE_DATE) %in% 0:(l - 1),]
  
  if(nrow(bl_entries) > 1) {
    duplicate_bl = rbind(duplicate_bl, bl_entries[-nrow(bl_entries),])
    problem_int = rbind(problem_int,entry)
  }
}



hist(duplicate_bl$YEAR)

table(bl$YEAR)

length(unique(bl[YEAR==2019]$BLDT_PK))

a <- data.table( table(bl$YEAR))
b <- data.table( table(interviews$YEAR))
c <- data.table( table(multiday$YEAR) )
d <- data.table( table(problem_int$YEAR) )
e <- merge(a,b,by="V1",all=T)
f <- merge(e,c,by="V1",all=T)
g <- merge(f,d,by="V1",all=T)
g[is.na(g)] <- 0
setnames(g,c("YEAR","N_boatlog","N_interviews","N_multi","N_problem"))
g <- g[YEAR>=2000&YEAR<2020]

g$PERC_INTERVIEWED <- round(g$N_interviews/g$N_boatlog*100,0)
g$PERC_MULTIDAY    <- round(g$N_multi/g$N_interviews*100,0)
g$PERC_MULTIPROB   <- round(g$N_problem/g$N_multi*100,0)
g[is.na(g)|g==Inf] <- 0

write.csv(g,"Trips_breakdown.csv")


table(interviews$BLDT_FK)



