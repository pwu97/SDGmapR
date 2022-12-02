# adding and removing words to keyword list

words = read.csv("cmu_usc_pwg_SDG_Keywords_corrected_10_11_22 copy.csv")

wordsgoal3 = words[words$goal == 3, ]
max(wordsgoal3$weight)
mean(wordsgoal3$weight)

# wordsorder = wordsgoal3[order(-wordsgoal3$weight), ]


wordsgoal7 = words[words$goal == 7, ]
max(wordsgoal7$weight)
mean(wordsgoal7$weight)


wordsgoal8 = words[words$goal == 8, ]
max(wordsgoal8$weight)
mean(wordsgoal8$weight)


wordsgoal16 = words[words$goal == 16, ]
max(wordsgoal16$weight)
mean(wordsgoal16$weight)