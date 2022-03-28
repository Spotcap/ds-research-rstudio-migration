library(apiBAcovid)

version <- packageVersion("apiBAcovid")

#* Check API readiness
#* @get /healthcheck
function(res) {

    res$status <- 200
    return(glue::glue("Give some data, I'm ready to extract EDB/BA stats for COVID-19. App version: {version}"))

}

#* Slice the data into 3 different data frames and calculates stats
#* @post /covid_stats
#* @serializer unboxedJSON
function(req, res) {

    ### LOCAL TESTING ###
    # request_body_df <- jsonlite::read_json("inst/extdata/df.json") %>%
    #    purrr::map_dfr(dplyr::as_tibble)
    ### or (most preferably)
    # request_body_df <- df
    ###

    request_body_df <- jsonlite::fromJSON(req$postBody)

    message(">>> Working on it... <<<")
    stats = calculate_all_covid_variables(request_body_df)
    message(">>> Slicing and calculating... <<<")

    if(stats == 1){
        res$status <- 400
        res$body <- list(
            error = as.character(glue::glue("Not enough transactions provided for calculations")))
            # !!!!!!!!! Also it can be unknown ERROR !!!!!!!!!

    }else{

        message(">>> Assembling response... <<<")
        response_body_df <- stats

        res$status <- 200
        res$body <- list(
            version = as.character(version),
            data = response_body_df
        )

    }
}


#* Evaluates seasonality and calculates corresponding stats
#* @post /sesonality_stats
#* @serializer unboxedJSON
function(req, res) {

    ### LOCAL TESTING ###
    ### jsonlite::write_json(df_list[[5]], path="inst/extdata/df_season.json", pretty=TRUE)
    ### request_body_df <- jsonlite::fromJSON("inst/extdata/df_season.json")
    ### or (most preferably)
    ### request_body_df <- df_list[[1]]
    ###

    request_body_df <- jsonlite::fromJSON(req$postBody)

    message(">>> Working on it... <<<")
    stats = evaluate_seasonality(request_body_df)
    message(">>> Evaluating and calculating... <<<")

    if(typeof(stats) != "list"){
        res$status <- 400
        res$body <- list(
            error = stats)
    }else{

        message(">>> Assembling response... <<<")
        response_body_df <- stats

        res$status <- 200
        res$body <- list(
            version = as.character(version),
            data = response_body_df
        )

    }
}
