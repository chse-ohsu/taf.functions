#!/bin/env R

library(tidyverse)

#' Name: remove_tennessee_zeros
#' 
#' Description: removes leading zeros from Tennessee ICD codes, given a 
#' a dataframe with columns containing 'dgns'
#' 
#' defaults to removing leading zeros from all 'dgns' columns, but you can 
#' specify a single column with the 'col' parameter
#' 
#' @return same data frame with leading zeros removed from specified column or
#' all dgns columns
#' @export
remove_tennessee_zeros <- function(tennessee_data, col='all'){
  tennessee_data <- as.data.frame(tennessee_data)
  

  if (col=='all'){
    
  # Apply to all "dgns" columns
    tennessee_data <- tennessee_data %>% 
      mutate(across(contains("dgns"), ~ gsub("^0+", "", .x)))
    
  } else{
    
    if (col %in% colnames(tennessee_data)){
      # Apply to a single column
      tennessee_data[, col] <- gsub("^0+", "", tennessee_data[,col])
    } else{
      message('invalid col')
      stop()
    }
    
  }
  
  return(tennessee_data)
}

