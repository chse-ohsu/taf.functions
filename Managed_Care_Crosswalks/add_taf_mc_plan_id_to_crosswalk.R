add_taf_mc_plan_id_to_crosswalk <- function(crosswalk, taf_mngd_care_plan_base_all_states, year){
  #subset to columns of interest
  taf_mngd_care_plan_base_all_states <- unique(taf_mngd_care_plan_base_all_states[, c('state_cd', 'mc_plan_id')])
  
  #remove rows without state or mc_plan_id - did not use such rows for the crosswalks
  taf_mngd_care_plan_base_all_states <- taf_mngd_care_plan_base_all_states[!is.na(taf_mngd_care_plan_base_all_states$mc_plan_id) &
                                                                             !is.na(taf_mngd_care_plan_base_all_states$state_cd),]
  
  #prefix asterisk to ID for consistency with the crosswalk
  taf_mngd_care_plan_base_all_states$mc_plan_id <- paste0("*", taf_mngd_care_plan_base_all_states$mc_plan_id)
  
  #order in the same way the crosswalk is ordered
  taf_mngd_care_plan_base_all_states <- taf_mngd_care_plan_base_all_states[order(taf_mngd_care_plan_base_all_states$state_cd, taf_mngd_care_plan_base_all_states$mc_plan_id)]

  # add NAs and repeated mc_plan_ids to match the crosswalk as necessary
  # the special rows data denotes which rows in the crosswalks have repeated
  # TAF mc_plan_ids or rows where TAF mc_plan_id is missing due to the CMS plan 
  # being unmatched to any TAF plan
  special_rows <- read.csv(paste0('Managed_Care_Crosswalks/', year, '_special_rows.csv'))

  for (i in 1:(nrow(taf_mngd_care_plan_base_all_states) + nrow(special_rows))){
    if (i %in% special_rows$rownums){
      print(i)
      if (special_rows$type[special_rows$rownums == i] == "na_mc_plan_id_rows"){
        
        new_row <- data.frame(mc_plan_id = NA, state_cd = taf_mngd_care_plan_base_all_states$state_cd[i-1])
        
        # if i < ... bc we must handle the edge cases where i == nrow (possible if the last row is special)
        if (i < nrow(taf_mngd_care_plan_base_all_states)){
          taf_mngd_care_plan_base_all_states <- rbind(
            taf_mngd_care_plan_base_all_states[1:i-1],
            new_row,
            taf_mngd_care_plan_base_all_states[i:nrow(taf_mngd_care_plan_base_all_states),])
        } else{
          taf_mngd_care_plan_base_all_states <- rbind(
            taf_mngd_care_plan_base_all_states[1:i-1],
            new_row)
        }
          
          
      } else{
        
        new_row <- data.frame(mc_plan_id = taf_mngd_care_plan_base_all_states$mc_plan_id[i-1], state_cd = taf_mngd_care_plan_base_all_states$state_cd[i-1])
        
        taf_mngd_care_plan_base_all_states <- rbind(
          taf_mngd_care_plan_base_all_states[1:i-1],
          new_row,
          taf_mngd_care_plan_base_all_states[i:nrow(taf_mngd_care_plan_base_all_states),])
        
      }
    }
  }

  #change name to prefix 'taf' for consistency with other xwalk cols
  taf_mngd_care_plan_base_all_states$taf_mc_plan_id <- taf_mngd_care_plan_base_all_states$mc_plan_id

  #add to crosswalk
  crosswalk <- cbind(crosswalk, taf_mngd_care_plan_base_all_states$taf_mc_plan_id)

  return(crosswalk)
}

taf_mngd_care_plan_base_all_states <- chse::get_taf(
  file_type = 'taf_mngd_care_plan_base',
  state='all',
  year=2017
)
year <- 2017
crosswalk <- read.csv('Managed_Care_Crosswalks/2017_Crosswalk.csv')
crosswalk_w_ids <- add_taf_mc_plan_id_to_crosswalk(crosswalk, taf_mngd_care_plan_base_all_states, year)
