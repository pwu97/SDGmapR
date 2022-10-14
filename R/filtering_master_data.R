# filtering the data after the mapping
# I already filtered the keywords in an earlier script, so no need for me to run this

# function to filter data to data only with weight above certain threshold
filter = function(data, threshold){
  mini_df = data[data$weight > threshold, ]
  return(mini_df)
}

# filter the master data after the mapping
master_data = read.csv("master_course_sdg_data.csv")
filtered_data = filter(master_data, 0.2)
write.csv(filtered_data, "master_course_sdg_data_filtered.csv", row.names=F)

