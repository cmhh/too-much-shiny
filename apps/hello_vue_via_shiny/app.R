library(shiny)

shinyApp(
  ui = htmlTemplate("www/index.html"),
  server = function(input, output, session){}
)