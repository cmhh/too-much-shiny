library(shiny)
library(data.table)
library(ggplot2)
library(plotly)
library(config)

service <- config::get("service")

subjects <- jsonlite::fromJSON(sprintf("%s/subjects", service))

subject_choices <- setNames(
  subjects$subject_code,
  sprintf("%s - %s", subjects$subject_code, subjects$subject_description)
)
