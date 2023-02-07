# working on the program requirements dataset


# install.packages("readxl")
library(readxl)
# install.packages("strip")
# library(strip)
library(stringr)

data = read_excel("programs-list-2023-01-18_14.51.07.xlsx")
# names(data)

line = data$Structure[2]
# line
new = gsub("[\r\n\t]", "", line)
# new

# noticing the course code is always right after an asterix

split = strsplit(new, "\\*")
# split

# split[[1]][1]

more = sapply(strsplit(split[[1]], "-"), trimws)
# more

# more[[2]][1]
# more[[70]][4]

# capitalize for classes like CHEM-105a 
more = sapply(more, toupper)

classes = sapply(more,"[",1)
# classes

# remove the first class since it is the name of the program

classes = classes[-1]

# some of them are NA or empty, remove those

classes = classes[!is.na(classes)]
classes = classes[classes != ""]
# classes

# now need to put a "-" instead of space
classes = sub(" ", "-", classes)


# now collapse to one string with commas
paste(classes, collapse=", ")





data$classes = ""
for (i in 1:nrow(data)){
  print(i)
  line = data$Structure[i]
  new = gsub("[\r\n\t]", "", line)
  split = strsplit(new, "\\*")
  more = sapply(strsplit(split[[1]], "-"), trimws)
  more = sapply(more, toupper)
  classes = sapply(more,"[",1)
  classes = classes[!is.na(classes)]
  classes = classes[classes != ""]
  classes = classes[-1]
  classes = sub(" ", "-", classes)
  data$classes[i] = paste(classes, collapse=", ")
}

out = data[, c("Program Name", "School/Department", "Program Type", "classes")]
write.csv(out, "programs.csv", row.names=F)
