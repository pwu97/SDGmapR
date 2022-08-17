# this file is going to categorize each course as SustainabilityRelated, 
# SustainabilityFocused, or NotRelated

library(tidyverse)

# data containing all course titles
usc_courses = read.csv("usc_courses.csv")
# data containing what courses map to which goals
master_data = read.csv("master_course_sdg_data.csv")


# grab the unique class titles
classes = unique(usc_courses$course_title)
df = data.frame(classes)
# create column to store goals that class maps to 
df = df %>% add_column(goals = NA)
# create column to store sustainability-relatedness
df = df %>% add_column(related = NA)
# criteria lists
social_economic_goals = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17)
environment_goals = c (13, 14, 15)


index = 1
for (class in df$classes){
  # subset master data to just the rows for that class and grab the unique goals
  mini_df = unique(master_data[master_data$course_title == class, "goal"])
  # combine all the goals into a string to be added to the goals column in df
  goals = paste(mini_df, collapse=",")
  #update the goals column of df to be this string "goals"
  df$goals[index] = goals
  index = index + 1
}


# now need to go through and check criteria and update the related column accordingly
new_index = 1
for (goal in df$goals){
  # first check if it is null and move to the next class if so
  if(goal == ""){
    df$related[new_index] = "NotRelated"
    new_index = new_index + 1
    next
  }
  # split the goals into a list
  goal_numbers = as.list(strsplit(goal, ",")[[1]])
  # three variables to keep track if mapped goals are in criteria lists
  is_social_economic = FALSE
  is_environment = FALSE
  has_17_11 = FALSE
  for (i in range(1:length(goal_numbers))){
    current_number = goal_numbers[i]
    if (current_number %in% social_economic_goals){
      is_social_economic = TRUE
    }
    if (current_number %in% environment_goals){
      is_environment = TRUE
    }
  }
  if (is_social_economic && !is_environment){
    df$related[new_index] = "Inclusive"
  }
  if (!is_social_economic && is_environment){
  df$related[new_index] = "Inclusive"
  }
  if (is_social_economic && is_environment){
  df$related[new_index] = "Focused"
  }
  new_index = new_index + 1
}

sum(df$related == "Focused")
sum(df$related == "Inclusive")
sum(df$related == "NotRelated")

write.csv(df, "sustainability_related_courses.csv")


