# This code will get the total weights for each sdg a class maps to


library(tidyverse)

# read in the master sdg course data 
master_data = read.csv("master_course_sdg_data.csv")

# read in the USC course data
courses = read.csv("usc_courses.csv")
classes = unique(courses$course_title)
weights = data.frame(classes)

weights = weights %>% add_column(sdg1_weight = NA)
weights = weights %>% add_column(sdg2_weight = NA)
weights = weights %>% add_column(sdg3_weight = NA)
weights = weights %>% add_column(sdg4_weight = NA)
weights = weights %>% add_column(sdg5_weight = NA)
weights = weights %>% add_column(sdg6_weight = NA)
weights = weights %>% add_column(sdg7_weight = NA)
weights = weights %>% add_column(sdg8_weight = NA)
weights = weights %>% add_column(sdg9_weight = NA)
weights = weights %>% add_column(sdg10_weight = NA)
weights = weights %>% add_column(sdg11_weight = NA)
weights = weights %>% add_column(sdg12_weight = NA)
weights = weights %>% add_column(sdg13_weight = NA)
weights = weights %>% add_column(sdg14_weight = NA)
weights = weights %>% add_column(sdg15_weight = NA)
weights = weights %>% add_column(sdg16_weight = NA)
weights = weights %>% add_column(sdg17_weight = NA)

# get the sum of the weights for each sdg
for (class in weights$classes){
  mini_weights = unique(master_data[master_data$course_title == class, c("keyword", "goal", "weight", "course_title") ])
  # print(mini_weights)
  unique_goals = unique(mini_weights$goal)
  for (g in unique_goals){
    goal_weights = mini_weights[mini_weights$goal == g, ]
    # print(goal_weights)
    goal_sum = sum(goal_weights$weight)
    # print(goal_sum)
    col_number= 1 + g
    weights[weights$classes == class, col_number] = goal_sum
  }
}

# get the total sum and add last column
weights = weights %>% add_column(total_weight = NA)
for (i in nrow(weights)){
  weights$total_weight = rowSums(weights[,-1], na.rm=TRUE) #exlude first two columns
}


write.csv(weights, "classes_total_weight.csv", row.names = F)


