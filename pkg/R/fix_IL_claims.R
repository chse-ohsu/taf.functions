#Created by Conor, 9-28-26
#Code reviewed by Sara, 9-29-26

#' # Collapses the IL claims data - which differs from that of other states -
# to the most recent version within the claim family, per resdac instructions.
# Before doing so, it fills any NA values with non-NA values from earlier versions within the family. 

#' @param claims_dt A data table containing TAF claims with at least the fields
#' 'state_cd', 'clm_type_cd', 'clm_num_adj', 'clm_num_orig', and 'adjdctn_dt'
#' @author Conor Hennessy
#' @keywords ~Illinois ~Claims ~TAF
#' @examples
#' il_dt_fixed <- fix_il_claims(il_dt)
#'
#' @export append_file

fix_il_claims <- function(claims_dt){
  if (length(missing_cols <- setdiff(c('state_cd', 'clm_type_cd', 'clm_num_adj', 'clm_num_orig', 'adjdctn_dt'), names(claims_dt)))){
    stop("Missing column(s): ", paste(missing_cols, collapse = ", "))
  }
  claims_dt_not_il <- claims_dt[!claims_dt$state_cd == "IL",]
  
  claims_dt <- claims_dt[claims_dt$state_cd == "IL",]
  
  #create claim family ID based on resdac guidance
  claims_dt$clm_family_id <- ifelse(claims_dt$clm_type_cd %in% c('4', 'D', 'X',  'Y'), claims_dt$clm_num_adj, claims_dt$clm_num_orig)
  
  
  #add a count of claims per family, to determine which families need fixing
  claims_dt[ , n_claims := .N, by = clm_family_id]
  #separate out claims that need fixing from claims ok as is, to make the rest of the function faster
  claims_ok <- claims_dt[n_claims == 1]
  claims_dt <- claims_dt[n_claims > 1]
  
  if (nrow(claims_dt) > 0){
    #drop count var
    claims_ok$n_claims <- NULL
    claims_dt$n_claims <- NULL
    
    #flag most recent claim for each family
    #claims_dt[, is_latest := adjdctn_dt == max(adjdctn_dt), by = clm_family_id]
    claims_dt[, latest_dt := max(adjdctn_dt), by = clm_family_id]
    claims_dt[, is_latest := adjdctn_dt == latest_dt ]
    claims_dt$latest_dt <- NULL
    
    # Sort each family newest to oldest; rows with missing dates go last so they
    # are only used as a final fallback
    setorder(claims_dt, clm_family_id, -adjdctn_dt, na.last = TRUE)
    
    # All columns to backfill (everything except the grouping key and the flag)
    
    # Amount columns get summed across the family instead of backfilled
    amt_cols <- grep("_amt$", names(claims_dt), value = TRUE) #NEW
    
    # All columns to backfill (everything except the grouping key, the flag, and amounts)
    cols <- setdiff(names(claims_dt), c("clm_family_id", "is_latest", amt_cols)) #NEW
    
    #Fill NAs. Note: in 2022 shard 0, this didn't fill anything. Other years may differ.
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
    
    # Sum amount columns over all claims in the family
    claims_dt[, (amt_cols) := lapply(.SD, sum, na.rm = TRUE), by = clm_family_id, .SDcols = amt_cols] #NEW
    
    
    #limit to latest date
    claims_dt <- claims_dt[is_latest == TRUE]
    
    #deduplicate among claims with latest date. No way to know which is correct, so drop at random. 
    claims_dt <- unique(claims_dt, by = "clm_family_id")
  }
  
  # recombine ok claims and not ok claims
  claims_dt <- rbind(claims_dt, claims_ok, fill=T)
  claims_dt <- rbind(claims_dt, claims_dt_not_il, fill=T)
  
  return(claims_dt)
  
}