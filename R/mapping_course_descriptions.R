# this script finds all of the keywords/weights in the course descriptions for each sdg
# BE SURE to run "tabulate_sdg_keywords.R" to have in your environment before doing this

library(tidyverse)
library(dplyr)

classes = read.csv("usc_courses_cleaned.csv")
#using the filtered keywords here, could also use the full list
cmu_usc_keywords = read.csv("filtered_keywords.csv")


all_sdg_keywords <- data.frame()
for (goal_num in 1:17) {
  print(goal_num) #useful for seeing how far you are in the code run
  classes %>%
    mutate(goal = goal_num, #run on clean_course_desc column w no punctuation and accuracy edits made
           keyword = tabulate_sdg_keywords(classes$clean_course_desc, goal_num, keywords = "cmu_usc")) %>%
    unnest(keyword) -> cur_sdg_keywords
  
  all_sdg_keywords <- rbind(all_sdg_keywords, cur_sdg_keywords) 
}

#create a copy because that code took 30+ minutes to run
all_sdg_keywords_copy = all_sdg_keywords

#now join it with cmu to get color and weight
all_sdg_keywords_copy %>%
  left_join(cmu_usc_keywords, by = c("goal", "keyword")) %>%
  select(courseID, course_title, section, semester, keyword, goal, weight, color, course_desc, department, N.Sections, year) %>%
  arrange(courseID) -> all_sdg_keywords_copy


write.csv(all_sdg_keywords_copy, "master_course_sdg_data.csv", row.names = F)
# save this object so we dont have to run code again
save(all_sdg_keywords_copy, file="all_sdg_keywords.Rda")
