
# ge_data = read.csv("ge_data.csv")

sdg_colors <- c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2', 
                         '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
                         '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')

classes = read.csv("master_course_sdg_data.csv")

users = c("DES-323")

classes = classes %>% filter(courseID %in% users) %>% select(semester, courseID, keyword, goal, weight, color)

# class data is the master data filtered to only users classes
create_bar = function(class_data){
  
  sdg_class_keyword_colors <- classes %>%
    filter(courseID %in% users) %>%
    group_by(goal) %>%
    # mutate(sum_weight = sum(weight)) %>%
    # arrange(desc(sum_weight)) %>%
    ungroup() %>%
    distinct(goal, .keep_all = TRUE) %>%
    arrange(goal) %>%
    select(color) %>%
    unique() %>%
    pull()
  
  courses = unique(class_data$courseID)
  goals = unique(class_data$goal)
  df = data.frame()
  weights = numeric(length(goals))
  for (course in courses){
    course_df = class_data[class_data$courseID == course, ]
    # just grab one semester where the class is offered
    sem = unique(course_df$semester)[1]
    # subet data to only that semester
    course_df = course_df[course_df$semester == sem, ]
    df = rbind(df, course_df)
  }
  # print(df)
  # extract just one semester of the data to make things easier
  # sem = unique(class_data$semester)[1]
  for (i in 1:length(goals)){
    g = goals[i]
    mini_df = df[df$goal == g, ]
    weights[i] = sum(mini_df$weight)
  }
  result = data.frame(goal = goals, sum_weight = weights)
  result = result %>% arrange(desc(sum_weight))
  
  goal_cols = goals[c(goals)]
  print(result)
  result %>% ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
    geom_col() +
    coord_flip() +
    # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
    labs(title = paste0("All Classes"),
         fill = "SDG",
         x = "SDG",
         y = "Total SDG Weight") +
    theme(text = element_text(size = 20, face="bold")) +
    guides(alpha = FALSE) +
    scale_fill_manual(values = sdg_class_keyword_colors) +
    scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
  
}


create_bar(classes)



unique(x$goal)
x$goal
# here is basic gg
ggplot() + geom_col(data = Titanic, aes(x = Class, y = Freq))


# here was ours
ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
  geom_col() +
  coord_flip() +
  # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
  labs(title = paste0("All Classes"),
       fill = "SDG",
       x = "SDG",
       y = "Total SDG Weight") +
  theme(text = element_text(size = 20, face="bold")) +
  guides(alpha = FALSE) +
  scale_fill_manual(values = sdg_class_keyword_colors) +
  scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))





sdg_class_keyword_colors <- classes %>%
  filter(courseID %in% users) %>%
  group_by(goal) %>%
  # mutate(sum_weight = sum(weight)) %>%
  # arrange(desc(sum_weight)) %>%
  ungroup() %>%
  distinct(goal, .keep_all = TRUE) %>%
  arrange(goal) %>%
  select(color) %>%
  unique() %>%
  pull()
  
if (length(sdg_class_keyword_colors) == 0) {return(ggplot())}
  
# sdg_class_goal_barplot <- 
classes %>%
  filter(courseID %in% users) %>%
  group_by(courseID, semester, goal) %>%
  mutate(sum_weight = sum(weight)) %>%
  ungroup() %>%
  distinct(goal, keyword, .keep_all = TRUE) %>% select(courseID, goal, color, weight, sum_weight) %>%
  # group_by(goal) %>%
  mutate(sum_weight = sum(weight)) %>%
  arrange(desc(sum_weight)) %>%
  ungroup() %>%
  # distinct(goal, .keep_all = TRUE) %>% 
  ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
  geom_col() +
  coord_flip() +
  # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
  labs(title = paste0("All Classes"),
       fill = "SDG",
       x = "SDG",
       y = "Total SDG Weight") +
  theme(text = element_text(size = 20, face="bold")) +
  guides(alpha = FALSE) +
  scale_fill_manual(values = sdg_class_keyword_colors) +
  scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))


classes %>% filter(courseID %in% users) %>% filter(semester=="SP19") %>% select(semester, courseID, keyword, goal, color)





sdg_weights 

test = data.frame(goal = c(9,11,12,16), sum_weight=c(7, 2,2,1))

  test %>% ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
  geom_col() +
  coord_flip() +
  # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
  labs(title = paste0("All Classes"),
       fill = "SDG",
       x = "SDG",
       y = "Total SDG Weight") +
  theme(text = element_text(size = 20, face="bold")) +
  guides(alpha = FALSE) +
  scale_fill_manual(values = sdg_class_keyword_colors) +
  scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))


test$sum_weight %>% arrange()




# ge_data %>%
#   filter(full_name == "B - Humanistic Inquiry") %>%
#   group_by(courseID, semester) %>%
#   mutate(total_weight = sum(weight)) %>%
#   arrange(desc(total_weight)) %>%
#   ungroup() %>%
#   distinct(courseID, .keep_all = TRUE) %>%
#   rename('Course ID' = courseID, Semester = semester, "Course Title" = course_title.x, 'Total SDG Weight'= total_weight, "Course Description" = course_desc) %>%
#   select('Course ID', "Course Title", "Course Description", "Total SDG Weight")

