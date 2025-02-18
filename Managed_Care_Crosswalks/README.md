The purpose of the managed care crosswalks is to allow TAF data users to merge 
TAF managed care data with data on managed care from the Kaiser Family 
Foundation (KFF) and the Center for Medicare and Medicaid Services (CMS). 


https://www.kff.org/other/state-indicator/medicaid-enrollment-by-mco/?currentTimeframe=0&sortModel=%7B%22colId%22:%22State%22,%22sort%22:%22asc%22%7D
https://data.medicaid.gov/dataset/0bef7b8a-c663-5b14-9a46-0b5c2b86b0fe/data?conditions[0][resource]=t&conditions[0][property]=year&conditions[0][value]=2014&conditions[0][operator]=%3D

Currently, we are unsure if we are allowed to post the mc_plan_id numbers from
TAF on this public GitHub. As such, the crosswalks are currently published here
sans-mc_plan_id. We have asked ResDac if we can do this, and they have said they 
will consider our request and get back to us.

However, for those with access to the TAF Managed Care (APL) data - specifically
the 'taf_mngd_care_plan_base' files for 2017-2021 should still be able to use the
crosswalks by ordering the mc_plan_ids in those files in the same order we have
ordered the rows of the crosswalk. The 'add_taf_mc_plan_id_to_crosswalk.R' function
in this repository will do that for you.

To use this function to obtain the crosswalks with mc_plan_ids, clone this 
repository and set your working directory to the 'taf.functions' repository folder. 
Then read in your TAF APL data for all states + DC and Puerto Rico. Next read in 
the crosswalks for the year you desire as it appears in this repository. Lastly,
call the add_taf_mc_plan_id_to_crosswalk() function with the APL data and 
crosswalk as input, and your output should be the crosswalk with mc_plan_id
numbers included.

For example:

#read in APL data
#how you read in this data will differ by institution
2021_apl_data <- readRDS('/path/to/my/2021/taf/APL/data.RDS')

#read in the crosswalk with no ideas in this repository 
2021_crosswalk_no_ids <- read.csv('Managed_Care_Crosswalks/2021_Crosswalk.csv')

# obtain IDs by ordering IDs in your APL data in an order that correctly corresponds
# to the order of the rows in the crosswalk
2021_crosswalk_WITH_ids <- add_taf_mc_plan_id_to_crosswalk(
  crosswalk=2021_crosswalk_no_ids, 
  taf_mngd_care_plan_base_all_states=2021_apl_data, 
  year=2021)
  
  
If you have trouble implementing this, or you cannot use R and prefer to run this
in a different programming language, or have other ideas on how we can share the
crosswalks including mc_plan_ids, please feel free to contact me at hennessc@ohsu.edu