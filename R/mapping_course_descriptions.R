
# library(SDGmapR) # update this to USC git page
library(tidyverse)
library(dplyr)

classes = read.csv("usc_courses.csv")
cmu_usc_keywords = read.csv("cmu_usc_pwg_mapped.csv")


all_sdg_keywords <- data.frame()
for (goal_num in 1:17) {
  print(goal_num)
  classes %>%
    mutate(goal = goal_num,
           keyword = tabulate_sdg_keywords(classes$course_desc, goal_num, keywords = "cmu_usc")) %>%
    unnest(keyword) -> cur_sdg_keywords
  
  all_sdg_keywords <- rbind(all_sdg_keywords, cur_sdg_keywords) 
}

all_sdg_keywords_copy = all_sdg_keywords

#now join it with cmu to get color and weight
all_sdg_keywords_copy %>%
  left_join(cmu_usc_keywords, by = c("goal", "keyword")) %>%
  select(course_title, keyword, weight, semester, course_num, goal, color, course_desc, course) %>%
  arrange(course_num) -> all_sdg_keywords_copy


write.csv(all_sdg_keywords_copy, "master_course_sdg_data_1.csv")


