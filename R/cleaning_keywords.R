library(tidyverse)

# add the weight column
keywords = read.csv("USC_PWG-E_2023Keywords_04_11_23_final.csv")
# there are strange NA columns i don't want
keywords = keywords %>% select (goal, keyword, pattern, color)
# assign every keyword a weight of 1
keywords$weight = 1

# make everything lower case
keywords$keyword = tolower(keywords$keyword)
keywords$pattern = tolower(keywords$pattern)

write.csv(keywords, "usc_keywords.csv", row.names=F)
