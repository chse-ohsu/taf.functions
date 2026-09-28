#' Collapses the IL claims data - which differs from that of other states - 
#' to the most recent non-NA value of each field withing a 'claim family', per
#' resdac instrutions (which are available here: )
#'
#' @param claims_dt A data table containing TAF claims with at least the fields
#' 'state_cd', 'clm_type_cd', 'clm_num_adj', 'clm_num_orig', and 'adjdctn_dt'
#' @author Conor Hennessy
#' @keywords ~Illinois ~Claims ~TAF
#' @examples
#' il_dt_fixed <- fix_il_claims(il_dt)
#'
#' @export append_file
fix_il_claims <- function(claims_dt){
  if (length(missing_cols <- setdiff(c('state_cd', 'clm_type_cd', 'clm_num_adj', 'clm_num_orig', 'adjdctn_dt'), names(claims_dt)))) stop("Missing column(s): ", paste(missing_cols, collapse = ", "))
  
  claims_dt <- claims_dt[claims_dt$state_cd == "IL",]
  
  #create claim family ID based on resdac guidance
  claims_dt$clm_family_id <- ifelse(claims_dt$clm_type_cd %in% c('4', 'D', 'X',  'Y'), claims_dt$clm_num_adj, claims_dt$clm_num_orig)
  
  #flag most recent claim for each family
  claims_dt[, is_latest := adjdctn_dt == max(adjdctn_dt), by = clm_family_id]
  
  # Sort each family newest to oldest; rows with missing dates go last so they
  # are only used as a final fallback
  setorder(claims_dt, clm_family_id, -adjdctn_dt, na.last = TRUE)
  
  # All columns to backfill (everything except the grouping key and the flag)
  cols <- setdiff(names(claims_dt), c("clm_family_id", "is_latest"))
  
  claims_dt[, (cols) := {
    # Capture the flag for this group so the function below can use it
    flag <- is_latest
    lapply(.SD, function(x) {
      # In the flagged row, replace an NA with the first non-NA value in this
      # family (the most recent one, given the sort). If the whole column is NA
      # for the family, this gives NA and the cell stays NA.
      x[flag & is.na(x)] <- x[!is.na(x)][1]
      x
    })
  }, by = clm_family_id, .SDcols = cols]
  
  claims_dt <- claims_dt[is_latest == TRUE]
  
  return(claims_dt)
  
}