# general education requirements

library(readxl)
data = read_excel("CATALOG_CLASS_GECAT_20231.xlsx")

data = data %>% select(RCA_COURSE, RCA_TITLE, RCA_GECAT_C)
data = data %>% rename(courseID = RCA_COURSE, course_title = RCA_TITLE, geID = RCA_GECAT_C)

# want to go through and split off the categories for a class into new rows
data = data %>% mutate(id = strsplit(as.character(geID), ";")) %>% unnest(id) %>% select(-geID)

# 20 - Category I: Western Cultures and Traditions 
# 21 - Category II: Global Cultures and Traditions 
# 22 - Category III: Scientific Inquiry
# 23 - Category IV: Science and Its Significance 
# 24 - Category V: Arts and Letters
# 25 - Category VI: Social Issues
# 30 - A The Arts
# 31 - B Humanistic Inquiry 
# 32 - C Social Analysis 
# 33 - D Life Sciences
# 34 - E Physical Sciences
# 35 - F Quantitative Reasoning 
# 36 - G Citizenship in a Diverse World
# 37 - H Traditions and Historical Foundations

# new column "category" and "category name"

ids = c(20, 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 36, 37)
values = c("Category I", "Category II", "Category III", "Category IV", "Category V", "Category VI", "A", "B", "C",
           "D", "E", "F", "G", "H")
names = c("Western Cultures and Traditions", "Global Cultures and Traditions", "Scientific Inquiry", "Science and Its Significance ",
          "Arts and Letters", "Social Issues", "The Arts", "Humanistic Inquiry", "Social Analysis", "Life Sciences", "Physical Sciences",
          "Quantitative Reasoning", "Citizenship in a Diverse World", "Traditions and Historical Foundations")

key = data.frame(id = ids, value = values, name = names)
key$full_name = paste(key$value, key$name, sep=" - ")

# need to convert id's to numbers
key$id = as.numeric(key$id)
data$id = as.numeric(data$id)
# join them together
df = left_join(data, key, by="id")
# nice.


# lets get the keywords, semesters, course_level etc. from master data
master = read.csv("master_course_sdg_data.csv")
# keep all our GE classes, grab matching rows from master
result = left_join(df, master, by="courseID")

# i also want to get"all goals" column from usc_courses_full
sustainability = read.csv("sustainability_related_courses.csv")
final = result %>% left_join(sustainability, by="courseID")

write.csv(final, "ge_data.csv", row.names=F)




