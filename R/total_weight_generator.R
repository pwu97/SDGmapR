# This code will get the total weights for each sdg a class maps to


library(tidyverse)

# read in the master sdg course data 
master_data = read.csv("master_course_sdg_data.csv")

# read in the USC course data
courses = read.csv("usc_courses.csv")
classes = unique(courses$course_title)
df = data.frame(classes)

df = df %>% add_column(sdg1_weight = NA)
df = df %>% add_column(sdg2_weight = NA)
df = df %>% add_column(sdg3_weight = NA)
df = df %>% add_column(sdg4_weight = NA)
df = df %>% add_column(sdg5_weight = NA)
df = df %>% add_column(sdg6_weight = NA)
df = df %>% add_column(sdg7_weight = NA)
df = df %>% add_column(sdg8_weight = NA)
df = df %>% add_column(sdg9_weight = NA)
df = df %>% add_column(sdg10_weight = NA)
df = df %>% add_column(sdg11_weight = NA)
df = df %>% add_column(sdg12_weight = NA)
df = df %>% add_column(sdg13_weight = NA)
df = df %>% add_column(sdg14_weight = NA)
df = df %>% add_column(sdg15_weight = NA)
df = df %>% add_column(sdg16_weight = NA)
df = df %>% add_column(sdg17_weight = NA)

# get the sum of the weights for each sdg
for (class in df$classes){
  mini_df = unique(master_data[master_data$course_title == class, c("keyword", "goal", "weight", "course_title") ])
  # print(mini_df)
  unique_goals = unique(mini_df$goal)
  for (g in unique_goals){
    goal_df = mini_df[mini_df$goal == g, ]
    # print(goal_df)
    goal_sum = sum(goal_df$weight)
    # print(goal_sum)
    col_number= 1 + g
    df[df$classes == class, col_number] = goal_sum
  }
}

# get the total sum and add last column
df = df %>% add_column(total_weight = NA)
for (i in nrow(df)){
  df$total_weight = rowSums(df[,-1], na.rm=TRUE) #exlude first two columns
}


write.csv(df, "classes_total_weight.csv")


