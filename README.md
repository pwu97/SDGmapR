# USC Sustainability Course Finder

Peter Wu at Carnegie Mellon wrote the initial code that inspired this
project, and his original R package can be found on
[Github](https://github.com/pwu97/SDGmapR). At USC, Brian Tinsley and
Dr. Julie Hopper in the Office of Sustainability have been working to
develop this package further and raise sustainability awareness in
higher education by mapping USC course descriptions to the United
Nations Sustainability Development Goals.

## Table of Contents

-   [Installation](#keyword-list)
-   [Installation](#installation)
-   [Cleaning Course Data](#cleaning-course-data)

## Installation

If you wish to install this package on your computer, clone this
repository by following [these
instructions.](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
Once installed, you can open, view, and edit all files in this
repository.

## Keyword List

## Cleaning Course Data

While I do not expect another school’s data to be of the same format as
the raw files at USC, I am still including some details on how we
cleaned the files in hopes that it may address some common problems
others might have with their data. <!-- add link to a file? --> Course
data was retrieved from the USC’s Office of Academic Records and
Registrar, and the raw data files, as well as the R scripts to clean
them, can be found in the `cleaning_raw_data` folder. These files had
lots of problems with spacing and column names, and we addressed these
issues in `cleaning_scattered_files.R`. <!-- show the dataframe -->
<!-- show the code to clean it --> In the `clean_file` function, we loop
from the bottom of the raw dataframe and combine empty rows with the row
above to fix the empty line issue. We also trim spaces before and after
to account for random spaces added at the end of some data entries. One
problem to look out for when cleaning a dataframe is accounting for
empty values (““) vs NA vs”NA” in data entries.

``` r
# go through backwords and combine error rows with row above it
for(i in seq(nrow(x), 2, -1)) { # Work on the table in bottom to top so we can merge the values
  if(is.na(x[i, "SECTION"]) | x[i, "SECTION"] == "NA" | x[i, "SECTION"] == "") { #always note if values are NA or "NA" or ""
      x[i, "SECTION"] = NA # fix the issue of combining character "NA" 
      print(i)
      # Work on the current row and the previous row.
      # Don't modify numeric columns (don't want to merge NA values).
      # Use lead() to check across rows, and turn NA values into an empty string.
      # Use paste() to combine the row values.
      # use trim() to get rid of any excess white space produced.
      x[i-1,] <- (x[c(i-1,i),] %>% mutate(across(.fns = ~ ifelse(is.numeric(.x), .x, trim(paste(.x, ifelse(is.na(lead(.x)), "", lead(.x))))))))[1, ]
    }
}
```

Once the files are cleaned, we run a function (in the same R script) to
clean each individual file and write it as CSV into a new folder, as
well as obtain the “origin” column which is the year and semester of the
data. Once again, I do not expect anyone’s data to be in the same
format, but this might help someone combine scattered CSV files of
different formats.

``` r
# make sure folder only contains CSVs you want to run the code on
files = list.files("SOC_files/")

# going to apply the function to each file and write a new csv in "clean_data" folder
# this loop will also get the "origin" column from the file name
# other users may have different file names and have to figure out how to get the origin
# column in the form "YYYYS" where s is 1, 2, 3 for spring, summer, fall
for (i in 1:length(files)){
  table = read.csv(paste0("SOC_files/", files[i]), header=TRUE) # load file
  out <- clean_file(table) # clean the file
  out$origin = NA #create origin column
  file_name = files[i] #grab the name of the file that starts with YYYYS
  term = substr(file_name, 1, 5) # grab just the first 5 digits to be used in the origin
  out$origin = term
  name = paste0("clean_data/", term, ".csv") # will change this to actually be the year output format
  write.csv(out, file = name, row.names = FALSE)
}
```

In the next R file, `cleaning_2020-2023.R`, we read in the combined
clean CSV and reformat it. We change column names, count the number of
students and sections for each section, cut out research courses, and we
create the “semester,” “all_semesters,” and “course_level” columns. To
see this code please see the R script.

There is an R script in the same directory that shows you how to add a
course to the dataframe `adding_course.R`. All you need to remember for
adding a course in this way is that you include ALL COLUMNS when adding
new entries – otherwise the data will be messy.

## Cleaning Course Descriptions

Once we have the cleaned dataframe with correct column names, we now
clean the course descriptions to increase the accuracy of the mapping we
will perform to the keyword list. If you navigate to
`cleaning_course_descriptions.R`, you will see what appears to be a
daunting 600-line R script – do not be scared. This file corrects
context-dependency issues that lead to inaccurate mappings of courses to
SDGs. For example, courses with the phrases “business environment” or
“learning environment” should not be mapped to the word “environment”
and its related SDGs.

The first thing we do is create a new column “clean_course_desc” which
holds the course description of the class but **excluding punctuation.**
By exluding punctuation (except for apostraphes), we ensure there are no
problems mapping words that come before a comma or period or other
punctuation. Code to achieve this is shown below:

``` r
# column to hold cleaned course description
usc_courses["clean_course_desc"] = NA

# put the clean version of course_desc in new column without punctuation, except for '
for (i in 1:nrow(usc_courses)){
  desc = usc_courses$course_desc[i]
  desc_clean = gsub("[^[:alnum:][:space:]']", " ", desc)
  desc_spaces = str_squish(desc_clean)
  usc_courses$clean_course_desc[i] = desc_spaces
}
```

To account for context dependencies either before a word or after a
word, follow the model in the file, and ensure to convert words to
lowercase and trim whitespace.
