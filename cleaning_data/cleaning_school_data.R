# going to try running Dr. Hopper's code for the old data on the new data for 
# 2020-2023, the files have weird bugs we need to fix

library(tidyverse)
library(gdata)

# function to clean a file
clean_file = function(table) {
  x <- table
  # want to add the 'origin' column for the semester it belongs to
  x$origin = "NA"
  for(i in seq(nrow(x), 2, -1)) { # Work on the table in bottom to top so we can merge the values
    if(x[i, "SECTION"] == "") { # only work on rows with empty course section ""
      # Work on the current row and the previous row.
      # Don't modify numeric columns (don't want to merge NA values).
      # Use lead() to check across rows, and turn NA values into an empty string.
      # Use paste() to combine the row values.
      # use trim() to get rid of any excess white space produced.
      x[i-1,] <- (x[c(i-1,i),] %>% mutate(across(.fns = ~ ifelse(is.numeric(.x), .x, trim(paste(.x, ifelse(is.na(lead(.x)), "", lead(.x))))))))[1, ]
    }
  }
  # remove the empty rows
  x <- x[x$SECTION != "",]
  return (x)
}


# grab file names in the "old_data" folder
# make sure they are all CSVs you want to run the code on
files = list.files("old_data")
# names(files)

# going to apply the function to each file and write a new csv in "new_data" folder
for (i in 1:length(files)){
  semester = read.csv(paste0("old_data/", files[i]), header=TRUE) # load file
  out <- clean_file(semester) # clean the file
  name = paste0("clean_data/", i, ".csv") # will change this to actually be the year output format
  write.csv(out, file = name, row.names = FALSE)
}


### now lets combine them all" ###

# CSVfiles <- list.files(pattern="\\.csv$", full.names=TRUE) 
# print(CSVfiles) #make sure all the files have the same header names
# #then merge files together

# library(data.table)

# file_list <- lapply(CSVfiles, function(x){
#   ret <- read_csv(x)
#   ret$origin <- x
#   return(ret)})
# 
# df <- rbindlist(file_list, fill = TRUE)
# names(df)
# head(df)
# df$origin <- str_replace(df$origin, "./FIXED_SOC_", "")
# df$origin <- str_replace(df$origin, ".csv", "")
# head(df)# yesss

# write.csv(df, "All_SOC_files_2020-2022_fixed.csv",row.names=FALSE)



