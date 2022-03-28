library(httr)
library(tidyverse)
library(magrittr)

## Server credentials 
staging = list(
               server = "https://r-studio-connect-staging.spotcap.com/",
               key    = "zk0tjMh3MMXxRfjQjcr80Mk5yZWjGIuD"
)
production = list(
                  server = "https://r-studio-connect.spotcap.com/",
                  key    = "uM9beDW9X8LWlBnygcxUU0i69apUWcjp"
)



# 1: Get a List Content Items
get_content_items_list <- function(server){
  resp <- GET(
              paste0(server$server, "__api__/v1/content"),
              add_headers(Authorization = paste("Key", server$key))
  )

  server$content = content(resp) %>% bind_rows()
}

staging_    = get_content_items_list(staging)
production_ = get_content_items_list(production)

staging_    %<>% mutate(server = "staging")
production_ %<>% mutate(server = "production")


combined = bind_rows(staging_, production_)

write.csv(combined, file=here::here("data/rsc_deployed.csv"))

# 2: download all bundles
bundle_path = "bundles"
if (!dir.exists(bundle_path)) dir.create(bundle_path)
setwd(bundle_path)
getwd()

for(i in 1:nrow(combined)){
  server    = combined[i,]$server
  p_id      = combined[i,]$id
  guid      = combined[i,]$guid
  bundle_id = combined[i,]$bundle_id

  bundle_folder = paste0(p_id, "_", bundle_id) 

  system(paste("mkdir -p", bundle_folder))
  setwd(bundle_folder)

  url_name = eval(parse(text=paste0(server, "$server")))
  key_name = eval(parse(text=paste0(server, "$key")))
  full_url = paste0(url_name, "__api__/v1/content/", guid, "/bundles/", bundle_id, "/download")

  cat("processing: ", i, "\n")
  system(paste0("curl --silent --show-error -L --max-redirs 0 --fail -J -O ",
                "-H 'Authorization: Key ", key_name, "' ",
                full_url))
  res = system(paste0("tar -xf bundle-", bundle_id, ".tar.gz"), intern=TRUE)

  print(combined[i,]$dashboard_url)

  cat("processed: ", i, "\n\n")
  Sys.sleep(0.3)

  setwd("..")
}

# 3: Update list with packages that used in there
# setwd("..")
# setwd(bundle_path)
getwd()

combined$comment = "uncertain"
tmp = combined

i = 50 
combined = combined %>% 
  filter(app_mode == "api") 

combined %>% glimpse()

combined$package = ""

for(i in 1:nrow(combined)){
  server    = combined[i,]$server
  p_id      = combined[i,]$id
  guid      = combined[i,]$guid
  bundle_id = combined[i,]$bundle_id

  bundle_folder = paste0(p_id, "_", bundle_id) 

  setwd(bundle_folder)
  print(bundle_folder)
  cat("processing: ", i, "\n")

  if (is.na(bundle_id)){
    print("Incomplete")
    combined[i,]$comment = "remove"
    combined[i,]$description = "Incomplete/broken"
  }else if ("plumber.R" %in% dir()){
    result = system("rg library plumber.R", intern=TRUE)
    result %>% print()
    api_list = stringr::str_match(result, "(?=\\().*?(?<=\\))") %>% 
      as.list() %>% 
      unlist() %>% 
      stringr::str_remove_all(., "[)(]") %>% 
      tibble(value = .) %>% 
      filter(!(value %in% c("RCurl" ,"httr", "tidyverse", "dplyr", "stringr", "magrittr", "packagename, character.only = TRUE", "jsonlite", "plumber")))

    if (nrow(api_list)){
      combined[i,]$package = api_list %>% 
        as.list()  %>% 
        .$value   %>% 
        paste(collapse=", ")
    }else{
      combined[i,]$package = "no package"    
    }

    print("api_name:")
    combined[i,]$api_name %>% print()
  }

  cat("processed: ", i, "\n\n")

  setwd("..")
}

write.csv(combined, file=here::here("data/rsc_deployed_api.csv"))

# 4: Update description and add info about endpoints
# setwd("..")
# setwd(bundle_path)
getwd()

combined %>% glimpse()

combined$endpoints = "No info"

i = 1
for(i in 1:nrow(combined)){
  server    = combined[i,]$server
  p_id      = combined[i,]$id
  guid      = combined[i,]$guid
  bundle_id = combined[i,]$bundle_id
  package   = combined[i,]$package

  bundle_folder = paste0(p_id, "_", bundle_id) 

  setwd(bundle_folder)
  print(bundle_folder)
  cat("processing: ", i, "\n")

#   if (is.na(stringr::str_match(package, " "))){
#     manifest = jsonlite::fromJSON(txt="manifest.json")
#     combined[i,]$description = eval(parse(text=paste0("manifest$packages$", package, "$description$Description")))
#     combined[i,]$version     = eval(parse(text=paste0("manifest$packages$", package, "$description$Version")))
#     combined[i,]$built       = eval(parse(text=paste0("manifest$packages$", package, "$description$Built")))
# 
#   }

  if ("plumber.R" %in% dir()){
    result = system("grep -B 3 function plumber.R", intern=TRUE)
    combined[i,]$endpoints = paste0(result, collapse=" \n ") 
  }

  cat("processed: ", i, "\n\n")

  setwd("..")
}

write.csv(combined, file=here::here("data/rsc_deployed_api.csv"))

# 5: A try to find a corrsponding repository
combined = read.csv(file=here::here("data/rsc_deployed_api.csv"))
combined %>% str()

combined$package
path = "../repositories/datasciencespotcap"

i = 1
combined$repo = ''
setwd(path)
for(i in 1:nrow(combined)){
  package = combined[i,]$package

  tryCatch({
    repo = system(paste0("grep -rw 'Package: *", package, "'  --include *DESCRIPTION"), intern=TRUE)  %>% 
      stringr::str_remove("/DESCRIPTION.*") %>% 
      stringr::str_remove("./")


    print(repo)
    combined[i,]$repo = repo
  },
  error = function (condition) {
    print(paste(package, "not found"))
  },
  finally= function() {
    print("finally")

  }
  )

}


tmp = combined %>% 
  select(name, package, repo, id, bundle_id)

write.csv(tmp, file=here::here("data/rsc_deployed_api_connection.csv"))

additional_info = 
  tibble(name = c("bank_account_stats", "test-plot"),
         repo = c("ds-other-endpoint-covid-ba-stats", "no repo")
  )

# some stats
# folders = system(paste('du --max-depth=1', path), intern=TRUE) %>% 
#   as_tibble()  %>% 
#   mutate(size   = as.numeric(stringr::str_remove(value, "\t.*"))) %>% 
#   mutate(folder = stringr::str_remove(value, ".*\t../repositories/datasciencespotcap/")) %>% 
#   select(-value) %>% 
#   filter(is.na(stringr::str_match(folder, ".*datasciencespotcap.*")))  %>% 
#   mutate(department = stringr::str_match(folder, "ds-[a-z]{1,10}"))
# 
# 
# folders  %>% 
#   arrange(desc(size)) %>% 
#   print(n=83)

