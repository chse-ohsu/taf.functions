file_type='taf_demog_elig_mny_flw_prsn'
year=2019
state='TN'
shard='all'
target_directory = "/home/groups/chse_tmsis/Shard_TMSIS/"
cols = "all"
valid_file_types <- c("taf_demog_elig_base", "taf_demog_elig_dates", 
                        "taf_demog_elig_disability", "taf_demog_elig_hh_spo", 
                        "taf_demog_elig_mngd_care", "taf_demog_elig_mny_flw_prsn", 
                        "taf_demog_elig_waiver", "taf_rx_header", "taf_rx_line", 
                        "taf_inpatient_header", "taf_inpatient_line", "taf_inpatient_occurrence", 
                        "taf_long_term_header", "taf_long_term_line", "taf_long_term_occurrence", 
                        "taf_other_services_header", "taf_other_services_line", 
                        "taf_other_services_occurrence", "taf_mngd_care_plan_srvc_area", 
                        "taf_mngd_care_plan_oprtg_auth", "taf_mngd_care_plan_location", 
                        "taf_mngd_care_plan_base", "taf_mngd_care_plan_enrol_pop", 
                        "taf_prvdr_taxonomy", "taf_prvdr_location", "taf_prvdr_identifiers", 
                        "taf_prvdr_enrollment", "taf_prvdr_bed_type", "taf_prvdr_base", 
                        "taf_prvdr_afltd_pgms", "taf_prvdr_afltd_grps", "taf_prvdr_license")
valid_shards <- c("all", "0", "1", "2", "3", "4", "5", "6", 
                    "7", "8", "9", "A", "B", "C", "D", "E", "F")
valid_years <- c("all", "2014", "2015", "2016", "2017", "2018", 
                   "2019", "2020")
valid_states <- c("all", "AK", "AL", "AR", "AZ", "CA", "CO", 
                    "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", 
                    "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", 
                    "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", 
                    "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", 
                    "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", 
                    "WV", "WY")
if (missing(file_type)) {
    stop("Please input file_type. Existing file types are listed in ?get_taf")
}else if (!file_type %in% valid_file_types) {
    stop("Please input file_type. Existing file types are listed in ?get_taf")
}
  
if (missing(year)) {
    stop("Please input one or more years or set to \"all\"\n      Example: year=2016, year=c(2017, 2018), year=\"all\"")
}else if (!year[1] %in% valid_years) {
    stop("Please input one or more years or set to \"all\"\n      Example: year=2016, year=c(2017, 2018), year=\"all\"")
}
  
if (missing(state)) {
    stop("Please input one or more states or set to \"all\"\n      Example: state=\"WY\", state=c(\"WY\",\"VT\"), state=\"all\"")
} else if (!state[1] %in% valid_states) {
    stop("Please input one or more states or set to \"all\"\n      Example: state=\"WY\", state=c(\"WY\",\"VT\"), state=\"all\"")
}
  
if (grepl("taf_mngd_care_plan", file_type) | grepl("taf_prvdr", 
                                                     file_type)) {
    shard <- "all"
}
  
if (missing(shard)) {
    stop("Please input one shard or set to \"all\".\n      Existing shards: 0-9 and A-F.\n      Example: shard=\"0\", shard=\"F\", shard=\"all\"")
}else if (!shard %in% valid_shards) {
    stop("Please input one shard or set to \"all\".\n      Existing shards: 0-9 and A-F.\n      Example: shard=\"0\", shard=\"F\", shard=\"all\"")
}
  
if (grepl("Chunk_Data_ID", target_directory)) {
    year <- "all"
    message("Data years 2014, 2015, and 2016 are always pulled when using the Chunk_Data_ID target directory.")
}

z_all_files <- data.table::fread(paste0(target_directory, 
                                          "z_hashes_tools/all_files_control_totals.txt"), sep = "|", 
                                   header = FALSE)

z_all_files <- z_all_files[[1]]
keep_files <- z_all_files[grepl(paste(file_type, collapse = "|"), 
                                  z_all_files)]
if (!"all" %in% year) {
    keep_files <- keep_files[grepl(paste(year, collapse = "|"), 
                                   keep_files)]
}
if (!"all" %in% state) {
    keep_files <- keep_files[grepl(paste(state, collapse = "|"), 
                                   keep_files)]
}
if (!"all" %in% shard) {
    keep_files <- keep_files[grepl(paste0("_", shard, ".gz"), 
                                   keep_files)]
}

schema <- get_schema(file_type, target_directory)
if (!"all" %in% cols) {
    combined_tables <- data.table::rbindlist(lapply(keep_files, 
                                                    function(x) data.table::fread(paste0(target_directory, 
                                                                                         x), na.strings = c("", NA, NULL), select = cols, 
                                                                                  colClasses = schema)), fill = TRUE)
} else {
    combined_tables <- data.table::rbindlist(lapply(keep_files, 
                                                    function(x) data.table::fread(paste0(target_directory, 
                                                                                         x), na.strings = c("", NA, NULL), colClasses = schema)), 
                                             fill = TRUE)
}

head(combined_tables)
