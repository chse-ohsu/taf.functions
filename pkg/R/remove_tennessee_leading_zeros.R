#!/bin/env Rscript

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
remove_tennessee_icd_leading_zeros <- function(tennessee_data, col='all'){
  tennessee_data <- as.data.frame(tennessee_data)
  
  
  if (col=='all'){
    
    # Apply to all "dgns_cd" columns
    dgns_cols <- grep('dgns_cd',colnames(tennessee_data), value=TRUE)
    for (col in dgns_cols){
      tennessee_data[, col] <- gsub("^0+", "", tennessee_data[,col])
    }
    
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
