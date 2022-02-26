shinyServer(function(input, output, session) {
  groups <- reactive({
    req(input$subject)
    unique(data[
      subject_code == input$subject,
      .(group_code, group_description)
    ])
  })

  series <- reactive({
    req(input$subject, input$group)
    unique(data[
      subject_code == input$subject & group_code == input$group,
      c("series_reference", sprintf("series_title_%d", 1:5)),
      with = FALSE
    ])
  })

  values <- reactive({
    req(input$subject, input$group, input$series)

    data[
      subject_code == input$subject & group_code == input$group &
        series_reference %in% input$series
    ]
  })

  observeEvent(groups(), {
    group_choices <- setNames(
      groups()$group_code,
      groups()$group_description
    )

    updateSelectizeInput(session, "group", choices = group_choices)
  })

  observeEvent(series(), {
    labels <- apply(series(), 1, function(z) {
      z[-1] |> (\(x) {x[x != ""]})() |> paste(collapse = ", ")
    })

    subject_choices <- setNames(
      series()$series_reference,
      sprintf("%s - %s", series()$series_reference, labels)
    )

    updateSelectizeInput(session, "series", choices = subject_choices)
  })

  output$plot <- renderPlotly({
    req(values())
    if (is.null(values())) return(NULL)
    if (nrow(values()) == 0) return(NULL)

    p <- ggplot(
      data = values(),
      aes(x = period, y = data_value, col = series_reference)
    ) +
      geom_line()

    ggplotly(p)
  })
})
