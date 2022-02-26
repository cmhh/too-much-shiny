shinyUI(fluidPage(
  titlePanel("Labour Market Time Series Data"),

  sidebarLayout(
    sidebarPanel(width = 4,
      selectizeInput(
        "subject", "select subject:", subject_choices
      ),
      selectizeInput(
        "group", "select group:", c()
      ),
      selectizeInput(
        "series", "select series:", c(), multiple = TRUE
      )
    ),

    mainPanel(width = 8,
      plotlyOutput("plot")
    )
  )
))
