
interviews = read.csv(file="Data/a_bbs_int_flat4.csv", stringsAsFactors = F)







interviews$SAMPLE_DATE = as.Date(interviews$SAMPLE_DATE)
bl = read.csv("Data/AS_bl_allyears.csv", stringsAsFactors = F)
bl$SAMPLE_DATE = as.Date(bl$SAMPLE_DATE)

duplicate_bl = data.frame()
multiday = interviews[interviews$NUM_DAYS_FISHED > 1,]
for(i in 1:nrow(multiday)) {
  entry = multiday[i,]
  
  v = entry$VESSEL_FK
  d = entry$SAMPLE_DATE
  l = entry$NUM_DAYS_FISHED
  
  bl_entries = bl[bl$VESSEL_FK == v & (d - bl$SAMPLE_DATE) %in% 0:(l - 1),]
  
  if(nrow(bl_entries) > 1) {
    duplicate_bl = rbind(duplicate_bl, bl_entries[-nrow(bl_entries),])
  }
}



unique(interviews$SAMPLE_DATE)
