# filtering the data

# function to filter data to data only with weight above certain threshold
filter = function(data, threshold){
  mini_df = data[data$weight > threshold, ]
  return(mini_df)
}

# filter keywords data (before mapping... will decrease run time of mapping)
keywords = read.csv("cmu_usc_pwg_mapped.csv")
filtered = filter_keywords(keywords, 0.5)
# write.csv(filtered, "filtered_keywords", row.names=F)


# filter the master data after the mapping
master_data = read.csv("master_course_sdg_data.csv")
filtered_data = filter(master_data, 0.5)
write.csv(filtered_data, "master_course_sdg_data_filtered.csv", row.names=F)

