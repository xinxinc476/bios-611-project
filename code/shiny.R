library(shiny)
library(tidyverse)
library(plotly)

data <- read.csv('derived_data/marketing_campaign_clean.csv') %>% as_tibble()
data$expenditure <- data$mntwines+data$mntfruits+data$mntmeatproducts+data$mntfishproducts+data$mntsweetproducts+data$mntgoldprods
  
data <- data %>% select(c(days_enrollment, income, expenditure))
data_scale <- as_tibble(scale(data))

#UI
ui <- fluidPage(
  titlePanel("Clustering of customers based on the number of days since enrollment, income, and expenditure"),
  fluidRow(
    column(4,
           sliderInput(inputId = "k", label = "Number of clusters:",
                       min = 1, max = 5, value = 3)
    ),
    column(8,
           selectInput(inputId = "p", label = "Type of plots:",
                       choices = c("3D plot", "Box plots for each feature")))
  ),
  fluidRow(
    column(12,
           plotlyOutput(outputId = "plot"))
  ),
  fluidRow(
    column(12,
           dataTableOutput('table')
    )
  )
)

server <- function(input, output) {
  dataInput <- reactive({
    k = input$k
    res <- kmeans(data_scale, centers = k)
    data_res <- as_tibble(cbind(data, "cluster"=as.factor(res$cluster)))
    data_res
  })
  
  plot_box <- reactive({
    data_res <- dataInput()
    days_plot <- plot_ly(data_res, y = ~days_enrollment, color = ~cluster, colors = "Pastel1", type = "box")
    expenditure_plot <- plot_ly(data_res, y = ~expenditure, color = ~cluster, colors = "Pastel1", type = "box")
    income_plot <- plot_ly(data_res, y = ~income, color = ~cluster, colors = "Pastel1", type = "box")
    subplot(expenditure_plot, income_plot, days_plot, titleY = T, nrows=2) %>% layout(showlegend=F)
  })
  
  plot_3d <- reactive({
    data_res <- dataInput()
    plot_3d <- plot_ly(x= ~days_enrollment, y=~income, z=~expenditure, color = ~cluster, colors = "Pastel1", data = data_res) %>%
      add_markers() %>%
      layout(
        scene = list(xaxis=list(title = "# of days since enrollment"),
                     yaxis=list(title="income"),
                     zaxis=list(title="expenditure"))
      )
    
    plot_3d
  })
  
  output$plot <- renderPlotly({
    if(input$p=="3D plot"){
      plot_3d()
    }else{
      plot_box()
    }
  })
  
  output$table <- renderDataTable({
    data_res <- dataInput()
    d <- data_res %>% group_by(cluster) %>% summarise("average # of days since enrollment" = round(mean(days_enrollment)), "average income"= round(mean(income), 2), "average expenditure" = round(mean(expenditure),2))
    d
  })
  
}

shinyApp(ui = ui, server = server, 
         options = list(port=8788, host="0.0.0.0"))

