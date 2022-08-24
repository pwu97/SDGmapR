# tabulate_sdg_keywords function, wrtiten by Peter Wu

library(SDGmapR) # will update this to our github 

# keyword list to be added
# MAKE SURE TO RUN THIS LINE BEFORE THE FUNCTION!
cmu_usc = read.csv("cmu_usc_pwg_mapped.csv")

tabulate_sdg_keywords <- Vectorize(function(text, sdg, keywords="elsevier100",
                                            count_repeats=FALSE) {
  
  # Select the right keyword set
  if (keywords == "elsevier100") {
    goal_df <- elsevier100_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "cmu_usc") { #added this for our data set
    goal_df <- cmu_usc %>%
      filter(goal == sdg)
  } else if (keywords == "sdsn") {
    goal_df <- sdsn_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "elsevier") {
    goal_df <- elsevier_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "cmu250") {
    goal_df <- cmu250_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "cmu500") {
    goal_df <- cmu500_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "cmu1000") {
    goal_df <- cmu1000_keywords %>%
      filter(goal == sdg)
  } else {
    goal_df <- keywords %>%
      filter(goal == sdg)
  }
  
  if (nrow(goal_df) == 0) {
    return(c())
  }
  
  # Get the keywords and weights
  goal_patterns <- goal_df$pattern
  goal_keywords <- goal_df$keyword
  goal_weights <- goal_df$weight
  
  words <- c()
  # Get keywords in a vector
  for (idx in 1:nrow(goal_df)) {
    if ((str_detect(str_to_lower(text), goal_patterns[idx]))) {
      words <- c(words, goal_keywords[idx])
    }
  }
  
  return(words)
})
