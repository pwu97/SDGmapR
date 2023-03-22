# adding PM-599 and GEOL-599

# read in the AY20-AY23 data
data = read.csv("new_usc_courses.csv")

geol = c("GEOL-599", "Data science methods for climate change health research", "SP23", 25001,
         "Introduces fundamental concepts on climate, epidemiology, and biostatistics and follows with data science methods to study impacts of climate-related events on human health.", "GEOL", 1, "AY23")

pm = c("PM-599", "Data science methods for climate change health research", "SP23", 41249,
         "Introduces fundamental concepts on climate, epidemiology, and biostatistics and follows with data science methods to study impacts of climate-related events on human health.", "PM", 1, "AY23")

data_new = rbind(data, geol)
data_new = rbind(data_new, pm)

write.csv(data_new, "new_usc_courses_updated.csv", row.names=F)
