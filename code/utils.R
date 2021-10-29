library(tidyverse)

ensure_directory <- function(directory){
    if(!dir.exists(directory)){
        dir.create(directory);
    }
}

make_logger <- function(filename, sep="\n"){
    if(file.exists(filename)){
        file.remote(filename);
    }
    function(...){
        text <- sprintf(...);
        cat(text, file=filename, sep=sep, append=T);
    }
}
