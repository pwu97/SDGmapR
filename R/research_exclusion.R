

# remove all research classes
data = read.csv("usc_courses_cleaned.csv")
master = read.csv("master_course_sdg_data.csv")

# theres a bunch of different ones but definitely excluding every class that says directed research

data_clean = data[!grepl("directed research", tolower(data$course_title)), ]
# sum(grepl("directed research", tolower(data_clean$course_title)))

master_clean = master[!grepl("directed research", tolower(master$course_title)), ]
# sum(grepl("directed research", tolower(master_clean$course_title)))






sum(grepl("doctoral dissertation", tolower(data$course_title)))
# 583 courses with doctoral dissertation

sum(grepl("directed research", tolower(data$course_title)))
sum(grepl("directed research", tolower(data$clean_course_desc)))
# 304 courses directed research

sum(grepl("research leading to the doctorate", tolower(data$clean_course_desc)))
# 159 courses research leading to doctorate

sum(grepl("research leading to the master's", tolower(data$clean_course_desc)))
sum(grepl("research leading to the masters", tolower(data$clean_course_desc)))

sum(grepl("research forum", tolower(data$clean_course_desc)))





