# this function will add a data entry to the keyword list

cmu_usc = read.csv("cmu_usc_pwg_mapped.csv")
# there is a column "X" which has indexes we will want to remove later
colors = unique(cmu_usc$color) # the colors are in order 1-17


# still need to make sure that the row to add isnt already in there
add_row = function(dataset, word, goal, weight){
  dataset = dataset[, c("goal", "keyword", "pattern", "weight", "color")] # get rid of X column
  color = colors[goal]
  # index = nrow(dataset) + 1 # need this for the row index
  pattern = paste("\\b(\\d*)", word, "(\\d*)\\b", sep="")
  row = c(goal, word, pattern, weight, color)
  dataset = rbind(dataset, row)
  return(dataset)
}

# hello


# add the row to the end
x = add_row(cmu_usc, "landscapes", 2, 0.21)
x = add_row(x, "landscapes", 6, 0.07)
x = add_row(x, "landscapes", 11, 0.16)
x = add_row(x, "landscapes", 12, 0.14)
# for sdg 15 landscape and landscapes are way off on weights... 

# order the rows by goal
x = x[order(strtoi(x$goal)), ]

# now overwrite the keyword list
write.csv(x, "cmu_usc_pwg_mapped.csv", row.names = F)
