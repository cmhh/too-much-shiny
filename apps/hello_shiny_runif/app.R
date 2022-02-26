library(shiny)

ui <- fluidPage(
  titlePanel("Hello runif from Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "nobs",
        label = "Number of observations:",
        min = 1, max = 10000, value = 1000
      )
    ),
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    runif(input$nobs)
  })

  output$distPlot <- renderPlot({
    hist(
      data(), col = "#75AADB", border = "white",
      xlab = "x",
      main = "distribution of random uniform numbers")
    })
}

shinyApp(ui = ui, server = server)