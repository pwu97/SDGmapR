# USC SHINY WEB APP
# BRIAN TINSLEY -- btinsley@usc.edu
# EXTENSION FROM PETER WU AT CMU

# require(devtools)
# install_github("lchiffon/wordcloud2")
# library(wordcloud2)

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
# install.packages("ggrepel")
library(ggrepel)
# install.packages("shinyWidgets")
library(shinyWidgets)

classes = read.csv("master_course_sdg_data.csv")

keywords = read.csv("usc_keywords.csv")

sdg_colors <- c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2', 
                '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
                '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')
                
goals <- c("1 - No poverty", "2 - Zero hunger", "3 - Good health and well-being", "4 - Quality education", "5 - Gender equality",
           "6 - Clean water and sanitation", "7 - Affordable and clean energy", "8 - Decent work and economic growth", "9 - Industry, innovation, and infrastructure", 
           "10 - Reduced inequalities", "11 - Sustainable cities and communities", "12 - Responsible consumption and production", "13 - Climate action",
           "14 - Life below water", "15 - Life on land", "16 - Peace, justice, and strong institutions", "17 - Partnership for the goals")

num_top_classes <- 10

# data for pie chart
sustainability_related = read.csv("usc_courses_full.csv")

# data for GE's
ge_data = read.csv("ge_data.csv")

# data for find classes by sdgs
classes_by_sdgs = read.csv("classes_by_sdgs.csv")

# for the ordering of GE's in dropdown
values = c("A", "B", "C",
           "D", "E", "F", "G", "H", "Category I", "Category II", "Category III", "Category IV", "Category V", "Category VI")
names = c("The Arts", "Humanistic Inquiry", "Social Analysis", "Life Sciences", "Physical Sciences",
          "Quantitative Reasoning", "Citizenship in a Diverse World", "Traditions and Historical Foundations", "Western Cultures and Traditions", "Global Cultures and Traditions", "Scientific Inquiry", "Science and Its Significance ",
          "Arts and Letters", "Social Issues")
key = data.frame(value = values, name = names)
key$full_name = paste(key$value, key$name, sep=" - ")
ge_names = key$full_name


# profvis({
# s = shinyApp(
### Begin Shiny App Code ###

# Define UI for application that draws a histogram
ui <- dashboardPage( skin="black",
                     
                     # Application title
                     dashboardHeader(title = "USC Sustainability Course Finder", titleWidth = 350),
                     
                     
                     dashboardSidebar(
                       width = 350,
                       sidebarMenu(
                         menuItem("About", tabName = "1"),
                         menuItem("FAQ", tabName = "2"),
                         menuItem("Map Your Courses", tabName = "3"),
                         menuItem("Find SDGs by Courses", tabName = "4"),
                         menuItem("Find Courses by SDGs", tabName = "5"),
                         menuItem("Search by GE Requirements", tabName = "6"),
                         menuItem("All Sustainability-Related Courses", tabName = "7"),
                         menuItem("Download Data", tabName = "downloaddata")
                         # menuItem("Sustainability Focused Programs", tabName="8")
                       )
                     ),
                     
                     dashboardBody( tags$head(tags$link(rel="stylesheet", type="text/css", href="custom.css"),
                                              tags$style(HTML(".main-sidebar { font-size: 20px; }"))), #link up css stylesheet
                                    tabItems(
                                      tabItem(tabName = "1",
                                              fluidPage(
                                                h1("About"),
                                                h3("Welcome to the USC Sustainability Course Finder\u2014a collaborative project from the 
                                                staff, faculty, and students of the University of Southern California and Carnegie 
                                                Mellon University. This tool allows users to identify USC courses which relate to the 
                                                17 United Nations Sustainable Development Goals (SDGs). With this information, students 
                                                can focus their studies in particular sustainability goals, and faculty can identify 
                                                ways to incorporate sustainability into their classes."),
                                                h3("This dashboard is a work in progress and will be improved through feedback and 
                                                   collaboration with faculty (", 
                                                   a("access the feedback form here", 
                                                   href = "https://forms.gle/keZXBY9uHa9DWsMg6", 
                                                   target="_blank", .noWS = "outside"),
                                                   "). To learn more about this tool visit the FAQ page."),
                                                br(),
                                                fluidRow(a(img(src="Education.png", height="550", style="display: block; margin-left: auto; margin-right: auto;"), 
                                                           href="https://sustainability.usc.edu/assignment-earth/", target="_blank")),
                                                h3(strong("Assignment: Earth"), "is USC’s Sustainability Framework for a greener campus and planet. It articulates our 
                                                         commitment to addressing the impacts of climate change and creating a more just, equitable, and 
                                                         sustainable future. It’s a big assignment. ", strong("We’re all in!")), br(),
                                                
                                                h1("Mapping the 17 SDGs"),
                                                h3("The SDGs were adopted by all United Nations Member States in 2015, providing a shared blueprint for peace and prosperity 
                                                   for people and the planet, now and into the future. The SDGs are an urgent call for action by all countries - developed and 
                                                   developing - in a global partnership. They recognize that ending poverty and other deprivations must go hand-in-hand with 
                                                   strategies that improve health and education, reduce inequality, and spur economic growth – all while tackling climate 
                                                   change and working to preserve our oceans and forests."), 
                                                   h3("Below displays a wordcloud for the keywords for each SDG. The keywords 
                                                   were edited by USC’s Office of Sustainability staff and interns as well as the USC Presidential Working Group. These keywords 
                                                   evolved from lists suggested by Elsevier and Carnegie Mellon University."),
                                
                                                # h3("Below displays a wordcloud for the top keywords for each SDG.
                                                #   The keywords come from the ", a("CMU250 keywords list,", href="https://github.com/CMUSustainability/SDGmapR/tree/main/data", target="_blank"), 
                                                #    "and the weights of the words relative to each SDG 
                                                #       were calculated using ",a("Google's word2vec.", href="https://code.google.com/archive/p/word2vec/", target="_blank"), "These word and weight 
                                                #        combinations are the criteria for the course mappings in the other pages of this website."),
                                                # h3("In the near future, this list will be updated to a USC and CMU combined list with the input of
                                                #              the PWG. To see the words in a CSV file format, please see the ",a("USC-SDGmap package.", href="https://github.com/USC-Office-of-Sustainability/USC-SDG-Curriculum", target="_blank")),
                                                h2("Select an SDG below to see its most relevant keywords."),
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                div(style="font-size:24px;",
                                                    selectizeInput(inputId = "sdg_goal3", label = "Choose SDG", choices = goals
                                                    )),
                                                tags$head(tags$style(HTML(".selectize-input {height: 45px; width: 450px; font-size: 24px;}"))),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "visualize_sdg"),br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%"))
                                                )),
                                                h2(strong("SDG Keywords Table")),
                                                fluidRow(bootstrapPage(
                                                  column(4, DT::dataTableOutput("keywords_table"))
                                                )), br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                                
                                              ) #end fluid page
                                      ), # end tabitem 1
                                      
                                      
                                      tabItem(tabName = "2",
                                              fluidPage(
                                                h2(strong("FAQ")),
                                                h3(strong("How do I use this dashboard?"), "You can choose your search function in 
                                 the main menu in the upper-left corner of this dashboard. 
                                 Here you can either find courses by the 17 different SDGs 
                                 (Find Courses by SDGs) or see which SDGs map to a selected course 
                                 (Find SDGs by Courses). To see how many courses at USC are sustainability-focused 
                                 or SDG-related, please click on the bottom menu option 
                                 ‘All Sustainability-Related Courses”."),
                                                
                                                h3(strong("How was this dashboard created?"), "This dashboard was created with R Shiny, based on source code in R through a 
                                              collaboration of USC’s Office of Sustainability (Source Code Developers: PSIP Intern- Brian Tinsley and Data Analyst- Dr. 
                                              Julie Hopper) with Carnegie Mellon University (Source Code Developers: Director of Sustainability Initiatives - Alex Hinicker 
                                              and Undergraduate Alumni - Peter Wu). Following the initial development of this dashboard, USC staff in the Office of 
                                              Sustainability and faculty in the Presidential Working Group (PWG) on Sustainability in Education reviewed the dashboard and 
                                              keywords. All of the datasets and source code used in this dashboard are open-source and can be found through", a("our
                                              Github page.", href="https://github.com/USC-Office-of-Sustainability/USC-SDGmap", target="_blank")),
                                                h3(strong("What are the UN’s 17 Sustainability Development Goals (SDGs)?"),
                                                   "The 2030 Agenda for Sustainable Development was adopted in 2015 by all UN member 
                                    states and provides a ‘blueprint for peace and prosperity for people and the planet, 
                                    now and into the future’. At the center of this are the 17 Sustainable Development
                                    Goals (SDGs). These goals acknowledge that ending poverty and other deprivations must
                                    accompany strategies that reduce inequality,  improve education and health, and 
                                    spur economic growth – all while working to preserve our natural ecosystems and 
                                    tackling climate change. To explore the 17 SDGs, 
                                    please visit ", a("their website.", href= "https://sdgs.un.org/goals#icons", target="_blank")),
                                                
                                                h3(strong("Which USC courses are included in this dashboard?"), "All USC courses except for \"Directed Research,\"
                                                   Master's Thesis,\" and \"Doctoral Dissertation\" courses. Although some courses do not map to the SDGs, they are still included
                                                   in data analysis. "),
                                                
                                                h3(strong("How often is this dashboard updated?"), "Data is updated at least once a semester after registration 
                                                is complete for the following semester, and more frequently upon feedback."),
                                                
                                                h3(strong("How are USC's courses mapped to the 17 SDGs?"), "Please visit our 
                                                   “Home” page to learn more."),
                                                
                                                h3(strong("I’m a faculty member, how can I use or provide feedback on this dashboard?"),
                                                   "It is our hope that this dashboard will be a useful tool for faculty who are looking 
                                                   for ways to incorporate sustainability into their courses by identifying potential 
                                                   connections between course topics and the UN SDGs. The dashboard is a work in progress 
                                                   and faculty feedback is critical in refining its accuracy and utility. If you have 
                                                   feedback or suggestions, please fill out", 
                                                   a("this form", href = "https://forms.gle/keZXBY9uHa9DWsMg6", target="_blank"), 
                                                   "or email us at oosdata@usc.edu."),
                                                
                                                h3(strong("I’d like to integrate sustainability into my courses. Where can I get help 
                                                          with this?"),
                                                   "If you’re interested in integrating sustainability into an existing course, contact 
                                                   the Office of Sustainability’s Experiential Learning Manager, Dr. Chelsea Graham at 
                                                   cmgraham@usc.edu."),
                                                
                                                h3(strong("What if I have more Questions/Comments or Suggestions?"), "Please fill out our ", a("feedback form.", 
                                                          href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                              ) #end fluidpage
                                      ), #end tabitem 2
                                      
                                      
                                      tabItem(tabName = "3",
                                              fluidPage(
                                                h1("Map Your Courses"),
                                                h3("Select your courses below and see how your curriculum relates to the 17 SDGs. Some courses
                                                   do not map to the SDGs via our keywords so those courses' mapping will be blank."), 
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                # h3("Enter Your USC Courses"),
                                                h4("Type in the course ID using the same format as this example: “ENST-150”"),
                                                div(style="font-size:24px;", selectizeInput(
                                                  inputId = "user_classes",
                                                  label = "Enter Your USC Courses by Course ID",
                                                  choices = "",
                                                  # choices = unique(sustainability_related$courseID), #changed this from master data
                                                  selected = NULL,
                                                  multiple = TRUE,
                                                  width = "100%",
                                                  options = list(
                                                    'plugins' = list('remove_button'),
                                                    'create' = TRUE,
                                                    'persist' = TRUE
                                                  )
                                                )),
                                                h3("SDG Mapping Data for:"),
                                                h4(textOutput("personal_classes")),
                                                br(),
                                                fluidRow(
                                                  column(6, plotOutput(outputId = "users_wordcloud"), br(),
                                                         plotOutput(outputId = "user_to_goals"), br()),
                                                  column(6, plotOutput(outputId = "user_classes_barplot"), img(src = "un_17sdgs.png", width="100%"), br())
                                                ),
                                                h2(strong("Your Courses")),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("user_table"))
                                                )), br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                              )#end fluid page
                                      ),# end tabitem 3
                                      
                                      
                                      tabItem(tabName = "4",
                                              # tabPanel("All", fluidPage(
                                              fluidPage(
                                                h1("Find SDGs by Courses"),
                                                h4(""),
                                                h3("Select a USC course ID below to view the SDG mapping for 
                          that particular course. If you cannot find a course you are looking for, then it did not map to any of the SDGs via our keyword list.
                                                   To check out the USC course catalogue, click ", a("here.", href="https://catalogue.usc.edu/", target="_blank")),
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                h4("Type in the course ID using the same format as this example: “ENST-150”"),
                                                div(style="font-size:24px;",selectizeInput(inputId = "usc_classes", 
                                                                                           label = "Choose USC Course by Course ID", 
                                                                                           choices = "",
                                                                                           width = "100%",
                                                                                           # choices = unique(classes$courseID),
                                                                                           options = list(maxOptions = 10000))),
                                                h3(textOutput("semesters_offered")),
                                                
                                                h5("*special topics courses (course levels 499 and 599) often change, but the course data comes from the
                                                   current semester for all courses."),
                                                
                                                br(),
                                                h3(strong("Course Title and Description:")),
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
                                                h2(strong("Keyword Table")),
                                                fluidRow(bootstrapPage(
                                                  column(4, DT::dataTableOutput("classes_table"))
                                                )), br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                                ) # end fluidpage
                                      ),#end tabitem 4
                                      
                                      
                                      tabItem(tabName = "5",
                                              fluidPage(
                                                h1("Find Courses by SDGs"),
                                                h3("Select USC departments and course levels, and then choose an SDGs to display the 10 most relevant USC courses that map to
                                                  that goal. To check out the USC course catalogue, click ", a("here.", href="https://catalogue.usc.edu/", target="_blank")),
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                # div(style="font-size:24px;", selectInput(inputId = "usc_semester3",
                                                #                                          label = "Choose USC Semester",
                                                #                                          selected = "SP23",
                                                #                                          choices = unique(classes$semester))),
                                                # tags$style("course_level_input {background-color:grey; color:red;}"),
                                                div(style="font-size:24px;", pickerInput(inputId = "department_input", 
                                                                                            label = "Choose Department", 
                                                                                            choices = unique(classes_by_sdgs$department) %>% sort(),
                                                                                            # choices = NULL,
                                                                                            selected = unique(classes_by_sdgs$department) %>% sort(),
                                                                                            options = list(maxOptions = 10000, `actions-box` = TRUE), multiple = T)),
                                                div(style="font-size:24px;", pickerInput(inputId = "course_level_input",
                                                                                        label = "Restrict course level?",
                                                                                        choices = c("All", "Undergrad lower division", "Undergrad upper division", "Graduate"),
                                                                                        options = list(height = 20))),
                                                                                        # choicesOpt = list(
                                                                                        # style = rep(("font-size:24px; line-height: 1.5;"),2)))),
                                                div(style="font-size:24px;", selectizeInput(inputId = "sdg_goal1", 
                                                                                            label = "Choose SDG", 
                                                                                            choices = goals
                                                )),
                                                br(),
                                                h2(strong(textOutput("top_classes"))),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "goals_to_classes"), br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%"))
                                                )),
                                                h2(strong(textOutput("sdg_name"))),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("top_classes_sdg_table"))
                                                )), br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                              ) #end fluidpage
                                      ), #end tabitem5
                                      
                                      tabItem(tabName="6",
                                              fluidPage(
                                                h1("Search by GE Requirements"),
                                                
                                                # h3("All students at USC are required to fulfill their general education (GE) requirements."),
                                                h3("Select a GE category below to see the sustainability related courses which satisfy that requirement. GE courses that
                                                   did not map to the SDGs via our keywords are not shown, but you can find them in the course catalogue ", a("here.", href="https://dornsife.usc.edu/2015ge/2015ge-requirements/")),
                                                
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                div(style="font-size:24px;",selectInput(inputId = "ge_category",
                                                                                        label = "Choose GE Category",
                                                                                        selected = "A - The Arts",
                                                                                        choices = ge_names)),
                                                tags$head(tags$style(HTML(".selectize-input {height: 50px; width: 500px;}"))),
                                                
                                                div(style="font-size:24px;", pickerInput(inputId = "ge_sdgs", 
                                                                                         label = "Choose SDGs", 
                                                                                         choices = seq(17),
                                                                                         selected = seq(17),
                                                                                         options = list(maxOptions = 10000, `actions-box` = TRUE), multiple = T)),
                                                
                                                br(), br(),
                                                h3(strong(textOutput("top_ge_chart"))),
                                                fluidRow(bootstrapPage(
                                                  column(6, plotOutput(outputId = "ge_bar"), br()),
                                                  column(6, img(src = "un_17sdgs.png", width = "100%")))),
                                                h1(strong(textOutput("ge_name"))),
                                                fluidRow(bootstrapPage(
                                                  column(12, DT::dataTableOutput("ge_table"))
                                                )), br(), br(),
                                                
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                              ) #end fluid page
                                      ), #end tabitem 6
                                      
                                      
                                      tabItem(tabName = "7",
                                              fluidPage(
                                                h1("All Sustainably-Related Courses"),
                                                h3("The below charts show the percent and number of USC courses that are ‘sustainability-focused’, ‘SDG-related’ or ‘not related’ to 
                                                sustainability, as well as the number and percent of departments that offer sustainability-focused or SDG-related courses. Note that there are often many sections
                                                   for an offered course."),
                                                h3("For a course to count as SDG-related, it has to include at least two SDG keywords. For a course to count as sustainability-focused, 
                                                   it has to map to a combination of SDGs that includes at least one environmental focused SDG (13, 14, 15) and at least one economic or social 
                                                   focused SDG (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17)."),
                                                h5("*This app is a work in progress, and we are continually improving accuracy. 
                                                             If you have feedback, please fill out our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target="_blank")),
                                                h4("Academic year determined by the year of the Spring semester and includes Summer and Fall terms of the previous calendar year. (AY23 = SU22, F22, SP23)"),
                                                div(style="font-size:24px;",selectInput(inputId = "usc_year",
                                                                                        label = "Choose USC Academic Year",
                                                                                        selected = "AY23",
                                                                                        choices = unique(sustainability_related$year))),
                                                div(style="font-size:24px;", pickerInput(inputId = "course_level_pie",
                                                                                         label = "Restrict course level?",
                                                                                         choices = c("All", "Undergraduate", "Graduate"),
                                                                                         options = list(height = 20))), br(),
                                                # choicesOpt = list(
                                                # style = rep(("font-size:24px; line-height: 1.5;"),2)))),
                                                
                                                fluidRow(column(6, 
                                                                h2("Sustainability Related Courses Offered"),
                                                                plotOutput("pie4")),
                                                         column(6, 
                                                                h2("Sustainability Related Departments"),
                                                                plotOutput("pie3"))),
                                                # textOutput("pie4_numbers")
                                                h2(strong("Department Sustainability Classification Table")),
                                                fluidRow(column(12, DT::dataTableOutput("sustainability_table"))), 
                                                br(), br(),
                                                h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                                   "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                                   "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating", 
                                                   a("here.", href="https://sustainability.usc.edu/give-now/", target="_blank"),"More questions or suggestions in regard to this tool? 
                                                   Please fill our our ", a("feedback form.", href="https://forms.gle/5THrD6SkTvbdgj8XA", target = "_blank")),
                                              ), # end fluid page
                                      ), # end tabitem 7
                                      tabItem(tabName="downloaddata",
                                              fluidPage(
                                                h1("Download Data"),
                                                downloadButton("download_data_table", "Download"),
                                                fluidRow(column(12, DT::dataTableOutput("view_data_table")))
                                              )
                                              ) # end tabitem

                                      # tabItem(tabName="8",
                                      #         fluidPage(
                                      #           h1("Sustainability-Focused Programs"),
                                      #           h3("Stay connected by visiting our home page at ", a("https://sustainability.usc.edu", href="https://sustainability.usc.edu", target="_blank"), 
                                      #              "or by following the Office of Sustainability on social media via", a("instagram", href="https://www.instagram.com/green.usc/?hl=en", target="_blank"), 
                                      #              "or", a("twitter.", href="https://twitter.com/GreenUSC", target="_blank"), "You can also support the Office of Sustainability by donating here. More questions or suggestions in 
                                      #                       regard to this tool? Please contact: ", a("oosdata@usc.edu.", href="mailto:oosdata@usc.edu"))
                                      #         ), #end fluid page
                                      # ) #end tabitem 8
                                      
                                      
                                )#end tabitems
                     )#end dashboard body
) #end UI
############ EDIT COMMA OUT HERE #####


# Define server logic
server <- function(input, output, session) {
  
  ## updating inputs to speed up program
  updateSelectizeInput(session, 'usc_classes', choices = unique(classes$courseID), selected = "ENST-150", server = TRUE)
  # map classes in ascending order
  updateSelectizeInput(session, 'user_classes', choices = unique(sustainability_related$courseID) %>% sort(), server = TRUE)
  
  
  #####
  ##
  ##### tabitem1 -- home(about) and MAPPING THE 17 SDGS ###
  ##
  #####
  
  
  output$visualize_sdg <- renderImage({
    sdg_goal_keyword_df <- classes %>%
      filter(goal %in% as.numeric(substr(input$sdg_goal3, 1, 2))) %>%
      select(keyword) %>%
      group_by(keyword) %>%
      mutate(count = n()) %>%
      distinct()
    png("wordcloud.png")
    wordcloud(words = sdg_goal_keyword_df$keyword, 
              freq = sdg_goal_keyword_df$count,
              min.freq = 1, max.words = 50, random.order = FALSE, rot.per = 0, 
              scale = c(8,1),
              colors = sdg_colors[as.numeric(substr(input$sdg_goal3, 1, 2))])
    dev.off()
    filename <- normalizePath(file.path("wordcloud.png"))
    list(src = filename, height = "100%")
    # sdg_goal_keyword_df <- classes %>%
    #   filter(goal %in% as.numeric(substr(input$sdg_goal3, 1, 2))) %>%
    #   distinct(keyword, .keep_all = TRUE) %>%
    #   arrange(desc(weight))
    #   # filter(!(keyword %in% exclude_words))
    # 
    # sdg_goal_keyword_wordcloud <- wordcloud(sdg_goal_keyword_df$keyword, 
    #                                         sdg_goal_keyword_df$weight,
    #                                         max.words=20, rot.per = 0, colors = sdg_colors[as.numeric(substr(input$sdg_goal3, 1, 2))], scale=c(2,1))
    # 
    # return(sdg_goal_keyword_wordcloud)
  }, deleteFile = TRUE)
  
  #sdg keywords table
  output$keywords_table <- DT::renderDataTable({
    keywords %>%
      # filter(!(keyword %in% exclude_words)) %>%
      filter(goal == as.numeric(substr(input$sdg_goal3, 1, 2))) %>%
      rename(Keyword = keyword,
             SDG = goal) %>%
      select(Keyword) %>%
      distinct()
  }, rownames=FALSE)
  
  
  
  
  
  
  #####
  ##
  ##### tabitem3 -- MAP YOUR CLASSES ###
  ##
  ##### 
  
  
  # get the courses
  output$personal_classes <- renderText({
    if (length(input$user_classes) > 0){ #first make sure they typed something in
      
      class_list <- sustainability_related %>% #changed this from master
        filter(courseID %in% input$user_classes) %>% #changed from section
        distinct(courseID, .keep_all = TRUE) %>%
        select(courseID) %>%
        unique() %>%
        pull()
      return(paste(class_list, collapse = ", "))
    }
  })
  
  # wordcloud for users classes
  output$users_wordcloud <- renderPlot({
    df = classes_by_sdgs[classes_by_sdgs$courseID %in% input$user_classes, ]
    
    sdg_class_keyword_colors <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$user_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(color) %>%
      pull()
    
    sdg_class_keyword_weights <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$user_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      mutate(weight = 100 * weight) %>%
      select(weight) %>%
      pull()
    
    sdg_class_keywords <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$user_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(keyword) %>%
      pull()
    
    if (length(sdg_class_keywords) == 0) {
      return(ggplot())
    }
    # data = data.frame(sdg_class_keywords, sdg_class_keyword_weights)
    # wordcloud2(data, color = sdg_class_keyword_colors,
    #            ordered.colors = TRUE)
    sdg_class_keyword_wordcloud <- wordcloud(sdg_class_keywords,
                                             sdg_class_keyword_weights,
                                             colors = sdg_class_keyword_colors,
                                             ordered.colors = TRUE, scale=c(3,1))
    
    return(sdg_class_keyword_wordcloud)
  })
  
  # output for users classes
  output$user_classes_barplot <- renderPlot({
    create_bar = function(class_data){
      
      sdg_class_keyword_colors <-  classes %>%
        filter(courseID %in% input$user_classes) %>%
        arrange(goal) %>% #arranged in order again because multiple classes screwed it up
        select(color) %>%
        unique() %>%
        pull()
      
      sdg_class_name <-  classes %>%
        filter(courseID %in% input$user_classes) %>%
        select(courseID) %>% 
        unique() %>%
        pull()
      
      if (length(sdg_class_keyword_colors) == 0) {return(ggplot())}
      
      courses = unique(class_data$courseID)
      goals = unique(class_data$goal)
      df = data.frame()
      weights = numeric(length(goals))
      for (course in courses){
        course_df = class_data[class_data$courseID == course, ]
        # just grab one semester where the class is offered
        if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
          sem = "SP23"
        }
        else{ # if no spring 23 just grab the last semester in df
          sem = unique(course_df$semester)[length(unique(course_df$semester))]
        }
        # sem = unique(course_df$semester)[1]
        # subet data to only that semester
        course_df = course_df[course_df$semester == sem, ]
        df = rbind(df, course_df)
      }
      
      result <- df %>%
        filter(courseID %in% input$user_classes) %>%
        # distinct(goal, keyword, .keep_all = TRUE) %>%
        arrange(desc(weight)) %>%
        ggplot(aes(x = reorder(keyword, weight), y = weight, fill = factor(as.numeric(goal)))) +
        geom_col() +
        coord_flip() +
        labs(title = paste0("All SDG Keywords"),
             fill = "SDG",
             x = "SDG Keyword",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold")) +
        scale_fill_manual(values = sdg_class_keyword_colors) + 
        scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      
      return(result)
    }
    classes = classes %>% filter(courseID %in% input$user_classes) %>% select(semester, courseID, keyword, goal, weight, color)
    create_bar(classes)
  })
  
  
  # user to goals barplot
  output$user_to_goals <- renderPlot({
    create_bar = function(class_data){
      
      sdg_class_keyword_colors <- classes %>%
        filter(courseID %in% input$user_classes) %>%
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
      
      courses = unique(class_data$courseID)
      goals = unique(class_data$goal)
      df = data.frame()
      weights = numeric(length(goals))
      for (course in courses){
        course_df = class_data[class_data$courseID == course, ]
        # just grab one semester where the class is offered
        if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
          sem = "SP23"
        }
        else{ # if no spring 23 just grab the last semester in df
          sem = unique(course_df$semester)[length(unique(course_df$semester))]
        }
        # sem = unique(course_df$semester)[1]
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
      # print(result)
      
      barplot = result %>% ggplot(aes(x = reorder(goal, sum_weight), y = sum_weight, fill = factor(as.numeric(goal)))) +
        geom_col() +
        coord_flip() +
        # geom_hline(yintercept = c(10, 15), color = c("#ffc33c", "#00bc9e")) +
        labs(title = paste0("All SDGs Mapped to your Courses"),
             fill = "SDG",
             x = "SDG",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold")) +
        guides(alpha = FALSE) +
        scale_fill_manual(values = sdg_class_keyword_colors) +
        scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
      
      return(barplot)
    }
    classes = classes %>% filter(courseID %in% input$user_classes) %>% select(semester, courseID, keyword, goal, weight, color)
    create_bar(classes)
  })
  
  
  output$user_table <- DT::renderDataTable({
    # use this dataframe so the course descriptions still show for unmapped classes
    df = sustainability_related[sustainability_related$courseID %in% input$user_classes, ]
    # need to only grab one instance

    df %>% filter(courseID %in% input$user_classes) %>%
      distinct(courseID, .keep_all = TRUE) %>%
      rename("Course ID" = courseID, "Course Description" = course_desc, "All Goals" = all_goals, "Sustainability Classification" = sustainability_classification) %>%
      select("Course ID", "All Goals", "Sustainability Classification","Course Description") %>%
      unique(by=c("courseID"))
  }, rownames=FALSE)
  
  
  
  
  
  
  #####
  ##### tabitem4 -- FIND SDGS BY CLASSES ###
  #####
  
  
  
  #this returns a dataframe with the descriptions of all the classes the user selected
  output$course_desc <- renderText({
    course_df = classes[classes$courseID == input$usc_classes, ]
    # just grab one semester where the class is offered
    # cant figure out how to get the most recent semester so checking if sp23 available
    if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
      sem = "SP23"
    }
    else{ # if no spring 23 just grab the last semester in df
      sem = unique(course_df$semester)[length(unique(course_df$semester))]
    }
    # sem = unique(course_df$semester)[1]
    df = course_df[course_df$semester == sem, ]
    usc_course_desc <- df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID == input$usc_classes) %>% #changed from section
      distinct(section, .keep_all = TRUE) %>%
      select(course_desc) %>%
      pull()
    
    return(paste(usc_course_desc))
  })
  
  # writes out the semesters offered
  output$semesters_offered <- renderText({
    sems <- classes %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID == input$usc_classes) %>% #changed from section
      select(semester) %>% unique() %>% pull()
    
    result = paste(sems, collapse=", ")
    final = paste("Semesters offered: ", result)
    
    return(final)
  })
  
  #this part filters the classes by the semester chosen in input field
  # observeEvent(input$usc_semester1,
  #              {
  #                updateSelectizeInput(session, "usc_classes",
  #                                     server = TRUE,
  #                                     choices = sort(classes %>% filter(semester == input$usc_semester1) %>% select(courseID) %>% pull()), #change this section to course_
  #                                     # selected = unique(classes %>% filter(semester == input$usc_semester1) %>% select(courseID) %>% pull())[1])
  #                                     selected = "ENST-100")
  #                
  #              })
  
  # barplot for sdgs
  output$classes_to_goals <- renderPlot({
    course_df = classes[classes$courseID == input$usc_classes, ]
    # just grab one semester where the class is offered
    if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
      sem = "SP23"
    }
    else{ # if no spring 23 just grab the last semester in df
      sem = unique(course_df$semester)[length(unique(course_df$semester))]
    }
    # sem = unique(course_df$semester)[1]
    df = course_df[course_df$semester == sem, ]
    sdg_class_keyword_colors <- df %>%
      # filter(semester == input$usc_semester1) %>%
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
    
    sdg_class_name <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(courseID) %>%
      unique() %>%
      pull()
    # print(sdg_class_name)
    
    sdg_class_goal_barplot <- df %>%
      # filter(semester == input$usc_semester1) %>%
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
      labs(title = paste0("All SDGs Mapped to ", sdg_class_name),
           fill = "SDG",
           x = "SDG",
           y = "Total SDG Keyword Frequency") +
      guides(alpha = FALSE) +
      theme(text = element_text(size = 18, face= "bold")) +
      scale_fill_manual(values = sdg_class_keyword_colors) +
      scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
    
    return(sdg_class_goal_barplot)
  })
  
  
  # keyword to sdg barplot
  output$classes_to_keywords <- renderPlot({
    course_df = classes[classes$courseID == input$usc_classes, ]
    # just grab one semester where the class is offered
    if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
      sem = "SP23"
    }
    else{ # if no spring 23 just grab the last semester in df
      sem = unique(course_df$semester)[length(unique(course_df$semester))]
    }
    # sem = unique(course_df$semester)[1]
    df = course_df[course_df$semester == sem, ]
    
    sdg_class_keyword_colors <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(color) %>%
      unique() %>%
      pull()
    
    sdg_class_name <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      select(course_title) %>% #changes here
      unique() %>%
      pull()
    
    sdg_class_keyword_barplot <- df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      arrange(desc(weight)) %>%
      ggplot(aes(x = reorder(keyword, weight), y = weight, fill = factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() +
      labs(title = paste0(input$usc_classes, " SDG Keywords"),
           fill = "SDG",
           x = "SDG Keyword",
           y = "Total SDG Keyword Frequency") +
      scale_fill_manual(values = sdg_class_keyword_colors) +
      theme(text = element_text(size = 18, face= "bold")) +
      scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
    
    return(sdg_class_keyword_barplot)
  })

  
  # class to wordcloud
  output$classes_to_wordcloud <- renderPlot({
    course_df = classes[classes$courseID == input$usc_classes, ]
    # just grab one semester where the class is offered
    if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
      sem = "SP23"
    }
    else{ # if no spring 23 just grab the last semester in df
      sem = unique(course_df$semester)[length(unique(course_df$semester))]
    }
    # sem = unique(course_df$semester)[1]
    df = course_df[course_df$semester == sem, ]
    
    sdg_class_keyword_colors <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(color) %>%
      pull()
    
    sdg_class_keyword_weights <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      mutate(weight = 100 * weight) %>%
      select(weight) %>%
      pull()
    
    sdg_class_keywords <-  df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      distinct(keyword, .keep_all = TRUE) %>%
      select(keyword) %>%
      pull()
    
    if (length(sdg_class_keywords) == 0) {
      return(ggplot())
    }
    # data = data.frame(sdg_class_keywords, sdg_class_keyword_weights)
    # wordcloud2(data, color = sdg_class_keyword_colors,
    #            ordered.colors = TRUE)
    sdg_class_keyword_wordcloud <- wordcloud(sdg_class_keywords,
                                             sdg_class_keyword_weights,
                                             colors = sdg_class_keyword_colors,
                                             ordered.colors = TRUE, scale=c(3,1))
    
    return(sdg_class_keyword_wordcloud)
  })
  
  
  # data table at bottom
  output$classes_table = DT::renderDataTable({
    course_df = classes[classes$courseID == input$usc_classes, ]
    # just grab one semester where the class is offered
    if ("SP23" %in% unique(course_df$semester)){ #if sp23 is there just use that
      sem = "SP23"
    }
    else{ # if no spring 23 just grab the last semester in df
      sem = unique(course_df$semester)[length(unique(course_df$semester))]
    }
    # sem = unique(course_df$semester)[1]
    df = course_df[course_df$semester == sem, ]
    
    df %>%
      # filter(semester == input$usc_semester1) %>%
      filter(courseID %in% input$usc_classes) %>%
      rename(SDG = goal , Keyword = keyword) %>%
      select(Keyword, SDG)
  }, rownames=FALSE)
  
  
  
  
  
  
  #####
  ##### tabitem5 -- FIND CLASSES BY SDGS
  #####
  
  
  
  # trying to get Classes by SDGs table name
  output$sdg_name = renderText({
    paste("All Courses Mapped to SDG", input$sdg_goal1, sep="")
  })
  
  # title of graph
  output$top_classes = renderText({
    paste0("Top 10 Courses that Map to SDG", input$sdg_goal1)
  })
  
  #this part filters the departments by the semester chosen in input field
  # observeEvent(input$usc_semester3,
  #              {
  #                updatePickerInput(session=session,
  #                                  inputId = "department_input",
  #                                     # server = TRUE,
  #                                     
  #                                     choices = unique(sort(classes %>% filter(semester == input$usc_semester3) %>% select(department) %>% pull())),#change this section to course_
  #                                     selected = unique(classes %>% filter(semester == input$usc_semester3) %>% select(department) %>% pull()))
  #                                     # selected = "All")
  #                
  #              })
  
  # need to filter for these options based on input from input$course_level
  # "All", "Graduate", "Undergrad lower divison", "Undergrad upper division"
  # undergrad lower division
  # undergrad upper division
  # graduate
  
  output$goals_to_classes <- renderPlot({
    if (input$course_level_input == "All"){
      goals_to_classes_barplot <- classes_by_sdgs %>%
        # filter(semester == input$usc_semester3) %>%
        filter(department %in% input$department_input) %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        # filter(course_level == "graduate") %>%
        # {if (input$course_level_input == "Graduate") filter(course_level == "graduate")} %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>% 
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        ungroup() %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        head(num_top_classes)
        if (nrow(goals_to_classes_barplot) == 0){
          return(0)
        }
        goals_to_classes_barplot = goals_to_classes_barplot %>%
        ggplot(aes(x = courseID1, y = total_weight)) +
        # as.numeric(substr(input$sdg_goal1, 1, 2))
        geom_col(fill = sdg_colors[as.numeric(substr(input$sdg_goal1, 1, 2))], alpha = 1) +
        coord_flip() +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
        labs(
             x = "Course",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold"))
      
      # ggsave(plot = goals_to_classes_barplot, filename = paste0("sdg_", input$sdg_goal1, "_top_classes.pdf"),
      #        device = "pdf")
      return(goals_to_classes_barplot)
      
    }
    else if (input$course_level_input == "Graduate"){
      goals_to_classes_barplot <- classes_by_sdgs %>%
        # filter(semester == input$usc_semester3) %>%
        filter(department %in% input$department_input) %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        filter(course_level == "graduate") %>%
        # {if (input$course_level_input == "Graduate") filter(course_level == "graduate")} %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>%
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        ungroup() %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        head(num_top_classes)
        if (nrow(goals_to_classes_barplot) == 0){
          return(0)
        }
        goals_to_classes_barplot = goals_to_classes_barplot %>% 
        ggplot(aes(x = courseID1, y = total_weight)) +
        geom_col(fill = sdg_colors[as.numeric(substr(input$sdg_goal1, 1, 2))], alpha = 1) +
        coord_flip() +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
        labs(title = paste0("Top 10 Courses that Map to SDG", input$sdg_goal1),
             x = "Course",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold"))

      # ggsave(plot = goals_to_classes_barplot, filename = paste0("sdg_", input$sdg_goal1, "_top_classes.pdf"),
      #        device = "pdf")
      return(goals_to_classes_barplot)
    }
    else if(input$course_level_input == "Undergrad upper division"){
      goals_to_classes_barplot <- classes_by_sdgs %>%
        # filter(semester == input$usc_semester3) %>%
        filter(department %in% input$department_input) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(course_level == "undergrad upper division") %>%
        # {if (input$course_level_input == "Graduate") filter(course_level == "graduate")} %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>%
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        ungroup() %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        head(num_top_classes)
        if (nrow(goals_to_classes_barplot) == 0){
          return(0)
        }
        goals_to_classes_barplot = goals_to_classes_barplot %>%
        ggplot(aes(x = courseID1, y = total_weight)) +
        geom_col(fill = sdg_colors[as.numeric(substr(input$sdg_goal1, 1, 2))], alpha = 1) +
        coord_flip() +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
        labs(title = paste0("Top 10 Courses that Map to SDG", input$sdg_goal1),
             x = "Course",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold"))
      
      # ggsave(plot = goals_to_classes_barplot, filename = paste0("sdg_", input$sdg_goal1, "_top_classes.pdf"),
      #        device = "pdf")
      return(goals_to_classes_barplot)
    }
    else if(input$course_level_input == "Undergrad lower division"){
      goals_to_classes_barplot <- classes_by_sdgs %>%
        # filter(semester == input$usc_semester3) %>%
        filter(department %in% input$department_input) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(course_level == "undergrad lower division") %>%
        # {if (input$course_level_input == "Graduate") filter(course_level == "graduate")} %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>%
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        ungroup() %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        head(num_top_classes)
        if (nrow(goals_to_classes_barplot) == 0){
          return(0)
        }
        goals_to_classes_barplot = goals_to_classes_barplot %>%
        ggplot(aes(x = courseID1, y = total_weight)) +
        geom_col(fill = sdg_colors[as.numeric(substr(input$sdg_goal1, 1, 2))], alpha = 1) +
        coord_flip() +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
        labs(title = paste0("Top 10 Courses that Map to SDG", input$sdg_goal1),
             x = "Course",
             y = "Total SDG Keyword Frequency") +
        theme(text = element_text(size = 20, face="bold"))
      
      # ggsave(plot = goals_to_classes_barplot, filename = paste0("sdg_", input$sdg_goal1, "_top_classes.pdf"),
      #        device = "pdf")
      return(goals_to_classes_barplot)
    }
  })
  
  # table for sdgs to classes
  output$top_classes_sdg_table <- DT::renderDataTable({
    if (input$course_level_input == "All"){
      classes_by_sdgs %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(department %in% input$department_input) %>%
        # filter(semester == input$usc_semester3) %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>% 
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        rename('Course ID' = courseID,"Sustainability Classification" = sustainability_classification, Semester = semester, "Course Title" = course_title, 'Total SDG Keyword Frequency'= total_weight, "Course Description" = course_desc, "Semesters Offered" = all_semesters) %>%
        select('Course ID', "Total SDG Keyword Frequency", "Sustainability Classification", "Course Description", "Semesters Offered")
    }
    else if (input$course_level_input == "Undergrad lower division"){
      classes_by_sdgs %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        filter(department %in% input$department_input) %>%
        # filter(semester == input$usc_semester3) %>%
        filter(course_level == "undergrad lower division") %>%
        # left_join(classes %>% select(section, courseID), by = "section") %>% 
        # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
        group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        rename('Course ID' = courseID,"Sustainability Classification" = sustainability_classification, Semester = semester, "Course Title" = course_title, 'Total SDG Keyword Frequency'= total_weight, "Course Description" = course_desc, "Semesters Offered" = all_semesters) %>%
        select('Course ID', "Total SDG Keyword Frequency", "Sustainability Classification", "Course Description", "Semesters Offered")
    }
    else if (input$course_level_input == "Undergrad upper division"){
      classes_by_sdgs %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        filter(department %in% input$department_input) %>%
        # filter(semester == input$usc_semester3) %>%
        filter(course_level == "undergrad upper division") %>%
      # left_join(classes %>% select(section, courseID), by = "section") %>% 
      # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
      group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        rename('Course ID' = courseID,"Sustainability Classification" = sustainability_classification, Semester = semester, "Course Title" = course_title, 'Total SDG Keyword Frequency'= total_weight, "Course Description" = course_desc, "Semesters Offered" = all_semesters) %>%
        select('Course ID', "Total SDG Keyword Frequency", "Sustainability Classification", "Course Description", "Semesters Offered")
    }
    else if (input$course_level_input == "Graduate"){
      classes_by_sdgs %>%
        # filter(goal %in% input$sdg_goal1) %>%
        filter(goal %in% as.numeric(substr(input$sdg_goal1, 1, 2))) %>%
        filter(department %in% input$department_input) %>%
        # filter(semester == input$usc_semester3) %>%
        filter(course_level == "graduate") %>%
      # left_join(classes %>% select(section, courseID), by = "section") %>% 
      # mutate(full_courseID = paste0(courseID, " (", section, ")")) %>%
      group_by(courseID) %>%
        mutate(total_weight = sum(weight)) %>%
        mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
        arrange(desc(total_weight)) %>%
        distinct(courseID, .keep_all = TRUE) %>%
        rename('Course ID' = courseID,"Sustainability Classification" = sustainability_classification, Semester = semester, "Course Title" = course_title, 'Total SDG Keyword Frequency'= total_weight, "Course Description" = course_desc, "Semesters Offered" = all_semesters) %>%
        select('Course ID', "Total SDG Keyword Frequency", "Sustainability Classification", "Course Description", "Semesters Offered")
    }
  }, rownames=FALSE)
  
  # options = list(
  #     autoWidth = TRUE)
  #     # columnDefs = list(list(width = '200px', targets = "_all"))
  # )
  
  
  
  
  
  
  
  
  
  
  #####
  ##### tabitem6 -- GE requirements
  #####
  
  
  
  # stacked bar chart for GEs
  output$ge_bar <- renderPlot({
    # get the top 10 classes and total weights
    courses = ge_data %>%
      filter(full_name == input$ge_category) %>%
      filter(goal %in% input$ge_sdgs) %>%
      group_by(courseID, semester) %>%
      mutate(total_weight = sum(weight)) %>%
      arrange(desc(total_weight)) %>%
      ungroup() %>%
      mutate(courseID1 = fct_reorder(courseID, total_weight)) %>%
      distinct(courseID, .keep_all = TRUE) %>%
      head(num_top_classes) %>%
      # rename('Course ID' = courseID, Semester = semester, "Course Title" = course_title.x, 'Total SDG Keyword Frequency'= total_weight, "Course Description" = course_desc) %>%
      select(courseID, total_weight)
    if (nrow(courses) == 0){
      return(0)
    }
    ids = courses$courseID
    #create empty dataframe 
    x = data.frame()
    for (i in 1:length(ids)){
      # grab only data for category and sdgs
      d = ge_data[ge_data$full_name == input$ge_category, ]
      d = d[d$goal %in% input$ge_sdgs, ]
      # grab only one semester
      little_df = d[d$courseID == ids[i], ]
      if ("SP23" %in% unique(little_df$semester)){ #if sp23 is there just use that
        sem = "SP23"
      }
      else{ # if no spring 23 just grab the last semester in df
        sem = unique(little_df$semester)[length(unique(little_df$semester))]
      }
      # sem = unique(little_df$semester)[1]
      df = little_df[little_df$semester == sem, ]
      df = df %>% select(courseID, keyword, weight, goal, color)
      x = rbind(x, df)
      # colors = df %>% select(color) %>% unique() %>% pull()
    }
    x = x %>% left_join(courses, by="courseID") %>% mutate(courseID1 = fct_reorder(courseID, total_weight))
    # grab the colors
    cols = x %>%
      arrange(goal) %>%
      select(color) %>% 
      unique() %>% 
      pull()
    ge_plot = x %>% ggplot(aes(x = courseID1, y = weight, fill=factor(as.numeric(goal)))) +
      geom_col() +
      coord_flip() + 
      scale_fill_manual(values = cols) + 
      scale_x_discrete(labels = function(x) str_wrap(x, width = 30)) +
      labs(
        fill="SDG",
        x = "Course",
        y = "Total SDG Keyword Frequency") +
      theme(text = element_text(size = 20, face="bold"))
    
    return(ge_plot)
  })
  
  # title above the chart
  output$top_ge_chart = renderText({
    paste("Top 10 Courses that Map to ", input$ge_category)
  })
  
  # trying to get Classes by SDGs table name
  output$ge_name = renderText({
    paste("All GE Courses Mapped to ", input$ge_category, sep="")
  })
  
  output$ge_table <- DT::renderDataTable({
    ge_data %>%
      filter(full_name == input$ge_category) %>%
      filter(goal %in% input$ge_sdgs) %>%
      group_by(courseID, semester) %>%
      mutate(total_weight = sum(weight)) %>%
      arrange(desc(total_weight)) %>%
      ungroup() %>%
      distinct(courseID, .keep_all = TRUE) %>%
      rename('Course ID' = courseID, Semester = semester, "All Goals" = all_goals, 'Total SDG Keyword Frequency'= total_weight, "Sustainability Classification" = sustainability_classification, "Course Description" = course_desc) %>%
      select('Course ID', "Total SDG Keyword Frequency", "All Goals", "Sustainability Classification", "Course Description")
  }, rownames=FALSE)
  
  
  
  
  
  
  #####
  ##### tabitem7 -- ALL SUSTAINABILITY RELATED CLASSES ###
  #####
  
  
  # sustainability related departments pie chart
  output$pie3 <- renderPlot({
    if (input$course_level_pie == "All"){
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) 
    }
    else if (input$course_level_pie == "Undergraduate"){
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) %>% filter(course_level == "undergrad upper division" | course_level == "undergrad lower division")
    }
    else{
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) %>% filter(course_level == "graduate")
    }
    department = unique(pie_data$department)
    departments = data.frame(department)
    # split courses into df by department and see if theres focused course or not
    # total = length(departments$department)
    notrelated = 0
    inclusive = 0
    focused = 0
    for (i in 1:nrow(departments)){
      mini_df = pie_data[pie_data$department == departments$department[i], ]
      department_classifications = unique(mini_df$sustainability_classification)
      if ("Sustainability-Focused" %in% department_classifications){
        focused = focused + 1
        next
      }
      else if ("SDG-Related" %in% department_classifications){
        inclusive = inclusive + 1
        next
      }
      else{
        notrelated = notrelated + 1
      }
    }
    total_num = notrelated+inclusive+focused
    pie_data <- data.frame(group = c("Not Related", "SDG-Related", "Sustainability-Focused"),
                           value = c(notrelated,
                                     inclusive,
                                     focused),
                           proportion = c(round(notrelated/total_num*100, 1),
                                          round(inclusive/total_num*100, 1),
                                          round(focused/total_num*100, 1)))
    
    # compute positions of labels
    pie_data <- pie_data %>%
      arrange(desc(group)) %>%
      mutate(prop = value / sum(pie_data$value) * 100) %>%
      mutate(ypos = cumsum(prop) - 0.5 * prop )
    
    pie(pie_data$value,
        labels = paste0(pie_data$group,"\n (", pie_data$value, ", " , pie_data$proportion,"%)"),
        col = c("#990000", "#FFC72C", "#767676"),
        cex = 1.5, cex.main = 2, family = "sans")
  })
  
  # sustainability courses offered pie chart
  output$pie4 <- renderPlot({
    if (input$course_level_pie == "All"){
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) 
    }
    else if (input$course_level_pie == "Undergraduate"){
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) %>% filter(course_level == "undergrad upper division" | course_level == "undergrad lower division")
    }
    else{
      pie_data <- sustainability_related %>% filter(year %in% input$usc_year) %>% filter(course_level == "graduate")
    }
    notrelated = 0
    inclusive = 0
    focused = 0
    for (i in 1:nrow(pie_data)){
      if (pie_data$sustainability_classification[i] == "Not Related"){
        notrelated = notrelated + pie_data$N.Sections[i]
        # sum_notrelated = sum_notrelated + 1
        next
      }
      if (pie_data$sustainability_classification[i] == "SDG-Related"){
        inclusive = inclusive + pie_data$N.Sections[i]
        # sum_inclusive = sum_inclusive + 1
        next
      }
      if (pie_data$sustainability_classification[i] == "Sustainability-Focused"){ 
        focused = focused + pie_data$N.Sections[i]
        # sum_focused = sum_focused + 1
        next
      }
    }
    total_num = notrelated+inclusive+focused
    pie_data <- data.frame(group = c("Not Related", "SDG-Related", "Sustainability-Focused"),
                           value = c(notrelated,
                                     inclusive,
                                     focused),
                           proportion = c(round(notrelated/total_num*100, 1),
                                          round(inclusive/total_num*100, 1),
                                          round(focused/total_num*100, 1)))
    
    # compute positions of labels
    pie_data <- pie_data %>%
      arrange(desc(group)) %>%
      mutate(prop = value / sum(pie_data$value) * 100) %>%
      mutate(ypos = cumsum(prop) - 0.5 * prop )
    
    pie(pie_data$value,
        labels = paste0(pie_data$group,"\n (", pie_data$value, ", " , pie_data$proportion,"%)"),
        col = c("#990000", "#FFC72C", "#767676"),
        cex = 1.5, cex.main = 2, family = "sans")
    # vals=c(sum_notrelated, sum_focused, sum_inclusive)
    # labels=c(paste("Not Related (N=", sum_notrelated, ")", sep = ""), paste("Sustainability-Focused (N=", sum_focused, ")", sep=""), paste("SDG-Related (N=", sum_inclusive, ")", sep=""))
    # pie_labels <- paste0(round(100 * vals/sum(vals), 1), "%")
    # pie = data.frame(labels, vals)
    # ggplot(pie, aes(x = "", y = vals, fill = labels)) +
    #   geom_col(color = "black") +
    #   coord_polar(theta = "y") +
    #   # geom_text(aes(label = pie_labels), #changed
    #   #           position = position_stack(vjust = 0.5)) +
    #   geom_text(aes(label = pie_labels),
    #             fill = "white", color = "white", size = 7.5, fontface="bold",
    #             position = position_stack(vjust = 0.5),
    #             show.legend = FALSE) +
    #   scale_fill_manual(values = c("#767676", 
    #                                         "#FFC72C", "#990000")) +
    #                                           guides(fill = guide_legend(title = "Sustainability Classification")) + 
    #   # guides(color = guide_legend(override.aes = list(size = 10))) + 
    #   theme_void() + 
    #   theme(legend.key.size = unit(1.5, 'cm'), legend.text = element_text(size=20), legend.title = element_text(size=25))
  })
  
  # sustainability departments table
  output$sustainability_table <- DT::renderDataTable({
    pie_data <- sustainability_related %>% filter(year %in% input$usc_year)
    department = unique(pie_data$department) # theres 44 departments
    departments = data.frame(department)
    departments["sustainability"] = NA
    departments["focused_classes"] = NA
    for (i in 1:nrow(departments)){
      # grab the course data for this department
      mini_df = pie_data[pie_data$department == departments$department[i], ] # just noticed that some departments are NA
      # remove the classes with no department listed
      mini_df = mini_df[!is.na(mini_df$department),]
      department_classifications = unique(mini_df$sustainability_classification)
      if ("Sustainability-Focused" %in% department_classifications){
        departments[i, "sustainability"] = "Sustainability-Focused"
        # now grab the classes
        classes_df = mini_df[mini_df$sustainability_classification == "Sustainability-Focused", ]
        courses = unique(classes_df$courseID)
        departments[i, "focused_classes"] = paste(courses, collapse = ", ")
        next
      }
      else if ("SDG-Related" %in% department_classifications){
        departments[i, "sustainability"] = "SDG-Related"
        next
      }
      else{
        departments[i, "sustainability"] = "Not Related"
        next
      }
    }
    
    departments %>% 
      arrange(department) %>%
      rename (Department = department, "Sustainability Classification" = sustainability, "Sustainability-Focused Courses" = focused_classes) %>%
      select(Department, "Sustainability Classification", "Sustainability-Focused Courses")
  }, rownames=FALSE)
  
  # download data page
  output$download_data_table <- downloadHandler(
    filename = function() {"sustainability_data.csv"},
    content = function(fname) {
      write.csv(sustainability_related, fname, row.names = FALSE)
    }
  )
  output$view_data_table <- DT::renderDataTable({
    sustainability_related
  }, rownames=FALSE,
  options = list(
    scrollX = TRUE,
    autoWidth = TRUE
  ))
}

# Run the application 
shinyApp(ui = ui, server = server)

# ) # end shinyApp(
# runApp(s)
# }) ## end profvis(



