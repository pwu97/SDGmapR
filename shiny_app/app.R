# USC SHINY WEB APP
# BRIAN TINSLEY
# EXTENSION FROM PETER WU AT CMU


# Run App with the Run App button at the top of the screen

library(tidyverse)
library(shiny)
library(shinydashboard)
# install.packages("plotly")
library(plotly)
# install.packages("wordcloud")
library(wordcloud)
# install.packages("DT")
library(DT)
# install.packages("ggplot2")
library(ggplot2)

# read in the filtered or unfiltered data
classes = read.csv("master_course_sdg_data_filtered.csv")

sdg_colors <- c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2', 
                '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
                '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')
exclude_words <- c() #this has already been accounted for in earlier files

# data for pie chart
sustainability_related = read.csv("usc_courses_full_filtered.csv")


### Begin Shiny App Code ###

# Define UI for application that draws a histogram
ui <- dashboardPage( skin="black",
                     
                     # Application title
                     dashboardHeader(title = "USC SDG Mapping"),
                     
                     
                     dashboardSidebar(
                       sidebarMenu( #will eventually add Schools to sdgs and sdgs to schools
                         menuItem("Home (About)", tabName = "6"),
                         menuItem("Mapping the 17 SDGs", tabName = "5"),
                         menuItem("Find SDGs by Classes", tabName = "1"),
                         menuItem("Find Classes by SDGs", tabName = "3"),
                         menuItem("All Sustainability-Related Classes", tabName = "2")
                       )
                     ),
                     
                     dashboardBody( tags$head(tags$link(rel="stylesheet", type="text/css", href="custom.css")), #link up css stylesheet
                                    tabItems(
                                      tabItem(tabName = "1",
                                              tabPanel("All", fluidPage(
                                                h1("Find SDGs by Classes"),
                                                h4(""),
                                                h3("Select a USC semester and course ID below to view the SDG mapping for 
                          that particular class. If the mapping is
                          blank, the course description may have been too short to draw
                          any concrete conclusions."),
                                                div(style="font-size:24px;", selectInput(inputId = "usc_semester1",
                                                                                         label = "Choose USC Semester",
                                                                                         # selected = "SP18",
                                                                                         choices = unique(classes$semester))),
                                                div(style="font-size:24px;",selectizeInput(inputId = "usc_classes", 
                                                                                           label = "Choose USC Class", 
                                                                                           # selected = "ACCT-525",
                                                                                           # choices = unique(classes$courseID),
                                                                                           choices = NULL,
                                                                                           options = list(maxOptions = 10000))),
                                                br(),
                                                h3(strong("Course description:")),
                                                h3(textOutput("course_desc")),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "classes_to_wordcloud"), br()),
                                                  column(6, plotOutput(outputId = "classes_to_keywords"), br())
                                                  # column(6, plotOutput(outputId = "test_run"), br())
                                                )),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "classes_to_goals"), br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%"))
                                                )),
                                                h1("Keyword Table"),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("classes_table"))
                                                ))
                                              ))
                                      ),#end tabitem
                                      tabItem(tabName = "3",
                                              fluidPage(
                                                h1("Find Classes by SDGs"),
                                                h3("Select a USC semester and one of the SDGs to display the 10 most relevant USC classes that map to
                           that goal."),
                                                div(style="font-size:24px;", selectInput(inputId = "usc_semester3",
                                                                                         label = "Choose USC Semester",
                                                                                         # selected = "SU18",
                                                                                         choices = unique(classes$semester))),
                                                div(style="font-size:24px;", selectizeInput(inputId = "sdg_goal1", 
                                                                                            label = "Choose SDG", 
                                                                                            choices = c(1:17)
                                                )),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "goals_to_classes"), br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%"))
                                                )),
                                                h1(textOutput("sdg_name")),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("top_classes_sdg_table"))
                                                ))
                                              )
                                      ), #end tabitem2
                                      tabItem(tabName = "5",
                                              fluidPage(
                                                h1("Mapping the 17 SDGs"),
                                                h3("Below displays a wordcloud for the top keywords for each SDG.
                           The keywords come from the ", a("CMU250 keywords list,", 
                                                           href="https://github.com/CMUSustainability/SDGmapR/tree/main/data"), "and the weights of the words relative to each SDG 
                           were calculated using ",a("Google's word2vec.", href="https://code.google.com/archive/p/word2vec/"), 
                                                   "These word and weight combinations are the criteria for the course mappings in the other pages of this website."),
                                                h3("In the near future, this list will be updated to a USC and CMU combined list with the input of
                           the PWG. To see the words in a CSV file format, please see the ",a("USC-SDGmap package.", href="https://code.google.com/archive/p/word2vec/")),
                                                h2("Select an SDG below to see its most relevant keywords by weight."),
                                                div(style="font-size:24px;",
                                                    selectizeInput(inputId = "sdg_goal3", label = "Choose SDG", choices = c(1:17)
                                                    )),
                                                tags$head(tags$style(HTML(".selectize-input {height: 40px; width: 400px; font-size: 24px;}"))),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "visualize_sdg"),br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%"))
                                                )),
                                                h1("SDG Keywords Table"),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("keywords_table"))
                                                ))
                                              )
                                      ), # end tab item 5
                                      tabItem(tabName = "6",
                                              fluidPage(
                                                h1("Home (About)"),
                                                fluidRow(bootstrapPage(
                                                  column(8, 
                                                         h3(strong("Are you interested in sustainability and the ",
                                                                   a("UN Sustainability Development Goals (SDGs)?", href="https://sdgs.un.org")), "If so, you have come to the right place! 
                           Sustainability incorporates protection for the environment, 
                           balancing a growing economy, and social responsibility to lead to an 
                           improved quality of life for current and future generations. Here, 
                           we have created a program in collaboration with Carnegie Mellon University 
                           to elevate awareness of sustainability in higher education.", strong("This 
                           dashboard is a tool that enables you to see which classes at USC 
                           relate to the 17 UN SDGs. If you are a student, you can use this 
                           tool to shape your education toward these sustainability goals.")),
                                                         br(),
                                                         h2(strong("FAQ")),
                                                         h3(strong("How Do I Use this Dashboard?"), "You can choose your search function in 
                                 the main menu in the upper-left corner of this dashboard. 
                                 Here you can either find classes by the 17 different SDGs 
                                 (Find Classes by SDG) or see which SDGs map to a selected class 
                                 (Find SDGs by Class). To see how many classes at USC are sustainability-focused 
                                 or sustainability-inclusive, please click on the bottom menu bottom 
                                 ‘All Sustainability-Related Classes”."),
                                                         
                                                         h3(strong("How was this dashboard created?"), "This dashboard was created with Rshiny, 
                                 based on source code in R through a collaboration of USC’s Office of Sustainability 
                                 (Source Code Developers: PSIP Intern- Brian Tinsley and Data Analyst- Dr. Julie Hopper) 
                                 with Carnegie Mellon University (Source Code Developers: Director of Sustainability 
                                 Initiatives - Alex Hinicker and Undergraduate Alumni - Peter Wu). CMU’s original 
                                 version of this program can be found at CMU SDG Mapping. All of the datasets and 
                                 source code used in this dashboard are open-source and can be found through our 
                                 Github page."),
                                                         
                                                         h3(strong("What are the UN’s 17 Sustainability Development Goals (SDGs)?"),
                                                            "The 2030 Agenda for Sustainable Development was adopted in 2015 by all UN member 
                                    states and provides a ‘blueprint for peace and prosperity for people and the planet, 
                                    now and into the future’. At the center of this are the 17 Sustainable Development
                                    Goals (SDGs). These goals acknowledge that ending poverty and other deprivations must
                                    accompany strategies that reduce inequality,  improve education and health, and 
                                    spur economic growth – all while working to preserve our natural ecosystems and 
                                    tackling climate change. To explore the 17 SDGs, 
                                    please visit: https://sdgs.un.org/goals#icons."),
                                                         
                                                         h3(strong("How are USC's classes mapped to the 17 SDGs?"), "Please visit our page 
                                    “Mapping the 17 SDGs” to learn more."),
                                                         
                                                         h3(strong("What if I have more Questions/Comments or Suggestions?"), "Please contact: oosdata@usc.edu"),
                                                         
                                                         
                                                  ), # end column
                                                  column(2, img(src="Education.png", width="500px"))
                                                )), #end bootstrap page and fluid page
                                              )
                                              #         h4("This application was developed in collaboration with Carnegie Melon
                                              #            University, and their version of this software can be found at ",
                                              #            a("CMU SDG Mapping", href = "https://cmusustainability.shinyapps.io/sdg-mapping/"), "."),
                                              #         h4("The ", a("United Nations Sustainable Development Goals", href="https://sdgs.un.org/")," are the core
                                              #            focuses of sustainability and this tool
                                              #            gives students the chance to shape their education toward these goals while 
                                              #            elevating awareness of sustainability in higher education."),
                                              #         h4("In this application, you can see the mapping between course titles and descriptions 
                                              #            to each the 17 SDG goals. The data includes USC classes offered in the 2019 academic year, but 
                                              #            academic years 2021 and 2022 will be added soon."),
                                              #         h4("All datasets and source code can be found through our ", 
                                              #            a("Github page.", href="https://github.com/USC-Office-of-Sustainability/USC-SDGmap"),"
                                              #            If you have comments, suggestions, questions, or feedback, please contact oosdata@usc.edu"),
                                              #         h4("Here are some awesome people...")
                                              # ),
                                              # fluidRow(bootstrapPage(
                                              #     column(2, img(src = "mick.pdf", width = 200)),
                                              #     column(2, img(src = "julie.png", width = 200)),
                                              #     column(2, img(src = "ellen.png", width = 200))
                                              # )),
                                              # br(),
                                              # h4("Note: this application is a work in progress and will soon look much cleaner :)")
                                      ), # end tab item 6
                                      tabItem(tabName = "2",
                                              fluidPage(fluidRow(
                                                h1("All Sustainably-Related Classes"),
                                                div(style="font-size:24px;",selectInput(inputId = "usc_year",
                                                                                        label = "Choose USC Academic Year",
                                                                                        # selected = "AY19",
                                                                                        choices = unique(sustainability_related$year))),
                                                # h3("Not including multiple sections"),
                                                # plotOutput("pie1"),
                                                # textOutput("pie1_numbers")
                                              ),
                                              # fluidRow(
                                              #   h3("Including multiple sections"),
                                              #   plotOutput("pie2"),
                                              #   textOutput("pie2_numbers")
                                              # ),
                                              # fluidRow(
                                              #   h3("By department"),
                                              #   plotOutput("pie3"),
                                              #   textOutput("pie3_numbers")
                                              # ),
                                              fluidRow(bootstrapPage(
                                                h3("Sustainability Related Courses Offered"),
                                                column(5, plotOutput("pie4")),
                                                # textOutput("pie4_numbers")
                                              )),
                                              fluidRow(bootstrapPage(
                                                h3("Sustainability Related Departments"),
                                                column(5, plotOutput("pie3")),
                                              )),
                                              h3("Sustainability Classification Table"),
                                              fluidRow(bootstrapPage(
                                                column(12, DT::dataTableOutput("sustainability_table"))
                                              ))
                                              ) # end fluid page
                                      ) # end tab item 6
                                    )#end tabitems
                     )#end dashboard body
                     
) #end UI


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  #this part filters the classes by the semester chosen in input field
  observeEvent(input$usc_semester1,
               {
                 updateSelectizeInput(session, "usc_classes",
                                      server = TRUE,
                                      choices = sort(classes %>% filter(semester == input$usc_semester1) %>% select(courseID) %>% pull()), #change this section to course_
                                      selected = unique(classes %>% filter(semester == input$usc_semester1) %>% select(courseID) %>% pull())[1])
                 
               })
  
  #this retunrs a dataframe with the descriptions of all the classes the user selected
  output$course_desc <- renderText({
    usc_course_desc <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID == input$usc_classes) %>% #changed from section
      distinct(section, .keep_all = TRUE) %>%
      select(course_desc) %>%
      pull()
    
    return(paste(usc_course_desc))
  })
  
  # trying to get Classes by SDGs table name
  output$sdg_name = renderText({
    paste("All Classes Mapped to SDG", input$sdg_goal1, sep="")
  })
  
  
  # not sure what this does yet
  # might need to go back and add the course title back in to display on the chart
  output$test_run <- renderPlot({
    sdg_class_keyword_colors <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>% #changed this from section
      group_by(goal) %>%
      mutate(sum_weight = sum(weight)) %>%
      arrange(desc(sum_weight)) %>%
      ungroup() %>%
      distinct(goal, .keep_all = TRUE) %>%
      arrange(goal) %>%
      select(color) %>%
      unique() %>%
      pull()
    # print(sdg_class_keyword_colors)
    # if (length(sdg_class_keyword_colors) == 0) {return(ggplot())}
    
    sdg_class_name <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(courseID) %>% # might need course title
      unique() %>%
      pull()
    # print(sdg_class_name)
    
    sdg_class_goal_barplot <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      group_by(goal) %>%
      mutate(sum_weight = sum(weight)) %>%
      arrange(desc(sum_weight)) %>%
      ungroup() %>%
      distinct(goal, .keep_all = TRUE) %>%
      ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() +
      # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
      labs(
        # title = paste0(sdg_class_name, " (", input$cmu_classes, ") ", "SDGs"),
        title = paste0(sdg_class_name, "\nSDGs"),
        fill = "SDG",
        x = "SDG",
        y = "Relevance Rating") +
      scale_fill_manual(values = sdg_class_keyword_colors) +
      theme(text = element_text(size = 10))
    
    sdg_class_keyword_colors <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(color) %>%
      unique() %>%
      pull()
    
    sdg_class_keyword_barplot <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      arrange(desc(weight)) %>%
      ggplot(aes(x = reorder(keyword, weight), y = weight, fill = factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() +
      labs(
        title = paste0(sdg_class_name, " (", input$usc_classes, ")\nSDG Keywords"),
        fill = "SDG",
        x = "SDG Keyword",
        y = "Relevance Rating") +
      scale_fill_manual(values = sdg_class_keyword_colors) +
      theme(text = element_text(size = 10))
    
    sdg_class_keyword_colors <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(color) %>%
      pull()
    
    sdg_class_keyword_weights <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      mutate(weight = 100 * weight) %>%
      select(weight) %>%
      pull()
    
    sdg_class_keywords <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(keyword) %>%
      pull()
    print(length(sdg_class_keywords))
    
    # if (length(sdg_class_keywords) == 0) {
    #   return(ggplot())
    # }
    
    sdg_class_keyword_wordcloud <- wordcloud(sdg_class_keywords, 
                                             sdg_class_keyword_weights,
                                             colors = sdg_class_keyword_colors,
                                             ordered.colors = TRUE)
    
    # library(gridExtra)
    # ggsave(grid.arrange(sdg_class_goal_barplot, sdg_class_keyword_barplot, nrow = 1),
    #        filename = paste0("class_plots/", input$cmu_classes, ".pdf"),
    #        height = 4,
    #        device = "pdf")
  })
  
  
  ### Classes Forward
  output$classes_to_goals <- renderPlot({
    sdg_class_keyword_colors <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      group_by(goal) %>%
      mutate(sum_weight = sum(weight)) %>%
      arrange(desc(sum_weight)) %>%
      ungroup() %>%
      distinct(goal, .keep_all = TRUE) %>%
      arrange(goal) %>%
      select(color) %>%
      unique() %>%
      pull()
    # print(sdg_class_keyword_colors)
    if (length(sdg_class_keyword_colors) == 0) {return(ggplot())}
    
    sdg_class_name <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(courseID) %>%
      unique() %>%
      pull()
    # print(sdg_class_name)
    
    sdg_class_goal_barplot <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      group_by(goal) %>%
      mutate(sum_weight = sum(weight)) %>%
      arrange(desc(sum_weight)) %>%
      ungroup() %>%
      distinct(goal, .keep_all = TRUE) %>%
      ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() +
      # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
      labs(title = paste0(sdg_class_name, " (", input$usc_classes, ") ", "SDGs"),
           fill = "SDG",
           x = "SDG",
           y = "Relevance Rating") +
      guides(alpha = FALSE) +
      scale_fill_manual(values = sdg_class_keyword_colors)
    
    return(sdg_class_goal_barplot)
  })
  
  
  
  output$classes_to_keywords <- renderPlot({
    sdg_class_keyword_colors <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(color) %>%
      unique() %>%
      pull()
    
    sdg_class_name <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(course_title) %>% #changes here
      unique() %>%
      pull()
    
    sdg_class_keyword_barplot <- classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      arrange(desc(weight)) %>%
      ggplot(aes(x = reorder(keyword, weight), y = weight, fill = factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() +
      labs(title = paste0(sdg_class_name, " (", input$usc_classes, ") ", "\nSDG Keywords"),
           fill = "SDG",
           x = "SDG Keyword",
           y = "Relevance Rating") +
      scale_fill_manual(values = sdg_class_keyword_colors)
    
    # ggsave(plot = sdg_class_keyword_barplot, filename = paste0(input$cmu_classes, "_top_goals.pdf"),
    #    device = "pdf")
    
    return(sdg_class_keyword_barplot)
  })
  
  
  output$classes_to_wordcloud <- renderPlot({
    sdg_class_keyword_colors <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(color) %>%
      pull()
    
    sdg_class_keyword_weights <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      mutate(weight = 100 * weight) %>%
      select(weight) %>%
      pull()
    
    sdg_class_keywords <-  classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(keyword) %>%
      pull()
    print(length(sdg_class_keywords))
    
    if (length(sdg_class_keywords) == 0) {
      return(ggplot())
    }
    
    sdg_class_keyword_wordcloud <- wordcloud(sdg_class_keywords, 
                                             sdg_class_keyword_weights,
                                             colors = sdg_class_keyword_colors,
                                             ordered.colors = TRUE, width=1,height=1)
    
    return(sdg_class_keyword_wordcloud)
  })
  
  
  
  output$classes_table = DT::renderDataTable({
    classes %>%
      filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      # rename(Keyword = keyword,
      #        `Keyword Weight` = weight,
      #        Semester = semester,
      #        `Course Number` = section,
      #        SDG = goal,
      #        `Course Department` = course_dept) %>%
      rename(SDG = goal) %>%
      select(SDG, keyword, weight, section, course_desc)
  }, rownames=FALSE)
  
  num_top_classes <- 10
  
  # this is for SDGs to classes, table item 3
  output$goals_to_classes <- renderPlot({
    goals_to_classes_barplot <- classes %>%
      filter(semester == input$usc_semester3) %>%
      filter(goal %in% input$sdg_goal1) %>%
      # left_join(classes %>% select(section, courseID), by = "section") %>% 
      # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
      group_by(section) %>%
      mutate(total_weight = sum(weight)) %>%
      ungroup() %>%
      mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
      arrange(desc(total_weight)) %>%
      distinct(courseID, .keep_all = TRUE) %>%
      head(num_top_classes) %>%
      ggplot(aes(x = courseID1, y = total_weight)) +
      geom_col(fill = sdg_colors[as.numeric(input$sdg_goal1)], alpha = 0.75) +
      coord_flip() +
      scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
      labs(title = paste0("Top 10 Classes that Map to SDG", input$sdg_goal1),
           x = "Course",
           y = "Relevance Rating") +
      theme(text = element_text(size = 20))
    
    # ggsave(plot = goals_to_classes_barplot, filename = paste0("sdg_", input$sdg_goal1, "_top_classes.pdf"),
    #        device = "pdf")
    return(goals_to_classes_barplot)
  })
  
  # table for sdgs to classes
  output$top_classes_sdg_table <- DT::renderDataTable({
    classes %>%
      filter(goal %in% input$sdg_goal1) %>%
      filter(semester == input$usc_semester3) %>%
      # left_join(classes %>% select(section, courseID), by = "section") %>% 
      # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
      group_by(section) %>%
      mutate(total_weight = sum(weight)) %>%
      mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
      arrange(desc(total_weight)) %>%
      distinct(courseID, .keep_all = TRUE) %>%
      rename(Semester = semester, SDG = goal) %>%
      select(courseID, section, total_weight, SDG)
  }, rownames=FALSE)
  # options = list(
  #     autoWidth = TRUE)
  #     # columnDefs = list(list(width = '200px', targets = "_all"))
  # )
  
  
  ### Visualize SDG Goals
  output$visualize_sdg <- renderPlot({
    sdg_goal_keyword_df <- classes %>%
      filter(goal %in% input$sdg_goal3) %>%
      mutate(weight = 100 * weight) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      arrange(desc(weight)) %>%
      filter(!(keyword %in% exclude_words))
    
    sdg_goal_keyword_wordcloud <- wordcloud(sdg_goal_keyword_df$keyword, 
                                            sdg_goal_keyword_df$weight,
                                            colors = sdg_colors[as.numeric(input$sdg_goal3)])
    
    return(sdg_goal_keyword_wordcloud)
  })
  
  
  #sdg keywords table
  output$keywords_table <- DT::renderDataTable({
    read_csv("cmu_usc_pwg_mapped.csv") %>%
      filter(!(keyword %in% exclude_words)) %>%
      filter(goal == input$sdg_goal3) %>%
      rename(Keyword = keyword,
             `Keyword Weight` = weight,
             SDG = goal) %>%
      select(SDG, Keyword, `Keyword Weight`)
  }, rownames=FALSE)
  
  
  output$pie1 <- renderPlot({
    pie_data <- sustainability_related # have not yet filtered by semester, need to add columns to dataframe
    # filter(semester == input$usc_semester_pie)
    nr = sum(pie_data$sustainability_classification == "Not Related")
    foc = sum(pie_data$sustainability_classification == "Focused")
    inc = sum(pie_data$sustainability_classification == "Inclusive")
    vals=c(nr, foc, inc)
    pie_labels <- paste0(round(100 * vals/sum(vals), 2), "%", labels=c(" Not Related", " Focused", " Inclusive"))
    result = pie(vals, labels = pie_labels, main="Proportion of Sustainability Related Courses (n=6461)")
    return(result)
  })
  
  output$pie1_numbers <- renderText({
    pie_data <- sustainability_related # have not yet filtered by semester, need to add columns to dataframe
    # filter(semester == input$usc_semester_pie)
    nr = sum(pie_data$sustainability_classification == "Not Related")
    foc = sum(pie_data$sustainability_classification == "Focused")
    inc = sum(pie_data$sustainability_classification == "Inclusive")
    vals=c(nr, foc, inc)
    return(paste("Not Related:", vals[1], "Focused:", vals[2], "Inclusive:", vals[3]))
  })
  
  
  output$pie2 <- renderPlot({
    pie_data <- sustainability_related # have not yet filtered by semester, need to add columns to dataframe
    sum_notrelated = 0
    sum_inclusive = 0
    sum_focused = 0
    for (i in 1:nrow(pie_data)){
      if (pie_data$sustainability_classification[i] == "Not Related"){
        sum_notrelated = sum_notrelated + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Inclusive"){
        sum_inclusive = sum_inclusive + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Focused"){
        sum_focused = sum_focused + pie_data$N.Sections[i]
      }
    }
    vals=c(sum_notrelated, sum_focused, sum_inclusive)
    pie_labels <- paste0(round(100 * vals/sum(vals), 2), "%", labels=c(" Not Related", " Focused", " Inclusive"))
    result = pie(vals, labels = pie_labels, main="Sustainability Related Classes (n=19539)")
    return(result)
  })
  
  output$pie2_numbers <- renderText({
    pie_data <- sustainability_related # have not yet filtered by semester, need to add columns to dataframe
    sum_notrelated = 0
    sum_inclusive = 0
    sum_focused = 0
    for (i in 1:nrow(pie_data)){
      if (pie_data$sustainability_classification[i] == "Not Related"){
        sum_notrelated = sum_notrelated + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Inclusive"){
        sum_inclusive = sum_inclusive + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Focused"){
        sum_focused = sum_focused + pie_data$N.Sections[i]
      }
    }
    vals=c(sum_notrelated, sum_focused, sum_inclusive)
    return(paste("Not Related:", vals[1], "Focused:", vals[2], "Inclusive:", vals[3]))
  })
  
  
  output$pie3 <- renderPlot({
    pie_data <- sustainability_related %>% filter(year %in% input$usc_year)
    department = unique(pie_data$department) # theres 179 departments
    departments = data.frame(department)
    # split courses into df by department and see if theres focused course or not
    total = length(departments$department)
    notrelated = 0
    inclusive = 0
    focused = 0
    for (i in 1:nrow(departments)){
      mini_df = pie_data[pie_data$department == departments$department[i], ]
      department_classifications = unique(mini_df$sustainability_classification)
      if ("Focused" %in% department_classifications){
        focused = focused + 1
        next
      }
      else if ("Inclusive" %in% department_classifications){
        inclusive = inclusive + 1
        next
      }
      else{
        notrelated = notrelated + 1
      }
    }
    vals=c(notrelated, focused, inclusive)
    labels=c("Not Related", "Focused", "Inclusive")
    pie = data.frame(labels, vals)
    # ggplot(pie, aes(x = "", y = vals, fill = labels)) +
    #   geom_col() +
    #   coord_polar(theta = "y")
    ggplot(pie, aes(x = "", y = vals, fill = labels)) +
      geom_col(color = "black") +
      # ggtitle("Title") +
      geom_text(aes(label = vals),
                position = position_stack(vjust = 0.5)) +
      coord_polar(theta = "y") +
      scale_fill_manual(values = c("#990000", 
                                   "#FFC72C", "#D3D3D3")) +
      theme_void()
    # pie_labels <- paste0(round(100 * vals/sum(vals), 2), "%", labels=c("Not Related", " Focused", " Inclusive"))
    # result = pie(vals, labels = pie_labels, main="Sustainability Related Departments (n=179)")
    # return(result)
  })
  
  output$pie3_numbers <- renderText({
    pie_data <- sustainability_related
    department = unique(pie_data$department) # theres 179 departments
    departments = data.frame(department)
    # split courses into df by department and see if theres focused course or not
    total = length(departments$department)
    notrelated = 0
    inclusive = 0
    focused = 0
    for (i in 1:nrow(departments)){
      mini_df = pie_data[pie_data$department == departments$department[i], ]
      department_classifications = unique(mini_df$sustainability_classification)
      if ("Focused" %in% department_classifications){
        focused = focused + 1
        next
      }
      else if ("Inclusive" %in% department_classifications){
        inclusive = inclusive + 1
        next
      }
      else{
        notrelated = notrelated + 1
      }
    }
    vals=c(notrelated, focused, inclusive)
    return(paste("Not Related:", vals[1], "Focused:", vals[2], "Inclusive:", vals[3]))
    
  })
  
  output$pie4 <- renderPlot({
    pie_data <- sustainability_related %>% filter(year %in% input$usc_year) 
    sum_notrelated = 0
    sum_inclusive = 0
    sum_focused = 0
    for (i in 1:nrow(pie_data)){
      if (pie_data$sustainability_classification[i] == "Not Related"){
        sum_notrelated = sum_notrelated + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Inclusive"){
        sum_inclusive = sum_inclusive + pie_data$N.Sections[i]
      }
      if (pie_data$sustainability_classification[i] == "Focused"){
        sum_focused = sum_focused + pie_data$N.Sections[i]
      }
    }
    vals=c(sum_notrelated, sum_focused, sum_inclusive)
    labels=c("Not Related", "Focused", "Inclusive")
    pie = data.frame(labels, vals)
    # ggplot(pie, aes(x = "", y = vals, fill = labels)) +
    #   geom_col() +
    #   coord_polar(theta = "y")
    ggplot(pie, aes(x = "", y = vals, fill = labels)) +
      geom_col(color = "black") +
      # ggtitle("Title") +
      geom_text(aes(label = vals),
                position = position_stack(vjust = 0.5)) +
      coord_polar(theta = "y") +
      scale_fill_manual(values = c("#990000", 
                                   "#FFC72C", "#D3D3D3")) +
      theme_void()
  })
  
  output$sustainability_table <- DT::renderDataTable({
    sustainability_related %>% filter(year %in% input$usc_year) %>%
      select(courseID, semester, all_goals, sustainability_classification)
  }, rownames=FALSE)
  
}

# Run the application 
shinyApp(ui = ui, server = server)