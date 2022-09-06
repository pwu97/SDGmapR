# working on the accuracy of the mapping 

# load("all_sdg_keywords.Rda")
# filtered = all_sdg_keywords_copy[all_sdg_keywords_copy$weight > 0.13, ]
usc_courses = read.csv("usc_courses.csv")
usc_courses["year"] = "AY19"
usc_courses["clean_course_desc"] = NA

# replacing exclude phrases
words = c("business", "Business", "reporting", "immersive", "learning", "Learning", "visualization", "visualisation",
          "outpatient", "hospital", "clinical", "dental", "lab", "media", "network", 
          "digital", "professional", "legal", "cross-platform", "news", "focused",
          "virtual", "workshop", "health care", "emotionally rich", "corporate", 
          "market", "structured")

# checking for environment preceded by one of the words above
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$course_desc[i]
  x = unlist(strsplit(desc, " "))
  for (j in 2:length(x)){
    if (is.na(x[j])){
      # x[j] = "temp"
      next
    }
    if (x[j] == "environment" | x[j] == "environments" | x[j] == "Environment" | 
        x[j] == "Environments" | x[j] == "environment." | x[j] == "environments." |
        x[j] == "environments;" | x[j] == "environment;" | x[j] == "environment.;Hours"){
      print("yup")
      if (x[j-1] %in% words){
          x[j] = "domain"
      }
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


# now want to check for environment of environments followed by "of an Air Force officer"
# for (i in 1:nrow(usc_courses)){
#   desc = usc_courses$course_desc[i]
#   x = unlist(strsplit(desc, " "))
#   for (j in 1:length(x)){
#     if (is.na(x[j])){
#       next
#     }
#     if (x[j] == "environment" | x[j] == "environments"){
#       y = unlist(strsplit(desc, "Air "))
#       if (y[2] == "of an Air Force Officer. \nGraded CR/NC.;"){
#         print("got one")
#         x[j] = "domain"
#       }
#     }
#   }
#   usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
# }


# x = "Leadership Laboratory I - Introduction to the military experience focusing on 
# customs and courtesies, drill and ceremonies, and the environment of an Air Force Officer. 
# Graded CR/NC.;"
# x = "Space Environments and Spacecraft Interactions - Space environments and interactions with space systems. Vacuum,;neutral and ionized species, plasma, radiation, micrometeoroids.;Phenomena important for spacecraft operations."
# y = unlist(strsplit(x, "Air "))
