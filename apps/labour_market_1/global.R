library(shiny)
library(data.table)
library(ggplot2)
library(plotly)

data <- readRDS("../../data/labour_market.rds")

subjects <- unique(data[, .(subject_code, subject_description)])

subject_choices <- setNames(
  subjects$subject_code,
  sprintf("%s - %s", subjects$subject_code, subjects$subject_description)
)
