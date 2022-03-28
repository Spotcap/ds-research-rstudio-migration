library(tidyverse)
library(jsonlite)

content = jsonlite::read_json(here::here("content.json")) %>% 
  bind_rows()

content %>% 
  slice(1) %>% 
  glimpse()
