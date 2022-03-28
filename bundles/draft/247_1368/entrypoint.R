library(plumber)

serve_prepro <- plumb("plumber.R")

serve_prepro$registerHook("exit", function(){
    message("Bye bye!")
    print("Bye bye!")
    write("test-output", paste0(format(Sys.time(), "%Y%m%d_%H%M%S"),".txt"))
})

return(serve_prepro)
