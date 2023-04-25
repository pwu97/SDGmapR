library(tidyverse)

keywords = read.csv("USC_PWG-E_2023Keywords_04_24_23.csv")
# there are strange NA columns i don't want
keywords = keywords %>% select (goal, keyword, pattern, color)
# assign every keyword a weight of 1
keywords$weight = 1
# make everything lower case
keywords$keyword = tolower(keywords$keyword)
keywords$pattern = tolower(keywords$pattern)
# get rd of duplicates
keywords = keywords[!duplicated(keywords), ]


write.csv(keywords, "usc_keywords.csv", row.names=F)
