# going to go through each course description in usc_courses and clean it up...
# remove punctuation and exclude phrases
# create column called clean_course_desc which will be used in the mapping


library(tidyverse)
library(stringr)
usc_courses = read.csv("usc_courses.csv")

usc_courses["year"] = "AY19"
usc_courses = usc_courses %>% rename(courseID = course_title, course_title = course)
usc_courses = subset(usc_courses, select = -course_num)
usc_courses["clean_course_desc"] = NA


# put the clean version of course_desc in new column without punctuation, except for '
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$course_desc[i]
  desc_clean = gsub("[^[:alnum:][:space:]']", " ", desc)
  desc_spaces = str_squish(desc_clean)
  usc_courses$clean_course_desc[i] = desc_spaces
}


# exclude words if followed by "environment"
words = c("business", "Business", "reporting", "immersive", "learning", "Learning", "visualization", "visualisation",
          "outpatient", "hospital", "clinical", "dental", "lab", "media", "network", 
          "digital", "professional", "legal", "news", "focused",
          "virtual", "workshop", "health care", "emotionally rich", "corporate", 
          "market", "structured", # adding new ones
          "built", "business", "classroom", "clinical", "commmunication", "consulting",
          "dental", "digital", "economic", "education", "educational", "focused",
          "future", "hospital", "inclusive", "institutional", "lab", "learning", 
          "legal", "liveable", "market", "marketing", "media", "network", "news",
          "orgnanizational", "outpatient", "peoples", "policy", "politics",
          "professional", "regulatory", "reporting", "reporting", "social", 
          "sonic", "strategic", "structured", "tax", "technology", "urban", 
          "various", "virtual", "voting", "workshop") 

# check 3744 industrial ecology

# exclude phrases if followed by environment: 
# cross platform
# consequences of design and the 
# emotionally rich
# health care
# creating characters and
# development of
# films in rapidly changing global
# international trade and the
# large data
# obstacles faced in today's
# policy under changing
# real time
# satisfying physical
# systems and


# change "environment" to "domain" if preceded by an exclude word
# change "ecology" to "domain" if preceded by classroom
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
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}

# environment followed by "of an air force officer"
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
    }
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}

# fixing all of other  phrases before environment or ecology
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$clean_course_desc[i]
  x = unlist(strsplit(desc, " "))
  if (length(x) < 6){ # start at the 6th word so no out of bounds errors 
    next
  }
  for (j in 6:length(x)){
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
    
    if (tolower(x[j]) == "restoration"){
      if (tolower(x[j-2]) == "filtering" && tolower(x[j-3]) == "image"){
        print(i)
        x[j] = "repair"
      }
    }
    
  }
  usc_courses$clean_course_desc[i] = paste(x, collapse=" ")
}


# write out csv
write.csv(usc_courses, "usc_courses_cleaned.csv", row.names = F)







# social, tax, built, clinical, educational, stability, institutional, education, urban
# politics (5245), liveable, Health Care, regulatory, Technology, Large Data, real time, Sonic, peoples,
# institutional, future, economic, Analyses of, organizational, regulatory, consequences of design and the,
# consulting, pathogen (2876), development of (2548), policy, classroom, inclusive, various (2358),
# strategic, voting, international trade and the (2218), Creating characters and (1616), marketing,
# communication, policy under changing, global (919), obstacles faced in today's (730), entwinement of (572)
# built (554), systems and (21)


# check 6084, 5973, 5542, 5469, 4613, 4490, 3744, 3688, 3445, 3403, 3398, 3318, 3089, 2876, 1108
# 684, 680, 672 talks about space, 577 says radiant, 


