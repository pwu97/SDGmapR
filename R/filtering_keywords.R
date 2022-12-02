# filtering keywords by a threshold
# will reduce runtime of the tabulate keywords function

# function to filter data to data only with weight above certain threshold
filter = function(data, threshold){
  mini_df = data[data$weight > threshold, ]
  return(mini_df)
}

keywords = read.csv("updated_keywords_11-28.csv")
filtered = filter(keywords, 0.2)
write.csv(filtered, "filtered_keywords.csv", row.names=F)
