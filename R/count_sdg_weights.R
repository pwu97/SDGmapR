
# library(SDGmapR) # will update this to our github 

# keyword list to be added
cmu_usc = read.csv("cmu_usc_pwg_mapped.csv")
count_sdg_weights <- Vectorize(function(text, sdg, keywords="elsevier100",
                                        count_repeats=FALSE) {
  # Initalize total weight
  tot_weight <- 0
  
  # Select the right keyword set
  if (keywords == "elsevier100") {
    goal_df <- elsevier100_keywords %>%
      filter(goal == sdg)
  } else if (keywords == "cmu_usc") { #add our dataset
    goal_df <- cmu_usc %>%
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
  goal_weights <- goal_df$weight
  
  # Add up the keyword weights
  for (idx in 1:nrow(goal_df)) { #add gsub here!
    if (str_detect(str_to_lower(text), goal_patterns[idx])) {
      if (count_repeats) {
        keyword_cnt <- str_count(str_to_lower(text), goal_patterns[idx])
        tot_weight <- tot_weight + keyword_cnt * goal_weights[idx]
      } else {
        tot_weight <- tot_weight + goal_weights[idx]
      }
    }
  }
  
  return (as.numeric(tot_weight))
})


