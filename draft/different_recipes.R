library(httr)


connectServer = "https://r-studio-connect-staging.spotcap.com/"
connectAPIKey = "zk0tjMh3MMXxRfjQjcr80Mk5yZWjGIuD"

# System information
resp <- GET(
  paste0(connectServer, "__api__/v1/server_settings/r"),
  add_headers(Authorization = paste("Key", connectAPIKey))
)
content(resp, as="parsed")


# Pagination
# Request a page of up to 25 audit log records.
resp <- GET(
  paste0(connectServer, "__api__/v1/audit_logs?ascOrder=false&limit=25"),
  add_headers(Authorization = paste("Key", connectAPIKey))
)
payload <- content(resp)
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


library(httr)

# The connectServer URL must have a trailing slash.
connectServer <- Sys.getenv("CONNECT_SERVER")
connectAPIKey <- Sys.getenv("CONNECT_API_KEY")

myRVersion <- paste(R.version$major, R.version$minor, sep = ".")
resp <- GET(
  paste0(connectServer, "__api__/v1/server_settings/r"),
  add_headers(Authorization = paste("Key", connectAPIKey))
)
payload <- content(resp, as="parsed")
if (myRVersion %in% unlist(payload)) {
  print("The local R version was found on the RStudio Connect server")
} else {
  print(paste("Cannot find R version", myRVersion,"on the RStudio Connect server"))
}
