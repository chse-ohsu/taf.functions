#' Name: get_icd10_codes_for_opioid_use_disorder
#' 
#' Description: 
#' @return
#' @export
get_icd10_codes_for_opioid_use_disorder <- function(){
  return(list(
    opioid_related_disorders='F11',
    opioid_abuse='F11.1',
    uncomplicated='F11.10',
    in_remission='F11.11',
    with_intoxication='F11.12',
    with_intoxication_uncomplicated='F11.120',
    with_intoxication_delirium='F11.121',
    with_intoxication_with_perpetual_disturbance='F11.122',
    with_intoxication_unspecified='F11.129',
    with_withdrawal='F11.13',
    with_opioid_induced_mood_disorder='F11.14',
    with_opioid_induced_psychotic_disorder='F11.15',
    with_opioid_induced_psychotic_disorder_with_delusions='F11.150',
    with_opioid_induced_psychotic_disorder_with_hallucinations='F11.151',
    with_opioid_induced_psychotic_disorder_unspecified='F11.159',
    with_other_opioid_induced_disorder='F11.18',
    with_other_opioid_induced_disorder_with_opioid_induced_sexual_dysfunction='F11.181',
    with_other_opioid_induced_disorder_with_opioid_induced_sleep_disorder='F11.182',
    with_other_opioid_induced_disorder_with_other_opioid_induced_disorder='F11.188',
    with_unspecified_opioid_induced_disorder='F11.19',
    opioid_dependence='F11.2',
    uncomplicated='F11.20',
    in_remission='F11.21',
    with_intoxication='F11.22',
    uncomplicated='F11.220',
    delirium='F11.221',
    with_perceptual_disturbance='F11.222',
    unspecified='F11.229',
    with_withdrawal='F11.23',
    with_opioid_induced_mood_disorder='F11.24',
    with_opioid_induced_psychotic_disorder='F11.25',
    with_delusions='F11.250',
    with_hallucinations='F11.251',
    unspecified='F11.259',
    with_other_opioid_induced_disorder='F11.28',
    with_opioid_induced_sexual_dysfunction='F11.281',
    with_opioid_induced_sleep_disorder='F11.282',
    with_other_opioid_induced_disorder='F11.288',
    with_unspecified_opioid_induced_disorder='F11.29',
    opioid_use_unspecified='F11.9',
    uncomplicated='F11.90',
    in_remission='F11.91',
    with_intoxication='F11.92',
    uncomplicated='F11.920',
    delirium='F11.921',
    with_perceptual_disturbance='F11.922',
    unspecified='F11.929',
    with_withdrawal='F11.93',
    with_opioid_induced_mood_disorder='F11.94',
    with_opioid_induced_psychotic_disorder='F11.95',
    with_delusions='F11.950',
    with_hallucinations='F11.951',
    unspecified='F11.959',
    with_other_specified_opioid_induced_disorder='F11.98',
    with_opioid_induced_sexual_dysfunction='F11.981',
    with_opioid_induced_sleep_disorder='F11.982',
    with_other_opioid_induced_disorder='F11.988',
    with_unspecified_opioid_induced_disorder='F11.99'
  ))
}



#' Name: get_icd9_codes_for_opioid_use_disorder
#' 
#' Description: 
#' @return
#' @export
get_icd9_codes_for_opioid_use_disorder <- function(){
  return(list(
    opioid_type_dependence='304.0',
    opioid_type_dependence_unspecified='304.00',
    opioid_type_dependence_continuous='304.01',
    opioid_type_dependence_episodic='304.02',
    opioid_type_dependence_in_remission='304.03',
    nondependent_opioid_abuse='305.5', 
    opioid_abuse_unspecified='305.50',
    opioid_abuse_continuous='305.51',
    opioid_abuse_episodic='305.52', 
    opioid_abuse_in_remission='305.53'
  ))
}



#' Name: get_icd_codes_for_opioid_use_disorder
#' 
#' Description: 
#' @return
#' @export
get_icd_codes_for_opioid_use_disorder <- function(){
  return(list(
    opioid_type_dependence='304.0',
    opioid_type_dependence_unspecified='304.00',
    opioid_type_dependence_continuous='304.01',
    opioid_type_dependence_episodic='304.02',
    opioid_type_dependence_in_remission='304.03',
    nondependent_opioid_abuse='305.5', 
    opioid_abuse_unspecified='305.50',
    opioid_abuse_continuous='305.51',
    opioid_abuse_episodic='305.52', 
    opioid_abuse_in_remission='305.53',
    opioid_related_disorders='F11',
    opioid_abuse='F11.1',
    uncomplicated='F11.10',
    in_remission='F11.11',
    with_intoxication='F11.12',
    with_intoxication_uncomplicated='F11.120',
    with_intoxication_delirium='F11.121',
    with_intoxication_with_perpetual_disturbance='F11.122',
    with_intoxication_unspecified='F11.129',
    with_withdrawal='F11.13',
    with_opioid_induced_mood_disorder='F11.14',
    with_opioid_induced_psychotic_disorder='F11.15',
    with_opioid_induced_psychotic_disorder_with_delusions='F11.150',
    with_opioid_induced_psychotic_disorder_with_hallucinations='F11.151',
    with_opioid_induced_psychotic_disorder_unspecified='F11.159',
    with_other_opioid_induced_disorder='F11.18',
    with_other_opioid_induced_disorder_with_opioid_induced_sexual_dysfunction='F11.181',
    with_other_opioid_induced_disorder_with_opioid_induced_sleep_disorder='F11.182',
    with_other_opioid_induced_disorder_with_other_opioid_induced_disorder='F11.188',
    with_unspecified_opioid_induced_disorder='F11.19',
    opioid_dependence='F11.2',
    uncomplicated='F11.20',
    in_remission='F11.21',
    with_intoxication='F11.22',
    uncomplicated='F11.220',
    delirium='F11.221',
    with_perceptual_disturbance='F11.222',
    unspecified='F11.229',
    with_withdrawal='F11.23',
    with_opioid_induced_mood_disorder='F11.24',
    with_opioid_induced_psychotic_disorder='F11.25',
    with_delusions='F11.250',
    with_hallucinations='F11.251',
    unspecified='F11.259',
    with_other_opioid_induced_disorder='F11.28',
    with_opioid_induced_sexual_dysfunction='F11.281',
    with_opioid_induced_sleep_disorder='F11.282',
    with_other_opioid_induced_disorder='F11.288',
    with_unspecified_opioid_induced_disorder='F11.29',
    opioid_use_unspecified='F11.9',
    uncomplicated='F11.90',
    in_remission='F11.91',
    with_intoxication='F11.92',
    uncomplicated='F11.920',
    delirium='F11.921',
    with_perceptual_disturbance='F11.922',
    unspecified='F11.929',
    with_withdrawal='F11.93',
    with_opioid_induced_mood_disorder='F11.94',
    with_opioid_induced_psychotic_disorder='F11.95',
    with_delusions='F11.950',
    with_hallucinations='F11.951',
    unspecified='F11.959',
    with_other_specified_opioid_induced_disorder='F11.98',
    with_opioid_induced_sexual_dysfunction='F11.981',
    with_opioid_induced_sleep_disorder='F11.982',
    with_other_opioid_induced_disorder='F11.988',
    with_unspecified_opioid_induced_disorder='F11.99'
  ))
}
