library(data.table)

# helper functions -------------------------------------------------------------
`%+%` <- function(a, b) sprintf("%s%s", a, b)
`%/%` <- function(a, b) sprintf("%s/%s", a, b)

ltrim <- function(str) {
  if (substr(str, 1, 1) == " ") ltrim(substr(str, 2, nchar(str)))
  else str
}

rtrim <- function(str) {
  if (substr(str, nchar(str), nchar(str)) == " ")
    rtrim(substr(str, 1, nchar(str) - 1))
  else
    str
}

trim <- function(str) ltrim(rtrim(str))

to_date <- function(x) {
  as.Date(sprintf("%s.01", x), format = "%Y.%m.%d")
}

# fetch labour market data -----------------------------------------------------
# note that this file will go away and be replaced with something else...
# labour-market-statistics-march-2022-quarter-csv.zip, for example.
# this is just terrible practice, but it is what it is.
# the fact that same date appears in two places in the URL is also silly.
path <- "https://www.stats.govt.nz/assets/Uploads" %/%
    "Labour-market-statistics" %/%
    "Labour-market-statistics-December-2021-quarter" %/%
    "Download-data" %/%
    "labour-market-statistics-december-2021-quarter-csv.zip"

# fetch, and unzip only the lms-* file
download.file(path, destfile = "data-raw/lm.zip")
files <- utils::unzip("data-raw/lm.zip", list = TRUE)
lms <- files[grepl("lms-", files$Name, perl = TRUE),]$Name[1]
utils::unzip("data-raw/lm.zip", files = lms, exdir = "data-raw")

# read data
data <- fread(
  "data-raw" %/% lms
)

# rename columns, etc.
colnames(data) <- tolower(colnames(data))
colnames(data)[6] <- "magnitude"
data[, period := to_date(period)]

codes <- sapply(data$subject, function(x) {
  strsplit(x, "-", fixed = TRUE)[[1]][2] |> trim()
}, USE.NAMES = FALSE)

descriptions <- sapply(data$subject, function(x) {
  strsplit(x, "-", fixed = TRUE)[[1]][1] |> trim()
}, USE.NAMES = FALSE)

data <- data.table(
  subject_code = codes,
  subject_description = descriptions,
  group_code = as.character(openssl::md4(data$group)),
  group_description = data$group,
  data
)

data[,subject:=NULL]
data[,group:=NULL]

setkeyv(data, c("subject_code", "group_code", "series_reference", "period"))

# save -------------------------------------------------------------------------
saveRDS(data, file = "data/labour_market.rds")
writeLines(text = path, con = "data/attribution.txt")

# tidy up ----------------------------------------------------------------------
unlink(c(
  "data-raw/lm.zip", "data-raw" %/% strsplit(lms, "/")[[1]][1]
), recursive = TRUE)
rm(list=ls())
