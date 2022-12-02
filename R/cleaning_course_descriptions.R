# cleaning the course descriptions for mapping

library(tidyverse)
library(stringr)


# first going to combine AY19 data with AY21, AY22, and AY23 data
old = read.csv("old_usc_courses.csv")
new = read.csv("new_usc_courses.csv")
usc_courses = rbind(old, new)

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
          "market", "structured", # adding new ones
          "built", "business", "classroom", "commmunication", "consulting",
          "economic", "education", "educational", "focused",
          "future", "inclusive", "institutional", 
          "liveable", "marketing",
          "orgnanizational", "peoples", "policy", "politics",
          "regulatory", "social", 
          "sonic", "strategic", "tax", "technology", "urban", 
          "various","voting", "justice")

# words to remove before "power"
# political, social, presidential, consistency, diversity, sex, motivation, film, n-th, functions


# change "environment" to "domain" if preceded by an exclude word
# change "ecology" to "domain" if preceded by classroom
# also going to change "power" to "domain" if preceded by some things
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
    
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-1]) == "social"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "presidential"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "sex"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "political"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "th"){ #this is for N-th power derivatives
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "consistency"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "functions"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "film"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "motivation"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j-1]) == "diversity"){
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
    # to produce
    if (tolower(x[j]) == "produce"){
      if (tolower(x[j-1]) == "to"){
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
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


# environment followed by "of an air force officer"
# or "power" followed by a bunch of phrases
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
    # words following "power"
    if (tolower(x[j]) == "power"){
      if (tolower(x[j+2]) == "black" && tolower(x[j+3]) == "america"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+2]) == "historical" && tolower(x[j+3]) == "trauma"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "narrative"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "leadership"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+2]) == "personal" && tolower(x[j+2]) == "finance"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+3]) == "aging" && tolower(x[j+2]) == "society"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "tools" && tolower(x[j+3]) == "visual"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "responsibility"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "discovering"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+3]) == "federal" && tolower(x[j+4]) == "government"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "relations" && tolower(x[j+2]) == "among" & tolower(x[j+3]) == "men"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "authority"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+3]) == "federal" && tolower(x[j+4]) == "government"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "institutions"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "institutions"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "politics" && tolower(x[j+3]) == "influence"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "institutions"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "legitimate" && tolower(x[j+3]) == "effective"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+2]) == "resolve" && tolower(x[j+3]) == "conflicts"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+2]) == "occupation" && tolower(x[j+3]) == "throughout"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "confidence" && tolower(x[j+3]) == "identity"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "walking"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "distribution" && tolower(x[j+3]) == "american"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "government"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "governments"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+3]) == "united" && tolower(x[j+4]) == "states"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "resistance" && tolower(x[j+3]) == "political"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "explores" && tolower(x[j+2]) == "collective"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "in" && tolower(x[j+2]) == "iberian"){
        print(i)
        x[j] = "domain"
      }
    }
    #plural power phrases
    if (tolower(x[j]) == "powers"){
      if (tolower(x[j+1]) == "and" && tolower(x[j+2]) == "responsibilities"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "governments"){
        print(i)
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "of" && tolower(x[j+2]) == "government"){
        print(i)
        x[j] = "domain"
      }
    }
    # words after advanced 
    if (tolower(x[j]) == "advanced"){
      if (tolower(x[j+1]) == "coverage"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "accounting"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "students"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "air" && tolower(x[j+2]) == "forcer"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "pronunciation"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "level"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "oral"){
        x[j] = "domain"
      }
      if (tolower(x[j+1]) == "academic"){
        x[j] = "domain"
      }
    }
    # words after produce
    if (tolower(x[j]) == "produce"){
      if (tolower(x[j+1]) == "persuasive"){
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
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


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
    
    # fixing power phrases
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-2]) == "culture"){
        print(i)
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-1]) == "maintain" && tolower(x[j-3]) == "practices"){
        print(i)
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-2]) == "leadership"){
        print(i)
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-1]) == "statistical"){
        print(i)
        x[j] = "domain"
      }
    }
    if (tolower(x[j]) == "power"){
      if (tolower(x[j-2]) == "status" && tolower(x[j-3]) == "class"){
        print(i)
        x[j] = "domain"
      }
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


write.csv(usc_courses, "usc_courses_cleaned.csv", row.names = F)


