# cleaning the course descriptions for mapping

library(tidyverse)
library(stringr)
library(stringi)

usc_courses = read.csv("cleaning_raw_data/usc_courses_updated.csv")
# usc_courses = read.csv("usc_courses.csv")

# fix typos in course description
corrections <- rbind(
  c("ofenvironmental", "of environmental"),
  c("ProfessionalEducation", "Professional Education"),
  c("EconomicContext", "Economic Context"),
  c("builtenvironment", "built environment"),
  c("medicaldevices", "medical devices"),
  c("systemscollapse", "systems collapse"),
  c("thepresent", "the present"),
  c("onindustralization", "on industralization"),
  c("buildingstructures", "building structures"),
  c("structuralinvestigation", "structural investigation")
)
colnames(corrections) <- c("wrong", "right")

usc_courses$course_desc <- stri_replace_all_regex(usc_courses$course_desc,
                                                  pattern = corrections[,1],
                                                  replacement = corrections[,2],
                                                  vectorize = FALSE)


# column to hold cleaned course description
usc_courses["clean_course_desc"] = NA


# put the clean version of course_desc in new column without punctuation, except for '
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$course_desc[i]
  desc_clean = gsub("[^[:alnum:][:space:]']", " ", desc)
  desc_spaces = str_squish(desc_clean)
  usc_courses$clean_course_desc[i] = desc_spaces
}


# exclude words if followed by "environment"
words = c("business", "reporting", "immersive", "learning", "visualization", "visualisation",
          "outpatient", "hospital", "clinical", "dental", "lab", "media", "network", 
          "digital", "professional", "legal", "news", "focused",
          "virtual", "workshop", "health care", "emotionally rich", "corporate", 
          "market", "structured","built", "business", "classroom", "commmunication", "consulting",
          "economic", "education", "educational", "focused",
          "future", "inclusive", "institutional", 
          "liveable", "marketing","orgnanizational", "peoples", "policy", "politics",
          "regulatory", "social", "sonic", "strategic", "tax", "technology", "urban", 
          "various","voting", "justice", "digital")



###
##### removing a word preceded by a word
###

# change "environment" to "domain" if preceded by an exclude word
# change "ecology" to "domain" if preceded by classroom
# change "laws" to "domain" if preceded by thermodynamic, biological, physical, or conservation
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$clean_course_desc[i]
  x = unlist(strsplit(desc, " "))
  for (j in 2:length(x)){
    if (is.na(x[j])){
      next
    }
    if (x[j] == "environment" | x[j] == "environments" | x[j] == "Environment" | x[j] == "Environments"){
      # print(i)
      if (tolower(x[j-1]) %in% words){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "ecology"){ #there is also industry ecology but i think it should map for that class
      if (tolower(x[j-1]) == "classroom"){
        print(i)
        x[j] = "domain"
      }
    }
    
    # application security
    if (tolower(x[j]) == "security"){
      if (tolower(x[j-1]) == "application"){
        print(i)
        x[j] = "domain"
      }
    }
    # art preservaton, wealth preservation
    if (tolower(x[j]) == "preservation"){
      if (tolower(x[j-1]) == "wealth"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "art"){
        print(i)
        x[j] = "domain"
      }
    }
    # brain architecture
    if (tolower(x[j]) == "architecture"){
      if (tolower(x[j-1]) == "brain"){
        print(i)
        x[j] = "domain"
      }
    }
    # laws
    if (tolower(x[j]) == "law" | tolower(x[j]) == "laws") {
      if (tolower(x[j-1]) == "thermodynamic" |
          tolower(x[j-1]) == "biological" |
          tolower(x[j-1]) == "physical" |
          tolower(x[j-1]) == "conservation") {
        x[j] = "domain"
      }
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}



###
##### phrases after words 
###

# environment followed by "of an air force officer"
# or "power" followed by a bunch of phrases
# laws followed by of thermodynamics or of nature
# trans followed by disciplinary
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$clean_course_desc[i]
  x = unlist(strsplit(desc, " "))
  if (length(x) < 6){
    next
  }
  for (j in 1:(length(x)-5)){
    if (tolower(x[j]) == "environment"){
      if (tolower(x[j+3]) == "air" && tolower(x[j+4]) == "force" && tolower(x[j+5]) == "officer"){
        print(i)
        x[j] = "domain"
      }
      #typo 3 f's in officer
      if (tolower(x[j+3]) == "air" && tolower(x[j+4]) == "force" && tolower(x[j+5]) == "offficer"){
        print(i)
        x[j] = "domain"
      }
    }
    # green screen footage
    if (tolower(x[j]) == "green"){
      if (tolower(x[j+1]) == "screen" && tolower(x[j+2]) == "footage"){
        print(i)
        x[j] = "domain"
      }
    }
    # court positioning
    if (tolower(x[j]) == "court"){
      if (tolower(x[j+1]) == "positioning"){
        x[j] = "domain"
      }
    }
    # inclusion exclusion symmetric
    if (tolower(x[j] == "inclusion")){
      if (tolower(x[j+1]) == "exclusion" && tolower(x[j+2]) == "symmetric"){
        x[j] = "domain"
      }
    }
    # bias measurement error
    if (tolower(x[j] == "bias")){
      if (tolower(x[j+1]) == "measurement" && tolower(x[j+2]) == "error"){
        x[j] = "domain"
      }
    }
    # laws
    if (tolower(x[j]) == "law" | tolower(x[j]) == "laws") {
      if (tolower(x[j+1]) == "of" & 
          (tolower(x[j+2]) == "thermodynamics" | tolower(x[j+2]) == "nature")) {
            x[j] = "domain"
          }
    }
    # trans disciplinary
    if (tolower(x[j]) == "trans") {
      if (tolower(x[j+1]) == "disciplinary") {
        x[j] = "domain"
      }
    }
    # zebra fish
    if (tolower(x[j]) == "zebra") {
      if (tolower(x[j+1]) == "fish") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "co2") {
      if (tolower(x[j+1]) == "laser" | tolower(x[j+1]) == "lasers") {
        x[j] = "domain"
      }
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}




###
##### phrases before words ###
###

# fixing all other phrases before "environment", "ecology", or "power(s)"
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$clean_course_desc[i]
  x = unlist(strsplit(desc, " "))
  if (length(x) < 6){ # start at the 6th word so no out of bounds errors 
    next
  }
  for (j in 6:length(x)){
    # fix environment phrases
    if (tolower(x[j]) == "environment" | tolower(x[j]) == "environments"){
      if (tolower(x[j-3]) == "design" && tolower(x[j-5]) == "consequences"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "rich" && tolower(x[j-2]) == "emotionally"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "care" && tolower(x[j-2]) == "health"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-2]) == "characters" && tolower(x[j-3]) == "creating"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "of" && tolower(x[j-2]) == "development"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "global" && tolower(x[j-2]) == "changing"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environment"){
      if (tolower(x[j-4]) == "international" && tolower(x[j-3]) == "trade"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "data" && tolower(x[j-2]) == "large"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environment"){
      if (tolower(x[j-1]) == "today's" && tolower(x[j-3]) == "faced"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "changing" && tolower(x[j-2]) == "under"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "time" && tolower(x[j-2]) == "real"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environment"){
      if (tolower(x[j-1]) == "physical" && tolower(x[j-2]) == "satisfying"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-1]) == "and" && tolower(x[j-2]) == "systems"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "environments"){
      if (tolower(x[j-2]) == "cross" && tolower(x[j-3]) == "platform"){
        print(i)
        x[j] = "domain"
      }
    }
    
    # fix ecology phrases
    if (tolower(x[j]) == "ecology"){
      if (tolower(x[j-1]) == "classroom"){
        print(i)
        x[j] = "domain"
      }
    }
    
    if (tolower(x[j]) == "ecology"){
      if (tolower(x[j-2]) == "within" && tolower(x[j-3]) == "entertainment"){
        print(i)
        x[j] = "domain"
      }
    }
    
    # fix image filtering restoration
    if (tolower(x[j]) == "restoration"){
      if (tolower(x[j-2]) == "filtering" && tolower(x[j-3]) == "image"){
        print(i)
        x[j] = "repair"
      }
    }
    
    # fix degrees of freedom
    if (tolower(x[j]) == "freedom"){
      if (tolower(x[j-2]) == "degrees" && tolower(x[j-1]) == "of"){
        print(i)
        x[j] = "domain"
      }
    }
    # youth ecosystem
    if (tolower(x[j]) == "ecosystem") {
      if (tolower(x[j-1]) == "youth") {
        x[j] = "domain"
      }
    }
    # prison pipeline
    if (tolower(x[j]) == "pipeline") {
      if (tolower(x[j-1]) == "prison") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "organism") {
      if (tolower(x[j-1]) == "total") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "species") {
      if (tolower(x[j-1]) == "reactive") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "forest") {
      if (tolower(x[j-1]) == "random") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "ecosystem") {
      if (tolower(x[j-1]) == "advertising") {
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "forest") {
      if (tolower(x[j-1]) == "decision") {
        x[j] = "domain"
      }
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


write.csv(usc_courses, "usc_courses_cleaned.csv", row.names = F)


