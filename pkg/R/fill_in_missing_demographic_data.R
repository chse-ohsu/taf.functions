#*******************************************************************************
#' Name: create_hash_id 
#' @param taf data frame (must include state_cd, msis_id, and bene_id columns)
#' @param id_colname - what you want to call the unique_id column - defaults to 
#' hash_id
#' @return dataframe with unique hash_id for each beneficiary
create_hash_id <- function(taf_df, id_colname='hash_id'){
  taf_df <- as.data.frame(taf_df)
  taf_df$hash_id <- ifelse(taf_df$bene_id == "", paste0(taf_df$msis_id, taf_df$state_cd), taf_df$bene_id)
  taf_df[,id_colname] <- sapply(taf_df$hash_id, digest::digest)
  taf_df[, id_colname] <- toupper(taf_df[, id_colname])
  return(taf_df)
}


#*******************************************************************************
#' Name: fill_in_missing_demographic_data
#' @param demog_data - dataframe or similar structure, containing the 
#' taf_demog_elig_base
#' 
#' @param year_col - name of the column that contains the year. TAF data does 
#' not initially have a year column, as it comes in discreet files by year. 
#' However, multiple, distinguishable years are necessary for this function. A
#' year column must be added.
#' 
#' @param demog_col - name of the column with missing values you want to impute 
#' (e.g. race_ethncty_cd, sex_cd, etc)
#' 
#' @returns dataframe with some missing observations in demog_col filled in in a 
#' column called <demog_col>_imputed. Original values remain in the original column
#' 
#' @export
fill_in_missing_demographic_data <- function(demog_data, 
                                          year_col, 
                                          demog_col){
  
  #create data frame (out of data table, tibble, etc ect - redundant if already dataframe)
  demog_data <- as.data.frame(demog_data)
  
  #create unique identifier
  demog_data <- create_hash_id(taf_df=demog_data)
  
  #provide information on initial missing values to the user

  missing_rows_initial <- nrow(demog_data[is.na(demog_data[,demog_col]),])
  print(paste0('prior to running this function, ', missing_rows_initial, '/', nrow(demog_data), ' rows in your data are missing ', demog_col ))

  
  #save original dataset for later use
  orig_data <- demog_data
  yrs <- unique(demog_data[, year_col])
  demog_data <- demog_data[, c('hash_id', demog_col, year_col)]

  #get the data in wide format so that there is one row per unique person
  #with multiptle years of values for each row
  demog_data <- reshape(data = demog_data,
                        idvar = "hash_id",
                        v.names = demog_col,
                        timevar = year_col,
                        direction = "wide")
  
  #'imputed' demographic col will show the user whether or not a value was imputed
  #initialize to zero

  demog_data[, paste0('imputed_', demog_col)] <- 0
  
  
  
  #for each individual, if a value is missing in one or more years and not all,
  #and the value is the same in all years where it's present, fill the missing
  #values with that value
  replace_demog_code <- function(n){
    
    demog_vals <- as.numeric(demog_data[n, paste0(demog_col, '.', yrs)])
    
    if ( length(unique(demog_vals)) == 2 & any(is.na(demog_vals)) ) {
      good_demog_val <- unique(demog_vals)[ !is.na(unique(demog_vals))]
      demog_vals[is.na(demog_vals)] <- good_demog_val
      demog_data[n, paste0(demog_col, '.', yrs)] <- good_demog_val
        
      #change imputed to 1 for values that were missing intially but filled
      demog_data[n, paste0('imputed_', demog_col)] <- 1
    }
    
    return(demog_data[n,])
  }
  
  #merge back into original data
  demog_data <- as.data.frame(data.table::rbindlist(lapply(1:nrow(demog_data), replace_demog_code)))
  demog_data <- merge(demog_data, orig_data, by='hash_id', all.y=TRUE)
  
  #fill in demog_col based on imputed data
  demog_data[demog_data[,paste0('imputed_', demog_col)] == 1, demog_col] <- demog_data[demog_data[,paste0('imputed_', demog_col)]==1, paste0(demog_col, '.', yrs[1])] #1 arbitrary, all yr cols will have this same value in the rows affected here

  
  #give the user information about how many rows were filled in
  missing_rows_final <- nrow(demog_data[is.na(demog_data[,demog_col]),])
  print(paste0('after running this function, ', missing_rows_final, '/', nrow(demog_data), ' rows in your data are missing ', demog_col ))
  print(paste0(as.numeric(missing_rows_initial) - as.numeric(missing_rows_final), ' missing ', demog_col, ' rows have been filled '))
    
  demog_data[,paste0(demog_col, '.', yrs)] <- NULL
  
  return(demog_data)
}