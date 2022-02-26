#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Get a sequence of random numbers
#* @param n Size of sequence
#* @get /rand
function(n) runif(n)