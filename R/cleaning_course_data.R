# Cleaning course data
# course dataset generator given raw data
# assuming raw_data is of the same form as USC_FULL_COURSE_LIST_20182_20183_20191.csv

library(tidyverse)

clean_data = function (raw_data){
  # grab only the rows without an exclude flag
  data_clean = raw_data[raw_data$Exclude.Flag == 0, ]
  # now grab the unique courses by term
  data_unique = data_clean[!duplicated(data_clean[ , c("Rcl.Course", "Rcl.Term")]), ] 
  # we could change this to Rcl.Cat.Id and Term as well
  
  # now getting the number of sections for each class offered in a semester
  counts = c()
  for (i in 1:nrow(data_unique)){
    course = data_unique[i, 1] # could change this to be Rcl.Cat.Id column
    term = data_unique[i, 2]
    mini_df = data_clean[ data_clean$Rcl.Course == course & data_clean$Rcl.Term == term , ]
    rows = nrow(mini_df)
    counts = c(counts, rows)
  }
  data_unique["N.Sections"] = counts
  return (data_unique)
}

# using function to clean usc raw course data
data = read.csv("USC_FULL_COURSE_LIST_20182_20183_20191.csv")
usc_courses = clean_data(data)



# helper function to get semester from the Rcl.Term column
get_semesters <- function(term_col){
  semesters = c()
  for (i in 1:length(term_col)){
    letters = term_col[i]
    year = substr(letters,3,4)
    term = substr(letters, 5,5)
    if (term == "1"){
      term = "SP"
    }
    else if (term == "2"){
      term = "SU"
    }
    else{
      term = "F"
    }
    result = paste0(term, year)
    semesters = c(semesters, result)
  }
  return(semesters)
}


transform_data = function(course_data){
  # now create "semester" column in the classes dataframe
  course_data$semester = get_semesters(course_data$Rcl.Term)
  #create the "course_num" column from "rcl.class"
  course_data$section = course_data$Rcl.Class
  #create the "course_desc" column
  course_data$course_desc=paste(course_data$Rcl.Title, "-", course_data$Rca.Desc)
  #create class_title column
  course_data$courseID = course_data$Rcl.Course
  # create course column
  course_data$course_title = course_data$Rcl.Title
  # create department column
  course_data$department = course_data$RCL_DEPT
  # create year column
  course_data$year = "AY19"
  # select relevant columns for the Shiny App
  course_data = course_data[, c("course_title", "semester", "courseID", "section", "course_desc", "department", "N.Sections", "year")]
  
  return (course_data)
}

classes = transform_data(usc_courses)
write.csv(classes, "usc_courses.csv",row.names = F)

