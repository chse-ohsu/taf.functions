#!/bin/env Rscript
task_id <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
library(data.table)

states <- list.dirs('/home/groups/chse_tmsis/Tools_Resources/taf_claims_data_for_qm', recursive=F, full.names=F)
states <- states[!states %like% 'results']
states <- states[!states %in% c('NY', 'TX', 'FL', 'CA', 'OH', 'NC', 'PA')]
file_types <- c('claims.csv',  'cont_en_lu.csv',  'member_months.csv',  'mem_detail.csv',  'rx.csv')

for (file_type in file_types){
  message("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  message(file_type)
  message(state)
  test <- fread(file.path('/home/groups/chse_tmsis/Tools_Resources/taf_claims_data_for_qm', state, file_type))
  years <- unique(test$year)
  years <- years[order(years)]
  stopifnot(years == 2017:2023)
}

print('finished')