#*******************************************************************************
#* DESCRIPTION: helper function for get_apr_data_quality_measures - checks if 
#* the classification code is a valid and informative classification code for 
#* the classification system being used (excludes NAs, 'all other' codes, 
#* codes for systems besides the one being used, etc)
#* 
#* INPUTS: dataframe with 'prvdr_clsfctn_sys' and 'prvdr_clsfctn_cd' columns, as
#* well as 'state_cd', 'submtg_state_prvdr_id', 'prvdr_type' cols for indexing
#* 
#* OUTPUTS: dataframe indexed by state, provider id, and provider type with 
#* proportions of valid codes
#*******************************************************************************
check_clsfctn <- function(taf_prvdr_clsfctn_df,
                          valid_prvdr_clsfctn_cds_sys2,
                          valid_prvdr_clsfctn_cds_sys3,
                          valid_prvdr_clsfctn_cds_sys4){
  
  taf_prvdr_clsfctn_df$count_valid <- 1
  
  #invalid if classification code or classification system is missing 
  taf_prvdr_clsfctn_df$count_valid[is.na(taf_prvdr_clsfctn_df$prvdr_clsfctn_sys)] <- 0
  taf_prvdr_clsfctn_df$count_valid[is.na(taf_prvdr_clsfctn_df$prvdr_clsfctn_cd)] <- 0
  
  #invalid if classification code is not one of the valid codes for the 
  # classification system being used
  taf_prvdr_clsfctn_df$count_valid[taf_prvdr_clsfctn_df$prvdr_clsfctn_sys == '2' & !(taf_prvdr_clsfctn_df$prvdr_clsfctn_cd %in% valid_prvdr_clsfctn_cds_sys2)] <- 0
  taf_prvdr_clsfctn_df$count_valid[taf_prvdr_clsfctn_df$prvdr_clsfctn_sys == '3' & !(taf_prvdr_clsfctn_df$prvdr_clsfctn_cd %in% valid_prvdr_clsfctn_cds_sys3)] <- 0
  taf_prvdr_clsfctn_df$count_valid[taf_prvdr_clsfctn_df$prvdr_clsfctn_sys == '4' & !(taf_prvdr_clsfctn_df$prvdr_clsfctn_cd %in% valid_prvdr_clsfctn_cds_sys4)] <- 0
  
  #taf_prvdr_clsfctn_df <- taf_prvdr_clsfctn_df[, .(count_valid = sum(count_valid)), by = c('state_cd', 'submtg_state_prvdr_id', 'prvdr_type')]
  taf_prvdr_clsfctn_df <- aggregate(taf_prvdr_clsfctn_df$count_valid, list(taf_prvdr_clsfctn_df$submtg_state_prvdr_id), FUN=sum)
  
  taf_prvdr_clsfctn_df$submtg_state_prvdr_id <- taf_prvdr_clsfctn_df$Group.1 
  taf_prvdr_clsfctn_df$count_valid <- taf_prvdr_clsfctn_d2$x
  
  taf_prvdr_clsfctn_df$Group.1 <- NULL
  taf_prvdr_clsfctn_df$x <- NULL
  
  taf_prvdr_clsfctn_df$count_valid[taf_prvdr_clsfctn_df$count_valid >= 1] <- 1
  
  return(taf_prvdr_clsfctn_df)
}




#*******************************************************************************
#* DESCRIPTION: helper function for get_apr_data_quality_measures - assigns an
#* 'assessment' e.g. 'moderately above expected', 'high concern' to proportions
#* of the various measures being tracked based on thresholds from DQ Atlas
#* 
#* INPUTS: a measure and its value
#* 
#* OUTPUTS: an 'assessment' in string form of the value, with criteria changing
#* based on which measure it is - no algorithm for determining assessment, all
#* criteria come from DQ Atlas
#*******************************************************************************
assign_assessment <- function(
    value,
    measure_name){
  
  
  if (!grepl('valid', measure_name)){
    
    if (measure_name == 'pct_indiv_prvdrs'){
      far_below_expected_threshold <- .6
      moderately_below_expected_threshold <- .7
      within_expected_threshold <- .93
      moderately_above_expected_threshold <- .97
    } else{
      far_below_expected_threshold <- .03
      moderately_below_expected_threshold <- .07
      within_expected_threshold <- .20
      moderately_above_expected_threshold <- .40
    }
    
    if (is.na(value)) {
      assessment <- 'no_data'
    } else {
      if(value < far_below_expected_threshold){
        assessment <- 'far_below_expected'
      } else if (value >= far_below_expected_threshold & value < moderately_below_expected_threshold){
        assessment <- 'moderately_below_expected'
      } else if (value >= moderately_below_expected_threshold & value < within_expected_threshold){
        assessment <- 'within_expected'
      } else if (value >= within_expected_threshold & value < moderately_above_expected_threshold){
        assessment <- 'moderately_above_expected'
      } else if (value >= moderately_above_expected_threshold){
        assessment <- 'far_above_expected'
      } else{
        message('something went wrong')
      }
    }
    
  } else{
    if (is.na(value)) {
      assessment <- 'no_data'
    } else {
      if(value < .5){
        assessment <- 'unusable'
      } else if (value >= .5 & value < .8){
        assessment <- 'high concern'
      } else if (value >= .8 & value < .9){
        assessment <- 'medium concern'
      } else if (value){
        assessment <- 'low concern'
      } else{
        message('something went wrong')
      }
    }
  }
  
  return(assessment)
}



#*******************************************************************************
#' Name: get_apr_data_quality_measures
#' 
#' Description: replication code for -  
#' https://www.medicaid.gov/dq-atlas/landing/topics/single/map?topic=g6m94&tafVersionId=34
#' the following 'topics' are currently finished - 
#' 'Facility/Group/Individual Code'
#' 
#' 
#' @param taf_prvdr_base_df - dataframe, must have data from 'taf_prvdr_base' file
#' @param year_col - optional. A character or string with the name of the column with the year
#' if such a column exists (no such column is in the raw TAF data, but is necessary
#' if you are analyzing multiple years of data)
#' @return A dataframe containing the same measures as the .csv files that can
#' be downloaded with the 'data (csv)' link at the URL above
#' @export
get_apr_data_quality_measures <- function(
    taf_prvdr_base_df,
    #taf_prvdr_taxonomy_df=NULL, 
    #taf_prvdr_location_df=NULL,
    year_col=NULL){
  #topic='all'
  
  valid_prvdr_clsfctn_cds_sys2 = c('89', '90', '91', '92', '93', '94', '95', '96', '97', '98')
  
  valid_prvdr_clsfctn_cds_sys3 = c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
                                   '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
                                   '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
                                   '31', '32', '33', '34', '35', '36', '37', '38', '39', '40',
                                   '41', '42', '43', '44', '45', '46', '47', '48', '49', '50',
                                   '51', '52', '53', '54', '55', '56', '57')
  
  valid_prvdr_clsfctn_cds_sys4 = c('001', '002', '003', '004', '005', '006', '007', '008', '009',
                                   '010', '011', '012', '013', '014', '015', '016', '017', '018', '019',
                                   '020', '021', '022', '023', '024', '025', '026', '027', '028', '029',
                                   '030', '031', '032', '033', '034', '035', '036', '037', '038', '039',
                                   '040', '041', '042', '043', '044', '045', '046', '047', '048', '049',
                                   '050', '051', '052', '053', '054', '055', '056', '057', '058', '059',
                                   '060', '061', '062', '063', '064', '065', '066', '067', '068', '069',
                                   '070', '071', '072', '073', '074', '075', '076', '077', '078', 
                                   '080', '081', '082', '083', '084', '085', '086', '087', '088', 
                                   '115')
  
  if (is.null(year_col)){
    taf_prvdr_base_df$year <- ''
    year_col <- 'year'
  }
  #* VALID PROVIDER DEFAULTS - NOTE:
  #* FROM DQATLAS
  #* 1. The value appears in the code set for the classification type (that is, 
  #* it is a valid value in the current provider taxonomy, specialty, type, and 
  #* authorized category of service code sets). [12] 
  #* 
  #* 2. The code provides usable information about a provider’s classification
  #*  (that is, codes indicating “all other,” “undefined physician type 
  #*  (provider is an MD),” or “unknown supplier/provider specialty” were not 
  #*  counted as usable).
  #* 3. The code must be applicable to the provider type (for example, a 
  #* provider specialty code indicatinga skilled nursing facility would be 
  #* applicable to facility providers but not to group and individual providers)
  
  states <- unique(taf_prvdr_base_df$state_cd)
  #if (!is.null(taf_prvdr_taxonomy_df)){states <- c(states, unique(taf_prvdr_taxonomy_df$state_cd))}
  #if (!is.null(taf_prvdr_location_df)){states <- c(states, unique(taf_prvdr_location_df$state_cd))}
  states <- unique(states)
  
  years <- unique(taf_prvdr_base_df[, year_col])
  #if (!is.null(taf_prvdr_taxonomy_df)){years <- c(years, unique(taf_prvdr_taxonomy_df[, year_col]))}
  #if (!is.null(taf_prvdr_location_df)){years <- c(years, unique(taf_prvdr_location_df[, year_col]))}
  years <- unique(years)
  
  df_list <- vector("list", length(states) * length(years))
  
  #evaluate proportion of valid data individually for each state/year combo
  taf_prvdr_base_df     <- as.data.frame(taf_prvdr_base_df)
  #if (!is.null(taf_prvdr_taxonomy_df)){taf_prvdr_taxonomy_df <- as.data.frame(taf_prvdr_taxonomy_df)}
  #if (!is.null(taf_prvdr_location_df)){taf_prvdr_location_df <- as.data.frame(taf_prvdr_location_df)}
  
  
  for (i in 1:length(years)){
    year <- years[i]
    
    taf_prvdr_base_df_year     <- taf_prvdr_base_df[taf_prvdr_base_df[, year_col]         == year,] 
    #if (!is.null(taf_prvdr_taxonomy_df)){taf_prvdr_taxonomy_df_year <- taf_prvdr_taxonomy_df[taf_prvdr_taxonomy_df[, year_col] == year,]}
    #if (!is.null(taf_prvdr_location_df)){taf_prvdr_location_df_year <- taf_prvdr_location_df[taf_prvdr_location_df[, year_col] == year,]}
    
    for (j in 1:length(states)){
      state <- states[j]
      message(paste0('*** evaluating data for ', state, ' ', year, '***'))
      
      taf_prvdr_base_df_curr     <- taf_prvdr_base_df[taf_prvdr_base_df_year$state_cd         == state,] 
      #if (!is.null(taf_prvdr_taxonomy_df)){taf_prvdr_taxonomy_df_curr <- taf_prvdr_taxonomy_df[taf_prvdr_taxonomy_df_year$state_cd == state,]}
      #if (!is.null(taf_prvdr_location_df)){taf_prvdr_location_df_curr <- taf_prvdr_location_df[taf_prvdr_location_df_year$state_cd == state,]}
      
      #if (topic %in% c('all', 'facility_group_individual_code')){
      n_unique_prvdr_ids_in_taf_apr <- length(unique(taf_prvdr_base_df_curr$submtg_state_prvdr_id))
      
      #get pct indiv, group, and facility
      if (nrow(taf_prvdr_base_df_curr) > 0){
        taf_prvdr_type_df        <- unique(taf_prvdr_base_df_curr[,c('state_cd', 'submtg_state_prvdr_id', 'prvdr_ent_type_cd')])
        pct_indiv_prvdrs         <- round(100*(nrow(taf_prvdr_type_df[taf_prvdr_type_df$prvdr_ent_type_cd  == '03' & !is.na(taf_prvdr_type_df$prvdr_ent_type_cd),]))/n_unique_prvdr_ids_in_taf_apr, digits=1)
        pct_group_prvdrs         <- round(100*(nrow(taf_prvdr_type_df[taf_prvdr_type_df$prvdr_ent_type_cd  == '02' & !is.na(taf_prvdr_type_df$prvdr_ent_type_cd),]))/n_unique_prvdr_ids_in_taf_apr, digits=1)
        pct_facility_prvdrs      <- round(100*(nrow(taf_prvdr_type_df[taf_prvdr_type_df$prvdr_ent_type_cd  == '01' & !is.na(taf_prvdr_type_df$prvdr_ent_type_cd),]))/n_unique_prvdr_ids_in_taf_apr, digits=1)
        
        prvdr_ent_type_cd_df <- unique(taf_prvdr_base_df_curr[, c('submtg_state_prvdr_id', 'prvdr_ent_type_cd')])
        pct_valid_indiv_grp_facil_cd <- 100*nrow(prvdr_ent_type_cd_df[prvdr_ent_type_cd_df$prvdr_ent_type_cd %in% c('01', '02', '03'),])/nrow(prvdr_ent_type_cd_df)
        
        out_df1_curr <- data.frame(state, year, n_unique_prvdr_ids_in_taf_apr, pct_facility_prvdrs, pct_group_prvdrs, pct_indiv_prvdrs, pct_valid_indiv_grp_facil_cd)
        
        out_df1_curr$pct_group_or_facility_prvders_assessment <- assign_assessment(value=(out_df1_curr$pct_facility_prvdrs/100+out_df1_curr$pct_group_prvdrs/100), measure_name='pct_group_or_facility_prvdrs')
        out_df1_curr$pct_indiv_prvdrs_assessment              <- assign_assessment(value=out_df1_curr$pct_indiv_prvdrs/100,    measure_name='pct_indiv_prvdrs')
        #out_df1_curr$pct_valid_indiv_grp_facil_cd_assessment <- assign_assessment(value=out_df1_curr$pct_valid_indiv_grp_facil_cd/100, measure_name='pct_valid_indiv_grp_facil_cd')
        
        
      } else{
        out_df1_curr <- data.frame(state, year, n_unique_prvdr_ids_in_taf_apr)
        out_df1_curr$pct_facility_prvdrs          <- NA
        out_df1_curr$pct_group_prvdrs             <- NA
        out_df1_curr$pct_indiv_prvdr              <- NA
        out_df1_curr$pct_valid_indiv_grp_facil_cd <- NA
        out_df1_curr$pct_indiv_prvdrs_assessment  <- NA
        out_df1_curr$pct_group_prvdrs_assessment  <- NA
      }
      
      #} 
      # else if (topic %in% c('all', 'group_and_indivicual_provider_classification_types')){
      #   
      #   taf_prvdr_taxonomy_df_curr <- merge(taf_prvdr_base_df_curr[,c('submtg_state_prvdr_id', 'prvdr_ent_type_cd')], taf_prvdr_taxonomy_df_curr, by='submtg_state_prvdr_id', all.x=TRUE)
      #   taf_prvdr_clsfctn_indiv_grp_df <- unique(taf_prvdr_taxonomy_df_curr[taf_prvdr_taxonomy_df_curr$prvdr_ent_type_cd=='03' | taf_prvdr_taxonomy_df_curr$prvdr_ent_type_cd=='02', c('state_cd', 'submtg_state_prvdr_id', 'prvdr_ent_type_cd', 'prvdr_clsfctn_sys', 'prvdr_clsfctn_cd')])
      #   n_grp_indiv_prvders <- length(unique(taf_prvdr_clsfctn_indiv_grp_df$submtg_state_prvdr_id))
      #   if (nrow(taf_prvdr_clsfctn_indiv_grp_df) > 0){
      #     
      #     taf_prvdr_taxonomy_df_curr <- merge(taf_prvdr_base_df_curr[,c('submtg_state_prvdr_id', 'prvdr_ent_type_cd')], taf_prvdr_taxonomy_df_curr, by='submtg_state_prvdr_id', all.x=TRUE)
      #     taf_prvdr_clsfctn_indiv_grp_df <- unique(taf_prvdr_taxonomy_df_curr[taf_prvdr_taxonomy_df_curr$prvdr_ent_type_cd=='03' | taf_prvdr_taxonomy_df_curr$prvdr_ent_type_cd=='02', c('state_cd', 'submtg_state_prvdr_id', 'prvdr_ent_type_cd', 'prvdr_clsfctn_sys', 'prvdr_clsfctn_cd')])
      #     taf_prvdr_clsfctn_df <- check_clsfctn(taf_prvdr_clsfctn_indiv_grp_df)
      #     pct_valid_clsfctn_cd <- mean(taf_prvdr_clsfctn_df$count_valid)*100
      #     out_df2_curr <- data.frame(n_grp_indiv_prvders, pct_valid_clsfctn_cd)
      #     out_df2_curr$pct_valid_clsfctn_cd  <- assign_assessment(value=out_df2_curr$pct_valid_clsfctn_cd/100,    measure_name='pct_valid_clsfctn_cd')
      #     
      #     
      #   } else{
      #     out_df2_curr <- data.frame(n_grp_indiv_prvders)
      #     out_df2_curr$pct_valid_clsfctn_cd <- NA
      #     out_df2_curr$pct_valid_clsfctn_cd_assessment <- NA
      #   }
      #   
      # }
      df_list[[(i-1)*length(states)+j]] <- out_df1_curr
    }
  }
  
  out_df <- df_list[[1]]
  for (df_ind in 2:length(df_list)){
    out_df_curr <- df_list[[df_ind]]
    out_df <- rbind(out_df, out_df_curr)
  }
  
  if (out_df$year[1]==''){out_df$year <- NULL}
  return(out_df)
}