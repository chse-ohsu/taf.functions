#!/bin/env Rscript

#' Name: michigan_county_fips_fix_17_18_19
#' 
#' Description: the bene_cnty_cd variable in the 2017-2019 TAF data for Michagan
#' is incorrect, and appears to have the value of the county SSA code plus one,
#' rather than the FIPS code. This can be corrected using a publicly available
#' FIPS to SSA crosswalk. This function makes this correction, stores the original
#' bene_cnty_cd in a column called orig_bene_cnty_cd, and preserves the original
#' order of the data. 
#'
#' Thank you to Kelsey Watson at OHSU and Emma Mairson & Sabin Gaire at U Pittsburg 
#' for contributing to this function
#' 
#' @return same data frame with county FIPS codes instead of SSA codes + 1 wherever
#' the bene_state_cd == 26 indicating Michigan
#' @export
michigan_county_fips_fix_17_18_19 <- function(taf_demog_elig_base, year){
  taf_demog_elig_base <- data.frame(taf_demog_elig_base)
  
  #get order of rows so that initial df can be recreated at the end of this 
  #function with only the county codes changed
  taf_demog_elig_base$order <- 1:nrow(taf_demog_elig_base)
  
  # it appears that the bene_cnty_cds in MI for 2017-2019 are actually CON 
  # codes rather than FIPS codes. CON codes can be seen here:
  # https://www.michigan.gov/-/media/Project/Websites/mdhhs/Folder1/Folder93/Michigan_County_Codes.pdf?rev=1067b3ac7f844181b14308aef3d0c31f
  # Here I am creating a crosswalk that will match CON codes to FIPS codes
  # Note that 'Detroit city' has it's own CON code which I am matching to 
  # Wayne County, which is where Detroit is located. In addition, there appears 
  # to be a code 0, which is not a valid FIPS or CON code. I'm matching that to 
  # 990, the FIPS code for 'statewide'.
  con_codes  <- c(0:84)
  con_codes <- sprintf("%02d", con_codes)
  
  fips_codes <- c(
    '990', '001', '003', '005', '007', '009', '011', '013', '015', '017', '019', 
    '021', '023', '025', '027', '029', '031', '033', '035', '037', '039', 
    '041', '043', '045', '047', '049', '051', '053', '055', '057', '059', 
    '061', '063', '065', '067', '069', '071', '073', '075', '077', '079',
    '081', '083', '085', '087', '089', '091', '093', '095', '097', '099',
    '101', '103', '105', '107', '109', '111', '113', '115', '117', '119',
    '121', '123', '125', '127', '129', '131', '133', '135', '137', '139',
    '141', '143', '145', '147', '149', '151', '153', '155', '157', '159',
    '161', '163', '163', '165'
  )
  
  county_crosswalk <- data.frame(con_codes, fips_codes) 

  # if the input data includes data where state_cd is not "MI", set that aside,
  # don't make changes to it, and add it back at the end
  state_cd_not_mi_df <- taf_demog_elig_base[taf_demog_elig_base$state_cd != "MI",]
  state_cd_mi_df <- taf_demog_elig_base[taf_demog_elig_base$state_cd == "MI",]
  
  # bene_state_cds do not always match state_cds - since bene_state_cds and 
  # bene_cnty_cds come from the same source (home addresses), it makes most sense
  # to limit the changes we make here to instances where bene_state_cd == MI
  # I have not checked whether the CON/FIPS issue affects bene_cnty_cds where
  # state_cd is MI but not bene_state_cd, or where state_cd is not MI but 
  # bene_state_cd is. This could be worth doing.
  bene_state_cd_not_mi_df <- state_cd_mi_df[state_cd_mi_df$bene_state_cd != '26' & !is.na(state_cd_mi_df$bene_state_cd),]
  mi_df     <- state_cd_mi_df[state_cd_mi_df$bene_state_cd == '26' & !is.na(state_cd_mi_df$bene_state_cd),]
  
  # treat NAs as Michigan unless county fips is not a valid MI county con or fips code
  # if county is also NA, assume it is in MI
  na_df <- taf_demog_elig_base[is.na(taf_demog_elig_base$bene_state_cd),]
  good_na_df <- na_df[is.na(na_df$bene_cnty_cd) | 
                        (na_df$bene_cnty_cd %in% county_crosswalk$fips_codes) | 
                        (na_df$bene_cnty_cd %in% county_crosswalk$con_codes),]
  
  bad_na_df <- na_df[!is.na(na_df$bene_cnty_cd) & 
                       !(na_df$bene_cnty_cd %in% county_crosswalk$fips_codes) &
                       !(na_df$bene_cnty_cd %in% county_crosswalk$con_codes),]
  bene_state_cd_not_mi_df <- rbind(bene_state_cd_not_mi_df, bad_na_df)
  mi_df <- rbind(mi_df, good_na_df)
  
  # If the bene_cnty_cd is a MI CON cd or '00', we want to replace it with the 
  # corresponding FIPS code
  # If the bene_cnty_cd is NOT a valid MI con code but is a valid FIPS code, we
  # want to leave it as is
  # Anything that is neither a valid CON nor FIPS code we will also leave as is
  #Emma & Sabin please check
  mi_df$orig_bene_cnty_cd <- mi_df$bene_cnty_cd
  mi_df$con_codes <- mi_df$bene_cnty_cd
  mi_df <- merge(mi_df, county_crosswalk, by='con_codes', all.x=T)
  mi_df$bene_cnty_cd[!is.na(mi_df$fips_codes)] <- mi_df$fips_codes[!is.na(mi_df$fips_codes)]

  
  #discard cols no longer needed
  mi_df$con_codes <- NULL
  mi_df$fips_codes <- NULL
  
  #re-combine with non-MI data if there was any
  if (nrow(bene_state_cd_not_mi_df) != 0){
    bene_state_cd_not_mi_df$orig_bene_cnty_cd <- NA
    mi_df <- rbind(mi_df, bene_state_cd_not_mi_df)
  }
  
  if (nrow(state_cd_not_mi_df) != 0){
    state_cd_not_mi_df$orig_bene_cnty_cd <- NA
    mi_df <- rbind(mi_df, state_cd_not_mi_df)
  }

  out_df <- mi_df

  #re-order the data to match the input
  out_df <- out_df[order(out_df$order),]
  
  return(out_df)
}








  
