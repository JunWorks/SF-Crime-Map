shinyUI(navbarPage('San Francisco Violent Crime Analysis', 
           tabPanel('Crime stat',
             sidebarLayout(
               sidebarPanel(sliderInput("range", 
                                        "Range:", 
                                        min = 2003, 
                                        max = 2015, 
                                        value = c(2003, 2015),
                                        format="####"),
                            actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                            actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o")),
                            uiOutput("catControls")
                            ),
               
             mainPanel(
               tabsetPanel(
                 type = "tabs", 
                 tabPanel("Map", plotOutput("map", height = 640)), 
                 tabPanel("Year by year", plotOutput("byYear", width = 640)), 
                 tabPanel("Table", dataTableOutput('table'))
               )
             )
           )
          ),
          tabPanel('Read me',
                   mainPanel(
                     includeMarkdown("readme.md")
                   )
                   )
        )
             
)

