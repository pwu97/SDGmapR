#going to add a column to each file that has grad/undergrad


# classes numbered 000 – 299 are considered lower division undergraduate 
# classes and classes numbered 300 – 499 are considered upper division 
# undergraduate classes. Classes numbered above 500 are primarily intended 
# for graduate students.

full = read.csv("usc_courses_full.csv")
master = read.csv("master_course_sdg_data.csv")

full$course_level = NA
master$course_level = NA 

add_level = function(data){
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

x = add_level(full)
y = add_level(master)

write.csv(x, "full.csv", row.names=F)
write.csv(y, "master.csv", row.names=F)


# 
# test = master$courseID[1]
# x = strsplit(test, "-")[[1]][2]
# first = as.numeric(substr(x, 1, 1))
# 
# as.numeric(unlist(strsplit(gsub("[^[:digit:]. ]", "", "chemeeeee105bbbb"), " +")))
