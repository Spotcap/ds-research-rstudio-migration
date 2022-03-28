library(httr)
library(tidyverse)

# The CONNECT_SERVER URL must have a trailing slash.
# connectServer <- Sys.getenv("CONNECT_SERVER")
# connectAPIKey <- Sys.getenv("CONNECT_API_KEY")

connectServer="https://r-studio-connect.spotcap.com/"
connectAPIKey="uM9beDW9X8LWlBnygcxUU0i69apUWcjp"

# Request a page of up to 25 visitation records.
resp <- GET(
            paste0(connectServer, "__api__/v1/instrumentation/content/visits?limit=500"),
            add_headers(Authorization = paste("Key", connectAPIKey))
)

resp  %>% glimpse
payload <- content(resp)

payload %>% glimpse()
# print the current page results
print(payload$results)

# Continue to page through additional records
# while we have a "next" reference
while(!is.null(payload$paging[["next"]])) {
  resp <- GET(
    payload$paging[["next"]],
    add_headers(Authorization = paste("Key", connectAPIKey))
  )
  payload <- content(resp)
  # print the results on this page
  print(payload$results)
}
