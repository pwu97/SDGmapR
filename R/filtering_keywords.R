# filtering keywords by a threshold
# will reduce runtime of the tabulate keywords function

# function to filter data to data only with weight above certain threshold
filter = function(data, threshold){
  mini_df = data[data$weight > threshold, ]
  return(mini_df)
}

keywords = read.csv("cmu_usc_pwg_SDG_Keywords_corrected_10_11_22.csv")
filtered = filter(keywords, 0.2)
write.csv(filtered, "filtered_keywords.csv", row.names=F)
