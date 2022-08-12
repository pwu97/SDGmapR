# filtering the data

master_data = read.csv("classes_total_weight.csv")

filter_master_data = function(data, threshold){
  df = data[data["weight"] >= threshold, ]
  return(df)
}


filter_master_data_column = function(data, threshold, column){
  df = data[data["weight"] >= threshold, ]
}


