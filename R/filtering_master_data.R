# filtering the data


# filter keywords data

keywords = read.csv("cmu_usc_pwg_mapped.csv")

filter_keywords = function(data, threshold){
  mini_df = data[data$weight > threshold, ]
  return(mini_df)
}

filtered = filter_keywords(keywords, 0.5)
# write.csv(filtered, "filtered_keywords", row.names=F)


# filter the master data by sdgs-- dont map to and sdg if the weight
master_data = read.csv("classes_total_weight.csv")

filter_master_data = function(data, threshold){
  df = data[data["weight"] >= threshold, ]
  return(df)
}


# filter master data by total weight



