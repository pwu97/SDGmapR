# cleaning 2020-2022 course data
# different format from the 2018/2019 data

# need to remove more research courses!!!

# data = read.csv("All_SOC_files_2020-2022_fixed.csv")
data = read.csv("combined_data.csv")


clean_data = function (raw_data){
  # grab only the rows with enough students (except future classes it doesnt matter)
  # update this number to be the current semester, so future semesters will be everything after this
  future_classes = raw_data[raw_data$origin > 20231 & trimws(raw_data$COURSE_TITLE) !=  "Directed Research", ]
  # remove basic research classes with boring descriptions
  data_clean = raw_data[raw_data$TOTAL_ENR > 3 & trimws(raw_data$COURSE_TITLE) !=  "Directed Research", ] # added trimws for some spaces at end
  # now combine with future classes
  data_clean = rbind(data_clean, future_classes)
  # now grab the unique courses by term
  data_unique = data_clean[!duplicated(data_clean[ , c("COURSE_CODE", "origin")]), ] 
  
  # now getting the number of sections for each class offered in a semester
  counts = c()
  for (i in 1:nrow(data_unique)){
    course = data_unique[i, "COURSE_CODE"] 
    term = data_unique[i, "origin"]
    mini_df = data_clean[ data_clean$COURSE_CODE == course & data_clean$origin == term , ]
    rows = nrow(mini_df)
    counts = c(counts, rows)
  }
  data_unique["N.Sections"] = counts
  return (data_unique)
}

#takes awhile to run this line
cleaned = clean_data(data)

# now need to get the semester format right, need F20, SU20, SP20 etc.
# right now it is in format 20202_SUMMER, 20212_SUMMER
# 3 is fall, 2 is summer, 1 is spring
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

# helper function to get "year" column in form AY20, AY21 etc.
# parameter is the column of the terms F20, SP21, etc.
# if it is 2020-2 or 2020-3, the AY is 21
# if it is 2021-1, AY is 21
get_year <- function(term_col){
  years = c()
  for (i in 1:length(term_col)){
    letters = term_col[i]
    # convert year to a integer
    year = strtoi(substr(letters,3,4))
    term = substr(letters, 5,5)
    # summer and fall terms count as the academic year of spring
    if (term == "2" | term == "3"){
      year = year + 1
    }
    result = paste0("AY", year)
    years = c(years, result)
  }
  return(years)
}


transform_data = function(course_data){
  # now create "semester" column in the classes dataframe
  course_data$semester = get_semesters(course_data$origin)
  #create the "course_num" column from "rcl.class"
  course_data$section = course_data$SECTION
  #create the "course_desc" column
  course_data$course_desc=paste(course_data$COURSE_TITLE, "-", course_data$COURSE_DESCRIPTION)
  #create class_title column
  course_data$courseID = course_data$COURSE_CODE
  # create course column
  course_data$course_title = course_data$COURSE_TITLE
  # create department column
  course_data$department = course_data$DEPARTMENT #changed this from departmentowner name
  # create year column
  course_data$year = get_year(course_data$origin)
  # select relevant columns for the Shiny App
  course_data = course_data[, c("courseID", "course_title", "semester", "section", "course_desc", "department", "N.Sections", "year")]
  
  return (course_data)
}

data_final = transform_data(cleaned)


# last thing!
# helper function to get the grad/undergrad column from courseID column
get_class_levels <- function(data) {
  data$course_level = NA
  for (i in 1:nrow(data)){
    print(i)
    # grab the course ID
    course = data$courseID[i]
    # get just the number after the "-"
    num = strsplit(course, "-")[[1]][2]
    # some course codes have letters at the end, remove them and convert to number
    val = as.numeric(unlist(strsplit(gsub("[^[:digit:]. ]", "", num), " +")))
    if (val >= 500){
      data$course_level[i] = "graduate"
    }
    else if (val < 300){
      data$course_level[i] = "undergrad lower division"
    }
    else{
      data$course_level[i] = "undergrad upper division"
    }
  }
  return (data)
}

# now add the course levels to data
data_final = get_class_levels(data_final)


write.csv(data_final, "usc_courses.csv",row.names = F)


