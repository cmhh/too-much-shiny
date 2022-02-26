Demo apps used in the blog post:

[Too Much Shiny?!](https://cmhh.github.io/2022/2022-01-20-too-much-shiny/)

## Data

The `labour_market_*` applications require a file called `data/labour_market.rds`.  This is provided with the repository, but is from a fixed point in time.  A newer version can be obtioned by running the script `data-raw/data.R` after updating the `path` variable (line 30)

## Services

service                                                | address          | to run                              | prerequisites                    
-------------------------------------------------------|------------------|-------------------------------------|----------------------------------
[services/labour_market.R](./services/labour_market.R) | `localhost:3001` | `./services/start_labour_market.sh` | `data/labour_market.rds` exists 
[services/rand.R](./services/rand.R)                   | `localhost:3002` | `./services/start_rand.sh`          | 

See the respective R scripts for details.

## Applications

app                                                    | to run                                            | prerequisites                      | description
-------------------------------------------------------|---------------------------------------------------|------------------------------------|------------------------------------------------------------------------
[apps/hello_shiny](./apps/hello_shiny)                 | `shiny::runApp("apps/hello_shiny")`               |                                    | histogram of Old Faithful eruption times using Shiny
[apps/hello_vue](./apps/hello_vue)                     | open `apps/hello_vue/index.html` in browser       |                                    | histogram of Old Faithful eruption times using Vue.js 
[apps/hello_vue_via_shiny](./apps/hello_vue_via_shiny) | `shiny::runApp("apps/hello_vue_via_shiny")`       |                                    | histogram of Old Faithful eruption times using Vue.js, via Shiny 
[apps/hello_shiny_runif](./apps/hello_shiny_runif)     | `shiny::runApp("apps/hello_shiny_runif")`         |                                    | histogram of random uniform sequence using Shiny
[apps/hello_vue_runif](./apps/hello_vue_runif)         | open `apps/hello_vue_runif/index.html` in browser | `rand` service is running          | histogram of random uniform sequence using Vue.js
[apps/labour_market_1](./apps/labour_market_1)         | `shiny::runApp("apps/labour_market_1")`           |                                    | select and view labour market time series data using Shiny
[apps/labour_market_2](./apps/labour_market_2)         | `shiny::runApp("apps/labour_market_2")`           | `labour_market` service is running | select and view labour market time series data using Shiny
[apps/labour_market_3](./apps/labour_market_3)         | open `apps/labour_market_3/index.html` in browser | `labour_market` service is running | select and view labour market time series data using Vue.js
[apps/labour_market_4](./apps/labour_market_4)         | `shiny::runApp("apps/labour_market_4")`           | `labour_market` service is running | select and view labour market time series data using Vue.js, via Shiny
