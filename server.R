library(ggmap)
library(ggplot2)
library(dplyr)
library(lubridate)
library(data.table)

crime <- fread("crime.csv", stringsAsFactors = F)

crime.sum <- crime %>%
  group_by(Category, year) %>%
  summarise(count = n())

Category <- sort(unique(crime$Category))
map <- get_map(location = 'san francisco', zoom = 13, source = "osm")

shinyServer(function(input, output, session) {
  values <- reactiveValues()
  values$Category <- Category[1:5]
  
  output$catControls <- renderUI({
    checkboxGroupInput('Category', 'Category', Category, selected=values$Category)
  })
  
  observe({
    if(input$clear_all == 0) return()
    values$Category <- c()
  })
  
  observe({
    if(input$select_all == 0) return()
    values$Category <- Category
  })
  
  crime.dt <- reactive({
    crime.dt <- crime %>%
      filter(year >= input$range[1], year <=input$range[2], Category %in% input$Category)
    
  })
  
  crime.sum <- reactive({
    crime.sum <- crime.dt() %>%
      group_by(Category, year) %>%
      summarise(count = n())
  })

  output$map <- renderPlot({
    if(is.null(input$Category)){return(NULL)}
    ggmap(map, extent = "device") + 
      stat_density2d(data=crime.dt(), aes(x=X, y=Y, fill = ..level.., alpha = ..level..), size = 0.05,
                     geom = "polygon") + scale_alpha_continuous(range=c(0.1,0.8), guide='none') +
      scale_fill_gradient('Violent Crime\nDensity', low = "black", high = "red")+
      theme(legend.key = element_blank(), legend.position=c(0.08, 0.5), strip.text.x = element_text(size=15)) + 
      facet_wrap(~ Category, ncol = 2)
    
  })
  
  output$byYear <- renderPlot({
    ggplot(data = crime.sum()) + 
      geom_line(aes(x= year, y = count, color = Category), size = 2) + theme_bw(18) +
      theme(legend.key = element_blank(), legend.position=c(0.2, 0.5)) +
      xlab('Year') + ylab('count') + ggtitle('SF Violent Crime by Year')
  })
  
  
  output$table <- renderDataTable(crime.sum())
  
})




