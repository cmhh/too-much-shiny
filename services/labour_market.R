#* @apiTitle Labour market data service
#* @apiDescription Data service for HLFS, QES, and LCI time series data.

library(data.table)
data <- readRDS("../data/labour_market.rds")
subjects <- unique(data[, c("subject_code", "subject_description")])

#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Return complete set of subjects
#* @get /subjects
#* @serializer json
function() {
  subjects
}

#* Return complete set of groups for selected subject
#* @get /groups/<subjectCode>
#* @serializer json
function(subjectCode) {
  unique(data[
    subject_code == subjectCode,
    c("subject_code", "group_code", "group_description")
  ])
}

#* Return complete set of series references for selected subject and group
#* @get /series/<subjectCode>/<groupCode>
#* @serializer json
function(subjectCode, groupCode) {
  unique(data[
    subject_code == subjectCode & group_code == groupCode,
    c("subject_code", "group_code", "group_description",
      "series_reference", "units", "magnitude",
      sprintf("series_title_%d", 1:5)), with = FALSE
  ])
}

#* Return data for specific references
#* @param seriesReference:[string] Series reference, e.g. "HLFQ.SAA1AZ"
#* @get /values
#* @serializer json
function(seriesReference) {
  data[series_reference %in% seriesReference]
}

#* Return data for specific references
#* @param seriesReference:[string] Series reference, e.g. "HLFQ.SAA1AZ"
#* @get /values/<subjectCode>/<groupCode>
#* @serializer json
function(subjectCode, groupCode, seriesReference) {
  data[
    subject_code == subjectCode & group_code == groupCode &
      series_reference %in% seriesReference
  ]
}