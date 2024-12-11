#!/bin/env Rscript

#' Name: michigan_county_fips_fix_17_18_19
#' 
#' Description: the bene_cnty_cd variable in the 2017-2019 TAF data for Michagan
#' is incorrect, and appears to have the value of the county SSA code plus one,
#' rather than the FIPS code. This can be corrected using a publicly available
#' FIPS to SSA crosswalk. This function makes this correction, stores the original
#' bene_cnty_cd in a column called orig_bene_cnty_cd, and preserves the original
#' order of the data
#' 
#' 
#' @return same data frame with county FIPS codes instead of SSA codes + 1 wherever
#' the bene_state_cd == 26 indicating Michigan
#' @export
michigan_county_fips_fix_17_18_19 <- function(taf_demog_elig_base, year){
  taf_demog_elig_base <- data.frame(taf_demog_elig_base)
  # get NBER crosswalk (seperate by year - these are stored in the taf.functions
  # library / no need for a file)
  if (year == 2017){
    xwalk <- ssa_fips_xwalk_17 #constant that lives in taf.functions repo with data from https://www.nber.org/research/data/ssa-federal-information-processing-series-fips-state-and-county-crosswalk
    xwalk$ssacd <- xwalk$ssacounty #change name to be consistent with 18 xwalk
    xwalk$ssacounty <- NULL
  } else if (year == 2018){
    xwalk <- ssa_fips_xwalk_18
  } else if (year == 2019){
    xwalk <- ssa_fips_xwalk_19
  } else{
    message('this function is not necessary outside of the years 2017-2019')
    message('returning original data untouched')
    return (taf_demog_elig_base)
  }
  # state FIPS/SSA are prefixed to county values, get rid of that
  xwalk <- xwalk[xwalk$state == 'MI',]
  xwalk$fipscounty <- substr(xwalk$fipscounty, 3, 5)
  xwalk$ssacd <- substr(xwalk$ssacd, 3, 5)
  xwalk <- xwalk[,c('ssacd', 'fipscounty')]
  
  # want output df to be identical to input df save for county fips changes
  # so we must preserve the order of rows, since this function will scramble them 
  taf_demog_elig_base$order <- 1:nrow(taf_demog_elig_base)
  not_mi_df <- taf_demog_elig_base[taf_demog_elig_base$bene_state_cd != '26' & !is.na(taf_demog_elig_base$bene_state_cd),]
  mi_df     <- taf_demog_elig_base[taf_demog_elig_base$bene_state_cd == '26' & !is.na(taf_demog_elig_base$bene_state_cd),]
  # treat NAs as Michigan unless county fips is not a valid MI county
  # if county is also NA, assume it is in MI
  na_df <- taf_demog_elig_base[is.na(taf_demog_elig_base$bene_state_cd),]
  good_na_df <- na_df[is.na(na_df$bene_cnty_cd) | (na_df$bene_cnty_cd %in% xwalk$fipscounty),]
  bad_na_df <- na_df[!is.na(na_df$bene_cnty_cd) & !(na_df$bene_cnty_cd %in% xwalk$fipscounty),]
  not_mi_df <- rbind(not_mi_df, bad_na_df)
  mi_df <- rbind(mi_df, good_na_df)
  
  # the bene_cnty_cd values seem to be SSA codes + 1
  # thus, subtract one from each bene_cnty_cd to get SSA cd, then convert to 
  # a three char string to match the NBER crosswalks
  mi_df$ssacd <- as.integer(mi_df$bene_cnty_cd) - 1
  mi_df$ssacd[mi_df$ssacd == -1] <- 999
  mi_df$ssacd <- as.character(mi_df$ssacd)
  mi_df$ssacd[nchar(mi_df$ssacd) == 2 & !is.na(mi_df$ssacd)] <- paste0('0', mi_df$ssacd[nchar(mi_df$ssacd) == 2  & !is.na(mi_df$ssacd)])
  mi_df$ssacd[nchar(mi_df$ssacd) == 1 & !is.na(mi_df$ssacd)] <- paste0('00', mi_df$ssacd[nchar(mi_df$ssacd) == 1 & !is.na(mi_df$ssacd)])
  

  # merge, replace bene_cnty_cd while preserving the old
  mi_df <- merge(mi_df, xwalk, by='ssacd', all.x=T)
  mi_df$orig_bene_cnty_cd <- mi_df$bene_cnty_cd
  mi_df$bene_cnty_cd <- mi_df$fipscounty
  
  #discard cols no longer needed
  mi_df$ssacd <- NULL
  mi_df$fipscounty <- NULL
  
  #re-combine with non-MI data if there was any
  if (nrow(not_mi_df) != 0){
    not_mi_df$orig_bene_cnty_cd <- NA
    out_df <- rbind(mi_df, not_mi_df)

  } else{
    out_df <- mi_df
  }

  #re-order the data to match the input
  out_df <- out_df[order(out_df$order),]
  
  return(out_df)
}






  
