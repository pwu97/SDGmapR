# Going to create new keyword list containing CMU words as well as the PWG

library(tidyverse)
library(SDGmapR)
library(dplyr)


# noticed that theres some repeats here... i could get rid of them quickly
pwg = read.csv("PWG_Keywords.csv")
pwg = unique(pwg)
cmu250 = read.csv("cmu250_keywords_cleaned.csv")
cmu1000 = cmu1000_keywords

pwg_cmu250 = left_join(pwg, cmu250, by="keyword")
write.csv(pwg_cmu250, "pwg_cmu250.csv")
# go into excel, create two new csvs... one for pwg words that mapped to cmu250
# and one for words that did not map to cmu250
pwg_unmapped_cmu250 = read.csv("pwg_unmapped_cmu250.csv")
pwg_mapped_cmu250 = read.csv("pwg_mapped_cmu250.csv")


# now join unmapped words and cmu1000
pwg_cmu1000 = left_join(pwg_unmapped_cmu250, cmu1000, by="keyword")
write.csv(pwg_cmu1000, "pwg_cmu1000.csv")
# go into excel, create two new csvs... one for pwg words that mapped to cmu1000
# and one for words that did not map to cmu1000
pwg_unmapped_cmu1000 = read.csv("pwg_unmapped_cmu1000.csv")
pwg_mapped_cmu1000 = read.csv("pwg_mapped_cmu1000.csv")



# new column to store where the words map
pwg = pwg %>% add_column(mapped = "NA")

# update mapped column to say cmu250 if it was not in the missing list
for (i in 1:nrow(pwg)){
  keyword = pwg$keyword[i]
  if (keyword %in% pwg_mapped_cmu250$keyword){
    pwg$mapped[i] = "cmu250"
  }
  if (keyword %in% pwg_mapped_cmu1000$keyword){
    pwg$mapped[i] = "cmu1000"
  }
}

nrow(pwg)
sum(pwg$mapped == "cmu250")
sum(pwg$mapped == "cmu1000")
sum(pwg$mapped == "NA")


# now making a master keyword list containing cmu250, as well as the pwg words that mapped
# to cmu1000
master_df = rbind(cmu250, pwg_mapped_cmu1000)


exclude_words = c("student", "students", "teaching", "learning", "skill", 
                  "skills", "curriculum",  "classroom", "math", "classrooms", 
                  "graduates",  "undergraduates", "undergrad", "course", 
                  "mathematics", "courses", "elementary", "academic", "training", 
                  "undergraduate", "college", "colleges", "learners", 
                  "algebra", "reading", "comprehension", "achievements", 
                  "universities", "faculty", "internship", "principal", 
                  "internships", "career", "principals", "curricula", 
                  "grad", "university", "semester", "scholars", "exam", 
                  "exams", "tutoring", "syllabus", "instructor", "instructors", 
                  "degree", "classes", "instruction", "campus", "homework", 
                  "instructional", "curricular", "mentoring", "teach",  
                  "qualifications", "coursework", "graduate")


master_df = master_df[!(master_df$keyword %in% exclude_words), ]
write.csv(master_df, "cmu_usc_pwg_mapped.csv", row.names = T)



